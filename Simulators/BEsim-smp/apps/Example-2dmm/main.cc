/*
  64x64 2D Matrix Multiply running on a 2x2 mesh.
  Used as example code for 2dmm App
*/

#include<iostream>
#include<pthread.h>
#include<cstdlib>

#include "smp/smp.h"

#define TAG_MSG    0
#define TAG_BARR   1
#define TAG_SIGNAL 2

smp::exascale_machine m;

int nrows, ncols, nprocs;
int datasize;

void* thread_fn(void*);
void barrier(int);

//-----MAIN-----
int main(){
  nrows=2;            //Mesh Network Dimension  
  ncols=2;
  datasize=64;        //Matrix size (Assuming Square Matrix)
  nprocs=nrows*ncols;
  
  //Setup simulator-----------------------------
  m.setup_procs(nprocs);                //Create ProcBEOs
  m.setup_mesh(nrows,ncols,NO_TRAFFIC); //Setup Mesh Network
  m.setup_workers(4);                   //Create Worker Threads
  m.start_network();                    //Attach workers and procs to queues,
                                        //begin network simulation
  
  //Start threads--------------------------------
  pthread_t *threads=new pthread_t[nprocs];
  int *IDs=new int[nprocs];
  
  for(int count=0;count<nprocs; count++){
    IDs[count]=count;
    pthread_create(&threads[count],NULL,thread_fn,(void*)&IDs[count]);
  } 
  
  void *retval;
  
  for(int count=0;count<nprocs; count++){
    pthread_join(threads[0],&retval);
  } 
  
  return 0;
}