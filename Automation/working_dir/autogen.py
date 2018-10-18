
#Author: Trokon Johnson

#Purpose:
  #The goal of this python script is to generate a standardized bash script format, based on an app and
  #a machine combinaition. This bash script can than be simply edited to run a large number of experiments
  #on a supercomputer system.
  

#Command Line Usage: 
  #python autogen.py application machine output_script_suffix
  #Note: Application and machine must be in autogenLib list

#Notes:
  #Script presupposes a makefile, but can easily be edited to remove this dependency
    #Output bash script would then, logically, have to be in the same folder as full application and makefile
    #If we stick to runtime scripts, this would not be necessary
  #Script currently overwrites previous files with same names; name of output bash script is only dependent on app name, machine name, and 3rd CLArg
  
import sys
import autogenLib

#Auxiliarry Functions
#def init():

#Prints the basic information common to each scripts
  #Check for CLArgs, remake app, checks for storage/output/error directories
  #Also, prints out unique variable to be iterated over
def print_header():
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
  
  #Make sure that the output directories exist 		#TJL: Could use a similar syntax to ensure that output file DNE
  print "#Check for job dir to store job scripts"
  print "if [ ! -d \"$1\" ]; then"
  print "\tmkdir $1/"
  print "fi\n"

  print "#Check for data dir to store *.out and *.err"
  print "if [ ! -d \"$2\" ]; then"
  print "\tmkdir $2/"
  print "fi\n"

  #Print the application parameters			#TJL: Need to define what constitutes an application parameter
  print "#" + currApp.getAppName() + " Parameters"
  currApp.printAppParams(tabCount)

  print "echo \"Creating job files(s)...\""

def basic_init():
  global tabCount, currApp, currMach, varParamList, varParamIter, orig_stdout, outputScriptName
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
    print "Assigning app and machine functions:"
    if appArg in autogenLib.appList:
      currApp = autogenLib.setApp(appArg)
      print "\tApp determined to be " + appArg
    else:
      print "\tNot a valid application"
      sys.exit(0)
	
    if machArg in autogenLib.machList:
      currMach = autogenLib.setMach(machArg)
      print "\tMachine determined to be " + machArg
    else:
      print "\tNot a valid machine"
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

def main():
  basic_init()
  print_header()

  tabCount = 0

  #<Jobscript Generation Loop>
  currApp.jobscriptGenerationLoop(tabCount, currMach)
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
  #</Generation Metadata>

  #<Jobscript Submission Loop>
  currApp.jobscriptSubmissionLoop(tabCount, currMach)
  #</Jobscript Submission Loop>

  print "echo \"* * * * " + "-"*11 + "Completed!" + "-"*11 + " * * * *\""
  sys.stdout = orig_stdout
  print "*"*10 + "Script Successfully Generated" + "*"*10
  print "Output file: " + outputScriptName
  
#TJL: Needed to run main properly; should look into more
if __name__ == "__main__":
  main()