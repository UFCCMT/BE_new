import math
import os
def appGenerator(inFileBase,outFile,numProcs,dim,dataSize):
	if not os.path.exists("VS_Scripts"):
		os.makedirs("VS_Scripts")
	base=inFileBase
	outputFile="VS_Scripts/"+outFile
	f = open(outputFile, 'w')
	f.close()
	for i in range(0,numProcs):
		with open(outputFile, "a") as out:
			s=""
			s="\nif(ID==%s){\n" %i
			out.write(s)
			inputFile="LowLevelScripts/"+inFileBase+"_#"+str(i)+".txt"
			for l in open(inputFile):
				r=l.split(" ")
				if r[0]=='send':
					tag=r[1]
					dest=r[2]
					setupTime=int(float(r[3]))
					hopTime=int(float(r[4]))
					s="input.functionToCall=1\ninput.arg1=%d\ninput.arg2=%s\ninput.arg3=%s\ninput.arg4=%s\nSEND(\"output\",input)\n\n" %(setupTime,dest,tag,hopTime)
					out.write(s)
				elif r[0]=='recv':
					tag=r[1]
					s="input.functionToCall=3\ninput.arg3=%sSEND(\"output\",input)\n\n" %tag
					out.write(s)
				elif r[0]=='advt':
					time=int(float(r[1]))
					s="input.functionToCall=2\ninput.arg1=%s\nSEND(\"output\",input)\n\n" %time
					out.write(s)
				elif (r[0]=='done\n'):
					s="input.functionToCall=4\nSEND(\"output\",input)\n\n"
					out.write(s)
				elif r[0]=='record':
					inst=r[1]
					s="input.functionToCall=17\ninput.arg1=%s\nSEND(\"output\",input)\n\n" %inst
					out.write(s)
				elif r[0]=='log\n':
					s="input.functionToCall=37\nSEND(\"output\",input)\n\n"
					out.write(s)
				elif r[0]=='init\n':
                                        s="SEND(\"rsend\",\"\\n\"+Device+\",\"+Operation+\",\"+numProcs+\",\"+DataSize+\",\")\n"
					#s="SEND(\"rsend\",\"\\n\"+Device+\",\"+Operation+\",\"+numProcs+\",\"+DataSize+\",\"+DataSize2+\",\")\n"
					out.write(s)
				elif r[0]=="dot":
					t=int(r[1])
					s="input.functionToCall=20\ninput.arg1=%s\nSEND(\"output\",input)\n\n" %t
					out.write(s)
				elif r[0]=="sobel":
					t=int(r[1])
					s="input.functionToCall=21\ninput.arg1=%s\nSEND(\"output\",input)\n\n" %t
					out.write(s)
			s="}"
			out.write(s)
			out.close()
