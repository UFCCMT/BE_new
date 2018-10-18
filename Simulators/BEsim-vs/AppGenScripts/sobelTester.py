import re
import csv
import highGen
import appGenerator
import os
proc=[2,4,8,16,32]
dim=[2,2,3,4,6]
rows=[320,480,640,800,1024,1280,1600]
cols=[240,320,480,600,768,1024,1200]
#proc=[4]
#dim=[2]
#size=[128]
operation=["Sobel"]
os.system("sobelInputGenerator.py")
for op in operation:
	for procIndex in range(len(proc)):
		for r in rows:
			procNum=proc[procIndex]
			highGen.highGen("input_%s_%d_%d.txt" %(op,procNum,r),"output_%s_%d_%d" %(op,procNum,r),procNum,dim[procIndex],r)
			appGenerator.appGenerator("output_%s_%d_%d" %(op,procNum,r), "VS_%s_%d_%d.txt" %(op,procNum,r),procNum,dim[procIndex],r)
