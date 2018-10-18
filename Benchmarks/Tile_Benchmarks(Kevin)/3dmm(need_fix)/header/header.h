#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT
  
  #include<tmc/cpus.h>
  #include<tmc/udn.h>

  //General definitions
  #define DATA_TYPE  float
  #define MAIN       -1

  //DEfinitions for logging
  #define BCAST_D 0
  #define SCA_D   1
  #define COMP_D  2
  #define XFER_D  3
  //#define XFER1_D  3
  //#define XFER2_D  4
  //#define XFER3_D  4
  //#define XFER4_D  6
  #define TOT_D 4
  
  void init(int, char **);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
  void finalize();
  void barrier(int);
  void *thread_fn(void*);
  void *watchdog(void*);
  double timer();
  
#endif
