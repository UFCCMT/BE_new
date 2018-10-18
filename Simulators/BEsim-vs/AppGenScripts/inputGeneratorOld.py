import math
import os
base="base"
outputFile="output1.txt"
f = open(outputFile, 'w')
f.close()
proc=[2,4,8,16,32,36]
size=[2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144]
#proc=[4]
#size=[8,16]
numOp="bcast"
print "Dir made"
if not os.path.exists("HighLevelScripts"):
    os.makedirs("HighLevelScripts")
for numProcs in proc:
	for numSize in size:
		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,numSize)
		with open(outputFile, "a") as out:
			s="Init(%d,2)\n" %numProcs
			out.write(s)
			s="VAR grp0=1:%d\n" %(numProcs-1)
			out.write(s)
			s="Bcast(0,grp0,%d)\nDone\n" %numSize
			out.write(s)
			out.close()
			
##numOp="barrier"
##for numProcs in proc:
##	for numSize in size:
##		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,numSize)
##		with open(outputFile, "a") as out:
##			s="Init(%d,2)\n" %numProcs
##			out.write(s)
##			s="VAR grp0=1:%d\n" %(numProcs-1)
##			out.write(s)
##			s="Barrier(grp0)\nDone\n"
##			out.write(s)
##			out.close()
			
numOp="scatter"
for numProcs in proc:
	for numSize in size:
		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,numSize)
		with open(outputFile, "a") as out:
			s="Init(%d,2)\n" %numProcs
			out.write(s)
			s="VAR grp0=1:%d\n" %(numProcs-1)
			out.write(s)
			s="Scatter(0,grp0,%d)\nDone\n" %(numSize/2)
			out.write(s)
			out.close()	
			
numOp="gather"
for numProcs in proc:
	for numSize in size:
		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,numSize)
		with open(outputFile, "a") as out:
			s="Init(%d,2)\n" %numProcs
			out.write(s)
			s="VAR grp0=1:%d\n" %(numProcs-1)
			out.write(s)
			s="Gather(0,grp0,%d)\nDone\n" %(numSize/2)
			out.write(s)
			out.close()	
