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
extern int n;
extern int E;
extern int iterations;



void finalize()
{
  int count, count1;
  
  //dump the log to a file
  printf("Opening log file to write the log data....\n");
  FILE *fp=fopen(logfile,"w");
  if(fp==NULL)
  {
    printf("Failed to open logfile. Quiting.\n");
    exit(EXIT_FAILURE);
  }
  
  for(count=0; count<nthreads-1; count++)
  {
    fprintf(fp,"Th %d BCAST_D,", count);
    fprintf(fp,"Th %d SCATTER_D,", count);
    fprintf(fp,"Th %d COMPUTE_D,", count);
	fprintf(fp,"Th %d XFER_D,", count);
    //fprintf(fp,"Th %d XFER1_D,", count);
    //fprintf(fp,"Th %d XFER2_D,", count);
    //fprintf(fp,"Th %d XFER3_D,", count);
    //fprintf(fp,"Th %d XFER4_D,", count);
    fprintf(fp,"Th %d TOT_D,", count);
  }
  fprintf(fp,"Th %d BCAST_D,", nthreads-1);
  fprintf(fp,"Th %d SCATTER_D,", nthreads-1);
  fprintf(fp,"Th %d COMPUTE_D,", nthreads-1);
  fprintf(fp,"Th %d XFER_D,", nthreads-1);
  //fprintf(fp,"Th %d XFER1_D,", nthreads-1);
  //fprintf(fp,"Th %d XFER2_D,", nthreads-1);
  //fprintf(fp,"Th %d XFER3_D,", nthreads-1);
  //fprintf(fp,"Th %d XFER4_D,", nthreads-1);
  fprintf(fp,"Th %d TOT_D\n", nthreads-1);
    

  for(count=0; count<iterations; count++)
  {
    for(count1=0; count1<nthreads*5-1; count1++)
      fprintf(fp,"%lf,",log_memory[count*nthreads*5+count1]);
    fprintf(fp,"%lf\n",log_memory[count*nthreads*5+nthreads*5-1]);
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
