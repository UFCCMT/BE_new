#!/bin/bash

#make clean

#bone-be parameters
TIMESTEP=10
ELE_SIZE=5
EL_X=10
EL_Y=10
EL_Z=10
CART_X=2
CART_Y=2
CART_Z=2
PHY_PARAM=5

#Machine Parameters
NUM_TASKS=$((CART_X*CART_Y*CART_Z))
Tlnum_proc=64
one=1
NUM_NODES1=$((NUM_TASKS/Tlnum_proc))
NUM_NODES=$((NUM_NODES1+one))

#Check for job dir to stare job scripts
if [ ! -d "jobscripts" ]; then
    mkdir jobscripts/
fi

#Check for data dir to store *.out and *.err
if [ ! -d "data" ]; then
    mkdir data/
fi

echo "Creating job file(s)..."

	#make using -D flag for compile time redefining
	#make -D'TIMESTEPS='$TIMESTEP -D'ELEMENT_SIZE='$ELE_SIZE -D'ELEMENTS_X='$EL_X -D'ELEMENTS_Y='$EL_Y -D'ELEMENTS_Z='$EL_Z

	#Compile the code with -D flag to redefine parameters during compiler time
	mpicc -DTIMESTEPS=$TIMESTEP -DELEMENT_SIZE=$ELE_SIZE -DELEMENTS_X=$EL_X -DELEMENTS_Y=$EL_Y -DELEMENTS_Z=$EL_Z -g -Wall -c cmt-bone-be.c -o cmtbonebe
	
	#Making unique executables w.r.t the parameters
	mv cmtbonebe bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z


	#Making the job script
	echo '#!/bin/bash' > jobfile
	echo '#SBATCH -D '`pwd` >> jobfile
	echo '#SBATCH --job-name=job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.job' >>jobfile	#Job name
	echo '#SBATCH --mail-type=ALL' >> jobfile		#Mail events (NONE,BEGIN,END,ALL)
	echo '#SBATCH --mail-user=aravindneela@ufl.edu'  >>jobfile		#your email id
	echo "#SBATCH --ntasks=$NUM_TASKS" >> jobfile		#Number of MPI ranls
	echo "#SBATCH --cpus-per-task=1" >> jobfile			#Number of cores per MPI rank
	echo "#SBATCH --nodes=$NUM_NODES" >> jobfile		#Number of Nodes
	echo "#SBATCH --mem-per-cpu=1gb" >> jobfile			#Per processor memory
	echo "#SBATCH -t 00:45:00" >> jobfile				#Walltime
	echo '#SBATCH -o data/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.out' >> jobfile	#STDOUT
	echo '#SBATCH -e data/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.err' >> jobfile	#STDERR
	echo " " >> jobfile
	echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile
	echo " " >> jobfile
	echo 'mpirun -np '$NUM_TASKS' ./bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z >> jobfile
	mv jobfile job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.job'


echo "Job file(s) created!"
echo " "
echo "Listing Jobfile(s):"
echo "---------------------------------------------------------------"
echo 'job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.job'

mv job-bonebe-es$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.job' jobscripts/
echo "----------------------------------------------------------------"
echo " "
echo "Job file(s) present in jobs/ folder"
echo "Output and error files present in data/ folder"
echo " "

#Submit jobscript
sbatch jobscripts/job-bonebe-es$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'.job'
echo "* * * * -----------Completed!----------- * * * *"

