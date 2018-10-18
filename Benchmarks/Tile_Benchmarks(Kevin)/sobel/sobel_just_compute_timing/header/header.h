#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT
  
  #include<tmc/cpus.h>
  #include<tmc/udn.h>

  //General definitions
  #define DATA_TYPE  char
  #define MAIN       -1

  //DEfinitions for logging
  //#define SCA_S   0
  //#define SCA_E   1
  //#define SCA_D   2

  #define COMP_S  0
  #define COMP_E  1
  #define COMP_D  2

  //#define GATH_S  6
  //#define GATH_E  7
  //#define GATH_D  8
  
  void init(int, char **);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
  void finalize();
  void barrier(int);
  void *thread_fn(void*);
  void *watchdog(void*);
  
#endif
