#include<header.h>
#include<cstdlib>
#include<cstdio>
#include<pthread.h>
#include<cstring>

//-----------------------------------Globals------------------------------------
//Thread management
extern int nthreads;
extern pthread_t *threads;
extern int *thread_id;
extern int *core_map;
extern int *barrier_map;
extern int xmax,ymax;



//Time measurement and log management
extern char *logfile;
extern double *log_memory;



//Program parameters
extern int nrows, ncols;
extern int iterations;







void init(int argc, char *argv[])
{
  if(argc<5)
  {
    printf("Usage: ./sobel <config_filename> <nrows> <ncols> <iterations> <log_filename>\n");
    exit(EXIT_FAILURE);
  }
  
  
  nthreads=-1;
  nrows=-1;
  ncols=-1;
  xmax=-1;
  
  char temp_word[20]; //Temporary variable to hold words
  int  temp_id[36]; //To hold mapping, barrier, etc
  int  temp_count; //General temporary variable 
  
  
  
  
  //Open config file
  printf("Trying to read the config file.....\n");
  FILE *config_file=fopen(argv[1],"r"); 
  if(config_file==NULL)
  {
    printf("Configuration file not found. Quiting.\n");
    exit(1);
  }
  
  
  
  
  //Parse the file for no. of processes
  while(!feof(config_file))
  {
    fscanf(config_file,"%s",temp_word);
    if(strcmp(temp_word,"NTHREADS")==0)
    {
      fscanf(config_file,"%s",temp_word);
      nthreads=atoi(temp_word);
      break;
    }
  }
  if(nthreads==-1)
  {
    printf("Invalid no. of processes. Quiting.\n");
    exit(1);
  }
  rewind(config_file);
  
  
  
  
  
  //Parse the file for  xmax
  while(!feof(config_file))
  {
    fscanf(config_file,"%s",temp_word);
    if(strcmp(temp_word,"XMAX")==0)
    {
      fscanf(config_file,"%s",temp_word);
      xmax=atoi(temp_word);
      break;
    }
  }
  if(xmax==-1)
  {
    printf("Invalid xmax. Quiting.\n");
    exit(1);
  }
  rewind(config_file);
  
  if(nthreads%xmax==0)
    ymax=nthreads/xmax-1;
  else
    ymax=nthreads/xmax;
  xmax=xmax-1;
  
 
 
   
  
  //Parse the file for the map of real vs virtual cores
  temp_count=0;
  core_map    = (int*)malloc(sizeof(int)*nthreads);
  thread_id   = (int*)malloc(sizeof(int)*nthreads);
  barrier_map = (int*)malloc(sizeof(int)*nthreads);
  threads     = (pthread_t*)malloc(sizeof(pthread_t)*nthreads);
  
  for(;temp_count<nthreads; temp_count++)
    thread_id[temp_count]=temp_count;
  
  
    
  temp_count=0;
    
  while(!feof(config_file))
  {
    fscanf(config_file,"%s",temp_word);
    if(strcmp(temp_word,"CORE_MAP")==0)
    {
      while(temp_count<nthreads && !feof(config_file))
      {
        fscanf(config_file,"%s",temp_word);
        core_map[temp_count]=atoi(temp_word);
        temp_count++;
      }
      if(temp_count<nthreads)
      {
        printf("No. of elements in core map does not match the no. of processes. Quitting\n");
        exit(1);
      }
      break;
    }
  }
  
  
  
  //Parse the file for the map barriers
  temp_count=0;
  
  while(!feof(config_file))
  {
    fscanf(config_file,"%s",temp_word);
    if(strcmp(temp_word,"BARRIER_MAP")==0)
    {
      while(temp_count<nthreads && !feof(config_file))
      {
        fscanf(config_file,"%s",temp_word);
        barrier_map[temp_count]=atoi(temp_word);
        temp_count++;
      }
      if(temp_count<nthreads)
      {
        printf("No. of elements in barrier map does not match the no. of processes. Quitting\n");
        exit(1);
      }
      break;
    }
  }
  
  
  
  
  //Close the file
  fclose(config_file);
  
  
  
  
  //Set up iterations
  printf("Setting up input datasize no. of benchmark iterations..\n");
  nrows=atoi(argv[2]);
  ncols=atoi(argv[3]);
  //iterations=atoi(argv[4]);
  iterations=1;
  
  
  
  //Initialize the log memory and open up the file
  printf("Creating memory for logs...\n");
  logfile=argv[5];
  log_memory=(double*)malloc(sizeof(double)*nthreads*9*iterations);
  
  printf("Initialized..\n");
}




void display_state()
{
  printf("nthreads: %d\nrows: %d\nncols: %d\nxmax: %d\nymax: %d\n",nthreads,nrows,ncols,xmax,ymax);
  int count=0;
  for(;count<nthreads; count++)
    printf("%d\t%d\t%d\n",thread_id[count],core_map[count],barrier_map[count]);
}




























