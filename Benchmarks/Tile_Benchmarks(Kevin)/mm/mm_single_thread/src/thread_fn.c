#include<header.h>
#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<sys/types.h>
#include<unistd.h>
#include<signal.h>

//#define DEBUG

//Time log management
//extern char *logfile;
extern double *log_memory;

//Program parameters
extern int M, N;
extern int iterations;




//*******************  Thread Function *****************************************
void *thread_fn(void *arg)
{
  
  //Necessary local variables
  int iterator;
  int row_count_A, col_count_B, el_count;
  DATA_TYPE temp_sum;
  double avg_runtime;

  //Thread memory initialization
  DATA_TYPE *A, *B, *C;
  int factor=sizeof(uint_reg_t)/sizeof(DATA_TYPE);
  
  A=(DATA_TYPE*)malloc(M*N*sizeof(DATA_TYPE));
  B=(DATA_TYPE*)malloc(N*N*sizeof(DATA_TYPE));
  C=(DATA_TYPE*)malloc(M*N*sizeof(DATA_TYPE));

#ifdef DEBUG
  printf("A[%d][%d] * B[%d][%d] = C[%d][%d]\n", M,N,N,N,M,N );
#endif
  
  //Time management variables
  double zero; //Reference time for iterations
  double start_time, end_time, total_time=0;
  struct timespec st;
  
  for(iterator=0; iterator<iterations; iterator++){ 
    
 	//Start time in us
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    start_time = ((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);
   
    //Compute matrix multiply 
    row_count_A=0;
    col_count_B=0;
    el_count=0;
    temp_sum=0;
    for(row_count_A=0; row_count_A<M; row_count_A++){
	  for(col_count_B=0; col_count_B<N; col_count_B++){
	    temp_sum = 0;
	    for(el_count=0; el_count<N; el_count++){
		  temp_sum += (A[row_count_A*N+el_count] * B[el_count*N+col_count_B]); //It is safe to assume column major arrangement for B
	    }
	    C[row_count_A*N+col_count_B] = temp_sum;
	  }
    }
  	//End time in us
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    end_time = ((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);

  	//Time difference	
	total_time = (end_time - start_time);

    //Log the data
	log_memory[iterator] = total_time;

#ifdef DEBUG
    printf("Iteration %d done\n",iterator);
#endif
  }
  
  int count;
  total_time=0;
  for(count=0; count<iterations; count++){
	total_time += log_memory[count];
  }
  
  avg_runtime = total_time/(double)iterations/1000/1000;
  printf("RUNTIME: %.8f;r\n", avg_runtime);

  
  //Free thread local memory
  free(A);
  free(B);
  free(C);
}


