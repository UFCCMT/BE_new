/*
  A simple matrix multiplaction benchmark.

    Copyright (C) 2013-2014  Dylan Rudolph

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

typedef double dtype;
typedef unsigned int uint;
struct timespec start_time, end_time;

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

int main (int argc, char *argv[])
{

  uint debug = 0;

  uint M, N, P;
  char *endptrM, *endptrN;

  if (argc > 2) {
    M = strtol(argv[1], &endptrM, 10);
    N = strtol(argv[2], &endptrN, 10);
    P = M;
  }

  else { M = 8; N = 8; P = 8;}

  uint runs = 8192 / M * 8192 / N / P + 1;

  if (debug == 1) { printf("Number of Runs: %i\n", runs); }

  srand( time(0) );
  matrix A = new_random_matrix(M, N, 0, 10);
  matrix B = new_random_matrix(N, P, 0, 10);
  matrix C = new_zero_matrix(M, P);

  clock_gettime(CLOCK_REALTIME, &start_time);

  uint i;
  for (i=0; i<runs; i++) {
    multiply_matrix(A, B, C);
  }

  clock_gettime(CLOCK_REALTIME, &end_time);

  if (debug == 1) {
    print_matrix(A, "A");
    print_matrix(B, "B");
    print_matrix(C, "C");
  }

  delete_matrix(A);
  delete_matrix(B);
  delete_matrix(C);

  /* Calculate the time difference and normalize for 'runs' */
  double dt = time_diff(start_time, end_time) / (double) runs;
  printf("RUNTIME: %.8f;r\n", dt);

  return 0;
}
