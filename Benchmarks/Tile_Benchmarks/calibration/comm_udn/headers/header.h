#ifndef __HEADER__
  #define __HEADER__

  #define DATA_TYPE float
  #include<tmc/cpus.h>
  #include<tmc/udn.h>
  
  #define iterations 20000
  
  void init(int, char**);
  void *thread_fn_master(void*);
  void *thread_fn_slave(void*);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
#endif
