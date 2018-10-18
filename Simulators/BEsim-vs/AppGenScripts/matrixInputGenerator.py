import math
import os
#proc=[72]

proc=[2,4,8,16,32]
#size=[2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288]
#proc=[64,100,256]
size=[64,128,256,512,1024,2048]
#size=[10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000]
#size=[1024]
#proc=[36,72]
#proc=[2]
numOp="MM"
def genInput():
	if not os.path.exists("HighLevelScripts"):
		os.makedirs("HighLevelScripts")
	for numProcs in proc:
		for matSize in size:
			outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,matSize)
			with open(outputFile, "a") as out:
				s="VAR commGrp=0:%d\n" %(numProcs-1)
				out.write(s)
				s="Bcast(int32,%d,0,commGrp)\n" %((matSize**2)/2)
				out.write(s)
				s="Barrier(commGrp)\n"
				out.write(s)
				s="Scatter(int32,%d,0,commGrp)\n" %((matSize**2)/(2*numProcs))
				out.write(s)		
				s="DotProduct(int32,%d)\n" %(matSize)
				out.write(s)
				s="Barrier(commGrp)\n"
				out.write(s)
				s="Gather(int32,%d,commGrp)\nDone\n" %((matSize**2)/(2*numProcs))
				out.write(s)
				out.close()
			
