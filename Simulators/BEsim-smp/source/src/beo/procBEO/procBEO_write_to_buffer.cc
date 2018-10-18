/*

About:
------
procBEO write_to_buffer source

Description:
------------
This file basically defines the simple write to buffer function, for procBEOs

Notes:
------

*/


#include "beo"
#include "data_structures"

namespace smp
{
  int procBEO::write_to_buffer(message m)
  {
    //Obtain lock on buffer
    sem_wait(&buffer_access);
    
    int insert_val= b.insert(m);
    
    //Wake up thread if asleep
    if(is_paused==PAUSED)
    {
      is_paused=UNPAUSED;
      sem_post(&pause_resume);
    }
    //Release lock
    sem_post(&buffer_access);
    
    return insert_val;
  }
}
