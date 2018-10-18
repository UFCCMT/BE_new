"""
  An interpolator training tool.

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

import numpy as np

class Training(object):

    def __init__(self, interpol, gatherer, pointgen, shell):
        """
        Training must be provided with and interpolator, a 'gatherer', which may
        be a benchmarking program or otherwise, a point generator, and a shell.
        """
        self.interpol = interpol
        self.gatherer = gatherer
        self.pointgen = pointgen
        self.shell = shell

    def initialize(self, initial_points):
        """ Gather an initial set of points before doing any training.
        """
        self.initial_points = initial_points
        self.shell.newline()
        self.shell.dashes()
        self.shell.say( "-------------------------- Gathering Initial Data Set " +
                        "------------------------" )
        self.shell.dashes()
        self.shell.newline()

        self.shell.increase_indent()

        # Perform the gathering and provide the samples to the interpolator.
        values = [item[0] for item in  self.gatherer.batch(self.initial_points)]
        self.interpol.data.set_samples(self.initial_points, values,
                                       len(self.initial_points[0]))

        self.shell.decrease_indent()

    def train(self, method):
        """
        Iteratively train the interpolator by gathering new samples and add them
        to the set. The paramters of the training are provided by 'method'.
        """
        self.shell.newline()
        self.shell.dashes()
        self.shell.say( "---------------------------   Performing Training   " +
                        "--------------------------" )
        self.shell.dashes()
        self.shell.newline()

        if method["type"] in ["budgeted random worst cost", "brwc"]:

            self.shell.increase_indent()

            for i in range(method["budget"]):
                self.shell.say("Training phase " + repr(i + 1) + " out of " +
                               repr(method["budget"]) )

                # Generate the random points, then evaluate their cost.
                points = self.pointgen.random(method["evaluation points"])
                costs = self.interpol.cost(points)

                # Find the index of the worst among them.
                worst = costs.index(max(costs))
                self.shell.increase_indent()
                self.shell.say("Highest cost of < " + ("%.5f" % costs[worst]) +
                               " > found at " + repr(points[worst]) )

                # Obtain a sample at this location.
                newpoint = points[worst]
                newvalue = self.gatherer.single(newpoint)[0]
                self.shell.decrease_indent()
                self.interpol.data.add_sample(newpoint, newvalue)

            self.shell.decrease_indent()

    def evaluate(self, points, estimates):
        """
        Given some estimates, see how good they were by going to the
        gatherer and obtaining the actual values at those points.
        """
        self.shell.newline()
        self.shell.dashes()
        self.shell.say( "---------------------------  Performing Evaluation  " +
                        "--------------------------" )
        self.shell.dashes()
        self.shell.newline()

        # Gather the test points.
        self.shell.increase_indent()
        values = [item[0] for item in  self.gatherer.batch(points)]
        self.shell.decrease_indent()

        # Compute some statistics about those points.
        error = np.abs( np.array(estimates) - np.array(values) )
        fraction =  error / np.array(values)
        aae  = np.average( error )
        afe  = np.average( fraction )
        wfei = np.argmax( fraction )
        wfe = fraction[wfei]

        # Let the user know about those statistics.
        self.shell.newline()
        self.shell.dashes()
        self.shell.say( "---------------------------  Results of Evaluation  " +
                        "--------------------------" )
        self.shell.dashes()
        self.shell.newline()
        self.shell.increase_indent()
        self.shell.say("Number of Points Evaluated: " + repr(len(points)))
        self.shell.say(("Average Fractional Error: %0.7f" % afe))
        self.shell.say(("Worst Fractional Error:   %0.7f" % wfe) +
                       " at " + repr(points[wfei]))
        self.shell.say(("Average Absolute Error:   %0.7f" % aae))
        self.shell.decrease_indent()
        self.shell.newline()

        return aae, afe, wfei, wfe
