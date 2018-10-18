/*
  A very simple OpenMP matrix multiplaction.

    Copyright (C) 2013  Dylan Rudolph

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "time.h"
#include "omp.h"

typedef double dtype;
typedef unsigned int uint;
struct timespec start_time, end_time, start_time_omp, end_time_omp;

struct timespec start_time_temp, end_time_temp;

struct timespec start_time_randA, end_time_randA;
struct timespec start_time_randB, end_time_randB;
struct timespec start_time_zeroC, end_time_zeroC;

struct timespec start_time_delA, end_time_delA;
struct timespec start_time_delB, end_time_delB;
struct timespec start_time_delC, end_time_delC;

typedef struct {
  uint rows;
  uint cols;
  dtype ** M;
} matrixtype, *matrix;

matrix new_matrix(uint rows, uint cols)
/*
  Make a new 'matrix' type and allocate memory for it.
  Access is done by: A->M[row][column].
*/
{
  uint i;
  matrix A = malloc(sizeof(matrixtype));
  A->rows = rows;
  A->cols = cols;
  A->M = malloc( sizeof( dtype * ) * rows );

  for (i = 0; i<rows; i++) {
    A->M[i] = malloc( sizeof( dtype * ) * cols);
  }

  return A;
}

void delete_matrix(matrix A)
/* Frees up the memory allocated for the matrix A. */
{
  uint row;
  for (row = 0; row<(A->rows); row++) { free(A->M[row]); }
  free(A->M);
  free(A);
}

void zero_matrix(matrix A)
/* Zeros out the matrix A. */
{
  uint row, col;
  for(row = 0; row<(A->rows); row++) {
    for(col = 0; col<(A->cols); col++) {
      A->M[row][col] = (dtype) 0;
    }
  }
}

matrix new_zero_matrix(uint rows, uint cols)
/* Returns a zeroed out newly-allocated matrix. */
{
  matrix A = new_matrix(rows, cols);
  zero_matrix(A);
  return A;
}

void random_fill_matrix(matrix A, dtype lower, dtype upper)
/* Fills a matrix with random numbers over [lower, upper) */
{
  uint row, col;
  for (row = 0; row<(A->rows); row++) {
    for (col = 0; col<(A->cols); col++) {
      A->M[row][col] = ((dtype) rand() / (RAND_MAX)) * 
                       (upper - lower + 1) + lower;
    }
  }
}

matrix new_random_matrix(uint rows, uint cols, dtype lower, dtype upper)
/* Returns a random newly-allocated matrix. */
{
  matrix A = new_matrix(rows, cols);
  random_fill_matrix(A, lower, upper);
  return A;
}

double time_diff(struct timespec a, struct timespec b)
/* Finds the time difference. */
{
  double dt = (( b.tv_sec - a.tv_sec ) + 
               ( b.tv_nsec - a.tv_nsec ) / 1E9);
  return dt;
}

void print_matrix(matrix A, char *mat_name)
/*
   Prints the matrix in a way which displays well for small numbers of columns,
   but not very well for large numbers of columns.
*/
{
  uint row, col;
  printf("\n%s: %d row(s), %d column(s)", mat_name, A->rows, A->cols);
  for(row = 0; row<(A->rows); row++) {
    printf("\n");
    for(col = 0; col<(A->cols); col++) {
      printf("%.2f, ", A->M[row][col]);
    }
  }
  printf("\n");
}

void multiply_matrix(matrix A, matrix B, matrix C)
/*
   Multiplies A and B, and puts the result in C. 
   C should be zeroed and initialized with size: (A->rows, B->cols).
*/
{
  zero_matrix(C);
  if (A->cols != B->rows) { exit(0); }

  uint row, col, i;
  for (row = 0; row<(C->rows); row++) {
    for (col = 0; col<(C->cols); col++) {
      for (i = 0; i<(A->cols); i++) {


        C->M[row][col] += A->M[row][i] * B->M[i][col];


      }
    }
  }
}

void omp_multiply_matrix(matrix A, matrix B, matrix C)
/*
   Multiplies A and B, and puts the result in C, uses OpenMP.
   C should be zeroed and initialized with size: (A->rows, B->cols).
*/
{
  zero_matrix(C);
  if (A->cols != B->rows) { exit(0); }
  uint row;
#pragma omp parallel for shared(A,B,C)
  for (row = 0; row<(C->rows); row++) {
    uint col;
    for (col = 0; col<(C->cols); col++) {
      uint i;
      for (i = 0; i<(A->cols); i++) {
         C->M[row][col] += A->M[row][i] * B->M[i][col];
      }
    }
  }
}

int main (int argc, char *argv[])
{
  uint n_threads = 4;
  omp_set_num_threads(n_threads);

  /* Disable 'debug' to remove print statements */
  uint debug = 0;

  /* 'runs' is the number of times over which to average.
     If in an OS, this should be at least 50. */
  uint runs = 50;

  /* Parse the input to get the matrix size. (Square: N by N) */
  uint N;
  char *endptr;
  if (argc > 1) { N = strtol(argv[1], &endptr, 10); }
  else { N = 8; }
  uint rows = N;
  uint cols = N;

  printf("Runs: %i\nSize: %ix%i\n\n", runs, rows, cols);

  /* Initialize the matrices */
  srand( time(0) );

  /*MATRIX INITIALIZATION*/
  int l;
  double time_temp = 0;
  for(l = 0; l < runs; l++){
    clock_gettime(CLOCK_REALTIME, &start_time_temp);
    matrix A;
    clock_gettime(CLOCK_REALTIME, &end_time_temp);
    time_temp += time_diff(start_time_temp, end_time_temp);

    A = new_zero_matrix(rows, cols);
    delete_matrix(A);
  }

  time_temp = time_temp/runs;
  printf("Avg Matrix Allocation Time: %.8f ms\n\n", time_temp*1000);

  matrix A, B, C;

  /*MATRIX FILLING*/
  uint j;
  double randA = 0, randB = 0, zeroC = 0;
  for(j = 0; j < runs; j++){
    clock_gettime(CLOCK_REALTIME, &start_time_randA);
    A = new_random_matrix(rows, cols, 0, 10);
    clock_gettime(CLOCK_REALTIME, &end_time_randA);
    randA += time_diff(start_time_randA, end_time_randA);

    clock_gettime(CLOCK_REALTIME, &start_time_randB);
    B = new_random_matrix(rows, cols, 0, 10);
    clock_gettime(CLOCK_REALTIME, &end_time_randB);
    randB += time_diff(start_time_randB, end_time_randB);

    clock_gettime(CLOCK_REALTIME, &start_time_zeroC);
    C = new_zero_matrix(rows, cols);
    clock_gettime(CLOCK_REALTIME, &end_time_zeroC);
    zeroC += time_diff(start_time_zeroC, end_time_zeroC);
  }

  randA = randA/runs;
  randB = randB/runs;
  zeroC = zeroC/runs;

  printf("RandA (%ix%i) Avg Time: %.8f ms\n", rows, cols, randA*1000);
  printf("RandB (%ix%i) Avg Time: %.8f ms\n", rows, cols, randB*1000);
  printf("ZeroC (%ix%i) Avg Time: %.8f ms\n", rows, cols, zeroC*1000);




  /* OPENMP MATRIX MULTIPLY */

  /* Outer loop measure */
  uint i;
  clock_gettime(CLOCK_REALTIME, &start_time_omp);

  for (i=0; i<runs; i++) {
    omp_multiply_matrix(A, B, C);
  }

  clock_gettime(CLOCK_REALTIME, &end_time_omp);

  double outer_omp = time_diff(start_time_omp, end_time_omp) / (double) runs;
  printf("\nOpenMP: OUTER LOOP Avg: %.8f ms\n", outer_omp*1000);

  /* Loop time and OMP_MM measure */
  double inner_omp = 0;
  clock_gettime(CLOCK_REALTIME, &start_time_temp);
  for (i=0; i<runs; i++) {
    clock_gettime(CLOCK_REALTIME, &start_time_omp);

    omp_multiply_matrix(A, B, C);

    clock_gettime(CLOCK_REALTIME, &end_time_omp);
    inner_omp += time_diff(start_time_omp, end_time_omp);
  }
  clock_gettime(CLOCK_REALTIME, &end_time_temp);

  double loop_time = time_diff(start_time_temp, end_time_temp) / (double) runs;
  inner_omp = inner_omp/(double)runs;

  printf("OpenMP: MATRIX MULTIPLY Avg: %.8f ms\n", inner_omp*1000);
  printf("OpenMP: LOOP Avg: %.8f ms\n", (loop_time-inner_omp)*1000);



  /* STANDARD MATRIX MULTIPLY */

  /* Outer loop measure */
  clock_gettime(CLOCK_REALTIME, &start_time);

  for (i=0; i<runs; i++) {
    multiply_matrix(A, B, C);
  }

  clock_gettime(CLOCK_REALTIME, &end_time);

  double outer_std = time_diff(start_time, end_time) / (double) runs;
  printf("\nStandard: OUTER LOOP Avg: %.8f ms\n", outer_std*1000);

  /* Inner loop measure */
  double inner_std = 0;
  clock_gettime(CLOCK_REALTIME, &start_time_temp);
  for (i=0; i<runs; i++) {
    clock_gettime(CLOCK_REALTIME, &start_time);

    multiply_matrix(A, B, C);

    clock_gettime(CLOCK_REALTIME, &end_time);
    inner_std += time_diff(start_time, end_time);
  }
  clock_gettime(CLOCK_REALTIME, &end_time_temp);
 
  loop_time = time_diff(start_time_temp, end_time_temp) / (double) runs;
  inner_std = inner_std/(double)runs;
  
  printf("Standard: MATRIX MULTIPLY Avg: %.8f ms\n", inner_std*1000);
  printf("Standard: LOOP Avg: %.8f ms\n", (loop_time-inner_std)*1000);



  if (debug == 1) {
    print_matrix(A, "A");
    print_matrix(B, "B");
    print_matrix(C, "C");
  }

  /*MATRIX DELETION*/
  int k;
  double delA = 0, delB = 0, delC = 0;
  for(k = 0; k < runs; k++){
    clock_gettime(CLOCK_REALTIME, &start_time_delA);
    delete_matrix(A);
    clock_gettime(CLOCK_REALTIME, &end_time_delA);
    delA += time_diff(start_time_delA, end_time_delA);

    clock_gettime(CLOCK_REALTIME, &start_time_delB);
    delete_matrix(B);
    clock_gettime(CLOCK_REALTIME, &end_time_delB);
    delB += time_diff(start_time_delB, end_time_delB);

    clock_gettime(CLOCK_REALTIME, &start_time_delC);
    delete_matrix(C);
    clock_gettime(CLOCK_REALTIME, &end_time_delC);
    delC += time_diff(start_time_delC, end_time_delC);

    /*Re-initialize matrices for averaging*/
    A = new_random_matrix(rows, cols, 0, 10);
    B = new_random_matrix(rows, cols, 0, 10);
    C = new_zero_matrix(rows, cols);

    /*To reset C to its normal state prior to deletion*/
    omp_multiply_matrix(A, B, C);
  }

  delA = delA/runs;
  delB = delB/runs;
  delC = delC/runs;

  printf("\nMatrix A Avg Deletion Time: %.8f ms\n", delA*1000);
  printf("Matrix B Avg Deletion Time: %.8f ms\n", delB*1000);
  printf("Matrix C Avg Deletion Time: %.8f ms\n", delC*1000);

  /*Free memory from final run of deletion avg*/
  delete_matrix(A);
  delete_matrix(B);
  delete_matrix(C);

  return 0;
}
