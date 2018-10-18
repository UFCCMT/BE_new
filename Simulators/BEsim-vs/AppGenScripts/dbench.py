"""
  A benchmarking tool.

    Copyright (C) 2014  Dylan Rudolph

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

import subprocess
import string
import pickle
import datetime
import platform
import csv

class Profiler():

    PARSE_STRINGS = { "Run Time": {"start": "RUNTIME: ", "end": ";r"},
                      "memtime": {"start": "MEMTIME: ", "end": ";m"},
                      "alloc": {"start": "ALLOCTIME: ", "end": ";a"},
                      "dealloc": {"start": "ALLOCTIME: ", "end": ";d"},
                      "overhead": {"start": "OVERHEADTIME: ", "end": ";o"},
                      "other": {"start": "OTHERTIME: ", "end": ";t"} }

    DASH = "-------------------------------------------------------------------"
    HEAD = "--------------------- Benchmark Manager V0.6 ----------------------"
    FOOT = "------------------------------- END -------------------------------"
    ALERT = "***"
    LG = "----"
    SM = "--"

    def __init__(self):

        self.data = {}

        #print "\n", self.DASH, "\n", self.HEAD, "\n", self.DASH, "\n"

    def run(self, command, arguments, n):

        call_string = command + ' '
        for i in range(len(arguments)):
            call_string = call_string + arguments[i] + ' '
        #print "Calling: '" + call_string + "' " + repr(n)+ " time(s)."

        call = [command]
        for argument in arguments:
            call.append(argument)

        averages = [0.0 for item in range(len(self.things_to_parse))]

        for i in range(n):
            return_text = subprocess.check_output(call)
            for j in range(len(self.things_to_parse)):
                thing = self.things_to_parse[j]
                lower = (return_text.find(self.PARSE_STRINGS[thing]["start"]) +
                         len(self.PARSE_STRINGS[thing]["start"]))
                upper = return_text.find(self.PARSE_STRINGS[thing]["end"])
                averages[j] += float(return_text[lower:upper]) / n

        for i in range(len(self.things_to_parse)):
           # print self.SM, "Average of", self.things_to_parse[i], \
                "was", averages[i], self.units

        return averages

    def batchRun(self, identifier, command, arguments, tagnames, tags, filename,
                 runs=1, things_to_parse=['Run Time'], units='Seconds'):

        self.things_to_parse = things_to_parse
        self.units = units

        results = []

        for i in range(len(arguments)):
            results.append(self.run(command, arguments[i], runs))

        today = datetime.date.today()

        self.data["year"] = today.year
        self.data["month"] = today.month
        self.data["day"] = today.day
        self.data["arch"] = platform.machine()
        self.data["os"] = platform.platform()

        self.data["identifier"] = identifier
        self.data["items"] = self.things_to_parse
        self.data["results"] = results
        self.data["tag names"] = tagnames
        self.data["tags"] = tags
        self.data["units"] = self.units

        writer =  csv.writer(open(filename+".csv", 'w'))

        writer.writerow(["Identifier", " ",
                         "Units", " ",
                         "Day",
                         "Month",
                         "Year", " ",
                         "Architecture",
                         "Operating System"])

        writer.writerow([self.data["identifier"], " ",
                         self.data["units"], " ",
                         self.data["day"],
                         self.data["month"],
                         self.data["year"], " ",
                         self.data["arch"],
                         self.data["os"] ] )

        writer.writerow([])

        columnlabels = []
        for item in self.data["tag names"]:
            columnlabels.append(item)

        for item in self.things_to_parse:
            columnlabels.append(item)

        writer.writerow(columnlabels)

        for i in range(len(self.data["results"])):
            thisrow = []
            for tag in self.data["tags"][i]:
                thisrow.append(tag)
            for result in self.data["results"][i]:
                thisrow.append(result)
            writer.writerow(thisrow)

        fh = open(filename + ".bmark", 'wb')
        pickle.dump(self.data, fh)
        fh.close()

        #print "\n", self.DASH, "\n", self.DASH, "\n", self.DASH
        #print "\n", self.ALERT, "File Saved:", filename, self.ALERT, "\n"
        #print "Identifier:       ", self.data["identifier"]
        #print "Run Date (D/M/Y): ", \
          #  self.data["day"], "/", self.data["month"], "/", self.data["year"]
       # print "Operating System: ", self.data["os"]
       # print "Architecture:     ", self.data["arch"]
       # print "\n", self.DASH, "\n", self.FOOT, "\n", self.DASH, "\n"

    def loadFile(self, filename):

        fh = open(filename, 'rb')
        data = pickle.load(fh)
        fh.close

        return data
