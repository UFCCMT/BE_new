"""
  Interpolation-related defitions, as part of scalable simulator.

    Copyright (C) 2015 {NSF CHREC, UF CCMT, Dylan Rudolph}

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

# Attempt to use the faster cPickle library.
try: import cPickle as pickle
except: import pickle

import csv
import datetime
from copy import deepcopy
import numpy as np
from scipy import spatial
from scipy import interpolate as spi

# Avoiding unwieldy import; but everything from common is in UPPERCASE.
from common import *


class Librarian(object):

    def __init__(self, scheme=DEFAULT_INTERPOLATION_SCHEME,
                 options=DEFAULT_INTERPOLATION_OPTIONS):
        """The Librarian manages interpolators and samples."""

        # 'cache' has keys: ("filename", (inputs,)) and values: [outputs].
        self.cache = {}

        # 'interpolators' has keys: "filename" and values [interpolator]
        self.interpolators = {}

        self.scheme = scheme
        self.options = options

    def newInterpolator(self, samples):
        """Create a new interpolator from some samples based on our scheme."""

        if self.scheme == NEAREST:
            return Nearest(samples)

        elif self.scheme == LINEAR:
            return Linear(samples)

        else:
            raise NameError(ERR_INTERPOLATION_SCHEME.format(self.scheme))

        # See note at bottom of non-commented portion of file.

        """
        elif self.scheme == RBF:
            return Rbf(samples, self.options[RBF][FUNCTION])

        elif self.scheme == KRIGING:
            return Kriging(samples, self.options[KRIGING][POLYNOMIAL],
                           self.options[KRIGING][NEIGHBORS],
                           self.options[KRIGING][VARIOGRAM])
        """

    def lookup(self, filename, inputs):
        """Determine the outputs for a given filename and inputs."""

        # If we've already cached this input:
        if (filename, tuple(inputs)) in self.cache:

            # Just return the cached entry.
            return self.cache[ (filename, tuple(inputs)) ]

        # Otherwise, if we have already opened this file:
        elif filename in self.interpolators:

            # Perform the interpolation.
            outputs = [ interp.interpolate(inputs)[0] for interp in
                        self.interpolators[filename] ]

            # Add the new entry to the cache.
            self.cache[ (filename, tuple(inputs)) ] = outputs

            # Return the new entry.
            return outputs

        # Otherwise, if we haven't seen this filename before:
        else:

            # Load the file.
            self.interpolators[filename] = self.load(filename)

            # Re-call lookup with the same parameters.
            return self.lookup(filename, inputs)

    def load(self, filename):
        """Load a .csv file and return all of its data as an interpolator."""

        # Create a reader-generator for the file name.
        reader = csv.reader(open(filename, 'rb'))

        # Grab the metadata, but (as of this writing) don't use it.
        metadata = dict(zip(reader.next(), reader.next()))

        # Skip rows until we get to the real data.
        line = reader.next()
        while (INPUT_LOOKUP_HEADER not in line
               and INPUT_LOOKUP_HEADER.lower() not in line):
            line = reader.next()

        # Determine which columns are inputs and which are outputs.
        icols = [c for c in range(len(line)) if line[c]==INPUT_LOOKUP_HEADER]
        ocols = [c for c in range(len(line)) if line[c]==OUTPUT_LOOKUP_HEADER]

        # Skip a line, this should contain the names of the parameters.
        reader.next()

        # Intitialize the point and value lists.
        points, values, = [], []

        # For each remaining row:
        for row in reader:

            # Add a point with the entry from each input/output column.
            points.append( [eval( row[col] ) for col in icols] )
            values.append( [eval( row[col] ) for col in ocols] )

        # Create sets of samples, one for each output, with the same inputs.
        sampleSets = [Samples(points, [[i] for i in v]) for v in zip(*values)]

        # Create an interpolator for each set of samples:
        return [ self.newInterpolator(samples) for samples in sampleSets ]


class Samples(object):

    def __init__(self, points, values):
        """Samples contain independent and dependent parameters."""
        self.points = deepcopy(points)
        self.values = deepcopy(values)
        self.dimension = len(self.points[0])
        self.build()

    def build(self):
        """Create a scipy KDTree from the points."""
        self.kdtree = spatial.KDTree(self.points)

    def append(self, point, value):
        """Include a new point and value."""
        self.points.append(deepcopy(point))
        self.values.append(deepcopy(value))
        self.build()

    def remove(self, point):
        """Remove a point from the samples, if it exists."""
        if point in self.points:
            i = self.points.index(point)
            self.points.pop(i)
            self.values.pop(i)
            self.build()

    def nearest(self, location, count):
        """Return the nearest 'count' points and values from 'location'."""
        distances, indices = self.kdtree.query(location, k=count)
        points = [self.points[i] for i in list(indices)]
        values = [self.values[i] for i in list(indices)]
        return points, values, list(distances)

    def extract(self, points):
        """Return a point-indexed subset of the samples."""
        newvalues = []
        for point in points:
            newvalues.append(self.values[self.points.index(point)])
        return Samples(points, newvalues)

    def subsample(self, stride, edge=None):
        """Return a subset of the samples, only works for square datasets."""

        newpoints, newvalues = [], []

        e = edge if edge else len(self.points)
        indices = range(len(self.points))

        for m, c in [(stride * (e**i), e**i) for i in range(self.dimension)]:
            indices = filter(lambda x: (x % m) < c, indices)

        for i in indices:
            newpoints.append(self.points[i])
            newvalues.append(self.values[i])

        return Samples(newpoints, newvalues)


class Nearest(object):

    def __init__(self, samples):
        """Nearest is the nearest-neighbor interpolation method."""

        # If this is multi-dimensional interpolation:
        if len(samples.points[0]) > 1:
            self.interp = spi.NearestNDInterpolator( np.array(samples.points),
                                                     np.array(samples.values) )

        else: # If there is just one input dimension:
            self.interp = spi.interp1d( zip(*samples.points)[0],
                                        zip(*samples.values)[0],
                                        fill_value=0.0, kind=NEAREST )

        self.interpolate = lambda p: [float(v) for v in self.interp(p)]


class Linear(object):

    def __init__(self, samples):
        """Linear is the linear interpolation method."""

        # If this is multi-dimensional interpolation:
        if len(samples.points[0]) > 1:
            self.interp = spi.LinearNDInterpolator( np.array(samples.points),
                                                    np.array(samples.values),
                                                    fill_value=0.0 )

        else: # If there is just one input dimension:
            self.interp = spi.interp1d( zip(*samples.points)[0],
                                        zip(*samples.values)[0],
                                        fill_value=0.0, kind=LINEAR)

        self.interpolate = lambda p: [float(v) for v in self.interp(p)]


if __name__ == "__main__":

    # Perform tests on a few files to make sure things roughly work:

    I = Librarian(scheme="nearest")

    print I.lookup("lookup/fft-dummy.csv", [100, 100])[0]
    print I.lookup("lookup/fft-dummy.csv", [100, 100])[0]
    print I.lookup("lookup/fft-dummy.csv", [99, 10])[0]
    print I.lookup("lookup/transfer-dummy-A.csv", [999])[0]
    print I.lookup("lookup/transfer-dummy-A.csv", [10])[0]

    I = Librarian(scheme="linear")

    print I.lookup("lookup/transfer-dummy-B.csv", [79])[0]
    print I.lookup("lookup/transfer-dummy-B.csv", [10])[0]


# Note from Dylan concerning Kriging and RBF:
#
# These probably do not work as-is, but have been tested and are known to
# work in general. They'll be included when the need arises, but for now
# (because they are written as strictly mult-dimensional interpolation methods,
# and would need to be adapted to also do one-dimensional interpolation)
# they are commented out.

"""
class Kriging(object):

    def __init__(self, samples, polynomial, neighbors, variogram):
        self.samples = samples
        self.polynomial = polynomial
        self.variogram = variogram
        self.neighbors = neighbors

    def distances(self, points):
        "Produce a matrix of distances between a set of points.

        If there were three elements in 'points', 'dists' would be:

              ____a_______b______c___
            a| D(a,a)  D(a,b)  D(a,c)
            b| D(b,a)  D(b,b)  D(b,c)
            c| D(c,a)  D(c,b)  D(c,c)

        where D(a, b) is the distance between 'a' and 'b', and the diagonal
        elements are then all zero.
        "

        # 'dim' states the dimensions for the numpy.tile function.
        dim = tuple([len(points), 1])
        dists = [np.tile(np.array( zip(*points)[i] ), dim)
                 for i in range(self.samples.dimension)]
        dists = np.power(dists - np.transpose(dists, (0, 2, 1)), 2)
        dists = np.sqrt(np.sum(dists, axis=0))

        return dists

    def variograms(self, dists):
        "Evaluate the variogram at a set of distances."

        n = self.variogram["nugget"] if "nugget" in self.variogram else 0.0
        s = self.variogram["sill"] if "sill" in self.variogram else 1.0
        r = self.variogram["range"]

        if self.variogram["type"] in ["exponential", "exp"]:
            variogram = (s - n) * (1 - np.exp(-1 * (3 * dists / r))) + n
        elif self.variogram["type"] in ["spherical", "sphere"]:
            a = ( (3 * dists) / (2 * r) - (dists**3) / (2 * r**3) )
            variogram = (s - n) * (a * (dists <= r) + (r < dists)) + n
        elif self.variogram["type"] in ["gaussian", "gauss"]:
            variogram = (s - n) * (1 - np.exp(-1 * (3 * dists**2 / r**2) )) + n

        return variogram

    def interpolate(self, points):
        "Perform the Kriging interpolation for each of the points.

        The H and V matrices are part of a matrix which is to be inverted to
        determine the weights for the linear estimator. The contents of h
        and v are dependent on the order of the underlying polynomialnomial in
        the estimation region. The weights are calculated as:
                 ____________________        ___
                |              |     | -1   |   |
                |              |     |      |   |
                |       G      |     |      |   |
                |              |     |   *  | g |
            W = |______________|  V  |      |   |
                |              |     |      |   |
                |       H      |     |      |   |
                |______________|_____|      |___|

        where the large matrix to be inverted is 'G' and 'g' is:

                |  v( d(point, nearest[0]) )  |
                |  v( d(point, nearest[1]) )  |
            g = |            ...              |
                | v( d(point, nearest[k-2]) ) |
                | v( d(point, nearest[k-1]) ) |

        and v(d) is a variogram function and d(a,b) is a distance function.
        "

        estimates = []
        variances = []

        dim = self.samples.dimension

        for index, point in enumerate(points):

            nearest, values, d = self.samples.nearest(point, self.neighbors)

            nearest.insert(0, point)
            D = self.distances(nearest)
            G = self.variograms(D)

            if self.polynomial == 0:
                H = np.ones((1, len(nearest)))
                V = np.transpose(np.append(H, np.zeros((1,1)), axis=1))
            elif self.polynomial == 1:
                ones = np.array([np.ones(len(nearest))])
                H = np.append(np.array(nearest).T, ones, axis=0)
                V = np.transpose(np.append(H,np.zeros((dim+1, dim+1)),axis=1))

            L = np.delete(np.append(np.append(G,H,axis=0),V,axis=1),(0),axis=1)
            g = L[0]
            L = np.delete(L, (0), axis=0)

            W = np.dot(np.linalg.inv(L), np.transpose(g))

            estimates.append(np.dot(W[0:self.neighbors], values))
            variances.append(np.dot(W, g))

        return estimates



class Rbf(object):

    def __init__(self, samples, function='linear'):
        spoints = [list(item) for item in zip(*samples.points)]
        spoints.append(samples.values)
        self.interp = spi.Rbf(*(spoints), function=function)

        self.interpolate = lambda p: self.interp(*([list(i) for i in zip(*p)]))

"""
