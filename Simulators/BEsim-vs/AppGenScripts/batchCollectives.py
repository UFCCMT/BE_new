#Generates batch file for VS simulations
import math
#Dimensions of square matrix
operation=["MM2"]
#proc=[64,100]
#dim=[8,10]
proc=[2,4,8,16,32]
dim=[2,2,3,4,6]
#proc=[32]
#dim=[6]
#proc=[2,32]
#size=[64,2048]
#dim=[2,6]
#proc=[36,72]
#dim=[6,9]
#dim=[9]
#size=[2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768]
size=[64,128,256,512,1024,2048]
#size=[320,480,640,800,1024,1280,1600]
#sizeN=[4,5,8,10,15,16,20,25]
#sizeE=[1,10,50]
#proc=[4]
#size=[320,480,640,800,1024,1280,1600]
#Number of processors0
#Dimensions of processors (assuming mesh layout).  2 indicates 2x2. 
count=0
list=[]
#Generates separate test for each matrix size and proc size
for i in range(len(operation)):
	for j in range(len(proc)):
		for k in range(len(size)):
			#This is specific to Chris' computer.  The "entry" variable will need to be changed to use on your computer
			entry='\"C:\\Program Files (x86)\\Java\\jdk1.6.0_30\\bin\\java\" -classpath C:\\Users\Krishna\Documents\VisualSim13\VS_AR VisualSim.actor.gui.VisualSimBatchModeSimulator -resultpath C:\\Users\Krishna\Desktop\Research\VS\ -leng '+str(dim[j])+' -width '+str(dim[j])+' -numProcs '+str(proc[j])+' -DataSize '+str(size[k])+ ' C:\\Users\Krishna\Desktop\Research\VS\VSModel.xml\n'
			list.append(entry)
#File created is named Sim_Batch_File.bat
f=open('Sim_Batch_File'+'.bat','w')
f.write(' '.join(list))
f.close()

