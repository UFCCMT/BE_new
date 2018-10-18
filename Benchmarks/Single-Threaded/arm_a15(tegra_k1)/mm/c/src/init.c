#include<header.h>
#include<stdlib.h>
#include<stdio.h>
#include<pthread.h>

//#define DEBUG

//-----------------------------------Globals------------------------------------
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
#ifdef DEBUG
  printf("Setting up benchmark iterations..\n");
#endif

  M=atoi(argv[1]);
  N=atoi(argv[2]);
  iterations= 8192 / M * 8192 / N / M + 1;
  if ((M >= 256) & (N >= 256)) iterations = 1000;
  //iterations=atoi(argv[3]);
  
  //Initialize the log memory and open up the file
#ifdef DEBUG
  printf("Creating memory for logs...\n");
#endif 
  //logfile=argv[4];
  log_memory=(double*)malloc(sizeof(double)*iterations);
  
#ifdef DEBUG
  printf("Initialized..\n");
#endif
}
