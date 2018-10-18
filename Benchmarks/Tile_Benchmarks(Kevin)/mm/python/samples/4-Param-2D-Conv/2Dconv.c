/*
  A naive serial implementation of 2D convolution.

    Copyright (C) 2014  Dylan Rudolph

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
#include <string.h>
#include <stdio.h>
#include <math.h>
#include "time.h"

/* ------------------------------------------------------------------------ */
/* -------------------------- Type Definitions ---------------------------- */
/* ------------------------------------------------------------------------ */

/* dtype - internal data storage type
   ttype - type to use for representing time */
typedef double dtype;
typedef double ttype;

typedef unsigned int uint;

typedef struct {
  uint rows;
  uint cols;
  dtype ** M;
} matrixtype, *matrix;

/* ------------------------------------------------------------------------ */
/* ----------------------------- Prototypes ------------------------------- */
/* ------------------------------------------------------------------------ */

double time_diff(struct timespec, struct timespec);

matrix new_matrix(uint, uint);
void delete_matrix(matrix);
void zero_matrix(matrix);
void print_matrix(matrix, char *);
void random_fill_matrix(matrix, dtype, dtype);
matrix new_random_matrix(uint, uint, dtype, dtype);
void print_matrix(matrix, char *);
dtype diff_matrix(matrix, matrix);
ttype convolve_matrix(matrix, matrix, matrix);

/* ------------------------------------------------------------------------ */
/* ------------------------- Utility Functions ---------------------------- */
/* ------------------------------------------------------------------------ */

ttype time_diff(struct timespec a, struct timespec b)
/* Finds the time difference (a is the first time). */
{
  ttype dt = (( b.tv_sec - a.tv_sec ) +
              ( b.tv_nsec - a.tv_nsec ) / 1E9);
  return dt;
}

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
    A->M[i] = malloc( sizeof( dtype ) * cols);
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

void random_fill_matrix(matrix A, dtype lower, dtype upper)
/* Fills a matrix with random numbers over [lower, upper). */
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

dtype diff_matrix(matrix A, matrix B)
/*
   Find the magnitude of the difference between A and B, which
   should both be the same size.
*/
{
  uint row, col;
  dtype diff = 0.0;
  for(row = 0; row<(A->rows); row++) {
    for(col = 0; col<(A->cols); col++) {
      diff += abs(A->M[row][col] - B->M[row][col]);
    }
  }

  return diff;
}

/* ------------------------------------------------------------------------ */
/* ----------------------- Mathematical Functions ------------------------- */
/* ------------------------------------------------------------------------ */

ttype convolve_matrix(matrix A, matrix B, matrix C)
/*
   Convolves the matrix A with the kernel B and puts the result in C.
   The output size is the same as that of A. So, C should be initialized
   with size: (A->rows, A->cols). Border cases are handled by extending
   border pixel values outwards.
*/
{

  struct timespec start, end;

  /* Begin logging elapsed time. */
  clock_gettime(CLOCK_REALTIME, &start);

  zero_matrix(C);

  uint row, col;
  int x, y, m, n, xd, xu, yd, yu;

  /* Calculate the x/y up/down kernel-offset values. */
  xd = -1 * (B->cols / 2);
  xu = (B->cols + 1) / 2;
  yd = -1 * (B->rows / 2);
  yu = (B->rows + 1) / 2;

  /* "For coordinates (row, col) in the output matrix" */
  for (row = 0; row < (C->rows); row++) {
    for (col = 0; col < (C->cols); col++) {

      /* "For coordinates (m, n) in the offset kernel" */
      for (m = xd; m < xu; m++) {
        for (n = yd; n < yu; n++) {

          /* x and y are the ordinates in A from which to take the value. */
          x = col + m;
          y = row + n;

          /* Handle border cases by extending border values. */
          if (x < 0) x = 0;
          else if (x > (C->cols - 1)) x = C->cols - 1;
          if (y < 0) y = 0;
          else if (y > (C->rows - 1)) y = C->rows - 1;

          /* Add this point to the accumulated values. */
          C->M[row][col] += A->M[y][x] * B->M[yu - n - 1][xu - m - 1];
        }
      }
    }
  }

  /* Stop logging elapsed time and return the difference. */
  clock_gettime(CLOCK_REALTIME, &end);
  ttype dt = time_diff(start, end);

  return dt;
}

/* ------------------------------------------------------------------------ */
/* --------------------------- Main Function ------------------------------ */
/* ------------------------------------------------------------------------ */

int main (int argc, char *argv[])
{
  /* Parse the input to get the sizes. The matrix is of size M by N.
     The kernel is of size J by K. */
  uint M, N, J, K;

  char *endptrM; char *endptrN;
  char *endptrJ; char *endptrK;
  if (argc > 4) {
    M = strtol(argv[1], &endptrM, 10);
    N = strtol(argv[2], &endptrN, 10);
    J = strtol(argv[3], &endptrJ, 10);
    K = strtol(argv[4], &endptrK, 10);
  } else {
    printf("\n*** Please enter 4 values for the sizes; using defaults. ***\n");
    M = 32; N = 32; J = 3; K = 3;
  }

  /* Generate a random signal and kernel. */
  srand(23);
  matrix A = new_random_matrix(M, N, 0, 255.0);
  matrix B = new_random_matrix(J, K, -1.0, 1.0);

  /* Prepare the output matrices. */
  matrix C = new_matrix(A->rows, A->cols);
  zero_matrix(C);

  /* Perform the naive convolution and print out the time it took. */
  ttype dtnaive = convolve_matrix(A, B, C);
  printf("RUNTIME: %.8f;r\n", dtnaive);

  /* Clean up. */
  delete_matrix(A);
  delete_matrix(B);
  delete_matrix(C);

  return 0;
}

