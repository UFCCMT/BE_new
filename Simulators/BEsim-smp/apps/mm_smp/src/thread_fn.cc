//Amartya's example 2dmm AppBEO

#include "smp/smp.h"
#include<iostream>


#define NTHREADS   4
#define TAG_MSG    0
#define TAG_BARR   1
#define TAG_SIGNAL 2

extern smp::exascale_machine m;

extern int nrows, ncols, nprocs;
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
  
  
  //Broadcast
  if(threadID==0)
    time=m.smp_gettime(threadID);
    
  int x=threadID%ncols;
  int y=threadID/ncols;
  int bsize=datasize*datasize/2;
  if(y==0 && x!=0)
    m.recv(threadID,threadID-1,TAG_MSG);
    
  if(y==0 && x!= ncols-1)
    m.send(threadID,threadID+1,TAG_MSG,bsize);
    
  if(y!=0)
    m.recv(threadID,threadID-ncols,TAG_MSG);
  
  if(y!=nrows-1)
    m.send(threadID,threadID+ncols,TAG_MSG,bsize);
    
  
  if(threadID==0)
  {
    time=m.smp_gettime(threadID)-time;
    std::cout<<"Thread 0 bcast time: "<<time<<"\n";
  }
  
  std::cout<<"Thread "<<threadID<<" bcast done\n";
  
  
  
  
  //Barrier
  barrier(threadID);
  
  
  
  
  
  //Scatter  
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
    
    
  return NULL;
}




