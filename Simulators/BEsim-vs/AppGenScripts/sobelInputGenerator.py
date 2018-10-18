import math
import os
#proc=[2,4,36]
#rows=[320,1024]
#cols=[240,768]
proc=[2,4,8,16,32]
#proc=[64,100]
rows=[320,480,640,800,1024,1280,1600]
cols=[240,320,480,600,768,1024,1200]
#proc=[36,72]
#rows=[640]
#cols=[480]
#proc=[36,72]
#rows=[800]
#cols=[600]
numOp="Sobel"
if not os.path.exists("HighLevelScripts"):
	os.makedirs("HighLevelScripts")
for numProcs in proc:
	for i in range(len(rows)):
		outputFile="HighLevelScripts/input_%s_%d_%d.txt" %(numOp,numProcs,rows[i])
		with open(outputFile, "a") as out:
			s="VAR commGrp0=0:%d\n" %(numProcs-1)
			out.write(s)
			s="VAR commGrp1=0:%d\n" %(rows[i]%numProcs)
			out.write(s)
			s="VAR commGrp2=%d:%d\n" %(rows[i]%numProcs,numProcs-1)
			out.write(s)
			s="Barrier(commGrp0)\n"
			out.write(s)
			if(rows[i]%numProcs!=0):
				s="Scatter(int32,%d,0,commGrp1)\n" %(math.ceil((cols[i]*((rows[i]-2)/numProcs+3))/8))
				out.write(s)
			s="Scatter(int32,%d,0,commGrp2)\n" %(math.ceil((cols[i]*((rows[i]-2)/numProcs+2))/8))

			out.write(s)

			s="Barrier(commGrp0)\n"
			out.write(s)

			if(rows[i]%numProcs!=0):
				s="ComputeGx(int32,%d,commGrp1)\n" %((rows[i]/numProcs+1)*cols[i])
				out.write(s)
				s="ComputeGy(int32,%d,commGrp1)\n" %((rows[i]/numProcs+1)*cols[i])
				out.write(s)
			s="ComputeGx(int32,%d,commGrp2)\n" %(rows[i]*cols[i]/numProcs)
			out.write(s)
			s="ComputeGy(int32,%d,commGrp2)\n" %(rows[i]*cols[i]/numProcs)
			out.write(s)
			
			s="Barrier(commGrp0)\n"
			out.write(s)

			#gather
			if(rows[i]%numProcs!=0):
				s="Gather(int32,%d,commGrp1)\n" %((2*((rows[i]-2)/numProcs+1)*cols[i])/8)
				out.write(s)
			s="Gather(int32,%d,commGrp2)\n" %((2*((rows[i]-2)/numProcs)*cols[i])/8)
			out.write(s)
			
			s="Barrier(commGrp0)\n"
			out.write(s)
			s="Done\n"
			out.write(s)
			out.close()
			
