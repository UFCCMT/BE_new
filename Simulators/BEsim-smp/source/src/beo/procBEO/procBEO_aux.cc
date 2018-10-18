/*

About:
------
Aux functions source.

Description:
------------
This file contains the source for the procBEO auxiliary functions.

Notes:
------

*/

#include "beo"

namespace smp
{
  TIME_TYPE procBEO::smp_gettime()
  {
    return clock;
  }
}
