/*

About:
------
The eorker thread function body

Description:
------------
This file contains the function definition of the worker threads. This is the 
function that binds everything (procBEOs, network, queue, etc into 1 unit, 
namely the exascale computer. THIS IS THE HEART OF THE SIMULATOR.

Notes:
------
1) Right now, it can handle only 1 network, and that too, just the mesh.
2) Functionality for multiple networks and multiple kinds of networks needs to be
added later.
3) Replace the bad q and network and procBEO pointer values with exceptions.

*/


#include "beo"
#include "data_structures"
#include "interpolation"

#include<cstdlib>

namespace smp
{
  void worker_threads::execute()
  {
    //Extract information about underlying network
    int source_x, source_y, dest_x, dest_y;
    int ncols=nets->get_ncols();
    
      
    //Start polling the queue and doing the thing
    message m;
    if(!nets->istraffic())
    {
      while(true)
      {
        if(q->dispatch(&m)==SUCCESS)
        {
          //Message source and destination co-ordinates
          source_x = m.source%ncols;
          source_y = m.source/ncols;
          dest_x   = m.destination%ncols;
          dest_y   = m.destination/ncols;
          
          //Modify the message time
          m.time+=((abs(dest_x-source_x)+(dest_y-source_y))*smp::interpolation(PER_HOP_TIME,0,0));
          m.time+=(m.message_size-1);
          
          //Deliver it to required procBEO
          while(procs[m.destination].write_to_buffer(m)==FAILURE);
        }//End of inner if
      }//End of while loop
    }//End of outer if
  }
}





