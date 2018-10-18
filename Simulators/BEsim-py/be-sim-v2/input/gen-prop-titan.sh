#!/bin/bash

#bone-be parameters
#TIMESTEP=100
#ELEMENT_SIZE="5 7 9 11 13" 
#EPP="2,2,2;4,4,2;4,4,4;8,4,4;8,8,4"
#CART="4,2,2;4,4,2;8,8,4;16,8,8;32,16,16"
#PHY_PARAM=5
#------------------------#

#Test case!
TIMESTEP=1
ELEMENT_SIZE="9" #"6 8 9 13 16 19"
EPP="5,5,4" #"2,2,2;4,4,2;4,4,4;8,8,4"
CART="4,4,2"
PHY_PARAM=5
#--------------------------#

#Creating array stack for EPP and CART 
CART_stack=$(echo $CART | tr ";" "\n")
epp_stack=$(echo $EPP | tr ";" "\n")
#---------------------------#

#generating titan-proper.py file
for index in ${!CART_stack[*]}
do
  #bone-BE Cartesian coordinate
  CART_X=$(echo ${CART_stack[$index]} | tr "," " " | awk '{print $1}')
  CART_Y=$(echo ${CART_stack[$index]} | tr "," " " | awk '{print $2}')
  CART_Z=$(echo ${CART_stack[$index]} | tr "," " " | awk '{print $3}')
  NP=$((CART_X*CART_Y*CART_Z))
  
  for EC in $epp_stack
  do
    #Calculating EL_X, EL_Y,EL_Z from epp_stack
    EL_X=$(echo $EC | tr "," " " | awk '{print $1}')
    EL_Y=$(echo $EC | tr "," " " | awk '{print $2}')
    EL_Z=$(echo $EC | tr "," " " | awk '{print $3}')
    Exyz=$((EL_X*EL_Y*EL_Z))

    #Calculating ELEMENTS ON FACE (EOF) for X, Y, Z axis
    EOF_X=$((EL_Y*EL_Z))
    EOF_Y=$((EL_X*EL_Z))
    EOF_Z=$((EL_X*EL_Y))
    
    for ES in $ELEMENT_SIZE
    do
      FS=$((ES*ES))   #FACE_SIZE
      TRANSFER_SIZE_X=$((FS*PHY_PARAM*EOF_X))
      TRANSFER_SIZE_Y=$((FS*PHY_PARAM*EOF_Y))
      TRANSFER_SIZE_Z=$((FS*PHY_PARAM*EOF_Z))
      echo "from input.cartesianrank import CartesianGrid" > titan-prop.py
      echo "" >> titan-prop.py
      echo "global cartesianData" >> titan-prop.py
      echo "" >> titan-prop.py
      echo "cartesianData = CartesianGrid($CART_X, $CART_Y, $CART_Z)" >> titan-prop.py
      echo "" >> titan-prop.py
      echo 'Component( "Titan-core" )' >> titan-prop.py
      echo 'Program( "Titan-core", "cmt-bone-be.smc" )' >> titan-prop.py
      echo "" >> titan-prop.py
      echo 'Property( "Titan-core", "app.elementSize", lambda gid, cid, cids, index: '$ES' )' >> titan-prop.py
      echo 'Property( "Titan-core", "app.elementsPerProcess", lambda gid, cid, cids, index: '$Exyz' )' >> titan-prop.py
      echo 'Property( "Titan-core", "app.transferSizeX", lambda gid, cid, cids, index: '$TRANSFER_SIZE_X' )' >> titan-prop.py
      echo 'Property( "Titan-core", "app.transferSizeY", lambda gid, cid, cids, index: '$TRANSFER_SIZE_Y' )' >> titan-prop.py
      echo 'Property( "Titan-core", "app.transferSizeZ", lambda gid, cid, cids, index: '$TRANSFER_SIZE_Z' )' >> titan-prop.py
      echo 'Property( "Titan-core", "app.timesteps", lambda gid, cid, cids, index: '$TIMESTEP' )' >> titan-prop.py
      echo 'Property( "Titan-core", "app.phyParam", lambda gid, cid, cids, index: '$PHY_PARAM' )' >> titan-prop.py
      echo "" >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.commRank", lambda gid, cid, cids, index: cid  )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.commSize", lambda gid, cid, cids, index: cids )' >> titan-prop.py
      echo 'def cartX(g, rank, c, i): return cartesianData.myCoordinates(rank, "X")' >> titan-prop.py
      echo 'def cartY(g, rank, c, i): return cartesianData.myCoordinates(rank, "Y")' >> titan-prop.py
      echo 'def cartZ(g, rank, c, i): return cartesianData.myCoordinates(rank, "Z")' >> titan-prop.py
      echo 'def cartXp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xplus")' >> titan-prop.py
      echo 'def cartHasXp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xplus") >= 0' >> titan-prop.py
      echo 'def cartYp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yplus")' >> titan-prop.py
      echo 'def cartHasYp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yplus") >= 0' >> titan-prop.py
      echo 'def cartZp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zplus")' >> titan-prop.py
      echo 'def cartHasZp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zplus") >= 0' >> titan-prop.py
      echo 'def cartXm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xminus")' >> titan-prop.py
      echo 'def cartHasXm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xminus") >= 0' >> titan-prop.py
      echo 'def cartYm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yminus")' >> titan-prop.py
      echo 'def cartHasYm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yminus") >= 0' >> titan-prop.py
      echo 'def cartZm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zminus")' >> titan-prop.py
      echo 'def cartHasZm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zminus") >= 0' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianX", cartX )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianY", cartY )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianZ", cartZ )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianXplus", cartXp )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianHasXplus", cartHasXp )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianYplus", cartYp )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianHasYplus", cartHasYp )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianZplus", cartZp )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianHasZplus", cartHasZp )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianXminus", cartXm )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianHasXminus", cartHasXm )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianYminus", cartYm )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianHasYminus", cartHasYm )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianZminus", cartZm )' >> titan-prop.py
      echo 'Property( "Titan-core", "mpi.cartesianHasZminus", cartHasZm )' >> titan-prop.py
      echo 'Ordinal( "Titan-core", "mpi.commRank" )' >> titan-prop.py
      echo 'Relation( "Titan-core", "Titan-core", "cpu", "self" )' >> titan-prop.py
      echo 'Attribute( "Titan-core", "usage", 0.0 )' >> titan-prop.py
      #echo 'Attribute( "Titan-core", "waiting", 0.0 )' >> titan-prop.py
      echo 'Operation( "Titan-core", "wait", NoLookup, 0,
           Recv( True ) ) ' >> titan-prop.py
      echo 'Operation( "Titan-core", "unwait", NoLookup, 0,
           Sendb( True ) )' >> titan-prop.py
      echo 'Operation( "Titan-core", "computeConv", "titan-compute-conv.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo 'Operation( "Titan-core", "computedr", "titan-compute-dr.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo 'Operation( "Titan-core", "computeds", "titan-compute-ds.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo 'Operation( "Titan-core", "computedt", "titan-compute-dt.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo 'Operation( "Titan-core", "computeSum", "titan-compute-sum.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo 'Operation( "Titan-core", "computerk", "titan-compute-rk.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo '#Operation( "Titan-core", "prepareFaces", "titan-compute-face-proper.csv", 4,
           #Loiter( "usage", "==", 0.0),
           #Modify( "usage", 1.0 ),
           #Dawdle( AnyOutput() ),
           #Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo 'Mailbox( "Titan-core", "unwait", lambda source, target, size, tag: [],
         OnTarget )' >> titan-prop.py
      echo 'Component( "Titan-network" )' >> titan-prop.py
      echo 'Attribute( "Titan-network", "usage", 0.0 )' >> titan-prop.py
      echo 'Operation( "Titan-network", "transfer", "titan-transfer.csv", 1,
	   Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
	   Modify( "usage", 0.0 ) )' >> titan-prop.py
      echo 'Mailbox( "Titan-network", "transfer", lambda source, target, size, tag: [size],
         OnAll )' >> titan-prop.py
      echo 'Component( "Titan-connection" )' >> titan-prop.py
      echo 'Component( "system" )' >> titan-prop.py
      echo 'Offspring( "system", Torus( "Titan-core", "Titan-network", [ '$CART_X', '$CART_Y', '$CART_Z' ] ) )' >> titan-prop.py
      echo 'Root("system")' >> titan-prop.py
      mv titan-prop.py titan-proper'-es'$ES'ec'$Exyz'np'$NP'.py'
    done
  done
done
