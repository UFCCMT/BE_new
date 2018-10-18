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

#Check for job dir to store job scripts
if [ ! -d "$1" ]; then
	mkdir $1/
fi

#Check for data dir to store *.out and *.err
if [ ! -d "$2" ]; then
	mkdir $2/
fi

#cmt-nek Parameters
core_list="256"
lx1_list="20"
elpercore_list="2"
lpartpercore="1024"
root=`pwd`

echo "Creating job files(s)..."
#Looping on MPI processes
for core in $core_list
do

	for lx1 in $lx1_list
	do

		for elpercore in $elpercore_list
		do

			for lpart in $lpartpercore
			do

				wtime="08:0:00"
				#Making the job script
				cd $root
				mkdir 'core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
				cp SIZE './core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
				cp * './core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
				cd './core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
				echo " " >> jobfile
				lelg=$core*$elpercore
				sed -i "s/(lx1=5,/(lx1=$lx1,/" SIZE
				sed -i "s/(lxd=5,/(lxd=$lx1,/" SIZE
				sed -i "s/,lelt=512,/,lelt=$elpercore,/" SIZE
				sed -i "s/(lelg = 512)/(lelg = $lelg)/" SIZE
				sed -i "s/(lp =512)/(lp =$core)/" SIZE
				sed -i "s/(lpart = 128000 )/(lpart = $lpart )/" SIZE
				nelt=$(($elpercore * $core))
				nelx=$(expr "$nelt" / 64)
				nw=$lpart
				sed -i "s;nw = 50000;nw = ($nw)/2;" cmtparticles.usrp
				if [ $nelx -gt 900 ]
				then
					nlx=$(expr "$nelx" / 4)
					sed -i "s/-8  -8  -8/-$nlx  -16  -16/" box.box
				else
					sed -i "s/-8  -8  -8/-$nelx  -8  -8/" box.box
				fi
				echo "box.box" > gbox.in
				echo "Updates Complete!!!"
				module load intel/2016.0.109 openmpi/1.10.2
				genbox < gbox.in
				mv box.rea b3dp.rea
				echo "b3dp" > gmap.in
				echo "0.2" >> gmap.in
				genmap < gmap.in
				chmod 777 generate.sh
				chmod 777 clean.sh
				echo "Running the job script"
				echo '#!/bin/bash' > jobfile
				echo 'chmod 777 makenek' > jobfile
				echo './makenek pvort' > jobfile
				echo 'echo pvort > SESSION.NAME' > jobfile
				echo 'echo `pwd`'/' >> SESSION.NAME' > jobfile
				echo 'mkdir profiles' > jobfile
				echo '#!/bin/bash' > jobfile
				echo '#SBATCH -D '`pwd` >> jobfile
				echo '#SBATCH --job-name=job-${PWD##*/}.job' >> jobfile
				echo '#SBATCH --mail-type=ALL' >> jobfile            		#Mail events (NONE,BEGIN,END,FAIL,ALL)
				echo '#SBATCH --mail-user=johnson@hcs.ufl.edu'  >>jobfile          #your email id
				echo "#SBATCH --ntasks=256" >> jobfile         			#Number of MPI ranks
				echo "#SBATCH --cpus-per-task=1" >> jobfile				#Number of cores per MPI Rank
				#echo "#SBATCH --nodes=1" >> jobfile         			#Number of Nodes
				echo "#SBATCH --mem-per-cpu=1gb" >> jobfile                   	#Per processor memory
				echo "#SBATCH -t 08:00:00" >> jobfile                         	#Walltime
				echo "#SBATCH --account=ccmt" >> jobfile                             #Account Status
				echo "#SBATCH --qos=ccmt" >> jobfile                                 #QOS
				echo "#SBATCH -o job-${PWD##*/}.out" >> jobfile			#STDOUT
				echo "#SBATCH -e job-${PWD##*/}.err" >> jobfile			#STDERR
				echo " " >> jobfile
				echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile
				echo " " >> jobfile
				echo "mpirun -np 256 ./nek5000 b3dp > log_${PWD##*/}.txt" >> jobfile	#Play that thang
				cp jobfile job-${PWD##*/}.job
				echo " " >> jobfile
				sbatch --qos=ccmt job-${PWD##*/}.job
			done
		done
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
for core in $core_list
do
	for lx1 in $lx1_list
	do
		for elpercore in $elpercore_list
		do
			for lpart in $lpartpercore
			do
				sbatch job-${PWD##*/}.job
			done
		done
	done
done
echo "* * * * -----------Completed!----------- * * * *"
