/*
  A pseudo-representative application to model NEK.

Modified:
   Nalini Kumar  { UF CCMT }
   Aravind Neelakantan { UF CCMT }

Original:
    Copyright (C) 2016  { Dylan Rudolph, NSF CHREC, UF CCMT }

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
#include <mpi.h>
#include <assert.h>

#include "params.h"
#include "dstructs.h" 
#include "utils.h"
#include "flux.h"



/* -------------------------- Machine/Primary Parameters --------------------------- */
  #define MPI_DTYPE MPI_DOUBLE		// MPI datatypes
  #define CARTESIAN_DIMENSIONS 3  	// Setup for MPI Cartesian function calls
  #define CARTESIAN_REORDER 0
  #define CARTESIAN_WRAP {0, 0, 0}

//  #define PROFILE /* Depricate usage. Only use this code for insitu microbenchmarking */



/* ------------------------------ Main Loop ----------------------------------------- */

int main (int argc, char *argv[])
{

  /* ------------------------------- MPI Setup------------------------------ */

  MPI_Init(&argc, &argv);
    
  int rank, comrades;

  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &comrades);


  /* ------------------------------- PARAMETER Setup------------------------------ */

  struct paramstype *params = malloc(sizeof(struct paramstype));
  assert(params != NULL);

  setup_parameters( argc, argv, rank, params);
  if (rank == params->PROBED_RANK) { print_parameters(params); }

  int cart_sizes[CARTESIAN_DIMENSIONS] = {params->CARTESIAN_X, params->CARTESIAN_Y, params->CARTESIAN_Z};
  int cart_wrap[CARTESIAN_DIMENSIONS] = CARTESIAN_WRAP;

  MPI_Comm cart_comm;
  MPI_Cart_create( MPI_COMM_WORLD, CARTESIAN_DIMENSIONS, cart_sizes, cart_wrap,
                   CARTESIAN_REORDER, &cart_comm );



  /* ------------------------------ Timing Setup --------------------------- */

  struct timespec Sdr, Edr, Sds, Eds, Sdt, Edt, Sconv, Econv, Ssum, Esum, Srk, Erk;
  struct timespec Scomminit, Ecomminit, Scomminitaxis, Ecomminitaxis;
  struct timespec Sprepface, Eprepface, Scleanface, Ecleanface;
  unsigned int T = (params->TIMESTEPS) * (params->ELEMENTS_PER_PROCESS) * (params-> PHYSICAL_PARAMS);
  unsigned int count = (params->ELEMENTS_PER_PROCESS) * (params-> PHYSICAL_PARAMS);
  unsigned int ts = T/count;

  double t_dr[T], t_ds[T], t_dt[T], t_conv[T], t_sum[T], t_rk[T];
  //double t_comminit[ (params->TIMESTEPS) ];
  double t_comminitaxis[ (params->TIMESTEPS) * (CARTESIAN_DIMENSIONS)];
  //double t_prepface[  (params->TIMESTEPS) ];
  //double t_cleanface[ (params->TIMESTEPS) ];

  double ts_dr[ts], ts_ds[ts], ts_dt[ts], ts_conv[ts], ts_sum[ts], ts_rk[ts], ts_comminit[ts], ts_comminitaxis[ts];
  double ts_prepface[ts], ts_cleanface[ts];


  /* ------------------------------ Memory Setup --------------------------- */
  srand( 11 );

  /* Index variables: {generic, timestep, element, block, axis} */
  int i, t, e, b, axis;

  element elements_Q[ params->ELEMENTS_PER_PROCESS ];
  element elements_R[ params->ELEMENTS_PER_PROCESS ];

  for (e = 0; e < params->ELEMENTS_PER_PROCESS; e++) {
    elements_Q[e] = new_random_element(0, 10, params);
    elements_R[e] = new_zero_element(params);
  }

  /* The same kernel is used for everything */
  matrix kernel = new_random_matrix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, -10, 10);

  /* The same transformation ternix (RX) is used for all elements.
     This is an approximation, there should be one for each element. */
  ternix RX[9];

  for (i = 0; i < 9; i++) {
    RX[i] = new_random_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE, -1, 1);
  }

  /* Intermediate 3D structures: used in conv operation */
  ternix Hx = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);
  ternix Hy = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);
  ternix Hz = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);

  /* Intermediate 3D structures: outputs of conv operation */
  ternix Ur = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);
  ternix Us = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);
  ternix Ut = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);

  /* Intermediate 3D structures: outputs of derivative operations */
  ternix Vr = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);
  ternix Vs = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);
  ternix Vt = new_zero_ternix(params->ELEMENT_SIZE, params->ELEMENT_SIZE, params->ELEMENT_SIZE);



  /* ----------------------------------------------------------------------- */
  /* ------------------------------- Main Loop ----------------------------- */
  /* ----------------------------------------------------------------------- */
  
  unsigned int k = 0;
  unsigned int j = 0;
  unsigned int h = 0; // for comminit
  unsigned int g = 0; // for comminitaxis
  unsigned int x = 0; // for prepface and cleanface

  for ( t = 0; t < params->TIMESTEPS; t++ ) {  /* For each timestep: */
   // for (r = 0; r < params->RK; r++) { /* For each of the three 'stages': */
      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) { /* For each element owned by this rank: */
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) { /* For each block in the element: */

          /* Generate Ur, Us, and Ut. */
          Sconv = now();
          operation_conv(elements_Q[e]->B[b], RX, Hx, Hy, Hz, Ur, Us, Ut, params);
          Econv = now();

          /* Perform the three derivative computations (R, S, T). */
          Sdr = now();
          operation_dr(kernel, Ur, Vr, params);
          Edr = now(); 

          Sds = now();
          operation_ds(kernel, Us, Vs, params);
          Eds = now(); 

          Sdt = now();
          operation_dt(kernel, Ut, Vt, params);
          Edt = now(); 

          /* Add Vr, Vs, and Vt to make R. */
          Ssum = now();
          operation_sum( Vr, Vs, Vt, elements_R[e]->B[b], params );
          Esum = now();

	  t_conv[k] = tdiff(Sconv, Econv);
	  t_dr[k] = tdiff(Sdr, Edr);
	  t_ds[k] = tdiff(Sds, Eds);
	  t_dt[k] = tdiff(Sdt, Edt);
	  t_sum[k] = tdiff(Ssum, Esum);

	  k++;

        }
      }


      MPI_Barrier(MPI_COMM_WORLD);

      /* --------------------------- Communicate --------------------------- */
      /* above: plus neighbor, below: minus neighbor, index along this axis */
      int above, below, index;

      /* Unused status flag */
      MPI_Status status;


      Scomminit = now();

      /* Cartesian coordinates */
      int coords[CARTESIAN_DIMENSIONS];

      /* Determine our location in the cartesian grid. */
      MPI_Cart_coords(cart_comm, rank, CARTESIAN_DIMENSIONS, coords);

      vector above_faces_to_send, above_faces_to_recv;
      vector below_faces_to_send, below_faces_to_recv;

      Ecomminit = now();
      ts_comminit[h] = tdiff(Scomminit, Ecomminit);
      h++;

         /* NK: Since a coord index can only be even or odd, both sections of the 
           code are similarly instrumented. Even and odd only decides whether send
           or receives are called first. Face buffer creation and cleanup functions
           are called in identical order and location. Thus, the timing of should
           remain same. But, the number of such transfer, buffer prep, and buffer 
           clean up calls varies based on the number of neighbors. Therefore, for 
           timing we count the total number of timers, and divide the total time 
           for all the function calls by the first number. */
      
      unsigned int ntransfer=0; // to count the total number of transfers above and below
      double tmp_prepface=0, tmp_cleanface=0;

      for ( axis = 0; axis < CARTESIAN_DIMENSIONS; axis++ ) {

        Scomminitaxis = now();
        index = coords[axis]; /* Find our index along this axis. */
        MPI_Cart_shift(cart_comm, axis, 1, &below, &above);  /* Determine our neighbors. */
        Ecomminitaxis = now();
        t_comminitaxis[g] = tdiff(Scomminitaxis, Ecomminitaxis);
        g++;

        /* ------------------------Tansfers: Even Axis Index ------------------------ */
        /* If my index on this axis is even:
             - SEND  faces to    ABOVE  neighbor  (23)
             - RECV  faces from  ABOVE  neighbor  (47)
             - SEND  faces to    BELOW  neighbor  (61)
             - RECV  faces from  BELOW  neighbor  (73) */

        if ( (index % 2) == 0 ) {

          if ( above != MPI_PROC_NULL ) {
            ntransfer++;            

            Sprepface = now();
            above_faces_to_send = new_extracted_faces(elements_R, axis, 1, params);
            above_faces_to_recv = new_empty_faces(axis, params);
            Eprepface = now();
	    tmp_prepface += tdiff(Sprepface, Eprepface);
  
            MPI_Send( above_faces_to_send->V, above_faces_to_send->size,
                      MPI_DTYPE, above, 23, cart_comm );  //Send above

            MPI_Recv( above_faces_to_recv->V, above_faces_to_recv->size,
                      MPI_DTYPE, above, 47, cart_comm, &status ); //Recv above

	    Scleanface = now();
            delete_vector(above_faces_to_send);
            delete_vector(above_faces_to_recv);
	    Ecleanface = now();
            tmp_cleanface += tdiff(Scleanface, Ecleanface);
          }

          if ( below != MPI_PROC_NULL ) {
            ntransfer++;

            Sprepface = now();
            below_faces_to_send = new_extracted_faces(elements_R, axis, -1, params);
            below_faces_to_recv = new_empty_faces(axis, params);
            Eprepface = now();
            tmp_prepface += tdiff(Sprepface, Eprepface);

            MPI_Send( below_faces_to_send->V, below_faces_to_send->size,
                      MPI_DTYPE, below, 61, cart_comm ); // Send below

            MPI_Recv( below_faces_to_recv->V, below_faces_to_recv->size,
                      MPI_DTYPE, below, 73, cart_comm, &status ); // Recv below

            Scleanface = now();
            delete_vector(below_faces_to_send);
            delete_vector(below_faces_to_recv);
            Ecleanface = now();
            tmp_cleanface += tdiff(Scleanface, Ecleanface);
          }
        }

        /* ------------------------- Odd Axis Index ------------------------ */
        /* If my index on this axis is odd:
             - RECV  faces from  BELOW  neighbor  (23)
             - SEND  faces from  BELOW  neighbor  (47)
             - RECV  faces to    ABOVE  neighbor  (61)
             - SEND  faces from  ABOVE  neighbor  (73) */

        else {

          if ( below != MPI_PROC_NULL ) {
            ntransfer++;

            Sprepface = now();
            below_faces_to_send = new_extracted_faces(elements_R, axis, -1, params);
            below_faces_to_recv = new_empty_faces(axis, params);
            Eprepface = now();
            tmp_prepface += tdiff(Sprepface, Eprepface);

            MPI_Recv( below_faces_to_recv->V, below_faces_to_recv->size,
                      MPI_DTYPE, below, 23, cart_comm, &status ); //Recv below

            MPI_Send( below_faces_to_send->V, below_faces_to_send->size,
                      MPI_DTYPE, below, 47, cart_comm ); // Send below

            Scleanface = now();
            delete_vector(below_faces_to_send);
            delete_vector(below_faces_to_recv);
            Ecleanface = now();
            tmp_cleanface += tdiff(Scleanface, Ecleanface);
          }

          if ( above != MPI_PROC_NULL ) {

            ntransfer++;

            Sprepface = now();
            above_faces_to_send = new_extracted_faces(elements_R, axis, 1, params);
            above_faces_to_recv = new_empty_faces(axis, params);
            Eprepface = now();
            tmp_prepface += tdiff(Sprepface, Eprepface);

            MPI_Recv( above_faces_to_recv->V, above_faces_to_recv->size,
                      MPI_DTYPE, above, 61, cart_comm, &status ); //Recv above

            MPI_Send( above_faces_to_send->V, above_faces_to_send->size,
                      MPI_DTYPE, above, 73, cart_comm ); //Send above

            Scleanface = now();
            delete_vector(above_faces_to_send);
            delete_vector(above_faces_to_recv);
            Ecleanface = now();
            tmp_cleanface += tdiff(Scleanface, Ecleanface);
          }
        }

      } /* for each axis ... */

      ts_prepface[x] = tmp_prepface/ntransfer;
      ts_cleanface[x] = tmp_cleanface/ntransfer;
      x++;

      MPI_Barrier(MPI_COMM_WORLD);


      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) { /* For each element owned by this rank: */
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) { /* For each block in the element: */

          /* Perform a fake Runge Kutta stage (without R from the last stage)
             to obtain a new value of Q. */
	  Srk = now();
          operation_rk(elements_R[e]->B[b], elements_Q[e]->B[b], params);
	  Erk = now();
	  t_rk[j] = tdiff(Srk, Erk);
	  j++;
        }
      }
      
   // } /* For each RK stage ... */
  } /* for each timestep ... */


  /* ------- Print execution time profiling outputs ------------------------ */

  unsigned int c=0, mn=0;
  double tmp_conv=0, tmp_dr=0, tmp_ds=0, tmp_dt=0, tmp_sum=0, tmp_rk=0;
  /* Grouping all the time values to obtain timestep 
	    number of execution times */
  if ( rank == params->PROBED_RANK ) {
 
    for (c=0; c<T; c++) {
		tmp_conv += t_conv[c];
		tmp_dr += t_dr[c];
		tmp_ds += t_ds[c];
		tmp_dt += t_dt[c];
		tmp_sum += t_sum[c];
		tmp_rk += t_rk[c];
		
		if((c+1)%count == 0 && c!=0) {
			ts_conv[mn] = tmp_conv;
			ts_dr[mn] = tmp_dr;
			ts_ds[mn] = tmp_ds;
			ts_dt[mn] = tmp_dt;
			ts_sum[mn] = tmp_sum;
			ts_rk[mn] = tmp_rk;
			//printf("c,mn=%d,%d\n",c,mn);	//use for debugging only
			mn++;
			tmp_conv = 0; tmp_dr = 0;
			tmp_ds = 0; tmp_dt = 0;
			tmp_sum = 0; tmp_rk = 0;
		}
	} //printf("T,last_c=%d,%d\n",T,c);	//use for debugging only
  }


/*  c=0; mn=0;
  double tmp_comminit=0, tmp_prepface = 0, tmp_cleanface = 0;
  if ( rank == params->PROBED_RANK) {

    for (c=0; c < (params->TIMESTEPS) ; c++){
       tmp_comminit += t_comminit[c];
       tmp_prepface += t_prepface[c];
       tmp_cleanface += t_cleanface[c];

       if ( (c+1)%(params->RK) == 0 && c!=0) {
          ts_comminit[mn] = tmp_comminit;
          ts_prepface[mn] = tmp_prepface;
          ts_cleanface[mn] = tmp_cleanface;
          mn++;
	  tmp_comminit = 0;
          tmp_prepface = 0;
          tmp_cleanface = 0;
       } 

    }
  }
*/
  c=0; mn=0;
  double tmp_comminitaxis=0;
  if ( rank == params->PROBED_RANK) {
    for (c=0; c < (params->TIMESTEPS)*CARTESIAN_DIMENSIONS ; c++){
       tmp_comminitaxis += t_comminitaxis[c];
       if ( (c+1)%(CARTESIAN_DIMENSIONS) == 0 && c!=0) {
          ts_comminitaxis[mn] = tmp_comminitaxis;
          mn++;
	  tmp_comminitaxis = 0;
       } 
    }
  }




	
  /* Print all kernels for all the timesteps */
  if ( rank == params->PROBED_RANK ) {
 
    for (c=0; c<ts; c++) {
        if (c==0) { printf("conv, %.8f,", ts_conv[c]); }
        else      { printf("%.8f,", ts_conv[c]); }
    }
    printf("\n");

	for (c=0; c<ts; c++) {
        if (c==0) { printf("dr, %.8f,", ts_dr[c]); }
        else      { printf("%.8f,", ts_dr[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("ds, %.8f,", ts_ds[c]); }
        else      { printf("%.8f,", ts_ds[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("dt, %.8f,", ts_dt[c]); }
        else      { printf("%.8f,", ts_dt[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("sum, %.8f,", ts_sum[c]); }
        else      { printf("%.8f,", ts_sum[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("rk, %.8f,", ts_rk[c]); }
        else      { printf("%.8f,", ts_rk[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("comminit, %.8f,", ts_comminit[c]); }
        else      { printf("%.8f,", ts_comminit[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("comminitaxis, %.8f,", ts_comminitaxis[c]); }
        else      { printf("%.8f,", ts_comminitaxis[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("prepface, %.8f,", ts_prepface[c]); }
        else      { printf("%.8f,", ts_prepface[c]); }
    }
    printf("\n");

    for (c=0; c<ts; c++) {
        if (c==0) { printf("cleanface, %.8f,", ts_cleanface[c]); }
        else      { printf("%.8f,", ts_cleanface[c]); }
    }
    printf("\n");

  } /* Print only for probed rank */


  /* ----------------------------------------------------------------------- */
  /* -------------------------------- Cleanup ------------------------------ */
  /* ----------------------------------------------------------------------- */

  for (e = 0; e < params->ELEMENTS_PER_PROCESS; e++) {
    delete_element(elements_Q[e], params);
    delete_element(elements_R[e], params);
  }

  delete_matrix(kernel);

  for (i = 0; i < 9; i++) {
    delete_ternix(RX[i]);
  }

  delete_ternix(Hx);
  delete_ternix(Hy);
  delete_ternix(Hz);
  delete_ternix(Ur);
  delete_ternix(Us);
  delete_ternix(Ut);
  delete_ternix(Vr);
  delete_ternix(Vs);
  delete_ternix(Vt);

  free(params);
  MPI_Finalize();

  return 0;
}

