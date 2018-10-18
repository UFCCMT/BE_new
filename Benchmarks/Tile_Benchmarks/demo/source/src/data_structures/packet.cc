#include<data_structures>
#include<iostream>




packet::packet()
{
  source=-1;
  destination=-1;
  message_size=-1;
  tag=-1;
  flag=(FLAG_TYPE)0;
  time=-1;
}

void packet::show()
{
  std::cout<<std::dec<<source<<"\t"<<destination<<"\t"<<message_size<<"\t"<<tag<<"\t"<<std::hex<<(int)flag<<"\n"; 
}





int packet::set_property(FLAG_TYPE flag)
{
  this->flag=this->flag | flag; 
  return 0;
}


int packet::clear_flag()
{
  this->flag=(FLAG_TYPE)0;
  return 0;
}
