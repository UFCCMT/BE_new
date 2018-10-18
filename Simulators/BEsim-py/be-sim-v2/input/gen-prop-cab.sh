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

#generating cab-proper.py file
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
      echo "from input.cartesianrank import CartesianGrid" > cab-prop.py
      echo "" >> cab-prop.py
      echo "global cartesianData" >> cab-prop.py
      echo "" >> cab-prop.py
      echo "cartesianData = CartesianGrid($CART_X, $CART_Y, $CART_Z)" >> cab-prop.py
      echo "" >> cab-prop.py
      echo 'Component( "Cab-core" )' >> cab-prop.py
      echo 'Program( "Cab-core", "cmt-bone-be.smc" )' >> cab-prop.py
      echo "" >> cab-prop.py
      echo 'Property( "Cab-core", "app.elementSize", lambda gid, cid, cids, index: '$ES' )' >> cab-prop.py
      echo 'Property( "Cab-core", "app.elementsPerProcess", lambda gid, cid, cids, index: '$Exyz' )' >> cab-prop.py
      echo 'Property( "Cab-core", "app.transferSizeX", lambda gid, cid, cids, index: '$TRANSFER_SIZE_X' )' >> cab-prop.py
      echo 'Property( "Cab-core", "app.transferSizeY", lambda gid, cid, cids, index: '$TRANSFER_SIZE_Y' )' >> cab-prop.py
      echo 'Property( "Cab-core", "app.transferSizeZ", lambda gid, cid, cids, index: '$TRANSFER_SIZE_Z' )' >> cab-prop.py
      echo 'Property( "Cab-core", "app.timesteps", lambda gid, cid, cids, index: '$TIMESTEP' )' >> cab-prop.py
      echo 'Property( "Cab-core", "app.phyParam", lambda gid, cid, cids, index: '$PHY_PARAM' )' >> cab-prop.py
      echo "" >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.commRank", lambda gid, cid, cids, index: cid  )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.commSize", lambda gid, cid, cids, index: cids )' >> cab-prop.py
      echo 'def cartX(g, rank, c, i): return cartesianData.myCoordinates(rank, "X")' >> cab-prop.py
      echo 'def cartY(g, rank, c, i): return cartesianData.myCoordinates(rank, "Y")' >> cab-prop.py
      echo 'def cartZ(g, rank, c, i): return cartesianData.myCoordinates(rank, "Z")' >> cab-prop.py
      echo 'def cartXp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xplus")' >> cab-prop.py
      echo 'def cartHasXp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xplus") >= 0' >> cab-prop.py
      echo 'def cartYp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yplus")' >> cab-prop.py
      echo 'def cartHasYp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yplus") >= 0' >> cab-prop.py
      echo 'def cartZp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zplus")' >> cab-prop.py
      echo 'def cartHasZp(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zplus") >= 0' >> cab-prop.py
      echo 'def cartXm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xminus")' >> cab-prop.py
      echo 'def cartHasXm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Xminus") >= 0' >> cab-prop.py
      echo 'def cartYm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yminus")' >> cab-prop.py
      echo 'def cartHasYm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Yminus") >= 0' >> cab-prop.py
      echo 'def cartZm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zminus")' >> cab-prop.py
      echo 'def cartHasZm(g, rank, c, i): return cartesianData.neighbourRank(rank, "Zminus") >= 0' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianX", cartX )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianY", cartY )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianZ", cartZ )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianXplus", cartXp )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianHasXplus", cartHasXp )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianYplus", cartYp )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianHasYplus", cartHasYp )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianZplus", cartZp )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianHasZplus", cartHasZp )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianXminus", cartXm )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianHasXminus", cartHasXm )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianYminus", cartYm )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianHasYminus", cartHasYm )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianZminus", cartZm )' >> cab-prop.py
      echo 'Property( "Cab-core", "mpi.cartesianHasZminus", cartHasZm )' >> cab-prop.py
      echo 'Ordinal( "Cab-core", "mpi.commRank" )' >> cab-prop.py
      echo 'Relation( "Cab-core", "Cab-core", "cpu", "self" )' >> cab-prop.py
      echo 'Attribute( "Cab-core", "usage", 0.0 )' >> cab-prop.py
      #echo 'Attribute( "Cab-core", "waiting", 0.0 )' >> cab-prop.py
      echo 'Operation( "Cab-core", "wait", NoLookup, 0,
           Recv( True ) ) ' >> cab-prop.py
      echo 'Operation( "Cab-core", "unwait", NoLookup, 0,
           Sendb( True ) )' >> cab-prop.py
      echo 'Operation( "Cab-core", "computeConv", "cab-compute-conv.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo 'Operation( "Cab-core", "computedr", "cab-compute-dr.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo 'Operation( "Cab-core", "computeds", "cab-compute-ds.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo 'Operation( "Cab-core", "computedt", "cab-compute-dt.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo 'Operation( "Cab-core", "computeSum", "cab-compute-sum.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo 'Operation( "Cab-core", "computerk", "cab-compute-rk.csv", 4,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
           Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo '#Operation( "Cab-core", "prepareFaces", "cab-compute-face-proper.csv", 4,
           #Loiter( "usage", "==", 0.0),
           #Modify( "usage", 1.0 ),
           #Dawdle( AnyOutput() ),
           #Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo 'Mailbox( "Cab-core", "unwait", lambda source, target, size, tag: [],
         OnTarget )' >> cab-prop.py
      echo 'Component( "Cab-network" )' >> cab-prop.py
      echo 'Attribute( "Cab-network", "usage", 0.0 )' >> cab-prop.py
      echo 'Operation( "Cab-network", "transfer", "cab-transfer.csv", 1,
           Loiter( "usage", "==", 0.0),
           Modify( "usage", 1.0 ),
           Dawdle( AnyOutput() ),
	   Modify( "usage", 0.0 ) )' >> cab-prop.py
      echo 'Mailbox( "Cab-network", "transfer", lambda source, target, size, tag: [size],
         OnAll )' >> cab-prop.py
      echo 'Component( "Cab-connection" )' >> cab-prop.py
      echo 'Component( "system" )' >> cab-prop.py
      echo 'Offspring( "system", Tree( ["Cab-network", "Cab-core"], ["Cab-connection"], [ '$NP' ] ) )' >> cab-prop.py
      echo 'Root("system")' >> cab-prop.py
      mv cab-prop.py cab-proper'-es'$ES'ec'$Exyz'np'$NP'.py'
    done
  done
done
