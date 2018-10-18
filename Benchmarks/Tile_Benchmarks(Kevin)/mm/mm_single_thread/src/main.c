// Matrix Multiply Single Thread
// Original Developer: Amartya
// Modified by: Kevin Cheng
//				cheng@hcs.ufl.edu

#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<header.h>

#define TILEGX36

double *log_memory;

//Program parameters
int M, N;
int iterations;

int main(int argc, char *argv[])
{

#if TILEGX36  
  //Manipulate cpu set and create a hardwall
  //printf("Setting CPUs and UDN...\n");
  cpu_set_t set;
  tmc_cpus_clear(&set);
  tmc_cpus_add_cpu(&set,0);
  tmc_cpus_add_cpu(&set,35);
#endif

  //Initialize
  init(argc,argv);
  
  //Start Benchmark
  void* ptr;
  thread_fn(ptr);
  
  free(log_memory);
}





