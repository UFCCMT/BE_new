#include<header.h>
#include<stdlib.h>

//-----------------------------------Globals------------------------------------
//Thread management
extern int nthreads;
extern pthread_t *threads;
extern int *thread_id;
extern int *core_map;



//Time measurement and log management
extern char *logfile
extern double *log_memory



//Program parameters
extern int M;
extern int iterations;







void init(int argc, char *argv[])
{
  if(argc<1)
  {
    printf("Usage: ./mm_sparse <config_filename>\n");
    exit(EXIT_FAILURE);
  }
  
  
  nthreads=-1;
  id=MAIN;
  
  char temp_word[20]; //Temporary variable to hold words
  int  temp_id[36]; //To hold mapping, barrier, etc
  int  temp_count; //General temporary variable 
  
  
  
  
  //Open config file
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
  if(n_processes==-1)
  {
    printf("Invalid no. of processes. Quiting.\n");
    exit(1);
  }
  rewind(config_file);
  
 
 
 
 
  //Parse the file for datasize
  while(!feof(config_file))
  {
    fscanf(config_file,"%s",temp_word);
    if(strcmp(temp_word,"DATASIZE")==0)
    {
      fscanf(config_file,"%s",temp_word);
      nthreads=atoi(temp_word);
      break;
    }
  }
  if(n_processes==-1)
  {
    printf("Invalid no. of processes. Quiting.\n");
    exit(1);
  }
  rewind(config_file);
 
 
  
  
  //Parse the file for the map of real vs virtual cores
  temp_count=0;
  core_map=malloc(sizeof(int)*nthreads);
  
  for(;temp_count<nthreads; temp_count++)
    thread_id[temp_count]=temp_count;
    
  temp_count=0;
    
  while(!feof(config_file))
  {
    fscanf(config_file,"%s",temp_word);
    if(strcmp(temp_word,"CORE_MAP")==0)
    {
      while(temp_count<n_processes && !feof(config_file))
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
  
  
  
  
  //Close the file
  fclose(config_file);
}




void display_state()
{
  printf("nthreads: %d\n",nthreads);
  int count=0;
  for(;count<nthreads; count++)
    printf("%d\t%d\n",thread_id[count],core_map[count]);
}




























