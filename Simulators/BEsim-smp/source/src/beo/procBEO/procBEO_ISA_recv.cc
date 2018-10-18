/*

About:
------
procBEO ISA recv source

Description:
------------
This file contains the source for the recv instruction belonging to a procBEO.
Its a blocking recv and here's how it works:
Step 1> poll the buffer until u find the crap
Step 2> Update clock
Step 2> Depending on if its a blocking/non blocking send, send an ACK back.

Notes:
------

*/


#include "beo"
#include "data_structures"
#include "interpolation"


namespace smp
{
  int procBEO::recv(int source, int tag)
  {
    message m;
    
    //Step 1: poll
    while(true)
    {
      //Obtain buffer lock
      sem_wait(&buffer_access);
      
      //Read stuff
      if(b.read_msg(source,tag,&m)==SUCCESS) //Release semaphore and break on success
      {
        sem_post(&buffer_access);
        break;
      }
      else //Release semaphore and go to sleep otherwise
      {
        is_paused=PAUSED;
        sem_post(&buffer_access);
        sem_wait(&pause_resume);
      }
    }
    
    //Step 2: Update clock
    if(m.time>clock)
      clock=m.time;
      
    //Step 3: Send back ACK if needed
    if(!m.is_bit_set(BLOCK))
    {
      m.source=ID;
      m.destination=source;
      m.tag=0;
      m.time=clock+smp::interpolation(LATENCY_P_TO_C,1,0);
      m.bit_set(MSG_ACK);
      while(q->insert(m)==FAILURE);
      
      clock=m.time;
    }
    
    return SUCCESS;
  }
}





