/*

Topic:
--------
This file implements the INIT command available in the api.

Description:
--------------
Following is the format for the INIT command: INIT <units> 
This command pretends to initialize a data of given size.
It also updates the log accordingly.

*/




#include<beo>
#include<data_structures>
#include<lookup>


#include<cstring>



void procBEO::init(int data_size)
{
  last_instr_end_t+=lookup(INIT_TIME,data_size,0);
}
