/*

A comp microbenchmark for the
simulator

*/



#define __REENTRANT
#include<cstdio>
#include<cstdlib>
#include<smp/mesh.h>


int datasize;
struct timespec st;
meshBEO M(6,6);






int main(int argc, char *argv[])
{
  if(argc!=2)
  {
    printf("Usage: comp <vsize>\n");
    exit(1);
  }
  
  
  datasize=atoi(argv[1]);
  
  float time=M.smp_clock_gettime(0,&st);
  M.compute(0,datasize);
  time=M.smp_clock_gettime(0,&st) - time;
  printf("Comput time for: %d = %f\n",datasize,time);
}




