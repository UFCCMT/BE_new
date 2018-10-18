# Example Details:
#   One core with one operation running a program.


# Declare a component by giving it a name.
Component( "xeon-e5-core" )

# Because it's our only component, it is also the root of the system.
Root( "xeon-e5-core" )

# Assign it a piece of software.
Program( "xeon-e5-core", "baby.smc" )

# Relation( source, target, software name, relationship )
#   Or: "xeon-e5-core" is "self" of "xeon-e5-core" and is called its "cpu".
#   Needing this will make more sense for non-trival setups.
Relation( "xeon-e5-core", "xeon-e5-core", "cpu", "self" )

# Attribute( thing, name, initial value )
#   Any component of substance will have attributes, as these are the things
#   which define the hardware state of the system.
Attribute( "xeon-e5-core", "usage", 0.0 )

# Give the core an operation called "fft" that reads from "fft-dummy.csv"
Operation(
    "xeon-e5-core", "fft", "fft-dummy.csv",
    Loiter( "usage", "==", 0.0),           # Loiter: wait until usage is zero.
    Modify( "usage", 1.0 ),                # Modify: change usage to one.
    Dawdle( Outputs(0) ),                  # Dawdle: wait for a fixed time;
    Modify( "usage", 0.0 )                 #         in this case use the first
)                                          #         (column, not row) 'output'
                                           #         of the .csv file.

# Internally, Dawdle, Modify, and Loiter are templates which create:
# Timeout, Change, and Condition Events, respectively.
