import math
import os
base="base"
outputFile="output1.txt"
f = open(outputFile, 'w')
f.close()
#proc=[2,4,8,16,32,36,72]
#size=[2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768]
#proc=[4]
#size=[8,16]
proc=[32]
size=[512]
numOp="bcast"
print "Dir made"
if not os.path.exists("HighLevelScripts"):
    os.makedirs("HighLevelScripts")
for numProcs in proc:
	for numSize in size:
		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,numSize)
		with open(outputFile, "a") as out:
			s="VAR commGrp=0:%d\n" %(numProcs-1)
			out.write(s)
			s="Bcast(int32,%d,0,commGrp)\nDone\n" %(numSize/2)
			out.write(s)
			out.close()
'''
numOp="scatter"
for numProcs in proc:
	for numSize in size:
		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,numSize)
		with open(outputFile, "a") as out:
			s="VAR commGrp=0:%d\n" %(numProcs-1)
			out.write(s)
			s="Scatter(int32,%d,0,commGrp)\nDone\n" %(numSize/2)
			out.write(s)
			out.close()	
			
numOp="gather"
for numProcs in proc:
	for numSize in size:
		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,numSize)
		with open(outputFile, "a") as out:
			s="VAR commGrp=0:%d\n" %(numProcs-1)
			out.write(s)
			s="Gather(int32,%d,commGrp)\nDone\n" %(numSize/2)
			out.write(s)
			out.close()'''	
