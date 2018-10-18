#include "mpi.h"
#include <stdio.h>
#include <time.h>
#include <math.h>
/* Code adapted from http://web.cs.sunyit.edu/~harrism2/CS523/Assignment4.html */

/*MPI_Type Enum*/
enum {
    MASTER=0,
    FROM_MASTER=1,
    FROM_WORKER=2,
	//Gonna set these from command line arguments, hopefully
    //NRA = 10 ,
    //NCA = 10 ,
    //NRB = 10 ,
    //NCB = 10 ,
    
};

int main(int argc, char *argv[]) {

    //MPI
    int         num_tasks;     /* number of tasks     */
    int         task_id;       /* number of processes  */
    int         num_workers;   /* number of worker tasks */
    int         source;        /* rank of sender       */
    int         dest;          /* rank of receiver     */
    int         mtype;         /* message type */
    int         tag = 0;       /* tag for messages     */
    char        message[100];  /* storage for message  */
    MPI_Status  status;        /* return status for receive */
    int         rows;
    int         offset;
    
    clock_t begin, end;
    double time_spent;
    
    //Matrix Mult
    int i,j,k = 0;
    int matrix_row, matrix_column = 0;
    int vector_row, vector_column = 0;
    
    
    /* Start up MPI */
    MPI_Init(&argc, &argv);
    
    /* Find out process rank  */
    MPI_Comm_rank(MPI_COMM_WORLD, &task_id);

	//<TJL>
	//Only master
        if(task_id == MASTER){
                //TJL: Very simple method so that I can check those CLA
                int z;
                for(z=0; z<argc; z++){
                        printf("%s\n", argv[z]);
                }
        }

	int NRA = atoi(argv[1]);
	int NCA = atoi(argv[1]);
	int NRB = atoi(argv[1]);
	int NCB = atoi(argv[1]);

	//</TJL>


    
    /* Find out number of processes */
    MPI_Comm_size(MPI_COMM_WORLD, &num_tasks);
    
    num_workers = num_tasks - 1;
    
    if (task_id == MASTER) {
        matrix_row = NRA ;
        matrix_column = NRB ;
        
        int matrix[matrix_row][matrix_column];
        
        
        for ( i = 0; i < matrix_row; i++ )
            for ( j = 0; j < matrix_column; j++ )
                matrix[i][j] = i + j ;
      //if((matrix_row + matrix_column )< 22){
	if((matrix_row + matrix_column )< 50){
        printf("Matrix A:\n");
        for ( i = 0; i < matrix_row; i++ ) {
            for ( j = 0; j < matrix_column; j++ )
            printf("%d\t", matrix[i][j]);
            
            printf("\n");
        }
        }
        
        vector_row = NRB;
        vector_column = NCB ;
        
        int vector[vector_row][vector_column];
        
        //Do some basic error checking
        if ( matrix_column != vector_row ) {
            printf("Matrices with entered orders can't be multiplied with each other.\n");
            return 1;
        }
        
        for ( i = 0; i < vector_row; i++ )
        for ( j = 0; j < vector_column; j++ )
        vector[i][j] = i-j;
        
        //if((vector_row + vector_column )< 22){
	if((matrix_row + matrix_column )< 50){
        printf("Vector B:\n");
        for ( i = 0; i < vector_row; i++ ) {
            for ( j = 0; j < vector_column; j++ )
            printf("%d\t", vector[i][j]);
            printf("\n");
        }
        }
        
        begin = clock();
        
        //Partiion the matrix data into smaller groups
        int average_row = matrix_row / num_workers;
        int left_overs = matrix_row % num_workers;
        
        //Send matrix data to worker tasks
        int offset = 0;
        int rows = 0;
        mtype = FROM_MASTER;
        for (dest = 1; dest < num_tasks; dest++) {
            rows = (dest < left_overs) ? average_row + 1 : average_row;
            printf("Sending %d rows to task %d\n", rows, dest);
            MPI_Send( &offset, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&rows, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&matrix_row, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&matrix_column, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&matrix[offset][0], rows * matrix_column, MPI_INT, dest, mtype,
                     MPI_COMM_WORLD);
            MPI_Send(&vector_row, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&vector_column, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&vector, vector_row * vector_column, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            offset += rows;
        }
        printf("Sent all the data!\n");
        
        //Define size of result matrix
        int product[matrix_row][vector_column];
        
        //Wait for results from workers
        mtype = FROM_WORKER;
        for( i=1; i < num_tasks; i++) {
            source = i;
            printf("Receiving data from task %d\n", source);
            MPI_Recv(&offset, 1, MPI_INT, source, mtype, MPI_COMM_WORLD, &status);
            MPI_Recv(&rows, 1, MPI_INT, source, mtype, MPI_COMM_WORLD, &status);
            int result[rows][vector_column];
            MPI_Recv(&result, rows * vector_column, MPI_INT, source, mtype,
                     MPI_COMM_WORLD, &status);
            //put results into their proper place in the product matrix
            int real_index = 0;
            for ( j = 0; j < rows; j++ ) {
                for ( k = 0; k < vector_column; k++ ) {
                    real_index = j + offset;
                    product[real_index][k] = result[j][k];
                }
            }
        }
        
        //Print the results
        //if((matrix_row + vector_column )< 22){
	if((matrix_row + matrix_column )< 50){
        printf("Product of entered matrices:-\n");
        for ( i = 0; i < matrix_row; i++ ) {
            for ( j = 0; j < vector_column; j++ ) {
                printf("%d\t", product[i][j]);
            }
            printf("\n");
        }
        }
    } else {
        //Worker task
        mtype = FROM_MASTER;
        //Get the rows from matrix A (ie matrix[][])
        MPI_Recv(&offset, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&rows, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&matrix_row, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&matrix_column, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        int matrix[rows][matrix_column];
        MPI_Recv(&matrix, rows*matrix_column, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        //Get vector b (ie vector[][])
        MPI_Recv(&vector_row, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&vector_column, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        int vector[vector_row][vector_column];
        MPI_Recv(&vector, vector_row * vector_column, MPI_INT, MASTER, mtype,
                 MPI_COMM_WORLD, &status);
        
        //Compute the result matrix
        int result[rows][vector_column];
        for( i=0; i < vector_column; i++) {
            for( j=0; j < rows; j++) {
                result[j][i] = 0;
                for (k = 0; k < vector_row; k++) {
                    result[j][i]= result[j][i] + matrix[j][k] * vector[k][i];
                }
            }
        }
        
        //Send the results back to the Master process
        mtype = FROM_WORKER;
        MPI_Send(&offset, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
        MPI_Send(&rows, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
        MPI_Send(&result, rows * vector_column, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
    }
    
    MPI_Finalize();
    if(task_id ==MASTER){
        
        end = clock();
        time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
        printf("( %d )time spent %f sec\n",num_tasks, time_spent);
    }
    return 0;
}
