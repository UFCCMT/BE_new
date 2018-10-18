#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT
  
  #include<tmc/cpus.h>
  #include<tmc/udn.h>

  //General definitions
  #define DATA_TYPE  float
  #define MAIN       -1

  //DEfinitions for logging
  //#define BCAST_S 0
  //#define BCAST_E 1
  #define BCAST_D 0
  
  //#define BAR_S 3
  //#define BAR_E 4
  #define BAR_D 1
  
  //#define SCA_S   6
  //#define SCA_E   7
  #define SCA_D   2

  //#define COMP_S  9
  //#define COMP_E  10
  #define COMP_D  3
  
  //#define BAR1_S 12
  //#define BAR1_E 13
  #define BAR1_D 4

  //#define GATH_S  15
  //#define GATH_E  16
  #define GATH_D  5
  
  #define TOTAL_D 6
  
  void init(int, char **);
  void send126(uint_reg_t*, int, int, uint_reg_t);
  void receive126(uint_reg_t*, int, int, uint_reg_t);
  void finalize();
  void barrier(int);
  void *thread_fn(void*);
  void *watchdog(void*);
  
#endif
