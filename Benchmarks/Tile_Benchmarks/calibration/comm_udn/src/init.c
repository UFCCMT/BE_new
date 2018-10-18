#include<stdlib.h>
#include<header.h>




//-------------------------------Globals----------------------------------------
//Communication params
extern int MASTER; 
extern int SLAVE;
extern int NWORDS;
//extern int iterations;

//Thread management
pthread_t master, slave;


//Time management
extern struct timespec st;








//------------------------------------------------------------------------------
//--------------------------------Init function---------------------------------
//------------------------------------------------------------------------------
void init(int argc, char *argv[])
{
  MASTER=0;
  SLAVE=1;
  NWORDS=1024;
  //iterations=1000;
  
  
  if(argc>1)  MASTER      = atoi(argv[1]);
  if(argc>2)  SLAVE       = atoi(argv[2]);
  if(argc>3)  NWORDS      = atoi(argv[3]);
  //if(argc>4)  iterations  = atoi(argv[4]);
  

}

