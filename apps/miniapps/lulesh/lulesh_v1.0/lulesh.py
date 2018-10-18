import input.data
global rankdata

cores = 8
rankdata = input.data.stuff[cores]


Component( "BGQ-core" )
Program( "BGQ-core", "lulesh.smc" )

Property( "BGQ-core", "app.elementsize", lambda gid, cid, cids, index: 10 )
Property( "BGQ-core", "app.procsperplane", lambda gid, cid, cids, index: 2 )
Property( "BGQ-core", "mpi.commsize", lambda gid, cid, cids, index: cids)
Property( "BGQ-core", "mpi.commRank", lambda gid, cid, cids, index: cid )
def rowmin(g, rank, c, i): return rankdata[rank]["rowmin"]
def rowmax(g, rank, c, i): return rankdata[rank]["rowmax"]
def colmin(g, rank, c, i): return rankdata[rank]["colmin"]
def colmax(g, rank, c, i): return rankdata[rank]["colmax"]
def planemin(g, rank, c, i): return rankdata[rank]["planemin"]
def planemax(g, rank, c, i): return rankdata[rank]["planemax"]
def Zminus(g, rank, c, i): return rankdata[rank]["Zminus"]
def Zplus(g, rank, c, i): return rankdata[rank]["Zplus"]
def Yminus(g, rank, c, i): return rankdata[rank]["Yminus"]
def Yplus(g,rank, c, i): return rankdata[rank]["Yplus"]
def Xminus(g, rank, c, i): return rankdata[rank]["Xminus"]
def Xplus(g, rank, c, i): return rankdata[rank]["Xplus"]
Property( "BGQ-core", "mpi.rowMin", rowmin )
Property( "BGQ-core", "mpi.rowMax", rowmax )
Property( "BGQ-core", "mpi.colMin", colmin )
Property( "BGQ-core", "mpi.colMax", colmax )
Property( "BGQ-core", "mpi.planeMin", planemin )
Property( "BGQ-core", "mpi.planeMax", planemax )
Property( "BGQ-core", "mpi.cartesianZminus", Zminus )
Property( "BGQ-core", "mpi.cartesianZplus", Zplus )
Property( "BGQ-core", "mpi.cartesianYminus", Yminus )
Property( "BGQ-core", "mpi.cartesianYplus", Yplus )
Property( "BGQ-core", "mpi.cartesianXminus", Xminus )
Property( "BGQ-core", "mpi.cartesianXplus", Xplus )
Attribute( "BGQ-core", "usage", 0.0 )
Attribute( "BGQ-core", "waiting", False )
Relation("BGQ-core", "BGQ-core", "cpu", "self")
#Operation( "BGQ-core", "wait", NoLookup,
 #          Modify( "waiting", True ) )
# Operation( "BGQ-core", "unwait", NoLookup,
           # Modify( "waiting", False ))
Operation( "BGQ-core", "Compute1", "Vulcan-Compute1.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "CalcVolForce", "Vulcan-CalcVolForce.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )		   
Operation( "BGQ-core", "CalcAcceleration", "Vulcan-CalcAcceleration.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "ApplyAccBdyCond", "Vulcan-ApplyAccBdyCond.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "CalcVelocity", "Vulcan-CalcVelocity.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "CalcPosition", "Vulcan-CalcPosition.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "CalcKinematics", "Vulcan-CalcKinematics.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "Compute6", "Vulcan-Compute6.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "CalcMQ", "Vulcan-CalcMQ.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "CalcMQGradients", "Vulcan-CalcMQGradients.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "Compute7", "Vulcan-Compute7.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "ApplyMaterialProperties", "Vulcan-ApplyMaterialProperties.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "UpdateVolumes", "Vulcan-UpdateVolumes.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "BGQ-core", "CalcTimeConstraints", "Vulcan-CalcTimeConstraints.csv",
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )

Operation( "BGQ-core", "wait", NoLookup,
           Modify( "waiting", True ),
           Loiter( "waiting", "==", False ) )

Operation( "BGQ-core", "unwait", NoLookup,
           Loiter( "waiting", "==", True ),
           Modify( "waiting", False ))

Ordinal("BGQ-core","mpi.commRank")		   
Component( "BGQ-network" )
Attribute( "BGQ-network", "usage", 0.0 )
Operation( "BGQ-network", "transfer", "HiPGator2-TT-hack.csv",
           Loiter( "usage", "==", 0.0 ),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Mailbox( "BGQ-network", "transfer", lambda source, target, size, tag: [size],
         OnAll )
Mailbox( "BGQ-core", "unwait", lambda source, target, size, tag: [],
         OnTarget )
Component( "BGQ-connection" )
Component( "system" )
Offspring( "system", Tree( ["BGQ-network", "BGQ-core"], ["BGQ-connection"],
                           [ 8 ] ) )
Root("system")

