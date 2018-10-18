"""
  A multi-dimensional interpolation tool.

    Copyright (C) 2014 Dylan Rudolph

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

from scipy import interpolate as spinterp
import scipy.special as special
from scipy import spatial
import numpy as np
from copy import deepcopy


class Data(object):
    """
    Data is a class for storage, lookup, and sorting of multidimensional data.

    FInding a particular sample's nearest neighbors is done by building a
    KD-Tree and searching for the adjacent samples.

    Indexing or searching for one of the samples is done by specifying a list
    which contains only the ordinates (e.g., [x, y, z]).
    """

    def __init__(self):
        """ """
        self.points = []
        self.values = []

    def set_samples(self, points, values, dimensions):
        """ Define an initial sample set.
        """
        self.points = deepcopy(points)
        self.values = deepcopy(values)
        self.dimensions = dimensions
        self.build()

    def add_sample(self, point, value):
        """ Append to the sample set.
        """
        self.points.append(point)
        self.values.append(value)
        self.build()

    def build(self):
        """
        Call build_kdtree if the data are multi-dimensional, or sort_samples if
        the data are one-dimensional.
        """
        if self.dimensions == 1:
            self.sort_samples()
        else:
            self.build_kdtree()

    def build_kdtree(self):
        """
        Create a scipy kdtree for neighbor lookup when the data are more
        than one-dimensional.
        """
        self.kdtree = spatial.KDTree(self.points)

    def sort_samples(self):
        """
        Sort the 'points' (and also 'values') for neighbor lookup when
        the data are one-dimensional. Not for multi-dimensional data.
        """
        a = zip(self.points, self.values)
        b = sorted(a)
        self.points = [item[0] for item in b]
        self.values = [item[1] for item in b]

    def find(self, location):
        """ """
        index = (np.abs(np.array(self.points)-np.array(location))).argmin()
        return index

    def get_points(self, indices):
        """ Return the points associated with the list of indices.
        """
        return [self.points[i] for i in indices]

    def get_values(self, indices):
        """ Return the points associated with the list of indices.
        """
        return [self.values[i] for i in indices]

    def neighbors(self, location, count):
        """
        Returns the indicies of the 'count' nearest neighbors to the
        point 'location'
        """

        distances, indices = self.kdtree.query(location, k=count)

        return indices

    def distances(self, location, count):
        """
        Returns the distances to the 'count' nearest neighbors to the
        point 'location'
        """

        distances, indices = self.kdtree.query(location, k=count)

        return distances


class Kriging(object):

    def __init__(self, data, poly, variogram, neighbors):
        """
        'data' is an instance of a 'Data' class containing the points
        and values from which to interpolate.

        'poly' is the degree of the assumed underlying polynomial in
        the region surrounding the points to interpolate.

        'variogram' is a dictionary of parameters for the variogram.
        See the 'variogram_matrix' for an itemization of the parameters.
        """
        self.data = data
        self.poly = poly
        self.variogram = variogram
        self.neighbors = neighbors

    def distances(self, points):
        """
        Produce a matrix of distances between a set of points. For example,
        if there were three elements in 'points', 'dists' would be:

              ____a_______b______c___
            a| D(a,a)  D(a,b)  D(a,c)
            b| D(b,a)  D(b,b)  D(b,c)
            c| D(c,a)  D(c,b)  D(c,c)

        where D(a, b) is the distance between 'a' and 'b', and the diagonal
        elements are then all zero.
        """

        # 'R' is just a convenience variable.
        R = range(self.data.dimensions)

        # 'dim' states the dimensions for the numpy.tile function.
        dim = tuple([len(points), 1])
        dists = [np.tile(np.array( zip(*points)[i] ), dim) for i in R]
        dists = np.power(np.subtract(dists, np.transpose(dists, (0, 2, 1)) ), 2)
        dists = np.sqrt(np.sum(dists, axis=0))

        return dists

    def variograms(self, dists):
        """ Use the 'dists' to evaluate the variogram at those distances.
        """
        if self.variogram["type"] in ["exponential", "exp"]:
            n = self.variogram["nugget"]
            r = self.variogram["range"]
            s = self.variogram["sill"]
            var = (s - n) * (1 - np.exp(dists / -r)) + n

        return var

    def interpolate(self, points):
        """
        Perform the interpolation for each point in the 'points' list. For
        the interpolation, use the 'neighbors' nearest neighbors. The number
        of neighbors should be enough to sure that there is not a singular
        matrix inversion.

        Each element of 'points' should be a list of the same dimensionality
        of the data. E.g., for three-dimensional data: [x, y, z].

        This function returns a list of estimates, one for each point, along
        with the estimated variance at each point.

        The H and V matrices are part of a matrix which is to be inverted to
        determine the weights for the linear estimator. The contents of h
        and v are dependent on the order of the underlying polynomial in the
        estimation region. The weights are calculated as:
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

        """

        estimates = []
        variances = []

        dim = self.data.dimensions

        for point in points:
            indices = self.data.neighbors(point, self.neighbors)
            nearest = self.data.get_points(indices)
            values = self.data.get_values(indices)

            nearest.insert(0, point)
            D = self.distances(nearest)
            G = self.variograms(D)

            if self.poly == 0:
                H = np.ones((1, len(nearest)))
                V = np.transpose(np.append(H, np.zeros((1,1)), axis=1))
            elif self.poly == 1:
                ones = np.array([np.ones(len(nearest))])
                H = np.append(np.array(nearest).T, ones, axis=0)
                V = np.transpose(np.append(H, np.zeros((dim+1, dim+1)), axis=1))

            L = np.delete(np.append(np.append(G,H,axis=0),V,axis=1),(0),axis=1)
            g = L[0]
            L = np.delete(L, (0), axis=0)

            W = np.dot(np.linalg.inv(L), np.transpose(g))
            estimates.append(np.dot(W[0:self.neighbors], values))
            variances.append(np.dot(W, g))

        return estimates, variances

    def cost(self, points):
        """
        For kriging, the cost at a given point (which is to be minimized)
        is simply the estimated variance at that point. So, the cost of a set
        of points can be determined by wrapping the interpolate function.
        """
        estimates, variances = self.interpolate(points)
        return variances


class NearestNeighbor(object):

    def __init__(self, data):
        """
        'data' is an instance of a 'Data' class containing the points
        and values from which to interpolate.
        """
        self.data = data

    def interpolate(self, points):
        """ Find the nearest neighbor and return its value.
        """
        self.interp = spinterp.NearestNDInterpolator(np.array(self.data.points),
                                                     np.array(self.data.values))
        values = self.interp(points)

        return values, [0.0 for i in range(len(values))]

    def cost(self, points):
        """ Return the distance to the nearest neighbor.
        """
        costs = []
        for point in points:
            costs.append(self.data.distances(point, 1))

        return costs


class Linear(object):

    def __init__(self, data):
        """
        'data' is an instance of a 'Data' class containing the points
        and values from which to interpolate.
        """
        self.data = data

    def interpolate(self, points):
        """
        Interpolate linearly in N-D space. Returns 0.0 if the point is
        outside the bounds of the points.
        """
        self.interp = spinterp.LinearNDInterpolator(np.array(self.data.points),
                                                    np.array(self.data.values),
                                                    fill_value = 0.0 )
        values = self.interp(points)

        return values, [0.0 for i in range(len(values))]

    def cost(self, points):
        """
        Return the mean distance to the nearest N+1 neighbors, where N is the
        dimensionality of the points. This number is closely related to the
        accuracy of the interpolation.
        """
        costs = []
        N = len(points[0])
        for point in points:
            cost = np.average(np.array(self.data.distances(point, N + 1)))
            costs.append(cost)

        return costs


class RBF(object):

    def __init__(self, data, function='multiquadric'):
        """
        'data' is an instance of a 'Data' class containing the points
        and values from which to interpolate.
        """
        self.data = data
        self.function = function

    def interpolate(self, points):
        """
        Interpolate linearly in N-D space. Returns 0.0 if the point is
        outside the bounds of the points.
        """
        datapoints = [list(item) for item in zip(*self.data.points)]
        datapoints.append(self.data.values)

        self.interp = spinterp.Rbf(*datapoints)
        points = [list(item) for item in zip(*points)]
        values = self.interp(*points)
        return values, [0.0 for i in range(len(values))]

    def cost(self, points):
        """
        Return the mean distance to the nearest N+1 neighbors, where N is the
        dimensionality of the points. This number is closely related to the
        accuracy of the interpolation.
        """
        costs = []
        N = len(points[0])
        for point in points:
            cost = np.average(np.array(self.data.distances(point, N + 1)))
            costs.append(cost)

        return costs
