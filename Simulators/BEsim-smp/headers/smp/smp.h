/*

About:
------
SMP API header

Description:
------------
This file contains the header necessary to use the smp library to develop apps.

Notes:
------

*/

#include<pthread.h>
#include "common_definitions"

namespace smp
{
  class procBEO;
  class mesh_network; 
  class ordered_q;
  class worker_threads;
  
  class exascale_machine
  {
    private: //Proc list
             int             nprocs;
             procBEO         *proc_list;
             
             //The network
             mesh_network    *nets;
             
             //Threads
             int nthreads;
             ordered_q       *queues;
             worker_threads  *workers;
             pthread_t       *threads;
             
             //Setup flags
             int is_proc_setup, is_net_setup, is_worker_setup;
             
    public : exascale_machine(){is_proc_setup=0; is_net_setup=0; is_worker_setup=0;}
             
             //Init functions
             int setup_procs(int);
             int setup_mesh(int,int,int);
             int setup_workers(int);
             void start_network();
             
             //Actual API
             int send(int,int,int,int); //Source, destination, tag, message_size
             int send_n(int,int,int,int); //Source, destination, tag, message_size
             int recv(int, int, int);  //Destination, source, tag
             int compute(int,int); //ID, compute size
             int compute_m(int,int,int); //ID, compute size, #computes
             TIME_TYPE smp_gettime(int); //ID
  };
}

