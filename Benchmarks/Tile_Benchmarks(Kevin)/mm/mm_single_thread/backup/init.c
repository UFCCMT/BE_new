#include<header.h>
#include<stdlib.h>
#include<stdio.h>
#include<pthread.h>

//-----------------------------------Globals------------------------------------
//Time measurement and log management
extern double *log_memory;

//Program parameters
extern int M, N;
extern int iterations;

void init(int argc, char *argv[])
{
  if(argc<2)
  {
    printf("Usage: ./mm_sparse <M> <N> <iterations> <logfile>\n");
    exit(EXIT_FAILURE);
  }

  //Set up iterations
  //printf("Setting up no. of benchmark iterations..\n");
  M=atoi(argv[1]);
  N=atoi(argv[2]);
  iterations= 8192 / M * 8192 / N / M + 1;
  
  //Initialize the log memory and open up the file
  log_memory=(double*)malloc(sizeof(double)*iterations);
  
  //printf("Initialized..\n");
}
