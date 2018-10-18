#include<header.h>
#include<stdlib.h>
#include<stdio.h>



//-----------------------------------Globals------------------------------------
//Thread management
extern int nthreads;
extern pthread_t *threads;
extern int *thread_id;
extern int *core_map;
extern int *barrier_map;



//Time measurement and log management
extern char *logfile;
extern double *log_memory;



//Program parameters
int nrows, ncols;
int iterations;





void finalize()
{
  int count, count1;
  
  //dump the lof to a file
  printf("Opening log file to write the log data....\n");
  FILE *fp=fopen(logfile,"w");
  if(fp==NULL)
  {
    printf("Failed to open logfile. Quiting.\n");
    exit(EXIT_FAILURE);
  }
  
  for(count=0; count<nthreads-1; count++)
  {
    fprintf(fp,"Th %d BARRIER1_D,", count);
	fprintf(fp,"Th %d SCATTER_D,", count);
    fprintf(fp,"Th %d BARRIER2_D,", count);
	fprintf(fp,"Th %d COMPUTEGX_D,", count);
    fprintf(fp,"Th %d COMPUTEGY_D,", count);
    fprintf(fp,"Th %d BARRIER3_D,", count);
    fprintf(fp,"Th %d GATHER_D,", count);
	fprintf(fp,"Th %d BARRIER4_D,", count);
  }
  
  fprintf(fp,"Th %d BARRIER1_D,", nthreads-1);
  fprintf(fp,"Th %d SCATTER_D,", nthreads-1);
  fprintf(fp,"Th %d BARRIER2_D,", nthreads-1);
  fprintf(fp,"Th %d COMPUTEGX_D,", nthreads-1);
  fprintf(fp,"Th %d COMPUTEGY_D,", nthreads-1);
  fprintf(fp,"Th %d BARRIER3_D,", nthreads-1);
  fprintf(fp,"Th %d GATHER_D,", nthreads-1);
  fprintf(fp,"Th %d BARRIER4_D\n", nthreads-1);



  for(count=0; count<iterations; count++)
  {
    for(count1=0; count1<nthreads*8-1; count1++)
      fprintf(fp,"%lf,",log_memory[count*nthreads*8+count1]);
    fprintf(fp,"%lf\n",log_memory[count*nthreads*8+nthreads*8-1]);
  }
  fclose(fp);


  printf("Log written... freeing all allocated memories...\n");
  free(threads);
  free(thread_id);
  free(core_map);
  free(barrier_map);
  free(log_memory);
  printf("Finished..\n");
}
