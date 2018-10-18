/*

Topic:
--------
This file defines the constructor of proc BEO.

Description:
-------------
This file defines the body of the constructors for the procBEO.
The default constructor does nothing basically.
The overloaded constructor initializes the registers, stack, event queue, buffer, etc.
*/ 




#include<beo>
#include<data_structures>



procBEO::procBEO()
{
  ID=-1;
}





procBEO::procBEO(int ID, buffer *b)
{
  this->ID=ID;
  this->b=b;
  	
  last_instr_end_t=0;
  
}




void procBEO::setup(int ID, buffer *b)
{
  this->ID=ID;
  this->b=b;

  
  last_instr_end_t=0;
  
}







