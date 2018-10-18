/*

Topic:
--------
This file contains the constructor functions of comm BEO.

Description:
-------------
This file contains the constructor functions of comm BEO.
The default constructor as usua l does nothing.
The overloaded constructor initializes the ID, etc of the BEO.

*/ 




#include<beo>
#include<data_structures>



//------------------------------------------------------------------------------
//-------------------------Comm BEO Constructors--------------------------------
//------------------------------------------------------------------------------

commBEO::commBEO()
{
  M=-1;
  N=-1;
}


commBEO::commBEO(pipe3* pipes[], buffer *b, int ID, comm_beo_interface* comm_ctrl)
{
  //Initialize pipe3s to connect to
  for(int count=0; count<4; count++)
    this->pipes[count]=*(pipes+count );
  
  //Initialize buffers and mesh dimensions  
  this->b=b;
  this->M=comm_ctrl->M;
  this->N=comm_ctrl->N;
  this->ID=ID;
  
  last_transfer_end_time=0.0f;
  
  
  
  arrange.head=0;
}






void commBEO::setup(pipe3* pipes[], buffer *b, int ID, comm_beo_interface* comm_ctrl)
{
  //Initialize pipe3s to connect to
  for(int count=0; count<4; count++)
    this->pipes[count]=*(pipes+count );
  
  //Initialize buffers and mesh dimensions  
  this->b=b;
  this->M=comm_ctrl->M;
  this->N=comm_ctrl->N;
  this->ID=ID;
  
  last_transfer_end_time=0.0f;
  
  
  
  arrange.head=0;
}


