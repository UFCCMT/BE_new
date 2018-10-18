#include<pthread.h>
#include<stdio.h>
#include<unistd.h>
#include<header.h>

//-----------------------------------Globals------------------------------------
//Thread management
int nthreads;
pthread_t *threads, watchdog_th;
int *thread_id;
int *core_map;
int *barrier_map;
int xmax,ymax;



//Time measurement and log management
char *logfile;
double *log_memory;



//Program parameters
int n;
int E;
int iterations;


int main(int argc, char *argv[])
{
//  printf("MM_UDN starting benchmark.....\n");
  
  //Manipulate cpu set and create a hardwall
  printf("Setting CPUs and UDN...\n");
  cpu_set_t set;
  tmc_cpus_clear(&set);
  
  tmc_cpus_add_cpu(&set,0);
  tmc_cpus_add_cpu(&set,35);

  tmc_udn_init(&set);  
  
  
  
  //Initialize
  init(argc,argv);
  #ifdef __DEBUG__
  display_state();
  #endif
  
  //Create threads
//  printf("Creating worker threads....\n");
  int count;
  for(count=0; count<nthreads; count++)
    pthread_create(&threads[count],NULL,thread_fn,(void*)(&thread_id[count]));
  
  //Start the watchdog thread
//  printf("Creating watchdog thread....\n");
  pthread_create(&watchdog_th,NULL,watchdog,NULL);
   
  //Wait for the worker threads to join 
  printf("Main thread waiting to join...\n"); 
  void *retval;
  for(count=0; count<nthreads; count++)
    pthread_join(threads[count],&retval);
    
  finalize();
}





