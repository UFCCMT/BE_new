//-----INCOMPLETE IMPLEMENTATION OF 3DMM-----

#include<iostream>
#include<pthread.h>
#include<cstdlib>

#include "smp/smp.h"

#define NTHREADS   4
#define TAG_MSG    0
#define TAG_BARR   1
#define TAG_SIGNAL 2

smp::exascale_machine m;

int nrows, ncols, dim, nprocs;
int datasize;


void* thread_fn(void*);
void barrier(int);



//------------------------------------------------------------------------------
//----------------------------Main----------------------------------------------
//------------------------------------------------------------------------------
int main(int argc, char *argv[])
{
  //Parse cmd line args------------------------
  if(argc<4)
  {
    std::cout<<"Usage: bin <Nrows/Ncols> <Datasize> <DIM>\n";
    exit(EXIT_FAILURE);
  }
  //N = #blocks
  //M = mesh value


  nrows = atoi(argv[1]);
  ncols = atoi(argv[1]);
  datasize = atoi(argv[2]);
  dim = atoi(argv[3]);
  nprocs = nrows*ncols; //1 proc per mesh node

  //nrows=atoi(argv[1]);
  //ncols=atoi(argv[2]);
  //datasize=atoi(argv[3]);
  //nprocs=nrows*ncols;
  
  
  //Setup simulator-----------------------------
  m.setup_procs(nprocs);
  m.setup_mesh(nrows, ncols, NO_TRAFFIC);
  m.setup_workers(NTHREADS);
  m.start_network();
  
  
  
  
  //Start threads--------------------------------
  pthread_t *threads=new pthread_t[nprocs];
  int *IDs=new int[nprocs];
  
  for(int count=0;count<nprocs; count++)
  {
    IDs[count]=count;
    pthread_create(&threads[count],NULL,thread_fn,(void*)&IDs[count]);
  } 
  
  void *retval;
  
  for(int count=0;count<nprocs; count++)
  {
    pthread_join(threads[0],&retval);
  } 
  
  return 0;
  
}
