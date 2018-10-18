"""
  A set of functions for text-based user interaction.

    Copyright (C) 2012-2014 Dylan Rudolph

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

class Shell(object):

    def __init__(self, one_indent="- ", shell_prompt="-->"):

        self.one_indent = one_indent
        self.shell_prompt = shell_prompt
        self.error_indicator = "***"
        self.warning_indicator = "*"
        self.instruct_indicator = "---"
        self.space_char = " "
        self.current_indent = 0
        self.indent_string = ""
        self.debug_mode = False

    def set_debug(self, debug=True):
        """ State whether to use print statements from debug mode or not. """
        self.debug_mode = debug

    def set_indent(self, level=0):
        """ Sets the indentation level. """
        try:
            level = int(level)
            self.current_indent = level
        except:
            print "Level must be integer."

    def increase_indent(self):
        """ Increase the indentation level by 1. """
        self.current_indent += 1

    def decrease_indent(self):
        """ Decrease the indentation level by 1. """
        self.current_indent -= 1
        if self.current_indent < 0:
            self.current_indent = 0

    def make_indent_string(self):
        self.indent_string = ""
        for i in range(self.current_indent):
            self.indent_string = self.indent_string + self.one_indent

    def prompt(self, additional_text="", new_lines=0, debug_only=False):
        """ Give the user a prompt and returns what the user typed. """
        if debug_only and not self.debug_mode:
            pass
        else:
            self.make_indent_string()
            for i in range(new_lines):
                print " "
            if additional_text != "":
                print self.indent_string + additional_text
            prompt_text = self.shell_prompt + self.space_char
            user_input = raw_input(prompt_text)

            return user_input

    def error(self, the_text, indent=True, debug_only=False):
        """ Provide the user with text formatted to indicate an error. """
        if debug_only and not self.debug_mode:
            pass
        else:
            self.make_indent_string()
            if indent:
                shown_text = (self.indent_string + self.error_indicator +
                              self.space_char + the_text +
                              self.space_char + self.error_indicator)
            else:
                shown_text = (self.error_indicator + self.space_char +
                              the_text + self.space_char + self.error_indicator)
            print shown_text

    def warn(self, the_text, indent=True, debug_only=False):
        """ Provide the user with text formatted to indicate a warning. """
        if debug_only and not self.debug_mode:
            pass
        else:
            self.make_indent_string()
            if indent:
                shown_text = (self.indent_string + self.warning_indicator +
                              self.space_char + the_text +
                              self.space_char + self.warning_indicator)
            else:
                shown_text = (self.warning_indicator + self.space_char +
                              the_text + self.space_char +
                              self.warning_indicator)
            print shown_text

    def say(self, the_text, indent=True, debug_only=False):
        """ Put some text in the prompt. """
        if debug_only and not self.debug_mode:
            pass
        else:
            self.make_indent_string()
            if indent:
                shown_text = self.indent_string + the_text
            else:
                shown_text = the_text
            print shown_text

    def dashes(self):
        self.say( "----------------------------------------------------" +
                  "--------------------------" )

    def newline(self):
        self.say( " " )

    def instruct(self, the_text, indent=True, debug_only=False):
        """ Give the user an instruction. """
        if debug_only and not self.debug_mode:
            pass
        else:
            self.make_indent_string()
            if indent:
                shown_text = (self.indent_string + self.instruct_indicator +
                              self.space_char + the_text +
                              self.space_char + self.instruct_indicator)
            else:
                shown_text = (self.instruct_indicator + self.space_char +
                              the_text + self.space_char +
                              self.instruct_indicator)
            print shown_text

    def pause(self, indent=True, debug_only=False):
        """ Request that the user press a key to continue. """
        if debug_only and not self.debug_mode:
            pass
        else:
            self.make_indent_string()
            the_text = "Press Enter To Continue...\n"
            if indent:
                raw_input(self.indent_string + the_text)
            else:
                raw_input(the_text)
