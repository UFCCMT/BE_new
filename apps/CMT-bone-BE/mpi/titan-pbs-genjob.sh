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
#E_SIZE=$(seq 5 25)
#EPP="1,1,1;2,2,2;5,5,2;5,5,4"
#CART="2,2,2;4,4,2;8,5,5;13,13,8;32,16,16"

#Test case
E_SIZE="6 8 13 16 19 21 24"
EPP="5,4,4" #"7,5,2;5,5,5;6,6,5"
CART="4,4,2;8,4,4;8,8,8;16,16,8;16,16,16"
PHY_PARAM=5

#Creating stack for different EPP and CART
epp_stack=$(echo $EPP | tr ";" "\n")
cart_stack=$(echo $CART | tr ";" "\n")

#user variables for # of nodes calcution
Tlnum_proc=16
one=1

#Check for job dir to store job scripts
if [ ! -d "$1" ]; then
    mkdir $1/
fi

#Check for data dir to store *.out and *.err
if [ ! -d "$2" ]; then
    mkdir $2/
fi

echo "Creating job file(s)..."
  
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
  #Looping on ELEMENT_SIZE
  for ELE_SIZE in $E_SIZE
  do
    for ele in $epp_stack
    do
      #Calculating EL_X, EL_Y,EL_Z from epp_stack
      EL_X=$(echo $ele | tr "," " " | awk '{print $1}')
      EL_Y=$(echo $ele | tr "," " " | awk '{print $2}')
      EL_Z=$(echo $ele | tr "," " " | awk '{print $3}')
      Exyz=$((EL_X*EL_Y*EL_Z))

      #Time assignment
      if [ $ELE_SIZE -le 13 ];
        then
          wtime="00:15:00"
      elif [ $ELE_SIZE -gt 13 ] && [ $ELE_SIZE -le 20 ]; 
        then
          wtime="00:30:00"
      elif [ $ELE_SIZE -gt 20 ] && [ $ELE_SIZE -le 22 ]; 
        then
          wtime="00:45:00"
      elif [ $ELE_SIZE -gt 22 ] && [ $ELE_SIZE -le 24 ]; 
        then
          wtime="01:00:00"
      elif [ $ELE_SIZE -eq 25 ]; 
        then
          wtime="01:15:00"
      fi

    echo '#!/bin/bash' > jobfile
	  echo "##### These lines are for PBS" >> jobfile
	  echo "#PBS -l nodes=$NUM_NODES" >> jobfile
	  echo '#PBS -N job-bonebe-es'$ELE_SIZE'ec'$Exyz'np'$NUM_TASKS'.job' >> jobfile	#Job name
	  echo "#PBS -l walltime=$wtime" >> jobfile
	  echo "#PBS -A CSC188" >> jobfile
	  echo '#PBS -o '$2'/bonebe-es'$ELE_SIZE'ec'$Exyz'np'$NUM_TASKS'.csv' >> jobfile	#STDOUT
	  echo '#PBS -e '$2'/bonebe-es'$ELE_SIZE'ec'$Exyz'np'$NUM_TASKS'.err' >> jobfile	#STDERR
	  echo "" >> jobfile 
	  echo " cd $MEMBERWORK" >> jobfile
	  echo "" >> jobfile
	  echo "aprun -n$NUM_TASKS /ccs/home/arav1994/titan-validation/cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z" >> jobfile
	  mv jobfile job-bonebe'-es'$ELE_SIZE'ec'$Exyz'np'$NUM_TASKS'.job'
      mv job-bonebe'-es'$ELE_SIZE'ec'$Exyz'np'$NUM_TASKS'.job' $1/
	  done
  done
done

echo "Job file(s) created!"
echo " "
echo "Listing Jobfile(s):"
echo "---------------------------------------------------------------"
ls $1/
echo "----------------------------------------------------------------"
sleep 2
echo " "
echo "Job file(s) present in $1 folder"
echo "Output and error files present in $2 folder"
echo " "

#Submit jobscript
echo "Submitting Job files:-"

for proc in $cart_stack
do
  #Calcuting CART_X, CART_Y, CART_Z from cart_stack
  CART_X=$(echo $proc | tr "," " " | awk '{print $1}')
  CART_Y=$(echo $proc | tr "," " " | awk '{print $2}')
  CART_Z=$(echo $proc | tr "," " " | awk '{print $3}')
  NUM_TASKS=$((CART_X*CART_Y*CART_Z))

  for ELE_SIZE in $E_SIZE
  do
  	for ele in $epp_stack
    do
      #Calculating EX_X, EL_Y,EL_Z from epp_stack
      EL_X=$(echo $ele | tr "," " " | awk '{print $1}')
      EL_Y=$(echo $ele | tr "," " " | awk '{print $2}')
      EL_Z=$(echo $ele | tr "," " " | awk '{print $3}')
      Exyz=$((EL_X*EL_Y*EL_Z))

	  #if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
 	  #then
	    qsub $1/job-bonebe'-es'$ELE_SIZE'ec'$Exyz'np'$NUM_TASKS'.job'
	  #fi
    done
	done
done

echo "* * * * -----------Completed!----------- * * * *"
