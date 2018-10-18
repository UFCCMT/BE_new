#Purpose
  #Script

#Purpose of output bash Script
  

#Command Line Usage: python autogen.py application_to_run machine_to_run_on output_script_suffix

#Notes:
  #Script presupposes a makefile, but can easily be edited to remove this dependency
    #Output bash script would then, logically, have to be in the same folder as full application and makefile
    #If we stick to runtime, this would not be necessary
  #Script currently overwrites previous files with same names; name of output bash script is only dependent on app name, machine name, and 3rd CLArg

#Table of Contents
  #Setup: Reading in CLArgs, initialization, and whatnot
  #Jobscript Generation Loop
  
import sys
import autogenLib

#Auxiliarry Functions
def init():
  
def print_header():

#initialization
tabCount = 0	#Declare this elsewhere?

#Check for the right number of args, compared to Lib. Exit if wrong
if(len(sys.argv) != autogenLib.numCLArgs):
  print "autogen.py expects " + str(autogenLib.numCLArgs - 1) + " command line arguments. \n Format is: python autogen.py 1. app 2. machine 3. output_script_suffix ] \n Exiting now"
  sys.exit(0)
else:	
  
  #Grab the command line parameters in local variables
  appArg = sys.argv[1]
  machArg = sys.argv[2]
  scriptSuf = sys.argv[3]
  
  #Set application and machine if in library; exit with print error if not
  print "Assigning app and machine functions"
  if appArg in autogenLib.appList:
    print "App determined to be " + appArg
    currApp = autogenLib.setApp(appArg)
    print currApp.getAppName() + "object successfully generated"
  else:
    print "Not a valid application"
    sys.exit(0)
      
  if machArg in autogenLib.machList:
    print "Machine determined to be " + machArg
    currMach = autogenLib.setMach(machArg)
    print currMach.getMachName() + "object successfully generated"
  else:
    print "Not a valid application"
    sys.exit(0)  

#Set the application parameters from the library
varParamList = currApp.varParamList
varParamIter = currApp.varParamIter

#Set the output file parameters
outputScriptName = currApp.getAppName() + "_" + currMach.getMachName() + "_" + sys.argv[3] + ".sh"	#TJL: Check if name already exists?
orig_stdout = sys.stdout
f = file(outputScriptName, 'w')
sys.stdout = f
#</Setup>

#Begin actual printing and generation
print "#!/bin/bash\n" 

#Conforming to previous UQ script usage, which requires a jobscript and Data folder
print "if [ $# -lt 2 ]; then"
print "\techo \"x---x---x---x---x---x---x---x---x\""
print "\techo \"No command line argument supplied\""
print "\techo \"Run again with jobscript and data folder name as cmd line inputs\""
print "\techo \"x---x---x---x---x---x---x---x---x\""
print "\texit 0"
print "fi\n"

#Remake the application. Would have to be in the same folder
print "make clean"
print "make\n"

#Print the application parameters			#TJL: Need to define what constitutes an application parameter
print "#" + currApp.getAppName() + " Parameters"
currApp.printAppParams(tabCount)

#Make sure that the output directories exist 		#TJL: Could use a similar syntax to ensure that output file DNE
print "#Check for job dir to store job scripts"
print "if [ ! -d \"$1\" ]; then"
print "\tmkdir $1/"
print "fi\n"

print "#Check for data dir to store *.out and *.err"
print "if [ ! -d \"$2\" ]; then"
print "\tmkdir $2/"
print "fi\n"

print "echo \"Creating job files(s)...\"\n"

#<Jobscript Generation Loop>
print "#Looping on MPI processes"				#TJL: What exactly does this mean?
tabCount = 0
for i in range(0, len(varParamList)):				#TJL: Really need to clarify parameter list vs variable parameter list
  
  if (tabCount == 1):
    currApp.printMachParams(tabCount)
  
  print "\t"*tabCount + "for " + varParamList[i] + " in " + varParamIter[i]
  print "\t"*tabCount + "do"
  tabCount+= 1

#currApp.printCartValues(tabCount)				#TJL: This is too BoneBE specific
currApp.printTimeAssignment(tabCount)				#TJL: Right now, doesn't actually print

print "\n"

print "\t"*tabCount + "#Making the job script"
if(currMach.getSchedulerType() == "moab"):
  currApp.printMoabSchedule(tabCount)
elif(currMach.getSchedulerType() == "slurm"):
  currApp.printSlurmSchedule(tabCount)

tabCount-=1

while (tabCount >= 0):
  print "\t"*tabCount + "done"
  tabCount-=1

print " "
#</Jobscript Generation Loop>

#<Generation Metatdata>: Generation Completion Message, list jobfiles, print folders
print "echo \"Job file\(s\) created!\""
print "echo \" \""
print "echo \"Listing Jobfile\(s\):\""
print "echo \"" + "-"*64 + "\""
print "ls $1/"
print "echo \"" + "-"*64 + "\""
print "sleep 2"
print "echo \" \""
print "echo \"Job file\(s\) present in $1/ folder\""
print "echo \"Output and error files present in $2 folder\""
print "echo \" \"\n"
#</

#<Jobscript Submission Loop>
tabCount = 0
print "#Submit jobscript"
print "echo \"Submitting Job Files:-\"\n"						#TJL: I thint that - is a typo
for i in range(0, len(varParamList)):
  print "\t"*tabCount + "for " + varParamList[i] + " in " + varParamIter[i]
  print "\t"*tabCount + "do"
  tabCount+= 1
  if (tabCount == 1):
    currApp.printMachSubmitParams(tabCount)
  if (tabCount == 2):
    currApp.printAppSubmitParams(tabCount)
  
if(currMach.getSchedulerType() == "moab"):
  currApp.printSubmitMoabJob(tabCount)
elif(currMach.getSchedulerType() == "slurm"):
  currApp.printSubmitSlurmJob(tabCount)
else:
  print "Error: Scheduler not properly set. Exiting now"
  sys.exit(0)

tabCount-=1

while (tabCount >= 0):
  print "\t"*tabCount + "done"
  tabCount-=1
#</Jobscript Submission Loop>

print " "
print "echo \"* * * * " + "-"*11 + "Completed!" + "-"*11 + " * * * *\""

sys.stdout = orig_stdout
print "*"*10 + "Script Successfully Generated (Hopefully)" + "*"*10
print "Output file: " + outputScriptName