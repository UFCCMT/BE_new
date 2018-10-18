/*

About:
------
Interpolation  function source

Description:
------------
This  file contains the source  of the interpolation  function.

Notes:
------
1) This is the linear interpolator as of  now. I  you want Dylan's stupid python
script to interface, pipe the script function call into this function and obtain 
a speedup o  -10. Good luck.

*/


#include "interpolation"

namespace smp
{
  //----------------Table  or latency  or communication-------------------------
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


  TIME_TYPE latency[]={
  0.0 ,
  381.0 ,
  560.0 ,
  792.0 ,
  1246.0 ,
  2200.0 ,
  4102.0 ,
  8323.0 ,
  16163.0 ,
  31909.0 ,
  64050.0 ,
  127924.0 ,
  255242.0 ,
  509618.0 ,
  1019905.0 ,
  2040060.0 ,
  4077260.0 ,
  8166810.0 ,
  16385468.0 ,
  33330479.0 };
  
  TIME_TYPE TPH=1;
  
  //------------------------Table  or computes----------------------------------
  int NCOMP[]={0,8,16,32,64,128,256,512,1024};
  TIME_TYPE c_time[]={0,483, 924, 1807, 3574, 7122, 14252, 28452, 56890};
  
  
  
  //-----------------------Interpolation function-------------------------------
  float interpolation(int type, int arg1, int arg2)
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
                                  
      case COMPUTE_M_TIME       : for(int count=0; count<NCOMPDATA; count++)
                                  {
                                    if(NCOMP[count]>=arg1)
                                      return arg2*((c_time[count]-c_time[count-1])*(arg1-NCOMP[count-1])/(NCOMP[count]-NCOMP[count-1])+c_time[count-1])+18.089*arg2+964.35;
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
}










