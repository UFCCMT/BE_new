/*

Topic:
-------- 
This file implements the RECV command available in the api.

Description:
-------------
Following is the format for the RECV command: RECV <source>
The recv command is a blocking recv. It waits on the shared buffer for the packet to arrive, 
and then depending on if it is a blocking or non blocking send, it sends back an ACK or nothing.

*/



#include<beo>
#include<data_structures>
#include<lookup>





void procBEO::recv(int source, int tag)
{
  //Temporary variable maybe used in different places
  float temp;

  
  //Wait for message
  p.source=source;
  p.tag=tag;
  
  while(1)
  {
    if(b->read(&p,COMM_TO_PROC)==0)
      break;
  }
  
  
  
  
  
  //Add latency to packet time
  p.time+=lookup(LATENCY_C_TO_P,0,0);
  p.time+=(p.message_size-1) ;
   
        
  //Update event log
  temp=p.time;
  
  
  if(temp<last_instr_end_t)
    temp=last_instr_end_t;

  
                                       
  //Send ACK if needed
  if((p.flag & (FLAG_TYPE)(FLAG_BLOCKING))>(FLAG_TYPE)0)
  {
    p.destination=p.source;
    p.source=ID;
    p.tag=TAG_ACK;
    p.source=ID;
    p.message_size=1;
    p.time=temp;
    
    p.clear_flag();
    
    b->write(&p,PROC_TO_COMM);
    temp+=lookup(LATENCY_P_TO_C,1,0);
  }     
  
  
  //Write log
  last_instr_end_t=temp;   
 
}


















