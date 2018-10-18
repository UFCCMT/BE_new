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
int nrows, ncols;
int iterations;













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
  DATA_TYPE weight[3][3] = {{ -1,  0,  1 },{ -2,  0,  2 },{ -1,  0,  1 }};
  
  
  //Set cpu and activate udn
  if(tmc_cpus_set_my_cpu(core_map[ID])!=0)
  {
    printf("Thread: %d CPU setting failed.\n",ID);
    exit(1);
  }
  tmc_udn_activate();
  
  
  
  //Thread memory initialization
  DATA_TYPE *image, *gx, *gy;
  int n_out_rows=nrows-2;
  int factor=sizeof(uint_reg_t)/sizeof(DATA_TYPE);
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
  
  
  
  //calculate x and y co-ordinates
  int x=ID%(xmax+1);
  int y=ID/(xmax+1);



  //Time management variables
  double zero; //Reference time for iterations
  double scatter_s, scatter_e, scatter_d, computeGx_s, computeGx_e, computeGx_d, computeGy_s, computeGy_e, computeGy_d, gather_s, gather_e, gather_d,total_s,total_e,total_d;
  double barrier1_s, barrier2_s, barrier3_s, barrier4_s, barrier1_e, barrier2_e, barrier3_e, barrier4_e, barrier1_d, barrier2_d, barrier3_d, barrier4_d;
  struct timespec st;
  
  
  
  
  
  
  
  
  
  
  
  
  for(iterator=0; iterator<iterations; iterator++)
  {
    
    //--------------------------------------------------------------------------
    //----------------------------Start of benchmark----------------------------
    //--------------------Do this shit over iteration times---------------------
    //--------------------------------------------------------------------------
	//Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier1_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3); 
	
	barrier(ID);
	
	 //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier1_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);    
    barrier1_d=barrier1_e-barrier1_s;
  
    
    //-------------------------Set reference time ------------------------------
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    zero=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;        
    
    
    
    //clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    //total_s=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;  
   
    
    
    //------------------------Step 1: Naive scatter-----------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    scatter_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    if(ID==0)
    {
      printf("n_out_rows = %i\n",n_out_rows);
	  printf("factor = %i\n",factor);
	  start_addr=((n_out_rows%nthreads==0)?(n_out_rows/nthreads+1):(n_out_rows/nthreads+1+1));
    
      for(count=1; count<nthreads; count++)
      {
        if(count<n_out_rows%nthreads)
        {
          send126((uint_reg_t*)(&image[(start_addr-1)*ncols]),(n_out_rows/nthreads+1+1+1)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);          
          start_addr+=n_out_rows/nthreads+1;
		  printf("scatter %d ID %d\n",(n_out_rows/nthreads+1+1+1)*ncols/factor,ID);
        }
        else
        {
          send126((uint_reg_t*)(&image[(start_addr-1)*ncols]),(n_out_rows/nthreads+1+1)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);
          start_addr+=n_out_rows/nthreads;
		  printf("scatter %d ID %d\n",(n_out_rows/nthreads+1+1)*ncols/factor,ID);
        }
      }
    }
    else
    {
      if(ID<n_out_rows%nthreads)
      {
        receive126((uint_reg_t*)image,(n_out_rows/nthreads+1+2)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);
      }
      else
      {
        receive126((uint_reg_t*)image,(n_out_rows/nthreads+2)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);
      }
    }
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    scatter_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    scatter_d=scatter_e-scatter_s;
    
    
    
    
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier2_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3); 
	
	barrier(ID);
	
	 //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier2_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);    
    barrier2_d=barrier2_e-barrier2_s;
    
    
    
    //-------------------------------Sobel compute------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    computeGx_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    //Compute Gx
    int i,j;
    if(ID<n_out_rows%nthreads)
    {
      temp_sum=(DATA_TYPE)0;
      for(count=1; count<(n_out_rows/nthreads+1+2-1); count++)
      {
        for(count1=1; count1<(ncols-1); count1++)
        {
          for(j=-1;j<=1;j++)
          {
            for(i=-1; i<=1; i++)
            {
              temp_sum+=weight[j + 1][i + 1] * image[(count+j)*ncols + count1 + i];
            }
          }
          
          gx[(count-1)*ncols+count1]=temp_sum;
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
          for(j=-1;j<=1;j++)
          {
            for(i=-1; i<=1; i++)
            {
              temp_sum+=weight[j + 1][i + 1] * image[(count+j)*ncols + count1 + i];
            }
          }
          
          gx[(count-1)*ncols+count2]=temp_sum;
        }
      }
    }
    
	//Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    computeGx_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    computeGx_d=computeGx_e-computeGx_s;
    
	
	//Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    computeGy_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
	
	
    //Compute Gy
    if(ID<n_out_rows%nthreads)
    {
      temp_sum=(DATA_TYPE)0;
      for(count1=1; count1<(ncols-1); count1++)
      {
        for(count=1; count<(n_out_rows/nthreads+1+2-1); count++)
        {
          for(j=-1;j<=1;j++)
          {
            for(i=-1; i<=1; i++)
            {
              temp_sum+=weight[i + 1][j + 1] * image[(count+i)*ncols + count1 + j];
            }
          }
          
          gy[(count-1)*ncols+count1]=temp_sum;
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
          for(j=-1;j<=1;j++)
          {
            for(i=-1; i<=1; i++)
            {
              temp_sum+=weight[i + 1][j + 1] * image[(count+i)*ncols + count1 + j];
            }
          }
          
          gy[(count-1)*ncols+count2]=temp_sum;
        }
      }
    }
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    computeGy_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    computeGy_d=computeGy_e-computeGy_s;
    
    
    
    
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier3_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3); 
	
	barrier(ID);
	
	 //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier3_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);    
    barrier3_d=barrier3_e-barrier3_s;
    
    
    
    //---------------------------Gather-----------------------------------------
    
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    gather_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    
    
    
    if(ID==0)
    {
      start_addr=1;
     
      for(count=1; count<nthreads; count++)
      {
        if(count<n_out_rows%nthreads)
        {
          //Send a signal to a certain waiting thread
          DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          
          //Collect Gx from that thread
          receive126((uint_reg_t*)(&gx[start_addr*ncols]),(n_out_rows/nthreads+1)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);  
          
          //Collect Gy from that thread
          receive126((uint_reg_t*)(&gy[start_addr*ncols]),(n_out_rows/nthreads+1)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);  
                  
          start_addr+=(n_out_rows/nthreads+1);
        }
        else
        {
          //Send a signal to a certain waiting thread
          DynamicHeader header= tmc_udn_header_from_cpu(core_map[count]);
          tmc_udn_send_1(header,UDN2_DEMUX_TAG,gather_sig);
          
          //Collect Gx from that thread
          receive126((uint_reg_t*)(&gx[start_addr*ncols]),(n_out_rows/nthreads)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);  
          
          //Collect Gy from that thread
          receive126((uint_reg_t*)(&gy[start_addr*ncols]),(n_out_rows/nthreads)*ncols/factor,core_map[count],UDN0_DEMUX_TAG);  
                  
          start_addr+=(n_out_rows/nthreads);
        }
      }
    }
    else
    {
      if(ID<n_out_rows%nthreads)
      {
        //Wait for signal from main signal
        gather_sig=tmc_udn2_receive();
        
        //Send the partial gx 
        send126((uint_reg_t*)gx,(n_out_rows/nthreads+1)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);  
        
        
        //Send the partial gy 
        send126((uint_reg_t*)gy,(n_out_rows/nthreads+1)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);  
        
      }
      else
      {
        //Wait for signal from main signal
        gather_sig=tmc_udn2_receive();
        
        //Send the partial gx 
        send126((uint_reg_t*)gx,(n_out_rows/nthreads)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);  
        
        
        //Send the partial gy 
        send126((uint_reg_t*)gy,(n_out_rows/nthreads)*ncols/factor,core_map[0],UDN0_DEMUX_TAG);  
      }
    }
    
    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    gather_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    gather_d=gather_e-gather_s;
    
    
    
    //clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    //total_e=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;  
    //total_d+=(total_e-total_s);
    
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier4_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3); 
	
	barrier(ID);
	
	 //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    barrier4_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);    
    barrier4_d=barrier4_e-barrier4_s;
    
    barrier(ID);
    
    //---------------------------Log the data-----------------------------------
	log_memory[iterator*nthreads*8+ID*8+BAR1_D]=barrier1_d;
	
    log_memory[iterator*nthreads*8+ID*8+SCA_D]=scatter_d;
	
	log_memory[iterator*nthreads*8+ID*8+BAR2_D]=barrier2_d;

    log_memory[iterator*nthreads*8+ID*8+COMPGX_D]=computeGx_d;
	
    log_memory[iterator*nthreads*8+ID*8+COMPGY_D]=computeGy_d;
	
	log_memory[iterator*nthreads*8+ID*8+BAR3_D]=barrier3_d;
    
    log_memory[iterator*nthreads*8+ID*8+GATH_D]=gather_d;
    
    log_memory[iterator*nthreads*8+ID*8+BAR4_D]=barrier4_d;
     
    //---------------------Barrier----------------------------------------------
   
    
    
    if(ID==0)
      printf("Iteration: %d\n",iterator);
    
    
     
    //--------------------------------------------------------------------------
    //------------------------------End of benchmark----------------------------
    //--------------------------------------------------------------------------
  
  }
  
  //Print total time
  printf("%lf\n",total_d/iterations);
  
  //Free thread local memory
  free(image);
  free(gx);
  free(gy);
  
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
    
    if(count>=100)
    {
      kill(getpid(),SIGKILL);
    }
    sleep(1);
  }
}




































