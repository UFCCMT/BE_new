#include<pthread.h>
#include<stdio.h>
#include<unistd.h>
#include<header.h>

//-----------------------------------Globals------------------------------------
//Thread management
int nthreads;
pthread_t *threads;
int *thread_id;
int *core_map;
int *barrier_map;
int xmax,ymax;



//Time measurement and log management
char *logfile;
double *log_memory;



//Program parameters
int datasize;
int iterations;


int main(int argc, char *argv[])
{
  //Manipulate cpu set and create a hardwall
  cpu_set_t set;
  tmc_cpus_clear(&set);
  
  tmc_cpus_add_cpu(&set,0);
  tmc_cpus_add_cpu(&set,35);

  tmc_udn_init(&set);  
  
  
  
  //Initialize
  init(argc,argv);
  display_state();
  
  //Create threads
  int count;
  for(count=0; count<nthreads; count++)
    pthread_create(&threads[count],NULL,thread_fn,(void*)(&thread_id[count]));
    
  void *retval;
  for(count=0; count<nthreads; count++)
    pthread_join(threads[count],&retval);
    
  finalize();
}





