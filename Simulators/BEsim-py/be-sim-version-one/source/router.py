"""
  Network Router, as part of scalable simulator.

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

from math import copysign

# Avoiding unwieldy import; but everything from common is in UPPERCASE.
from common import *


class Router(object):

    def __init__(self, layout, policies=DEFAULT_ROUTING_POLICIES):
        """The Router handles finding paths between objects."""

        self.layout = layout
        self.policies = policies

        # Keep already-computed routes handy.
        self.cache = {}

        # Create an n-sized identity list with entries that have the sign of x.
        self.ident = lambda n, x: [ [ int(copysign(1, x)) if a == b else 0
                                      for a in range(n)]
                                    for b in range(n) ]

        # Add two index-like items.
        self.add = lambda a, b: tuple(y + x for x, y in zip(a, b))

        # Subtract two index-like items.
        self.sub = lambda a, b: tuple(y - x for x, y in zip(a, b))

        # Torus-specific: add index-like items (addition modulo size):
        self.torusAdd = lambda a, b, sizes: (
            tuple( (y + x) % z for x, y, z in zip(a, b, sizes) )
        )

        # Torus specific: subtract index-like items, that is, for a
        # difference 'd' and size 's', torusSub does:
        #
        #   d IF |d| <= s / 2 ELSE ( |d| - s ) * SIGNUM(s)
        #
        # This means that if the number of hops is equal going forward
        # and backward around the torus, the message will be routed in the
        # forward direction. To choose backward-priority, make "<=" into "<".

        self.torusSub = lambda a, b, sizes: (
            tuple( ( x if abs(x) <= sizes[i] / 2
                     else int( copysign(abs(x) - sizes[i], -x) ) )
                   for i, x in enumerate( self.sub(a, b) ) )
        )

        # Return a list of (shortest) atomic differences between indexes.
        self.deltas = lambda a, b: (
            [ [ self.ident(len(a), d)[i] ] * abs(d)
              for i, d in enumerate( self.sub(a, b) ) ]
        )

        # Same as above, but for torus networks.
        self.torusDeltas = lambda a, b, sizes: (
            [ [ self.ident(len(a), d)[i] ] * abs(d)
              for i, d in enumerate( self.torusSub(a, b, sizes) ) ]
        )

    def prep(self, source, target):
        """Prepare to route a path by finding the bookends."""

        # Determine the lowest-level object which contains both.
        scope = self.layout.parents[self.layout.ordinals[source]]

        while target not in self.layout.subordinals[scope]:
            scope = self.layout.parents[scope]

        # Start the path with the GID of the source and target.
        forward = [self.layout.ordinals[source]]
        reverse = [self.layout.ordinals[target]]

        # Walk up to the scope on both sides.
        while forward[-1] not in self.layout.children[scope]:
            forward.append(self.layout.parents[forward[-1]])

        while reverse[-1] not in self.layout.children[scope]:
            reverse.append(self.layout.parents[reverse[-1]])

        # Read the name and size of the network of interest.
        netname = self.layout.netnames[forward[-1]]
        netsize = self.layout.netsizes[forward[-1]]

        return forward, reverse, netname, netsize

    def path(self, source, target):
        """Return a list of components along a path from source to target."""

        # Check to see if this route has already been computed.
        if (source, target) in self.cache:
            return self.cache[(source, target)]

        maxordinal = len(self.layout.ordinals)

        if source < 0: source = source + maxordinal
        if source >= maxordinal: source = source - maxordinal

        if target < 0: target = target + maxordinal
        if target >= maxordinal: target = target - maxordinal

        # Check to see if this is a valid route:
        if ( not (source in self.layout.ordinals) or
             not (target in self.layout.ordinals) or
             source == target ):
            raise RuntimeError(ERR_UNROUTABLE.format(source, target))

        forward, reverse, netname, netsize = self.prep(source, target)

        # These are the indices of the things that actually get routed.
        start = self.layout.indices[forward[-1]]
        end = self.layout.indices[reverse[-1]]

        # Mesh, Cube, and Torus networks are routed in similar ways.
        if netname in [MESH, CUBE, TORUS]:

            # Find the atomic differences between the indices.
            deltas = ( self.deltas(start, end) if netname in [MESH, CUBE]
                       else self.torusDeltas(start, end, netsize) )

            # Reorder the differences depending on how we want to route.
            deltas = {
                "first-to-last":     deltas,
                "last-to-first":     deltas[::-1],
                "shorter-to-longer": sorted(deltas, key=len),
                "longer-to-shorter": sorted(deltas, key=len, reverse=True)
            } [ self.policies[netname] ]

            # Start the traversal route on the forward side.
            across = [ start ]

            # Progressively build the traversal route:
            for direction in deltas:

                # Each delta is just an atomic difference of one index.
                for delta in direction:

                    # Add the delta to the last index and append it.
                    across.append(
                        self.add(across[-1], delta) if netname in [MESH, CUBE]
                        else self.torusAdd(across[-1], delta, netsize) )

        # Tree routing is different than the others.
        elif netname in [TREE]:

            # Initialize the tree traversals with each end.
            ascent, descent = [start], [end]

            # Keep appending to each until they are at the same point.
            while ascent[-1] != descent[-1]:
                ascent.append(ascent[-1][:-1])
                descent.append(descent[-1][:-1])

            # Reverse the descent, remove the common point, and glue them.
            across = ascent + descent[::-1][1:]

        # Now, because 'across' is just indices, identify the components that
        # need to be traversed for those indices, and add them to 'forward'.
        for item in across[1:]:

            # Find the relevant edge by searching:
            edges = self.layout.edges[forward[-1]]
            for other, bond in edges:

                # If we found the right one, add it and move on:
                if self.layout.indices[other] == item:
                    forward.append(bond)
                    forward.append(other)
                    break

        # Remove the common point, reverse 'reverse', and glue them together.
        return forward + reverse[::-1][1:]
