#include<header.h>
#include<stdlib.h>
#include<stdio.h>
#include<pthread.h>

//-----------------------------------Globals------------------------------------
//Time measurement and log management
//extern char *logfile;
extern double *log_memory;

//Program parameters
int nrows, ncols;
int iterations;

void init(int argc, char *argv[])
{
   //printf("Usage: ./sobel <nrows> <ncols> <iterations>\n");
  nrows=-1;
  ncols=-1;
  
  //Set up iterations
  nrows=atoi(argv[1]);
  ncols=atoi(argv[2]);
  iterations=atoi(argv[3]);
  
  //Initialize the log memory and open up the file
  //logfile=argv[4];
  //log_memory=(double*)malloc(sizeof(double)*nthreads*3*iterations);
  log_memory=(double*)malloc(sizeof(double)*iterations);
  //printf("Initialized..\n");
}




























