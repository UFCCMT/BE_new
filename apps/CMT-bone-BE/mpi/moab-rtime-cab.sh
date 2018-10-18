#!/bin/bash

if [ $# -lt 2 ]; then
        echo "x---x---x---x---x---x---x---x---x"
        echo "No command line argument supplied"
        echo "Run again with jobscript and data folder name as cmd line inputs"
        echo "x---x---x---x---x---x---x---x---x"
        exit 0
fi

make clean

make

#bone-be parameters
TIMESTEP=100
E_SIZE=$(seq 5 21) #$(seq 22 36)
E_X="2 3 4 5 6 7 8 9 10"
E_Y="2 3 4 5 6 7 8 9 10"
E_Z="2 3 4 5 6 7 8 9 10"
CART_X=2
CART_Y=2
CART_Z=2
PHY_PARAM=5

#Machine Parameters
NUM_TASKS=$((CART_X*CART_Y*CART_Z))
Tlnum_proc=16
one=1
NUM_NODES1=$((NUM_TASKS/Tlnum_proc))
NUM_NODESr=$((NUM_TASKS%Tlnum_proc))
if [ $NUM_NODESr -eq 0 ];
then
    NUM_NODES=$NUM_NODES1
else
    NUM_NODES=$((NUM_NODES1+one))
fi

#Check for job dir to store job scripts
if [ ! -d "$1" ]; then
    mkdir $1/
fi

#Check for data dir to store *.out and *.err
if [ ! -d "$2" ]; then
    mkdir $2/
fi

echo "Creating job file(s)..."

for ELE_SIZE in $E_SIZE
do
  for EL_Z in $E_Z
  do
    for EL_Y in $E_Y
    do
      for EL_X in $E_X
      do
	 	if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
	 	then
		   #Making the job script
		   echo '#!/bin/bash' > jobfile
		   echo '#MSUB -d '`pwd` >> jobfile
		   echo '#MSUB -N job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' >>jobfile	#Job name
		   echo "#MSUB -l nodes=$NUM_NODES" >> jobfile		#Number of MPI ranls
		   echo "#MSUB -l partition=cab" >> jobfile			#Number of cores per MPI rank
		   echo "#MSUB -q pdebug" >> jobfile		#Number of Nodes
		   #echo "#MSUB -m a" >> jobfile			#Per processor memory
		   echo "#MSUB -l walltime=00:20:00" >> jobfile				#Walltime
		   echo '#MSUB -o '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' >> jobfile	#STDOUT
		   echo '#MSUB -e '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.err' >> jobfile	#STDERR
		   echo " " >> jobfile
		   echo "module load intel/16.0 openmpi-intel/1.8" >> jobfile
		   echo " " >> jobfile
		   echo "mpirun -np $NUM_TASKS -map-by core --report-bindings ./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z" >> jobfile
		   mv jobfile job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'
	       mv job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' $1/
	 	fi
      done
    done
  done
done

echo "Job file(s) created!"
echo " "
echo "Listing Jobfile(s):"
echo "---------------------------------------------------------------"
#echo 'job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.job'
ls $1/
echo "----------------------------------------------------------------"
sleep 2
echo " "
echo "Job file(s) present in $1 folder"
echo "Output and error files present in $2 folder"
echo " "

#Submit jobscript
echo "Submitting Job files:-"

for ELE_SIZE in $E_SIZE
do
 for EL_Z in $E_Z
 do
  for EL_Y in $E_Y
  do
   for EL_X in $E_X
   do
    if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ];
    then
     msub $1/job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'
    fi
   done
  done
 done
done

echo "* * * * -----------Completed!----------- * * * *"
