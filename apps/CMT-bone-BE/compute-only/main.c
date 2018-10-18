/*
  A pseudo-representative application to model NEK.

Modified:
   Nalini Kumar  { UF CCMT }

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
#include <assert.h>

#include "params.h"
#include "dstructs.h" 
#include "utils.h"
#include "flux.h"




int main (int argc, char *argv[])
{

  /* ------------------------------- PARAMETER Setup------------------------------ */
  struct paramstype *params = malloc(sizeof(struct paramstype));
  assert(params != NULL);
  setup_parameters( argc, argv, params);
  print_parameters(params);


  /* ------------------------------ Timing Setup --------------------------- */
  struct timespec Sdr, Edr, Sds, Eds, Sdt, Edt, Sconv, Econv, Ssum, Esum, Srk, Erk;
  unsigned int TS = params->ITERATIONS;
  ttype t_dr[TS], t_ds[TS], t_dt[TS], t_conv[TS], t_sum[TS], t_rk[TS]; 



  /* ------------------------------ Memory Setup --------------------------- */
  srand( 11 );

  /* Index variables: {generic, timestep, element, block} */
  int i, t, e, b;

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



  /* For each timestep: */
  for ( t = 0; t < params->ITERATIONS; t++ ) {

      /* Generate Ur, Us, and Ut. */
      Sconv = now();
      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) { /* For each element owned by the processor */
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) { /* For each block in the element: */
          operation_conv(elements_Q[e]->B[b], RX, Hx, Hy, Hz, Ur, Us, Ut, params);
        }
      }
      Econv = now();
      t_conv[t] = tdiff(Sconv, Econv);

      /* Perform r-direction derivative computations */
      Sdr = now();
      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) {
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) {
          operation_dr(kernel, Ur, Vr, params);
        }
      }
      Edr = now();
      t_dr[t] = tdiff(Sdr, Edr);

      /* Perform s-direction derivative computations */
      Sds = now();
      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) {
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) {
          operation_ds(kernel, Us, Vs, params);
        }
      }
      Eds = now();
      t_ds[t] = tdiff(Sds, Eds);

      /* Perform t-direction derivative computations */
      Sdt = now();
      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) {
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) {
          operation_dt(kernel, Ut, Vt, params);
        }
      }
      Edt = now();
      t_dt[t] = tdiff(Sdt, Edt);

      /* Add Vr, Vs, and Vt to make R. */
      Ssum = now();
      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) {
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) {
          operation_sum( Vr, Vs, Vt, elements_R[e]->B[b], params );
        }
      }
      Esum = now();
      t_sum[t] = tdiff(Ssum, Esum);

      /* Perform a fake RK stage (without R from the last stage) to obtain a new value of Q. */
      Srk = now();          
      for ( e = 0; e < params->ELEMENTS_PER_PROCESS; e++ ) {
        for ( b = 0; b < params->PHYSICAL_PARAMS; b++ ) {
          operation_rk(elements_R[e]->B[b], elements_Q[e]->B[b], params);
        }
      }
      Erk = now();
      t_rk[t] = tdiff(Srk, Erk);

  } /* for each timestep ... */

     
    int c=0;
    for (c=0; c<TS; c++) { 
        if (c==0) { printf("conv, %.8f,", t_conv[c]); }
        else	  { printf("%.8f,", t_conv[c]); }
    }
    printf("\n");

    for (c=0; c<TS; c++) { 
        if (c==0) { printf("dr, %.8f,", t_dr[c]); }
        else	  { printf("%.8f,", t_dr[c]); }
    }
    printf("\n");


    for (c=0; c<TS; c++) { 
        if (c==0) { printf("ds, %.8f,", t_ds[c]); }
        else	  { printf("%.8f,", t_ds[c]); }
    }
    printf("\n");


    for (c=0; c<TS; c++) { 
        if (c==0) { printf("dt, %.8f,", t_dt[c]); }
        else	  { printf("%.8f,", t_dt[c]); }
    }
    printf("\n");

    for (c=0; c<TS; c++) { 
        if (c==0) { printf("sum, %.8f,", t_sum[c]); }
        else	  { printf("%.8f,", t_sum[c]); }
    }
    printf("\n");

    for (c=0; c<TS; c++) { 
        if (c==0) { printf("rk, %.8f,", t_rk[c]); }
        else	  { printf("%.8f,", t_rk[c]); }
    }
    printf("\n");




  /* -------------------------------- Cleanup ------------------------------ */
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
  
  return 0;
}

