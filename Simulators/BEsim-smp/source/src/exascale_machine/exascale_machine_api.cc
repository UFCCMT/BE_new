/*

About:
------
Exascale machine api source

Description:
------------
This file contains the source for the top level api, exposed to the user.

Notes:
------

*/


#include "exascale_machine"
#include<iostream>
#include<cstdlib>



void* smp_thread_fn(void *arg)
{
  smp::worker_threads *w=(smp::worker_threads*)arg;
  w->execute();
  return NULL;
}



namespace smp
{
  //Function to create processors
  int exascale_machine::setup_procs(int nprocs)
  {
    this->nprocs=nprocs;
    proc_list=new procBEO[nprocs];
    is_proc_setup=1;
    return SUCCESS;
  }
  
  
  
  //-------------------Function to set up network-------------------------------
  int exascale_machine::setup_mesh(int nrows, int ncols, int traffic)
  {
    nets=new mesh_network(nrows,ncols,traffic);
    is_net_setup=1;
    return SUCCESS;
  }
  
  
  
  
  
  
  
  
  //------------------Funstion to set up worker threads-------------------------
  int exascale_machine::setup_workers(int nthreads)
  {
    if(is_proc_setup==0 || is_net_setup==0)
    {
      std::cout<<"Setup is incomplete\nMake sure setup_proc and setup_mesh functions have been called before this\n";
      exit(EXIT_FAILURE);
    }
    this->nthreads=nthreads;
    queues  = new ordered_q[nthreads]      ; 
    workers = new worker_threads[nthreads] ;
    threads = new pthread_t[nthreads]      ;
    
    is_worker_setup=1;
    return SUCCESS;
  }
  
  
  
  
  
  
  //---------------------------Function to start execution----------------------
  void exascale_machine::start_network()
  {
    if(is_worker_setup==0)
    {
      std::cout<<"Setup is incomplete\n";
      exit(EXIT_FAILURE);
    }
    
    //Bind procs to queues
    for(int count=0, count1=0; count<nprocs; count++)
    {
      proc_list[count].setup(count,&queues[count1]);
      count1++;
      if(count1==nthreads)
        count1=0;
    }
    
    //Bind worker threads to queues
    for(int count=0; count<nthreads; count++)
    {
      workers[count].setup(count, &queues[count],proc_list,nets);
      pthread_create(&threads[count],NULL,smp_thread_fn,(void*)&workers[count]);
    }
  }
  
  
  
  
  
  
  //-------------------------------------Send-----------------------------------
  int exascale_machine::send(int source, int destination, int tag, int message_size)
  {
    if(source>=nprocs || destination>=nprocs)
    {
      std::cout<<"Invalid procID. Quiting\n";
      exit(EXIT_FAILURE);
    }
    proc_list[source].send(destination,tag,message_size);
    return SUCCESS;
  }
  
  
  
  //-------------------------------------Send N---------------------------------
  int exascale_machine::send_n(int source, int destination, int tag, int message_size)
  {
    if(source>=nprocs || destination>=nprocs)
    {
      std::cout<<"Invalid procID. Quiting\n";
      exit(EXIT_FAILURE);
    }
    proc_list[source].send_n(destination,tag,message_size);
    return SUCCESS;
  }
  
  
  
  
  //-------------------------------------Recv-----------------------------------
  int exascale_machine::recv(int destination, int source, int tag)
  {
    if(source>=nprocs || destination>=nprocs)
    {
      std::cout<<"Invalid procID. Quiting\n";
      exit(EXIT_FAILURE);
    }
    proc_list[destination].recv(source,tag);
    return SUCCESS;
  }
  
  
  //---------------------------------Compute------------------------------------
  int exascale_machine::compute(int ID, int compsize)
  {
    if(ID>=nprocs)
    {
      std::cout<<"Invalid proc ID for compute: "<<ID<<"\n";
      exit(EXIT_FAILURE);
    }
    proc_list[ID].compute(compsize);
    return SUCCESS;
  }
  
  
  //---------------------------------Compute M----------------------------------
  int exascale_machine::compute_m(int ID, int compsize, int compnum)
  {
    if(ID>=nprocs)
    {
      std::cout<<"Invalid proc ID for compute: "<<ID<<"\n";
      exit(EXIT_FAILURE);
    }
    proc_list[ID].compute_m(compsize,compnum);
    return SUCCESS;
  }
  
  
  //------------------------------Get clock-------------------------------------
  TIME_TYPE exascale_machine::smp_gettime(int ID)
  {
    if(ID>=nprocs)
    {
      std::cout<<"Invalid proc ID for timer: "<<ID<<"\n";
      exit(EXIT_FAILURE);
    }
    return proc_list[ID].smp_gettime();
  }
}