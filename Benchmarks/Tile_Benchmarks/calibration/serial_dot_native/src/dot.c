#include<stdio.h>
#include<stdlib.h>
#include<tmc/cpus.h>
#include<tmc/udn.h>
#include<pthread.h>
#include<time.h>
#include<semaphore.h>
#include<unistd.h>

#define __REENTRANT


#define DATA_TYPE float



//Globals: Thread management
int NTHREADS;
int data_size;
int RUNS;
int *thread_id;
pthread_t *threads;


//The data
DATA_TYPE *main_vec1, *main_vec2, *result;


//Time measurement and data logging
char *filename;
double *time_logs;













//------------------------------------------------------------------------------
//-----------------------------Thread function----------------------------------
//------------------------------------------------------------------------------
void *thread_fn(void *args)
{
  int ID=(*((int*)args));
  
  
  //Local variables
  DATA_TYPE *vec1, *vec2, sum=0;
  long start,end;
  struct timespec st;
  int count, count1, count2;
  double time=0;
  
  //Set cpu 
  if(tmc_cpus_set_my_cpu(ID)!=0)
  {
    printf("CPU setting failed.\n");
    exit(1);
  }
  
  
  
  //Memory allocation
  vec1=(DATA_TYPE*)malloc(data_size*sizeof(DATA_TYPE));
  vec2=(DATA_TYPE*)malloc(data_size*sizeof(DATA_TYPE));
  
  
  
  //Initilize: copy over the vectors to thread local memory, to avoid contention
  for(count=0;count<data_size; count++)
  {
    vec1[count]=main_vec1[count];
    vec2[count]=main_vec2[count];
  } 
    

  
  //Actual dot product over RUNS iterations
  for(count2=0; count2<RUNS; count2++)
  {
    //Start time clock
    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &st);
    start = st.tv_sec*1e9+st.tv_nsec;
    
    //Average over a 1000 runs, to remove jitters
    for(count1=0; count1<100; count1++)
    {
      sum=0;
      for(count=0; count<data_size; count++)
        sum+=(vec1[count]*vec2[count]);
    }
    
    
    
    //End time clock
    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &st);
    end = st.tv_sec*1e9+st.tv_nsec;
    
    time=((double)(end-start))/100;
    
    //Record the time
    time_logs[count2*NTHREADS+ID]=time;
    
  }
  
  
  //Save the result
  result[ID]=sum/1000;
  
  
  pthread_exit(NULL);
  
}







//------------------------------------------------------------------------------
//--------------------------------Init function---------------------------------
//------------------------------------------------------------------------------

void init(int argc, char *argv[])
{
  //Parse command line args
  if(argc<4)
  {
    printf("Usage: ./dot_serial <vec_size> <nthreads> <iterations> <output_file>\n");
    exit(EXIT_FAILURE);
  }
  data_size=atoi(argv[1]);
  NTHREADS=atoi(argv[2]);
  RUNS=atoi(argv[3]);
  filename=argv[4];
  
  
  //Allocate memory
  main_vec1=(DATA_TYPE*)malloc(data_size*sizeof(DATA_TYPE));
  main_vec2=(DATA_TYPE*)malloc(data_size*sizeof(DATA_TYPE));
  result=(DATA_TYPE*)malloc(NTHREADS*sizeof(DATA_TYPE));
  time_logs=(double*)malloc(NTHREADS*RUNS*sizeof(double));
  
  
  if(main_vec1==NULL || main_vec2==NULL)
    printf("Failed to allocate memory\n");
  
  
  //Initialize the vectors
  int count;
  for(count=0; count<data_size; count++)
  {
    main_vec1[count]=rand()/RAND_MAX;
    main_vec2[count]=rand()/RAND_MAX;
  }
  
 
  //Create the threads
  thread_id=(int*)malloc(NTHREADS*sizeof(int));
  threads=(pthread_t*)malloc(NTHREADS*sizeof(pthread_t));
  for(count=0; count<NTHREADS; count++)
    thread_id[count]=count;
   
}



void finalize()
{
  int count,count1;
  free(main_vec1);
  free(main_vec2);
  free(result);
  FILE *log_dump=fopen(filename,"w");
  
  for(count=0; count<NTHREADS-1; count++)
    fprintf(log_dump,"Thread_%d,",count);
  fprintf(log_dump,"Thread_%d\n",NTHREADS-1);
  
  
  for(count=0; count<RUNS; count++)
  {
    for(count1=0; count1<NTHREADS-1; count1++)
      fprintf(log_dump,"%lf,",time_logs[count*NTHREADS+count1]);
    fprintf(log_dump,"%lf\n",time_logs[count*NTHREADS+NTHREADS-1]);
  }
  
  double temp=0;
  for(count=0; count<NTHREADS*RUNS;count++)
    temp+=(time_logs[count]/(NTHREADS*RUNS));
    
  printf("RUNTIME: %.8lf;r\n", temp/1e9);
  fclose(log_dump);
  free(time_logs);
 
}







void main(int argc, char *argv[])
{
  init(argc,argv);
  void *retval;
  int count;
  
  
  for(count=0; count<NTHREADS; count++)
    pthread_create(&threads[count],NULL,thread_fn,(void*)&thread_id[count]);
    
  
  for(count=0; count<NTHREADS; count++)
    pthread_join(threads[count],&retval);
  
  finalize();  
  //printf("%lf\n",t_exec/NTHREADS);
  
}









































