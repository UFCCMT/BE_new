// @ author: Nalini Kumar
// @ original author: Dylan Rudolph
// @ date: Dec-01-2016
// @ brief: In-situ instrumentation for performance benchmarking 



#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <mpi.h>

#include "time.h"



/* -------------------------- Primary Parameters --------------------------- */

/* The rank which shows its timing output */
#ifndef PROBED_RANK
#define PROBED_RANK 0
#endif

/* Number of simulation timesteps */
#ifndef TIMESTEPS
#define TIMESTEPS 3
#endif

/* Number of processes in each dimension (must all be even numbers)
   MPI must be run with (product of these numbers) processes. */
#ifndef CARTESIAN_X 
#define CARTESIAN_X 2 
#endif

#ifndef CARTESIAN_Y
#define CARTESIAN_Y 2
#endif

#ifndef CARTESIAN_Z
#define CARTESIAN_Z 2
#endif

/* Number of elements per process in each dimension */
#ifndef ELEMENTS_X
#define ELEMENTS_X 2
#endif

#ifndef ELEMENTS_Y
#define ELEMENTS_Y 2
#endif

#ifndef ELEMENTS_Z
#define ELEMENTS_Z 2
#endif

/* Size of each element (cubic) */
#ifndef ELEMENT_SIZE
#define ELEMENT_SIZE 5
#endif

/* Number of physics parameters tracked */
#define PHYSICAL_PARAMS 5

/* ------------------------- Secondary Parameters -------------------------- */

#define MPI_DTYPE MPI_DOUBLE
#define CARTESIAN_DIMENSIONS 3
#define CARTESIAN_REORDER 0
#define CARTESIAN_WRAP {0, 0, 0}
#define RK 3

/* ------------------------- Calculated Parameters ------------------------- */

#define ELEMENTS_PER_PROCESS (ELEMENTS_X * ELEMENTS_Y * ELEMENTS_Z)
#define ELEMENTS_ON_X_FACE (ELEMENTS_Y * ELEMENTS_Z)
#define ELEMENTS_ON_Y_FACE (ELEMENTS_X * ELEMENTS_Z)
#define ELEMENTS_ON_Z_FACE (ELEMENTS_X * ELEMENTS_Y)
#define FACE_SIZE (ELEMENT_SIZE * ELEMENT_SIZE)


/* --------------------------- Timing Parameter selection  -------------------------- */
     /* Use this to print the timing parameter on specific module in the program
        PROFILE == FALSE  ---->   Print each timestep (csv format) and its avg.
        PROFILE == TRUE   ---->   Compute(A), comm and compute(B) per step with avg.  */

  #define PROFILE

