#include<header.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<pthread.h>



//-------------------------------Globals----------------------------------------
//Communication params
extern int MASTER; 
extern int SLAVE;
extern int NWORDS;
//extern int iterations;

//Thread management
extern pthread_t master, slave;


//Time management
extern struct timespec st;









//------------------------------------------------------------------------------
//-----------------------MAster thread function---------------------------------
//------------------------------------------------------------------------------
void *thread_fn_master(void *arg)
{
  //Local variables
  int count,count1;
  double start, end, time=0;
  
  
  
  //Set cpu and activate udn
  if(tmc_cpus_set_my_cpu(MASTER)!=0)
  {
    printf("CPU setting failed.\n");
    exit(1);
  }
  tmc_udn_activate();
  
  
  //Alocate NWORDS 64 bit memory
  DATA_TYPE *buffer=malloc(NWORDS*sizeof(uint_reg_t));
 
  
  //Iterate over count iterations and measure the time
  start=0; 
  end=0;
    
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  start=st.tv_sec*1e9 + st.tv_nsec;
  for(count=0; count<iterations; count++)
  {
    
    
    
      send126((uint_reg_t*)buffer,NWORDS,SLAVE,UDN0_DEMUX_TAG);
    
    
    
  }  
   
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  end=st.tv_sec*1e9 + st.tv_nsec;
  time=(end-start)/iterations;  
    
  
  
  //Calculate the average of all iterations
 
  printf("%lf\n",time);
}













//------------------------------------------------------------------------------
//-----------------------------Slave thread function----------------------------
//------------------------------------------------------------------------------
void *thread_fn_slave(void *arg)
{
  //Set cpu and activate udn
  if(tmc_cpus_set_my_cpu(SLAVE)!=0)
  {
    printf("CPU setting failed.\n");
    exit(1);
  }
  
  tmc_udn_activate();
  int count1;
  //Receive packets
  int count;
  DATA_TYPE *buffer=malloc(NWORDS*(sizeof(uint_reg_t)/sizeof(DATA_TYPE))*sizeof(DATA_TYPE));
  for(count=0; count<iterations  ; count++)
  {
    
      receive126((uint_reg_t*)buffer,NWORDS,MASTER,UDN0_DEMUX_TAG);
    
  }
}












