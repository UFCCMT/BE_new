/*

About:
-------
Buffer data structure source file

Description:
------------
This file contains the source code for the buffer data structure.
This data structure stores data in whatever order and allows random 
access unlike ordered_q

Notes:
------

*/


#include "data_structures"
#include<semaphore.h>


namespace smp
{
  //------------------------Buffer insert---------------------------------------
  int buffer::insert(message m)
  {
    if(n_storage==BUFF_SIZE)
    {
      return FAILURE;
    }
    
    for(int count=0; count<BUFF_SIZE; count++)
    {
      if(valid[count]==INVALID)
      {
        storage[count]=m;
        valid[count]=VALID;
        n_storage++;
        return SUCCESS;
      }
    }
    
    return SUCCESS;
  }
  
  
  
  //--------------------Buffer read message function----------------------------
  int buffer::read_msg(int source, int tag, message *m)
  {
    for(int count=0; count<BUFF_SIZE; count++)
    {
      if(valid[count]==VALID && !storage[count].is_bit_set(MSG_ACK) && storage[count].source==source && storage[count].tag==tag)
      {
        *m=storage[count];
        valid[count]=INVALID;
        n_storage--;
        return SUCCESS;
      }
    }
    
    return FAILURE;
  }
  
  
  //--------------------Buffer read ack function--------------------------------
  int buffer::read_ack(int source, message *m)
  {
    for(int count=0; count<BUFF_SIZE; count++)
    {
      if(valid[count]==VALID && storage[count].source==source && storage[count].is_bit_set(MSG_ACK))
      {
        *m=storage[count];
        valid[count]=INVALID;
        n_storage--;
        return SUCCESS;
      }
    }
    
    return FAILURE;
  }
  
  
  
  //-----------------------Buffer display---------------------------------------
  void buffer::display()
  { 
    for(int count=0; count<BUFF_SIZE; count++)
    {
      if(valid[count]==VALID)
        std::cout<<"V "<<storage[count]<<"\n";
      else
        std::cout<<"I "<<storage[count]<<"\n";
    }
  }
}








