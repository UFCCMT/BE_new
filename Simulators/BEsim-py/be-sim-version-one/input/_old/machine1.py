## BE simulation demo
## Author: Nalini Kumar
## Date: 9-9-2016


# ------- Specifications for Machine1 ------ #
# - Machine has 256 nodes; IB
# - Node has 2 CPU; PCI
# - CPU has 16 cores; on-chip network


# ------ Steps for writing a HW description/BEO ------ #
# For each component:
# 1. Define the component with a name and alias
# 2. Setup with any component-specific parameters
# 3. Define operations(HW routine) that are handled by the component
#    a. Condition: Describes when the operation can be run.
#    b. Events: Describes what happens to the component during the operation.
# 4. Assign operations to the component, along with a model
# 5. Define a program name (Active component) if the component runs a program



import input.cartesian

global cartesianData

cartesianData = input.cartesian.data216



# ----------------------------- CPU Core Setup ------------------------------ #
Component( "cpu-core" )
Program( "cpu-core", "nek-abstract.smc" )

Attribute( "cpu-core", "usage", 0.0 )
Attribute( "cpu-core", "waiting", False )

Operation( "cpu-core", "wait", NoLookup,
           Modify( "waiting", True ),
           Loiter( "waiting", "==", False ) )

Operation( "cpu-core", "unwait", NoLookup,
           Loiter( "waiting", "==", True ),
           Modify( "waiting", False ))

Operation( "cpu-core", "mm", "cab-matmult-12.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )

Mailbox( "cpu-core", "unwait", lambda source, target, size, tag: [],
         OnTarget ) # This mailbox is only applied to the last component.



# ----------------------- On-Chip Connection Setup -------------------------- #
Component( "on-chip-connection" )
Operation( "on-chip-connection", "transfer", "cab-transfer-occ.csv",
           Dawdle( AnyOutput() ) )
Mailbox( "on-chip-connection", "transfer",
         lambda source, target, size, tag: [size], OnAll )
Component( "bus" )



# ------------------------------- CPU Setup --------------------------------- #
Component( "cpu" )
Offspring( "cpu", Tree( ["on-chip-connection", "cpu-core"], ["bus"], [6] ) )



# ------------------------------- QPI Setup --------------------------------- #
Component( "qpi")
Operation( "qpi", "transfer", "cab-transfer-qpi.csv", Dawdle( AnyOutput() ) )
Mailbox( "qpi", "transfer", lambda source, target, size, tag: [size], OnAll )



# ------------------------------- Node Setup -------------------------------- #
Component( "node" )
Offspring( "node", Mesh("cpu", "qpi", [2]) ) # Or linear



# ---------------------------- Intra-node Network Setup --------------------- #
Component( "ib" )



# ------------------------------ System Setup ------------------------------- #
Component( "switch" )
Operation( "switch", "transfer", "cab-transfer-switch-B.csv", Dawdle( AnyOutput() ) )
Mailbox( "switch", "transfer", lambda source, target, size, tag: [size], OnAll )


Component( "system" )
Offspring( "system", Tree( ["switch", "node"], ["ib"], [18] ) )


Root("system")
