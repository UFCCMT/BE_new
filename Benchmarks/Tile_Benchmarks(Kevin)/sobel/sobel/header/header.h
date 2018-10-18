#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT
  
  #include<tmc/cpus.h>
  #include<tmc/udn.h>

  //General definitions
  #define DATA_TYPE  char
  #define MAIN       -1

  //DEfinitions for logging
  #define BAR1_D  0
  #define SCA_D   1
  #define BAR2_D  2
  #define COMPGX_D  3
  #define COMPGY_D  4
  #define BAR3_D  5
  #define GATH_D  6
  #define BAR4_D  7
  
  void init(int, char **);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
  void finalize();
  void barrier(int);
  void *thread_fn(void*);
  void *watchdog(void*);
  
#endif
