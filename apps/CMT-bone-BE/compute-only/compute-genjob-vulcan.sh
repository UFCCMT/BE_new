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
#E_SIZE="5 10 15 20 25"
#EPP="2,2,2;4,3,2;7,5,2;5,5,5;6,6,5"
#CART="2,2,2;4,4,2;8,5,5;13,13,8;32,16,16"
E_SIZE=$(seq 5 25)
EPP="2,2,2" #"7,5,2;5,5,5;6,6,5"
#CART="2,2,2;4,4,2;8,5,5;13,13,8;32,16,16"
PHY_PARAM=5

#Creating stack for different EPP and CART
epp_stack=$(echo $EPP | tr ";" "\n")
#cart_stack=$(echo $CART | tr ";" "\n")

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

	  #if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
 	  #then
	    #Making the job script
	    echo '#!/bin/bash' > jobfile
	    echo "##### These lines are for Moab" >> jobfile
	    echo '#MSUB -d '`pwd` >> jobfile
	    echo '#MSUB -N job-bonebe-es'$ELE_SIZE'ec'$Exyz'.job' >> jobfile	#Job name
	    #echo "#MSUB -l nodes=$NUM_NODES" >> jobfile		#Number of MPI ranls
	    echo "#MSUB -l partition=vulcan" >> jobfile			#Number of cores per MPI rank
	    echo "#MSUB -q psmall" >> jobfile		#Number of Nodes
	    #echo "#MSUB -m a" >> jobfile			#Mailing job status
	    echo "#MSUB -l walltime=$wtime" >> jobfile				#Walltime
	    echo '#MSUB -o '$2'/bonebe-es'$ELE_SIZE'ec'$Exyz'.csv' >> jobfile	#STDOUT
	    echo '#MSUB -e '$2'/bonebe-es'$ELE_SIZE'ec'$Exyz'.err' >> jobfile	#STDERR
	    echo " " >> jobfile
	    echo "./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z" >> jobfile
	    mv jobfile job-bonebe'-es'$ELE_SIZE'ec'$Exyz'.job'
      mv job-bonebe'-es'$ELE_SIZE'ec'$Exyz'.job' $1/
 	  #fi
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
	    msub $1/job-bonebe'-es'$ELE_SIZE'ec'$Exyz'.job'
	  #fi
	  done
  done


echo "* * * * -----------Completed!----------- * * * *"
