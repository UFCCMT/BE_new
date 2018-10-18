#include<header.h>
#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>

#include<sys/types.h>
#include<unistd.h>
#include<signal.h>



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
extern int ksize, ssize;
extern int iterations;













//------------------------------------------------------------------------------
//--------------------------Thread function-------------------------------------
//------------------------------------------------------------------------------
void *thread_fn(void *arg)
{
  int ID=(*((int*)arg));
  
  //Necessary local variables
  int count, count1, count2, start_addr, iterator;
  int result_count,vector_count;
  DATA_TYPE temp_sum;
  uint_reg_t gather_sig;
  
  
  //Set cpu and activate udn
  if(tmc_cpus_set_my_cpu(core_map[ID])!=0)
  {
    printf("Thread: %d CPU setting failed.\n",ID);
    exit(1);
  }
  tmc_udn_activate();
  
  
  
  //Thread memory initialization
  DATA_TYPE *kernel, *signal, *result;
  int ssize2=ssize+2*(ksize-1);
  int rsize=ssize+ksize-1;
  if(ID==0)
  {
    kernel=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*ksize);
    signal=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*ssize2);
    result=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(rsize));
  }
  else
  {
    kernel=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*ksize);
    if(ID<rsize%nthreads)
    {
      result=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(rsize/nthreads+1)+sizeof(uint_reg_t));
      signal=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(ksize+rsize/nthreads+1-1)+sizeof(uint_reg_t));
    }
    else
    {
      result=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(rsize/nthreads)+sizeof(uint_reg_t));
      signal=(DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(ksize+rsize/nthreads-1)+sizeof(uint_reg_t));
    }
  }
  int factor=sizeof(uint_reg_t)/sizeof(DATA_TYPE);
  
  
  
  //calculate x and y co-ordinates
  int x=ID%(xmax+1);
  int y=ID/(xmax+1);



  //Time management variables
  double zero; //Reference time for iterations
  double bcast_s, bcast_e, bcast_d, scatter_s, scatter_e, scatter_d, compute_s, compute_e, compute_d, gather_s, gather_e, gather_d;
  struct timespec st;
  
  
  
  
  
  
  
  
  
  
  
  
  for(iterator=0; iterator<iterations; iterator++)
  {
    
    //--------------------------------------------------------------------------
    //----------------------------Start of benchmark----------------------------
    //--------------------Do this shit over iteration times---------------------
    //--------------------------------------------------------------------------
  

  
    
    //-------------------------Set reference time ------------------------------
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    zero=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;        
    
    
    
    
    
    
    
    
    
    
    //----------------------Broadcst kernel ------------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    bcast_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    
    //Broadcast the data in a broadcast tree
    if(y==0 && x!=0)
      receive126((uint_reg_t*)kernel,ksize/factor,core_map[ID-1],UDN0_DEMUX_TAG);
      
    if(y==0 && x!=xmax)
      send126((uint_reg_t*)kernel,ksize/factor,core_map[ID+1],UDN0_DEMUX_TAG);
      
    if(y!=0)
      receive126((uint_reg_t*)kernel,ksize/factor,core_map[ID-xmax-1],UDN0_DEMUX_TAG);
      
    if(y!=ymax && (ID+xmax+1)<nthreads)
      send126((uint_reg_t*)kernel,ksize/factor,core_map[ID+xmax+1],UDN0_DEMUX_TAG);
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    bcast_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    bcast_d=bcast_e-bcast_s;
    
    if(ID==0)
    {
      printf("Iteration %d bcast done\n",iterator);
    }
    
    
    
   
   
   
   
   
    //---------------------Barrier----------------------------------------------
    barrier(ID);
    
    
    
    
    
    
    
   
   
   
   
   
    //-------------------------Scatter signal ----------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    scatter_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    
    //Thread 0 sends out pieces of the signal vector
    start_addr=(rsize/nthreads==0?(rsize/nthreads):(rsize/nthreads+1));
    if(ID==0)
    {
      for(count=1; count<nthreads; count++)
      {
        if(count<rsize%nthreads)
        {
          send126((uint_reg_t*)(&signal[start_addr]),(ksize+rsize/nthreads+1-1)/factor+1,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=rsize/nthreads+1;
        }
        else
        {
          send126((uint_reg_t*)(&signal[start_addr]),(ksize+rsize/nthreads-1)/factor+1,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=rsize/nthreads;
        }  
      }
    }
    
    //Others receive data
    else
    {
      if(ID <rsize%nthreads)
      {
        receive126((uint_reg_t*)signal,(ksize+rsize/nthreads+1-1)/factor+1,core_map[0],UDN0_DEMUX_TAG);
      }
      else
      {
        receive126((uint_reg_t*)signal,(ksize+rsize/nthreads-1)/factor+1,core_map[0],UDN0_DEMUX_TAG);
      }
    }
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    scatter_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    scatter_d=scatter_e-scatter_s;
    
    if(ID==0)
    {
      printf("Iteration %d scatter done\n",iterator);
    }
    
    
    
    
    
    
    
    
    
    //---------------------------Compute----------------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    
    
    
    
    if(ID<rsize%nthreads)
    {
      for(result_count=0; result_count<rsize/nthreads+1; result_count++)
      {
        temp_sum=0;
        for(vector_count=0; vector_count<ksize;vector_count++)
        {
          temp_sum+=(kernel[vector_count]*signal[result_count+vector_count]);
        }
        result[result_count]=temp_sum;
      }
    }
    else
    {
      for(result_count=0; result_count<rsize/nthreads; result_count++)
      {
        temp_sum=0;
        for(vector_count=0; vector_count<ksize;vector_count++)
        {
          temp_sum+=(kernel[vector_count]*signal[result_count+vector_count]);
        }
        result[result_count]=temp_sum;
      }
    }
    
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    compute_d=compute_e-compute_s;
    
    if(ID==0)
    {
      printf("Iteration %d compute done\n",iterator);
    }
    
    
    
    
    
    
    
    
    
    
    
    //---------------------------Gather result matrix---------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    gather_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    
    //Thread 0 receives data from all threads
    start_addr=((rsize%nthreads==0)?(rsize/nthreads):(rsize/nthreads+1));
    if(ID==0)
    {
      for(count=1; count<nthreads; count++)
      {
        if(count<rsize%nthreads)
        {
          //Send a signal to a certain waiting thread
          DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          
          //Receive data from that thread
          receive126((uint_reg_t*)(&result[start_addr]),(rsize/nthreads+1)/factor+1,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=(rsize/nthreads+1);
        }
        else
        {
          //Send a signal to a certain waiting thread
          DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          
          //Receive data from that thread
          receive126((uint_reg_t*)(&result[start_addr]),(rsize/nthreads)/factor+1,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=(rsize/nthreads);
        }
      }
    }
    else
    {
      if(ID<rsize%nthreads)
      {
        //Wait for signal from main signal
        gather_sig=tmc_udn2_receive();
        
        //Send the partial C matrix
        send126((uint_reg_t*)result,(rsize/nthreads+1)/factor+1,core_map[0],UDN0_DEMUX_TAG);  
      }
      else
      {
        //Wait for signal from main signal
        gather_sig=tmc_udn2_receive();
        
        //Send the partial C matrix
        send126((uint_reg_t*)result,(rsize/nthreads)/factor+1,core_map[0],UDN0_DEMUX_TAG);  
      }
    }
    
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    gather_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    gather_d=gather_e-gather_s;
    
    if(ID==0)
    {
      printf("Iteration %d gather done\n",iterator);
    }
    
    
    
    
    
    
    
    
    //---------------------------Log the data-----------------------------------
    log_memory[iterator*nthreads*12+ID*12+BCAST_S]=bcast_s;
    log_memory[iterator*nthreads*12+ID*12+BCAST_E]=bcast_e;
    log_memory[iterator*nthreads*12+ID*12+BCAST_D]=bcast_d;
    
    log_memory[iterator*nthreads*12+ID*12+SCA_S]=scatter_s;
    log_memory[iterator*nthreads*12+ID*12+SCA_E]=scatter_e;
    log_memory[iterator*nthreads*12+ID*12+SCA_D]=scatter_d;
    
    log_memory[iterator*nthreads*12+ID*12+COMP_S]=compute_s;
    log_memory[iterator*nthreads*12+ID*12+COMP_E]=compute_e;
    log_memory[iterator*nthreads*12+ID*12+COMP_D]=compute_d;
    
    log_memory[iterator*nthreads*12+ID*12+GATH_S]=gather_s;
    log_memory[iterator*nthreads*12+ID*12+GATH_E]=gather_e;
    log_memory[iterator*nthreads*12+ID*12+GATH_D]=gather_d;
    
    
     
    //---------------------Barrier----------------------------------------------
    barrier(ID);
    
    /*
    if(ID==0)
      printf("Iteration: %d\n",count);
    
    
     
    //--------------------------------------------------------------------------
    //------------------------------End of benchmark----------------------------
    //--------------------------------------------------------------------------
  */
  }
  
  //Free thread local memory
  free(kernel);
  free(signal);
  free(result);
  
  
  pthread_exit(NULL);
}





void *watchdog(void *arg)
{
  long int count=0;
  while(1)
  {
    if(count%5==0)
    {
      printf("running even now %d sec.\n",count);
      system("touch watchdog_file");
    }
    count++;
    sleep(1);
  }
}




































