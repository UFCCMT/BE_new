/*
 * The program finds the time to do a scalar multiplication with a vector.
 * The program takes the numer of times to run the program and the size of
 * a vector and gives the average time as output.
 * Running the function :
 *                    ./programme_name run N
 *
 * example :          ./blas_timing 100 50
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
 * The function mat_blas_dscal(uint run, uint size) uses cblas_dscal function,
 * it creates a vector of 'size' length and produces the scaled product. It
 * returns the time to calculate the product.
 */

ttype mat_blas_dscal(uint run, uint size) {
  if (run < 1 || size < 1) {
    printf("\nInvalid value of parameter. using defaults\n");
    fflush(stdout);
    run = 100;
    size = 32;
  }
  struct timespec start, end;
  ttype time_spent = 0;
  dtype *A;
  ttype *time_record;
  dtype alpha = 1;
  dtype min = 0, max = 255.0;
  uint incX = 1;

  A = (dtype *) malloc(size * sizeof(dtype));
  time_record = (ttype *) malloc(run * sizeof(ttype));

  if (A == NULL) {
    free(A);
    free(time_record);
    return 1;
  }

  /* Initialize the vector with random values */
  rand_init(A, size, min, max);

  uint i;
  for(i = 0; i < run; i++) {
    alpha = (dtype) rand() / RAND_MAX * (max - min) + min;

    clock_gettime(CLOCK_REALTIME, &start);

    cblas_dscal(size, alpha, A, incX);

    clock_gettime(CLOCK_REALTIME, &end);

    /* Timing output */
    time_record[i] = time_diff(start, end);
    time_spent += time_record[i];
  }

  ttype avg_time = time_spent / (ttype) run;

  free(A);
  free(time_record);

  return avg_time;
}

int main (int argc, char *argv[]) {
  ttype time = 0;

/*
 * run : number of times to run the matrix multiplication
 * size : size for the vector
 */
  uint run;
  uint size;
  char *endrun, *endsize;

  if (argc > 2) {
    run = strtol(argv[1], &endrun, 10);
   /*
    * all the elements in the vector of length 'size'
    * are multiplied to a random scalar
    */
    size = strtol(argv[2], &endsize, 10);
  }
  else {
    printf("\nPlease enter 2 values for run and size. using defaults\n");
    fflush(stdout);
    run = 100;
    size = 32;
  }
  
  if (run < 1 || size < 1) {
    printf("\nInvalid value of parameter. using defaults\n");
    fflush(stdout);
    run = 100;
    size = 32;
  }

  time = mat_blas_dscal(run,size);

  /* Timing output Average time */
  printf("\n%d   %.12f", size, time);
  return 0;
}
