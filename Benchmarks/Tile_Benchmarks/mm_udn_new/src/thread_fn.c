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
extern int datasize;
extern int iterations;













//------------------------------------------------------------------------------
//--------------------------Thread function-------------------------------------
//------------------------------------------------------------------------------
void *thread_fn(void *arg)
{
  int ID=(*((int*)arg));
  
  //Necessary local variables
  int count, count1, count2, start_addr, iterator;
  int row_count_A, col_count_B, el_count;
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
  DATA_TYPE *A, *B, *C;
  int factor=sizeof(uint_reg_t)/sizeof(DATA_TYPE);
  
  if(ID==0)
  {
    A=(DATA_TYPE*)malloc(datasize*datasize*sizeof(DATA_TYPE));
    B=(DATA_TYPE*)malloc(datasize*datasize*sizeof(DATA_TYPE));
    C=(DATA_TYPE*)malloc(datasize*datasize*sizeof(DATA_TYPE));
  }
  else
  {
    B=(DATA_TYPE*)malloc(datasize*datasize*sizeof(DATA_TYPE));
    if(ID<datasize%nthreads)
    {
      A=(DATA_TYPE*)malloc((datasize/nthreads+1)*datasize*sizeof(DATA_TYPE));
      C=(DATA_TYPE*)malloc((datasize/nthreads+1)*datasize*sizeof(DATA_TYPE));
    }
    else
    {
      A=(DATA_TYPE*)malloc((datasize/nthreads)*datasize*sizeof(DATA_TYPE));
      C=(DATA_TYPE*)malloc((datasize/nthreads)*datasize*sizeof(DATA_TYPE));
    }
  }
  
  int nwords_bcast, nwords_scatter, nwords_gather;
  nwords_bcast=datasize*datasize/factor;
  
  
  
  //calculate x and y co-ordinates
  int x=ID%(xmax+1);
  int y=ID/(xmax+1);



  //Time management variables
  double zero; //Reference time for iterations
  double bcast_s, bcast_e, bcast_d, scatter_s, scatter_e, scatter_d, compute_s, compute_e, compute_d, gather_s, gather_e, gather_d;
  struct timespec st;
  
  
  
  
  
  
  
  
  struct timespec tot;
  double total_time_s,total_time_e,total_time_d=0;
  
  
  for(iterator=0; iterator<iterations; iterator++)
  { 
    //--------------------------------------------------------------------------
    //----------------------------Start of benchmark----------------------------
    //--------------------Do this shit over iteration times---------------------
    //--------------------------------------------------------------------------
  

  
    
    //-------------------------Set reference time ------------------------------
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    zero=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;        
    
    
    
    
    
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&tot);
    total_time_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);
  
    
    
    
    
    //----------------------Broadcst B matrix-----------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    bcast_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    
    //Broadcast the data in a broadcast tree
    if(y==0 && x!=0)
      receive126((uint_reg_t*)B,nwords_bcast,core_map[ID-1],UDN0_DEMUX_TAG);
      
    if(y==0 && x!=xmax)
      send126((uint_reg_t*)B,nwords_bcast,core_map[ID+1],UDN0_DEMUX_TAG);
      
    if(y!=0)
      receive126((uint_reg_t*)B,nwords_bcast,core_map[ID-xmax-1],UDN0_DEMUX_TAG);
      
    if(y!=ymax && (ID+xmax+1)<nthreads)
      send126((uint_reg_t*)B,nwords_bcast,core_map[ID+xmax+1],UDN0_DEMUX_TAG);
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    bcast_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    bcast_d=bcast_e-bcast_s;
    
    if(ID==0)
    {
      printf("Iteration %d bcast done\n",iterator);
      printf("Time taken: %lf\n",bcast_d);
    }
    
    
    
   
   
   
   
   
   
    //---------------------Barrier----------------------------------------------
    barrier(ID);
    
    
    
    
    
    
    
   
   
   
   
   
    //-------------------------Scatter A matrix---------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    scatter_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    //Thread 0 sends out all data
    start_addr=((datasize%nthreads==0)?((datasize/nthreads)*datasize):((datasize/nthreads+1)*datasize));
    if(ID==0)
    {
      for(count=1; count<nthreads; count++)
      {
        if(count<datasize%nthreads)
        {
          nwords_scatter=(datasize/nthreads+1)*datasize/factor;
          send126((uint_reg_t*)(&A[start_addr]),nwords_scatter,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=(datasize/nthreads+1)*datasize;
        }
        else
        {
          nwords_scatter=(datasize/nthreads)*datasize/factor;
          send126((uint_reg_t*)(&A[start_addr]),nwords_scatter,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=(datasize/nthreads)*datasize;
        }  
      }
    }
    
    //Others receive data
    else
    {
      if(ID <datasize%nthreads)
      {
        nwords_scatter=(datasize/nthreads+1)*datasize/factor;
        receive126((uint_reg_t*)A,nwords_scatter,core_map[0],UDN0_DEMUX_TAG);
      }
      else
      {
        nwords_scatter=(datasize/nthreads)*datasize/factor;
        receive126((uint_reg_t*)A,nwords_scatter,core_map[0],UDN0_DEMUX_TAG);
      }
    }
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    scatter_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    scatter_d=scatter_e-scatter_s;
    
    if(ID==0)
    {
      printf("Iteration %d scatter done\n",iterator);
      printf("Time taken: %lf\n",scatter_d);
    }
    
    
    
    
    
    
    
    
    
    //---------------------------Compute----------------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    
    row_count_A=0;
    col_count_B=0;
    el_count=0;
    temp_sum=0;
    
    if(ID<datasize%nthreads)
    {
      for(row_count_A=0; row_count_A<(datasize/nthreads+1); row_count_A++)
      {
        for(col_count_B=0; col_count_B<datasize; col_count_B++)
        {
          temp_sum=0;
          for(el_count=0; el_count<datasize; el_count++)
          {
            //It is safe to assume column major arrangement for B
            temp_sum+=(A[row_count_A*datasize+el_count]*B[col_count_B*datasize+el_count]);
          }
          C[row_count_A*datasize+col_count_B]=temp_sum;
        }
      }
    }
    else
    {
      int temp_a, temp_b;
      for(row_count_A=0; row_count_A<(datasize/nthreads); row_count_A++)
      {
        temp_a=row_count_A*datasize;
        
        for(col_count_B=0; col_count_B<datasize; col_count_B++)
        {
          temp_sum=0;
          
          temp_b=col_count_B*datasize;
          
          for(el_count=0; el_count<datasize; el_count++)
          {
            //It is safe to assume column major arrangement for B
            temp_sum+=(A[row_count_A*datasize+el_count]*B[col_count_B*datasize+el_count]);
          }
          C[row_count_A*datasize+col_count_B]=temp_sum;
        }
      }
    }
    
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    compute_d=compute_e-compute_s;
    
    if(ID==0)
    {
      printf("Iteration %d compute done\n",iterator);
      printf("Time taken: %lf\n",compute_d);
    }
    
    
    
    
    
    
    
    
    
    
    
    //--------------------------GAther C matrix---------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    gather_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    
    //Thread 0 receives data from all threads
    start_addr=((datasize%nthreads==0)?((datasize/nthreads)*datasize):((datasize/nthreads+1)*datasize));
    if(ID==0)
    {
      for(count=1; count<nthreads; count++)
      {
        if(count<datasize%nthreads)
        {
          //Send a signal to a certain waiting thread
          DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          
          //Receive data from that thread
          nwords_gather=(datasize/nthreads+1)*datasize/factor;
          receive126((uint_reg_t*)(&C[start_addr]),nwords_gather,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=(datasize/nthreads+1);
        }
        else
        {
          //Send a signal to a certain waiting thread
          DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          
          //Receive data from that thread
          nwords_gather=(datasize/nthreads)*datasize/factor;
          receive126((uint_reg_t*)(&C[start_addr]),nwords_gather,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=(datasize/nthreads);
        }
      }
    }
    else
    {
      if(ID<datasize%nthreads)
      {
        //Wait for signal from main signal
        gather_sig=tmc_udn2_receive();
        
        //Send the partial C matrix
        nwords_gather=(datasize/nthreads+1)*datasize/factor;
        send126((uint_reg_t*)C,nwords_gather,core_map[0],UDN0_DEMUX_TAG);  
      }
      else
      {
        //Wait for signal from main signal
        gather_sig=tmc_udn2_receive();
        
        //Send the partial C matrix
        nwords_gather=(datasize/nthreads)*datasize/factor;
        send126((uint_reg_t*)C,nwords_gather,core_map[0],UDN0_DEMUX_TAG);  
      }
    }
    
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    gather_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    gather_d=gather_e-gather_s;
    
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&tot);
    total_time_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);
    total_time_d+=(total_time_e-total_time_s);
    
    if(ID==0)
    {
      printf("Iteration %d gather done\n",iterator);
      printf("Time taken: %lf\n",gather_d);
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
  
  printf("%lf\n",total_time_d/iterations);
  //Free thread local memory
  free(A);
  free(B);
  free(C);
  
  
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




































