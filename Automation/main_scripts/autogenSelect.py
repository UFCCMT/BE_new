import sys
import autogenLib

#<Input Handling (App/Machine/Output_Name Selection>

print "Which App would you like to use?\n'1' for cmtbbe\n'2' for lulesh\n'3' for mmult"
nb = raw_input('App --> ')

if (nb == "1"):
  currApp = autogenLib.setApp("cmtbbe")
elif (nb == "2"):
  currApp = autogenLib.setApp("lulesh")
elif (nb == "3"):
  currApp = autogenLib.setApp("mmult")
else:
  print "That was not a valid choice"
  sys.exit(0)
print "Which machine would you like to use?\n'1' for hipergator\n'2' for cab\n'3' for vulcan"
nb = raw_input('Machine -->  ')
if (nb == "1"):
  currMach = autogenLib.setMach("hipergator") #TJL: Should add a check to see if objects generated properly
elif (nb == "2"):
  currMach = autogenLib.setMach("cab") #TJL: Should add a check to see if objects generated properly
elif (nb == "3"):
  currMach = autogenLib.setMach("vulcan") #TJL: Should add a check to see if objects generated properly
else:
  print "That was not a valid choice"
  sys.exit(0)

print "What would you like your output file to be named? *a .sh extension will be automatically added"
outputFileName = raw_input('*file name --> ')+".sh"


#</Input Handling>

varParamList = currApp.varParamList
varParamIter = currApp.varParamIter



tabCount = 0	#Declare this elsewhere?


outputScriptName = currApp.getAppName() + "_" + currMach.getMachName() + "_" + outputFileName	#TJL: Check if name already exists
orig_stdout = sys.stdout
f = file(outputScriptName, 'w')
sys.stdout = f

#</Setup>

#Begin actual printing and generation
print "#!/bin/bash\n" 

print "if [ $# -lt 2 ]; then"
print "\techo \"x---x---x---x---x---x---x---x---x\""
print "\techo \"No command line argument supplied\""
print "\techo \"Run again with jobscript and data folder name as cmd line inputs\""
print "\techo \"x---x---x---x---x---x---x---x---x\""
print "\texit 0"
print "fi\n"

print "make clean"
print "make\n"

print "#" + currApp.getAppName() + " Parameters"
currApp.printAppParams(tabCount)

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
print "#Looping on MPI processes"
tabCount = 0
for i in range(0, len(varParamList)):
  
  if (tabCount == 1):
#    currApp.printCartValues(tabCount)				#TJL: Depreciated; I basically added this into the machine parameters to eliminate variance, or just have it call this
    currApp.printMachParams(tabCount)
  
  print "\t"*tabCount + "for " + varParamList[i] + " in " + varParamIter[i]
  print "\t"*tabCount + "do"
  tabCount+= 1

#currApp.printCartValues(tabCount)				#TJL: This is too BoneBE specific
currApp.printTimeAssignment(tabCount)

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

print "#Submit jobscript"
print "echo \"Submitting Job Files:-\"\n"						#I thint that - is a typo

#<Jobscript Submission Loop>
tabCount = 0
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
