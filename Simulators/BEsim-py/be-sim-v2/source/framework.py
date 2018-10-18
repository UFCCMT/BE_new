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
        self.type = "Process"

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

# Recv wait
RecvWait = namedtuple("RecvWait", [])

# Message arrival
MsgArvl = namedtuple("MsgArvl", [])

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

    def __init__(self, setter, getter, trace):
        """An Environment manages events and processes."""

        self.setter, self.getter = setter, getter

        # Set up the master process.
        def end(): yield Terminate()

        self.master = Process(end())

        # Define which function handles each event type.
        self.handlers = { "Change": self._change_,
                          "Timeout": self._timeout_,
                          "Condition": self._condition_,
                          "RecvWait": self._recvwait_,
                          "MsgArvl": self._msgarvl_,
                          "Subprocess": self._subprocess_,
                          "Autoprocess": self._autoprocess_,
                          "Terminate": self._terminate_ }

        self.time = 0.0         

        self.tracefile = trace
        self.trace = {}

        self.messageTable = {}
        self.recvTable = {}

    def generate_trace(self, event, process, endOfEvent, messagePathTrace):

        if endOfEvent:

            if messagePathTrace:
                end_time = self.time
                if process.parent.gid in self.trace:
                    for comm_record in reversed(self.trace[process.parent.gid]): 
                        if comm_record[2][1] == process.parent.uniqueid: comm_record[-1][-1][1][-1] = end_time 

            else:
                end_time = self.time
                if process.gid in self.trace:
                    for call_record in reversed(self.trace[process.gid]):
                        if call_record[2][1] == process.uniqueid: call_record[4][-1] = end_time

        else:

            if messagePathTrace:
                simulator   = process.parent.simulator
                gid         = process.location
                kind        = simulator.layout.kinds[gid]
                linkid      = gid
                start_time  = self.time
                lookupfile  = simulator.operations[kind][simulator.mailboxes[kind][0][0]][0]    # change in case of multiple mailboxes per component
                parameters  = [process.size, process.tag]
                record      = (linkid, [start_time, 0], lookupfile, parameters)

                if process.gid in self.trace:
                    for comm_record in reversed(self.trace[process.gid]):
                        if comm_record[2][1] == process.uniqueid: comm_record[-1].append(record) 

            else:
                instruction = process.program[process.line]
                simulator   = process.simulator
                gid         = process.gid

                if instruction.kind == "call":
                    event_type = instruction.operands[1]
                    parameters = [process.registers[op] for op in instruction.operands[2:]]
                    event_id   = event.processes[0].uniqueid
                    thread_id  = simulator.layout.cids[gid]
                    start_time = self.time
                    lookupfile = simulator.operations[simulator.layout.kinds[gid]][event_type][0]
                    record     = (gid, instruction.kind, [thread_id, event_id], event_type, [start_time, 0], lookupfile, parameters)

                    if gid in self.trace: self.trace[gid].append(record)
                    else                : self.trace.update({gid: [record]}) 

                elif instruction.kind == "comm":
                    sthread_id = simulator.layout.cids[gid]
                    sevent_id  = event.processes[0].uniqueid
                    rthread_id = process.registers[instruction.operands[2]]
                    record     = (gid, instruction.kind, [sthread_id, sevent_id], [rthread_id, 0], [(gid, [self.time, self.time], None, [])])

                    if gid in self.trace: self.trace[gid].append(record)
                    else                : self.trace.update({gid: [record]})
            

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

            # If FPGA trace flag is enabled and if it is an instruction generated event, record the event details.
            if process.type == "Executor":
                if self.tracefile: self.generate_trace(event, process, False, False)  

            elif process.type == "Message":
                if self.tracefile: self.generate_trace(event, process, False, True)   

            #if (isinstance(event, MsgArvl) or isinstance(event, RecvWait)) and process.gid == 16:
            #    import pdb
            #    pdb.set_trace()     

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

            elif isinstance(event, RecvWait):
                executor = process.parent
                msg_source = executor.registers[executor.program[executor.line].operands[3]]
                self_gid = executor.gid
                key = (self_gid, msg_source)

                if key in self.messageTable:

                    if len(self.messageTable[key])!=0: 
                        mentry = self.messageTable[key].pop()
                        time, mevent, mprocess = mentry
                        self.tick( self.time, mevent, mprocess )
                        time, revent, rprocess = entry
                        self.tick( self.time, revent, rprocess )

                    else:
                        rentry = entry
                        rkey = (self_gid, msg_source)
                        if rkey in self.recvTable: self.recvTable[rkey].append(rentry) 
                        else: self.recvTable.update({rkey: [rentry]})
                        
                else:
                    rentry = entry
                    rkey = (self_gid, msg_source)
                    if rkey in self.recvTable: self.recvTable[rkey].append(rentry) 
                    else: self.recvTable.update({rkey: [rentry]})   

            elif isinstance(event, MsgArvl):
                message = process.parent
                msg_source = message.source
                self_gid = process.gid
                key = (self_gid, msg_source)

                if key in self.recvTable:
                    
                    if len(self.recvTable[key])!=0:
                        rentry = self.recvTable[key].pop()
                        time, revent, rprocess = rentry
                        self.tick( self.time, revent, rprocess )
                        time, mevent, mprocess = entry
                        self.tick( self.time, mevent, mprocess )

                    else:
                        mentry = entry
                        mkey = (self_gid, msg_source)
                        if mkey in self.messageTable: self.messageTable[mkey].append(mentry)
                        else: self.messageTable.update({mkey: [mentry]})

                else:
                    mentry = entry
                    mkey = (self_gid, msg_source)
                    if mkey in self.messageTable: self.messageTable[mkey].append(mentry)
                    else: self.messageTable.update({mkey: [mentry]})

         

            # If the event is anything but a Timeout, don't enqueue it.
            elif not isinstance(event, Timeout): self.tick( *entry )

            # Otherwise, enqueue this event, its time, and its process.
            else:
                # Depending on the queue type, do different operations.
                if self.blist: self.upcoming.add( entry )
                else:          self.upcoming.append( entry )

        except StopIteration:

            if process.type == "Routine": 
                if process.parent.type == "Executor" and self.tracefile: self.generate_trace(None, process, True, False)  
                elif process.parent.type == "Message" and self.tracefile: self.generate_trace(None, process, True, True)  

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
        #if self.time > eventTime:
            #raise RuntimeError("Causality violated :: {}".format(event))

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
            if len(self.upcoming) != 0: eventTime, event, eventProcess = self.upcoming.pop()

            # Handle this one event.
            self.tick(eventTime, event, eventProcess)

        if len(self.master.children) != 0:
            import pdb
            pdb.set_trace()


    # ---------------------------- Event Handlers --------------------------- #

    def _change_(self, event, eprocess):
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

    def _recvwait_(self, event, process):

        pass

    def _msgarvl_(self, event, process):

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
