#include<stdio.h>
#include<time.h>
#include<stdlib.h>

int main(int argc, char *argv[])
{
  int loop_count=atoi(argv[1]), iterations=atoi(argv[2]), count, count1, x;
  struct timespec st;
  double start, end,time=0;
  
  
  for(count=0;count<iterations; count++)
  {
    //Start time clock
    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &st);
    //clock_gettime(CLOCK_REALTIME, &st);
    start = st.tv_sec*1e6+st.tv_nsec*1e-3;
    
    for(count1=0;count1<loop_count; count1++)
    {
      x=4;
    }
  
    //End time clock
    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &st);
    //clock_gettime(CLOCK_REALTIME, &st);
    end = st.tv_sec*1e6+st.tv_nsec*1e-3;
    
    time+=(end-start);
  }
  printf("%lf \n",(time/iterations));
}
