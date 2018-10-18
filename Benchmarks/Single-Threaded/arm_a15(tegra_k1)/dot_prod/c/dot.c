#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<semaphore.h>
#include<unistd.h>

#define __REENTRANT

#define DATA_TYPE float

//The data
DATA_TYPE *main_vec1, *main_vec2;

int main(int argc, char *argv[])
{
  int RUNS, data_size;
  
  //Parse command line args
  if(argc<2)
  {
    printf("Usage: ./dot_serial <vec_size> [<nthreads>=1] [<iterations>=100] [<output_file>=log.csv]\n");
    exit(EXIT_FAILURE);
  }
  if(argc>=2)
    data_size=atoi(argv[1]);
  
    //Default valoos
  RUNS=83886080/data_size * 5;
  
  //Allocate memory
  main_vec1=(DATA_TYPE*)malloc(data_size*sizeof(DATA_TYPE));
  main_vec2=(DATA_TYPE*)malloc(data_size*sizeof(DATA_TYPE));

  if(main_vec1==NULL || main_vec2==NULL)
    printf("Failed to allocate memory\n");
  
  //Initialize the vectors
  int temp;
  for(temp=0; temp<data_size; temp++)
  {
    main_vec1[temp]=(DATA_TYPE)rand()/RAND_MAX;
    main_vec2[temp]=(DATA_TYPE)rand()/RAND_MAX;
  }
  
  //------------THREAD FUNCTION-----------------
  
  //Local variables
  DATA_TYPE sum=0;
  double start,end;
  struct timespec st;
  int count, count1;
  double time=0;
  
	//Start time clock
	clock_gettime(CLOCK_REALTIME, &st);
	start = st.tv_sec*1e9+st.tv_nsec;
	//start = ((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);

	//Average over a RUNS runs, to remove jitters
	for(count1=0; count1<RUNS; count1++)
	{
	  sum=0;
	  for(count=0; count<data_size; count++)
		sum+=(main_vec1[count]*main_vec2[count]);
	}
	
	//End time clock
	clock_gettime(CLOCK_REALTIME, &st);
	end = st.tv_sec*1e9+st.tv_nsec;
	//end = ((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3);

	//time=(end-start)/(double)RUNS/1000/1000;
	time=(end-start)/(double)RUNS/1000/1000/1000;
	
	printf("RUNTIME: %.8f;r\n", time);
  
  free(main_vec1);
  free(main_vec2); 

  return 0;
}


