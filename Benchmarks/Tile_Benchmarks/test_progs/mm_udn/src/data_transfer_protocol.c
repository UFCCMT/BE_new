/*

File: 
---------
Data transfer protocols.

Description: 
--------------
The functions defined here are responsible for transfering data between nodes in a reliable (somewhat) manner.
These functions form a protocol that makes the send/recv functions independent limited buffer in tile.
These automatically create batches and wait for an acknowledge after each batch of dara

*/



#include<tmc/udn.h>
#include<stdio.h>



//Function prototypes
int send127(uint_reg_t*, int, int,      uint_reg_t);
int sendN  (uint_reg_t*, int, int, int, uint_reg_t);
int recv127(uint_reg_t*, int, int,      uint_reg_t);
int recvN  (uint_reg_t*, int, int, int, uint_reg_t);








//---------------------------------------------------------------------------------------------
//----------------------------Send in fixed batch size (127)-----------------------------------
//---------------------------------------------------------------------------------------------
void send127(uint_reg_t *buffer, int no_of_words, int dest, uint_reg_t demux)
{
  int count, count1;
  DynamicHeader header= tmc_udn_header_from_cpu(dest);
  uint_reg_t ACK;
  uint_reg_t *start_addr=buffer;
 
  //Send data in 126 word long batches 
  for(count=0; count<no_of_words/127; count++)
  {
    //Send a 126 word long packet
    tmc_udn_send_buffer(header,demux,start_addr,127);
    
    //Wait for ACK:
    ACK=tmc_udn3_receive();
    
    //Increment buffer address
    start_addr+=127;
    
    
  }
  
  //Send remaining data
  if(no_of_words%127!=0)
  {
    //Send a 126 word long batch
    tmc_udn_send_buffer(header,demux,start_addr,no_of_words%127);
    
    //Wait for AC:
    ACK=tmc_udn3_receive();
  }
  
}








//---------------------------------------------------------------------------------------------
//----------------------------Recv in fixed batch size (127)-----------------------------------
//---------------------------------------------------------------------------------------------
void receive126(uint_reg_t *buffer, int no_of_words, int source, uint_reg_t demux)
{
  int count, count1;
  DynamicHeader header= tmc_udn_header_from_cpu(source);
  uint_reg_t ACK;
  uint_reg_t *start_addr=buffer;
 
  //Receive data in 126 word long batches 
  for(count=0; count<no_of_words/127; count++)
  {
    //Receive a 126 word long packet
    switch(demux)
    {
      case UDN0_DEMUX_TAG: tmc_udn0_receive_buffer(start_addr, 127); break;
      case UDN1_DEMUX_TAG: tmc_udn1_receive_buffer(start_addr, 127); break;
      case UDN2_DEMUX_TAG: tmc_udn2_receive_buffer(start_addr, 127); break;
    }
    
    
    //SEND ACK:
    tmc_udn_send_1(header,UDN3_DEMUX_TAG,ACK);
    
    //Increment buffer address
    start_addr+=127;
  }
  
  
  //Receive remaining data
  if(no_of_words%127!=0)
  {
    //Send a 126 word long batch
    switch(demux)
    {
      case UDN0_DEMUX_TAG: tmc_udn0_receive_buffer(start_addr, no_of_words%127); break;
      case UDN1_DEMUX_TAG: tmc_udn1_receive_buffer(start_addr, no_of_words%127); break;
      case UDN2_DEMUX_TAG: tmc_udn2_receive_buffer(start_addr, no_of_words%127); break;
    }
    
    //Send  ACK:
    tmc_udn_send_1(header,UDN3_DEMUX_TAG,ACK);
    
  }
  
}









