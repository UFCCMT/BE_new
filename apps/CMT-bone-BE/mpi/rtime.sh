#!/bin/bash

make clean

make

#bone-be parameters
TIMESTEP=100
ELE_SIZE=10
E_X="1 2 3 4 5 6 7 8 9 10"
E_Y="1 2 3 4 5 6 7 8 9 10"
E_Z="1 2 3 4 5 6 7 8 9 10"
CART_X=2
CART_Y=2
CART_Z=2
PHY_PARAM=5

#Machine Parameters
NUM_TASKS=$((CART_X*CART_Y*CART_Z))
Tlnum_proc=32
one=1
NUM_NODES1=$((NUM_TASKS/Tlnum_proc))
NUM_NODESr=$((NUM_TASKS%Tlnum_proc))
if [ $NUM_NODESr -eq 0 ];
then
    NUM_NODES=$NUM_NODES1
else
    NUM_NODES=$((NUM_NODES1+one))
fi

#Check for data dir to store *.out and *.err
if [ ! -d "data" ]; then
    mkdir data/
fi

echo "Starting to run the applicaion for different parameters"
#Multiple runs
for EL_Z in $E_Z
do
  for EL_Y in $E_Y
  do
     for EL_X in $E_X
     do
	#if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
	#then
	   mpirun -np $NUM_TASKS ./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z > logfile
	   mv logfile bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out'
    	   mv bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' data/
	   echo 'bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out'
	#fi
     done
  done
done

echo "* * * * -----------Completed!----------- * * * *"

