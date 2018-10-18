//-----Most basic AppBEO possible.  Sets up mesh, sends and receives messages on each node.-----

#include "smp/smp.h"
#include <pthread.h>
#include <cstdlib>
#include <iostream>

smp::exascale_machine m;

void * thread0(void * args){
	int id = *((int*) args);
	if(id == 0){	//master node
		for(int i = 1; i < 16; i++){	//send data to each 
			m.send(0,i,5,500);
			std::cout << "send to " << i << "\n";
		}
	}
	else{	//slave nodes
		m.recv(id,0,5);	//each receives the data, echoes its ID
		std::cout << "received at " << id << "\n";
	}
}

int main(){
	int nrows = 4;
	int ncols = 4;
	int nprocs = nrows*ncols;
	
	//-----SETUP-----
	m.setup_procs(16);
	m.setup_mesh(4,4,NO_TRAFFIC);
	m.setup_workers(4);
	m.start_network();

	int *IDs = new int[nprocs];	//Create a 4x4 mesh and a thread for each node
	pthread_t *threads = new pthread_t[nprocs];
		
	for(int i = 0; i < nprocs; i++){
		IDs[i] = i;
		pthread_create(&threads[i], NULL, thread0, (void*)&IDs[i]);
	}

	void * ret; //needed for the join to ensure all threads stop

	for(int i = 0; i < nprocs; i++){	//join all threads before stopping
		pthread_join(threads[i], &ret);
	}
	
	return 0;
}
