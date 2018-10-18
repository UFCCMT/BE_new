"""
  Discrete Event Simulation Framework, as part of scalable simulator.

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

from collections import namedtuple, defaultdict
import time
import copy

# --------------------------------------------------------------------------- #
# ----------------------- Data Structure Definitions ------------------------ #
# --------------------------------------------------------------------------- #

class Process(object):

    def __init__(self, generator):
        """A Process is a node in the process tree."""
        self.generator = generator

        self.parent = None
        self.children = set()

    def next(self):
        """Return the next element from this Process' generator."""
        return self.generator.next()

    def append(self, other):
        """Add a dependent child Process to this Process."""
        self.children.add(other)
        other.parent = self

    def delete(self):
        """Remove this Process from its parent."""
        self.parent.children.remove(self)


# ------------------------- Event Type Declarations ------------------------- #

# A Change event is an atomic state difference.
Change = namedtuple("Change", "thing attribute value")

# A Timeout event pauses the parent process for a fixed time.
Timeout = namedtuple("Timeout", "value")

# A Condition event pauses the parent process until criteria are met.
Condition = namedtuple("Condition", "thing attribute condition")

# An Autoprocess event spawns independent Processes.
Autoprocess = namedtuple("Autoprocess", "processes")

# A Subprocess event adds child Processes to a parent.
Subprocess = namedtuple("Subprocess", "processes")

# A Terminate event ends the simulation.
Terminate = namedtuple("Terminate", [])


# --------------------------------------------------------------------------- #
# --------------------------- Primary Definitions --------------------------- #
# --------------------------------------------------------------------------- #

class Environment(object):

    def __init__(self, setter, getter):
        """An Environment manages events and processes."""

        self.setter, self.getter = setter, getter

        # Set up the master process.
        def end(): yield Terminate()

        self.master = Process(end())

        # Define which function handles each event type.
        self.handlers = { "Change": self._change_,
                          "Timeout": self._timeout_,
                          "Condition": self._condition_,
                          "Subprocess": self._subprocess_,
                          "Autoprocess": self._autoprocess_,
                          "Terminate": self._terminate_ }

        self.time = 0.0

    def running(self):
        """Return True if the simulation should continue."""

        wallTime = time.time() - self.start

        t = self.time < self.timeCap if self.timeCap else True
        w = wallTime < self.wallCap if self.wallCap else True
        e = len(self.previous) < self.eventCap if self.eventCap else True

        return self.upcoming and t and w and e

    def enroll(self, process):
        """Add a new autonomous (independent) process to the simulation."""

        # All processs are children of the master process.
        self.master.append(process)

    def step(self, process):
        """Make a Process generate its next event, if possible."""

        try:

            # If the process hasn't expired, get another event from it.
            event = process.next()

            # Timeouts are special: they are enqueued with a delay.
            delay = event.value if isinstance(event, Timeout) else 0.0

            # Build the entry tuple to be enqueued or watched.
            entry = (self.time + delay, event, process)

            if isinstance(event, Condition):

                value = self.getter(event.thing, event.attribute)

                # If the condition is already met, mark it as having happened.
                if event.condition( value ): self.tick( *entry )

                # Otherwise, add it to the watch list.
                else:
                    self.conditions[ (id(event.thing),
                                      event.attribute) ].append( entry )

            # If the event is anything but a Timeout, don't enqueue it.
            elif not isinstance(event, Timeout): self.tick( *entry )

            # Otherwise, enqueue this event, its time, and its process.
            else:

                # Depending on the queue type, do different operations.
                if self.blist: self.upcoming.add( entry )
                else:          self.upcoming.append( entry )

        except StopIteration:

            # If the process has expired (run out of events), delete it.
            process.delete()

            # If no siblings, allow the parent to continue.
            if not process.parent.children: self.step(process.parent)

            # Let the main loop know that this process is not running.
            process.parent = None

    def tick(self, eventTime, event, eventProcess):
        """Handle one event."""

        # Call one of the event-handling functions based on the event type.
        self.handlers[type(event).__name__](event, eventProcess)

        # This should never happen, just a sanity check.
        if self.time > eventTime:
            raise RuntimeError("Causality violated :: {}".format(event))

        # Advance the simulation time.
        self.time = eventTime

        # Record the event as having happened.
        self.previous.append( (eventTime, event) )

        # If appropriate, continue the event's process.
        if not eventProcess.children and eventProcess.parent:
            self.step(eventProcess)

    def run(self, timeCap=None, wallCap=None, eventCap=None):
        """Perform the simulation until a stop condition is met."""

        # Stop conditions:
        self.timeCap = timeCap
        self.wallCap = wallCap
        self.eventCap = eventCap

        # State Reset:
        self.time = 0.0
        self.start = time.time()

        # Attempt to use the blist package for the event queue.
        try:
            from blist import sortedlist
            self.upcoming = sortedlist([], key=lambda x: -x[0])
            self.blist = True
        except:
            self.upcoming, self.blist = [], False
            print ("Framework: Could not import 'blist' package; falling" +
                   " back to a slower implementation.")

        self.previous = []
        self.conditions = defaultdict(list)

        def walk(process):
            """Walk through a Process tree and step each terminal node."""

            if process.children:

                # Walk backwards through the children, because the children
                # list is not guaranteed to stay the same over iteration.
                for child in copy.copy(process.children):
                    walk(child)
            else:
                self.step(process)

        # Generate initial events from enrolled processes.
        walk(self.master)

        # Main Event Loop:
        while self.running():

            # Sort the queue if not using a sorted type.
            if not self.blist:
                self.upcoming = sorted(self.upcoming, key=lambda x: -x[0])

            # Get the next event, its time, and the process that made it.
            eventTime, event, eventProcess = self.upcoming.pop()

            # Handle this one event.
            self.tick(eventTime, event, eventProcess)


    # ---------------------------- Event Handlers --------------------------- #

    def _change_(self, event, process):
        """Handle a Change event."""

        # Perform the change.
        self.setter(event.thing, event.attribute, event.value)

        key = (id(event.thing), event.attribute)

        # If there are watchers of this thing and attribute:
        if key in self.conditions:

            # Look through all of the watchers.
            for entry in self.conditions[key]:

                # Unpack the entry.
                time, cevent, process = entry

                # If the condition is now met, remove it and handle it.
                value = self.getter(cevent.thing, cevent.attribute)
                if cevent.condition(value):

                    self.conditions[key].remove(entry)
                    self.tick( self.time, cevent, process )

    def _timeout_(self, event, process):
        """Handle a Timeout event."""

        # At handling time, a Timeout event does nothing.
        pass

    def _condition_(self, event, process):
        """Handle a Condition event."""

        # At handling time, a Condition event does nothing.
        pass

    def _subprocess_(self, event, process):
        """Handle a Subprocess event."""

        for subprocess in event.processes:

            # Add the new Process as a child of the calling Process.
            process.append(subprocess)

            # Have the new Process generate an initial event.
            self.step(subprocess)

    def _autoprocess_(self, event, process):
        """Handle an Autoprocess event."""

        for autoprocess in event.processes:

            # Add the new Process as a child of the top-level Process.
            self.master.append(autoprocess)

            # Have the new Process generate an initial event.
            self.step(autoprocess)

    def _terminate_(self, event, process):
        """Handle a Terminate event."""

        self.running = lambda : False


if __name__ == "__main__":
    """Run a contrived test case to make sure the basic features work."""

    # The state of our system can be represented with one number.
    class State(object):
        mangoes = 0

    state = State()

    def mangoAdder():

        # Add a new mango every so often.
        while True:
            print "We've {} Mangoes, let's add one more.".format(state.mangoes)
            yield Change(state, "mangoes", state.mangoes + 1)

            yield Timeout( 1.5 )

    def mangoChecker():

        # Nine mangoes is, of course, too many.
        yield Condition(state, "mangoes", lambda x: x > 8)
        print "Too many Mangoes!"

        # End the simulation.
        yield Terminate()

    def mangoProcessMaker():

        # Spawn the checker in an independent process.
        yield Autoprocess( [ Process(mangoChecker()) ] )
        yield Timeout(4.0)

        # Spawn the adders in a dependent processes.
        yield Subprocess( [ Process(mangoAdder()),
                            Process(mangoAdder()) ] )

    environment = Environment(setattr, getattr)

    environment.enroll( Process(mangoProcessMaker()) )
    environment.run()

    print "Mango limit exceeded at time:", environment.time
