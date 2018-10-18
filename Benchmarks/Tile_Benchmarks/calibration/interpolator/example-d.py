import lib
import lib.interpolation as interpolation
import lib.benchmarking as benchmarking
import lib.training as training
import lib.userio as userio

"""
Example specifics:

 - Application: Matrix Multiplication with 3 parameters
 - Interpolator: Linear
 - Initial point selection scheme: linear
 - Trainer: None

 - Initial points: 1728
 - Trained points: 0

"""

example_name = "example-d"

# General setup. 'shell'  directs and controls user i/o.
# 'data' stores all of the points and values.
shell = userio.Shell()
data = interpolation.Data()

# ---------- Set up the benchmarking and point-generation tools ---------- #
app_name = "matmult3"
app_tags = ["M", "N", "P"]
M_range = [16, 512]
N_range = [16, 512]
P_range = [16, 512]
app_ranges = [M_range, N_range, P_range]
things_to_parse = ["Run Time"]
start_strings = ["RUNTIME: "]
end_strings = [";r"]
command = "samples/3-Param-Mat-Mult/mm3"

bench = benchmarking.Benchmarking(app_name, app_tags)
bench.setup(things_to_parse, start_strings, end_strings, command)
bench.shell = shell

pointgen = benchmarking.PointGenerator(app_ranges)

# ----------------------- Set up the interpolator ------------------------ #

interpol = interpolation.Linear(data)

initial_points = pointgen.randlinspace([12, 12, 12], 3)
trainer = training.Training(interpol, bench, pointgen, shell)
trainer.initialize(initial_points)

# We're done, save the results.
bench.save_bmark("saves/" + example_name)
bench.save_csv("saves/" + example_name)

# ------------------------ Evaluate the Results -------------------------- #

bench.load_bmark("saves/" + example_name)

evaluation_points = pointgen.random(500)

estimates, variances = interpol.interpolate(evaluation_points)
trainer.evaluate(evaluation_points, estimates)
