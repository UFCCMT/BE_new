from input.cartesianrank import CartesianGrid 

global cartesianData

cartesianData = CartesianGrid(4, 4, 2)

Component( "Titan-core" )
Program( "Titan-core", "cmt-bone-be.smc" )

Property( "Titan-core", "app.elementSize", lambda gid, cid, cids, index: 9 )
Property( "Titan-core", "app.elementsPerProcess", lambda gid, cid, cids, index: 100 )
Property( "Titan-core", "app.transferSizeX", lambda gid, cid, cids, index: 8100 ) 
Property( "Titan-core", "app.transferSizeY", lambda gid, cid, cids, index: 8100 )
Property( "Titan-core", "app.transferSizeZ", lambda gid, cid, cids, index: 10125 )
Property( "Titan-core", "app.timesteps", lambda gid, cid, cids, index: 1 )
Property( "Titan-core", "app.phyParam", lambda gid, cid, cids, index: 5 )

Property( "Titan-core", "mpi.commRank", lambda gid, cid, cids, index: cid  )
Property( "Titan-core", "mpi.commSize", lambda gid, cid, cids, index: cids )
def cartX(g, rank, c, i): return cartesianData.myCoordinates(rank, "X")
def cartY(g, rank, c, i): return cartesianData.myCoordinates(rank, "Y")
def cartZ(g, rank, c, i): return cartesianData.myCoordinates(rank, "Z")
def cartXp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xplus")
def cartHasXp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xplus") >= 0
def cartYp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yplus")
def cartHasYp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yplus") >= 0
def cartZp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zplus")
def cartHasZp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zplus") >= 0
def cartXm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xminus")
def cartHasXm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xminus") >= 0
def cartYm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yminus")
def cartHasYm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yminus") >= 0
def cartZm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zminus")
def cartHasZm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zminus") >= 0
Property( "Titan-core", "mpi.cartesianX", cartX )
Property( "Titan-core", "mpi.cartesianY", cartY )
Property( "Titan-core", "mpi.cartesianZ", cartZ )
Property( "Titan-core", "mpi.cartesianXplus", cartXp )
Property( "Titan-core", "mpi.cartesianHasXplus", cartHasXp )
Property( "Titan-core", "mpi.cartesianYplus", cartYp )
Property( "Titan-core", "mpi.cartesianHasYplus", cartHasYp )
Property( "Titan-core", "mpi.cartesianZplus", cartZp )
Property( "Titan-core", "mpi.cartesianHasZplus", cartHasZp )
Property( "Titan-core", "mpi.cartesianXminus", cartXm )
Property( "Titan-core", "mpi.cartesianHasXminus", cartHasXm )
Property( "Titan-core", "mpi.cartesianYminus", cartYm )
Property( "Titan-core", "mpi.cartesianHasYminus", cartHasYm )
Property( "Titan-core", "mpi.cartesianZminus", cartZm )
Property( "Titan-core", "mpi.cartesianHasZminus", cartHasZm )
Ordinal( "Titan-core", "mpi.commRank" )
Relation( "Titan-core", "Titan-core", "cpu", "self" )
Attribute( "Titan-core", "usage", 0.0 )
Operation( "Titan-core", "wait", NoLookup, 0,
	   Recv( True ))
Operation( "Titan-core", "unwait", NoLookup, 0,
	   Sendb( True ))
Operation( "Titan-core", "computeConv", "titan-compute-conv.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Titan-core", "computedr", "titan-compute-dr.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Titan-core", "computeds", "titan-compute-ds.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Titan-core", "computedt", "titan-compute-dt.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Titan-core", "computeSum", "titan-compute-sum.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Titan-core", "computerk", "titan-compute-rk.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
#Operation( "Titan-core", "prepareFaces", "titan-compute-face-proper.csv", 4,
#           Loiter( "usage", "==", 0.0),
#           Modify( "usage", 1.0 ),
#           Dawdle( AnyOutput() ),
#           Modify( "usage", 0.0 ) )
Mailbox( "Titan-core", "unwait", lambda source, target, size, tag: [],
         OnTarget )
Component( "Titan-network" )
Attribute( "Titan-network", "usage", 0.0 )
Operation( "Titan-network", "transfer", "titan-transfer.csv", 1,
	   Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
	   Modify( "usage", 0.0 ) )
Mailbox( "Titan-network", "transfer", lambda source, target, size, tag: [size],
         OnAll )
Component( "Titan-connection" )
Component( "system" )
#Offspring( "system", Tree( ["Titan-network", "Titan-core"], ["Titan-connection"], [ cores ] ) )
Offspring( "system", Torus("Titan-core", "Titan-network", [4, 4, 2]) )
Root("system")
