#include<header.h>



//-----------------------------------Globals------------------------------------
//Thread management
int nthreads;
pthread_t *threads;
int *thread_id;
int *core_map;



//Time measurement and log management
char *logfile
double *log_memory



//Program parameters
int M;
int iterations;








//-----------------------------------Main function------------------------------
int main(int argc, char *argv)
{
  init(argc,argv);
  //Create threads
  //Join threads
  finalize(logfile);
}
