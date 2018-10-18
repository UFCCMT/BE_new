#include<header.h>
#include<stdio.h>



//-----------------------------------Globals------------------------------------
//Thread management
extern int nthreads;
extern pthread_t *threads;
extern int *thread_id;
extern int *core_map;
extern int *barrier_map;



//Time measurement and log management
extern char *logfile;
extern double *log_memory;



//Program parameters
extern int datasize;
extern int iterations;






void barrier(int ID)
{
  uint_reg_t bcast_sig;
  if(core_map[ID]==0)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(barrier_map[0]);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
  
  bcast_sig=tmc_udn1_receive();
  
  if(core_map[ID]!=0)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(barrier_map[ID]);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
  if(core_map[ID]==0)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(barrier_map[0]);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
  
  bcast_sig=tmc_udn1_receive();
  
  if(core_map[ID]!=0)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(barrier_map[ID]);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
}
