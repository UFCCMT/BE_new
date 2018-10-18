from scipy import interpolate as interp
from scipy.interpolate import griddata
import scipy.special as special
from scipy import spatial
import numpy as np
import dbench
import copy
import math

def find_dist_and_gamma(data, variogram):
    """ Internal function, called by krige() """
    N, m = len(data) - 1, len(data[-1])
    R = range(N)

    td = tuple([m + 1 if i == 0 else 1 for i in R])
    tile = [np.tile(np.array(data[i]), td) for i in R]

    for i in R:
        tile[i] = np.power(np.subtract(tile[i], np.transpose(tile[i])), 2)

    if variogram[0] in ["exponential", "exp", "Exponential"]:
        n, s, r, a = variogram[1], variogram[2], -1, variogram[3]
        dist = np.sqrt(np.sum(tile, axis=0))
        gamma = (s - n) * (1 - np.exp( dist / (r * a) )) + n

    return dist, gamma

def generate_KDTree(data):
    """ Internal function, called by krige() """

    kdtree = spatial.KDTree(zip(*data[0:-1]))

    return kdtree

def find_nearest_points(kdtree, values, k, loc):
    """ Internal function, called by krige() """

    neighbors = kdtree.query(loc, k=k)
    vals = [values[i] for i in neighbors[1]]
    points = [list(item) for item in zip(*kdtree.data[neighbors[1]])]
    points.append(vals)

    return points

def get_matrix_multiply_data(file_path):
    """ Parse through a matrix multiply benchmark file and return a 
    list of lists of data in the file. """

    prof = dbench.Profiler()
    M, N, P, D = [], [], [], []

    data = prof.loadFile(file_path)

    for i in range(len(data["results"])):
        M.append(float(data["tags"][i][0]))
        N.append(float(data["tags"][i][1]))
        P.append(float(data["tags"][i][2]))
        D.append(float(data["results"][i][0]))

    return [M, N, D]

def get_dot_product_data(file_path):
    """ Parse through a dot product benchmark file and return a 
    list of lists of data in the file. """

    prof = dbench.Profiler()
    N = []
    D = []
    Z = []

    data = prof.loadFile(file_path)

    for i in range(len(data["results"])):
        N.append(float(data["tags"][i][0]))
        Z.append(float(data["tags"][i][0]))
        D.append(float(data["results"][i][0]))

    return [N, Z, D]


def krige(data, variogram, order, points, k=10):
    """
    'input_data' should be an [N+1][m] dimensional list contaning the ordinates of the
    data plus the value at those ordinates, e.g.:
    [
    [ X0, X1, X2, ..., Xm ],   --> Dimension 0
    [ Y0, Y1, Y2, ..., Ym ],   --> Dimension 1
    ...                        --> Other Dimensions (N total)
    [ D0, D1, D2, ..., Dm ]    --> Data
    ]

    'variogram' should specify the type and parameters of a the (semi)variogram
    to be used in a list, e.g.:
    ["exponential", 0, 10, 3.33]

    'order' specifies the order of the polynomial which is assumed to be present
    in the data, e.g. 3

    'points' is a length-m list of list coordinates to estimate.

    'neighbors' declares how many nearest neighbors to use, 0 means all.
    """

    if k == 0 or k > len(data[0]):
        k = len(data[0])

    estimates = [0.0 for i in range(len(points[0]))]
    variances = [0.0 for i in range(len(points[0]))]

    kdtree = generate_KDTree(data)

    for p in range(len(points[0])):

        point = [points[i][p] for i in range(len(points))]
        neighbors = find_nearest_points(kdtree, data[-1], k, point)
        N, m = len(neighbors) - 1, len(neighbors[-1])
        R = range(N)

        for i in R:
            neighbors[i].insert(0, points[i][p])

        dist, gamma = find_dist_and_gamma(neighbors, variogram)

        if order == 0:
            h = np.ones((1, m+1))
            v = np.transpose(np.append(h, np.zeros((1,1)), axis = 1))
        elif order == 1:
            h = np.ones((N+1, m+1))
            for i in range(0, N):
                h[i] = np.array(neighbors[i])
            v = np.transpose(np.append(h, np.zeros((N+1, N+1)), axis=1))
        elif order == 2:
            h = np.ones((N+4, m+1))
            for i in range(0, N):
                h[i] = np.array(neighbors[i])
            for i in range(N, 2*N):
                h[i] = np.array(neighbors[i-N]) * np.array(neighbors[i-N])
            for i in range(2*N, 2*N + int(special.binom(N, 2))):
                if i == 2*N:
                    h[i] = np.array(neighbors[0]) * np.array(neighbors[N - 1])
                else:
                    h[i] = np.array(neighbors[i-2*N-1]) * np.array(neighbors[i-2*N])
            v = np.transpose(np.append(h, np.zeros((N+4, N+4)), axis=1))

        gamma = np.append(np.append(gamma, h, axis=0), v, axis=1)
        gamma = np.delete(gamma, (0), axis=1)
        g = gamma[0]
        gamma = np.delete(gamma, (0), axis=0)

        w = np.dot(np.linalg.inv(gamma), np.transpose(g))

        estimates[p] = np.dot(w[0:m], neighbors[-1])
        variances[p] = np.dot(w, g)

    return estimates, variances

if __name__ == "__main__":

    trained_file = "Tilera_Dot_Prod.bmark"
    trained_data = get_dot_product_data(trained_file)

    variogram = ["exponential", 0.000, 1.0, 500.0]

    x_pts = [256.0]
    points = [x_pts, x_pts] # Fake 2d, temporary fix to singular matrix issue in 1d.

    neighbors = 3
    poly = 0

    estimates, variances = krige(trained_data, variogram, poly, points, neighbors)

    print ("Number of Points: ", len(points[0]))
    print ("Value of Points: ", points)
    print ("Resulting Estmates: ", estimates)
    print ("Resulting Variances: ", variances)

