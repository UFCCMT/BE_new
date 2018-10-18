#! /usr/bin/env python

"""
  Top-level simulator file, as part of scalable simulator.

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

import time
from math import copysign, ceil
from collections import defaultdict
from multiprocessing import Pool, Value, Array


# Avoiding unwieldy import; but everything from common is in UPPERCASE.
from source.common import *

from source.shell import Shell
from source.router import Router
from source.lookup import Librarian
from source.structure import Designer
from source.framework import Environment
from compiler import Compiler, Instruction
from source.processes import Routine, Message, Executor
from source.containers import ( InputProcrastinator,
                                OutputProcrastinator,
                                RandomProcrastinator,
                                AttributeProcrastinator,
                                ChangeTemplate,
                                TimeoutTemplate,
                                ConditionTemplate )


# --------------------------------------------------------------------------- #
# --------------------------- Primary Definitions --------------------------- #
# --------------------------------------------------------------------------- #

class Simulator(object):

    def __init__( self, shell, programDirectory, lookupDirectory, interpolator,
                  probeGIDs, probeOrdinals, probeStates, showPrinting ):
        """The Simulator is the simulation manager."""

        self.shell = shell
        self.programDirectory = programDirectory
        self.lookupDirectory = lookupDirectory
        self.interpolator = interpolator

        self.gProbes = probeGIDs
        self.sProbes = probeStates
        self.oProbes = probeOrdinals
        self.pProbes = showPrinting

        # Initialize the setup parameters.
        self.programs = {}
        self.indicators = {}
        self.mailboxes = defaultdict(list)
        self.attributes = defaultdict(list)
        self.operations = defaultdict(dict)

        # Initialize the assistants
        self.librarian = Librarian(scheme=interpolator)
        self.designer = Designer(self)
        self.compiler = Compiler()

        # The component setup 'properties' are shared between the two.
        self.properties = self.designer.properties

        # This is the 'instrumentation' time.
        self.t = lambda : self.environment.time


    # -------------------- Public Control-Flow Functions -------------------- #

    def build(self):
        """Create the structure of the simulation."""
        self.layout = self.designer.build()
        self.router = Router(self.layout)

        # Build a list of all probed GIDs (by adding the ordinal probes)
        self.ogProbes = self.gProbes + [ self.layout.ordinals[o]
                                         for o in self.oProbes ]

    def reset(self):
        """(Re)set the state, but not structure, of the simulation."""

        def getter(x, y): return x[y]
        def setter(x, y, z): x[y] = z

        self.environment = Environment(setter, getter)

        # Reset the simulation state.
        self.software, self.hardware = [], []

        # Re-initialize the simulation state.
        for gid in self.layout.gids():

            kind = self.layout.kinds[gid]

            # Set up any software associated with this part.
            if kind in self.programs:

                # Get the associated program.
                prog = self.compiler.load( self.programDirectory +
                                           self.programs[kind] )

                # Determine if this executor should do run-time logging.
                shown = gid in self.ogProbes

                # Determine if it should show its print statements too.
                printing = self.layout.rordinals[gid] in self.pProbes

                # Assign it a PID string.
                pid = PID(PID_EXECUTOR_PREFIX)

                # Add it to the software state list.
                self.software.append( Executor(gid, pid, self.shell, shown,
                                               printing, self.t, self, prog) )

            # The hardware state is just the named attributes.
            self.hardware.append( dict(self.attributes[kind]) )

        for executor in self.software:
            self.environment.enroll(executor)

    def run(self, timeCap, wallCap, eventCap):
        """Run the simulation, subject to some limitations."""
        self.environment.run(timeCap, wallCap, eventCap)


    # --------------------- Internally-Called Functions --------------------- #

    def _lookup_(self, kind, operation, inputs):
        """Determine the outputs and templates of an operation."""

        # Look up the operation for this component type and operation name.
        filename, templates = self.operations[kind][operation]

        # Get the (maybe interpolated) outputs if there was a file to look up.
        outputs = (
            self.librarian.lookup(self.lookupDirectory + filename, inputs)
            if filename else None )

        return outputs, templates

    def _route_(self, message):
        """Determine where a Message should go and what to do at each hop."""

        # Find every GID from source to target.
        gids = self.router.path(message.source, message.target)

        # Keep track of the routines to do at each GID.
        routineses = []

        for i, gid in enumerate(gids):

            # This is the list of routines to do just at this GID.
            routines = []

            kind = self.layout.kinds[gid]

            # Add to the routines based on the mailboxes for this type.
            for operation, function, targets in self.mailboxes[ kind ]:

                # Determine which things this mailbox gets run on.
                onSource, onMiddle, onTarget = targets

                if ( (i == 0 and onSource)                  # Source
                     or (i == len(gids) - 1 and onTarget)   # Target
                     or (i < len(gids) - 1 and onMiddle) ): # Middle

                    # Determine the routine inputs from the mailbox function.
                    inputs = function( message.source, message.target,
                                       message.size, message.tag )

                    # Look up the outputs and templates.
                    outputs, templates = self._lookup_(kind, operation, inputs)

                    # Determine if this Routine should do run-time logging.
                    shown, plotted = gid in self.ogProbes, gid in self.sProbes

                    # Add the new routine.
                    routines.append( Routine( gid, PID(PID_ROUTINE_PREFIX),
                                              self.shell, shown, plotted,
                                              self.t, self.hardware[gid],
                                              inputs, outputs, templates ) )

            # Add the set of routines for this GID to the whole list.
            routineses.append(routines)

        return zip(gids, routineses)

    def _obtain_(self, executor, name):
        """Give an Executor the property it asks for."""

        # Find the kind of object the Executor is operating on.
        kind = self.layout.kinds[executor.gid]

        index =  ( self.layout.indices[executor.gid]
                   if executor.gid in self.layout.indices else None)

        # Determine and evaluate the property of interest.
        return self.properties[kind][name]( executor.gid,
                                            self.layout.cids[executor.gid],
                                            self.layout.tallies[kind],
                                            index )

    def _call_(self, executor, target, operation, *inputs):
        """Give an Executor a Routine based on a call instruction."""

        # Find the GID and type of the thing that runs the routine.
        targetGID = self.layout.relations[executor.gid][target]
        kind = self.layout.kinds[targetGID]

        # Find the parameters of the Routine.
        outputs, templates = self._lookup_(kind, operation, inputs)

        # Determine if this Routine should do run-time logging.
        shown, plotted = targetGID in self.ogProbes, targetGID in self.sProbes

        # Build and return the Routine.
        return Routine( targetGID, PID(PID_ROUTINE_PREFIX), self.shell,
                        shown, plotted, self.t, self.hardware[targetGID],
                        inputs, outputs, templates )

    def _comm_(self, executor, operation, size, ranks, tag):
        """Give an Executor some Messages based on a comm instruction."""

        # Determine the ordinal of the Executor's component.
        source = self.layout.rordinals[executor.gid]

        # Send (one-to-one) is the only currently-supported comm operation.
        if operation == SEND:

            # Determine if this Message should do run-time logging.
            shown = executor.gid in self.ogProbes

            # Build and return the Message.
            return [ Message( executor.gid, PID(PID_MESSAGE_PREFIX),
                              self.shell, shown, self.t, self._route_,
                              source, ranks, size, tag ) ]

    def _prog_(self, executor, filename):
        """Give an Executor another Executor based on a prog instruction."""

        # Determine if this Executor should do run-time logging.
        shown = executor.gid in self.ogProbes

        # Build and return the Executor.
        return Executor( executor.gid, PID(PID_EXECUTOR_PREFIX), self.shell,
                         shown, self.allowPrinting, self.t, self,
                         self.compiler.load(self.programDirectory + filename) )



# --------------------------------------------------------------------------- #
# ------------------------- Management Definitions -------------------------- #
# --------------------------------------------------------------------------- #

def new(args, shell):
    """Make and configure a new Simulator object."""

    sim = Simulator( shell, args.programDirectory, args.lookupDirectory,
                     args.interpolator, args.probeGIDs, args.probeOrdinals,
                     args.probeStates, args.showPrinting )

    # ----------------- Namespace Mapping for Configuration ----------------- #

    Root = sim.designer.root
    Mailbox = sim.designer.mailbox
    Program = sim.designer.program
    Ordinal = sim.designer.ordinal
    Property = sim.designer.property
    Relation = sim.designer.relation
    Component = sim.designer.component
    Offspring = sim.designer.subcomponent
    Attribute = sim.designer.attribute
    Operation = sim.designer.operation

    Cube = sim.designer.cube
    Tree = sim.designer.tree
    Mesh = sim.designer.mesh
    Torus = sim.designer.torus
    Single = sim.designer.one

    Modify = ChangeTemplate
    Dawdle = TimeoutTemplate
    Loiter = ConditionTemplate

    Inputs = InputProcrastinator
    Outputs = OutputProcrastinator
    AnyOutput = RandomProcrastinator
    Values = AttributeProcrastinator

    NoLookup = None
    OnEndpoints = (True, False, True)
    OnMiddle    = (False, True, False)
    OnAll       = (True, True, True)
    OnSource    = (True, False, False)
    OnNonSource = (False, True, True)
    OnTarget    = (False, False, True)
    OnNonTarget = (True, True, False)

    # ---------------------- Run the Configuration File --------------------- #

    execfile(args.config)

    return sim


# ------------------------- Batch-Running Functions ------------------------- #

# "Star operator" wrapper: needed for cPickle to work properly.
def _sequential(_a): return sequential(*_a)

def sequential(args, count, suppressed):
    """Perform a sequential simulator batch run."""

    # Set up the simulator and shell.
    shell = Shell(suppress=suppressed, verbose=args.verbose)
    sim = new(args, shell)

    # ------------------------ Set Up the Simulation ------------------------ #

    shell.subheading("Preparing Simulation")

    tA = time.time(); sim.build(); tB = time.time()

    shell.say(NOTE_TIME.format("Structure Generated", tB - tA))

    # -------------------- Print Out Component Information ------------------ #

    shell.increase_indent()
    shell.newline(verbose=True)
    shell.say("Components:", verbose=True)

    components = sorted(sim.layout.tallies.items(), key=lambda x: x[1])
    gids = defaultdict(str)

    # Make the header for the component table.
    shell.newline(verbose=True)
    shell.say(NOTE_COMPONENT_HEADER, verbose=True)
    shell.say(NOTE_COMPONENT_RULE, verbose=True)

    for kind, number in components:

        # Find the first few GIDs for each type of component:
        for gid, _kind in enumerate(sim.layout.kinds):

            # Add to the string if we havent grabbed enough of them yet.
            if _kind == kind and len( gids[kind] ) < (GID_WIDTH - 6):
                gids[kind] += (" " + str(gid))

        # Make and show the appropriate strings.
        kindstr = kind.ljust(KIND_WIDTH)
        gidstr = gids[kind].ljust(GID_WIDTH)

        shell.say(NOTE_COMPONENT.format(number, kindstr, gidstr), verbose=True)

    shell.say(NOTE_COMPONENT_RULE, verbose=True)
    shell.decrease_indent()

    # ------------------------- Perform the Batch Run ----------------------- #

    times = []

    shell.subheading("Starting Simulation")

    for i in range(count):

        shell.say(NOTE_RUN.format(i))
        shell.increase_indent()

        # -------------------- Set the Simulation State --------------------- #

        tA = time.time(); sim.reset(); tB = time.time()

        shell.say(NOTE_TIME_IND.format("State Intialized", tB-tA),verbose=True)

        # ------------------------- Perform a Run --------------------------- #

        shell.increase_indent(); tA = time.time()
        sim.run(args.time, args.real, args.events)
        shell.decrease_indent(); tB = time.time()

        # ------------------- Print Out Run Information --------------------- #

        times.append(sim.environment.time)
        events = len(sim.environment.previous)
        keps = str(events / 1000.0 / (tB - tA))[:5]

        shell.say(NOTE_TIME_IND.format("Run Complete", tB - tA), verbose=True)
        shell.say(NOTE_SIM_TIME.format(times[-1]))
        shell.say(NOTE_SIM_EVENTS.format(events), verbose=True)
        shell.say(NOTE_SIM_SPEED.format(keps), verbose=True)

        shell.decrease_indent()
        shell.newline()

    shell.subheading("Simulation Complete")

    return times


def parallel(args, processes):
    """Perform a prallelized batch run. Maybe round the count up."""

    pool = Pool(processes=processes)

    # Give each process the correct number of runs, and only allow
    # the first process to print.
    times = pool.map( _sequential, [
        ( args, int(ceil(float(args.count) / processes)),
          args.silent if i==0 else True ) for i in range(processes) ] )

    # Flatten the times from each run.
    return [a for b in times for a in b]


# Top level function:

def run(args):
    """Wrapper with more printing and information for the running functions."""

    # Make our own shell for assorted other printing.
    shell = Shell(suppress=args.silent)

    # If this is a process-parallel (monte carlo) batch run:
    if args.parallel > 1:

        shell.subheading("Parallel Run: Viewing 1 of {}".format(args.parallel))
        times = parallel(args, args.parallel)

    # Oherwise, use the sequential routine.
    else:
        times = sequential(args, args.count, args.silent)

    # Optionally produce an output file.
    if args.output:
        with open(args.output, 'wb') as out:
            out.write("\n".join([repr(item) for item in times]))

        shell.say("Simulated times written to '{}'".format(args.output))

    # The statistics always be shown if the flag is enabled.
    if args.statistics:
        shell = Shell()
        shell.subheading("Simulation Time Histogram")
        shell.histogram(times, coarse=True)
        shell.newline()
        shell.statistics("Statistics", times)


if __name__ == "__main__":

    import argparse

    # ------------------------ Argument Parser Setup ------------------------ #

    ap = argparse.ArgumentParser()
    ap.add_argument('config')

    # File-related arguments
    ap.add_argument('-PD', '--programDirectory', default="./programs/",
                    help="location of programs")

    ap.add_argument('-LD', '--lookupDirectory', default="./lookup/",
                    help="location of models")

    ap.add_argument('-o', '--output', default=None,
                    help="output log file name")

    # Assorted arguments
    ap.add_argument('-p', '--profile', action='store_true',
                    help="profile the simulator")

    ap.add_argument('-q', '--statistics', action='store_true',
                    help="print various statistics")

    ap.add_argument('-i', '--interpolator', default="linear",
                    help="model interpolation method")

    # Run-time analysis arguments
    ap.add_argument('-G', '--probeGIDs', nargs="*", type=int, default=[],
                    help="GIDs to watch")

    ap.add_argument('-O', '--probeOrdinals', nargs="*", type=int, default=[],
                    help="ordinals to watch")

    ap.add_argument('-S', '--probeStates', nargs="*", type=int, default=[],
                    help="GIDs to view state")

    ap.add_argument('-P', '--showPrinting', nargs="*", type=int, default=[],
                    help="ordinals to allow printing")

    # Execution-related arguments
    ap.add_argument('-n', '--count', default=1, type=int,
                    help="number of times to run the simulation")

    ap.add_argument('-N', '--parallel', default=1, type=int,
                    help="number of parallel processes")

    ap.add_argument('-e', '--events', default=None, type=int,
                    help="approximate event limit")

    ap.add_argument('-t', '--time', default=None, type=float,
                    help="approximate simulated time limit")

    ap.add_argument('-r', '--real', default=None, type=float,
                    help="approximate real time limit")

    # Verbosity arguments.
    ap.add_argument('-v', '--verbose', action='store_true',
                    help="verbose command line output")

    ap.add_argument('-s', '--silent', action='store_true',
                    help="suppress command line output")

    # Acceleration/enhancement arguments.
    ap.add_argument('--cacheSoftwareStates', action='store_true',
                    help="enable software state caching")


    args = ap.parse_args()

    # If we're profiing, make and print out a stats file after the run.
    if args.profile:
        import cProfile, pstats

        cProfile.run('run(args)', 'profile.dump')
        stats = pstats.Stats('profile.dump')

        shell = Shell()
        shell.subheading("Profiler Results (Top 30)")
        stats.strip_dirs().sort_stats('time').print_stats(30)

    # Otherwise, just run it as is.
    else: run(args)
