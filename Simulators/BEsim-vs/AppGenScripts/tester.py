import re
import csv
import highGen
import appGenerator
import os
operation=["bcast","scatter","scatter","gather","MM"]
proc=[2,4,8,16,32]
dim=[2,2,3,4,6]
size=[8,16,32,64,128]
#size=[8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144]
#proc=[4]
#dim=[2]
#size=[8,16]
#appGenerator.appGenerator("output_barrier_2_2","VS_output_2_2.txt",2,2,2)
#os.system("matrixInputGenerator.py")
for op in operation:
	for procIndex in range(len(proc)):
		for sizeNum in size:
			procNum=proc[procIndex]
			highGen.highGen("input_%s_%d_%d.txt" %(op,procNum,sizeNum),"output_%s_%d_%d" %(op,procNum,sizeNum),procNum,dim[procIndex],sizeNum)
			appGenerator.appGenerator("output_%s_%d_%d" %(op,procNum,sizeNum), "VS_%s_%d_%d.txt" %(op,procNum,sizeNum),procNum,dim[procIndex],sizeNum)

