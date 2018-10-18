#!/bin/bash
chmod 777 makenek
./makenek b3dp
echo b3dp > SESSION.NAME
echo `pwd`'/' >> SESSION.NAME
mkdir profiles
echo "#!/bin/bash" > jobfile
echo '#SBATCH -D '`pwd` >> jobfile
echo "#SBATCH --job-name=job-${PWD##*/}.job" >> jobfile	#Job name
echo '#SBATCH --mail-type=ALL' >> jobfile		#Mail events (NONE,BEGIN,END,ALL)
echo '#SBATCH --mail-user=schenna@ufl.edu'  >> jobfile		#your email id
echo "#SBATCH --ntasks=$1" >> jobfile		#Number of MPI ranls
echo "#SBATCH --cpus-per-task=1" >> jobfile			#Number of cores per MPI rank
#echo "#SBATCH --nodes=1" >> jobfile		#Number of Nodes
echo "#SBATCH --mem-per-cpu=1gb" >> jobfile			#Per processor memory
echo "#SBATCH -t 08:00:00" >> jobfile				#Walltime
echo "#SBATCH -o job-${PWD##*/}.out" >> jobfile	#STDOUT
echo "#SBATCH -e job-${PWD##*/}.err" >> jobfile	#STDERR
echo " " >> jobfile
echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile
echo " " >> jobfile
echo "mpirun -np $1 ./nek5000 b3dp > log_${PWD##*/}.txt" >> jobfile
cp jobfile job-${PWD##*/}.job

sbatch --qos=ccmt job-${PWD##*/}.job

