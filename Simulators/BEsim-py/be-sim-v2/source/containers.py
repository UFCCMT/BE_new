"""
  Container type definitions, as part of scalable simulator.

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

from copy import copy, deepcopy

import operator
import random


class Procrastinator(object):

    """
    A Procrastinator is a container which computes its operations later.

    Notes:
      - This works by overloading some select Python operators to just keep
        track of the operator and operand for later use.
      - Docstrings omitted (all these functions do the same class of thing)
      - Only basic arithmetic and comparison operators are implemented.
      - Because the Python parser needs to see these methods, it is unlikely
        that these functions can be defined in a shorter, more dynamic, way.

    Usage:
      - Use the call method, e.g., 'instance(args)', with any arguments that
        a subclass of this Procrastinator requires. The 'value' method will be
        called automatically with those arguments on every child, so it
        should probably be overloaded on any subclasses as requried.
    """

    def __init__(self, initial=None):
        self.initial = initial
        self.operations = []

        # By default, the value of a Procrastinator is its initial argument.
        if not hasattr(self, "value"):
            self.value = lambda *x: self.initial

    def __add__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.add, right) )
        return new

    def __radd__(self, left):
        new = deepcopy(self)
        new.operations.append( (operator.add, left) )
        return new

    def __sub__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.sub, right) )
        return new

    def __rsub__(self, left):
        new = deepcopy(self)
        new.operations.append( (operator.mul, -1) )
        new.operations.append( (operator.add, left) )
        return new

    def __mul__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.mul, right) )
        return new

    def __rmul__(self, left):
        new = deepcopy(self)
        new.operations.append( (operator.mul, left) )
        return new

    def __div__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.div, right) )
        return new

    def __rdiv__(self, left):
        new = deepcopy(self)
        new.operations.append( (operator.pow, -1) )
        new.operations.append( (operator.mul, left ) )
        return new

    def __pow__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.pow, right) )
        return new

    def __eq__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.eq, right) )
        return new

    def __ne__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.ne, right) )
        return new

    def __lt__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.lt, right) )
        return new

    def __le__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.le, right) )
        return new

    def __gt__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.gt, right) )
        return new

    def __ge__(self, right):
        new = deepcopy(self)
        new.operations.append( (operator.ge, right) )
        return new

    def __call__(self, *args):
        """Step back through the operators and calculate the final value."""

        lhs = self.value(*args)

        # The parser should have ensured that these are sorted according
        # to Python's order of operations.
        for op, rhs in self.operations:
            rhs = rhs.value(*args) if isinstance(rhs, Procrastinator) else rhs
            lhs = op(lhs, rhs)

        return lhs


# Procrastinators describe things to be determined at runtime.

# An AttributeProcrastinator gets a named attribute of a component (later).
AttributeProcrastinator = type( "AttributeProcrastinator", (Procrastinator,), {
    "value": lambda s,d,i,o: (d[s.initial]) } )

# An InputProcrastinator gets one of the lookup input arguments (later).
InputProcrastinator = type( "InputProcrastinator", (Procrastinator,), {
    "value": lambda s,d,i,o: i[s.initial] } )

# An OutputProcrastinator gets one of the lookup output arguments (later).
OutputProcrastinator = type( "OutputProcrastinator", (Procrastinator,), {
    "value": lambda s,d,i,o: o[s.initial] } )

# A RandomProcrastinator chooses one of the outputs at random (later).
RandomProcrastinator = type( "RandomProcrastinator", (Procrastinator,), {
    "value": lambda s,d,i,o: random.choice(o) } )


# Event templates store event-creation information, excluding the component.

class ChangeTemplate(object):

    def __init__(self, attribute, value, provision=True):
        """A ChangeTemplate stores the information to make a Change Event."""
        self.attribute, self.value = attribute, value
        self.provision = provision

class TimeoutTemplate(object):

    def __init__(self, value, provision=True):
        """A TimeoutTemplate stores the information to make a Timeout Event."""
        self.value = value
        self.provision = provision

class ConditionTemplate(object):

    def __init__(self, attribute, compare, value, provision=True):
        """A ConditionTemplate stores information to make a Condition Event."""
        self.attribute, self.compare, self.value = attribute, compare, value
        self.provision = provision

class RecvTemplate(object):
    
    def __init__(self, provision=True):
        self.provision = provision

class MsgArvlTemplate(object):
    
    def __init__(self, provision=True):
        self.provision = provision


if __name__ == "__main__":

    # Test many of the container features to make sure things roughly work:

    attributes, inputs, outputs = {"alpha": 10, "beta": 30}, [0, 100], [0.5, 1]

    # Make a few different procrastinators:

    A = AttributeProcrastinator("beta")
    B = InputProcrastinator(0) == 0
    C = OutputProcrastinator(0) * A
    D = (AttributeProcrastinator("alpha") * 10) / InputProcrastinator(1)
    E = RandomProcrastinator()

    # Evaluate their values:

    print A(attributes, inputs, outputs) # Should be 30
    print B(attributes, inputs, outputs) # Should be True
    print C(attributes, inputs, outputs) # Should be 15.0
    print D(attributes, inputs, outputs) # Should be 1
    print E(attributes, inputs, outputs) # Should be 0.5 or 1
