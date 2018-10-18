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
//extern char *logfile;
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
  int count, count1, count2, iterator;
  int row_count_A, col_count_B, el_count;
  DATA_TYPE temp_sum;
  DATA_TYPE weight[3][3] = {{ -1,  0,  1 },{ -2,  0,  2 },{ -1,  0,  1 }};
  
  //Thread memory initialization
  DATA_TYPE *image, *gx, *gy;
  int n_out_rows=nrows-2;

  image = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
  gx    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
  gy    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
    
  for(count=0; count<nrows; count++){
    for(count1=0; count1<ncols; count1++){
      image[count*ncols+count1]=count;
    }
  }

  //Time management variables
  double zero; //Reference time for iterations
  double compute_s,compute_e,compute_d,avg_runtime;
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
    
    //-------------------------------Sobel compute------------------------------
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  
    //Compute Gx
    int i,j;
	temp_sum=(DATA_TYPE)0;
	for(count=1; count<(n_out_rows); count++){
		for(count1=1; count1<(ncols-1); count1++){
			for(j=-1;j<=1;j++){
				for(i=-1; i<=1; i++){
					temp_sum+=weight[j+1][i+1] * image[(count+j)*ncols+count1+i];
				}
			}
			gx[(count-1)*ncols+count1]=temp_sum;
		}
	}

    //Compute Gy
    temp_sum=(DATA_TYPE)0;
    for(count1=1; count1<(ncols-1); count1++){
		for(count=1; count<(n_out_rows); count++){
			for(j=-1;j<=1;j++){
				for(i=-1; i<=1; i++){
					temp_sum+=weight[i+1][j+1] * image[(count+i)*ncols+count1+j];
				}
			}   
			gy[(count-1)*ncols+count1]=temp_sum;
		}
    }

    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    compute_d=compute_e-compute_s;
    
    //---------------------------Log the data-----------------------------------   
    //log_memory[iterator*nthreads*3+ID*3+COMP_S]=compute_s;
    //log_memory[iterator*nthreads*3+ID*3+COMP_E]=compute_e;

	log_memory[iterator]=compute_d;
  }
  
  int count_time;
	compute_d=0;
	for(count_time=0; count_time<iterations; count_time++){
		compute_d += log_memory[count_time];
	}

	avg_runtime = compute_d/(double)iterations/1000/1000;
	printf("RUNTIME: %.8f;r\n", avg_runtime);

	
  //Free thread local memory
  free(image);
  free(gx);
  free(gy);
  
}
































