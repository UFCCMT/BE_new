#include<header.h>
#include<pthread.h>
#include<cstdio>
#include<cstdlib>


#include<sys/types.h>
#include<unistd.h>
#include<signal.h>

#include<smp/mesh.h>


#define TAG 10
//-----------------------------------Globals------------------------------------
extern meshBEO M;

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
extern int nrows, ncols;
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
  //uint_reg_t gather_sig;
  DATA_TYPE weight[3][3] = {{ -1,  0,  1 },{ -2,  0,  2 },{ -1,  0,  1 }};
  
  
  
  
  
  //Thread memory initialization
  DATA_TYPE *image, *gx, *gy;
  int n_out_rows=nrows-2;
  int factor=sizeof(uint_reg_t)/sizeof(DATA_TYPE);
  /*
  if(ID==0)
  {
    image = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
    gx    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
    gy    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
    
    for(count=0; count<nrows; count++)
    {
      for(count1=0; count1<ncols; count1++)
      {
        image[count*ncols+count1]=count;
      }
    }
  }
  else
  {
    if(ID<n_out_rows%nthreads)
    {
      image = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(n_out_rows/nthreads+1+2)*ncols);
      gx    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(n_out_rows/nthreads+1  )*ncols);
      gy    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(n_out_rows/nthreads+1  )*ncols);
    }
    else
    {
      image = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(n_out_rows/nthreads+2)*ncols);
      gx    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(n_out_rows/nthreads  )*ncols);
      gy    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*(n_out_rows/nthreads  )*ncols);
    }
  }
  */
  
  
  //calculate x and y co-ordinates
  int x=ID%(xmax+1);
  int y=ID/(xmax+1);



  //Time management variables
  double zero; //Reference time for iterations
  double scatter_s, scatter_e, scatter_d, compute_s, compute_e, compute_d, gather_s, gather_e, gather_d,total_s,total_e,total_d;
  struct timespec st;
  
  
  
  
  
  
  
  
  
  
  for(iterator=0; iterator<1; iterator++)
  {
    
    //--------------------------------------------------------------------------
    //----------------------------Start of benchmark----------------------------
    //--------------------Do this shit over iteration times---------------------
    //--------------------------------------------------------------------------
  

  
    
    //-------------------------Set reference time ------------------------------
    //clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    
    
    
   total_s=M.smp_clock_gettime(core_map[ID],&st);
    
    //------------------------Step 1: Naive scatter-----------------------------
    //Set start time
    scatter_s=M.smp_clock_gettime(core_map[ID],&st);
    
    if(ID==0)
    {
      start_addr=((n_out_rows%nthreads==0)?(n_out_rows/nthreads+1):(n_out_rows/nthreads+1+1));
    
      for(count=1; count<nthreads; count++)
      {
        if(count<n_out_rows%nthreads)
        {
          M.send(core_map[ID],core_map[count],TAG,(n_out_rows/nthreads+1+1+1)*ncols/factor); 
        }
        else
        {
          M.send(core_map[ID],core_map[count],TAG,(n_out_rows/nthreads+1+1)*ncols/factor);
        }
      }
    }
    else
    {
      if(ID<n_out_rows%nthreads)
      { 
        M.recv(core_map[ID],core_map[0],TAG);
      }
      else
      {
        M.recv(core_map[ID],core_map[0],TAG);
      }
    }
    
    //Set end time
    scatter_e=M.smp_clock_gettime(core_map[ID],&st);
    scatter_d=scatter_e-scatter_s;
    
    
    
    
    
    
    //-------------------------------Sobel compute------------------------------
    compute_s=M.smp_clock_gettime(core_map[ID],&st);
    
    //Compute Gx
    int i,j;
    if(ID<n_out_rows%nthreads)
    {
      temp_sum=(DATA_TYPE)0;
      for(count=1; count<(n_out_rows/nthreads+1+2-1); count++)
      {
        for(count1=1; count1<(ncols-1); count1++)
        {
          M.compute_m(core_map[ID],3,3);
        }
      }
    }
    else
    {
      temp_sum=(DATA_TYPE)0;
      for(count=1; count<(n_out_rows/nthreads+2-1); count++)
      {
        for(count1=1; count1<(ncols-1); count1++)
        {
          M.compute_m(core_map[ID],3,3);
        }
      }
    }
    
    
    //Compute Gy
    if(ID<n_out_rows%nthreads)
    {
      temp_sum=(DATA_TYPE)0;
      for(count1=1; count1<(ncols-1); count1++)
      {
        for(count=1; count<(n_out_rows/nthreads+1+2-1); count++)
        {
          M.compute_m(core_map[ID],3,3);
        }
      }
    }
    else
    {
      temp_sum=(DATA_TYPE)0;
      for(count1=1; count1<(ncols-1); count1++)
      {
        for(count=1; count<(n_out_rows/nthreads+2-1); count++)
        {
          M.compute_m(core_map[ID],3,3);
        }
      }
    }
    
    //Set end time
    //clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    //compute_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero; 
    compute_e=M.smp_clock_gettime(core_map[ID],&st);   
    compute_d=compute_e-compute_s;
    
    
    
    
    
    
    
    
    //---------------------------Gather-----------------------------------------
    
    //Set start time
    //clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    //gather_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    gather_s=M.smp_clock_gettime(core_map[ID],&st);
    
    
    if(ID==0)
    {
      start_addr=1;
     
      for(count=1; count<nthreads; count++)
      {
        if(count<n_out_rows%nthreads)
        {
          //Send a signal to a certain waiting thread
          //DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          //tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          M.send_n(core_map[ID],core_map[count],TAG_MSG,1);
          
          //Collect Gx from that thread
          //receive126((uint_reg_t*)(&gx[start_addr*ncols]),(n_out_rows/nthreads+1)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);  
          M.recv(core_map[ID],core_map[count],TAG_MSG);
          
          //Collect Gy from that thread
          //receive126((uint_reg_t*)(&gy[start_addr*ncols]),(n_out_rows/nthreads+1)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);
          M.recv(core_map[ID],core_map[count],TAG_MSG);  
                  
          //start_addr+=(n_out_rows/nthreads+1);
        }
        else
        {
          //Send a signal to a certain waiting thread
          //DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          //tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          M.send_n(core_map[ID],core_map[count],TAG_MSG,1);
          
          //Collect Gx from that thread
          //receive126((uint_reg_t*)(&gx[start_addr*ncols]),(n_out_rows/nthreads)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);  
          M.recv(core_map[ID],core_map[count],TAG_MSG);  
          
          //Collect Gy from that thread
          //receive126((uint_reg_t*)(&gy[start_addr*ncols]),(n_out_rows/nthreads)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);  
          M.recv(core_map[ID],core_map[count],TAG_MSG);  
                  
          start_addr+=(n_out_rows/nthreads);
        }
      }
    }
    else
    {
      if(ID<n_out_rows%nthreads)
      {
        //Wait for signal from main signal
        //gather_sig=tmc_udn2_receive();
        M.recv(core_map[ID],core_map[0],TAG_MSG);
        
        //Send the partial gx 
        //send126((uint_reg_t*)gx,(n_out_rows/nthreads+1)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);  
        M.send(core_map[ID],core_map[0],TAG_MSG,(n_out_rows/nthreads+1)*ncols/factor);
        
        //Send the partial gy 
        //send126((uint_reg_t*)gy,(n_out_rows/nthreads+1)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);  
        M.send(core_map[ID],core_map[0],TAG_MSG,(n_out_rows/nthreads+1)*ncols/factor);
        
      }
      else
      {
        //Wait for signal from main signal
        //gather_sig=tmc_udn2_receive();
        M.recv(core_map[ID],core_map[0],TAG_MSG);
        
        //Send the partial gx 
        //send126((uint_reg_t*)gx,(n_out_rows/nthreads)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);  
        M.send(core_map[ID],core_map[0],TAG_MSG,(n_out_rows/nthreads)*ncols/factor);
        
        //Send the partial gy 
        //send126((uint_reg_t*)gy,(n_out_rows/nthreads)*ncols/factor,core_map[0],UDN0_DEMUX_TAG); 
        M.send(core_map[ID],core_map[0],TAG_MSG,(n_out_rows/nthreads)*ncols/factor); 
      }
    }
    
    //Set end time
    //clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    //gather_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    gather_e=M.smp_clock_gettime(core_map[ID],&st);
    gather_d=gather_e-gather_s;
    
    
    total_e=M.smp_clock_gettime(core_map[ID],&st);
    total_d=total_e-total_s;
    
    printf("%lf\n",total_d);
    
    if(ID==0)
    printf("Scatter: %lf\nCompute: %lf\nGather: %lf\n",scatter_d,compute_d,gather_d);
    
    
    
    
    
    //---------------------------Log the data-----------------------------------
    log_memory[iterator*nthreads*9+ID*9+SCA_S]=scatter_s;
    log_memory[iterator*nthreads*9+ID*9+SCA_E]=scatter_e;
    log_memory[iterator*nthreads*9+ID*9+SCA_D]=scatter_d;
    
    log_memory[iterator*nthreads*9+ID*9+COMP_S]=compute_s;
    log_memory[iterator*nthreads*9+ID*9+COMP_E]=compute_e;
    log_memory[iterator*nthreads*9+ID*9+COMP_D]=compute_d;
    
    log_memory[iterator*nthreads*9+ID*9+GATH_S]=gather_s;
    log_memory[iterator*nthreads*9+ID*9+GATH_E]=gather_e;
    log_memory[iterator*nthreads*9+ID*9+GATH_D]=gather_d;
    
     
     
    
    
    
     
    //--------------------------------------------------------------------------
    //------------------------------End of benchmark----------------------------
    //--------------------------------------------------------------------------
  
  }
  
  //Free thread local memory
  //free(image);
  //free(gx);
  //free(gy);
  
  pthread_exit(NULL);
}





void *watchdog(void *arg)
{
  long int count=0;
  while(1)
  {
    if(count%5==0)
    {
      printf("running even now %ld sec.\n",count);
      system("touch watchdog_file");
    }
    count++;
    
    if(count>=100)
    {
      kill(getpid(),SIGKILL);
    }
    sleep(1);
  }
}




































