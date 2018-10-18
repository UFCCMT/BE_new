#include<data_structures>
#include<semaphore.h>
#include<iostream>
#include<unistd.h>

#define __DEBUG__

//--------------------------------------------------
//---------------Pipe constructor-------------------
//--------------------------------------------------
pipe3::pipe3()
{
  read_head_up=0;
  write_head_up=0;
  read_head_down=0;
  write_head_down=0;
  sem_init(&sem_pipe_up,0,1);
  sem_init(&sem_pipe_down,0,1);
  flag=(FLAG_TYPE)0;
}













//--------------------------------------------------
//--------------------Read a pipe-------------------
//--------------------------------------------------
int pipe3::read(packet *p,FLAG_TYPE flag)
{
  if(flag==PIPE_UP)//Read Up pipe
  {
    sem_wait(&sem_pipe_up);
    
    //If read and write heads co incide it means that there is nothing in the pipe.
    //Then we reset it.
    if(read_head_up==write_head_up)
    {
      read_head_up=0, write_head_up=0;
      sem_post(&sem_pipe_up);
      return -1;
    }
    //Otherwise Just return whatever is there
    *p=pipe_up[read_head_up];
    #ifdef __DEBUG__
      pipe_up[read_head_up].source=-1;
      pipe_up[read_head_up].destination=-1;
      pipe_up[read_head_up].tag=0;
      //pipe_up[read_head_up].message_size=0;
    #endif
    read_head_up++;
    sem_post(&sem_pipe_up);
    return 0;
  }
  
  if(flag==PIPE_DOWN)//Read Down pipe
  {
    sem_wait(&sem_pipe_down);
    
    //If read and write heads co incide it means that there is nothing in the pipe.
    //Then we reset it.
    if(read_head_down==write_head_down)
    {
      read_head_down=0, write_head_down=0;
      sem_post(&sem_pipe_down);
      return -1;
    }
    //Otherwise Just return whatever is there
    *p=pipe_down[read_head_down];
    #ifdef __DEBUG__
      pipe_down[read_head_down].source=-1;
      pipe_down[read_head_down].destination=-1;
      pipe_down[read_head_down].tag=0;
      //pipe_down[read_head_down].message_size=0;
    #endif
    read_head_down++;
    sem_post(&sem_pipe_down);
    return 0;
  }
  return -1;
}












//----------------------------------------------------------------------
//-----------------------Pipe write-------------------------------------
//----------------------------------------------------------------------
int pipe3::write(packet *p, FLAG_TYPE flag)
{
  if(flag==PIPE_UP)
  {
    sem_wait(&sem_pipe_up);
    
    //Check for overflow
    if(write_head_up==PIPE_SIZE && read_head_up<PIPE_SIZE/2)
    {
      sem_post(&sem_pipe_up);
      return -1;
    }
    
    //Check for wasted space
    if(write_head_up==PIPE_SIZE && read_head_up>=PIPE_SIZE/2)
    {
      //Shift contents down the pipe
      //int temp=read_head_up;
      for(int count=0; count<PIPE_SIZE-read_head_up; count++)
      {
        pipe_up[count]=pipe_up[count+read_head_up];
        #ifdef __DEBUG__
          pipe_up[count+read_head_up].source=-1;
          pipe_up[count+read_head_up].destination=-1;
          pipe_up[count+read_head_up].tag=0;
          pipe_up[count+read_head_up].message_size=0;
        #endif
      }
      write_head_up-=read_head_up;
      read_head_up=0;
      
      //Now write data into the pipe
      pipe_up[write_head_up]=*p;
      write_head_up++;
      sem_post(&sem_pipe_up);
      return 0;
    }
    
    //Normal Write
    pipe_up[write_head_up]=*p;
    write_head_up++;
    sem_post(&sem_pipe_up);
    return 0;
  }
  
  if(flag==PIPE_DOWN)
  {
    sem_wait(&sem_pipe_down);
    
    //Check for overflow
    if(write_head_down==PIPE_SIZE && read_head_down<PIPE_SIZE/2)
    {
      sem_post(&sem_pipe_down);
      return -1;
    }
    
    //Check for wasted space
    if(write_head_down==PIPE_SIZE && read_head_down>=PIPE_SIZE/2)
    {
      //Shift contents down the pipe
      //int temp=read_head_down;
      for(int count=0; count<PIPE_SIZE-read_head_down; count++)
      {
        pipe_down[count]=pipe_down[count+read_head_down];
        #ifdef __DEBUG__
          pipe_down[count+read_head_down].source=-1;
          pipe_down[count+read_head_down].destination=-1;
          pipe_down[count+read_head_down].tag=0;
          pipe_down[count+read_head_down].message_size=0;
        #endif
      }
      write_head_down-=read_head_down;
      read_head_down=0;
      
      //Now write data into the pipe
      pipe_down[write_head_down]=*p;
      write_head_down++;
      sem_post(&sem_pipe_down);
      return 0;
    }
    
    //Normal Write
    pipe_down[write_head_down]=*p;
    write_head_down++;
    sem_post(&sem_pipe_down);
    
    return 0;
  }
  return -1;
}











//--------------------------------------------------------------
//--------------------------_Set flags in pipe------------------
//--------------------------------------------------------------
int pipe3::set_property(FLAG_TYPE flag)
{
  this->flag=this->flag|flag;
  return 0;
}


























//--------------------------------------------------------------
//--------------------------Clear flags in pipe-----------------
//--------------------------------------------------------------
int pipe3::clear_flag()
{
  this->flag=(FLAG_TYPE)0;
  return 0;
}

















//--------------------------------------------------------------
//--------------------------Display pipe------------------------
//--------------------------------------------------------------
void pipe3::show(FLAG_TYPE flag)
{
  if(flag==PIPE_UP)
  {
    std::cout<<"\n\n\nUp pipe.....\nFlag: "<<std::hex<<(int)this->flag<<"\n";
    for(int count=0; count<PIPE_SIZE; count++)
      pipe_up[count].show();
  }
  else
  {
    std::cout<<"\n\n\nDown pipe.....\nFlag: "<<std::hex<<(int)this->flag<<"\n";
    for(int count=0; count<PIPE_SIZE; count++)
      pipe_down[count].show();
  }
}














