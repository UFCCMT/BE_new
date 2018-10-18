#include<tmc/cpus.h>
#include<tmc/udn.h>
#include<pthread.h>
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<time.h>
#include<unistd.h>



#define N_THREADS 2
#define DATA_TYPE int
#define MAIN 0
#define UPPER 20
#define LOWER 10

#define __REENTRANT







//---------------------------globals------------------------------------
//Thread maintainence stuff,
pthread_t *threads;
int *thread_id;
int x_max,y_max;

//Barrier implementation
int *list, *bar_list;



//Parameters
int nthreads=36;
int matrix_size=36;
long iterations=1000;


//Time keeping
double malloc_t, bcast_B, scatter_A, compute, gather_C;

//Data logging
char *fname;
double *datalog;









  
  
  int list_2[]      ={0,1};
  int bar_list_2[]  ={1,0};
  
  int list_4[]      ={0,1,6,7};
  int bar_list_4[]  ={1,7,0,6};
  
  int list_8[]      ={0,1,2,3,6,7,8,9};
  int bar_list_8[]  ={1,2,3,9,0,6,7,8};
  
  int list_9[]      ={0,1,2,6,7,8,12,13,14};
  int bar_list_9[]  ={1,2,8,7,0,14,6,12,13};
  
  int list_16[]     ={0,1,2,3,6,7,8,9,12,13,14,15,18,19,20,21};
  int bar_list_16[] ={1,2,3,9,0,13,7,8,6,14,15,21,12,18,19,20};
  
  int list_25[]     ={0,1,2,3,4,6,7,8,9,10,12,13,14,15,16,18,19,20,21,22,24,25,26,27,28};
  int bar_list_25[] ={1,2,3,4,10,7,8,9,0,16,6,12,13,14,22,19,20,21,15,28,18,24,25,26,27};
  
  int list_32[]     ={0,1,2,3,4,5 ,6 ,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};
  int bar_list_32[] ={1,2,3,4,5,11,0,13,7,8, 9,10, 6,14,15,16,17,23,12,25,19,20,21,22,18,26,27,28,29,31,24,30};
  
  int list_36[]     ={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35};
  int bar_list_36[] ={1,2,3,4,5,11,0,13,7,8,9,10,6,14,15,16,17,23,12,25,19,20,21,22,18,26,27,28,29,35,24,30,31,32,33,34};
  
  
  
  
  
  
  
  
  
  
  
  
 


//-------------------------Init function-------------------------------
void init(int argc, char *argv[])
{
  int count; //Temporary counter variable
  
  //Parse command line args and override the defaults
  if(argc>1)  matrix_size = atoi(argv[1]);
  if(argc>2)  nthreads    = atoi(argv[2]);
  if(argc>3)  iterations  = atoi(argv[3]);
  if(argc>4)  fname       = argv[4];
  else        fname="logfile.csv";
  
  //Setup the correct barrier list
  if(nthreads==2 ) list=list_2 , x_max=1, y_max=0, bar_list=bar_list_2 ;
  if(nthreads==4 ) list=list_4 , x_max=1, y_max=1, bar_list=bar_list_4 ;
  if(nthreads==8 ) list=list_8 , x_max=3, y_max=1, bar_list=bar_list_8 ;
  if(nthreads==9 ) list=list_9 , x_max=2, y_max=2, bar_list=bar_list_9 ;
  if(nthreads==16) list=list_16, x_max=3, y_max=3, bar_list=bar_list_16;
  if(nthreads==25) list=list_25, x_max=4, y_max=4, bar_list=bar_list_25;
  if(nthreads==32) list=list_32, x_max=5, y_max=5, bar_list=bar_list_32;
  if(nthreads==36) list=list_36, x_max=5, y_max=5, bar_list=bar_list_36;
  
  
  
  //Initialize the thread ID array
  threads=malloc(nthreads*sizeof(pthread_t));
  thread_id=malloc(nthreads*sizeof(int));
  
  for(count=0; count<nthreads; count++)
    thread_id[count]=list[count];
  
  //Initialize the data log memory  
  datalog=(double*)malloc(nthreads*12*iterations*sizeof(double));
    
  
}





//-----------------------------Thread function--------------------------------
void *thread_fn(void *arg)
{
  //Thread variables
  DATA_TYPE *A, *B, *C, *temp;
  int ID, x, y,rank; //The rank is the virtual ID and the ID is the real core ID of the thread
  struct timespec st, temp_z;
  double zero; //This is the variable that holds the reference time in each iteration of the benchmark
  
  
  int count, count1, count2;
  int NOW=matrix_size*matrix_size*sizeof(DATA_TYPE)/sizeof(uint_reg_t); //NOW stands for Number of Words. It has nothing to do with time.
  uint_reg_t bcast_sig=ID;
  
  
  //Time keeping variables
  double time;
  int i, rank_i;
  double BCASTB_S=0, BCASTB_E=0, SCA_S=0, SCA_E=0, CMP_S=0,CMP_E=0,GATHC_S=0,GATHC_E=0;
  
  //Obtain ID
  ID=(*((int*)arg));
  
  
  
  //Quick fix for data logging (may be ugly)
  for(rank_i=0; rank_i<nthreads;rank_i++)
  {
    if(thread_id[rank_i]==ID)
         rank=rank_i;
  }
  
  
  
  
  //Set cpu and activate udn
  if(tmc_cpus_set_my_cpu(ID)!=0)
  {
    printf("Thread: %d CPU setting failed.\n",ID);
    exit(1);
  }
  tmc_udn_activate();
  
  
  
  //get x, y coordinates
  x=rank%(x_max+1);
  y=rank/(x_max+1);
  
  
  
  
  //Allocate local memory 
  B=malloc(matrix_size*matrix_size*sizeof(DATA_TYPE));
  if(ID==MAIN)
  {
    A=malloc(matrix_size*matrix_size*sizeof(DATA_TYPE));
    C=malloc(matrix_size*matrix_size*sizeof(DATA_TYPE));
  }
  else
  {
    A=malloc((matrix_size*matrix_size+1)*sizeof(DATA_TYPE)/nthreads);
    C=malloc((matrix_size*matrix_size+1)*sizeof(DATA_TYPE)/nthreads);
  }
  if(A==NULL || B==NULL || C==NULL)
    printf("Error allocating memory\n");  

  


  //Initialize arrays in MAIN
  if(ID==MAIN)
  {
    for(count=0; count<matrix_size*matrix_size; count++)
    {
      (*(A+count))=rand(); //(DATA_TYPE)((float)(UPPER-LOWER)*(float)rand()/(float)RAND_MAX);
      (*(B+count))=rand(); //(DATA_TYPE)((float)(UPPER-LOWER)*(float)rand()/(float)RAND_MAX);
      (*(C+count))=0;
      
    }
  }
  
  
 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
//------------------------------------------------------------------------------//
//----------------------------------------*Iterate over a lot oftimes*----------//
//------------------------------------------------------------------------------//
  
  for(i=0; i<iterations; i++)
  {
  
  
  //-------------------------Set reference time ----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  zero=(double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;  
  
  
  
  
  
  
  
  
  
   
  //----------------Broadcast B matrix---------------------
  //-------------------------------------------------------
  
  //----------------------***Time start***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  BCASTB_S=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  
  
  //Step 1: B is propagated right
  if(y==0 && x!=0)
    receive126(B,NOW,list[rank-1],UDN0_DEMUX_TAG);
    
  if(y==0 && x!=x_max )
    send126(B,NOW,list[rank +1],UDN0_DEMUX_TAG);
    

  
  
  //Step 2 a: B is propagated downward
  if(y!=0)
    receive126(B,NOW,list[rank-x_max-1],UDN0_DEMUX_TAG);
  
  if(y!=y_max && (rank + x_max+1)<nthreads)
    send126(B,NOW,list[rank+x_max+1],UDN0_DEMUX_TAG);
    
  
  
  //----------------------***Time end***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  BCASTB_E=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 0))= BCASTB_S;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 1))=BCASTB_E;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 2))=(BCASTB_E-BCASTB_S);
  
  
  
  
  
  if(ID==MAIN) 
  printf("%d\t%d\t%d\tBCAST\n",matrix_size,nthreads,i);
  
  
  
  
  
  
 
  
  //------------------Less shitty implementation of barrier---------------------
  //----------------------------------------------------------------------------
  
  
  if(ID==MAIN)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(1);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
  
  bcast_sig=tmc_udn1_receive();
  
  if(ID!=MAIN)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(bar_list[rank]);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
  
  
  
  if(ID==MAIN)
  printf("%d\t%d\t%d\tBARRIER\n",matrix_size,nthreads,i);
  
  
  
  
  
  
  
  

  
  
  
  
  
  //------------------------Scatter A matrix------------------------------------
  //----------------------------------------------------------------------------
  
  
  //----------------------***Time start***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  SCA_S=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  
 
  
  
  
  //Main sends out matrix A to other threads serially
  if(ID==MAIN)
  {
    int start_addr=matrix_size*matrix_size/nthreads;
    for(count=1; count<nthreads; count++)
    {
      if(count<matrix_size%nthreads)
      {
        send126(&A[start_addr],NOW/(nthreads)+1,thread_id[count],UDN0_DEMUX_TAG);
        start_addr+=matrix_size*matrix_size/nthreads+1;
      }
      else
      {
        send126(&A[start_addr],(NOW/nthreads),thread_id[count],UDN0_DEMUX_TAG);
        start_addr+=matrix_size*matrix_size/nthreads+1;
      }
      
    }
    
  }
  
  //Others receive
  else
  {
    
    if(rank<matrix_size%nthreads)
      receive126(A,NOW/(nthreads)+1,MAIN,UDN0_DEMUX_TAG);
    else
      receive126(A,(NOW/nthreads),MAIN,UDN0_DEMUX_TAG);
  }
  
  //----------------------***Time end***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  SCA_E=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 3))=SCA_S;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 4))=SCA_E;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 5))=(SCA_E-SCA_S);
  
  
  
  
  
  
  
  
  if(ID==MAIN)
  printf("%d\t%d\t%d\tSCATTER\n",matrix_size,nthreads,i);
  
  
  
  
  
  
  
  
  //--------------------------Barrier-------------------------------------------
  //----------------------------------------------------------------------------
  
  if(ID==MAIN)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(1);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
  
  bcast_sig=tmc_udn1_receive();
  
  if(ID!=MAIN)
  {
    DynamicHeader header= tmc_udn_header_from_cpu(bar_list[rank]);
    tmc_udn_send_1(header,UDN1_DEMUX_TAG,bcast_sig);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  //-----------------------COMPUTE----------------------------------------------
  //----------------------------------------------------------------------------
  
  //----------------------***Time start***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  CMP_S=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  
  DATA_TYPE *temp_A=A, *temp_B;
  DATA_TYPE *temp_C=C;
  
  
  
  //Start computation!!
  for(count2=0; count2<matrix_size/nthreads; count2++)
  {
    temp_B=B;
    
    for(count1=0; count1<matrix_size; count1++)
    {  
      for(count=0; count<matrix_size; count++)
        (*(temp_C+count1))+=(*(temp_A+count))*(*(temp_B+count));
       
      temp_B+=matrix_size;
    }    
    temp_A+=matrix_size;
    temp_C+=matrix_size;
  }
  
  //----------------------***Time end***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  CMP_E=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 6))=CMP_S;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 7))=CMP_E;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 8))=(CMP_E-CMP_S);
  
  if(ID==MAIN)
  printf("%d\t%d\t%d\tCOMPUTE\n",matrix_size,nthreads,i);
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  //----------------------Gather C matrix---------------------------------------
  //----------------------------------------------------------------------------
  
  //----------------------***Time start***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  GATHC_S=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  
  
  if(ID==MAIN)
  {
    temp_C=C+matrix_size*matrix_size/nthreads;
    for(count=1; count<nthreads; count++)
    {
      //Signal a certain thread
      DynamicHeader header= tmc_udn_header_from_cpu(*(thread_id+count));
      tmc_udn_send_1(header,UDN2_DEMUX_TAG,bcast_sig);
      
      //Receive data from that thread
      if(count<matrix_size%nthreads)
      {
        receive126(temp_C,NOW/nthreads,*(thread_id+count),UDN0_DEMUX_TAG);
        temp_C+=matrix_size*matrix_size/nthreads;
      }
      else
      {
        receive126(temp_C,NOW/nthreads+ NOW%nthreads,*(thread_id+count),UDN0_DEMUX_TAG);
        //temp_C+=matrix_size*matrix_size/nthreads+matrix_size*(matrix_size%nthreads);
        temp_C+=matrix_size*matrix_size/nthreads+1;
      }
   
      
    }
  }
  else
  {
    //Receive signal
    bcast_sig=tmc_udn2_receive();
    
    
    //Send
    if(rank<matrix_size%nthreads)
      send126(C,NOW/nthreads,MAIN,UDN0_DEMUX_TAG);
    else
      send126(C,NOW/nthreads+NOW%nthreads,MAIN,UDN0_DEMUX_TAG);
  }
  
  
  //----------------------***Time end***----------------------------
  clock_gettime(CLOCK_THREAD_CPUTIME_ID,&st);
  GATHC_E=((double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3)-zero;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 9))=GATHC_S;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 10))=GATHC_E;
  *(datalog  +  (i*nthreads*12)  +  (rank*12 + 11))=(GATHC_E-GATHC_S);
  
  if(ID==MAIN)
    printf("%d\t%d\t%d\tCOMPUTE\n",matrix_size,nthreads,i);
  
  
  
  
  
  
  
  
  //--------------------------Barrier-------------------------------------------
  //----------------------------------------------------------------------------
  if(ID==MAIN)
  {
    for(count=1; count<nthreads; count++)
      bcast_sig=tmc_udn2_receive();
  }
  else
  {
    DynamicHeader header= tmc_udn_header_from_cpu(MAIN);
    tmc_udn_send_1(header,UDN2_DEMUX_TAG,bcast_sig);
  }
  
  
  
  
  
  
  
  //To check if program is stuck
  if(ID==MAIN)
      printf("Iteration: %d\n",i);
  
  
  
  
 
  }
  //----------------------------------------------------------------------------
  //----------------------------------------*End of iterations*-----------------
  //----------------------------------------------------------------------------
  
  
  
  
 
  //Finalize
  //free(A);
  //free(B);
  //free(C);
  
  //----------------------------------------------------------------------------
  //------------------------------------------------*Export to file*------------
  //----------------------------------------------------------------------------
  /*if(ID==MAIN)
  {
    FILE *fp;
    if((fp=fopen(fname,"w"))==NULL)
    {
      printf("Could not open logfile..\n");
    }
    else
    {
    
      for(count=0; count<nthreads; count++)
      {
        fprintf(fp,"T%dBCASTB_S,",count);
        fprintf(fp,"T%dBCASTB_E,",count);
        fprintf(fp,"T%dBCASTB_D,",count);
        fprintf(fp,"T%dSCA_S,",count);
        fprintf(fp,"T%dSCA_E,",count);
        fprintf(fp,"T%dSCA_D,",count);
        fprintf(fp,"T%dCMP_S,",count);
        fprintf(fp,"T%dCMP_E,",count);
        fprintf(fp,"T%dCMP_D,",count);
        fprintf(fp,"T%dGATHC_S,",count);
        fprintf(fp,"T%dGATHC_E,",count);
        if(count<nthreads-1)
          fprintf(fp,"T%dGATHC_D,",count);
        else
          fprintf(fp,"T%dGATHC_D\n",count);
      }
      for(count=0; count<iterations; count++)
      {
        for(count1=0; count1<nthreads*12; count1++)
        {
          fprintf(fp,"%lf",*(datalog+count*nthreads*12+count1));
          if(count1<nthreads*12-1)
            fprintf(fp,",  ");
        }
        fprintf(fp,"\n");
      }
      fclose(fp);
    }
  }*/
  if(ID==0)
  printf("Finished\n\n");
  pthread_exit(NULL);
}

















int main(int argc, char *argv[])
{
  int count;
  int *retval;
  
  
  //Manipulate cpu set and create a hardwall
  cpu_set_t set;
  tmc_cpus_clear(&set);
  
  tmc_cpus_add_cpu(&set,0);
  tmc_cpus_add_cpu(&set,35);

  tmc_udn_init(&set);  
  
  //Initialize
  init(argc, argv);
  
  
  //Ctrate threads
  for(count=0; count<nthreads; count++)
    pthread_create((threads+count),NULL,thread_fn,(void*)(thread_id+count));
    
  for(count=0; count<nthreads; count++)
    pthread_join(*(threads+count),(void**)&retval);
    
  
}








