#include<header.h>
#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<sys/types.h>
#include<unistd.h>
#include<signal.h>

//-----------------------------------Globals------------------------------------
//Time measurement and log management
extern double *log_memory;

//Program parameters
extern int M, N;
extern int iterations;

//------------------------------------------------------------------------------
//--------------------------Thread function-------------------------------------
//------------------------------------------------------------------------------
void *thread_fn(void *arg)
{
  
  //Necessary local variables
  int iterator;
  int row_count_A, col_count_B, el_count;
  DATA_TYPE temp_sum;
  double total_time=0, avg_runtime=0;

  //Thread memory initialization
  DATA_TYPE *A, *B, *C;
  
  A=(DATA_TYPE*)malloc(M*N*sizeof(DATA_TYPE));
  B=(DATA_TYPE*)malloc(M*N*sizeof(DATA_TYPE));
  C=(DATA_TYPE*)malloc(M*N*sizeof(DATA_TYPE));
  
  //Time management variables
  double zero; //Reference time for iterations
  double total_time_s,total_time_e,total_time_d=0;
  struct timespec st;
  
  for(iterator=0; iterator<iterations; iterator++){ 
    //--------------------------------------------------------------------------
    //----------------------------Start of benchmark----------------------------
    //--------------------Do this shit over iteration times---------------------
    //--------------------------------------------------------------------------
	
    //-------------------------Set reference time ------------------------------
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    zero=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;        

    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    total_time_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);
   
    //---------------------------Compute---------------------------------------- 
    row_count_A=0;
    col_count_B=0;
    el_count=0;
    temp_sum=0;
    
  for(row_count_A=0; row_count_A<M; row_count_A++){
	for(col_count_B=0; col_count_B<M; col_count_B++){
	  temp_sum=0;
	  for(el_count=0; el_count<N; el_count++){
		//It is safe to assume column major arrangement for B
		temp_sum+=(A[row_count_A*N+el_count]*B[col_count_B*N+el_count]);
	  }
	  C[row_count_A*M+col_count_B]=temp_sum;
	}
  }
    
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    total_time_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);
    total_time_d=(total_time_e-total_time_s);

    //printf("Iteration %d done\n",iterator);
    
    //---------------------------Log the data-----------------------------------
	log_memory[iterator]=total_time_d;
	
    //--------------------------------------------------------------------------
    //------------------------------End of benchmark----------------------------
    //--------------------------------------------------------------------------
  
  }
  
  int count;
  for(count=0; count<iterations; count++){
	total_time += log_memory[count];
  }
  //Convert from us to s
  avg_runtime = total_time/iterations/1000/1000;
  printf("RUNTIME: %.8f;r\n", avg_runtime);
  
  
  //Free thread local memory
  free(A);
  //free(B);
  //free(C);
  
}


