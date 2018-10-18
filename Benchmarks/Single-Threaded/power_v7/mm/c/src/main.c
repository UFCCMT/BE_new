// Matrix Multiply Single Thread
// Original Developer: Amartya
// Modified by: Kevin Cheng
//				cheng@hcs.ufl.edu

#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<header.h>

double *log_memory;

//Program parameters
int M, N;
int iterations;

int main(int argc, char *argv[])
{

  //Initialize
  init(argc,argv);
  
  //Start Benchmark
  void* ptr;
  thread_fn(ptr);
  
  free(log_memory);
}





