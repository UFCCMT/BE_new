/**
* @author: Nalini Kumar
* @brief: Embarrassingly parallel matrix multiply kernel from CMT based on pencil-decomposition 
* common in CFD. 3d mat-mult is used for calculating gradient in 3 directions by multiplying 
* volumetric data with gradient matrices. a*U=dudr
*/


#include<header.h>
#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>

#include<sys/types.h>
#include<unistd.h>
#include<signal.h>

//#define DEBUG



//-----------------------------------Globals------------------------------------
//Thread management
extern int nthreads;
extern pthread_t *threads;
extern int *thread_id;
extern int *core_map;
extern int *barrier_map;
extern int xmax, ymax;

//Time measurement and log management
extern char *logfile;
extern double *log_memory;

//Program parameters
extern int E; //No. of elements assigned to each processor
extern int n; //Size of element - must be b/w 5 and 25
extern int iterations;



//------------------------------- TIMER FUNCTION ------------------------------
// Accesses high-res timers and return the time at that instance in microseconds 
double timer() {
  
  struct timespec st;
  double time = 0;
  
  clock_gettime(CLOCK_THREAD_CPUTIME_ID, &st);
  time = (double)st.tv_sec*1e6 + (double)st.tv_nsec*1e-3;

  return time;
}



//--------------------------Thread function-------------------------------------
void *thread_fn(void *arg)
{
	
  //Set cpu and activate udn
  int ID=(*((int*)arg));
  if(tmc_cpus_set_my_cpu(core_map[ID])!=0) {
    printf("Thread: %d CPU setting failed.\n",ID);
    exit(1);
  }
  tmc_udn_activate();

  //calculate x and y co-ordinates
  int id_x=ID%(xmax+1);
  int id_y=ID/(xmax+1);

  //Necessary local variables
  int count, start_addr, iterator;
  DATA_TYPE temp_sum;
  uint_reg_t gather_sig;
  int nwords_bcast, nwords_scatter, nwords_update;

  //Time management variables
//  struct timespec st;
  double zero; //Reference time for iterations
  double bcast_s, bcast_e, bcast_d;
  double scatter_s, scatter_e, scatter_d;
  double compute_s, compute_e, compute_d;
  double transfer_s, transfer_e, transfer_d;
  //double transfer1_s, transfer1_e, transfer1_d;
  //double transfer2_s, transfer2_e, transfer2_d;
  //double transfer3_s, transfer3_e, transfer3_d;
  //double transfer4_s, transfer4_e, transfer4_d;
  double total_time_s, total_time_e, total_time_d;
  double total_time;

  
  //----------------------- Thread memory initialization ----------------------
  //	U - Volumetric data
  //	r - Filter for gradient calculation
  //	dudr - Result of gradient calculation

  DATA_TYPE *U, *r, *dudr;
  int factor=sizeof(uint_reg_t)/sizeof(DATA_TYPE);
  
  if(ID==0) {
    U=(DATA_TYPE*)malloc(n*n*n*E*nthreads*sizeof(DATA_TYPE));	
    r=(DATA_TYPE*)malloc(n*n*sizeof(DATA_TYPE));	
    dudr=(DATA_TYPE*)malloc(n*n*n*E*sizeof(DATA_TYPE));	
  }
  else {
    U=(DATA_TYPE*)malloc(n*n*n*E*sizeof(DATA_TYPE)); 
    r=(DATA_TYPE*)malloc(n*n*sizeof(DATA_TYPE));
    dudr=(DATA_TYPE*)malloc(n*n*n*E*sizeof(DATA_TYPE));
  }
  


  //Perform 'iterations' iterations
  for(iterator=0; iterator<iterations; iterator++)
  { 

    //---------------------Barrier-----------------------------------------------
    barrier(ID);	 

    total_time_s = timer()-zero;


    //----------------------Broadcast r matrix----------------------------------- 
    nwords_bcast=n*n/factor;
    bcast_s = timer();    
    //Broadcast the data in a broadcast tree fashion
    if(id_y==0 && id_x!=0)
      receive126((uint_reg_t*)r,nwords_bcast,core_map[ID-1],UDN0_DEMUX_TAG);
    if(id_y==0 && id_x!=xmax)
      send126((uint_reg_t*)r,nwords_bcast,core_map[ID+1],UDN0_DEMUX_TAG);
    if(id_y!=0)
      receive126((uint_reg_t*)r,nwords_bcast,core_map[ID-xmax-1],UDN0_DEMUX_TAG);
    if(id_y!=ymax && (ID+xmax+1)<nthreads)
      send126((uint_reg_t*)r,nwords_bcast,core_map[ID+xmax+1],UDN0_DEMUX_TAG);
    bcast_e = timer();    
    bcast_d = bcast_e - bcast_s;
#ifdef DEBUG 
if(ID==0) { printf("Iteration %d bcast done. Time taken: %lfus\n ",iterator, bcast_d); } 
#endif

    //------------------------------ Barrier -----------------------------------
    barrier(ID);	 
	
    //-------------------------Scatter U matrix-----------------------------------
    nwords_scatter = n*n*n*E/factor;
    start_addr=n*n*n*E;
    scatter_s = timer();
    if(ID==0) { //Thread 0 sends out all data
        for(count=1; count<nthreads; count++) {
		send126( (uint_reg_t*)(&U[start_addr]), nwords_scatter, core_map[count], UDN0_DEMUX_TAG);
		start_addr+=n*n*n*E;
      }
    }
    else { //Others receive data
      receive126((uint_reg_t*)U, nwords_scatter, core_map[0], UDN0_DEMUX_TAG);
    }
    scatter_e = timer();    
    scatter_d = scatter_e - scatter_s;
#ifdef DEBUG  
if(ID==0) { printf("Iteration %d scatter done. Time taken: %lfus\n  ",iterator, scatter_d); }  
#endif
    
    //------------------------------ Barrier ----------------------------------
    barrier(ID);	 
 
    //---------------------------Compute----------------------------------------
    int ie,x,y,z,l,temp; 
    compute_s = timer();
	for (ie=0; ie <E; ie++) {
  	  for (z=0; z<n; z++) {
	    for (l=0; l<n; l++) {
	      for (x=0; x<n; x++) {
	        for(y=0; y<n; y++) {
		  temp += r[l*n+y] * U[ie*n*n*n + z*n*n + y*n + x];			
		}
		dudr[ie*n*n*n + z*n*n + l*n +x] = temp;
		temp =0;
	      }
	    }
	  }
	}
    compute_e = timer();    
    compute_d = compute_e - compute_s;
#ifdef DEBUG  
if(ID==0) { printf("Iteration %d compute done. Time taken: %lfus\n",iterator,compute_d); }  
#endif    

    //------------------------------ Barrier ----------------------------------
    barrier(ID);

    //------------------------- Send data to neighbors ------------------------
    nwords_update = n*n*E/factor; //n*n face for each element assigned to a thread

    // Transfer bottom to top
    // Odd numbered rows send to even numbered rows first and then vice versa
    transfer_s = timer();  
    if(id_y%2==0){
      if(id_y!=ymax) { 
        receive126((uint_reg_t*)dudr,nwords_update,core_map[ID+(xmax+1)],UDN0_DEMUX_TAG);
      }
      if(id_y!=0) {
//        printf("ID:%d ---> %d \n", ID,ID-(xmax+1)); 
        send126((uint_reg_t*)dudr,nwords_update, core_map[ID-(xmax+1)],UDN0_DEMUX_TAG);
      }

    }
    else {
//      printf("ID:%d ---> %d \n", ID,ID-(xmax+1)); 
      send126((uint_reg_t*)dudr,nwords_update,core_map[ID-(xmax+1)],UDN0_DEMUX_TAG);
      if(id_y!=ymax) {
	receive126((uint_reg_t*)dudr,nwords_update,core_map[ID+(xmax+1)],UDN0_DEMUX_TAG);
      }

    }
    //transfer1_e = timer();
    //transfer1_d = transfer1_e - transfer1_s;
#ifdef DEBUG  
if(ID==0){ printf("Iteration %d transfer1 done. Time taken: %lfus\n",iterator, transfer1_d); }  
#endif    

    //---------------------Barrier----------------------------------------------
    barrier(ID);
#ifdef DEBUG 
printf("ID: %i finished barrier\n",ID);
#endif   
    // Transfer for top to bottom
	// Even numbered rows send to odd numbered rows first and then vice versa
	//transfer2_s = timer();  
	if(id_y%2==0) { 
	  if(id_y!= ymax) {
//	    printf("ID:%d ---> %d \n", ID,ID+(xmax+1));
 	    send126((uint_reg_t*)dudr,nwords_update,core_map[ID+(xmax+1)],UDN0_DEMUX_TAG);
	  }
	  if(id_y!=0) {
 	  receive126((uint_reg_t*)dudr,nwords_update,core_map[ID-(xmax+1)],UDN0_DEMUX_TAG);
	  }
	}
	else {
	  receive126((uint_reg_t*)dudr,nwords_update,core_map[ID-(xmax+1)],UDN0_DEMUX_TAG);
          if(id_y!=ymax) {
//	    printf("ID:%d ---> %d \n", ID,ID+(xmax+1));
 	    send126((uint_reg_t*)dudr,nwords_update,core_map[ID+(xmax+1)],UDN0_DEMUX_TAG);
	  }
	}
#ifdef DEBUG 
	printf("ID: %i is done transferring\n",ID);
#endif
	//transfer2_e = timer();
	//transfer2_d = transfer2_e - transfer2_s;
#ifdef DEBUG
    if(ID==0){ printf("Iteration %d transfer2 done. Time taken: %lfus\n",iterator, transfer2_d); }
#endif    

   //---------------------Barrier----------------------------------------------
    barrier(ID);
	
    //Transfer from right to left
	// Odd numbered cols send to even numbered cols first and then vice versa
	//transfer3_s = timer();  
	if(id_x%2==0) { 
	   if(id_x!= xmax) {
	     receive126((uint_reg_t*)dudr,nwords_update,core_map[ID+1],UDN0_DEMUX_TAG);
	   }
	   if(id_x!=0) {
//             printf("ID:%d ---> %d \n", ID,ID-1);
	     send126((uint_reg_t*)dudr,nwords_update,core_map[ID-1],UDN0_DEMUX_TAG);
	   }
	}
	else {
//           printf("ID:%d ---> %d \n", ID,ID-1);
	   send126((uint_reg_t*)dudr,nwords_update,core_map[ID-1],UDN0_DEMUX_TAG);
        if(id_x!=xmax) {
	     receive126((uint_reg_t*)dudr,nwords_update,core_map[ID+1],UDN0_DEMUX_TAG);
	   }
	}
	//transfer3_e = timer();
	//transfer3_d = transfer3_e - transfer3_s;
#ifdef DEBUG
    if(ID==0) { printf("Iteration %d transfer3 done. Time taken: %lfus\n",iterator,transfer3_d); }
#endif    
	
    //---------------------Barrier----------------------------------------------
    barrier(ID);

	//Transfer from left to right
	// Even numbered cols send to odd numbered cols first and then vice versa
	//transfer4_s = timer();  
	if(id_x%2==0) { 
	   if(id_x!= xmax) {
//	     printf("ID:%d ---> %d \n",ID,ID+1);
	     send126((uint_reg_t*)dudr,nwords_update,core_map[ID+1],UDN0_DEMUX_TAG);
	   }
	   if(id_x!=0){
	     receive126((uint_reg_t*)dudr,nwords_update,core_map[ID-1],UDN0_DEMUX_TAG);
	   }
	}
	else {
	   receive126((uint_reg_t*)dudr,nwords_update,core_map[ID-1],UDN0_DEMUX_TAG);
           if(id_x!=xmax) {
//	     printf("ID:%d ---> %d \n",ID,ID+1);
	     send126((uint_reg_t*)dudr,nwords_update,core_map[ID+1],UDN0_DEMUX_TAG);
	   }
	}
	//transfer4_e = timer();
	//transfer4_d = transfer4_e - transfer4_s;
	transfer_e = timer();
	transfer_d = transfer_e - transfer_s;
#ifdef DEBUG
    if(ID==0)
    {
      printf("Iteration %d transfer4 done\n",iterator);
      printf("Time taken: %lfus\n",transfer4_d);
    }
#endif    	
	
    //---------------------Barrier----------------------------------------------
    barrier(ID);
	
    total_time_e = timer();
    total_time_d = (total_time_e - total_time_s);
    total_time += total_time_d;

    //---------------------------Log the data-----------------------------------
    log_memory[iterator*nthreads*5+ID*5+BCAST_D]=bcast_d;
    log_memory[iterator*nthreads*5+ID*5+SCA_D]=scatter_d;
    log_memory[iterator*nthreads*5+ID*5+COMP_D]=compute_d;
	log_memory[iterator*nthreads*5+ID*5+XFER_D]=transfer_d;
    //log_memory[iterator*nthreads*8+ID*8+XFER1_D]=transfer1_d;
    //log_memory[iterator*nthreads*8+ID*8+XFER2_D]=transfer2_d;
    //log_memory[iterator*nthreads*8+ID*8+XFER3_D]=transfer3_d;
    //log_memory[iterator*nthreads*8+ID*8+XFER4_D]=transfer4_d;
    log_memory[iterator*nthreads*5+ID*5+TOT_D]=total_time_d;
  
    //---------------------Barrier----------------------------------------------
    barrier(ID);

#ifdef DEBUG
    if(ID==0) { printf("Iteration %d ALL done.\n",iterator); }
#endif
	
  }
    
//#ifdef DEBUG
    if(ID==0) { printf("Time per iteration %lf\n\n", total_time/iterations); }
//#endif    
     

  
  //Free thread local memory
  free(U);
  free(r);
  free(dudr);
  
  
  pthread_exit(NULL);
}



//------------- Watchdog -------------------------------------------------

void *watchdog(void *arg)
{
  long int count=0;
  while(1)
  {
    if(count%5==0)
    {
      printf("running even now %d sec.\n",count);
      system("touch watchdog_file");
    }
    count++;
    sleep(1);
  }
}












	   
  
  
  
  
