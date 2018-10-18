// @ author: Nalini Kumar
// @ original author: Dylan Rudolph
// @ date: Dec-01-2016
// @ brief: In-situ instrumentation for performance benchmarking 



#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <mpi.h>

#include "time.h"
#include "params.h"



/* ------------------------------------------------------------------------ */
/* -------------------------- Type Definitions ---------------------------- */
/* ------------------------------------------------------------------------ */

// dtype: internal data storage type for calculations
// ttype: type to use for representing time
typedef double dtype;
typedef double ttype;

typedef struct {
  int size;
  dtype * V;
} vectortype, *vector;

typedef struct {
  int rows;
  int cols;
  dtype ** M;
} matrixtype, *matrix;

typedef struct {
  int rows;
  int cols;
  int layers;
  dtype *** T;
} ternixtype, *ternix;

/* NOTE: the definition below does not know the number of physical parameters,
   so it is dependent on the macro PHYSICAL_PARAMS for the size of B.
   The macro is defined in params.h */

typedef struct {
  ternix *B;
} elementtype, *element;



