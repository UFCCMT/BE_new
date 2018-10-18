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

#CMT_Bone_BE Parameters
TIMESTEP=100
E_SIZE="15 20 25"
EPP="7,5,2;5,5,5;6,6,5"
CART="2,2,2;4,4,2;8,5,5;13,13,8;32,32,16"
PHY_PARAM=5
#Creating stack for different EPP and CART
epp_stack=$(echo $EPP | tr ";" "\n")
cart_stack=$(echo $CART | tr ";" "\n")

#user variables for # of nodes calcution
Tlnum_proc=16
one=1

echo "Creating job files(s)..."
#Looping on MPI processes
for proc in $cart_stack
do
	#Calcuting CART_X, CART_Y, CART_Z from cart_stack
	CART_X=$(echo $proc | tr "," " " | awk '{print $1}')
	CART_Y=$(echo $proc | tr "," " " | awk '{print $2}')
	CART_Z=$(echo $proc | tr "," " " | awk '{print $3}')

	#Machine Parameters
	NUM_TASKS=$((CART_X*CART_Y*CART_Z))
	NUM_NODES1=$((NUM_TASKS/Tlnum_proc))
	NUM_NODESr=$((NUM_TASKS%Tlnum_proc))

	if [ $NUM_NODESr -eq 0 ];
	then
		NUM_NODES=$NUM_NODES1
	else
		NUM_NODES=$((NUM_NODES1+one))
	fi


	for ELE_SIZE in $E_SIZE
	do

		for ele in $epp_stack
		do

			#Calcuting EL_X, EL_Y, EL_Z from epp_stack
			EL_X=$(echo $proc | tr "," " " | awk '{print $1}')
			EL_Y=$(echo $proc | tr "," " " | awk '{print $2}')
			EL_Z=$(echo $proc | tr "," " " | awk '{print $3}')
			Exyz=$((EL_X*EL_Y*EL_Z))
 
			#Time assignment
			if [ $ELE_SIZE -eq 5 ];
				then
				if [ $Exyz -le 150 ]; then
					wtime="00:15:00"
				elif [ $Exyz -eq 180 ]; then
					wtime="00:20:00"
				else
					wtime="00:30:00"
				fi
			elif [ $ELE_SIZE -eq 10 ];
				then
				if [ $Exyz -le 150 ]; then
					wtime="00:20:00"
				elif [ $Exyz -eq 180 ]; then
					wtime="00:30:00"
				else
					wtime="01:10:00"
				fi
			elif [ $ELE_SIZE -eq 15 ];
				then
				if [ $Exyz -le 100 ]; then
					wtime="00:30:00"
				elif [ $Exyz -eq 125 ]; then
					wtime="01:15:00"
				elif [ $Exyz -eq 180 ]; then
					wtime="01:45:00"
				else
					wtime="02:00:00"
				fi
			elif [ $ELE_SIZE -eq 20 ];
				then
				if [ $Exyz -le 50 ]; then
					wtime="00:40:00"
				elif [ $Exyz -eq 70 ]; then
					wtime="04:00:00"
				elif [ $Exyz -eq 125 ]; then
					wtime="08:00:00"
				elif [ $Exyz -eq 180 ]; then
					wtime="10:00:00"
				else
					wtime="02:30:00"
				fi
			elif [ $ELE_SIZE -eq 25 ];
				then
				if [ $Exyz -le 50 ]; then
					wtime="00:50:00"
				elif [ $Exyz -eq 70 ]; then
					wtime="08:30:00"
				elif [ $Exyz -eq 125 ]; then
					wtime="11:00:00"
				elif [ $Exyz -eq 180 ]; then
					wtime="11:59:59"
				else
					wtime="02:45:00"
				fi
			fi
			wtime=00:15:00
			#Making the job script
			if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ];
			then
				#Making the job script
				echo '#!/bin/bash' > jobfile
				echo '#SBATCH -D '`pwd` >> jobfile
				echo '#SBATCH --job-name=job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' >> jobfile
				echo '#SBATCH --mail-type=FAIL' >> jobfile            #Mail events (NONE,BEGIN,END,FAIL,ALL)
				echo '#SBATCH --mail-user=johnson@hcs.ufl.edu'  >>jobfile            #your email id
				echo "#SBATCH --ntasks=$NUM_TASKS" >> jobfile         #Number of MPI ranls
				echo '#SBATCH --account=ccmt' >> jobfile
				echo '#SBATCH --qos=ccmt' >> jobfile
				echo "#SBATCH --cpus-per-task=1" >> jobfile                   #Number of cores per MPI rank
				echo "#SBATCH --nodes=$NUM_NODES" >> jobfile          #Number of Nodes
				echo "#SBATCH --ntasks-per-socket=16" >> jobfile             #Number of tasks per socket
				echo "#SBATCH --exclusive" >> jobfile                        #Making the node exclusive to the job
				echo "#SBATCH --distribution=cyclic:block" >> jobfile        #Having cyclic instead of round robin
				echo "#SBATCH --mem-per-cpu=1gb" >> jobfile                   #Per processor memory
				echo "#SBATCH -t $wtime" >> jobfile                         #Walltime
				echo '#SBATCH -o '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' >> jobfile
				echo '#SBATCH -e '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.err' >> jobfile
				echo " " >> jobfile
				echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile
				echo " " >> jobfile
				echo "mpirun -np $NUM_TASKS ./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z">>jobfile
				mv jobfile job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'
				mv job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' $1
			fi
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
for proc in $cart_stack
do
	#Calcuting CART_X, CART_Y, CART_Z from cart_stack
	CART_X=$(echo $proc | tr "," " " | awk '{print $1}')
	CART_Y=$(echo $proc | tr "," " " | awk '{print $2}')
	CART_Z=$(echo $proc | tr "," " " | awk '{print $3}')
	NUM_TASKS=$((CART_X*CART_Y*CART_Z))

	for ELE_SIZE in $E_SIZE
	do
		#Calculating EX_X, EL_Y,EL_Z from epp_stack
		EL_X=$(echo $proc | tr "," " " | awk '{print $1}')
		EL_Y=$(echo $proc | tr "," " " | awk '{print $2}')
		EL_Z=$(echo $proc | tr "," " " | awk '{print $3}')

		for ele in $epp_stack
		do
			if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ];
			then
				sbatch $1'/job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'
			fi
		done
	done
done
echo "* * * * -----------Completed!----------- * * * *"
