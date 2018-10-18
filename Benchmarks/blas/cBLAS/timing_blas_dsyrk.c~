/*
 * Matrix multiplication using blas library. The program takes the size of
 * matrix and numer of times to run the program and gives the average time
 * as output. The multiplication here done is such that matrix A is multiplied
 * with the transpose of A to produce a symmetric matrix C.
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

#define MAX(a,b) a > b ? a : b
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
int print_mat(dtype *C, uint row, uint col) {
  uint i, j;
  for(i=0; i<row; i++) {
  printf("\n");
    for(j=0; j<col; j++) {
	printf(" %f ", C[i*col+j]);
	}
  }
return 0;
}
dtype fill_triangle_symm(dtype *M, uint m, uint n) {
  if(m != n) {
    printf("Symmetric matrix has to be a square matrix");
	return 1;
  }
  uint i, j, k = 0;
  for(i=0; i<m; i++) {
    for(j=k; j<n; j++) {
      M[j*n+i] = M[i*n+j];
    }
    k++;
  }
  return 0;
}

ttype time_diff(struct timespec start, struct timespec end) {
  ttype timing = ((end.tv_sec - start.tv_sec) +
                      (end.tv_nsec - start.tv_nsec) / 1E9);
  return timing;
}

/*
 * The function mat_blas_syrk(uint run, uint m, uint n) uses cblas_dsyrk
 * function, it takes a matrix A of size ldaxn multiplies it with the
 * transpose of A and produces a matrix of size ldcxn. It returns the time
 * to calculate the product matrix.
 */

ttype mat_blas_syrk(uint run, uint n, uint k) {
  if (run < 1 || n < 1 || k < 1) {
    printf("\nInvalid value of parameter. using defaults\n");
    fflush(stdout);
    run = 100;
    n = 16;
    k = 16;
  }
  uint lda = n;
  uint ldc = n;
  struct timespec start, end;
  ttype time_spent = 0;
  dtype *A, *C;
  ttype *time_record;
  dtype alpha, beta;
  dtype min = 0, max = 255.0;
  alpha = 1.0; beta = 0.0;

  A = (dtype *) malloc(lda * k * sizeof(dtype));
  C = (dtype *) calloc(ldc * n, sizeof(dtype));
  time_record = (ttype *) malloc(run * sizeof(ttype));

  if (A == NULL || C == NULL) {
    free(A);
    free(C);
    free(time_record);
    exit(0);
  }

  /* Initialize the matrix with random values */
  rand_init(A, lda*n, min, max);

  uint i;
  for(i = 0; i < run; i++) {
    rand_init(A, 1, min, max);

    clock_gettime(CLOCK_REALTIME, &start);

    cblas_dsyrk(CblasRowMajor, CblasUpper, CblasNoTrans, n, k,
                alpha, A, lda, beta, C, ldc);

    /*
     * Since cblas_dsyrk() with the parameters used returns the upper triangle
     * of the symmetric product matrix, the lower triangle has to be copied
     * from the upper half to produce the whole matrix. This operation is
     * taken in consideration while timing.
     */
    print_mat(C, ldc, n);
    fill_triangle_symm(C, ldc, n);
    print_mat(C, ldc, n);

    clock_gettime(CLOCK_REALTIME, &end);

    /* Timing output */
    time_record[i] = time_diff(start, end);
    time_spent += time_record[i];
  }

  ttype avg_time = time_spent / (ttype) run;

  free(A);
  free(C);
  free(time_record);

  return avg_time;
}

int main (int argc, char *argv[]) {
  ttype time = 0;
  uint run;
  uint row, col;
  char *endrun, *endrow, *endcol;

  if (argc > 2) {
  run = strtol(argv[1], &endrun, 10);
  /*
   * a matrix of size row * col is multiplied with its transpose
   * to produce a symmetric matrix of size row * row
   */
  row = strtol(argv[2], &endrow, 10);
  col = strtol(argv[3], &endcol, 10);
  }
  else {
    printf("\nPlease enter 3 values for run and size. using defaults\n");
    fflush(stdout);
    run = 100;
    row = 16;
    col = 16;
  }

  if (row < 1 || col < 1 || run < 1) {
    printf("\nInvalid value of parameter. using defaults\n");
    fflush(stdout);
    run = 100;
    row = 16;
    col = 16;
  }

  time = mat_blas_syrk(run,row,col);

  /* Timing output Average time */
  printf("\n%d * %d    %.12f ", row, col, time );

  return 0;
}
