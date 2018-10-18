/*

Topic:
--------
This file implements the clock_gettime command available in the api.

Description:
--------------
This just returns the stupid clock value at this time

*/




#include<beo>
#include<data_structures>
#include<lookup>

float procBEO::clock_gettime()
{
  return last_instr_end_t;
}
