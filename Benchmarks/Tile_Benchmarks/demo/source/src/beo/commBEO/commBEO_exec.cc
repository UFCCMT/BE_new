/*

Topic:
--------
This file implements the control unit of the comm BEO.

Description:
-------------
This file contains the control function for the comm BEO.
This function polls the different pipes in a specified manner and routes the packets.


*/ 




#include<beo>
#include<data_structures>
#include<cstdlib>
#include<pthread.h>

#include<unistd.h>

#include<iostream>


//------------------------------------------------------------------------------
//-----------------------Comm BEO Execution unit--------------------------------
//------------------------------------------------------------------------------


void commBEO::execute()
{ 
  
  while(1)
  {
    //Loop 100 times and collect packets
    for(int count=0; count<100 && arrange.head<BUFF_MAX; count++)
    {
      //Read buffer and route
      if(b->read_anything(&arrange.buffer[arrange.head])!=-1)
      {
        arrange.from[arrange.head]=FROM_PROC;
        arrange.head++;
      }
      //Read east pipe and route
      if(pipes[EAST]!=NULL && pipes[EAST]->read(&arrange.buffer[arrange.head],PIPE_DOWN)!=-1)
      {
        arrange.from[arrange.head]=FROM_COMM;
        arrange.head++;
        //route(1);
      }
      //Read south pipe and route
      if(pipes[SOUTH]!=NULL && pipes[SOUTH]->read(&arrange.buffer[arrange.head],PIPE_UP)!=-1)
      {
        arrange.from[arrange.head]=FROM_COMM;
        arrange.head++;
        //route(1);
      }
    
      //Read west pipe and route
      if(pipes[WEST]!=NULL && pipes[WEST]->read(&arrange.buffer[arrange.head],PIPE_UP)!=-1)
      {
        arrange.from[arrange.head]=FROM_COMM;
        arrange.head++;
        //route(1);
      }
    
      //Read north pipe and route
      if(pipes[NORTH]!=NULL && pipes[NORTH]->read(&arrange.buffer[arrange.head],PIPE_DOWN)!=-1)
      {
        arrange.from[arrange.head]=FROM_COMM;
        arrange.head++;
        //route(1);
      }
      
    }
    
    //Sort the entries by time
    packet temp_packet;
    char temp_from;
    for(int count=0; count<arrange.head;count++)
    {
      for(int count1=count; count1<arrange.head; count1++)
      {
        if(arrange.buffer[count1].time<arrange.buffer[count].time)
        {
          temp_packet=arrange.buffer[count];
          arrange.buffer[count]=arrange.buffer[count1];
          arrange.buffer[count1]=temp_packet;
          
          temp_from=arrange.from[count];
          arrange.from[count]=arrange.from[count1];
          arrange.from[count1]=temp_from;
        }
      }
    }
    
    //Dispatch
    for(int count=0; count<arrange.head; count++)
    {
      p=arrange.buffer[count];
      if(arrange.from[count]==FROM_PROC)
        route(0);
      else
        route(1);
    }
    
    //Reset head
    arrange.head=0;
    
  }  
}

























