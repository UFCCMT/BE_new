/*

About:
------
Ordered_q source file

Description:
------------
This file contains the source for the ordered queue data structure.

Notes:
-------

*/


#include "data_structures"
#include<new>
#include<iostream>
#include<cstdlib>
#include<semaphore.h>

namespace smp
{
  //-----------------------------Destructor-------------------------------------
  ordered_q::~ordered_q()
  {
    node *parser, *temp;
    parser=head;
    while(parser!=NULL)
    {
      temp=parser->next;
      delete parser;
      parser=temp;
    }
  }
  
  
  //----------------------------Insert------------------------------------------
  int ordered_q::insert(message object)
  {
    sem_wait(&sync); //Obtain lock
    
    node *parser=head;
    
    //Take care of empty list
    if(head==NULL) 
    {
      try
      {
        head=new node(object);
      }
      catch(std::bad_alloc &b)
      {
        std::cout<<"Memory allocation error. Quiting and dumping log.. "<<b.what()<<"\n";
        exit(1);
      }
      head->prev=NULL;
      head->next=NULL;
      head->content=object;
      tail=head;
      
      sem_post(&sync); //Release lock
      
      return SUCCESS;
    }
    
 
    //Otherwise do funstuff
    for(parser=head; parser!=NULL; parser=parser->next)
    {
      if(parser->content<object)
      {
        if(parser->prev!=NULL)
        {
          parser->prev->next=new node(object);
          parser->prev->next->next=parser;
          parser->prev->next->prev=parser->prev;
          parser->prev=parser->prev->next;
        }
        else
        {
          parser->prev=new node(object);
          parser->prev->prev=NULL;
          parser->prev->next=parser;
          head=parser->prev;
        }
        
        sem_post(&sync); //Release lock
        
        return SUCCESS;
      }
    }
    
    //Insert in last
    tail->next=new node(object);
    tail->next->next=NULL;
    tail->next->prev=tail;
    tail=tail->next;
    
    sem_post(&sync); //Release lock
    
    
    return SUCCESS;
  }
  
  
  
  
  
  
  
  
  
  
  
  //-------------------------------Dispatch-------------------------------------
  int ordered_q::dispatch(message *object)
  {
    sem_wait(&sync); //Obtain lock
    
    node *temp;
    
    //Empty q
    if(tail==NULL)
    {
      sem_post(&sync); //Release lock
      return FAILURE;
    }
      
    //Single element
    if(tail==head)
    {
      *object=tail->content;
      delete tail;
      tail=NULL;
      head=NULL;
      sem_post(&sync); //Release lock
      return SUCCESS;
    }
    
    //Normal stuff
    *object=tail->content;
    tail->prev->next=NULL;
    temp=tail->prev;;
    delete tail;
    tail=temp;
    
    sem_post(&sync); //Release lock
    
    return SUCCESS;
  }  
  
  
  //------------------------------Display---------------------------------------
  int ordered_q::display()
  {
    sem_wait(&sync); //Obtain lock
    
    node *parser=head;
    while(parser!=NULL)
    {
      std::cout<<parser->content<<"\n";
      parser=parser->next;
    }
    
    sem_post(&sync); //Release lock
    
    return SUCCESS;
  }
}

