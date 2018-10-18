/*
  A simple single-threaded dot-product benchmark.

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

/* 64 bit float type. */
typedef double dtype;

/* 64 bit int type. */
typedef long long int ltype; 

/* 32 bit float type. */
typedef float ftype;

/* 32 bit int type. */
typedef int itype;

typedef struct {
  uint size;
  dtype * V;
} dvectortype, *dvector;

typedef struct {
  uint size;
  ltype * V;
} lvectortype, *lvector;

typedef struct {
  uint size;
  ftype * V;
} fvectortype, *fvector;

typedef struct {
  uint size;
  itype * V;
} ivectortype, *ivector;

typedef unsigned int uint;
struct timespec start_time_mem, end_time_mem, start_time_run, end_time_run;


/* -------------------------------------------------------------------------- */
/* ------------------- Operations for FLOAT64-Typed Vectors ----------------- */
/* -------------------------------------------------------------------------- */

dvector new_dvector(uint size)
/* Make a new 'dvector' type and allocate memory for it. */
{
  dvector X = malloc(sizeof(dvectortype));
  X->size = size;
  X->V = malloc(sizeof( dtype * ) * size);
  return X;
}

void delete_dvector(dvector X)
/* Frees up the memory allocated for the dvector X. */
{
  free(X->V);
  free(X);
}

void random_fill_dvector(dvector X, dtype lower, dtype upper)
/* Fills a dvector with random numbers over [lower, upper) */
{
  uint i;
  for (i = 0; i<(X->size); i++) {
    X->V[i] = ((dtype) rand() / (RAND_MAX)) * 
      (upper - lower + 1) + lower;
  }
}

dvector new_random_dvector(uint size, dtype lower, dtype upper)
/* Returns a random newly-allocated dvector */
{
  dvector X = new_dvector(size);
  random_fill_dvector(X, lower, upper);
  return X;
}

dtype ddot_product(dvector X, dvector Y)
/* Returns the dot product of x and y. */
{
  if( X->size != Y->size ) { exit(0); }
  dtype p = 0;

  uint i;
  for (i = 0; i<(X->size); i++) {
    p += X->V[i] * Y->V[i];
  }
  
  return p;
}

/* -------------------------------------------------------------------------- */
/* -------------------- Operations for INT64-Typed Vectors ------------------ */
/* -------------------------------------------------------------------------- */

lvector new_lvector(uint size)
/* Make a new 'lvector' type and allocate memory for it. */
{
  lvector X = malloc(sizeof(lvectortype));
  X->size = size;
  X->V = malloc(sizeof( ltype * ) * size);
  return X;
}

void delete_lvector(lvector X)
/* Frees up the memory allocated for the lvector X. */
{
  free(X->V);
  free(X);
}

void random_fill_lvector(lvector X, ltype lower, ltype upper)
/* Fills a lvector with random numbers over [lower, upper) */
{
  uint i;
  for (i = 0; i<(X->size); i++) {
    X->V[i] = ((ltype) rand() / (RAND_MAX)) * 
      (upper - lower + 1) + lower;
  }
}

lvector new_random_lvector(uint size, ltype lower, ltype upper)
/* Returns a random newly-allocated lvector */
{
  lvector X = new_lvector(size);
  random_fill_lvector(X, lower, upper);
  return X;
}

ltype ldot_product(lvector X, lvector Y)
/* Returns the dot product of x and y. */
{
  if( X->size != Y->size ) { exit(0); }
  ltype p = 0;

  uint i;
  for (i = 0; i<(X->size); i++) {
    p += X->V[i] * Y->V[i];
  }
  
  return p;
}

/* -------------------------------------------------------------------------- */
/* ------------------- Operations for FLOAT32-Typed Vectors ----------------- */
/* -------------------------------------------------------------------------- */

fvector new_fvector(uint size)
/* Make a new 'fvector' type and allocate memory for it. */
{
  fvector X = malloc(sizeof(fvectortype));
  X->size = size;
  X->V = malloc(sizeof( ftype * ) * size);
  return X;
}

void delete_fvector(fvector X)
/* Frees up the memory allocated for the fvector X. */
{
  free(X->V);
  free(X);
}

void random_fill_fvector(fvector X, ftype lower, ftype upper)
/* Fills a fvector with random numbers over [lower, upper) */
{
  uint i;
  for (i = 0; i<(X->size); i++) {
    X->V[i] = ((ftype) rand() / (RAND_MAX)) * 
      (upper - lower + 1) + lower;
  }
}

fvector new_random_fvector(uint size, ftype lower, ftype upper)
/* Returns a random newly-allocated fvector */
{
  fvector X = new_fvector(size);
  random_fill_fvector(X, lower, upper);
  return X;
}

ftype fdot_product(fvector X, fvector Y)
/* Returns the dot product of x and y. */
{
  if( X->size != Y->size ) { exit(0); }
  ftype p = 0;

  uint i;
  for (i = 0; i<(X->size); i++) {
    p += X->V[i] * Y->V[i];
  }
  
  return p;
}

/* -------------------------------------------------------------------------- */
/* ------------------- Operations for FLOAT32-Typed Vectors ----------------- */
/* -------------------------------------------------------------------------- */

ivector new_ivector(uint size)
/* Make a new 'ivector' type and allocate memory for it. */
{
  ivector X = malloc(sizeof(ivectortype));
  X->size = size;
  X->V = malloc(sizeof( itype * ) * size);
  return X;
}

void delete_ivector(ivector X)
/* Frees up the memory allocated for the ivector X. */
{
  free(X->V);
  free(X);
}

void random_fill_ivector(ivector X, itype lower, itype upper)
/* Fills a ivector with random numbers over [lower, upper) */
{
  uint i;
  for (i = 0; i<(X->size); i++) {
    X->V[i] = ((itype) rand() / (RAND_MAX)) * 
      (upper - lower + 1) + lower;
  }
}

ivector new_random_ivector(uint size, itype lower, itype upper)
/* Returns a random newly-allocated ivector */
{
  ivector X = new_ivector(size);
  random_fill_ivector(X, lower, upper);
  return X;
}

itype idot_product(ivector X, ivector Y)
/* Returns the dot product of x and y. */
{
  if( X->size != Y->size ) { exit(0); }
  itype p = 0;

  uint i;
  for (i = 0; i<(X->size); i++) {
    p += X->V[i] * Y->V[i];
  }

  return p;
}

/* -------------------------------------------------------------------------- */
/* ----------------------------- Common Functions --------------------------- */
/* -------------------------------------------------------------------------- */

double time_diff(struct timespec a, struct timespec b)
/* Finds the time difference. */
{
  double dt = (( b.tv_sec - a.tv_sec ) + 
               ( b.tv_nsec - a.tv_nsec ) / 1E9);
  return dt;
}

/* -------------------------------------------------------------------------- */
/* ------------------------------- Main Function ---------------------------- */
/* -------------------------------------------------------------------------- */

int main (int argc, char *argv[])
{
  int i;

  /* Parse the input to get the vector size. */
  uint N;
  char *endptr;
  if (argc > 1) { N = strtol(argv[1], &endptr, 10); }
  else { N = 8; }
  uint size = N;

  /* 'runs' is the number of times over which to average.
     It is reduced gradually as the vector size increases.*/
  int runs = 8388608 / N * 2;
  if (N > 8388608) { runs++; }

  /* Initialize the vectors */
  srand( time(0) );

  /* ------------------------------------------------------------------------ */
  /* -------------------- Benchmark for the F64 type ------------------------ */
  /* ------------------------------------------------------------------------ */

  dvector A = new_random_dvector(size, 0, 10);
  dvector B = new_random_dvector(size, 0, 10);

  /* Actual dot product multiply */
  clock_gettime(CLOCK_REALTIME, &start_time_run);

  /* Do it 'runs' times for consistency. */
  for (i=0; i<runs; i++) {
    ddot_product(A, B);
  }

  clock_gettime(CLOCK_REALTIME, &end_time_run);

  /* Free things up */
  delete_dvector(A);
  delete_dvector(B);

  /* Calculate the time differences and normalize for 'runs' */
  double dt_run = time_diff(start_time_run, end_time_run) / (double) runs;
  printf("RUNTIME: %.8f;r\n", dt_run);

  return 0;
}
