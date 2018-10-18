#include<header.h>
#include<stdio.h>

void send126(uint_reg_t *buffer, int no_of_words, int dest, uint_reg_t demux)
{
  int count, count1;
  DynamicHeader header= tmc_udn_header_from_cpu(dest);
  uint_reg_t ACK;
  uint_reg_t *start_addr=buffer;
 
  //Send data in 126 word long batches 
  for(count=0; count<no_of_words/126; count++)
  {
    //Send a 126 word long packet
    tmc_udn_send_buffer(header,demux,start_addr,126);
    
    //Wait for AC:
    ACK=tmc_udn3_receive();
    
    //Increment buffer address
    start_addr+=126;
    
    
  }
  
  //Send remaining data
  if(no_of_words%126!=0)
  {
    //Send a 126 word long batch
    tmc_udn_send_buffer(header,demux,start_addr,no_of_words%126);
    
    //Wait for AC:
    ACK=tmc_udn3_receive();
  }
  
}









void receive126(uint_reg_t *buffer, int no_of_words, int source, uint_reg_t demux)
{
  int count, count1;
  DynamicHeader header= tmc_udn_header_from_cpu(source);
  uint_reg_t ACK;
  uint_reg_t *start_addr=buffer;
 
  //Receive data in 126 word long batches 
  for(count=0; count<no_of_words/126; count++)
  {
    //Receive a 126 word long packet
    switch(demux)
    {
      case UDN0_DEMUX_TAG: tmc_udn0_receive_buffer(start_addr, 126); break;
      case UDN1_DEMUX_TAG: tmc_udn1_receive_buffer(start_addr, 126); break;
      case UDN2_DEMUX_TAG: tmc_udn2_receive_buffer(start_addr, 126); break;
    }
    
    
    //SEND ACK:
    tmc_udn_send_1(header,UDN3_DEMUX_TAG,ACK);
    
    //Increment buffer address
    start_addr+=126;
  }
  
  
  //Receive remaining data
  if(no_of_words%126!=0)
  {
    //Send a 126 word long batch
    switch(demux)
    {
      case UDN0_DEMUX_TAG: tmc_udn0_receive_buffer(start_addr, no_of_words%126); break;
      case UDN1_DEMUX_TAG: tmc_udn1_receive_buffer(start_addr, no_of_words%126); break;
      case UDN2_DEMUX_TAG: tmc_udn2_receive_buffer(start_addr, no_of_words%126); break;
    }
    
    //Send  ACK:
    tmc_udn_send_1(header,UDN3_DEMUX_TAG,ACK);
    
  }
  
}















