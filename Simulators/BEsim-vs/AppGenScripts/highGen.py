import re
import csv
import training
import interpolation
import benchmarking
import os
import math
def highGen(inFile,outFileBase,numProcs,dim,dataSize):
	debug=False
	length=dim
	#size=dataSize
	hopTime=1
	strBuf="";
	bench = benchmarking.Benchmarking()
	data = interpolation.Data()
	barrierT=[None]*300
	barrierT[2]=[1,0]
	barrierT[4]=[1,3,0,2]
	barrierT[8]=[1,2,5,0,7,4,3,6]
	barrierT[16]=[1,2,3,7,0,9,5,6,4,10,11,15,8,12,13,14]
	barrierT[32]=[1,2,3,4,5,11,0,13,7,8, 9,10, 6,14,15,16,17,23,12,25,19,20,21,22,18,26,27,28,29,31,24,30]
	barrierT[36]=[1,2,3,4,5,11,0,13,7,8,9,10,6,14,15,16,17,23,12,25,19,20,21,22,18,26,27,28,29,35,24,30,31,32,33,34]
	barrierT[64]=[1, 2, 3, 4, 5, 6, 7, 15, 0, 17, 9, 10, 11, 12, 13, 14, 8, 18, 19, 20, 21, 22, 23, 31, 16, 33, 25, 26, 27, 28, 29, 30, 24, 34, 35, 36, 37, 38, 39, 47, 32, 49, 41, 42, 43, 44, 45, 46, 40, 50, 51, 52, 53, 54, 55, 63, 48, 56, 57, 58, 59, 60, 61, 62]
	barrierT[72]=[1,2,3,4,5,6,7,8,17,0,19,10,11,12,13,14,15,16,9,20,21,22,23,24,25,26,35,18,37,28,29,30,31,32,33,34,27,38,39,40,41,42,43,44,53,36,55,46,47,48,49,50,51,52,45,56,57,58,59,60,61,62,71,54,63,64,65,66,67,68,69,70]
	barrierT[100]=[1, 2, 3, 4, 5, 6, 7, 8, 9, 19, 0, 21, 11, 12, 13, 14, 15, 16, 17, 18, 10, 22, 23, 24, 25, 26, 27, 28, 29, 39, 20, 41, 31, 32, 33, 34, 35, 36, 37, 38, 30, 42, 43, 44, 45, 46, 47, 48, 49, 59, 40, 61, 51, 52, 53, 54, 55, 56, 57, 58, 50, 62, 63, 64, 65, 66, 67, 68, 69, 79, 60, 81, 71, 72, 73, 74, 75, 76, 77, 78, 70, 82, 83, 84, 85, 86, 87, 88, 89, 99, 80, 90, 91, 92, 93, 94, 95, 96, 97, 98]
	barrierT[144]=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 23, 0, 25, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 12, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 47, 24, 49, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 36, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 71, 48, 73, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 60, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 95, 72, 97, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 84, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 119, 96, 121, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 108, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 143, 120, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142]
	barrierT[256]=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 31, 0, 33, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 16, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 63, 32, 65, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 48, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 95, 64, 97, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 80, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 127, 96, 129, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 112, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 159, 128, 161, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 144, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 191, 160, 193, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 176, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 223, 192, 225, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 208, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 255, 224, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254]
	barrier=barrierT[numProcs]
	setupTime=3000
	loopTime=0
	vars={}
	tag=0 #acts as counter
	if not os.path.exists("LowLevelScripts"):
		os.makedirs("LowLevelScripts")
	files = [open('LowLevelScripts/%s_#%d.txt' %(outFileBase,i), 'w') for i in range(0,numProcs)] #opens all files for writing
	reader = csv.reader(open('DotProductsKNL.csv','rU'))
	dotProducts={}
	for row in reader:
		dotProducts[row[0]]=row[1]
	reader = csv.reader(open('SetupTimes.csv','rU'))
	setupTimes={}
	for row in reader:
		setupTimes[row[0]]=row[1]
	reader = csv.reader(open('loop_time.csv','rU'))
	loop_time={}
	for row in reader:
		loop_time[row[0]]=row[1]
	reader = csv.reader(open('3DMMTile.csv','rU'))
	kernalTime={}
	for row in reader:
		kernalTime[row[0]]=row[1]
		
	files[0].write('init\n')
	for line in open("HighLevelScripts/%s" %inFile): #iterates through input file
			if '//' in line:
				continue
			elif 'VAR' in line: #if variable defined, adds to variable array
				splitLine=re.split(r'[ =\n]', line)
				#print splitLine
				vars[splitLine[1]]=splitLine[2]
			elif 'Scatter' in line: #if scatter defined, generate scatter output
				splitLine=re.split(r'[(),]', line) #split
				localMaster=int(splitLine[3]) #master is 1st index
				dataSize=str(int(splitLine[2]))
				minMaxSplit=vars[splitLine[4]].split(':') #contains [num1,num2]
				destArray=range(1+int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				if debug:
					files[localMaster].write(line)
					for i in destArray:
						files[i].write(line)
				for i in destArray:
					if ((int(dataSize) & (int(dataSize)-1))!=0):
						lowIndex=int(math.pow(2.0,int(math.log(float(dataSize),2))))
						highIndex=int(math.pow(2.0,math.ceil(math.log(float(dataSize),2))))
						higher=int(setupTimes[str(int(math.pow(2.0,math.ceil(math.log(float(dataSize),2)))))])
						lower=int(setupTimes[str(int(math.pow(2.0,int(math.log(float(dataSize),2)))))])
						setupTime=(int(dataSize)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(dataSize)-1)*hopTime
						#setupTime=higher*int(dataSize)/lower+lower+(int(dataSize)-1)*hopTime
						#dataSize=str(int((math.pow(2,math.ceil(math.log(int(dataSize))/math.log(2))))))
					else:
						setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
					strBuf="send %d %s %s %d" %(tag,i,setupTime,hopTime)
					if debug:
						strBuf+="       Scatter from master to node %d" %(i)
					strBuf+="\n"
					files[localMaster].write(strBuf) #send instruction for master
					strBuf="recv %d" %tag
					if debug:
						strBuf+="               Receive Scatter from node %d" %localMaster
					strBuf+="\n"
					files[i].write(strBuf) #corresponding recv instruction
					tag+=1 #increments tag
					setupTime=int(setupTimes['1'])
					strBuf=( "send %d %s %s %d" %(tag,localMaster,setupTime,hopTime)) #ack send instruction
					if debug:
						strBuf+="       Send acknowledgement for scatter to node %d" %localMaster
					strBuf+="\n"
					files[i].write(strBuf)
					
					strBuf=( "recv %d" %tag) #corresponding receive instruction
					if debug:
						strBuf+="               Receive acknowledgement for scatter from %d" %i
					strBuf+="\n"
					files[localMaster].write(strBuf)
					tag+=1 #increments tag
				files[localMaster].write("log\n")
			elif 'Gather' in line: #if scatter defined, generate scatter output
				splitLine=re.split(r'[(),]', line) #split
				localMaster=0 #master is 1st index
				dataSize=str(int(splitLine[2]))
				minMaxSplit=vars[splitLine[3]].split(':') #contains [num1,num2]
				destArray=range(1+int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				if debug:
					files[localMaster].write(line)
					for i in destArray:
						files[i].write(line)
				#Initial send
				for i in destArray:
					setupTime=int(setupTimes['1'])
					files[localMaster].write( "send %d %s %s %d\n" %(tag,i,setupTime,hopTime)) #ack send instruction
					files[i].write( "recv %d\n" %tag) #corresponding receive instruction
					tag+=1
					if ((int(dataSize) & (int(dataSize)-1))!=0):
						lowIndex=int(math.pow(2.0,int(math.log(float(dataSize),2))))
						highIndex=int(math.pow(2.0,math.ceil(math.log(float(dataSize),2))))
						higher=int(setupTimes[str(int(math.pow(2.0,math.ceil(math.log(float(dataSize),2)))))])
						lower=int(setupTimes[str(int(math.pow(2.0,int(math.log(float(dataSize),2)))))])
						print lower
						print higher
						print setupTime
						setupTime=(int(dataSize)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(dataSize)-1)*hopTime
						#setupTime=higher*int(dataSize)/lower+lower+(int(dataSize)-1)*hopTime
						#dataSize=str(int((math.pow(2,math.ceil(math.log(int(dataSize))/math.log(2)))
					else:
						setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
					
					strBuf= "send %d %s %s %d" %(tag,localMaster,setupTime,hopTime) #send instruction for master
					if debug:
						strBuf+="       Send to master(%d) for gather instruction" %localMaster
					strBuf+="\n"
					files[i].write(strBuf)

					
					strBuf= "recv %d" %tag #corresponding recv instruction
					if debug:
						strBuf+="               Receive packet for gather instruction from node %d" %i
					strBuf+="\n"
					files[localMaster].write(strBuf)
					tag+=1 #increments tag

					setupTime=int(setupTimes['1'])
					strBuf= "send %d %s %s %d" %(tag,i,setupTime,hopTime) #ack send instruction
					if debug:
						strBuf+="       Send acknowledgement for gather to node %d" %i
					strBuf+="\n"
					files[localMaster].write(strBuf)
					
					strBuf= "recv %d" %tag #corresponding receive instruction
					if debug:
						strBuf+="               Receive acknowledgement for gather from master(%d)" %localMaster
					strBuf+="\n"
					files[i].write(strBuf)
					tag+=1 #increments tag

				files[localMaster].write("log\n")	
					

					
					
			elif 'ComputeGx' in line:
				splitLine=re.split(r'[ (),\n]', line) #split
				print splitLine[2]
				print splitLine[3]
				numOps=int(splitLine[2])
				time=numOps*506   
				minMaxSplit=vars[splitLine[3]].split(':') #contains [num1,num2]
				destArray=range(1+int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				strBuf="advt %s\n" %time
				for i in destArray:
					if i==1:
						files[0].write(strBuf)
						files[0].write("log\n")
					files[i].write(strBuf)
			elif 'ComputeGy' in line:
				splitLine=re.split(r'[ (),\n]', line) #split
				numOps=int(splitLine[2])
				time=numOps*506   
				minMaxSplit=vars[splitLine[3]].split(':') #contains [num1,num2]
				destArray=range(1+int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				strBuf="advt %s\n" %time
				for i in destArray:
					if i==1:
						files[0].write(strBuf)
						files[0].write("log\n")
					files[i].write(strBuf)
			elif 'ComputeKernal' in line:
				splitLine=re.split(r'[ (),\n]', line) #split
				E=int(splitLine[2])
				N=int(splitLine[3])
				time=N*E*int(kernalTime[str(N)])
				if ((int(N*E) & (int(N*E)-1))!=0):
                                        lowIndex=int(math.pow(2.0,int(math.log(float(N*E),2))))
                                        highIndex=int(math.pow(2.0,math.ceil(math.log(float(N*E),2))))
                                        higher=int(loop_time[str(int(math.pow(2.0,math.ceil(math.log(float(N*E),2)))))])
                                        lower=int(loop_time[str(int(math.pow(2.0,int(math.log(float(N*E),2)))))])
                                        loopTime=(int(N*E)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(N*E)-1)*hopTime
                                else:
                                        loopTime=loop_time[str(N*E)]
				time=int(time)+int(loopTime)*int(N)*int(E)
				strBuf="advt %s\n" %time
				for i in range(0,numProcs):
					files[i].write(strBuf)
				files[localMaster].write("log\n")
				
			elif '3DMM_Transfer1' in line:
				splitLine=re.split(r'[(),]', line) #split
				localMaster=0
				dataSize=str(int(splitLine[1]))
				minMaxSplit=vars[splitLine[2]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				if ((int(dataSize) & (int(dataSize)-1))!=0):
					lowIndex=int(math.pow(2.0,int(math.log(float(dataSize),2))))
					highIndex=int(math.pow(2.0,math.ceil(math.log(float(dataSize),2))))
					higher=int(setupTimes[str(int(math.pow(2.0,math.ceil(math.log(float(dataSize),2)))))])
					lower=int(setupTimes[str(int(math.pow(2.0,int(math.log(float(dataSize),2)))))])
					setupTime=(int(dataSize)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(dataSize)-1)*hopTime
				else:
					setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
				ackSetupTime=int(setupTimes['1'])

				#Transfer 1
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idy%2==1): #if row is odd
						strBuf= "send %d %s %s %d" %(tag,i-dim,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i-dim].write(strBuf)
						tag+=1 #increments tag
						
						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i-dim].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idy%2==0 and idy!=0): #if row is even
						strBuf= "send %d %s %s %d" %(tag,i-dim,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i-dim].write(strBuf)
						tag+=1 #increments tag

						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i-dim].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag
						
				
				files[localMaster].write("log\n")

			elif '3DMM_Transfer2' in line:
				splitLine=re.split(r'[(),]', line) #split
				localMaster=0
				dataSize=str(int(splitLine[1]))
				minMaxSplit=vars[splitLine[2]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				if ((int(dataSize) & (int(dataSize)-1))!=0):
					lowIndex=int(math.pow(2.0,int(math.log(float(dataSize),2))))
					highIndex=int(math.pow(2.0,math.ceil(math.log(float(dataSize),2))))
					higher=int(setupTimes[str(int(math.pow(2.0,math.ceil(math.log(float(dataSize),2)))))])
					lower=int(setupTimes[str(int(math.pow(2.0,int(math.log(float(dataSize),2)))))])
					setupTime=(int(dataSize)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(dataSize)-1)*hopTime
				else:
					setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
				ackSetupTime=int(setupTimes['1'])

				
				#Transfer 2
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idy%2==0 and idy!=dim-1 and (i+dim<numProcs)): #if row is even 
						strBuf= "send %d %s %s %d" %(tag,i+dim,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i+dim].write(strBuf)
						tag+=1 #increments tag

						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i+dim].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idy%2==1 and idy!=dim-1 and (i+dim<numProcs)): #if row is odd
						strBuf= "send %d %s %s %d" %(tag,i+dim,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i+dim].write(strBuf)
						tag+=1 #increments tag

						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i+dim].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag
						
				files[localMaster].write("log\n")


			elif '3DMM_Transfer3' in line:
				splitLine=re.split(r'[(),]', line) #split
				localMaster=0
				dataSize=str(int(splitLine[1]))
				minMaxSplit=vars[splitLine[2]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				if ((int(dataSize) & (int(dataSize)-1))!=0):
					lowIndex=int(math.pow(2.0,int(math.log(float(dataSize),2))))
					highIndex=int(math.pow(2.0,math.ceil(math.log(float(dataSize),2))))
					higher=int(setupTimes[str(int(math.pow(2.0,math.ceil(math.log(float(dataSize),2)))))])
					lower=int(setupTimes[str(int(math.pow(2.0,int(math.log(float(dataSize),2)))))])
					setupTime=(int(dataSize)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(dataSize)-1)*hopTime
				else:
					setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
				ackSetupTime=int(setupTimes['1'])
						
				#Transfer 3
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idx%2==1): #if col is odd 
						strBuf= "send %d %s %s %d" %(tag,i-1,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i-1].write(strBuf)
						tag+=1 #increments tag

						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i-1].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idx%2==0 and idx!=0): #if col is even
						strBuf= "send %d %s %s %d" %(tag,i-1,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i-1].write(strBuf)
						tag+=1 #increments tag

						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i-1].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag

				
						
				files[localMaster].write("log\n")

			elif '3DMM_Transfer4' in line:
				splitLine=re.split(r'[(),]', line) #split
				localMaster=0
				dataSize=str(int(splitLine[1]))
				minMaxSplit=vars[splitLine[2]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				if ((int(dataSize) & (int(dataSize)-1))!=0):
					lowIndex=int(math.pow(2.0,int(math.log(float(dataSize),2))))
					highIndex=int(math.pow(2.0,math.ceil(math.log(float(dataSize),2))))
					higher=int(setupTimes[str(int(math.pow(2.0,math.ceil(math.log(float(dataSize),2)))))])
					lower=int(setupTimes[str(int(math.pow(2.0,int(math.log(float(dataSize),2)))))])
					setupTime=(int(dataSize)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(dataSize)-1)*hopTime
				else:
					setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
				ackSetupTime=int(setupTimes['1'])

				#Transfer 4
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idx%2==0 and idx!=dim-1 and (i+1<numProcs)): #if col is even 
						strBuf= "send %d %s %s %d" %(tag,i+1,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i+1].write(strBuf)
						tag+=1 #increments tag

						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i+1].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag
				for i in destArray:
					idy=i/dim
					idx=i%dim
					if (idx%2==1 and idx!=dim-1 and (i+1<numProcs)): #if col is odd
						strBuf= "send %d %s %s %d" %(tag,i+1,setupTime,hopTime)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf= "recv %d" %tag #corresponding recv instruction
						strBuf+="\n"
						files[i+1].write(strBuf)
						tag+=1 #increments tag

						#Ack
						strBuf=( "send %d %s %s %d" %(tag,i,setupTime,hopTime)) #ack send instruction
						strBuf+="\n"
						files[i+1].write(strBuf)
					
						strBuf=( "recv %d" %tag) #corresponding receive instruction
						strBuf+="\n"
						files[i].write(strBuf)
						tag+=1 #increments tag
						
				files[localMaster].write("log\n")
				
			elif 'DotProduct' in line:
				
				splitLine=re.split(r'[ (),\n]', line) #split
				vectorSize=splitLine[2]
				 #add all this
				trained_file = "hiper-dot-prod"
				
				x_pt=float(vectorSize)

				points, values = bench.samples_from_bmark(trained_file)
				data.set_samples(points, values, len(points[0]))
				variogram = {"type": "exponential", "nugget": 0.00, "range": 500.0, "sill": 1.0}
				polynomial = 0
				neighbors = 3
				interpol = interpolation.Kriging(data, polynomial, variogram, neighbors)
				estimate, variances = interpol.interpolate([[x_pt,x_pt]])	
				time=estimate[0]
				time*=1000000000
				print vectorSize
				print time
				time=int(time)*int(vectorSize)*int(vectorSize)/numProcs
				loopTime=loop_time[vectorSize]
				time=int(time)+int(loopTime)*int(vectorSize)*int(vectorSize)/numProcs #LOOP TIME
				
				
				#time=dotProducts[vectorSize]    #delete
				#time=int(time)*int(vectorSize)*int(vectorSize)/numProcs #delete
				
				dataType=splitLine[1]
				if debug:
					files[localMaster].write(line)
					for i in destArray:
						files[i].write(line)
				for i in range(0,numProcs):
					#files[i].write( "dot %s\n" %vectorSize)
					strBuf="advt %s" %time
					if debug:
						strBuf+="       Advance timer for compute time in dot product"
					strBuf+="\n"
					files[i].write(strBuf)
				files[localMaster].write("log\n")

			elif 'MM' in line:
				
				splitLine=re.split(r'[ (),\n]', line) #split
				MatSize=splitLine[2]
				trained_file = "power_MM"
				y_pt=float(MatSize)
				x_pt=float(float(MatSize)/float(numProcs))
				points, values = bench.samples_from_bmark(trained_file)
				data.set_samples(points, values, len(points[0]))
				variogram = {"type": "exponential", "nugget": 0.01, "range": 64.0, "sill": 1.0}
				polynomial = 0
				neighbors = 8
				interpol = interpolation.Kriging(data, polynomial, variogram, neighbors)
				estimate, variances = interpol.interpolate([[x_pt,y_pt]])		
				time=estimate[0]
				time*=1000000000
				time=int(time)
				print MatSize
				print time
				dataType=splitLine[1]
				if debug:
					files[localMaster].write(line)
					for i in destArray:
						files[i].write(line)
				for i in range(0,numProcs):
					strBuf="advt %s" %time
					if debug:
						strBuf+="       Advance timer for compute time of MM"
					strBuf+="\n"
					files[i].write(strBuf)
				files[localMaster].write("log\n")
				
			elif 'Barrier' in line:
				splitLine=re.split(r'[(),]', line) #split
				localMaster=0 #master is 1st index
				minMaxSplit=vars[splitLine[1]].split(':') #contains [num1,num2]
				destArray=range(1+int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				setupTime=int(setupTimes['1'])
				for k in range(0,2):
					strBuf="send %d %s %s %d" %(tag+barrier[0],barrier[0],setupTime,hopTime) #send instruction for master
					if debug:
						files[localMaster].write(line)
						for i in destArray:
							files[i].write(line)
					if debug:
						strBuf+="        Send barrier to node %d" %barrier[0]
					strBuf+="\n"
					files[localMaster].write(strBuf)
					strBuf= "recv %d" %(tag+barrier[0]) #corresponding recv instruction
					if debug:
						strBuf+="               Receive barrier from node %d" %barrier[0]
					strBuf+="\n"
					files[barrier[0]].write(strBuf)
					for i in destArray:
						setupTime=int(setupTimes['1'])
						
						strBuf= "recv %d" %(tag+int(barrier[i])) #corresponding receive instruction
						if debug:
							strBuf+="               Received barrier from node %d" %barrier[i]
						strBuf+="\n"
						files[barrier[i]].write(strBuf)
					for i in destArray:	
						strBuf="send %d %s %s %d" %(tag+int(barrier[i]),barrier[i],setupTime,hopTime) #ack send instruction
						if debug:
							strBuf+="       Send barrier to node %d" %barrier[i]
						strBuf+="\n"
						files[i].write(strBuf)
						
					tag+=1+len(destArray)
				files[localMaster].write("log\n")
			elif 'Init' in line:
				splitLine=re.split(r'[ (),\n]', line) #split
				config=splitLine[1]
				simSetup=splitLine[2]
				#files[0].write("init\n")
			elif 'Done' in line:
				for i in range(0,numProcs):
					strBuf="done"
					if debug:
						strBuf+="       End of file"
					strBuf+="\n"
					files[i].write(strBuf)
					
				break
			elif 'Bcast' in line:

				splitLine=re.split(r'[(),]', line) #split
				localMaster=int(splitLine[3]) #master is 1st index
				dataSize=splitLine[2]
				minMaxSplit=vars[splitLine[4]].split(':') #contains [num1,num2]
				destArray=range(1+int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				if debug:
					files[localMaster].write(line)
					for i in destArray:
						files[i].write(line)
				for i in range(0,numProcs):
					setupTime=int(setupTimes['1'])
					if (i<(length) and i>0):
						strBuf="recv %d" %(tag+i) #corresponding receive instruction
						if debug:
							strBuf+="               Receive broadcast from node %d" %(i-1)
						strBuf+="\n"
						files[i].write(strBuf)
						strBuf= "send %d %s %s %d" %(tag+(i-1+numProcs),i-1,setupTime,hopTime) #ack send instruction
						if debug:
							strBuf+="       Send acknowledgement for broadcast to node %d" %(i-1)
						strBuf+="\n"
						files[i].write(strBuf)
					elif (i>=length):
						strBuf= "recv %d" %(tag+i) #corresponding receive instruction
						if debug:
							strBuf+="               Receive broadcast from node %d" %(i-length)
						strBuf+="\n"
						files[i].write(strBuf)
						strBuf="send %d %s %s %d" %(tag+(i-length+2*numProcs),i-length,setupTime,hopTime) #ack send instruction
						if debug:
							strBuf+="       Send acknowledgement for broadcast to node %d" %(i-length)
						strBuf+="\n"
						files[i].write(strBuf)
					if ((int(dataSize) & (int(dataSize)-1))!=0):
						lowIndex=int(math.pow(2.0,int(math.log(float(dataSize),2))))
						highIndex=int(math.pow(2.0,math.ceil(math.log(float(dataSize),2))))
						higher=int(setupTimes[str(int(math.pow(2.0,math.ceil(math.log(float(dataSize),2)))))])
						lower=int(setupTimes[str(int(math.pow(2.0,int(math.log(float(dataSize),2)))))])
						#print higher
						#print lower
						setupTime=(int(dataSize)-lowIndex)*(higher-lower)/(highIndex-lowIndex)+lower+(int(dataSize)-1)*hopTime
						#print setupTime
						#setupTime=higher*int(dataSize)/lower+lower+(int(dataSize)-1)*hopTime
						#dataSize=str(int((math.pow(2,math.ceil(math.log(int(dataSize))/math.log(2))))))
					else:
						setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime


				
				for i in range(0,numProcs):	
					if(i<(length-1)):
						strBuf="send %d %s %s %d" %(tag+(i+1),i+1,setupTime,hopTime) #ack send instruction
						if debug:
							strBuf+="       Send broadcast to node %d" %(i+1)
						strBuf+="\n"
						files[i].write(strBuf)
						
						strBuf="recv %d" %(tag+(i+numProcs)) #corresponding receive instruction
						if debug:
							strBuf+="               Receive acknowledgement for broadcast from node %d" %(i+1)
						strBuf+="\n"
						files[i].write(strBuf)

					if(i<(numProcs-length)):	
						strBuf="send %d %s %s %d" %(tag+(i+length),i+length,setupTime,hopTime) #ack send instruction
						if debug:
							strBuf+="       Send broadcast to node %d" %(i+length)
						strBuf+="\n"
						files[i].write(strBuf)
						strBuf="recv %d" %(tag+(i+2*numProcs)) #corresponding receive instruction
						if debug:
							strBuf+="               Receive acknowledgement for broadcast from node %d" %(i+length)
						strBuf+="\n"
						files[i].write(strBuf)
				tag+=3*numProcs
				files[0].write("log\n")
			
	for f in files:
		f.close()
	
	
	
