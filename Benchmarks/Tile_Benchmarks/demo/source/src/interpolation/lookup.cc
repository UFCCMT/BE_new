/*

Topic: 
--------------
Lookup function.

Description:
-----------------
This file contains the lookup function. This function implements the lookup capabilities of the BEOs.
This function takes as arguements, categories of events, and size parameters if needed.
Then it returns the calculated time for that event, using a lookup table and interpolation functions.

*/


#include<lookup>


//Latency tabulated

#define NDATA 20
int NLAT[]={
0,
1,
4,
8,
16,
32,
64,
128,
256,
512,
1024,
2048,
4096,


8192,
16384,
32768,
65536,
131072,
262144,
524288};


float latency[]={
0.0f,
381.0f,
560.0f,
792.0f,
1246.0f,
2200.0f,
4102.0f,
8323.0f,
16163.0f,
31909.0f,
64050.0f,
127924.0f,
255242.0f,



509618.0f,
1019905.0f,
2040060.0f,
4077260.0f,
8166810.0f,
16385468.0f,

33330479.0f};


//Computation tabulated
#define NCOMPDATA 9
int NCOMP[]={0,8,16,32,64,128,256,512,1024};
float c_time[]={0,483, 924, 1807, 3574, 7122, 14252, 28452, 56890};



float TPH=1;



float lookup(int type, int arg1, int arg2)
{
  switch(type)
  {
    case PER_HOP_TIME         : return TPH;
    case MSG_PROCESSING_TIME_P: return (float)(LATENCY_P_TO_C*arg1);
    case MSG_PROCESSING_TIME_C: return 1*(float)arg1;
    
    
    //Linear interpolator for compute
    case COMPUTE_TIME         : for(int count=0; count<NCOMPDATA; count++)
                                {
                                  if(NCOMP[count]>=arg1)
                                    return ((c_time[count]-c_time[count-1])*(arg1-NCOMP[count-1])/(NCOMP[count]-NCOMP[count-1])+c_time[count-1]);
                                }
    case INIT_TIME            : return 10.38*(float)arg1;
    
    
    //Linear interpolator for latency
    case LATENCY_P_TO_C       : for(int count=1; count<NDATA; count++)
                                {
                                  if(NLAT[count]>=arg1)
                                    return ((latency[count]-latency[count-1])*(arg1-NLAT[count-1])/(NLAT[count]-NLAT[count-1]) + latency[count-1]);
                                }
                                
    case LATENCY_C_TO_P       : return 0;
    default                   : return -1;
  }
}







