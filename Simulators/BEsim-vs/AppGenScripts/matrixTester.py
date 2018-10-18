import re
import csv
import highGen
import appGenerator
import os
import matrixInputGenerator
#operation=["bcast","scatter","gather"]
operation=["MM"]
#proc=[36,72]
#dim=[6,9]
#size=[800]
#size=[10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2,4,8,16,32,64,128,256,512,1024,2048]
#proc=[72]
#size=[640]
#dim=[9]
#operation=["Sobel"]
proc=[2,4,8,16,32]
dim=[2,2,3,4,6]
#proc=[36]
#size=[2048]
#dim=[6]
#dim=[8,10,16]
#proc=[36]
#dim=[6]
#size=[64]
#dim=[9]
size=[64,128,256,512,1024,2048]
#size=[2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768]
#proc=[36,72]
#dim=[6,9]
#size=[640]
#operation=["Sobel"]
#os.system("matrixInputGenerator.py")
matrixInputGenerator.genInput()
for op in operation:
	for procIndex in range(len(proc)):
		for sizeNum in size:
			procNum=proc[procIndex]
			highGen.highGen("input_%s_%d_%d.txt" %(op,procNum,sizeNum),"output_%s_%d_%d" %(op,procNum,sizeNum),procNum,dim[procIndex],sizeNum)
			appGenerator.appGenerator("output_%s_%d_%d" %(op,procNum,sizeNum), "VS_%s_%d_%d.txt" %(op,procNum,sizeNum),procNum,dim[procIndex],sizeNum)

