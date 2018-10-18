/*

Topic:
--------
This file implements the network routing.

Description:
-------------
This file implements the route function of the comm BEO.
This function is responsible for routing of the packets.
It i8mplements an XY routing scheme, and may/may not account for traffic.
That depends on if it is compiled with the __TRAFFIC__ defined.

*/ 


/*

Note: this is a switch to turn traffic model on/off during compilation.

*/




#include<beo>
#include<data_structures>
#include<lookup>



//------------------------------------------------------------------------------
//-----------------------Comm BEO Routing function------------------------------
//------------------------------------------------------------------------------

void commBEO::route(int mode)
{
  //Step 1: Calculate own and destination x and y co-ordinates
  int temp_x=p.destination%M;
  int temp_y=p.destination/M;
  int x=ID%M, y=ID/M;
  
  
  
  //Step 2: Modify times in packet
  if(mode==0)//From own proc BEO
  {
    p.time+=lookup(LATENCY_P_TO_C,p.message_size,0);
    last_transfer_end_time=p.time+lookup(PER_HOP_TIME,p.message_size,0)*(p.message_size-1);
  }
  else //From other comm BEOs
  {
    p.time+=lookup(PER_HOP_TIME,p.message_size,0);
    last_transfer_end_time=p.time+p.message_size*lookup(PER_HOP_TIME,p.message_size,0);
  }
  
  
  
  
  //Step3: Route the packet
  if(temp_x<x)
    while(pipes[WEST]->write(&p,PIPE_DOWN)==-1);
  if(temp_x>x)
    while(pipes[EAST]->write(&p,PIPE_UP)==-1);
  if(temp_x==x)
  {
    if(temp_y<y)
      while(pipes[NORTH]->write(&p,PIPE_UP)==-1);
    if(temp_y>y)
      while(pipes[SOUTH]->write(&p,PIPE_DOWN)==-1);
    if(temp_y==y)
      b->write(&p,COMM_TO_PROC);
      
  }
  
  
}
