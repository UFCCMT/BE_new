/*

About:
------
The eorker thread constructor body

Description:
------------
This file contains the constructor definition of the worker threads. 
The constrcutor creates the threads, associates the procBEOs, network and the
queues and starts the thread execution.

Notes:
------

*/





#include "beo"
#include<pthread.h>

namespace smp
{
  worker_threads::worker_threads()
  {
  }
  
  
  int worker_threads::setup(int worker_id, ordered_q *q, procBEO *procs, mesh_network *nets)
  {
    this->worker_id=worker_id;
    this->q=q;
    this->procs=procs;
    this->nets=nets;
    
    return SUCCESS;
  }
}




