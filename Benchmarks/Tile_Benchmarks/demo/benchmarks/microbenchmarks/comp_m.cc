/*

A comp microbenchmark for the
simulator

*/



#define __REENTRANT
#include<cstdio>
#include<cstdlib>
#include<smp/mesh.h>


int datasize;
int times;

struct timespec st;
meshBEO M(6,6);






int main(int argc, char *argv[])
{
  if(argc!=3)
  {
    printf("Usage: comp <vsize> <times>\n");
    exit(1);
  }
  
  
  datasize=atoi(argv[1]);
  times=atoi(argv[2]);
  
  float time=M.smp_clock_gettime(0,&st);
  M.compute_m(0,1000,datasize);
  time=M.smp_clock_gettime(0,&st) - time;
  printf("Comput_m time for: %d (times %d) = %f\n",datasize,times, time/times);
}




