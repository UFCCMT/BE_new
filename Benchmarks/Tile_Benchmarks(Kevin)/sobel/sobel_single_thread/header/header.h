#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT
  
  #include<tmc/cpus.h>
  #include<tmc/udn.h>

  //General definitions
  #define DATA_TYPE  char
  #define MAIN       -1

  
  void init(int, char **);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
  void finalize();
  void barrier(int);
  void *thread_fn(void*);
  void *watchdog(void*);
  
#endif
