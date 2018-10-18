#To add an app
  #Update app List
  #update setApp function
  #define all functions in app superclass


appList = ["cmtbbe", "lulesh", "mmult"]			#TJL: Need to make these superclasses
machList = ["hipergator", "cab", "vulcan"]

#<Functions>
def setApp(appName):				#TJL: Would like a better way of adding/keeping apps
  if(appName == "cmtbbe"):
    return cmtBoneBE()
  if(appName == "lulesh"):
    return lulesh()
  if(appName == "mmult"):
    return matrix_mult()

def setMach(machName):
  if(machName == "hipergator"):			#TJL: Would like a better way of adding/keeping machines
    return hipergator()
#</Functions>


class machine:
  machName = "unset"
  schedulerType = "unset"
  
  def getMachName(self):
    return self.machName
  
  def getSchedulerType(self):
    return self.schedulerType
  
class app:
  appName = "unset"
  appParamList = ["unset"]
  auxAppParamList =["unset"]
  varParamList = ["unset"]
  machParamList = ["unset"]

class matrix_mult(app):
  appName = "m_mult"
  appParamList = ["MATRIX_SIZE_LIST=\"10 100 1000\"", "NUM_TASKS_LIST=\"1 2 3 4\""] #What other parameters could we add
  auxAppParamList =[""]
  varParamList = ["CUR_MATRIX_SIZE", "CUR_NUM_TASKS"]
  varParamIter = ["$MATRIX_SIZE_LIST", "$NUM_TASKS_LIST"]
  machParamList = [""]
  
  def getAppName(self):				#TJL: Maybe remove getters and setters? Access fields with dot operator?
    return self.appName
  
  def printAppParams(self, tabCount):
    for i in self.appParamList:
      print i
    print ""
    for i in self.auxAppParamList:
      print i
    print""
  
  def printAppSubmitParams(self, tabCount):
    print "\t"*tabCount + "#No App submit params to do\n"
  
  def printMachParams(self, tabCount):
    print "\t"*tabCount + "#Machine Parameters have not yet been defined"
    
  def printMachSubmitParams(self, tabCount):
    print "\t"*tabCount + "#Machine Submission Parameters have not yet been defined"
  
  def printSubmitMoabJob(self, tabCount):
    print "\t"*tabCount + "#MOAB not implemented yet"
  
  def printSubmitSlurmJob(self, tabCount):
    print "\t"*tabCount + "sbatch $1/matrix_mult$CUR_MATRIX_SIZE'np'$CUR_NUM_TASKS'.job'"
    
  #I don't think that I actually need any of these parameters
  def printMoabSchedule(self, tabCount):					#TJL: MOAB/SLURM Schedule print routines can, for the most part, be moved out of the app functions
    print "\t"*tabCount + "MOAB version coming soon!\""

  def printTimeAssignment(self, tabCount):
    print "\t"*tabCount + "wtime=\"00:5:00\""			#TJL: Left as a constant for now. Need a way for lulesh
  
  def printSlurmSchedule(self, tabCount):					#TJL: If a lot of this is the same, can moved to a function shared between apps
    print "\t"*tabCount + "#Making the job script"
    print "\t"*tabCount + 'echo \'#!/bin/bash\' > jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH -D \'`pwd` >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --job-name=matrix_mult\'$CUR_MATRIX_SIZE\'np\'$CUR_NUM_TASKS\'.job\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --mail-type=ALL\' >> jobfile            #Mail events (NONE,BEGIN,END,FAIL,ALL)'
    print "\t"*tabCount + 'echo \'#SBATCH --mail-user=johnson@hcs.ufl.edu\'  >>jobfile            #your email id'
    print "\t"*tabCount + 'echo \"#SBATCH --ntasks=$CUR_NUM_TASKS" >> jobfile         #Number of MPI ranls'
    print "\t"*tabCount + 'echo \'#SBATCH --account=ccmt\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --qos=ccmt\' >> jobfile'
    print "\t"*tabCount + 'echo \"#SBATCH --mem-per-cpu=1mb" >> jobfile                   #Per processor memory'
    print "\t"*tabCount + 'echo \"#SBATCH -t 00:15:00" >> jobfile                         #Walltime'
    print "\t"*tabCount + 'echo \'#SBATCH -o \'$2\'/matrix_mult\'$CUR_MATRIX_SIZE\'np\'$CUR_NUM_TASKS\'.out\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH -e \'$2\'/matrix_mult\'$CUR_MATRIX_SIZE\'np\'$CUR_NUM_TASKS\'.err\''' >> jobfile'
    print "\t"*tabCount + 'echo \" " >> jobfile'
    print "\t"*tabCount + 'echo \"module load intel/2016.0.109 openmpi/1.10.2" >> jobfile'
    print "\t"*tabCount + 'echo \" " >> jobfile'
    print "\t"*tabCount + 'echo \"mpirun -np $CUR_NUM_TASKS ./mat_mult.o $CUR_SIZE" >> jobfile'
    print "\t"*tabCount + 'mv jobfile matrix_mult$CUR_MATRIX_SIZE\'np\'$CUR_NUM_TASKS.job'
    print "\t"*tabCount + 'mv matrix_mult$CUR_MATRIX_SIZE\'np\'$CUR_NUM_TASKS.job $1'
    print " "


class lulesh(app):
  appName = "lulesh"
  appParamList = ["SIZE=10 100 1000", "ITER=20"]
  auxAppParamList =[""]
  varParamList = ["SIZE"]
  machParamList = [""]
  
  def getAppName(self):				#TJL: Maybe remove getters and setters? Access fields with dot operator?
    return self.appName
  
  def printAppParams(self, tabCount):
    for i in self.appParamList:
      print i
    print ""
    for i in self.auxAppParamList:
      print i
    print""
      
  def printMachParams(self, tabCount):
    print "\t"*tabCount + "#Machine Parameters have not yet been defined"
  
  def printSubmitMoabJob(self, tabCount):
    print "\t"*tabCount + "Need an example of lulesh MOAB submission"
  
  def printSubmitSlurmJob(self, tabCount):
    print "\t"*tabCount + "Need an example of lulesh Slurm submission"
    
  #I don't think that I actually need any of these parameters
  def printMoabSchedule(self, tabCount):					#TJL: MOAB/SLURM Schedule print routines can, for the most part, be moved out of the app functions
    #if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
    #then
    #Making the job script
    print "\t"*tabCount + "echo '#!/bin/bash' > jobfile"
    print "\t"*tabCount + "echo \"##### These lines are for Moab\" >> jobfile"
    print "\t"*tabCount + "echo '#MSUB -d '`pwd` >> jobfile"
    print "\t"*tabCount + "echo '#MSUB -N job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' >>jobfile	#Job name"
    print "\t"*tabCount + "echo \"#MSUB -l nodes=$NUM_NODES\" >> jobfile		#Number of MPI ranls"
    print "\t"*tabCount + "echo \"#MSUB -l partition=vulcan\" >> jobfile			#Number of cores per MPI rank"
    print "\t"*tabCount + "echo \"#MSUB -q psmall\" >> jobfile		#Number of Nodes"
    print "\t"*tabCount + "#echo \"#MSUB -m a\" >> jobfile			#Mailing job status"
    print "\t"*tabCount + "echo \"#MSUB -l walltime=$wtime\" >> jobfile"				#Walltime
    print "\t"*tabCount + "echo '#MSUB -o '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' >> jobfile	#STDOUT"
    print "\t"*tabCount + "echo '#MSUB -e '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.err' >> jobfile	#STDERR"
    print "\t"*tabCount + "echo " " >> jobfile"
    print "\t"*tabCount + "echo \"srun -n $NUM_TASKS ./lulesh2.0 $SIZE $ITER"
    print "\t"*tabCount + "mv jobfile job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'"
    print "\t"*tabCount + "mv job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' $1/"
    print "\t"*tabCount + "#fi"

  def printTimeAssignment(self, tabCount):
    print "\t"*tabCount + "#wtime=\"00:15:00\""			#TJL: Left as a constant for now. Need a way for lulesh
  
  def printSlurmSchedule(self, tabCount):					#TJL: If a lot of this is the same, can moved to a function shared between apps
    print "\t"*tabCount + "if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; "
    print "\t"*tabCount + "then"
    tabCount += 1
    print "\t"*tabCount + "#Making the job script"
    print "\t"*tabCount + 'echo \'#!/bin/bash\' > jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH -D \'`pwd` >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --job-name=job-bonebe-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.job\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --mail-type=FAIL\' >> jobfile            #Mail events (NONE,BEGIN,END,FAIL,ALL)'
    print "\t"*tabCount + 'echo \'#SBATCH --mail-user=johnson@hcs.ufl.edu\'  >>jobfile            #your email id'
    print "\t"*tabCount + 'echo \"#SBATCH --ntasks=$NUM_TASKS" >> jobfile         #Number of MPI ranls'
    print "\t"*tabCount + 'echo \'#SBATCH --account=ccmt\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --qos=ccmt\' >> jobfile'
    print "\t"*tabCount + 'echo \"#SBATCH --cpus-per-task=1" >> jobfile                   #Number of cores per MPI rank'
    print "\t"*tabCount + 'echo \"#SBATCH --nodes=$NUM_NODES" >> jobfile          #Number of Nodes'
    print "\t"*tabCount + 'echo \"#SBATCH --ntasks-per-socket=16" >> jobfile             #Number of tasks per socket'
    print "\t"*tabCount + 'echo \"#SBATCH --exclusive" >> jobfile                        #Making the node exclusive to the job'
    print "\t"*tabCount + 'echo \"#SBATCH --distribution=cyclic:block" >> jobfile        #Having cyclic instead of round robin'
    print "\t"*tabCount + 'echo \"#SBATCH --mem-per-cpu=1gb" >> jobfile                   #Per processor memory'
    print "\t"*tabCount + 'echo \"#SBATCH -t 00:15:00" >> jobfile                         #Walltime'
    print "\t"*tabCount + 'echo \'#SBATCH -o \'$2\'/bonebe-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.out\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH -e \'$2\'/bonebe-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.err\' >> jobfile'
    print "\t"*tabCount + 'echo \" " >> jobfile'
    print "\t"*tabCount + 'echo \"module load intel/2016.0.109 openmpi/1.10.2" >> jobfile'
    print "\t"*tabCount + 'echo \" " >> jobfile'
    print "\t"*tabCount + 'echo \"mpirun -np $NUM_TASKS ./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z"'
    print "\t"*tabCount + 'mv jobfile job-bonebe\'-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.job\''
    print "\t"*tabCount + 'mv job-bonebe\'-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.job\' $1'

    print "\t"*tabCount + "fi"
    
#Notes:
  # echo "string" and 'string' are the same right? Because assuming they are eliminates need for \' or \"
  
  #def printMoabSchedule(esize, ex, ey, ez, numTasks, numNodes, cartx, carty, cartz, tabCount):
      #print "Moab Schedule lines here"
    #print "echo '#!/bin/bash' > jobfile"
    #print "echo "#### These lines are for MOAB" >> jobfile"						#TJL: something weird is happening here...
    #print "echo '#MSUB -d '`pwd` >> jobfile"
    #print "echo '#MSUB -N job=bonebe-es'$" + esize + "'ex'$" + ex + "'ey'$" + ey + "'ez'$" + ez + "'np'$" + numTasks + "'.job' >>jobfile\t #Job name"
    #print "echo '#MSUB -l nodes=$' + numNodes + '\" >> jobfile \t#Number of MPI ranks"
    #print "echo '#MSUB -l partition=vulcan' >> jobfile \t#Number of cores per MPI rank"			#TJL: Technically should be machine dependent too...
    #print "echo '#MSUB =q psmall' >> jobfile \t#Number of Nodes"
    #print "#echo '#MSUB -m a' >> jobfile \t#Mailing Job Status"
    #print "echo '#MSUB -l walltime=$wtime' >> jobfile \t#Walltime"
    #print "echo '#MSUB -o '$2'/bonebe-es'$" + esize + "'ex'$" + ex + "'ey'$" + ey + "'ez'$" + ez + "'np'$" + numTasks + "'.out' >>jobfile\t #STDOUT"
    #print "echo '#MSUB -e '$2'/bonebe-es'$" + esize + "'ex'$" + ex + "'ey'$" + ey + "'ez'$" + ez + "'np'$" + numTasks + "'.err' >>jobfile\t #STDERR"
    #print "echo ' ' >> jobfile
    #print "echo "srun -n 
    
class hipergator(machine):
  
  machName = "hipergator"
  schedulerType = "slurm"
  
  def getMachName(self):
    return self.machName
  
  def getSchedulerType(self):
    return self.schedulerType

class cmtBoneBE(app):
  
  appName = "CMT_Bone_BE"
  appParamList = ["TIMESTEP=100", "E_SIZE=\"15 20 25\"", "EPP=\"7,5,2;5,5,5;6,6,5\"","CART=\"2,2,2;4,4,2;8,5,5;13,13,8;32,32,16\"", "PHY_PARAM=5"]
  auxAppParamList =["#Creating stack for different EPP and CART","epp_stack=$(echo $EPP | tr \";\" \"\\n\")","cart_stack=$(echo $CART | tr \";\" \"\\n\")","\n","#user variables for # of nodes calcution","Tlnum_proc=16","one=1"]
  #varParamList = ["proc","E_SIZE", "E_Z", "E_Y", "E_X"]
  varParamList = ["proc","ELE_SIZE", "ele"]
  varParamIter = ["$cart_stack","$E_SIZE", "$epp_stack"]
  machParamList = ["NUM_TASKS=$((CART_X*CART_Y*CART_Z))","NUM_NODES1=$((NUM_TASKS/Tlnum_proc))","NUM_NODESr=$((NUM_TASKS%Tlnum_proc))"]
  
  def getAppName(self):
    return self.appName
  
  def printAppParams(self, tabCount):
    for i in self.appParamList:
      print i
    print ""
    for i in self.auxAppParamList:
      print i
    print""
      
  def printMachParams(self, tabCount):
    print "\t"*tabCount + "#Calcuting CART_X, CART_Y, CART_Z from cart_stack"		#TJL: SHould look at putting this somewhere else
    print "\t"*tabCount + "CART_X=$(echo $proc | tr \",\" \" \" | awk '{print $1}')"
    print "\t"*tabCount + "CART_Y=$(echo $proc | tr \",\" \" \" | awk '{print $2}')"
    print "\t"*tabCount + "CART_Z=$(echo $proc | tr \",\" \" \" | awk '{print $3}')"
    print ""
    print "\t#Machine Parameters"
    for i in self.machParamList:
      print "\t"*tabCount + i
    print ""
    print "\t"*tabCount + "if [ $NUM_NODESr -eq 0 ];"
    print "\t"*tabCount + "then"
    print "\t"*(tabCount+1) + "NUM_NODES=$NUM_NODES1"
    print "\t"*tabCount + "else"
    print "\t"*(tabCount+1) + "NUM_NODES=$((NUM_NODES1+one))"
    print "\t"*(tabCount) + "fi"
    print ""
    
    
  def printMachSubmitParams(self, tabCount):
    print "\t"*tabCount + "#Calcuting CART_X, CART_Y, CART_Z from cart_stack"		#TJL: SHould look at putting this somewhere else
    print "\t"*tabCount + "CART_X=$(echo $proc | tr \",\" \" \" | awk '{print $1}')"
    print "\t"*tabCount + "CART_Y=$(echo $proc | tr \",\" \" \" | awk '{print $2}')"
    print "\t"*tabCount + "CART_Z=$(echo $proc | tr \",\" \" \" | awk '{print $3}')"
    print "\t"*tabCount + "NUM_TASKS=$((CART_X*CART_Y*CART_Z))"
    print ""
  
  #def printCartValues(self, tabCount):							#TJL: THis should  not/cannot be a top level function to outsiders
    
    
  def printEppValues(self, tabCount):							#TJL: THis should  not/cannot be a top level function to outsiders
    print "\t"*tabCount + "#Calculating EX_X, EL_Y,EL_Z from epp_stack"
    print "\t"*tabCount + "EL_X=$(echo $proc | tr \",\" \" \" | awk '{print $1}')"
    print "\t"*tabCount + "EL_Y=$(echo $proc | tr \",\" \" \" | awk '{print $2}')"
    print "\t"*tabCount + "EL_Z=$(echo $proc | tr \",\" \" \" | awk '{print $3}')"
    print ""

  def printAppSubmitParams(self, tabCount):							#TJL: THis should  not/cannot be a top level function to outsiders
    print "\t"*tabCount + "#Calculating EX_X, EL_Y,EL_Z from epp_stack"
    print "\t"*tabCount + "EL_X=$(echo $proc | tr \",\" \" \" | awk '{print $1}')"
    print "\t"*tabCount + "EL_Y=$(echo $proc | tr \",\" \" \" | awk '{print $2}')"
    print "\t"*tabCount + "EL_Z=$(echo $proc | tr \",\" \" \" | awk '{print $3}')"
    print ""
  
  def printSubmitMoabJob(self, tabCount):
    print "\t"*tabCount + "msub $1/job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'"
  
  def printSubmitSlurmJob(self, tabCount):
    print "\t"*tabCount + "if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ];"
    print "\t"*tabCount + "then"
    tabCount += 1
    print "\t"*tabCount + "sbatch $1'/job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'"
    tabCount -= 1
    print "\t"*tabCount + "fi"
    
  #I don't think that I actually need any of these parameters
  def printMoabSchedule(self, tabCount):
    #if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; 
    #then
    #Making the job script
    print "\t"*tabCount + "echo '#!/bin/bash' > jobfile"
    print "\t"*tabCount + "echo \"##### These lines are for Moab\" >> jobfile"
    print "\t"*tabCount + "echo '#MSUB -d '`pwd` >> jobfile"
    print "\t"*tabCount + "echo '#MSUB -N job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' >>jobfile	#Job name"
    print "\t"*tabCount + "echo \"#MSUB -l nodes=$NUM_NODES\" >> jobfile		#Number of MPI ranls"
    print "\t"*tabCount + "echo \"#MSUB -l partition=vulcan\" >> jobfile			#Number of cores per MPI rank"
    print "\t"*tabCount + "echo \"#MSUB -q psmall\" >> jobfile		#Number of Nodes"
    print "\t"*tabCount + "#echo \"#MSUB -m a\" >> jobfile			#Mailing job status"
    print "\t"*tabCount + "echo \"#MSUB -l walltime=$wtime\" >> jobfile"				#Walltime
    print "\t"*tabCount + "echo '#MSUB -o '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' >> jobfile	#STDOUT"
    print "\t"*tabCount + "echo '#MSUB -e '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.err' >> jobfile	#STDERR"
    print "\t"*tabCount + "echo " " >> jobfile"
    print "\t"*tabCount + "echo \"srun -n $NUM_TASKS ./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z\" >> jobfile"
    print "\t"*tabCount + "mv jobfile job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'"
    print "\t"*tabCount + "mv job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' $1/"
    print "\t"*tabCount + "#fi"

  def printTimeAssignment(self, tabCount):
    print "\t"*tabCount + "#Calcuting EL_X, EL_Y, EL_Z from epp_stack"			#TJL: Ideally called by a subfunction to do
    print "\t"*tabCount + "EL_X=$(echo $proc | tr \",\" \" \" | awk '{print $1}')"
    print "\t"*tabCount + "EL_Y=$(echo $proc | tr \",\" \" \" | awk '{print $2}')"
    print "\t"*tabCount + "EL_Z=$(echo $proc | tr \",\" \" \" | awk '{print $3}')"
    print "\t"*tabCount + "Exyz=$((EL_X*EL_Y*EL_Z))"
    print " "
    print "\t"*tabCount + "#Time assignment"
    print "\t"*tabCount + "if [ $ELE_SIZE -eq 5 ];"
    tabCount += 1
    print "\t"*tabCount + "then"
    print "\t"*tabCount + "if [ $Exyz -le 150 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"00:15:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 180 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"00:20:00\""
    print "\t"*tabCount + "else"
    print "\t"*(tabCount + 1) + "wtime=\"00:30:00\""
    print "\t"*tabCount + "fi"
    tabCount -= 1
    print "\t"*tabCount + "elif [ $ELE_SIZE -eq 10 ];"
    tabCount += 1
    print "\t"*tabCount + "then"
    print "\t"*tabCount + "if [ $Exyz -le 150 ]; then"
    print "\t"*(tabCount + 1) +  "wtime=\"00:20:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 180 ]; then"
    print "\t"*(tabCount + 1) +  "wtime=\"00:30:00\""
    print "\t"*tabCount + "else"
    print "\t"*(tabCount + 1) +  "wtime=\"01:10:00\""
    print "\t"*tabCount + "fi"
    tabCount -= 1
    print "\t"*tabCount + "elif [ $ELE_SIZE -eq 15 ];"
    tabCount += 1
    print "\t"*tabCount + "then"
    print "\t"*tabCount + "if [ $Exyz -le 100 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"00:30:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 125 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"01:15:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 180 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"01:45:00\""
    print "\t"*tabCount + "else"
    print "\t"*(tabCount + 1) + "wtime=\"02:00:00\""
    print "\t"*tabCount + "fi"
    tabCount -= 1
    print "\t"*tabCount + "elif [ $ELE_SIZE -eq 20 ];"
    tabCount += 1
    print "\t"*tabCount + "then"
    print "\t"*tabCount + "if [ $Exyz -le 50 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"00:40:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 70 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"04:00:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 125 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"08:00:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 180 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"10:00:00\""
    print "\t"*tabCount + "else"
    print "\t"*(tabCount + 1) + "wtime=\"02:30:00\""
    print "\t"*tabCount + "fi"
    tabCount -= 1
    print "\t"*tabCount + "elif [ $ELE_SIZE -eq 25 ];"
    tabCount += 1
    print "\t"*tabCount + "then"
    print "\t"*tabCount + "if [ $Exyz -le 50 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"00:50:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 70 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"08:30:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 125 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"11:00:00\""
    print "\t"*tabCount + "elif [ $Exyz -eq 180 ]; then"
    print "\t"*(tabCount + 1) + "wtime=\"11:59:59\""
    print "\t"*tabCount + "else"
    print "\t"*(tabCount + 1) + "wtime=\"02:45:00\""
    print "\t"*tabCount + "fi"
    tabCount -= 1
    print "\t"*tabCount + "fi"
  
  def printSlurmSchedule(self, tabCount):
    print "\t"*tabCount + "if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ];"
    print "\t"*tabCount + "then"
    tabCount += 1
    print "\t"*tabCount + '#Making the job script'
    print "\t"*tabCount + 'echo \'#!/bin/bash\' > jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH -D \'`pwd` >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --job-name=job-bonebe-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.job\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --mail-type=FAIL\' >> jobfile            #Mail events (NONE,BEGIN,END,FAIL,ALL)'
    print "\t"*tabCount + 'echo \'#SBATCH --mail-user=johnson@hcs.ufl.edu\'  >>jobfile            #your email id'
    print "\t"*tabCount + 'echo "#SBATCH --ntasks=$NUM_TASKS" >> jobfile         #Number of MPI ranls'
    print "\t"*tabCount + 'echo \'#SBATCH --account=ccmt\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH --qos=ccmt\' >> jobfile'
    print "\t"*tabCount + 'echo "#SBATCH --cpus-per-task=1" >> jobfile                   #Number of cores per MPI rank'
    print "\t"*tabCount + 'echo "#SBATCH --nodes=$NUM_NODES" >> jobfile          #Number of Nodes'
    print "\t"*tabCount + 'echo "#SBATCH --ntasks-per-socket=16" >> jobfile             #Number of tasks per socket'
    print "\t"*tabCount + 'echo "#SBATCH --exclusive" >> jobfile                        #Making the node exclusive to the job'
    print "\t"*tabCount + 'echo "#SBATCH --distribution=cyclic:block" >> jobfile        #Having cyclic instead of round robin'
    print "\t"*tabCount + 'echo "#SBATCH --mem-per-cpu=1gb" >> jobfile                   #Per processor memory'
    print "\t"*tabCount + 'echo "#SBATCH -t 00:15:00" >> jobfile                         #Walltime'
    print "\t"*tabCount + 'echo \'#SBATCH -o \'$2\'/bonebe-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.out\' >> jobfile'
    print "\t"*tabCount + 'echo \'#SBATCH -e \'$2\'/bonebe-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.err\' >> jobfile'
    print "\t"*tabCount + 'echo " " >> jobfile'
    print "\t"*tabCount + 'echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile'
    print "\t"*tabCount + 'echo " " >> jobfile'
    print "\t"*tabCount + 'echo "mpirun -np $NUM_TASKS ./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z"'
    print "\t"*tabCount + 'mv jobfile job-bonebe\'-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.job\''
    print "\t"*tabCount + 'mv job-bonebe\'-es\'$ELE_SIZE\'ex\'$EL_X\'ey\'$EL_Y\'ez\'$EL_Z\'np\'$NUM_TASKS\'.job\' $1'
    tabCount -= 1
    print "\t"*tabCount + 'fi'
    
#Notes:
  # echo "string" and 'string' are the same right? Because assuming they are eliminates need for \' or \"
  
  def printMoabSchedule(esize, ex, ey, ez, numTasks, numNodes, cartx, carty, cartz, tabCount):
      #print "Moab Schedule lines here"
    print "\t"*tabCount + "if [ $EL_X = $EL_Y ] && [ $EL_Y = $EL_Z ]; "
    print "\t"*tabCount + "echo '#!/bin/bash' > jobfile"
    print "\t"*tabCount + "echo '##### These lines are for Moab\" >> jobfile"
    print "\t"*tabCount + "echo '#MSUB -d '`pwd` >> jobfile"
    print "\t"*tabCount + "echo '#MSUB -N job-bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' >>jobfile	#Job name"
    print "\t"*tabCount + "echo '#MSUB -l nodes=$NUM_NODES\" >> jobfile		#Number of MPI ranls"
    print "\t"*tabCount + "echo '#MSUB -l partition=vulcan\" >> jobfile			#Number of cores per MPI rank"
    print "\t"*tabCount + "echo '#MSUB -q psmall\" >> jobfile		#Number of Nodes"
    print "\t"*tabCount + "echo '#MSUB -l walltime=$wtime\" >> jobfile				#Walltime"
    print "\t"*tabCount + "echo '#MSUB -o '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.out' >> jobfile	#STDOUT"
    print "\t"*tabCount + "echo '#MSUB -e '$2'/bonebe-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.err' >> jobfile	#STDERR"
    print "\t"*tabCount + "echo " " >> jobfile"
    print "\t"*tabCount + "echo \"srun -n $NUM_TASKS ./cmtbonebe $TIMESTEP $ELE_SIZE $EL_X $EL_Y $EL_Z $CART_X $CART_Y $CART_Z\" >> jobfile"
    print "\t"*tabCount + "mv jobfile job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job'"
    print "\t"*tabCount + "mv job-bonebe'-es'$ELE_SIZE'ex'$EL_X'ey'$EL_Y'ez'$EL_Z'np'$NUM_TASKS'.job' $1/"
    #print "echo '#!/bin/bash' > jobfile"
    #print "echo "#### These lines are for MOAB" >> jobfile"						#TJL: something weird is happening here...
    #print "echo '#MSUB -d '`pwd` >> jobfile"
    #print "echo '#MSUB -N job=bonebe-es'$" + esize + "'ex'$" + ex + "'ey'$" + ey + "'ez'$" + ez + "'np'$" + numTasks + "'.job' >>jobfile\t #Job name"
    #print "echo '#MSUB -l nodes=$' + numNodes + '\" >> jobfile \t#Number of MPI ranks"
    #print "echo '#MSUB -l partition=vulcan' >> jobfile \t#Number of cores per MPI rank"			#TJL: Technically should be machine dependent too...
    #print "echo '#MSUB =q psmall' >> jobfile \t#Number of Nodes"
    #print "#echo '#MSUB -m a' >> jobfile \t#Mailing Job Status"
    #print "echo '#MSUB -l walltime=$wtime' >> jobfile \t#Walltime"
    #print "echo '#MSUB -o '$2'/bonebe-es'$" + esize + "'ex'$" + ex + "'ey'$" + ey + "'ez'$" + ez + "'np'$" + numTasks + "'.out' >>jobfile\t #STDOUT"
    #print "echo '#MSUB -e '$2'/bonebe-es'$" + esize + "'ex'$" + ex + "'ey'$" + ey + "'ez'$" + ez + "'np'$" + numTasks + "'.err' >>jobfile\t #STDERR"
    #print "echo ' ' >> jobfile
    #print "echo "srun -n 
    
