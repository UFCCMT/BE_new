/*

Topic:
--------
This file implements the COMPUTE command available in the api.

Description:
--------------
Following is the format for the COMPUTE command: COMPUTE <units> 
This command pretends to compute on a data of given size.
It also updates the log accordingly.

*/




#include<beo>
#include<data_structures>
#include<lookup>

#include<cstring>

#include<iostream>
#include<cstdlib>

void procBEO::compute(int size)
{
  //Update event log
  last_instr_end_t+=lookup(COMPUTE_TIME,size,0);
}






void procBEO::compute_m(int size, int num)
{
  //Update event log
  last_instr_end_t+=lookup(COMPUTE_TIME,size,0)*num;
}








