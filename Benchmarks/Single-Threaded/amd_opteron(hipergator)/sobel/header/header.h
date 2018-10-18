#ifndef __HEADER__
  #define __HEADER__
  #define __REENTRANT

  //General definitions
  #define DATA_TYPE  char
  #define MAIN       -1

  
  void init(int, char **);
  void *thread_fn(void*);

#endif
