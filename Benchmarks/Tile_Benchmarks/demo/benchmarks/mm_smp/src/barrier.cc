#include<smp/mesh.h>
#include<cstdio>
#define UDN0_DEMUX_TAG TAG_USER+0
#define UDN1_DEMUX_TAG TAG_USER+1
#define UDN2_DEMUX_TAG TAG_USER+2
#define UDN3_DEMUX_TAG TAG_USER+3

extern int n_meshrows, n_meshcols;
extern meshBEO M;

//int core_map[]={0 ,1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10 ,11 ,12 ,13 ,14 ,15 ,16 ,17 ,18 ,19 ,20 ,21 ,22 ,23 ,24 ,25 ,26 ,27 ,28 ,29 ,30 ,31 ,32 ,33 ,34 ,35 ,36 ,37 ,38 ,39 ,40 ,41 ,42 ,43 ,44 ,45 ,46 ,47 ,48 ,49 ,50 ,51 ,52 ,53 ,54 ,55 ,56 ,57 ,58 ,59 ,60 ,61 ,62 ,63 ,64 ,65 ,66 ,67 ,68 ,69 ,70 ,71 ,72 ,73 ,74 ,75 ,76 ,77 ,78 ,79 ,80 ,81 ,82 ,83 ,84 ,85 ,86 ,87 ,88 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,96 ,97 ,98 ,99}; 

//int barrier_map[]={1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10 ,11 ,12 ,13 ,14 ,15 ,16 ,17 ,18 ,19 ,20 ,21 ,22 ,23 ,24 ,25 ,26 ,27 ,28 ,29 ,30 ,31 ,32 ,33 ,34 ,35 ,36 ,37 ,38 ,39 ,40 ,41 ,42 ,43 ,44 ,45 ,46 ,47 ,48 ,49 ,50 ,51 ,52 ,53 ,54 ,55 ,56 ,57 ,58 ,59 ,60 ,61 ,62 ,63 ,64 ,65 ,66 ,67 ,68 ,69 ,70 ,71 ,72 ,73 ,74 ,75 ,76 ,77 ,78 ,79 ,80 ,81 ,82 ,83 ,84 ,85 ,86 ,87 ,88 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,96 ,97 ,98 ,99,0}; 

//int core_map[]=    {0, 1 ,2, 3, 4 ,5 ,6, 7, 8 ,9 ,10, 11 ,12 ,13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24 ,25 ,26, 27, 28 ,29, 30, 31 ,32 ,33 ,34 ,35};
//int barrier_map[]=  {1 ,2, 3, 4 ,5 ,11, 0, 13, 7 ,8, 9 ,10, 6, 14, 15, 16 ,17, 23, 12, 25 ,19, 20 ,21 ,22 ,18, 26,27 ,28 ,29 ,35, 24, 30, 31 ,32, 33 ,34};


int *core_map=new int [1000];
int *barrier_map=new int[1000];



void barrier(int ID)
{
  int nthreads=n_meshrows*n_meshcols;
  for(int count=0; count<nthreads; count++)
  {
    core_map[count]=count;
  }


  for(int count=0; count<nthreads-1; count++)
  {
    barrier_map[count]=count+1;
  }

  barrier_map[nthreads-1]=0;
  
  
  int rank=0;
  for(int count=0; count<nthreads; count++)
  {
    if(barrier_map[count]==core_map[ID])
    {
      rank=count;
      break;
    }
  }
  
  
  if(core_map[ID]==0)
  {
    M.send_n(core_map[ID],barrier_map[0],UDN1_DEMUX_TAG,1);
  }
  
  M.recv(core_map[ID],core_map[rank],UDN1_DEMUX_TAG);
  
  if(core_map[ID]!=0)
  {
    
    M.send_n(core_map[ID],barrier_map[ID],UDN1_DEMUX_TAG,1);
  }
  
}  
  
  /*
  
  
  
  
  
  
void barrier(int ID)
{
  int nthreads=n_meshrows*n_meshcols;
  if(ID==0)
  {
    for(int count=1; count<nthreads; count++)
      M.send_n(0,count,UDN1_DEMUX_TAG,1);
  }
  else
  {
    M.recv(ID,0,UDN1_DEMUX_TAG);
    printf("Node %d hit barrier\n",ID);
  }
}




*/








  
  

