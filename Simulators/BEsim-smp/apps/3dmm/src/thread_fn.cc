//-----INCOMPLETE IMPLEMENTATION OF 3DMM-----

#include "smp/smp.h"
#include<iostream>


#define NTHREADS   4
#define TAG_MSG    0
#define TAG_BARR   1
#define TAG_SIGNAL 2

extern smp::exascale_machine m;

extern int numrows, ncols, dim, nprocs;
extern int datasize;


//--------------------------Barrier function------------------------------------
void barrier(int ID)
{
  if(ID==0)
  {
    m.send(ID,1,TAG_BARR,1);
    m.recv(ID,nprocs-1,TAG_BARR);  
  }
  if(ID!=0 && ID!=(nprocs-1))
  {
    m.recv(ID,ID-1,TAG_BARR);
    m.send(ID,ID+1,TAG_BARR,1);
  }
  if(ID==nprocs-1)
  {
    m.recv(ID,ID-1,TAG_BARR);
    m.send(ID,0,TAG_BARR,1);
  }
  
  //std::cout<<ID<<" hit barrier\n";
}





//------------------------------Thread function---------------------------------
void *thread_fn(void *arg)
{
  int threadID=(*((int*)arg));
  float time;
  
  
  float temp;
  
  //For each chunk, perform 3dmm algo w/ 
  //Return N/M chunks from each processor

  //Broadcast
  
  if(threadID==0)
    time=m.smp_gettime(threadID);
    
  int x=threadID%nrows;
  int y=threadID/nrows;
  //Send datasize*datasize*datasize/nprocs 3D matrix to each processor
  //Also send dim*dim 2D matrix to each processor

  //#packets - TWO 32-bit pieces of data in a single 64 bit packet
  int bsize=((datasize*datasize*datasize/nprocs) + (dim*dim))/2;

  if(y==0 && x!=0)
    m.recv(threadID,threadID-1,TAG_MSG);
    
  if(y==0 && x!= nrows-1)
    m.send(threadID,threadID+1,TAG_MSG,bsize);
    
  if(y!=0)
    m.recv(threadID,threadID-nrows,TAG_MSG);
  
  if(y!=nrows-1)
    m.send(threadID,threadID+nrows,TAG_MSG,bsize);
    
  
  if(threadID==0)
  {
    time=m.smp_gettime(threadID)-time;
    std::cout<<"Thread 0 bcast time: "<<time<<"\n";
  }
  
  std::cout<<"Thread "<<threadID<<" bcast done\n";
  
  
  
  
  //Barrier
  
  barrier(threadID);
  
  
  
  
  
  //Scatter  
  /*
  if(threadID==0)
    time=m.smp_gettime(threadID);
  if(threadID==0)
  {
    for(int count=1; count<nprocs; count++)
    {
      if(count<datasize%nprocs)
        m.send(threadID,count,TAG_MSG,(datasize/nprocs+1)*datasize/2);
      else
        m.send(threadID,count,TAG_MSG,(datasize/nprocs)*datasize/2);
    
        m.compute(threadID,3); //Control times
    }
  }
  else
  {
    m.recv(threadID,0,TAG_MSG);
  }
  
  std::cout<<"Thread "<<threadID<<" scatter done\n";
  
  if(threadID==0)
  {
    time=m.smp_gettime(threadID)-time;
    std::cout<<"Thread 0 scatter time: "<<time<<"\n";
  }
  */
  
  
  
  
  //Compute
  
  if(threadID==0)
    time=m.smp_gettime(threadID);
  
  if(threadID<datasize%nprocs)
  {
    m.compute_m(threadID,datasize,(datasize/nprocs+1)*datasize);
    m.compute_m(threadID,datasize,(datasize/nprocs+1)); //Control stuff
    m.compute_m(threadID,datasize,(datasize/nprocs+1)); //Control stuff
  }
  else
  {
    m.compute_m(threadID,datasize,(datasize/nprocs)*datasize);
    m.compute_m(threadID,datasize,(datasize/nprocs)); //Control stuff
    m.compute_m(threadID,datasize,(datasize/nprocs)); //Control stuff
  }
    
  if(threadID==0)
  {
    time=m.smp_gettime(threadID)-time;
    std::cout<<"Thread 0 compute time: "<<time<<"\n";
  }
  
  
  std::cout<<"Thread "<<threadID<<" compute done\n";
  
  
  
  
  //Gather
  /*
  if(threadID==0)
  {
    time=m.smp_gettime(threadID);
  }
    
  if(threadID==0)
  {
    for(int count=1; count<nprocs; count++)
    {
      m.send_n(threadID,count,TAG_SIGNAL,1);
      m.recv(threadID,count,TAG_MSG);
    } 
  }
  else
  {
    m.recv(threadID,0,TAG_SIGNAL);
    if(threadID<datasize%nprocs)
    {
      m.compute(threadID,3); //Control times
      m.send(threadID,0,TAG_MSG,(datasize/nprocs+1)*datasize/2);
    }
    else
    {
      m.compute(threadID,3); //Control times
      m.send(threadID,0,TAG_MSG,(datasize/nprocs)*datasize/2);
    }
  }
  
  std::cout<<"Thread "<<threadID<<" gather done\n";
  
  if(threadID==0)
  {
    time=m.smp_gettime(threadID)-time;
    std::cout<<"Thread 0 gather time: "<<time<<"\n";
  }
  */
    
  return NULL;
}