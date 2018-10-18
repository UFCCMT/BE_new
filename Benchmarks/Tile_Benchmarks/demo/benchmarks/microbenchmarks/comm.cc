/*

A comm microbenchmark for the
simulator

*/



#define __REENTRANT
#include<cstdio>
#include<cstdlib>
#include<smp/mesh.h>

int master;
int slave;
int datasize;
struct timespec st;
meshBEO M(6,6);




//Master thread
void *thread1_fn(void *arg)
{
  float time=M.smp_clock_gettime(master,&st);
  M.send(master,slave,TAG_MSG,datasize);
  time=M.smp_clock_gettime(master,&st) - time;
  printf("RTT for datasize: %d = %f\n",datasize,time);
}


//Smave thread
void *thread2_fn(void *arg)
{
  M.recv(slave,master,TAG_MSG);
}


int main(int argc, char *argv[])
{
  if(argc!=4)
  {
    printf("Usage: comm <master> <slave> <datasize>\n");
    exit(1);
  }
  
  master=atoi(argv[1]);
  slave=atoi(argv[2]);
  datasize=atoi(argv[3]);
  
  pthread_t thread1, thread2;
  pthread_create(&thread1,NULL,thread1_fn,NULL);
  pthread_create(&thread2,NULL,thread2_fn,NULL);
  void *retval;
  pthread_join(thread1,&retval);
  pthread_join(thread2,&retval);
}




