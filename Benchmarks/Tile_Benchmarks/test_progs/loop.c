#include<stdio.h>
#include<stdlib.h>
#include<time.h>

int main(int argc, char *argv[])
{
  int loop_iterations=atoi(argv[1]), fixed_count=1000, count, count1;
  double start, end, time=0;
  struct timespec st;
  
  for(count=0; count<loop_iterations; count++)
  {
    //Start time clock
    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &st);
    start = st.tv_sec*1e9+st.tv_nsec;
    
    for(count1=0; count1<1000; count1++);
    
    //End time clock
    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &st);
    end = st.tv_sec*1e9+st.tv_nsec;
    
    time=((double)(end-start));
    printf("Average time to run 1000 loops= %lf microseconds\n", time/1000);

  }
  
}
