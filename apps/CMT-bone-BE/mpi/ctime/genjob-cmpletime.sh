#!/bin/bash

if [ $# -lt 3 ]; then
        echo "x---x---x---x---x---x---x---x---x"
        echo "No command line argument supplied"
        echo "Run again with jobscript, data and executable folder names as cmd line inputs"
        echo "x---x---x---x---x---x---x---x---x"
        exit 0
fi

#make clean

#bone-be parameters
TIMESTEP=40
ELE_SIZE=10
E_X=8 #"1 2 3 4 5 6 7 8 9 10"
E_Y=8 #"1 2 3 4 5 6 7 8 9 10"
E_Z=8 #"1 2 3 4 5 6 7 8 9 10"
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

#Check for job dir to stare job scripts
if [ ! -d "$1" ]; then
    mkdir $1/
fi

#Check for data dir to store *.out and *.err
if [ ! -d "$2" ]; then
    mkdir $2/
fi

#Check for executable folder to store all the unique object files
if [ ! -d "$3" ]; then
    mkdir $3/
fi

echo "Creating job file(s)..."

for EL_Z in $E_Z
do
  for EL_Y in $E_Y
  do
    for EL_X in $E_X
    do
	  #if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
	  #then
		#Compile the code with -D flag to redefine parameters during compiler time
		mpicc -DTIMESTEPS=$TIMESTEP -DELEMENT_SIZE=$ELE_SIZE -DELEMENTS_X=$EL_X -DELEMENTS_Y=$EL_Y -DELEMENTS_Z=$EL_Z -DCARTESIAN_X=$CART_X -DCARTESIAN_Y=$CART_Y -DCARTESIAN_Z=$CART_Z cmt-bone-be.c -o cmtbonebe
		
		#Making unique executables w.r.t the parameters
		mv cmtbonebe $3'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS

		#Making the job script
		echo '#!/bin/bash' > jobfile
		echo '#SBATCH -D '`pwd` >> jobfile
		echo '#SBATCH --job-name=job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' >>jobfile	#Job name
		echo '#SBATCH --mail-type=FAIL' >> jobfile		#Mail events (NONE,BEGIN,END,ALL)
		echo '#SBATCH --mail-user=aravindneela@ufl.edu'  >>jobfile		#your email id
		echo "#SBATCH --ntasks=$NUM_TASKS" >> jobfile		#Number of MPI ranls
		echo "#SBATCH --cpus-per-task=1" >> jobfile			#Number of cores per MPI rank
		echo "#SBATCH --nodes=$NUM_NODES" >> jobfile		#Number of Nodes
		echo "#SBATCH --ntasks-per-socket=16" >> jobfile             #Number of tasks per socket
        echo "#SBATCH --exclusive" >> jobfile                        #Making the node exclusive to the job
        echo "#SBATCH --distribution=cyclic:block" >> jobfile        #Having cyclic instead of round robin
		echo "#SBATCH --mem-per-cpu=1gb" >> jobfile			#Per processor memory
		echo "#SBATCH -t 00:25:00" >> jobfile				#Walltime
		echo '#SBATCH -o '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' >> jobfile	#STDOUT
		echo '#SBATCH -e '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.err' >> jobfile	#STDERR
		echo " " >> jobfile
		echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile
		echo " " >> jobfile
		echo 'mpirun -np '$NUM_TASKS' ./'$3'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS >> jobfile
		mv jobfile job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'
		mv job-bonebe-es$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' $1
	  #fi
    done
  done
done

echo "Job file(s) created!"
echo " "
echo "Listing Jobfile(s):"
echo "---------------------------------------------------------------"
#echo 'job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.job'
ls $1
echo "----------------------------------------------------------------"
echo " "
echo "Job file(s) present in $1/ folder"
echo "Output and error files present in $2/ folder"
echo "The executables are present in $3/ folder"
echo " "

sleep 2

#Submit jobscript
echo "Submitting Job files:-"

for EL_Z in $E_Z
do
  for EL_Y in $E_Y
  do
	for EL_X in $E_X
	do
	  #if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ];
   	  #then
		sbatch $1/job-bonebe-es$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'
	  #fi
    done
  done
done

echo "* * * * -----------Completed!----------- * * * *"
