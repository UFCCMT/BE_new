/*

About:
------
procBEO ISA non blocking send source

Description:
------------
This file contains the source for the send instruction belonging to a procBEO.
Its a non blocking send and here's how it works:
Step 1> Prepare the packet.
Step 2> Put the packet in the ordered queue.
Step 3> Move on

Notes:
------

*/


#include "beo"
#include "interpolation"

namespace smp
{
  int procBEO::send_n(int destination, int tag, int message_size)
  {
    //Prepare packet
    m.source=ID;
    m.destination=destination;
    m.tag=tag;
    m.message_size=message_size;
    m.time=clock+interpolation(LATENCY_P_TO_C,message_size,0);
    m.bit_reset(MSG_ACK);
    m.bit_set(BLOCK);
    
    //Dispatch packet
    while(q->insert(m)==FAILURE);
    
    //Update clock
    clock=m.time;
    
    return SUCCESS;
  }
}





