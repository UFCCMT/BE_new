#include<data_structures>
#include<semaphore.h>
#include<iostream>


//------------------------------------------------------------------------
//---------------------------Buffer Constructor---------------------------
//------------------------------------------------------------------------
buffer::buffer()
{
  count_proc_to_comm=0;
  count_comm_to_proc=0;
  sem_init(&sem_proc_to_comm,0,1);
  sem_init(&sem_comm_to_proc,0,1);
}









//-----------------------------------------------------------------------
//---------------------------Read from buffer----------------------------
//-----------------------------------------------------------------------

int buffer::read(packet *p, FLAG_TYPE which_buffer)
{
  //Buff proc to comm-------------------------------------
  if(which_buffer==PROC_TO_COMM)
  { 
    //Lock semaphore
    sem_wait(&sem_proc_to_comm);
    
    //Loop throuh the entire buffer
    for(int count=0; count<BUFFER_SIZE; count++)
    {
      if(buff_proc_to_comm[count].source == p->source &&              //Check source
         buff_proc_to_comm[count].tag == p->tag)                      //Check tag 
      {
        //Copy the packet over
        p->flag         = buff_proc_to_comm[count].flag         ;
        p->time         = buff_proc_to_comm[count].time         ;
        p->destination  = buff_proc_to_comm[count].destination  ;
        p->message_size = buff_proc_to_comm[count].message_size ;
        
        buff_proc_to_comm[count].tag=-1;
        //Release the semaphore
        sem_post(&sem_proc_to_comm);
        return 0;
      }
    }
    //Not found. Return -1
    sem_post(&sem_proc_to_comm);
    return -1;
  }
  
  
  
  
  
  
  //Buff comm to proc-------------------------------------
  if(which_buffer==COMM_TO_PROC)
  { 
    //Lock semaphore
    sem_wait(&sem_comm_to_proc);
    
    //Loop throuh the entire buffer
    for(int count=0; count<BUFFER_SIZE; count++)
    {
      if(buff_comm_to_proc[count].source == p->source &&              //Check source
         buff_comm_to_proc[count].tag == p->tag)                      //Check tag (always 0 for ACK)
      {
        //Copy the packet over
        p->flag         = buff_comm_to_proc[count].flag         ;
        p->time         = buff_comm_to_proc[count].time         ;
        p->destination  = buff_comm_to_proc[count].destination  ;        
        p->message_size = buff_comm_to_proc[count].message_size ;
        buff_comm_to_proc[count].tag=-1;
        
        //Release the semaphore
        sem_post(&sem_comm_to_proc);
        return 0;
      }
    }
    
    //Not found. Return -1
    sem_post(&sem_comm_to_proc);
    return -1;
  }
  
  
 return -1; 
  
  
}










//------------------------------------------------------------------------------
//-------------------------Read anything from buffer----------------------------
//------------------------------------------------------------------------------

int buffer::read_anything(packet *p)
{
  //Lock semaphore
  sem_wait(&sem_proc_to_comm);
  
  //Loop and look for a valid packet
  for(int count=0; count<BUFFER_SIZE; count++)
  {
    if(buff_proc_to_comm[count].tag!=-1)
    {
      //If found, copy the packet over, release semaphore and return success
      (*p)=buff_proc_to_comm[count];
      buff_proc_to_comm[count].tag=-1;
      sem_post(&sem_proc_to_comm);
      return 0;
    }
  }
  
  //If no valid packet is there, return failure
  sem_post(&sem_proc_to_comm);
  return -1; 
}
















//------------------------------------------------------------------------------
//------------------------------Write to buffer---------------------------------
//------------------------------------------------------------------------------

int buffer::write(packet *p, FLAG_TYPE which_buffer)
{
  //Write to proc to comm buffer-----------------------------------------------
  if(which_buffer==PROC_TO_COMM)
  {
    //Lock semaphore
    sem_wait(&sem_proc_to_comm);
    
    //Loop to see an empty slot
    for(int count=0; count<BUFFER_SIZE; count++)
    {
      if(buff_proc_to_comm[count].tag==-1)
      { 
        //Write to buffer
        buff_proc_to_comm[count]=(*p);
        
        //Release semaphore
        sem_post(&sem_proc_to_comm);
        
        //Return success
        return 0;
      }
    }
    
    //No empty slot. Release semaphore and return failure
    sem_post(&sem_proc_to_comm);
    return -1;
  }
  
  
  
  
  //Write to comm to proc buffer-----------------------------------------------
  if(which_buffer==COMM_TO_PROC)
  {
    //Lock semaphore
    sem_wait(&sem_comm_to_proc);
    
    //Loop to see an empty slot
    for(int count=0; count<BUFFER_SIZE; count++)
    {
      if(buff_comm_to_proc[count].tag==-1)
      { 
        //Write to buffer
        buff_comm_to_proc[count]=(*p);
        
        //Release semaphore
        sem_post(&sem_comm_to_proc);
        
        //Return success
        return 0;
      }
    }
    
    //No empty slot. Release semaphore and return failure
    sem_post(&sem_comm_to_proc);
    return -1;
  }
  
  return -1;
}

























//------------------------------------------------------------------------------
//-------------------------See contents of buffer-------------------------------
//------------------------------------------------------------------------------

void buffer::show(FLAG_TYPE which_buffer)
{
  //Display proc to comm buffer-------------------------------------------------
  if(which_buffer==PROC_TO_COMM)
  {
    std::cout<<"\n\n\nProc to comm buffer..\n";
    for(int count=0; count<BUFFER_SIZE; count++)
      buff_proc_to_comm[count].show();
  }
  
  
  //Display comm to proc buffer-------------------------------------------------
  if(which_buffer==COMM_TO_PROC)
  {
    std::cout<<"\n\n\nComm to proc buffer..\n";
    for(int count=0; count<BUFFER_SIZE; count++)
      buff_comm_to_proc[count].show();
  }
}


















