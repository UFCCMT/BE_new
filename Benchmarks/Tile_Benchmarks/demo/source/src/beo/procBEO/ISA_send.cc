/*

Topic:
--------
This file implements the SEND command available in the api.

Description:
--------------
Following is the format for the SEND command: SEND <destination> <no. of packets>
This is a blocking send. The send function writes the message into the shared buffer,
and waits for the acknowledgement. It also updates the log accordingly.

*/




#include<beo>
#include<data_structures>
#include<lookup>









void procBEO::send(int destination, int tag, int message_size)
{                
  //Praeare packet
  p.source=ID;
  p.destination=destination;
  p.tag=tag;
  p.message_size=message_size;
  
  p.time=last_instr_end_t;
  
  p.clear_flag();
  p.set_property(FLAG_BLOCKING);
  
  
  
                 
  //Write packet to buffer
  b->write(&p,PROC_TO_COMM);
    
  //Wait for ACK
  p.source=p.destination;
  p.tag=TAG_ACK;
  p.destination=ID;
  
  
  while(1)
  {
    if(b->read(&p,COMM_TO_PROC)==0)
    break;
  }
                    
                
  //Update event log
  last_instr_end_t=p.time+lookup(LATENCY_C_TO_P,message_size,0);
}
