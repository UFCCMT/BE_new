#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<header.h>

//-----------------------------------Globals------------------------------------
//Time measurement and log management
//char *logfile;
double *log_memory;

//Program parameters
int nrows, ncols;
int iterations;

int main(int argc, char *argv[])
{
  //Manipulate cpu set and create a hardwall
  //printf("Setting CPUs and UDN...\n");
  cpu_set_t set;
  tmc_cpus_clear(&set);
  
  tmc_cpus_add_cpu(&set,0);
  tmc_cpus_add_cpu(&set,35);

  //tmc_udn_init(&set);  
  
  //Initialize
  init(argc,argv);
  
  void* ptr;
  thread_fn(ptr);
    
  free(log_memory);
}





