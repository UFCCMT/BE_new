"""
  A benchmark automation tool.

    Copyright (C) 2013-2014 Dylan Rudolph

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
import subprocess
import pickle
import datetime
import platform
import csv
import userio

class PointGenerator(object):

    def __init__(self, ranges):
        """
        Ranges is a list of two-element lists, where each two-element
        list indiciates the lower and upper bound for point generation.
        For example: [ [Xlow, Xhigh], [Ylow, Yhigh], ... ].
        """
        self.R = ranges
        self.D = len(ranges)

    def rand(self, lower, upper):
        """ Return a random integer over the range [lower, upper).
        """
        return int(round((upper - lower) * np.random.rand() + lower))

    def dense(self):
        """ Produce a dense set based on the provided ranges. A word of
        caution: this can produce a very large resulting array. """

        # Generate a list of the ticks along each axis.
        axes = [np.array(range(item[0], item[1]), dtype=np.int32) for
                item in self.ranges]

        # Create a numpy meshgrid from it and reform it to be one-dimensional.
        mesh = np.meshgrid(*axes)
        reshaped = [list(item.reshape((item.size))) for item in mesh]

        # Zip the one-dimensional arrays together to obtain the points.
        points = zip(*reshaped)

        return points

    def random(self, count):
        """ Generate a random set of 'count' points over the ranges.
        """
        points = []
        for i in range(count):

            # Make a random list of integers of length 'D'
            point = [self.rand(*self.R[j]) for j in range(self.D)]
            # Ensure that this point isn't already in 'points'.
            while point in points:
                point = [self.rand(*self.R[j]) for j in range(self.D)]
            points.append(point)

        return points

    def linspace(self, counts):
        """
        Generate a set of linearly-spaced elements with 'counts[i]' elments
        along each axis. There will be (count[0]*count[1]*...) total points.
        """

        # Generate a D-length list of integer numpy linspace arrays
        spaced = [np.array(np.linspace(self.R[i][0], self.R[i][1], counts[i]),
                           dtype=np.int32) for i in range(self.D)]
        mesh = np.meshgrid(*spaced)

        # Convert each mesh item into a one-dimensional array.
        reshaped = [list(item.reshape((item.size))) for item in mesh]

        # Zip the one-dimensional arrays together to obtain the points.
        points = [list(item) for item in zip(*reshaped)]

        return points

    def randlinspace(self, counts, deviation):
        """
        Generate a set of linearly-spaced elements with 'counts[i]' elments
        along each axis. Add a random pertubation to these with a standard
        deviation of 'deviation'. There will be (count[0]*count[1]*...) points.
        There is no checking to ensure that there are no overlapping points.
        """

        # Generate a D-length list of numpy linspace arrays
        spaced = [np.linspace(self.R[i][0], self.R[i][1], counts[i])
                  for i in range(self.D)]
        mesh = np.meshgrid(*spaced)

        # Convert each mesh item into a one-dimensional array, add a normal
        # random variable to each element, clip it to our range, and then
        # convert it to a list of integers.
        reshaped = [list(np.clip( np.array( (mesh[i].reshape((mesh[i].size)) +
                                             np.random.randn(mesh[i].size) *
                                             float(deviation)),
                                            dtype=np.int32 ),
                                  self.R[i][0], self.R[i][1] ) )
                    for i in range(self.D)]

        # Zip the one-dimensional arrays together to obtain the points.
        points = [list(item) for item in zip(*reshaped)]

        return points

    def diaglinspace(self, count):
        """
        Generate a set of linearly-spaced elements with 'counts' elments and
        the same entry along each axis. This function will likely be used only
        for generating a 2-D list of points for 1-D data.
        """
        linspace = [np.array(np.linspace(self.R[0][0], self.R[0][1], count),
                             dtype=np.int32) for item in range(self.D)]

        points = zip(*linspace)

        return points

    def randdiaglinspace(self, count):
        """
        Generate a set of random elements with 'counts' elments and the same
        entry along each axis. This function will likely be used only for
        generating a 2-D list of points for 1-D data.
        """
        points = []
        for i in range(count):
            val = self.rand(*self.R[0])
            # Make a list of integers from the 'val'
            point = [val for j in range(self.D)]
            # Ensure that this point isn't already in 'points'.
            while point in points:
                val = self.rand(*self.R[0])
                point = [val for j in range(self.D)]
            points.append(point)
        return points


class Benchmarking(object):

    def __init__(self, identifier=None, tags=None, units='seconds',
                 arch=None, os=None):
        """
        The 'identifier' is simply a name assigned to the current thing being
        benchmarked. The 'tags' are a list of things which are essentially
        column labels for the 'arguments' to be passed. E.g., ["M", "N", "P"].
        """
        self.shell = userio.Shell()
        today = datetime.date.today()
        self.data = { "identifier": identifier, "argument tags": tags,
                      "year": today.year, "month": today.month, "day":today.day,
                      "arch": arch if arch else platform.machine(),
                      "os": os if os else platform.platform(), "units": units}

    def setup(self, names, starts, ends, command):
        """
        The 'names' are identifiers for the things which are to be parsed, e.g.,
        "run time". 'starts' are the parts of a return string which preceed the
        actual number. 'ends' are strings after the number. Each of 'names',
        'starts', and 'ends' is a list of strings. The 'command' is the actual
        thing to run (e.g., "./matmult" or "sh run.sh")
        """
        self.strings = zip(names, starts, ends)
        self.data["result tags"] = names
        self.command = command

    def call(self, cmd):
        """
        This function should likely only be used in setup or setup-like
        circumstances. It directs the system to call a provided commend.
        """
        self.shell.say("Calling: '" + cmd + "'")
        result = subprocess.call([cmd])

    def run(self, arguments, message=""):
        """
        Build a command-line call and have the system execute it. 'arguments'
        must be of the form [argA, argB, ...].
        """
        call = [self.command]
        call.extend([str(item) for item in arguments])
        self.shell.say("Calling: '" + " ".join(call) + "'" + message)

        results = []
        output = subprocess.check_output(call)
        for i in range(len(self.strings)):
            lower = output.find(self.strings[i][1]) + len(self.strings[i][1])
            upper = output.find(self.strings[i][2])
            results.append(float(output[lower:upper]))
            self.shell.increase_indent()
            self.shell.say("Result of " + self.strings[i][0] +
                           " was: " + repr(results[i]) )
            self.shell.decrease_indent()

        return results

    def batch(self, arguments):
        """
        Run a batch of command-line calls. The 'arguments' paramter is a
        list of lists of the form:

        [ [argA0, argB0, ...],
          [argA1, argB1, ...],
          ...
          [argAN, argBN, ...] ]

        where each [argA0, argB0, ...] is included in the command-line call,
        and each element is converted to a string representation to do so.
        """
        results = []
        for i in range(len(arguments)):
            progress = " (" + repr(i) + " of " + repr(len(arguments)) + ")"
            results.append(self.run(arguments[i], message = progress))

        self.data["arguments"] = arguments
        self.data["results"] = results

        return results

    def single(self, arguments):
        """
        A 'single' is a call which gets appended to the batch run. 'arguments'
        must be of the form [argA, argB, ...]. In order to run a 'single', a
        'batch' must have already been run, and no more batches can be run.
        """
        result = self.run(arguments)

        self.data["arguments"].append(arguments)
        self.data["results"].append(result)

        return result

    def save_bmark(self, filename):
        """
        Pickle the current 'data' so that it can be retrieved later.
        """
        handle = open(filename + ".bmark", 'wb')
        pickle.dump(self.data, handle)
        handle.close()

    def save_csv(self, filename):
        """
        Save the existing data to a .csv file. The translation between
        a .csv file and a .bmark file is not implemented, so this should
        generally be called in conjunction with saving a .bmark file.
        """

        writer =  csv.writer(open(filename+".csv", 'w'))
        writer.writerow(["Identifier", " ", "Units", " ", "Day", "Month",
                         "Year", " ", "Architecture", "Operating System"])
        writer.writerow([self.data["identifier"], " ", self.data["units"], " ",
                         self.data["day"], self.data["month"], self.data["year"],
                         " ", self.data["arch"], self.data["os"]])
        writer.writerow([])

        labels = []
        labels.extend(self.data["argument tags"])
        labels.extend(self.data["result tags"])
        writer.writerow(labels)

        for i in range(len(self.data["results"])):
            row = []
            row.extend(self.data["arguments"][i])
            row.extend(self.data["results"][i])
            writer.writerow(row)

    def load_bmark(self, filename):
        """
        Load a .bmark file but do not replace the current 'data' with the
        contents of that .bmark file.
        """
        handle = open(filename + ".bmark", 'rb')
        contents = pickle.load(handle)
        handle.close
        return contents

    def samples_from_bmark(self, filename):
        """
        Load a .bmark file, and extract from it only arguments ('points'), and
        results ('values').
        """
        contents = self.load_bmark(filename)
        points = contents["arguments"]
        values = [ item[0] for item in contents["results"] ]
        return points, values


