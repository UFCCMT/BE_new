#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<header.h>

double *log_memory;
int nrows, ncols;
int iterations;


void init(int argc, char *argv[])
{
  nrows=-1;
  ncols=-1;
  
  nrows=atoi(argv[1]);
  ncols=atoi(argv[2]);
  iterations=atoi(argv[3]);
  
  printf("Usage: ./sobel <nrows> <ncols> <iterations>\n");
  log_memory=(double*)malloc(sizeof(double)*iterations);
}

 
int main(int argc, char *argv[])
{
  init(argc,argv);

  void* ptr;
  thread_fn(ptr);
    
  free(log_memory);
}





