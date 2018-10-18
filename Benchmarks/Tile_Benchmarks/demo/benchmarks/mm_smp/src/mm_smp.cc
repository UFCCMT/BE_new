#include<iostream>
#include<cstdio>
#include<pthread.h>
#include<smp/mesh.h>
#include<time.h>

void barrier(int);


#define UDN0_DEMUX_TAG TAG_USER+0
#define UDN1_DEMUX_TAG TAG_USER+1
#define UDN2_DEMUX_TAG TAG_USER+2
#define UDN3_DEMUX_TAG TAG_USER+3

#define BCAST_S 0
#define BCAST_E 1
#define BCAST_D 2

#define SCAT_S  3
#define SCAT_E  4
#define SCAT_D  5

#define COMP_S  6
#define COMP_E  7
#define COMP_D  8

#define GATH_S  9
#define GATH_E  10
#define GATH_D  11


//----------------------------------Globals-------------------------------------
int n_meshrows=6;
int n_meshcols=6;
int datasize=512;

meshBEO M(n_meshrows,n_meshcols);

float *log;





//---------------------------------Thread---------------------------------------
void *threadfn(void *arg)
{
  int threadID=(*((int*)arg));
  
  
  
  
  //Necessary variables
  int xmax=n_meshcols-1;
  int ymax=n_meshrows-1;
  int factor=2;
  //int nthreads=n_meshrows*n_meshcols;
  int nthreads=32;
  int nwords_bcast, nwords_scatter, nwords_gather;
  
  //Timekeeping variables
  float bcast_s, bcast_e, bcast_d, sca_s, sca_e, sca_d, comp_s, comp_e, comp_d, gath_s, gath_e, gath_d, barr_s, barr_e, barr_d,total_s,total_e;
  struct timespec st;
  
  //calculate x and y co-ordinates
  int x=threadID%(xmax+1);
  int y=threadID/(xmax+1);
  
  total_s=M.smp_clock_gettime(threadID,&st);
  
  if(threadID==0)
  printf("Start\n");
  
  
  
  
  
  //Broadcast the data in a broadcast tree
  nwords_bcast=datasize*datasize/factor;
  
  bcast_s=M.smp_clock_gettime(threadID,&st);
  
  if(y==0 && x!=0)
    M.recv(threadID,threadID-1,UDN0_DEMUX_TAG);
      
  if(y==0 && x!=xmax)
    M.send(threadID, threadID+1, UDN0_DEMUX_TAG ,nwords_bcast);
  
  
  if(y!=0 && threadID<nthreads)
    M.recv(threadID,threadID-1-xmax,UDN0_DEMUX_TAG);
 
      
  if(y!=ymax && (threadID+xmax+1)<nthreads)
    M.send(threadID, threadID+1+xmax, UDN0_DEMUX_TAG ,nwords_bcast);
    
  bcast_e=M.smp_clock_gettime(threadID,&st);
  bcast_d=bcast_e-bcast_s;
  
  
  

  
  
  
  //Barrier
  barr_s=M.smp_clock_gettime(threadID,&st);
  barrier(threadID);
  std::cout<<"Node "<<threadID<<" at barrier\n";
  barr_e=M.smp_clock_gettime(threadID,&st);
  barr_d=barr_e-barr_s;
  
  
  
  
   
 
 
 
 
  
  
  //Do a naive scatter
  sca_s=M.smp_clock_gettime(threadID,&st);
  if(threadID==0)
  {
    for(int count=1; count<nthreads; count++)
    {
      if(count<datasize%nthreads)
      {
        nwords_scatter=(datasize/nthreads+1)*datasize/factor;
        
        M.send(threadID,count,UDN0_DEMUX_TAG,nwords_scatter);
      } 
      else
      {
        nwords_scatter=(datasize/nthreads)*datasize/factor;
        
        M.send(threadID,count,UDN0_DEMUX_TAG,nwords_scatter);
      }
    }
  }
  if(threadID>0 && threadID<nthreads)
  {
    M.recv(threadID,0,UDN0_DEMUX_TAG);
    printf("received at node %d\n",threadID);
  }
  sca_e=M.smp_clock_gettime(threadID,&st);
  sca_d=sca_e-sca_s;
  
  
  
  
  
  
  //Do a  compute
  comp_s=M.smp_clock_gettime(threadID,&st);
  if(threadID<datasize%nthreads)
  {
    M.compute_m(threadID,datasize,datasize*(datasize/nthreads+1));
  }
  else
  {
    M.compute_m(threadID,datasize,datasize*(datasize/nthreads));
  }
  comp_e=M.smp_clock_gettime(threadID,&st);
  comp_d=comp_e-comp_s;
   
  
  
  
  
  
  
  //Do a gather
  gath_s=M.smp_clock_gettime(threadID,&st);
  
  //Thread 0 receives data from all threads  
    if(threadID==0)
    {
      for(int count=1; count<nthreads; count++)
      {
       
        //Send a signal to a certain waiting thread
        M.send_n(threadID,count,UDN2_DEMUX_TAG,1);
          
        //Receive data from that thread
        M.recv(threadID,count,UDN0_DEMUX_TAG);
        //printf("Received from node %d\n",count);
      }
    }
    if(threadID>0 && threadID<nthreads)
    {
      if(threadID<datasize%nthreads)
      {
        //Wait for signal from main signal
        M.recv(threadID,0,UDN2_DEMUX_TAG);
        
        //Send the partial C matrix
        nwords_gather=(datasize/nthreads+1)*datasize/factor;
        M.send(threadID,0,UDN0_DEMUX_TAG,nwords_gather);
      }
      else
      {
        //Wait for signal from main signal
        M.recv(threadID,0,UDN2_DEMUX_TAG);
        
        //Send the partial C matrix
        nwords_gather=(datasize/nthreads)*datasize/factor;
        M.send(threadID,0,UDN0_DEMUX_TAG,nwords_gather);
      }
    }
    gath_e=M.smp_clock_gettime(threadID,&st);
    gath_d=gath_e-gath_s;
    
    
    
    
    total_e=M.smp_clock_gettime(threadID,&st);
    
    //Print times 
    printf("%f\n",total_e-total_s);
    if(threadID==0)
    printf("bcast time: %f\n",bcast_d); 
    if(threadID==0)
    printf("barr time: %f\n",barr_d); 
    if(threadID==0)
    printf("Scatter time: %f\n",sca_d);
    if(threadID==0)
    printf("Compute time=%f\n",comp_d);
    if(threadID==0)
    printf("Gather time=%f\n",gath_d);
     
  
  pthread_exit(NULL);
   
   
}

int main()
{
  int *threadIDs=new int[n_meshrows*n_meshcols];
  pthread_t *threads=new pthread_t[n_meshrows*n_meshcols];
  
  for(int count=0; count<n_meshrows*n_meshcols; count++)
  {
    threadIDs[count]=count;
    pthread_create(&threads[count],NULL,threadfn,(void*)(&threadIDs[count]));
  }
  void *retval;
  
  for(int count=0; count<n_meshrows*n_meshcols; count++)
  {
    pthread_join(threads[count],&retval);
  }
}









