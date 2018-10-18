/*

About:
------
Compute instruction source

Description:
------------
This file contains the source for the compute instruction.
This operates by increasing the clock according to the interpolation.

Notes:
------

*/


#include "beo"
#include "interpolation"

namespace smp
{
  int procBEO::compute(int size)
  {
    //Update clock
    clock+=interpolation(COMPUTE_TIME,size,0);
    return SUCCESS;
  }
  
  int procBEO::compute_m(int size, int ncompute)
  {
    //Update clock
    clock+=interpolation(COMPUTE_M_TIME,size,ncompute);
    return SUCCESS;
  }
}
