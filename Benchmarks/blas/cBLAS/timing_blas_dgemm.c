/*
 * Matrix-matrix multiplication using blas library. The program takes the
 * size of matrix and numer of times to run the program and gives the average
 * time as output.
 * Running the function :
 *                    ./programme_name run row1 col1 col2
 *
 * example :          ./blas_timing 100 50 50 50
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
 * The function mat_blas(int m, int n, int k) uses clas_dgemm function, it
 * takes the 2 matrix of size mxk and kxn multiplies them and produces a
 * matrix of size mxn. It returns the time to calculate the product matrix.
 */

ttype mat_blas(uint run, uint row1, uint col1, uint col2) {
  if (row1 < 1 || col1 < 1 || col2 < 1 || run < 1) {
    printf("\nInvalid value of parameter. using defaults\n");
    fflush(stdout);
    run = 100;
    row1 = 16;
    col1 = 16;
    col2 = 16;
  }
  uint row2 = col1;
  struct timespec start, end;
  ttype time_spent = 0;
  dtype *A, *B, *C;
  ttype *time_record;
  dtype alpha, beta;
  dtype min = 0, max = 255.0;
  alpha = 1.0; beta = 0.0;

  A = (dtype *) malloc(row1 * col1 * sizeof(dtype));
  B = (dtype *) malloc(row2 * col2 * sizeof(dtype));
  C = (dtype *) calloc(row1 * col2, sizeof(dtype));
  time_record = (ttype *) malloc(run * sizeof(ttype));

  if (A == NULL || B == NULL || C == NULL) {
    free(A);
    free(B);
    free(C);
    free(time_record);
    exit(0);
  }

  /* Initialize the matrix with random values */
  rand_init(A, row1 * col1, min, max);
  rand_init(B, row2 * col2, min, max);

  uint i;
  for(i = 0; i < run; i++) {
    rand_init(A, 1, min, max);
    rand_init(B, 1, min, max);

    clock_gettime(CLOCK_REALTIME, &start);

    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                row1, col2, col1, alpha, A, col1, B, col2, beta, C, col2);

    clock_gettime(CLOCK_REALTIME, &end);

    /* Timing output */
    time_record[i] = time_diff(start, end);
    time_spent += time_record[i];
  }

  ttype avg_time = time_spent / run;

  free(A);
  free(B);
  free(C);
  free(time_record);

  return avg_time;
}

int main (int argc, char *argv[]) {
  ttype time = 0;
  uint run;
  uint row1, col1, col2;
  char *endrun, *endrow1, *endcol1, *endcol2;
  
  if (argc > 4) {
    run = strtol(argv[1], &endrun, 10);
  /*
   * 2 matrix of size mxk and kxn multiplied to
   * produce a matrix of size mxn
   */
    row1 = strtol(argv[2], &endrow1, 10);
    col1 = strtol(argv[3], &endcol1, 10);
    col2 = strtol(argv[4], &endcol2, 10);
  }
  else {
    printf("\nPlease enter 4 values for run and sizes. using defaults\n");
    fflush(stdout);
    run = 100;
    row1 = 16;
    col1 = 16;
    col2 = 16;
  }

  if (row1 < 1 || col1 < 1 || col2 < 1 || run < 1) {
    printf("\nInvalid value of parameter. using defaults\n");
    fflush(stdout);
    run = 100;
    row1 = 16;
    col1 = 16;
    col2 = 16;
  }

  time = mat_blas(run,row1,col1,col2);

  /* Timing output Average time */
  printf("\n%d * %d   %.12f ", row1, col1, time);
  
  return 0;
}
