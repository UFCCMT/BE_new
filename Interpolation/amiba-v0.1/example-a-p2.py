import lib
import lib.interpolation as interpolation
import lib.benchmarking as benchmarking

bench = benchmarking.Benchmarking()
data = interpolation.Data()

points, values = bench.samples_from_bmark("saves/example-a")
data.set_samples(points, values, len(points[0]))

variogram = {"type": "exponential", "nugget": 0.01, "range": 50.0, "sill": 1.0}
polynomial = 0
neighbors = 8
interpol = interpolation.Kriging(data, polynomial, variogram, neighbors)

test_points = [[32, 18], [64, 64], [91, 80], [123, 231]]
estimates, variances = interpol.interpolate(test_points)

print "Test points:", test_points
print "Estimates:", "  ".join([("%.6f" % item) for item in estimates])
print "Variances:", "  ".join([("%.6f" % item) for item in variances])
