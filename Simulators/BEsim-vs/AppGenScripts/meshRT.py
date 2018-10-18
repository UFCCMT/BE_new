import math
def make(x,y,Distance,Speed_Mbps):
  s="Node_"
  count=0
  list=[]
  for ID in range(1,x*y):
	if (ID+1)%x!=1:
	  entry=str(count)+' '+s+str(ID-1)+' '+s+str(ID)+' '+str(Distance)+' '+str(Speed_Mbps)+' ;'+'\n'
	  count+=1
	  list.append(entry)
	  entry=str(count)+' '+s+str(ID)+' '+s+str(ID-1)+' '+str(Distance)+' '+str(Speed_Mbps)+' ;'+'\n'
	  count+=1
	  list.append(entry)
	if (ID+x)<=(x*y):
	  entry=str(count)+' '+s+str(ID-1)+' '+s+str(ID-1+x)+' '+str(Distance)+' '+str(Speed_Mbps)+' ;'+'\n'
	  count+=1
	  list.append(entry)
	  entry=str(count)+' '+s+str(ID-1+x)+' '+s+str(ID-1)+' '+str(Distance)+' '+str(Speed_Mbps)+' ;'+'\n'
	  count+=1
	  list.append(entry)
  f=open('MeshRT_'+str(x*y)+'.txt','w')
  f.write(' '.join(list))
  f.close()

