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

#m_mult Parameters
MATRIX_SIZE_LIST="10 100 1000"
NUM_TASKS_LIST="1 2 3 4"



#Check for job dir to store job scripts
if [ ! -d "$1" ]; then
	mkdir $1/
fi

#Check for data dir to store *.out and *.err
if [ ! -d "$2" ]; then
	mkdir $2/
fi

echo "Creating job files(s)..."

#Looping on MPI processes
for CUR_MATRIX_SIZE in $MATRIX_SIZE_LIST
do
	#Machine Parameters have not yet been defined
	for CUR_NUM_TASKS in $NUM_TASKS_LIST
	do
		wtime="00:5:00"


		#Making the job script
		#Making the job script
		echo '#!/bin/bash' > jobfile
		echo '#SBATCH -D '`pwd` >> jobfile
		echo '#SBATCH --job-name=matrix_mult'$CUR_MATRIX_SIZE'np'$CUR_NUM_TASKS'.job' >> jobfile
		echo '#SBATCH --mail-type=ALL' >> jobfile            #Mail events (NONE,BEGIN,END,FAIL,ALL)
		echo '#SBATCH --mail-user=johnson@hcs.ufl.edu'  >>jobfile            #your email id
		echo "#SBATCH --ntasks=$CUR_NUM_TASKS" >> jobfile         #Number of MPI ranls
		echo '#SBATCH --account=ccmt' >> jobfile
		echo '#SBATCH --qos=ccmt' >> jobfile
		echo "#SBATCH --mem-per-cpu=1mb" >> jobfile                   #Per processor memory
		echo "#SBATCH -t 00:15:00" >> jobfile                         #Walltime
		echo '#SBATCH -o '$2'/matrix_mult'$CUR_MATRIX_SIZE'np'$CUR_NUM_TASKS'.out' >> jobfile
		echo '#SBATCH -e '$2'/matrix_mult'$CUR_MATRIX_SIZE'np'$CUR_NUM_TASKS'.err' >> jobfile
		echo " " >> jobfile
		echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile
		echo " " >> jobfile
		echo "mpirun -np $CUR_NUM_TASKS ./mat_mult.o $CUR_SIZE" >> jobfile
		mv jobfile matrix_mult$CUR_MATRIX_SIZE'np'$CUR_NUM_TASKS.job
		mv matrix_mult$CUR_MATRIX_SIZE'np'$CUR_NUM_TASKS.job $1
 
	done
done
 
echo "Job file\(s\) created!"
echo " "
echo "Listing Jobfile\(s\):"
echo "----------------------------------------------------------------"
ls $1/
echo "----------------------------------------------------------------"
sleep 2
echo " "
echo "Job file\(s\) present in $1/ folder"
echo "Output and error files present in $2 folder"
echo " "

#Submit jobscript
echo "Submitting Job Files:-"

for CUR_MATRIX_SIZE in $MATRIX_SIZE_LIST
do
	#Machine Submission Parameters have not yet been defined
	for CUR_NUM_TASKS in $NUM_TASKS_LIST
	do
		#No App submit params to do

		sbatch $1/matrix_mult$CUR_MATRIX_SIZE'np'$CUR_NUM_TASKS'.job'
	done
done
 
echo "* * * * -----------Completed!----------- * * * *"
