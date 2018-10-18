#!/usr/bin/env python
import lib
import lib.interpolation as interpolation
import lib.benchmarking as benchmarking
import lib.training as training
import lib.userio as userio

"""
Example specifics:

 - Application: Dot Product with 2 Paramters (One Faked)
 - Interpolator: Kriging (Unused Dummy)
 - Initial point selection scheme: None
 - Trainer: None

 - Initial points: 200
 - Trained points: 0

"""

example_name = "tile-dot-prod"

# General setup. 'shell'  directs and controls user i/o.
# 'data' stores all of the points and values.
shell = userio.Shell()
data = interpolation.Data()

# ---------- Set up the benchmarking and point-generation tools ---------- #
app_name = "tilera-dot-product"
app_tags = ["N", "-"]
N_range = [4, 4096]
initial_points = 200

#For dense set
#pts = [[i, i] for i in range(16, 4097)]

app_ranges = [N_range, N_range]
things_to_parse = ["Run Time"]
start_strings = ["RUNTIME: "]
end_strings = [";r"]
command = "./dotprod"

bench = benchmarking.Benchmarking(app_name, app_tags)
bench.setup(things_to_parse, start_strings, end_strings, command)
bench.shell = shell

pointgen = benchmarking.PointGenerator(app_ranges)

# ----------------------- Set up the interpolator ------------------------ #

variogram = { "type": "exponential",
              "nugget": 0.001,
              "range": 100.0,
              "sill": 1.0 }
polynomial = 0
neighbors = 6

interpol = interpolation.Kriging(data, polynomial, variogram, neighbors)

initial_points = pointgen.randdiaglinspace(initial_points)
trainer = training.Training(interpol, bench, pointgen, shell)
trainer.initialize(initial_points)

# We're done, save the results.
bench.save_bmark(example_name)
bench.save_csv(example_name)
