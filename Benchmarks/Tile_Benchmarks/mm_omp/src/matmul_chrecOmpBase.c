/*
 ============================================================================
 Name        : CHREC-F5-matrixMult.c
 Author      : Justin Richardson
 Version     : 0.006
 Copyright   : Part of the CHREC F5 benchmarks
 Description : Matrix Multiply benchmark, CHREC F5 (Serial Baseline)
 Modification: Dave Ojika :
                    - changed type to run program using a different data type (handed-coded to Double)
                    - changed print format to support double for debugging
                    - replaced random function for input matrix with simple i+j algoirithm inside loop. Computation varified in Matlab
                    - runs matrix multiply "runs" number of times - used to calculate average execution time
                    - added openMP pragma for multithreading
                    - chnaged input paramter to provide only 1 sqaure matrix and number of threads
 ============================================================================
 */

#include <stdlib.h>
#include <sys/time.h>
#include <stdio.h>
#include <omp.h>

//Definitions
#define MAX_SIZE 2048
#define HIGH 255
#define LOW 0

//Function prototypes
int Commands( int arg, char *args[]);
void Init( void *MATA);


//Matrix Parameters startup values
int nAsize = 3;		// Matrix A row size
int mAsize = 3;		// Matrix A col size
int nBsize = 3;		// Matrix B row size
int mBsize = 3;		// Matrix B col size
int nCsize = 3;		// Matrix C row size
int mCsize = 3;		// Matrix C col size

//number of thrads to be used for computation
//int numThrds = omp_get_num_threads();           //returns only 1???
int numThrds = 2;                               //default set to 2. overidden by input from terminal
const int runs = 1;                             //number of times to run computation. used to do the average computation time
time_t start;

//type definition
typedef double dataType;     //changed type to run program using a different type

//Pointer prototypes
dataType ** matrixA;
dataType ** matrixB;
dataType ** matrixC;

//Timer structures
struct timeval startCycles, stopCycles;
double walltime, timeUsed;

//File IO pointers
FILE * output;


int main(int argc, char *argv[]) {
	//DEBUG:Print Header info
	printf("==========================================\n");
	printf("==CHREC F5 Baseline Arithmetic Benchmark==\n");
	printf("==Version: 0.006                        ==\n");
	printf("==Core function Matrix Multiply         ==\n");
	printf("==========================================\n");

	if( Commands(argc, argv) != 0){printf("Died in arg function!\n"); exit(-1);}

	printf("\nMatrix Sizes:\nMA: %dx%d\nMB: %dx%d\nMC: %dx%d\n\n", nAsize,mAsize,nBsize,mBsize,nCsize,mCsize);

	printf("Using the precision: %d bits\n\n", (int)sizeof(dataType)*8);

	//various loop parameters
	int i = 0;
	int j = 0;
	int z = 0;

	//open file
	output = fopen("output.txt", "a+");
	if( output == NULL){printf("Cannot open file!\n"); exit(-1);}


	//Allocate memory for each matrix
	dataType **matrixA = (dataType **)malloc(nAsize * sizeof(*matrixA));
	if(!(matrixA[0] = (dataType *)malloc(nAsize * mAsize * sizeof(dataType))))
	{
		printf("OUT OF MEMORY!\n");
		free(matrixA[0]);
		free(matrixA);
		exit(-2);
	}
	for( i = 1; i < nAsize; i++) {
		matrixA[i] = matrixA[0] + i * mAsize;
		//DEBUG: printf("Address: %p\n", matrixA[i]);
	}

	dataType **matrixB = (dataType **)malloc(nBsize * sizeof(*matrixB));
	if(!(matrixB[0] = (dataType *)malloc(nBsize * mBsize * sizeof(dataType))))
	{
		printf("OUT OF MEMORY!\n");
		free(matrixB[0]);
		free(matrixB);
		exit(-2);
	}
	i = 0;
	for( i = 1; i < nBsize; i++) {
		matrixB[i] = matrixB[0] + i * mBsize;
	}

	dataType **matrixC = (dataType **)malloc(nCsize * sizeof(*matrixC));
	if(!(matrixC[0] = (dataType *)malloc(nCsize * mCsize * sizeof(dataType))))
	{
		printf("OUT OF MEMORY!\n");
		free(matrixC[0]);
		free(matrixC);
		exit(-2);
	}
	i = 0;
	for( i = 1; i < nCsize; i++) {
			matrixC[i] = matrixC[0] + i * mCsize;
		}


//this block initializes two input matrices with values ranging from 0 to N x M. Replaces the previous version of using a random function
//for actual matrix replaces this code segment with actual matrix
	int i2=0;
	int j2=0;
	for(i2 = 0; i2 < nAsize; i2++){
		for(j2 = 0; j2 < mAsize; j2++){
			matrixA[i2][j2] = (dataType) i2 + j2;
		}
	}
	for(i2 = 0; i2 < nAsize; i2++){
		for(j2 = 0; j2 < mAsize; j2++){
			matrixB[i2][j2] = (dataType) i2 + j2;
		}
	}
	for(i2 = 0; i2 < nAsize; i2++){
		for(j2 = 0; j2 < mAsize; j2++){
			matrixC[i2][j2] = (dataType) 0;
		}
	}

/*
//change format type to support double
//	//DEBUG: Print matrix A
	printf("Matrix A:\n");
	for(i2 = 0; i2 < nAsize; i2++) {
		printf("[");
		for(j2 = 0; j2 < mAsize; j2++) {
			printf(" %g", matrixA[i2][j2]);
		}
		printf(" ]\n");
	}
//	//DEBUG: Print matrix B
	printf("Matrix B:\n");
	for(i2 = 0; i2 < nBsize; i2++) {
		printf("[");
		for(j2 = 0; j2 < mBsize; j2++) {
			printf(" %g", matrixB[i2][j2]);
		}
		printf(" ]\n");
	}
//	//DEBUG: Print matrix C
	printf("Matrix C:\n");
	for(i2 = 0; i2 < nCsize; i2++) {
		printf("[");
		for(j2 = 0; j2 < mCsize; j2++) {
			printf(" %g", matrixC[i2][j2]);
		}
		printf(" ]\n");
	}
*/
    int r=0;
    omp_set_num_threads(8);
	gettimeofday(&startCycles, NULL);       //set timer
	start = time(NULL);

    #pragma omp parallel for private(i,j,z) shared(matrixA, matrixB, matrixC)
    for(r=0; r<runs; r++){              //run matrix multiply "runs" times and find the average time of computation
	//MATRIX MULTIPLICATION
        for( i = 0; i < nAsize; i++){
            for( j = 0; j < mBsize; j++){
                dataType sum = 0;
                for( z = 0; z < mAsize; z++){
                     sum += matrixA[i][z] * matrixB[z][j];
                }
                matrixC[i][j] = sum;
            }
        }
    }
	gettimeofday(&stopCycles, NULL);        //stop timer
	walltime = time(NULL) - start;          //stop timer
	walltime = walltime/runs;

	//Compute Time consumed
	timeUsed = ((double)stopCycles.tv_sec + (double)stopCycles.tv_usec/1000000) -
			((double)startCycles.tv_sec + (double)startCycles.tv_usec/1000000);

    timeUsed=timeUsed/runs;

    //compute ime consumed
	printf("\nFinished calculations.\n");
    printf("Matmul kernel wall clock time = %f sec\n", walltime);
    printf("MFlops = %f\n", (double)(nAsize*nAsize*2)*(double)(nAsize)/walltime/1.0e6);



/*    //DEBUG: Print result matrix
	printf("Result Matrix:\n");
	for(i = 0; i < nCsize; i++){
		printf("[ ");
		for(j = 0; j < mCsize; j++){
			printf("%g ", matrixC[i][j]);
		}
		printf("]\n");
	}
*/
    //print thread info
    printf("\n\n# of threads: %i\n", numThrds);

	//print resulting time
	fprintf(output, "Time:%f:s\n", timeUsed);
	printf("Time used: %f (s)\n", timeUsed);

	//free all the pointers!
	free(matrixA[0]);
	free(matrixA);
	free(matrixB[0]);
	free(matrixB);
	free(matrixC[0]);
	free(matrixC);
	if(fclose(output) != 0){printf("File did not close properly!\n");exit(-1);}

	printf("Program is exiting...\n");

	return 0;
}

int Commands( int arg, char *args[]) {
/*
 ============================================================================
 Function Name	: Commands			Version:1.0
 Author     	: Justin Richardson
 Inputs		    : # of arguments, address of char arrays
 Copyright  	: Part of the CHREC F5 benchmarks
 Description 	: Processes the input parameters for the function
 ============================================================================
 */
	if(arg != 3){printf("Usage: [Square matrix dimension] [number of threads]\n");exit(0);}

	nAsize = atoi(args[1]);
	mAsize = atoi(args[1]);
	nBsize = atoi(args[1]);
	mBsize = atoi(args[1]);
	numThrds = atoi(args[2]);       //modified number of threads to be used to computation

	if(mAsize != nBsize){printf("Matrix Sizes do not match!\nExiting Program\n");exit(-1);}

	nCsize = mAsize;	//Set output matrix sizes
	mCsize = nBsize;

	return 0;
}

void Init(void *MATA) {
/*
 ============================================================================
 Function Name	: Init				Version:0.2 (bypassed)
 Author     	: Justin Richardson
 Inputs		    : Pointer to Matrix?
 Copyright  	: Part of the CHREC F5 benchmarks
 Description 	: Generate random matrices for benchmarking
 ============================================================================
 */

/*
	//Seed the random number generator
	time_t seed;
	time(&seed);
	srand((unsigned int) seed);

	//Initalize the memory blocks
	int i2 = 0;
	int j2 = 0;
	for(i2 = 0; i2 < nAsize; i2++){
		for(j2 = 0; j2 < mAsize; j2++){
			matrixA[i2][j2] = 1; //(short int)(rand() % (HIGH - LOW + 1) + LOW);
		}
	}

	for(i2 = 0; i2 < nBsize; i2++) {
		for(j2 = 0; j2 < mBsize; j2++) {
			matrixB[i2][j2] = 2; //(short int)(rand() % (HIGH - LOW + 1) + LOW);
		}
	}

	for(i2 = 0; i2 < nCsize; i2++) {
		for(j2 = 0; j2 < mCsize; j2++) {
			matrixC[i2][j2] = 0;
		}
	}

	//DEBUG: Print matrix A
	printf("Matrix A:\n");
	for(i2 = 0; i2 < nAsize; i2++) {
		printf("[");
		for(j2 = 0; j2 < mAsize; j2++) {
			printf(" %d", matrixA[i2][j2]);
		}
		printf(" ]\n");
	}

	//DEBUG: Print matrix B
	printf("Matrix B:\n");
	for(i2 = 0; i2 < nBsize; i2++) {
		printf("[");
		for(j2 = 0; j2 < mBsize; j2++) {
			printf(" %d", matrixB[i2][j2]);
		}
		printf(" ]\n");
	}

	//DEBUG: Print matrix C
	printf("Matrix C:\n");
	for(i2 = 0; i2 < nCsize; i2++) {
		printf("[");
		for(j2 = 0; j2 < mCsize; j2++) {
			printf(" %d", matrixC[i2][j2]);
		}
		printf(" ]\n");
	}
*/

	return;
}

//EoF
