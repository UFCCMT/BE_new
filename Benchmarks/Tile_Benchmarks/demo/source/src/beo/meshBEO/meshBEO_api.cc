#include<beo>

//Init function
int meshBEO::init(int proc_ID, int size)
{
  int x=proc_ID%N;
  int y=proc_ID/N;
  proc_mesh[y][x].init(size);
  return 0;
}



//Compute function
int meshBEO::compute(int proc_ID, int size)
{
  int x=proc_ID%N;
  int y=proc_ID/N;
  proc_mesh[y][x].compute(size);
  return 0;
}


//Compute_m funstion
int meshBEO::compute_m(int proc_ID, int size, int n)
{
  int x=proc_ID%N;
  int y=proc_ID/N;
  proc_mesh[y][x].compute_m(size,n);
  return 0;
}



//Send function
int meshBEO::send(int proc_ID, int dest, int tag, int msg_size) 
{
  int x=proc_ID%N;
  int y=proc_ID/N;
  proc_mesh[y][x].send(dest,tag,msg_size);
  return 0;
}


//Send_n function
int meshBEO::send_n(int proc_ID, int dest, int tag, int msg_size)
{
  int x=proc_ID%N;
  int y=proc_ID/N;
  proc_mesh[y][x].send_n(dest,tag,msg_size);
  return 0;
}


//Recv function
int meshBEO::recv(int proc_ID, int source, int tag)
{
  int x=proc_ID%N;
  int y=proc_ID/N;
  proc_mesh[y][x].recv(source,tag);
  return 0;
}


//Clock function
float meshBEO::smp_clock_gettime(int proc_ID,struct timespec *st)
{
  int x=proc_ID%N;
  int y=proc_ID/N;
  float t=proc_mesh[y][x].clock_gettime();
  st->tv_sec=0;
  st->tv_nsec=t;
  return t;
}








