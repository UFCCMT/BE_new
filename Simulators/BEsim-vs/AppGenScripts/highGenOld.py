import re
import csv
import krige
import os
import math
def highGen(inFile,outFileBase,numProcs,dim,dataSize):
	length=dim
	size=dataSize
	hopTime=1
	barrierT=[None]*37
	barrierT[2]=[1,0]
	barrierT[4]=[1,3,0,2]
	barrierT[8]=[1,2,5,0,7,4,3,6]
	barrierT[16]=[1,2,3,7,0,9,5,6,4,10,11,15,8,12,13,14]
	barrierT[32]=[1,2,3,4,5,11,0,13,7,8, 9,10, 6,14,15,16,17,23,12,25,19,20,21,22,18,26,27,28,29,31,24,30]
	barrierT[36]=[1,2,3,4,5,11,0,13,7,8,9,10,6,14,15,16,17,23,12,25,19,20,21,22,18,26,27,28,29,35,24,30,31,32,33,34]
	barrierT[72]=[1,2,3,4,5,6,7,8,17,0,19,10,11,12,13,14,15,16,9,20,21,22,23,24,25,26,35,18,37,28,29,30,31,32,33,34,27,38,39,40,41,42,43,44,53,36,55,46,47,48,49,50,51,52,45,56,57,58,59,60,61,62,71,54,63,64,65,66,67,68,69,70]
	barrier=barrierT[numProcs]
	setupTime=3000
	loopTime=0
	vars={}
	tag=0 #acts as counter
	if not os.path.exists("LowLevelScripts"):
		os.makedirs("LowLevelScripts")
	files = [open('LowLevelScripts/%s_#%d.txt' %(outFileBase,i), 'w') for i in range(0,numProcs)] #opens all files for writing
	reader = csv.reader(open('DotProducts.csv','rU'))
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
	for line in open("HighLevelScripts/%s" %inFile): #iterates through input file
			if '//' in line:
				continue
			elif 'VAR' in line: #if variable defined, adds to variable array
				splitLine=re.split(r'[ =\n]', line)
				#print splitLine
				vars[splitLine[1]]=splitLine[2]
			elif 'Scatter' in line: #if scatter defined, generate scatter output
				splitLine=re.split(r'[(),]', line) #split
				localMaster=int(splitLine[1]) #master is 1st index
				dataSize=str(int(splitLine[3]))
				minMaxSplit=vars[splitLine[2]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				for i in destArray:
					#print dataSize
					if ((int(dataSize) & (int(dataSize)-1))!=0):
						print dataSize
						dataSize=str(int((math.pow(2,math.ceil(math.log(int(dataSize))/math.log(2))))))		
					setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
					files[localMaster].write( "send %d %s %s %d\n" %(tag,i,setupTime,hopTime)) #send instruction for master
					files[i].write( "recv %d\n" %tag) #corresponding recv instruction
					tag+=1 #increments tag
					setupTime=int(setupTimes['1'])
					files[i].write( "send %d %s %s %d\n" %(tag,localMaster,setupTime,hopTime)) #ack send instruction
					files[localMaster].write( "recv %d\n" %tag) #corresponding receive instruction
					tag+=1 #increments tag
				#files[localMaster].write("log\n")
			elif 'Gather' in line: #if scatter defined, generate scatter output
				splitLine=re.split(r'[(),]', line) #split
				localMaster=int(splitLine[1]) #master is 1st index
				dataSize=str(int(splitLine[3]))
				minMaxSplit=vars[splitLine[2]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
			
				#Initial send
				for i in destArray:

					#setupTime=int(setupTimes['1'])
					#files[localMaster].write( "send %d %s %s %d\n" %(tag,i,setupTime,hopTime)) #ack send instruction
					#files[i].write( "recv %d\n" %tag) #corresponding receive instruction
					#tag+=1
					if ((int(dataSize) & (int(dataSize)-1))!=0):
						print dataSize
						dataSize=str(int((math.pow(2,math.ceil(math.log(int(dataSize))/math.log(2))))))		
					setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
					files[i].write( "send %d %s %s %d\n" %(tag,localMaster,setupTime,hopTime)) #send instruction for master
					files[localMaster].write( "recv %d\n" %tag) #corresponding recv instruction
					tag+=1 #increments tag

					setupTime=int(setupTimes['1'])
					files[localMaster].write( "send %d %s %s %d\n" %(tag,i,setupTime,hopTime)) #ack send instruction
					files[i].write( "recv %d\n" %tag) #corresponding receive instruction
					tag+=1 #increments tag

				#files[localMaster].write("log\n")	
					

					
					
			elif 'Sobel' in line:
				splitLine=re.split(r'[ (),\n]', line) #split
				cols=splitLine[1]
				rows=600
				if int(cols)==640:
					rows=480      
				trained_file = "Tilera_Dot_Prod.bmark"
				trained_data = krige.get_dot_product_data(trained_file)
				variogram = ["exponential", 0.000, 1.0, 500.0]
				x_pt = [float(3)]
				point = [x_pt, x_pt]

				neighbors = 3
				poly = 0

				estimate, variances = krige.krige(trained_data, variogram, poly, point, neighbors)		
				time=estimate[0]
				#print time
				time*=1000000
				#time=dotProducts[vectorSize] --Use if no interpolation
				#print time	--with above
				#time=dotProducts[vectorSize]
				time=int(time)*3*((int(rows)-2)/numProcs)*(int(cols)-2)
			       # print "Compute= "+str(time)+ " D= "+str(vectorSize)+" proc= "+str(numProcs)
				#print time
				#print "Compute= "+str(time)+ " D= "+str(vectorSize)+" proc= "+str(numProcs)

				dataType=splitLine[2]
				for i in range(0,numProcs):
					files[i].write( "sobel %s\n" %cols)
				files[localMaster].write("log\n")		
			
				
			elif 'DotProduct' in line:
				splitLine=re.split(r'[ (),\n]', line) #split
				vectorSize=splitLine[1]
				trained_file = "Tilera_Dot_Prod.bmark"
				trained_data = krige.get_dot_product_data(trained_file)
				variogram = ["exponential", 0.000, 1.0, 500.0]
				x_pt = [float(vectorSize)]
				point = [x_pt, x_pt]

				neighbors = 3
				poly = 0

				estimate, variances = krige.krige(trained_data, variogram, poly, point, neighbors)		
				time=estimate[0]
				#print time
				time*=1000000
				#time=dotProducts[vectorSize]
				time=int(time)*int(vectorSize)*int(vectorSize)/numProcs
			       # print "Compute= "+str(time)+ " D= "+str(vectorSize)+" proc= "+str(numProcs)
				loopTime=loop_time[vectorSize]
				time=int(time)+int(loopTime)*int(vectorSize)*int(vectorSize)/numProcs
				#print time
				#print "Compute= "+str(time)+ " D= "+str(vectorSize)+" proc= "+str(numProcs)

				dataType=splitLine[2]
				for i in range(0,numProcs):
					#files[i].write( "dot %s\n" %vectorSize)
					files[i].write("advt %s\n" %time)
				#files[localMaster].write("log\n")
			elif 'Barrier' in line:
				splitLine=re.split(r'[(),]', line) #split
				localMaster=0 #master is 1st index
				minMaxSplit=vars[splitLine[1]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				setupTime=int(setupTimes['1'])
				files[localMaster].write( "send %d %s %s %d\n" %(tag+barrier[0],barrier[0],setupTime,hopTime)) #send instruction for master
				files[barrier[0]].write( "recv %d\n" %(tag+barrier[0])) #corresponding recv instruction
				for i in destArray:
					setupTime=int(setupTimes['1'])
					files[barrier[i]].write( "recv %d\n" %(tag+int(barrier[i]))) #corresponding receive instruction
				for i in destArray:	
					files[i].write( "send %d %s %s %d\n" %(tag+int(barrier[i]),barrier[i],setupTime,hopTime)) #ack send instruction
				tag+=1+len(destArray)
				#files[localMaster].write("log\n")
			elif 'Init' in line:
				splitLine=re.split(r'[ (),\n]', line) #split
				config=splitLine[1]
				simSetup=splitLine[2]
				#files[0].write("init\n")
			elif 'Done' in line:
				for i in range(0,numProcs):
					files[i].write("done\n")
				break
			elif 'Bcast' in line:
				splitLine=re.split(r'[(),]', line) #split
				localMaster=int(splitLine[1]) #master is 1st index
				dataSize=splitLine[3]
				minMaxSplit=vars[splitLine[2]].split(':') #contains [num1,num2]
				destArray=range(int(minMaxSplit[0]),1+int(minMaxSplit[1])) #contains list of all numbers from num1 to num2
				for i in range(0,numProcs):
					setupTime=int(setupTimes['1'])
					if (i<(length) and i>0):
						files[i].write( "recv %d\n" %(tag+i)) #corresponding receive instruction
						files[i].write( "send %d %s %s %d\n" %(tag+(i-1+numProcs),i-1,setupTime,hopTime)) #ack send instruction
					elif (i>=length):
						files[i].write( "recv %d\n" %(tag+i)) #corresponding receive instruction
						files[i].write( "send %d %s %s %d \n" %(tag+(i-length+2*numProcs),i-length,setupTime,hopTime)) #ack send instruction
				setupTime=int(setupTimes[dataSize])+(int(dataSize)-1)*hopTime
				for i in range(0,numProcs):	
					if(i<(length-1)):
						files[i].write( "send %d %s %s %d\n" %(tag+(i+1),i+1,setupTime,hopTime)) #ack send instruction
						files[i].write( "recv %d\n" %(tag+(i+numProcs))) #corresponding receive instruction

					if(i<(numProcs-length)):	
						files[i].write( "send %d %s %s %d\n" %(tag+(i+length),i+length,setupTime,hopTime)) #ack send instruction
						files[i].write( "recv %d\n" %(tag+(i+2*numProcs))) #corresponding receive instruction
				tag+=3*numProcs
				#files[numProcs-1].write("log\n")
			
	for f in files:
		f.close()
	
	
	
