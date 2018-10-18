/*

Topic:
--------
This is the header smp mesh header file

About
-------
This header file needs to be used when we need to use the smp_mesh apis.
All the mesh UDN, etc are built around this api.

*/


#ifndef __SMP_MESH__
  //Define the header macro
  #define __SMP_MESH__
  
  //Define TAG macros
  #define TAG_MSG       0
  #define TAG_ACK       1
  #define TAG_BARR      2
  #define TAG_USER      3

  //This is needed fos stuff inside the mesh class
  #include<pthread.h>
  class procBEO;
  class commBEO;
  class pipe3;
  class buffer;
  
  //The mesh class itself
  class meshBEO
  {
    private: int M,N; //Dimensions
             procBEO **proc_mesh; //All procBEOs
             commBEO **comm_mesh; //All commBEOs
               
             pipe3 **pipe_rows, **pipe_cols; //All pipes
             buffer **buff_links; //All buffers
           
             pthread_t **comm_threads; //Holds all commBEO threads
           
    public : meshBEO(); //Default Constructor
             meshBEO(int,int); //Dimensioned constructor
             void setup(int,int); //Post object creation initialization
           
           
           
             //The Proc functionality exposed
             int init(int,int);
             int compute(int,int); //ID, size
             int send(int,int,int,int); //ID, Destination, tag, msg_size
             int send_n(int,int,int,int); //ID, Destination, tag, msg_size
             int recv(int,int,int); //ID, Source, tag
             int compute_m(int,int,int); //ID, M, N
             float smp_clock_gettime(int,struct timespec*); //ID, timespec
           
  };



#endif
