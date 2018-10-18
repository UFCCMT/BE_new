def make(x,y):
	pos=[-150.0, -75.0]
	coord=[0.0,0.0]
	list=[]
	for i in range(y):
		for j in range(x):
			coord[1]=j*100+pos[0]
			coord[0]=i*100+pos[0]
			ID=i*x+j+1
			m='<entity name="BEO_Stack'+str(ID-1)+ '" class="BEO_Stack">\n\n\
			<property name="_location" class="VisualSim.kernel.util.Location" value="['+str(coord[1])+', '+str(coord[0])+']">\n \n\
			</property>\n        <property name="ID" class="VisualSim.data.expr.Parameter" value="'+str(ID-1)+'">\n \n\
			</property>\n \n\
			<entity name="Comm_BEO" class="VisualSim.actor.TypedCompositeActor"> \n\
       	    </entity>\n\
			</entity>'
			list.append(m)
	f=open('Matrix_'+str(x)+'x'+str(y)+'.txt','w')
	f.write(' '.join(list))
	f.close()
