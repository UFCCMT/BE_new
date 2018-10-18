#include<beo>
#include<iostream>
#include<pthread.h>



//------------------------------------------------------------------------------
//------------------------Comm BEO Thread---------------------------------------
//------------------------------------------------------------------------------
void *commBEO_thread_fn(void *arg)
{
  commBEO* comm_ID=((commBEO*)arg);
  comm_ID->execute();
  pthread_exit(NULL);
}









//------------------------------------------------------------------------------
//---------------------------Constructors---------------------------------------
//------------------------------------------------------------------------------
meshBEO::meshBEO()
{
  M=-1;
  N=-1;
}

meshBEO::meshBEO(int nrows, int ncols)
{
  //Step1: According to dimensions, create the BEOs, pipes, etc
  
  M=nrows;
  N=ncols;
  proc_mesh    =new procBEO*[nrows]   ;
  comm_mesh    =new commBEO*[nrows]   ;
  buff_links   =new buffer*[nrows]    ;
  pipe_cols    =new pipe3*[nrows-1]   ;
  pipe_rows    =new pipe3*[nrows]     ;
  comm_threads =new pthread_t*[nrows] ;
  
  
  for(int count=0; count<nrows; count++)
  {
    proc_mesh[count]  =new   procBEO[ncols]    ;
    comm_mesh[count]  =new   commBEO[ncols]    ;
    buff_links[count] =new   buffer[ncols]     ;
    comm_threads[count] =new pthread_t[ncols] ;
  }
  
  
  for(int count=0; count<nrows-1; count++)
  {
    pipe_cols[count]=new pipe3[ncols];
  }
  
  for(int count=0; count<nrows; count++)
  {
    pipe_rows[count]=new pipe3[ncols-1];
  }
  
  
  
  //Step 2: Now map resources to the BEOs
  int temp_id=0;
  pipe3 *temp_pipes[4];
  comm_beo_interface plug;
  plug.M=ncols;
  plug.N=nrows;
  
  for(int y=0; y<nrows; y++)
  {
    for(int x=0; x<ncols; x++)
    {
      //Initialize a procBEO
      proc_mesh[y][x].setup(temp_id,&buff_links[y][x]);
      
      //Initialize the corresponding commBEO
      //Set up east pipes for commBEO
      if(x==ncols-1)
        temp_pipes[EAST]=NULL;
      else
        temp_pipes[EAST]=&pipe_rows[y][x];
        
      //Set up west pipes for commBEO
      if(x==0)
        temp_pipes[WEST]=NULL;
      else
        temp_pipes[WEST]=&pipe_rows[y][x-1];
        
      //Set up north pipes
      if(y==0)
        temp_pipes[NORTH]=NULL;
      else
        temp_pipes[NORTH]=&pipe_cols[y-1][x];
      
      //Set up south pipes  
      if(y==nrows-1)
        temp_pipes[SOUTH]=NULL;
      else
        temp_pipes[SOUTH]=&pipe_cols[y][x];
          
      comm_mesh[y][x].setup(temp_pipes,&buff_links[y][x],temp_id,&plug);
      
      temp_id++;
    }
  }
  
  
  //Step 3: Start the commBEO threads
  for(int y=0; y<nrows; y++)
  {
    for(int x=0; x<ncols; x++)
    {
      pthread_create(&comm_threads[y][x],NULL,commBEO_thread_fn,(void*)(&comm_mesh[y][x]));
    }
  }
}







//------------------------------------------------------------------------------
//---------------------------Post object setup----------------------------------
//------------------------------------------------------------------------------
void meshBEO::setup(int nrows, int ncols)
{
  //Step1: According to dimensions, create the BEOs, pipes, etc
 
  proc_mesh    =new procBEO*[nrows]   ;
  comm_mesh    =new commBEO*[nrows]   ;
  buff_links   =new buffer*[nrows]    ;
  pipe_cols    =new pipe3*[nrows-1]   ;
  pipe_rows    =new pipe3*[nrows]     ;
  comm_threads =new pthread_t*[nrows] ;
  
  
  for(int count=0; count<nrows; count++)
  {
    proc_mesh[count]  =new   procBEO[ncols]    ;
    comm_mesh[count]  =new   commBEO[ncols]    ;
    buff_links[count] =new   buffer[ncols]     ;
    comm_threads[count] =new pthread_t[ncols] ;
  }
  
  
  for(int count=0; count<nrows-1; count++)
  {
    pipe_cols[count]=new pipe3[ncols];
  }
  
  for(int count=0; count<nrows; count++)
  {
    pipe_rows[count]=new pipe3[ncols-1];
  }
  
  
  
  //Step 2: Now map resources to the BEOs
  int temp_id=0;
  pipe3 *temp_pipes[4];
  comm_beo_interface plug;
  plug.M=nrows;
  plug.N=ncols;
  
  for(int y=0; y<nrows; y++)
  {
    for(int x=0; x<ncols; x++)
    {
      //Initialize a procBEO
      proc_mesh[y][x].setup(temp_id,&buff_links[y][x]);
      
      //Initialize the corresponding commBEO
      //Set up east pipes for commBEO
      if(x==ncols-1)
        temp_pipes[EAST]=NULL;
      else
        temp_pipes[EAST]=&pipe_rows[y][x];
        
      //Set up west pipes for commBEO
      if(x==0)
        temp_pipes[WEST]=NULL;
      else
        temp_pipes[WEST]=&pipe_rows[y][x-1];
        
      //Set up north pipes
      if(y==0)
        temp_pipes[NORTH]=NULL;
      else
        temp_pipes[NORTH]=&pipe_cols[y-1][x];
      
      //Set up south pipes  
      if(y==nrows-1)
        temp_pipes[SOUTH]=NULL;
      else
        temp_pipes[SOUTH]=&pipe_cols[y][x];
          
      comm_mesh[y][x].setup(temp_pipes,&buff_links[y][x],temp_id,&plug);
      
      temp_id++;
    }
  }
  
  
  //Step 3: Start the commBEO threads
  for(int y=0; y<nrows; y++)
  {
    for(int x=0; x<ncols; x++)
    {
      pthread_create(&comm_threads[y][x],NULL,commBEO_thread_fn,(void*)(&comm_mesh[y][x]));
    }
  }
}








