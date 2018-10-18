#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT
  
  #include<tmc/cpus.h>
  #include<tmc/udn.h>

  //General definitions
  #define DATA_TYPE  float
  #define MAIN       -1

  //DEfinitions for logging
  #define BCAST_S 0
  #define BCAST_E 1
  #define BCAST_D 2
  
  #define SCA_S   3
  #define SCA_E   4
  #define SCA_D   5

  #define COMP_S  6
  #define COMP_E  7
  #define COMP_D  8

  #define GATH_S  9
  #define GATH_E  10
  #define GATH_D  11
  
  void init(int, char **);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
  void finalize();
  void barrier(int);
  void *thread_fn(void*);
  void *watchdog(void*);
  
#endif
