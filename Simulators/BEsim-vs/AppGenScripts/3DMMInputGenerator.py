import math
import os
#proc=[72]

#proc=[2,4,8,16,32,36]
#size=[2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288]
#proc=[64,100,256]
#size=[64,128,256,512,1024]
sizeN=[4,5,8,10,15,16,20,25]
sizeE=[1,10,50]
proc=[4]
factor=2
numOp="3DMM"
if not os.path.exists("HighLevelScripts"):
	os.makedirs("HighLevelScripts")
for numProcs in proc:
	for N in sizeN:
		for E in sizeE:
			outputFile="HighLevelScripts/input_%s_%d_%d_%d.txt" %(numOp,numProcs,N,E)
			with open(outputFile, "a") as out:
				s="VAR commGrp=0:%d\n" %(numProcs-1)
				out.write(s)

				s="Barrier(commGrp)\n"
				out.write(s)

				s="Bcast(float,%d,0,commGrp)\n" %(N*N/factor)
				out.write(s)
				
				s="Barrier(commGrp)\n"
				out.write(s)
				
				s="Scatter(float,%d,0,commGrp)\n" %(N*N*N*E/factor)
				out.write(s)

				s="Barrier(commGrp)\n"
				out.write(s)

				
				s="ComputeKernal(float,%d,%d)\n" %(E,N)
				out.write(s)

				s="Barrier(commGrp)\n"
				out.write(s)

				s="3DMM_Transfer1(%d,commGrp)\n" %(N*N*E/factor)
				out.write(s)

				s="Barrier(commGrp)\n"
				out.write(s)

				s="3DMM_Transfer2(%d,commGrp)\n" %(N*N*E/factor)
				out.write(s)

				s="Barrier(commGrp)\n"
				out.write(s)

				s="3DMM_Transfer3(%d,commGrp)\n" %(N*N*E/factor)
				out.write(s)

				s="Barrier(commGrp)\n"
				out.write(s)

				s="3DMM_Transfer4(%d,commGrp)\n" %(N*N*E/factor)
				out.write(s)

				s="Barrier(commGrp)\n"
				out.write(s)
				
				s="Done\n"
				out.write(s)
				out.close()
				




