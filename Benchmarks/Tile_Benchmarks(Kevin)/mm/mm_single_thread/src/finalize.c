#include<header.h>
#include<stdlib.h>
#include<stdio.h>

//-----------------------------------Globals------------------------------------
//Time measurement and log management
extern char *logfile;
extern double *log_memory;

//Program parameters
extern int M, N;
extern int iterations;

void finalize()
{
  int count;
  
  //dump the lof to a file
  //printf("Opening log file to write the log data....\n");
  FILE *fp=fopen(logfile,"w");
  if(fp==NULL){
    printf("Failed to open logfile. Quiting.\n");
    exit(EXIT_FAILURE);
  }
  
  //Print Header
  fprintf(fp,"Th 0 TOTAL_D\n");

  for(count=0; count<iterations; count++)
  {
    //Write to log file
	fprintf(fp,"%lf\n",log_memory[count]);
  }
  
  fclose(fp);

  //printf("Log written... freeing all allocated memories...\n");
  
  //printf("Finished..\n");
}
