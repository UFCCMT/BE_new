#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT

  //General definitions
  #define DATA_TYPE  float
  #define MAIN       -1
  
  void init(int, char **);
  void finalize();
  void *thread_fn(void*);
  void *watchdog(void*);
  
#endif
