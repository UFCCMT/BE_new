/*

Topic:
--------
This file implements the SEND_N command available in the api.

Description:
--------------
Following is the format for the SEND_N command: SEND_N <destination> <no. of packets>
This is a non-blocking send. The send function writes the message into the shared buffer.
It also updates the log accordingly.

*/




#include<beo>
#include<data_structures>
#include<lookup>



void procBEO::send_n(int destination, int tag, int message_size)
{                 
   //Praeare packet
  p.source=ID;
  p.destination=destination;
  p.tag=tag;
  p.message_size=message_size;
  
  p.time=last_instr_end_t;
  
  p.clear_flag();
  
  
                 
  //Write packet to buffer
  b->write(&p,PROC_TO_COMM);
  
 
                     
  //Update event log
  last_instr_end_t+=lookup(LATENCY_P_TO_C,p.message_size,0); 
}

















