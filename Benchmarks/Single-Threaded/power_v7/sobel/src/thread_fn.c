#include<header.h>
#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>

#include<sys/types.h>
#include<unistd.h>
#include<signal.h>

extern double *log_memory;

int nrows, ncols;
int iterations;

void *thread_fn(void *arg)
{
  //Variable declarations
  int row, col, iterator;
  DATA_TYPE temp_sum;
  DATA_TYPE weight_x[3][3] = {{ -1,  0,  1 },{ -2,  0,  2 },{ -1,  0,  1 }};
  DATA_TYPE weight_y[3][3] = {{ -1,  -2,  -1 },{ 0,  0,  0 },{ 1,  2,  1 }};

  printf("....nrows=%d, ncols=%d, itrs=%d \n", nrows, ncols, iterations);
  
  DATA_TYPE *image, *gx, *gy;
  image = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
  gx    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
  gy    = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*nrows*ncols);
   
  srand(time(NULL)); 
  for(row=0; row<nrows; row++){
    for(col=0; col<ncols; col++){
      image[row*ncols+col]=rand()%20;
    }
  }

  for(row=0; row<nrows; row++){
    for(col=0; col<ncols; col++){
      printf("%d ", image[row*ncols+col]);
    }
    printf("\n");
  }


  //Time management variables
  double zero; //Reference time for iterations
  double compute_s,compute_e,compute_d,avg_runtime;
  struct timespec st;

  for(iterator=0; iterator<iterations; iterator++)
  {
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    zero=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;        
    
    //Set start time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_s=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;  

    //Compute Gx
    int i,j;
    temp_sum = (DATA_TYPE)0;
    for(row=1; row<(nrows-1); row++){
	for(col=1; col<(ncols-1); col++){
	    for(j=-1; j<=1; j++){
		for(i=-1; i<=1; i++){
		   temp_sum+=weight_x[j+1][i+1] * image[(row+j)*ncols+(col+i)];
		}
	    }
	    gx[(row)*ncols+col]=temp_sum;
	}
    }

    printf(".....gx.....\n");
    for(row=0; row<nrows; row++){
	for(col=0; col<ncols; col++){
            printf("%d ",gx[(row)*ncols+col]);
	}
	printf("\n");
    }

    //Compute Gy
    temp_sum = (DATA_TYPE)0;
    for(row=1; row<(nrows-1); row++){
	for(col=1; col<(ncols-1); col++){
	    for(j=-1; j<=1; j++){
		for(i=-1; i<=1; i++){
		   temp_sum+=weight_y[j+1][i+1] * image[(row+j)*ncols+(col+i)];
		}
	    }
	    gy[(row)*ncols+col]=temp_sum;
	}
    }

    printf(".....gy.....\n");
    for(row=0; row<nrows; row++){
	for(col=0; col<ncols; col++){
            printf("%d ",gy[(row)*ncols+col]);
	}
	printf("\n");
    }


    //Set end time
    clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
    compute_e=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;    
    compute_d=compute_e-compute_s;
    
/*	int rand_num;
	srand(time(NULL));
	rand_num = rand() % (sizeof(DATA_TYPE)*nrows*ncols);
	printf("gx(%d) = %d\n",rand_num,gx[rand_num]);
	printf("gy(%d) = %d\n",rand_num,gy[rand_num]);
*/	
	log_memory[iterator]=compute_d;
  }
  
  int count_time;
	compute_d=0;
	for(count_time=0; count_time<iterations; count_time++){
		compute_d += log_memory[count_time];
	}

	avg_runtime = compute_d/(double)iterations/1000/1000;
	printf("RUNTIME: %.8f;r\n", avg_runtime);

	
	FILE *fp;
	fp=fopen("log.csv","a");
	fprintf(fp,"%ix%i,%.8f\n",nrows,ncols,avg_runtime);
	fclose(fp);
	
  //Free thread local memory
  free(image);
  free(gx);
  free(gy);
  
}




