import lib
import lib.interpolation as interpolation
import lib.benchmarking as benchmarking
import lib.training as training
import lib.userio as userio

"""
Example specifics:

 - Application: Matrix Multiply with 2 parameters
 - Interpolator: Kriging
 - Initial point selection scheme: linear spacing with small deviation
 - Trainer: Budgeted Random Worst Cost

 - Initial points: 144
 - Trained points: 100
"""

example_name = "example-a"

# General setup. 'shell'  directs and controls user i/o.
# 'data' stores all of the points and values.
shell = userio.Shell()
data = interpolation.Data()

# ---------- Set up the benchmarking and point-generation tools ---------- #
app_name = "matmult2"
app_tags = ["M", "N"]
M_range = [16, 256]
N_range = [16, 256]
app_ranges = [M_range, N_range]
things_to_parse = ["Run Time"]
start_strings = ["RUNTIME: "]
end_strings = [";r"]
command = "samples/2-Param-Mat-Mult/mm2"

bench = benchmarking.Benchmarking(app_name, app_tags)
bench.setup(things_to_parse, start_strings, end_strings, command)
bench.shell = shell

pointgen = benchmarking.PointGenerator(app_ranges)

# ----------------------- Set up the interpolator ------------------------ #
variogram = { "type": "exponential",
              "nugget": 0.01,
              "range": 50.0,
              "sill": 1.0 }
polynomial = 0
neighbors = 12

interpol = interpolation.Kriging(data, polynomial, variogram, neighbors)

# ------------------ Set up the interpolation trainer -------------------- #
training_method = { "type": "budgeted random worst cost",
                    "evaluation points": 500,
                    "budget": 100 }

initial_points = pointgen.randlinspace([12, 12], 4)
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

evaluation_points = pointgen.random(500)

estimates, variances = interpol.interpolate(evaluation_points)
trainer.evaluate(evaluation_points, estimates)
