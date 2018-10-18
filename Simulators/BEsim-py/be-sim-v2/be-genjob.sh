#!/bin/bash

if [ $# -lt 2 ]; then
        echo "x---x---x---x---x---x---x---x---x"
        echo "No command line argument supplied"
        echo "Run again with jobscript and data folder name as cmd line inputs"
	echo "Usage: ./be-genjob.sh <job_folder> <data_folder>"
        echo "x---x---x---x---x---x---x---x---x"
        exit 0
fi

#bone-be parameters
TIMESTEP=100
E_SIZE="5 6 8 9 11 13 14 16 17 19 20 21 23 24 25"
EPP="100"
PHY_PARAM=5

#Test case!!
#E_SIZE=5
#EPP=8 #"8 24 70 125 180"
#CART_X=32
#CART_Y=16
#CART_Z=16
#CART="8 32 200 1352 8192"

#Machine Parameters
#NUM_TASKS=$((CART_X*CART_Y*CART_Z))
NP="32 128 512 2048 8192 32768 131072" 
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

#Check for job dir to store job scripts
if [ ! -d "$1" ]; then
    mkdir $1/
fi

#Check for data dir to store *.out and *.err
if [ ! -d "$2" ]; then
    mkdir $2/
    mkdir $2/err
fi

echo "Creating job file(s)..."

for ELE_SIZE in $E_SIZE
do
  for EC in $EPP
  do
    for NUM_TASKS in $NP
    do
      #Time and memory assignment
      if [ $NUM_TASKS -eq 32768 ];
        then
        MEM="6gb"
        if [ $EC -le 100 ]; then
          wtime="10:30:00"
        elif [ $EC -eq 125 ]; then
          wtime="11:30:00"
        else
          wtime="11:59:00"
        fi
      elif [ $NUM_TASKS -eq 32768 ];
        then
        MEM="5gb"
        if [ $EC -le 100 ]; then
          wtime="09:30:00"
        elif [ $EC -eq 125 ]; then
          wtime="10:20:00"
        else
          wtime="11:30:00"
        fi
      elif [ $NUM_TASKS -eq 8192 ];
        then
        MEM="4gb"
        if [ $EC -le 100 ]; then
          wtime="08:00:00"
        elif [ $EC -eq 125 ]; then
          wtime="09:20:00"
        else
          wtime="11:30:00"
        fi
      elif [ $NUM_TASKS -eq 2048 ]; 
        then
        MEM="4gb"
        if [ $EC -le 100 ]; then
          wtime="07:00:00"
        elif [ $EC -eq 125 ]; then
          wtime="08:00:00"
        else
          wtime="09:00:00"
        fi
      elif [ $NUM_TASKS -eq 512 ]; 
        then
        MEM="2gb"
        if [ $EC -le 100 ]; then
          wtime="02:30:00"
        elif [ $EC -eq 125 ]; then
          wtime="03:15:00"
        elif [ $EC -eq 180 ]; then
          wtime="03:45:00"
        else
          wtime="04:00:00"
        fi
      elif [ $NUM_TASKS -eq 128 ]; 
        then
        MEM="1gb"
        if [ $EC -le 100 ]; then
          wtime="00:30:00"
        elif [ $EC -eq 125 ]; then
          wtime="00:45:00"
        else
          wtime="01:00:00"
        fi
      elif [ $NUM_TASKS -eq 32 ]; 
        then
        MEM="1gb"
        if [ $EC -le 100 ]; then
          wtime="00:30:00"
        elif [ $EC -eq 125 ]; then
          wtime="00:45:00"
        else
          wtime="01:45:00"
        fi
      fi
#  	  if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
#  	  then
      	  #Making the job script
      	  echo '#!/bin/bash' > jobfile
      	  echo '#SBATCH -D '`pwd` >> jobfile
      	  echo '#SBATCH --job-name=be_sim-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.job' >>jobfile	#Job name
      	  echo '#SBATCH --mail-type=FAIL' >> jobfile		#Mail events (NONE,BEGIN,END,FAIL,ALL)
      	  echo '#SBATCH --mail-user=aravindneela@ufl.edu'  >>jobfile		#your email id
      	  echo "#SBATCH --ntasks=1" >> jobfile		#Number of MPI ranls
      	  echo "#SBATCH --cpus-per-task=1" >> jobfile			#Number of cores per MPI rank
      	  #echo "#SBATCH --nodes=$NUM_NODES" >> jobfile		#Number of Nodes
      	  echo "#SBATCH --mem-per-cpu=$MEM" >> jobfile			#Per processor memory
      	  echo "#SBATCH -t $wtime" >> jobfile				#Walltime
      	  #echo '#SBATCH -o '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' >> jobfile	#STDOUT
      	  echo '#SBATCH -e '$2'/err/be_sim-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.err' >> jobfile	#STDERR
      	  echo " " >> jobfile
	  echo "module purge" >> jobfile
      	  echo "module load gcc/5.2.0 python/2.7.10" >> jobfile
      	  echo " " >> jobfile
      	  echo './simulator.py input/vulcan-proper-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.py -n '$TIMESTEP' 100 -v -q -o '$2'/be-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.txt | grep "Statistics :: " >> '$2'/be-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.txt' >> jobfile
      	  mv jobfile be_sim'-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.job'
          mv be_sim'-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.job' $1
#  	  fi
    done    
  done
done

echo "Job file(s) created!"
echo " "
echo "Listing Jobfile(s):"
echo "---------------------------------------------------------------"
ls $1
echo "----------------------------------------------------------------"
sleep 2
echo " "
echo "Job file(s) present in $1/ folder"
echo "Output and error files present in $2/ folder"
echo " "

#Submit jobscript
echo "Submitting Job files:-"

for ELE_SIZE in $E_SIZE
do
 for EC in $EPP
 do
  for NUM_TASKS in $NP
  do
#   if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ];
#   then
      sbatch $1/be_sim'-es'$ELE_SIZE'ec'$EC'np'$NUM_TASKS'.job'
#   fi
  done
 done
done

echo "* * * * -----------Completed!----------- * * * *"
