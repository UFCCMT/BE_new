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
extern int datasize;
extern int iterations;





void finalize()
{
  int count, count1;
  
  //dump the lof to a file
  FILE *fp=fopen(logfile,"w");
  if(fp==NULL)
  {
    printf("Failed to open logfile. Quiting.\n");
    exit(EXIT_FAILURE);
  }
  
  for(count=0; count<nthreads-1; count++)
  {
    fprintf(fp,"Th %d BCAST_S,", count);
    fprintf(fp,"Th %d BCAST_E,", count);
    fprintf(fp,"Th %d BCAST_D,", count);
  }
  fprintf(fp,"Th %d BCAST_S,", nthreads-1);
  fprintf(fp,"Th %d BCAST_E,", nthreads-1);
  fprintf(fp,"Th %d BCAST_D\n", nthreads-1);



  for(count=0; count<iterations; count++)
  {
    for(count1=0; count1<nthreads*3-1; count1++)
      fprintf(fp,"%lf,",log_memory[count*nthreads*3+count1]);
    fprintf(fp,"%lf\n",log_memory[count*nthreads*3+nthreads*3-1]);
  }
  fclose(fp);


  
  free(threads);
  free(thread_id);
  free(core_map);
  free(barrier_map);
  free(log_memory);
}
