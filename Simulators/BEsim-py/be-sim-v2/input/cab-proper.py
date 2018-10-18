from input.cartesianrank import CartesianGrid 

global cartesianData

cartesianData = CartesianGrid(8, 4, 4)

Component( "Cab-core" )
Program( "Cab-core", "cmt-bone-be.smc" )

Property( "Cab-core", "app.elementSize", lambda gid, cid, cids, index: 9 )
Property( "Cab-core", "app.elementsPerProcess", lambda gid, cid, cids, index: 100 )
Property( "Cab-core", "app.transferSizeX", lambda gid, cid, cids, index: 8100 ) 
Property( "Cab-core", "app.transferSizeY", lambda gid, cid, cids, index: 8100 )
Property( "Cab-core", "app.transferSizeZ", lambda gid, cid, cids, index: 10125 )
Property( "Cab-core", "app.timesteps", lambda gid, cid, cids, index: 1 )
Property( "Cab-core", "app.phyParam", lambda gid, cid, cids, index: 5 )

Property( "Cab-core", "mpi.commRank", lambda gid, cid, cids, index: cid  )
Property( "Cab-core", "mpi.commSize", lambda gid, cid, cids, index: cids )
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
Property( "Cab-core", "mpi.cartesianX", cartX )
Property( "Cab-core", "mpi.cartesianY", cartY )
Property( "Cab-core", "mpi.cartesianZ", cartZ )
Property( "Cab-core", "mpi.cartesianXplus", cartXp )
Property( "Cab-core", "mpi.cartesianHasXplus", cartHasXp )
Property( "Cab-core", "mpi.cartesianYplus", cartYp )
Property( "Cab-core", "mpi.cartesianHasYplus", cartHasYp )
Property( "Cab-core", "mpi.cartesianZplus", cartZp )
Property( "Cab-core", "mpi.cartesianHasZplus", cartHasZp )
Property( "Cab-core", "mpi.cartesianXminus", cartXm )
Property( "Cab-core", "mpi.cartesianHasXminus", cartHasXm )
Property( "Cab-core", "mpi.cartesianYminus", cartYm )
Property( "Cab-core", "mpi.cartesianHasYminus", cartHasYm )
Property( "Cab-core", "mpi.cartesianZminus", cartZm )
Property( "Cab-core", "mpi.cartesianHasZminus", cartHasZm )
Ordinal( "Cab-core", "mpi.commRank" )
Relation( "Cab-core", "Cab-core", "cpu", "self" )
Attribute( "Cab-core", "usage", 0.0 )
Operation( "Cab-core", "wait", NoLookup, 0,
	   Recv( True ))
Operation( "Cab-core", "unwait", NoLookup, 0,
	   Sendb( True ))
Operation( "Cab-core", "computeConv", "cab-compute-conv.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Cab-core", "computedr", "cab-compute-dr.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Cab-core", "computeds", "cab-compute-ds.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Cab-core", "computedt", "cab-compute-dt.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Cab-core", "computeSum", "cab-compute-sum.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
Operation( "Cab-core", "computerk", "cab-compute-rk.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )
#Operation( "Cab-core", "prepareFaces", "cab-compute-face-proper.csv", 4,
#           Loiter( "usage", "==", 0.0),
#           Modify( "usage", 1.0 ),
#           Dawdle( AnyOutput() ),
#           Modify( "usage", 0.0 ) )
Mailbox( "Cab-core", "unwait", lambda source, target, size, tag: [],
         OnTarget )
Component( "Cab-network" )
Attribute( "Cab-network", "usage", 0.0 ) 
Operation( "Cab-network", "transfer", "cab-transfer.csv", 1,
	   Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ), 
	   Modify( "usage", 0.0 ) )
Mailbox( "Cab-network", "transfer", lambda source, target, size, tag: [size],
         OnAll )
Component( "Cab-connection" )
Component( "system" )
Offspring( "system", Tree( ["Cab-network", "Cab-core"], ["Cab-connection"], [ 128 ] ) )
Root("system")
