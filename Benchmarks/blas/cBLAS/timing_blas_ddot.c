/*
 * This program gives the time to calculate dot product from a matrix and
 * a vector using blas library. The program takes the size of a matrix,
 * a vector and numer of times to run the program and gives the average
 * time as output.
 * Running the function :
 *                    ./programme_name run row col
 *
 * example :          ./blas_timing 100 50 50
 *
 * -Farhaan Fowze (July 2014)
 */

#include <cblas.h>
#include <time.h>

#include <stdio.h>
#include <stdlib.h>

/*
 * dtype - data type
 * ttype - timing data type
 */
typedef double dtype;
typedef double ttype;
typedef unsigned int uint;

dtype rand_init(dtype *M, uint size, dtype min, dtype max) {
  uint i;
  for(i=0; i<size; i++) {
    M[i] = (dtype) rand() / RAND_MAX * (max - min) + min;
  }
  return 0;
}

ttype time_diff(struct timespec start, struct timespec end) {
  ttype timing = ((end.tv_sec - start.tv_sec) +
                      (end.tv_nsec - start.tv_nsec) / 1E9);
  return timing;
}

/*
 * The function mat_blas_ddot(uint run, uint m, uint n) uses cblas_ddot().
 * It provides the cblas_ddot() function with a row of matrix A and vector B.
 * After the multiplication average time for multiplication is returned to
 * the main function.
 */

ttype mat_blas_ddot(uint run, uint row, uint col) {
  if (run < 1 || row < 1 || col < 1) {
    printf("\nInvalid value of parameter. using defaults\n");
    fflush(stdout);
    run = 100;
    row = 16;
    col = 16;
  }
  struct timespec start, end;
  ttype time_spent = 0;
  dtype *A, *B, *C;
  ttype *time_record;
  dtype min = 0, max = 255.0;
  uint incX = 1, incY = 1;

  A = (dtype *) malloc(row * col * sizeof(dtype));
  B = (dtype *) malloc(col * sizeof(dtype));
  C = (dtype *) calloc(row, sizeof(dtype));
  time_record = (ttype *) malloc(run * sizeof(ttype));

  if (A == NULL || B == NULL || C == NULL) {
    free(A);
    free(B);
    free(C);
    free(time_record);
    exit(0);
  }

  /* Initialize the matrix and the vector with random values */
  rand_init(A, row * col, min, max);
  rand_init(B, col, min, max);

  uint i, j;
  for(i = 0; i < run; i++) {
    rand_init(A, 1, min, max);
    rand_init(B, 1, min, max);

    clock_gettime(CLOCK_REALTIME, &start);

    for(j = 0; j < row; j++) {
      C[j] = cblas_ddot(col, B, incX, &A[j * col], incY);
    }

    clock_gettime(CLOCK_REALTIME, &end);
    /* Timing output */
    time_record[i] = time_diff(start, end);
    time_spent += time_record[i];
  }

  ttype avg_time = time_spent / (ttype) run;

  free(A);
  free(B);
  free(C);
  free(time_record);

  return avg_time;
}

int main (int argc, char *argv[]) {
  ttype time = 0;
  uint run;
  uint row, col;
  char *endrun, *endrow, *endcol;

  if (argc > 3) {
  run = strtol(argv[1], &endrun, 10);
 /*
  * A Matrix of size row * col and vector of length col are multiplied to
  * produce a product of size row * 1
  */
  row = strtol(argv[2], &endrow, 10);
  col = strtol(argv[3], &endcol, 10);
  }
else {
    printf("\nPlease enter 3 values for run and sizes. using defaults\n");
    fflush(stdout);
    run = 100;
    row = 16;
    col = 16;
  }

if (run < 1 || row < 1 || col < 1) {
  printf("\nInvalid value of parameter. using defaults\n");
  fflush(stdout);
  run = 100;
  row = 16;
  col = 16;
  }

  time = mat_blas_ddot(run, row, col);

  /* Timing output Average time */
  printf("\n%d * %d    %.12f ", row, col, time );

  return 0;
}
