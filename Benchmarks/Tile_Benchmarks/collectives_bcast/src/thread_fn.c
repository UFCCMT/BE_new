#include<header.h>
#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>



//-----------------------------------Globals------------------------------------
//Thread management
extern int nthreads;
extern pthread_t *threads;
extern int *thread_id;
extern int *core_map;
extern int *barrier_map;
extern int xmax, ymax;



//Time measurement and log management
extern char *logfile;
extern double *log_memory;



//Program parameters
extern int datasize;
extern int iterations;













//------------------------------------------------------------------------------
//--------------------------Thread function-------------------------------------
//------------------------------------------------------------------------------
void *thread_fn(void *arg)
{
  int ID=(*((int*)arg));
  int count, count1, count2;
  
  
  //Set cpu and activate udn
  if(tmc_cpus_set_my_cpu(core_map[ID])!=0)
  {
    printf("Thread: %d CPU setting failed.\n",ID);
    exit(1);
  }
  tmc_udn_activate();
  
  
  
  //Thread memory initialization
  DATA_TYPE *data_memory=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*datasize);
  int nwords=datasize*sizeof(DATA_TYPE)/sizeof(uint_reg_t);
  
  
  //calculate x and y co-ordinates
  int x=ID%(xmax+1);
  int y=ID/(xmax+1);



  //Time management crap
  double zero; //Reference time for iterations
  double bcast_s, bcast_e, bcast_d;
  struct timespec st;
  
  
  for(count=0; count<iterations; count++)
  {
    
    //--------------------------------------------------------------------------
    //----------------------------Start of benchmark----------------------------
    //--------------------Do this shit over iteration times---------------------
    //--------------------------------------------------------------------------
  

  
    
    //-------------------------Set reference time ------------------------------
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    zero=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;        
    
    
    
    
    //----------------------Broadcst--------------------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    bcast_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    
    //Broadcast the data in a broadcast tree
    if(y==0 && x!=0)
      receive126((uint_reg_t*)data_memory,nwords,core_map[ID-1],UDN0_DEMUX_TAG);
      
    if(y==0 && x!=xmax)
      send126((uint_reg_t*)data_memory,nwords,core_map[ID+1],UDN0_DEMUX_TAG);
      
    if(y!=0)
      receive126((uint_reg_t*)data_memory,nwords,core_map[ID-xmax-1],UDN0_DEMUX_TAG);
      
    if(y!=ymax && (ID+xmax+1)<nthreads)
      send126((uint_reg_t*)data_memory,nwords,core_map[ID+xmax+1],UDN0_DEMUX_TAG);
    
    if(ID==0)
      printf("Iteration: %d\n",count);
     
     
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    bcast_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    bcast_d=bcast_e-bcast_s;
    
    //Save the data to log
    log_memory[count*nthreads*3+ID*3+0]=bcast_s;
    log_memory[count*nthreads*3+ID*3+1]=bcast_e;
    log_memory[count*nthreads*3+ID*3+2]=bcast_d;
    
    barrier(ID);
     
    //--------------------------------------------------------------------------
    //------------------------------End of benchmark----------------------------
    //--------------------------------------------------------------------------

  }
  
  
  
  
  pthread_exit(NULL);
}








































