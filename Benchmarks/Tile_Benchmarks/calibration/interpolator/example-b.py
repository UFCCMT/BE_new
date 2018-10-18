import lib
import lib.interpolation as interpolation
import lib.benchmarking as benchmarking
import lib.training as training
import lib.userio as userio

"""
Example specifics:

 - Application: 2D Convolution with 4 parameters
 - Interpolator: Kriging
 - Initial point selection scheme: linear spacing with small deviation
 - Trainer: Budgeted Random Worst Cost

 - Initial points: 900
 - Trained points: 100
"""

example_name = "example-b"

# General setup. 'shell'  directs and controls user i/o.
# 'data' stores all of the points and values.
shell = userio.Shell()
data = interpolation.Data()

# ---------- Set up the benchmarking and point-generation tools ---------- #
app_name = "conv4"
app_tags = ["M", "N", "X", "Y"]
M_range = [64, 512]
N_range = [64, 512]
X_range = [3, 15]
Y_range = [3, 15]
app_ranges = [M_range, N_range, X_range, Y_range]
things_to_parse = ["Run Time"]
start_strings = ["RUNTIME: "]
end_strings = [";r"]
command = "samples/4-Param-2D-Conv/2Dconv"

bench = benchmarking.Benchmarking(app_name, app_tags)
bench.setup(things_to_parse, start_strings, end_strings, command)
bench.shell = shell

pointgen = benchmarking.PointGenerator(app_ranges)

# ----------------------- Set up the interpolator ------------------------ #
variogram = { "type": "exponential",
              "nugget": 0.05,
              "range": 50.0,
              "sill": 1.0 }
polynomial = 1
neighbors = 18

interpol = interpolation.Kriging(data, polynomial, variogram, neighbors)

# ------------------ Set up the interpolation trainer -------------------- #
training_method = { "type": "budgeted random worst cost",
                    "evaluation points": 1000,
                    "budget": 100}

initial_points = pointgen.randlinspace([10, 10, 3, 3], 2)
trainer = training.Training(interpol, bench, pointgen, shell)

# ------------------------ Perform the training -------------------------- #

# First, gather the initial points.
trainer.initialize(initial_points)

# Then, perform the iterative training.
trainer.train(training_method)

# We're done, save the results.
bench.save_bmark("saves/" + example_name)
bench.save_csv("saves/" + example_name)

# ------------------------ Evaluate the Results -------------------------- #

bench.load_bmark("saves/" + example_name)

evaluation_points = pointgen.random(1000)

estimates, variances = interpol.interpolate(evaluation_points)
trainer.evaluate(evaluation_points, estimates)

