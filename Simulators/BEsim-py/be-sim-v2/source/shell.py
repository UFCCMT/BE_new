"""
  A set of functions for text-based user interaction.

    Copyright (C) 2012-2015 Dylan Rudolph

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

import math
import textwrap

class Shell(object):

    WARNING = "** ", " **"
    ERROR = "*** ", " ***"
    ALERT = "<<<<< ", " >>>>>"
    INSTRUCT = ">>> ", ""
    ONE_INDENT = "  "

    def __init__(self, line_length=79, verbose=False, suppress=False):
        """ """
        self.line_length = line_length
        self.suppressed = suppress
        self.verbose = verbose
        self.set_indent(0)

    def repeat(self, which, count):
        """Repeat a character ceil and floor 'count'/2 times, return both."""
        return which * int(math.ceil(count)), which * int(math.floor(count))

    # ----------------------- Indent-Related Functions ---------------------- #

    def set_indent(self, level):
        """Set the indentation level."""
        self.current_indent = max(level, 0)

    def increase_indent(self):
        """Increase the indentation level by 1."""
        self.set_indent(self.current_indent + 1)

    def decrease_indent(self):
        """Decrease the indentation level by 1."""
        self.set_indent(self.current_indent - 1)

    # -------------------------- Printing Functions ------------------------- #

    def say(self, text, indent=True, verbose=False, show=True):
        """Put some text in the prompt at the proper indent level."""
        indent_string = self.ONE_INDENT * self.current_indent
        if (not self.suppressed) and show:
            if (self.verbose and verbose) or verbose == False:
                print indent_string + text if indent else text

    def dashes(self, verbose=False):
        """Print dashes for a full line."""
        self.say("-" * self.line_length, indent=False, verbose=verbose)

    def newline(self, verbose=False):
        """Skip a line."""
        self.say("", indent=False, verbose=verbose)

    # ---------------------- Compound-Printing Functions -------------------- #

    def heading(self, text):
        """Print a heading-formatted string."""
        pre, suf = self.repeat("-", (self.line_length - 2 - len(text)) / 2.)
        self.newline()
        self.dashes()
        self.say(pre + " " + text + " " + suf, indent=False)
        self.dashes()

    def subheading(self, text):
        """Print a sub-heading-formatted string."""
        pre, suf = self.repeat("-", (self.line_length - 2 - len(text)) / 2.)
        self.newline()
        self.say(pre + " " + text + " " + suf, indent=False)
        self.newline()

    def alert(self, text):
        """Print an alert-formatted (centered) string."""
        pre, suf = self.repeat(" ", (self.line_length - 12 - len(text)) / 2.)
        self.say(pre+self.ALERT[0] + text + self.ALERT[1]+suf, indent=False)

    def center(self, text):
        """Print an centered string."""
        pre, suf = self.repeat(" ", (self.line_length - len(text)) / 2.)
        self.say(pre + text + suf, indent=False)

    def error(self, text, indent=False):
        """Print an error-formatted string."""
        self.say(self.ERROR[0] + text + self.ERROR[1], indent=indent)

    def warn(self, text, indent=False):
        """Print a warning-formatted string."""
        self.say(self.WARNING[0] + text + self.WARNING[1], indent=indent)

    def instruct(self, text, indent=False):
        """Print an instruction-formatted string."""
        self.say(self.INSTRUCT[0] + text + self.INSTRUCT[1], indent=indent)

    # ---------------------- User-Interaction Functions --------------------- #

    def pause(self, indent=False):
        """Request that the user press a key to continue."""
        indent_string = self.ONE_INDENT * self.current_indent
        text = "Press Enter To Continue...\n"
        raw_input(indent_string + text if indent else text)

    # ---------------------- Complex Printing Functions --------------------- #

    def description(self, heading, string, seperator=" :: ", stop=-1):
        """Print a description-formatted string."""
        indent_string = self.ONE_INDENT * self.current_indent
        heading = indent_string + heading + seperator
        wrapped = textwrap.wrap(string, self.line_length - len(heading))
        for index, line in enumerate(wrapped):
            _line = heading + line if index == 0 else " " * len(heading) + line
            print _line if index < (len(wrapped) - 1) else _line[:stop]

    def histogram(self, values, minimum=None, maximum=None, coarse=False):
        """Prints a text-based histogram of the values, with optional range.

        All numbers will be printed with roughly 4/6 siginificant figures, and
        there will be 10/6 'bins' in the histogram. This function only works
        well if there are less than 10000 values per bin, and the magnitude of
        the numbers is between 0.01 and 100000.
        """
        import numpy as np

        minimum = minimum if minimum else np.amin(values)
        maximum = maximum if maximum else np.amax(values)

        if not coarse:
            # h : histogram value array, b : histogram bins array, d : decimals
            [h, b] = np.histogram(values, bins=10, range=(minimum, maximum))
            d = str(min(max(-int(np.log10(max(abs(minimum), maximum))-4),0),3))

            print "    |"+("{:^ 6d}|"*10).format(*list(h)).replace(" 0", "--")
            print "" + ((" {:^+6." + d + "f}") * 11).format(*list(b))

        else:
            # h : histogram value array, b : histogram bins array, d : decimals
            [h, b] = np.histogram(values, bins=7, range=(minimum, maximum))
            d = str(min(max(-int(np.log10(max(abs(minimum), maximum))-6),0),5))

            print "       |"+("{:^ 8d}|"*7).format(*list(h)).replace(" 0","--")
            print "   " + ((" {:^+8." + d + "f}") * 8).format(*list(b))

    def statistics(self, name, values, formatter=":{:>+0.6f}, ", display=True,
                   which=["min", "mean", "max", "cov"]):
        """Prints out a small selection of statistics about the values."""
        import numpy as np
        line = ""
        def cat(string, name, value):
            return string + name + formatter.format(value)

        for item in which:
            line = { "std": cat(line, item, np.std(values)),
                     "cov": cat(line, item, np.std(values) / np.mean(values)),
                     "var": cat(line, item, np.var(values)),
                     "med": cat(line, item, np.median(values)),
                     "min": cat(line, item, np.amin(values)),
                     "max": cat(line, item, np.amax(values)),
                     "mean": cat(line, item, np.mean(values)) }[item]
        if display:
            self.description(name, line[:-1])
        else:
            return line[:-2]


if __name__ == "__main__":

    shell = Shell()
    shell.heading("This is a test of the shell class")
    shell.newline()
    shell.subheading("Beginning indent test")
    shell.say("Test of indent level 0")
    shell.increase_indent()
    shell.say("Test of indent level 1")
    shell.increase_indent()
    shell.say("Test of indent level 2")
    shell.decrease_indent()
    shell.say("Test of indent level 1")
    shell.subheading("Beginning message tests")
    shell.set_indent(0)
    shell.error("Error Test")
    shell.warn("Warning Test")
    shell.alert("About to start histogram tests.")
    #shell.pause()

    import numpy as np
    shell.histogram(list(np.random.randn(10000)*10000)); shell.newline()
    shell.histogram(list(np.random.randn(10000)*100)); shell.newline()
    shell.histogram(list(np.random.randn(10000)*1)); shell.newline()
    shell.histogram(list(np.random.randn(10000)*0.01)); shell.newline()

    shell.statistics("Some Values", list(np.random.randn(100)*2.0))
