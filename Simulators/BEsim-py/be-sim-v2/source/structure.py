"""
  Structure and layout defitions, as part of scalable simulator.

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
from copy import copy, deepcopy
from itertools import repeat

# Avoiding unwieldy import; but everything from common is in UPPERCASE.
from common import *

# --------------------------------------------------------------------------- #
# ------------------------ Setup and Type Definitions ----------------------- #
# --------------------------------------------------------------------------- #

# Convert nested lists to a flat list:
flatten = lambda x: ( flatten( [a for b in x for a in b] )
                      if isinstance(x[0], list) else x )

class Node(object):

    def __init__(self, index=None):
        """A Node is a nearly-empty temporary storage type."""
        self.index = index

    def __repr__(self):
        """Create a string representation of the node."""
        return str(self.index)


# --------------------------------------------------------------------------- #
# -------------------- Construction Utility Definitions --------------------- #
# --------------------------------------------------------------------------- #

def tree(ns, es, sizes):
    """Create a tree structure of routing indices and edges."""

    def recurse(nodes, edges, parent, remaining):

        # Get the types and size for this level.
        n, e, size = remaining.pop(0)

        # Construct the leaf node types and indices.
        leaves = [ (n, TREE, sizes, Node(parent.index + (i,)))
                   for i in range(size) ]
        nodes.extend(leaves)

        # Make a connection between each leaf node and the parent.
        edges.extend([(e, TREE, sizes, (parent, i)) for _, _, _, i in leaves])

        # If there's still work to be done, drop to the next level.
        if remaining:
            for leaf in leaves:
                recurse(nodes, edges, leaf[-1], copy(remaining))

    sizes = tuple(sizes)

    # Construct the root node.
    nodes, edges = [(ns.pop(0), TREE, sizes, Node((0,)) )], []

    # Build the tree.
    recurse(nodes, edges, nodes[0][-1], zip(ns, es, sizes))

    return nodes + edges

def glue(things, wrap=False):
    """Glue together (link across one dimension) a list of objects."""

    edges = []

    for thing in things[ (0 if wrap else 1): ]:

        # Get the left-adjacent thing.
        other = things[ things.index(thing) - 1 ]

        # If we aren't at the lowest level yet, recurse with the pair.
        if isinstance(thing, list):
            for pair in zip(thing, other):
                edges.extend( glue(pair) )

        # If we are at the lowest level, connect this pair.
        else: edges.append( (thing, other) )

    return edges

def assign(things, indices=()):
    """Assign routing indices to each element in a block."""

    for i, thing in enumerate(things):

        # Calculate the current index.
        current = indices + ( i, )

        # If we aren't at the bottom, recurse with the current index.
        if isinstance(thing, list): assign( thing, current )
        else:                       thing.index = current

    return things

def block(n, e, sizes, wrap):
    """Create a multi-dimensional block of routing indices and edges."""

    # Build the first dimension.
    block = [ Node() for _ in range(sizes[-1]) ]
    edges = glue(block, wrap=wrap)

    # Progressively build the other dimensions by duplication.
    for size in reversed(sizes[:-1]):

        # Duplicate the previous dimension.
        copies = [deepcopy( (block, edges) ) for _ in range(size)]

        # Unpack the duplication.
        block = [item[0] for item in copies]
        edges = flatten( [item[1] for item in copies] )

        # Add the new connections.
        edges.extend( glue(block, wrap=wrap) )

    # Sort everything by index (of the first item for edges).
    block = sorted(flatten(assign(block)), key=lambda x: x.index)
    edges = sorted(edges, key=lambda x: x[0].index)

    # Zip names and sizes to each thing and then return nodes + edges.
    N, S = repeat(TORUS if wrap else MESH), repeat(tuple(sizes))

    return zip(repeat(n), N, S, block) + zip(repeat(e), N, S, edges)

def cube(n, e, degree):
    """Create a hypercube of routing indices and edges."""

    # Start with a zero-dimensional hypercube.
    cube, edges = Node(), []

    # Progressively double and glue new dimensions.
    for _ in range(degree):

        # Create a duplicate of the previous dimension.
        new = [deepcopy((cube, edges)), deepcopy((cube, edges))]

        # Unpack the duplicate.
        cube, edges = [new[0][0], new[1][0]], new[0][1] + new[1][1]

        # Add the new connections.
        edges.extend( glue(cube) )

    # Sort everything by index (of the first item for edges).
    cube = sorted(flatten(assign(cube)), key=lambda x: x.index)
    edges = sorted(edges, key=lambda x: x[0].index)

    # Zip names and sizes to each thing and then return nodes + edges.
    N, S = repeat(CUBE), repeat(degree)

    return zip(repeat(n), N, S, cube) + zip(repeat(e), N, S, edges)


# --------------------------------------------------------------------------- #
# --------------------------- Primary Definitions --------------------------- #
# --------------------------------------------------------------------------- #

class Designer(object):

    def __init__(self, simulator):
        """The Designer is most of the the configuration-file interface."""

        self.simulator = simulator

        self.ordinals = {}
        self.mailboxes = {}
        self.components = {}
        self.relations = defaultdict(list)
        self.properties = defaultdict(dict)

        self.system = None

    # ----------------------- User-Accessable Functions --------------------- #

        self.torus = lambda n, e, s:  block(n, e, s, True)
        self.mesh = lambda n, e, s:   block(n, e, s, False)
        self.tree = lambda ns, es, s: tree(ns, es, s)
        self.cube = lambda n, e, d:   cube(n, e, d)
        self.one = lambda n:          [(n, None, [], Node())]

    def root(self, kind):
        """Define the root component of a system."""
        self.system = kind

    def component(self, kind):
        """Define a new component template from a name."""
        self.components[kind] = []

    def subcomponent(self, parent, children):
        """Give one of the templates a group of children."""
        self.components[parent].extend(children)

    def mailbox(self, kind, operation, operands, targets):
        """Give a component a mailbox."""
        self.simulator.mailboxes[kind].append( (operation, operands, targets) )

    def program(self, kind, filename):
        """Give a component template a program."""
        self.simulator.programs[kind] = filename

    def ordinal(self, kind, name):
        """Give a component template a routing index (a named property)."""
        self.ordinals[kind] = name

    def property(self, kind, name, value):
        """Give a component template a property."""
        self.properties[kind][name] = value

    def relation(self, kind, other, name, relation):
        """Give a component template a relationship to another."""
        self.relations[kind].append( (other, name, relation) )

    def attribute(self, kind, name, initial):
        """Give a component template an attribute with initial value."""
        self.simulator.attributes[kind].append( (name, initial) )

    def operation(self, kind, name, filename, degree, *templates):
        """Give a component template an operation."""
        self.simulator.operations[kind][name] = (filename, templates, degree)

    def build(self):
        """Construct the layout from provided parameters."""
        return Layout( self.system, self.components, self.properties,
                       self.ordinals, self.relations )


class Layout(object):

    def __init__(self, root, components, properties, ordinals, relations):
        """The Layout contains the structure of a system."""

        # Things which many or all components have:
        self.cids = []
        self.kinds = []
        self.edges = []
        self.parents = []
        self.children = []

        # Things which only some components have:
        self.indices = {}                     # { gid: (index, ...), ... }
        self.netnames = {}                    # { gid: network, ... }
        self.netsizes = {}                    # { gid: [size, ...], ... }
        self.ordinals = defaultdict(lambda: None)     # { ordinal: gid, ... }
        self.rordinals = defaultdict(lambda: None)    # { gid: ordinal, ... }
        self.subordinals = defaultdict(list)  # { gid: [ordinal, ...], ... }
        self.relations = defaultdict(dict)    # { gid: {"name": gid ...}, ... }

        self.gids = lambda : range(len(self.cids))

        # Relationship utility functions: return all GIDs which are ___ of GID.

        # (Parent's Parent's Children)
        self.aunts = lambda gid: self.children[self.parents[self.parents[gid]]]

        # (Parent's Children)
        self.siblings = lambda gid: self.children[self.parents[gid]]

        # Construct the layout from the provided parameters.
        self.build(root, components, properties, ordinals, relations)

    def new(self, cid, kind, parent, edges, children,
            index=None, netname=None, netsize=None):
        """Add a new component to the structure."""

        # The current GID is the length of any of the manditory parameters.
        gid = len(self.cids)

        # Add the new entry to the manditory parameters.
        self.cids.append(cid)
        self.kinds.append(kind)
        self.edges.append(edges)
        self.parents.append(parent)
        self.children.append(children)

        # Optionally add the new entry to the other parameters.
        if index: self.indices[gid] = index
        if netname: self.netnames[gid] = netname
        if netsize: self.netsizes[gid] = netsize

    def build(self, root, components, properties, ordinals, relations):
        """Construct the layout from assorted parameters."""

        # Keep track of how many of each thing we have.
        self.tallies = defaultdict(lambda: 0)

        self.tallies[root] = 1

        # Start the structure with the root node.
        self.new( 0, root, None, [], set() )

        # Helper function: just return the current Global Identifier.
        GID = lambda : len(self.cids) - 1

        def recurse(current):

            # Keep a mapping of index-to-GID so we don't need to search later.
            indices = {}

            # Take note of the parent GID (of each thing in current).
            PGID = GID()

            for kind, netname, netsize, part in current:

                if isinstance(part, Node): # If this part is a Node proper:

                    # Make the entry for this component (sans some properties).
                    self.new( self.tallies[kind], kind, PGID, [], set(),
                              index=part.index, netname=netname,
                              netsize=netsize )

                    # Add this entry to its parents children.
                    self.children[PGID].add( GID() )

                    # Update the mapping.
                    if part.index: indices[part.index] = GID()

                    # If this node should be assigned an ordinal:
                    if kind in ordinals:

                        # Grab the property that determines the ordinal.
                        prop = properties[kind][ordinals[kind]]

                        # Evaluate the property, with incorrect CID totals.
                        ordinal = prop( GID(), self.tallies[kind],
                                        self.tallies[kind], part.index )
                        self.ordinals[ordinal] = GID()
                        self.rordinals[GID()] = ordinal

                        ancestor = PGID

                        # Add this ordinal to every parent, recusively.
                        while ancestor != None:
                            self.subordinals[ancestor].append( ordinal )
                            ancestor = self.parents[ancestor]

                else: # Else it is an edge:

                    # Build the entry for this edge component.
                    self.new( self.tallies[kind], kind, PGID, [], set(),
                              netname=netname, netsize=netsize )

                    # Recall the GIDs of the referenced nodes.
                    AGID, BGID = indices[part[0].index], indices[part[1].index]

                    # Add this entry to its parents children.
                    self.children[PGID].add( GID() )

                    # Insert the (other, edge) references back into the nodes.
                    self.edges[AGID].append( (BGID, GID()) )
                    self.edges[BGID].append( (AGID, GID()) )

                # Update the build count for this type of component.
                self.tallies[kind] += 1

                # Drop down a level to the children of this type of component:
                recurse( components[kind] )

        # Build the structure.
        recurse( components[root] )

        # Now build the relationships:

        # For every entry in the structure:
        for gid in self.gids():

            # For each relation in this type of entry:
            for other, name, relation in relations[self.kinds[gid]]:

                # Construct the search space for the relationship (GID list).
                if relation == SELF:       search = [ gid ]
                elif relation == CHILD:    search = self.children[gid]
                elif relation == PARENT:   search = [ self.parents[gid] ]
                elif relation == SIBLING:  search = self.siblings(gid)
                elif relation == AUNT:     search = self.aunts(gid)

                # Look through the search space for the right kind of thing.
                for s in search:

                    # Once a kind-matched item is found, add it.
                    if self.kinds[s] == other:
                        self.relations[gid][name] = s
                        break

                # If we didn't find any of the right kind of thing, error out.
                else: raise ValueError(
                    ERR_RELATIONSHIP.format(other, relation, self.kinds[gid]))


if __name__ == "__main__":

    # Non-exhaustive feature test:

    print "Tree:\n"
    for name, network, size, node in tree(["A", "B", "C"], ["D", "E"], [2, 3]):
        print name, network, size, node

    print "\nMesh:\n"
    for name, network, size, node in block("A", "B", [2, 2, 2], False):
        print name, network, size, node

    print "\nTorus:\n"
    for name, network, size, node in block("A", "B", [4], True):
        print name, network, size, node

    print "\nCube:\n"
    for name, network, size, node in cube("A", "B", 3):
        print name, network, size, node
