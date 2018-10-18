// Matrix Multiply Single Thread
// Original Developer: Amartya
// Modified by: Kevin Cheng
//				cheng@hcs.ufl.edu

#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<header.h>

//-----------------------------------Globals------------------------------------
//Time measurement and log management
double *log_memory;

//Program parameters
int M, N;
int iterations;


int main(int argc, char *argv[])
{
  //printf("MM_Single_Thread starting benchmark.....\n");
  
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
  

  //finalize();
  free(log_memory);
}





