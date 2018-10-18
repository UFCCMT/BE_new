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

    def newInterpolator(self, samples, filename, degree):
        """Create a new interpolator from some samples based on our scheme."""

        if self.scheme == NEAREST:
            return Nearest(samples)

        elif self.scheme == LINEAR:
            return Linear(samples, filename)

        elif self.scheme == POLYNOMIAL:
            return Polynomial(samples, filename, degree)

        elif self.scheme == LAGRANGE:
            return Lagrange(samples, filename)

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

    def lookup(self, filename, inputs, degree):
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
            self.interpolators[filename] = self.load(filename, degree)

            # Re-call lookup with the same parameters.
            return self.lookup(filename, inputs, degree)

    def load(self, filename, degree):
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

        #def unpair(inputset):
            #level = len(inputset[0]) 

        # Create an interpolator for each set of samples:
        return [ self.newInterpolator(samples, filename, degree) for samples in sampleSets ]


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


class Lagrange(object):

    def __init__(self, samples, filename):
        """Lagrange polynomial interpolation method."""

        self.samples = samples
        self.filename = filename
        self.interpolate = lambda p: [float(self.interpolatedOP(p))]

    def polyip(self, x1, y1, x2, y2, k):

        slope = (y2-y1)/(x2-x1)
        return (y2 - (slope*(x2-k)))

    def lagrangeip(self, ip, ipset, opset):

        op = 0.0
        i = 0

        for entryO in ipset:
            s = 1.0
            t = 1.0
            j = 0

            for entryI in ipset:
                if j != i:
                    s = s*(ip-entryI)
                    t = t*(entryO-entryI)
                j = j+1

            op = op + ((s/t)*opset[i])
            i = i+1

        if (op < 0) or (op > opset[len(opset)-1] or op < opset[0]):
            print "Warning---Lagrange interpolation failed for one set in "+self.filename+". Trying linear interpolation!"
            k = 0
            for x in ipset:
                if x == ip: return opset[k]
                if x > ip : return self.polyip(ipset[k-1], opset[k-1], x, opset[k], ip)
                k = k+1
            return opset[k-1]

        else:
            return op

    def interpolatedOP(self, inputset):

        if len(inputset) != len(self.samples.points[0]): 
            raise Exception("Invalid Input set "+str(inputset));
            return 0

        j = 0
        for ip_sample in self.samples.points:
            if tuple(inputset) == tuple(ip_sample): return self.samples.values[j][0]
            j = j+1

        level = len(inputset)-1
        curr_level_op = [float(v[0]) for v in self.samples.values]
        first_level_ip = []

        if level == 0: 
            for inputval in self.samples.points:
                first_level_ip.append(float(inputval[0]))

        while level > 0:
            
            i = 0
            next_level_op = []
            parent = self.samples.points[0][level-1]
            if level == 1: first_level_ip.append(float(parent))
            iplist = []
            oplist = []

            for sampleip in self.samples.points:
                if sampleip[level-1] == parent:
                    iplist.append(float(sampleip[level]))
                    oplist.append(float(curr_level_op[i]))
                else:
                    next_level_op.append(self.lagrangeip(float(inputset[level]), iplist, oplist))
                    parent = sampleip[level-1]
                    iplist = [float(sampleip[level])]
                    oplist = [float(curr_level_op[i])]
                    if level == 1: first_level_ip.append(float(parent))
     
                i = i+1

            next_level_op.append(self.lagrangeip(float(inputset[level]), iplist, oplist))
            curr_level_op = next_level_op
            level = level-1

        return self.lagrangeip(float(inputset[level]), first_level_ip, curr_level_op)


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


class Polynomial(object):

    def __init__(self, samples, filename, degree):
        """Polynomial is the polynomial interpolation method."""

        self.samples  = samples
        self.filename = filename
        self.degree   = degree
        """        
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
        """
        self.interpolate = lambda p: [float(self.interpolatedOP(p))]

    def polyip(self, x1, y1, x2, y2, k):

        d = self.degree
        slope = (y2-y1)/((x2**d)-(x1**d))
        return (y2 - (slope*((x2**d)-(k**d))))

    def fetchValue(self, level, parent, inputset, samples, index, value_pos):

        if len(inputset) == 0: return self.samples.values[value_pos][0]

        offset = 0

        for sampleip in samples:

            if parent == sampleip[level-1] and sampleip[level] == inputset[0]:
                return self.fetchValue(level+1, sampleip[level], inputset[1:], samples[offset:], index+offset, index+offset)

            elif parent == sampleip[level-1] and sampleip[level] > inputset[0]:
                opl = self.fetchValue(level+1, samples[offset-1][level], inputset[1:], samples[0:offset], 0, index+offset-1)
                opn = self.fetchValue(level+1, sampleip[level], inputset[1:], samples[offset:], index+offset, index+offset)
                return self.polyip(samples[offset-1][level], opl, sampleip[level], opn, inputset[0])

            elif parent >= sampleip[level-1]:
                offset = offset+1

        return self.samples.values[value_pos+offset-1][0]    

    def interpolatedOP(self, inputset):

        if len(inputset) != len(self.samples.points[0]): 
            raise Exception("Invalid Input set "+str(inputset));
            return 0

        index = 0

        for sampleip in self.samples.points:

            if sampleip == inputset: return self.samples.values[index][0]

            if sampleip[0] == inputset[0]:
                return self.fetchValue(1, sampleip[0], inputset[1:], self.samples.points[index:], index, index)

            elif sampleip[0] > inputset[0]:
                opl = self.fetchValue(1, self.samples.points[index-1][0], inputset[1:], self.samples.points[0:index], 0, index-1)
                opn = self.fetchValue(1, sampleip[0], inputset[1:], self.samples.points[index:], index, index) 
                return self.polyip(self.samples.points[index-1][0], opl, sampleip[0], opn, inputset[0])

            index = index+1

        return self.samples.values[index-1][0] 


class Linear(object):

    def __init__(self, samples, filename):
        """Polynomial is the polynomial interpolation method."""

        self.samples  = samples
        self.filename = filename
        """        
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
        """
        self.interpolate = lambda p: [float(self.interpolatedOP(p))]

    def linearip(self, x1, y1, x2, y2, k):

        slope = (y2-y1)/(x2-x1)
        return (y2 - (slope*(x2-k)))

    def fetchValue(self, level, parent, inputset, samples, index, value_pos):

        if len(inputset) == 0: return self.samples.values[value_pos][0]

        offset = 0

        for sampleip in samples:

            if parent == sampleip[level-1] and sampleip[level] == inputset[0]:
                return self.fetchValue(level+1, sampleip[level], inputset[1:], samples[offset:], index+offset, index+offset)

            elif parent == sampleip[level-1] and sampleip[level] > inputset[0]:
                opl = self.fetchValue(level+1, samples[offset-1][level], inputset[1:], samples[0:offset], 0, index+offset-1)
                opn = self.fetchValue(level+1, sampleip[level], inputset[1:], samples[offset:], index+offset, index+offset)
                return self.linearip(samples[offset-1][level], opl, sampleip[level], opn, inputset[0])

            elif parent >= sampleip[level-1]:
                offset = offset+1

        return self.samples.values[value_pos+offset-1][0]    

    def interpolatedOP(self, inputset):

        if len(inputset) != len(self.samples.points[0]): 
            raise Exception("Invalid Input set "+str(inputset));
            return 0

        index = 0

        for sampleip in self.samples.points:

            if sampleip == inputset: return self.samples.values[index][0]

            if sampleip[0] == inputset[0]:
                return self.fetchValue(1, sampleip[0], inputset[1:], self.samples.points[index:], index, index)

            elif sampleip[0] > inputset[0]:
                opl = self.fetchValue(1, self.samples.points[index-1][0], inputset[1:], self.samples.points[0:index], 0, index-1)
                opn = self.fetchValue(1, sampleip[0], inputset[1:], self.samples.points[index:], index, index) 
                return self.linearip(self.samples.points[index-1][0], opl, sampleip[0], opn, inputset[0])

            index = index+1

        return self.samples.values[index-1][0]        


if __name__ == "__main__":

    # Perform tests on a few files to make sure things roughly work:

    I = Librarian(scheme="nearest")

    print I.lookup("lookup/fft-dummy.csv", [100, 100])[0]
    print I.lookup("lookup/fft-dummy.csv", [100, 100])[0]
    print I.lookup("lookup/fft-dummy.csv", [99, 10])[0]
    print I.lookup("lookup/transfer-dummy-A.csv", [999])[0]
    print I.lookup("lookup/transfer-dummy-A.csv", [10])[0]

    I = Librarian(scheme="polynomial")

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
