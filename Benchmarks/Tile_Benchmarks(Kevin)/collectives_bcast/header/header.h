#ifndef __HEADER__
  #define __HEADER__
  
  #include<tmc/cpus.h>
  #include<tmc/udn.h>

  #define DATA_TYPE  float
  #define MAIN       -1

  void init(int, char **);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
  void finalize();
  void barrier(int);
  void *thread_fn(void*);
#endif
