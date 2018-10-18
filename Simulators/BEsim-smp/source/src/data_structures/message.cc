/*

About:
-------
Message source file

Description:
-------------
This file contains the source for the message data structure.

Notes:
-------

*/

#include<data_structures>

namespace smp
{
  message::message()
  {
    source=-1;
    destination=-1;
    message_size=-1;
    tag=-1;
    flag=(FLAG_TYPE)0;
    time=(TIME_TYPE)-1;
  }
  
  //-------------------Pperator overloading-------------------------------------
  bool message::operator<(message m)
  {
    return ((time<m.time)?true:false);
  }
  
  bool message::operator>(message m)
  {
    return ((time>m.time)?true:false);
  }
  
  bool message::operator<=(message m)
  {
    return ((time<=m.time)?true:false);
  }
  
  bool message::operator>=(message m)
  {
    return ((time>=m.time)?true:false);
  }
  
  std::ostream& operator<<(std::ostream& out, message m)
  {
    out<<"("<<m.source<<" , "<<m.destination<<" , "<<m.message_size<<" , "<<m.tag<<" , "<<m.time<<" , "<<(int)m.flag<<")";
    return out;
  }
  
  
  
  //----------------------------Flag manipulation-------------------------------
  void message::bit_set(int pos)
  {
    flag=(flag | 1<<pos);
  }
  
  void message::bit_reset(int pos)
  {
    flag=(flag & ~(1<<pos));
  }
  
  bool message::is_bit_set(int pos)
  {
    return ((flag & (1<<pos))==0?false:true);
  }
}

