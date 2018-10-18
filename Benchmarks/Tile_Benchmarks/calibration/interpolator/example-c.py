#!/usr/bin/python

import lib
import lib.interpolation as interpolation
import lib.benchmarking as benchmarking
import lib.training as training
import lib.userio as userio

"""
Example specifics:

 - Application: Dot Product with 2 Paramters (One Faked)
 - Interpolator: Kriging
 - Initial point selection scheme: linear
 - Trainer: None

 - Initial points: 1000
 - Trained points: 0

"""

example_name = "example-c"

# General setup. 'shell'  directs and controls user i/o.
# 'data' stores all of the points and values.
shell = userio.Shell()
data = interpolation.Data()

# ---------- Set up the benchmarking and point-generation tools ---------- #
app_name = "dotprod2"
app_tags = ["N", "-"]
N_range = [64, 16384]
Z_range = [64, 16384]
app_ranges = [N_range, Z_range]
things_to_parse = ["Run Time"]
start_strings = ["RUNTIME: "]
end_strings = [";r"]
command = "samples/dot_serial"

bench = benchmarking.Benchmarking(app_name, app_tags)
bench.setup(things_to_parse, start_strings, end_strings, command)
bench.shell = shell

pointgen = benchmarking.PointGenerator(app_ranges)

# ----------------------- Set up the interpolator ------------------------ #

variogram = { "type": "exponential",
              "nugget": 0.001,
              "range": 10.0,
              "sill": 1.0 }
polynomial = 0
neighbors = 4

interpol = interpolation.Kriging(data, polynomial, variogram, neighbors)

initial_points = pointgen.diaglinspace(200)
trainer = training.Training(interpol, bench, pointgen, shell)
trainer.initialize(initial_points)

# We're done, save the results.
bench.save_bmark("saves/" + example_name)
bench.save_csv("saves/" + example_name)

# ------------------------ Evaluate the Results -------------------------- #

bench.load_bmark("saves/" + example_name)

evaluation_points = pointgen.randdiaglinspace(500)

estimates, variances = interpol.interpolate(evaluation_points)
trainer.evaluate(evaluation_points, estimates)
