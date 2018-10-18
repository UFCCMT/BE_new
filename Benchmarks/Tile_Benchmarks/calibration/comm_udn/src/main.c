#include<header.h>
#include<pthread.h>
#include<stdlib.h>
#include<time.h>
#include<stdio.h>


#define DATA_TYPE float


//-------------------------------Globals----------------------------------------
//Communication params
int MASTER; 
int SLAVE;
int NWORDS;
//int iterations;

//Thread management
pthread_t master, slave;


//Time management

struct timespec st;











//------------------------------------------------------------------------------
//------------------------------Main function-----------------------------------
//------------------------------------------------------------------------------
void main(int argc, char *argv[])
{
  /*struct timespec resolusion;
  clock_getres(CLOCK_THREAD_CPUTIME_ID,&resolusion);
  printf("Clock CLOCK_THREAD_CPUTIME_ID resolution: %d nsec\n",resolusion.tv_nsec);*/
  
  
  //Manipulate cpu set and create a hardwall
  cpu_set_t set;
  tmc_cpus_clear(&set);
  
  tmc_cpus_add_cpu(&set,0);
  tmc_cpus_add_cpu(&set,35);

  tmc_udn_init(&set);  
  
  void *retval;
  init(argc, argv);
  
  pthread_create(&master,NULL,thread_fn_master,NULL);
  pthread_create(&slave ,NULL,thread_fn_slave ,NULL);
  
  pthread_join(master,&retval);
  pthread_join(slave ,&retval);
  
  
  
}







