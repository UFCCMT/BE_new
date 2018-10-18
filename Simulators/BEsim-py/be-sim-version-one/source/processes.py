"""
  Process Type Definitions, as part of scalable simulator.

    Copyright (C) 2015 {NSF CHREC, UF CCMT, Dylan Rudolph}

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

from framework import ( Process, Change, Timeout, Condition, Autoprocess,
                        Subprocess, Terminate )

from containers import ( ChangeTemplate, TimeoutTemplate, ConditionTemplate,
                         Procrastinator )

# Avoiding unwieldy import; but everything from common is in UPPERCASE.
from common import *


# --------------------------------------------------------------------------- #
# ---------------------------- Utility Definitions -------------------------- #
# --------------------------------------------------------------------------- #

# Processes call this for any new updates:
def Log(P, S, *A):
    if P.view:
        parent = P.parent.pid if hasattr(P.parent, "pid") else "   --   "
        P.shell.say( S.format( *( (P.gid, P.time(), parent, P.pid) + A ) ) )

# Routines call this to show their state:
def Plot(P, M):
    if P.plot:
        parent = P.parent.pid if hasattr(P.parent, "pid") else "   --   "
        S = M.format(P.gid, P.time(), parent, P.pid,
                     "{}: {}, " * (len(P.state) - 1) + "{}: {}" )
        P.shell.say( S.format( *[x for y in P.state.items() for x in y] ) )

# --------------------------------------------------------------------------- #
# --------------------------- Primary Definitions --------------------------- #
# --------------------------------------------------------------------------- #

class Routine(Process):

    def __init__(self, gid, pid, shell, view, plot, time,
                 state, inputs, outputs, sequence):
        """A Routine is a Process which operates on one component."""
        super(Routine, self).__init__(self.run())

        self.gid = gid             # GID of the thing Routine is working on.
        self.pid = pid
        self.view = view
        self.plot = plot
        self.time = time           # Function that returns simulation time.
        self.shell = shell
        self.state = state         # Reference to state dictionary.
        self.inputs = inputs       # Tuple of integral inputs.
        self.outputs = outputs     # List of float outputs.
        self.sequence = sequence   # List of event templates.

    def run(self):
        """Step through this Routine's templates and build / yield them."""

        def find(value):
            """Determine a value, which could be a Procrastinator or number."""
            return ( value(self.state, self.inputs, self.outputs)
                     if isinstance(value, Procrastinator) else value )

        Log( self, LOG_ROUTINE_STARTED, self.inputs,
             len(self.outputs) if self.outputs else None )

        for template in self.sequence:

            # If this event should be executed:
            if find(template.provision):

                if isinstance(template, ChangeTemplate):

                    value, attribute = find(template.value), template.attribute

                    # Build the event.
                    event = Change( self.state, attribute, value )

                    # Say what's about to happen to the state.
                    Log(self, LOG_ROUTINE_CHANGE, attribute, value)

                    # Change the state.
                    yield event

                    # Say what the new state is.
                    Plot(self, LOG_ROUTINE_STATE_META)

                elif isinstance(template, TimeoutTemplate):

                    value = find(template.value)

                    # Build the event.
                    event = Timeout( value )

                    # Say how long we're about to wait.
                    Log(self, LOG_ROUTINE_TIMEOUT, value)

                    yield event

                    # Say that we're done waiting.
                    Log(self, LOG_ROUTINE_CONTINUE)

                elif isinstance(template, ConditionTemplate):

                    attribute, compare, value = ( template.attribute,
                                                  template.compare,
                                                  find(template.value) )

                    # Build the checking function.
                    check = lambda x: STRING_OPERATORS[compare](x, value)

                    # Build the event.
                    event = Condition( self.state, attribute, check )

                    # Say what we're waiting for.
                    Log(self, LOG_ROUTINE_CONDITION, attribute, compare, value)

                    yield event

                    # Say that we're done waiting.
                    Log(self, LOG_ROUTINE_CONTINUE)

            # If this event should not be executed:
            else:

                # Do nothing but take a note of it.
                Log(self, LOG_ROUTINE_PROVISION)

        Log(self, LOG_ROUTINE_ENDED)


class Message(Process):

    def __init__( self, gid, pid, shell, view, time,
                  router, source, target, size, tag ):
        """A Message is a Process which performs Routines across a network."""
        super(Message, self).__init__(self.run())

        self.gid = gid           # GID of thing that made the Message
        self.pid = pid
        self.view = view
        self.time = time
        self.shell = shell
        self.router = router     # Function which returns next hops
        self.source = source     # Ordinal of source
        self.target = target     # Ordinal of target
        self.size = size         # Integral
        self.tag = tag           # Any type

        # We don't know where we are until the simulator tells us.
        self.location = None

    def run(self):
        """Route the Message through the network and generate routines."""

        Log( self, LOG_MESSAGE_STARTED, self.source, self.target,
             self.size, self.tag )

        # Get as many hops as the router function is willing to provide.
        hops = self.router(self)

        # While we still have hops to go.
        while hops:

            # Get the next hop.
            self.location, routines = hops.pop(0)

            # Conditional console output:
            for routine in routines:
                Log(self, LOG_MESSAGE_UPDATE, self.location, routine.pid)

            # If we need to do a routine here, yield it.
            if routines: yield Subprocess( routines )

            # If we're out of hops, get more. (Adaptive Routing; future work)
            # if not hops: hops = self.simulator.route(self)

        Log(self, LOG_MESSAGE_ENDED)


softwareStateCache = {}

class Executor(Process):

    def __init__(self, gid, pid, shell, view, pview, time, simulator, program,
                 caching=False):
        """An Executor is an abstract software-running machine."""
        super(Executor, self).__init__(self.run())

        self.gid = gid              # GID of thing this Executor is assgined to
        self.pid = pid
        self.view = view
        self.pview = pview          # Print statement viewing.
        self.time = time
        self.shell = shell
        self.simulator = simulator
        self.program = program
        self.caching = caching

        self.instructions = { item: getattr(self, "_" + item + "_")
                              for item in INSTRUCTIONS.lower().split() }

    def run(self):
        """Step through the program and generate events along the way."""

        Log(self, LOG_EXECUTOR_STARTED)

        # Set the state of this executor.
        self.indep, self.simul, self.queue, self.line = False, False, [], 0

        registerType = type('r', (dict,), {'__missing__': lambda y, x: x})
        self.registers = registerType()

        # While we haven't reached the last line in the program:
        while self.line < len(self.program):

            """
            key = (self.program, self.line, self.registers.items())

            if self.caching and key in softwareStateCache:

                self.line, regItems = softwareStateCache(key)
                self.registers = registerType(regItems)
            """

            # Get the next instruction.
            instruction = self.program[ self.line ]

            Log(self, LOG_EXECUTOR_UPDATE, instruction)

            # Run it and see if it made any events.
            event = self.instructions[instruction.kind](*instruction.operands)

            """
            if ( self.caching and
                 not (instruction.kind in UNCACHABLE_INSTRUCTIONS) ):
                softwareStateCache(key) = self.line, self.registers.items
            """

            # If it did, yield those events.
            if event: yield event

            self.line += 1

        Log(self, LOG_EXECUTOR_ENDED)

    # -------------------- Event-Generating Instructions -------------------- #

    def _call_(self, *operands):
        """Generate a Routine."""

        # Dereference each of the operands from the registers.
        operands = [self.registers[item] for item in operands]

        # Get the new Routine from the simulator.
        routine = self.simulator._call_(self, *operands)

        Log(self, LOG_ROUTINE_CREATED, routine.pid, routine.gid)

        # Run it now, unless simul or indep have been called.
        if self.indep or self.simul: self.queue.append( routine )
        else:                        return Subprocess( [ routine ] )

    def _comm_(self, *operands):
        """Generate a Message."""

        # Dereference each of the operands from the registers.
        operands = [self.registers[item] for item in operands]

        # Get the new Message from the simulator.
        messages = self.simulator._comm_(self, *operands)

        for message in messages:
            Log(self, LOG_MESSAGE_CREATED, message.pid)

        # Run it now, unless simul or indep have been called.
        if self.indep or self.simul: self.queue.extend( messages )
        else:                        return Subprocess( messages )

    def _prog_(self, *operands):
        """Generate an Executor."""

        # Get the new Executor from the simulator.
        executor = self.simulator._prog_(self, operands)

        Log(self, LOG_EXECUTOR_CREATED, executor.pid)

        # Run it now, unless simul or indep have been called.
        if self.indep or self.simul: self.queue.append( executor )
        else:                        return Subprocess( [ executor ])

    def _indep_(self):
        """Declare the next 0 or more lines as independent of this Executor."""
        self.indep = True

    def _simul_(self):
        """Declare the next 0 or more lines as concurrent."""
        self.simul = True

    def _begin_(self):
        """Execute the independent or concurrent lines."""

        # If indep was declared:
        if self.indep and not self.simul:

            # Spawn the queue as independent processes, then clear it.
            event = Autoprocess(self.queue)
            self.queue, self.indep = [], False

        # If simul was declared:
        elif self.simul and not indep:

            # Spawn the queue as dependent processes, then clear it.
            event = Subprocess(self.queue)
            self.queue, self.simul = [], False

        else:
            raise RuntimeError(ERR_CONCURRENCY)

        return event

    def _print_(self, string, *things):
        """Print to console, if this executor is being watched."""

        # Strip quotes.
        if string.startswith('"') or string.startswith("'"):
            string = string[1:-1]

        # Make comma separated strings for each thing.
        things = ', '.join([ repr(self.registers[thing]) for thing in things ])

        # Print the text.
        if self.pview: self.shell.say(string + ' ' + things)

    def _obtain_(self, which, name):
        """Set a register value to a named property."""
        self.registers[which] = self.simulator._obtain_(self, name)

    def _assign_(self, which, value):
        """Set a register to a value."""
        self.registers[which] = value

    def _access_(self, which, array, index):
        """Set a register to be an indexed element of an array."""
        self.registers[which] = self.registers[array][self.registers[index]]

    def _target_(self, target):
        """Do nothing (serves as either a no-op or a landing for a 'jump')."""
        pass

    def _jumpeq_(self, left, right, target):
        """Conditionally jump if equal."""
        if self.registers[left] == self.registers[right]:
            self.line = target.line

    def _jumpnq_(self, left, right, target):
        """Conditionally jump if not equal."""
        if self.registers[left] != self.registers[right]:
            self.line = target.line

    def _jumpgt_(self, left, right, target):
        """Conditionally jump if greater than."""
        if self.registers[left] > self.registers[right]:
            self.line = target.line

    def _jumplt_(self, left, right, target):
        """Conditionally jump if less than."""
        if self.registers[left] < self.registers[right]:
            self.line = target.line

    def _jumpng_(self, left, right, target):
        """Conditionally jump if less than or equal."""
        if self.registers[left] <= self.registers[right]:
            self.line = target.line

    def _jumpnl_(self, left, right, target):
        """Conditionally jump if greater than or equal."""
        if self.registers[left] >= self.registers[right]:
            self.line = target.line

    def _add_(self, target, a, b):
        """Assign a register to be the addition of two values."""
        self.registers[target] = self.registers[a] + self.registers[b]

    def _sub_(self, target, a, b):
        """Assign a register to be the subtraction of two values."""
        self.registers[target] = self.registers[a] - self.registers[b]

    def _mul_(self, target, a, b):
        """Assign a register to be the multiplication of two values."""
        self.registers[target] = self.registers[a] * self.registers[b]

    def _div_(self, target, a, b):
        """Assign a register to be the division of two values."""
        self.registers[target] = self.registers[a] / self.registers[b]

    def _mod_(self, target, a, b):
        """Assign a register to be the modulus of two values."""
        self.registers[target] = self.registers[a] % self.registers[b]

    def _inc_(self, target):
        """Increment a register value."""
        self.registers[target] += 1

    def _dec_(self, target):
        """Decrement a register value."""
        self.registers[target] -= 1
