/*

About:
------
procBEO ISA send source

Description:
------------
This file contains the source for the send instruction belonging to a procBEO.
Its a blockinh send and here's how it works:
Step 1> Prepare the packet.
Step 2> Put the packet in the ordered queue.
Step 3> Poll the buffer for an ACK

Notes:
------

*/


#include "beo"
#include "interpolation"

namespace smp
{
  int procBEO::send(int destination, int tag, int message_size)
  {
    //Prepare packet
    m.source=ID;
    m.destination=destination;
    m.tag=tag;
    m.message_size=message_size;
    m.time=clock+interpolation(LATENCY_P_TO_C,message_size,0);
    m.bit_reset(MSG_ACK);
    m.bit_reset(BLOCK);
    
    //Dispatch packet
    while(q->insert(m)==FAILURE);
    
    //Wait for ACK
    while(true)
    {
      sem_wait(&buffer_access);
      if(b.read_ack(destination,&m)==SUCCESS)
      {
        sem_post(&buffer_access);
        break; 
      }
      else
      {
        is_paused=PAUSED;
        sem_post(&buffer_access);
        sem_wait(&pause_resume);
      }
    }
    
    //Update clock
    clock=m.time;
    
    return SUCCESS;
  }
}





