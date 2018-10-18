SHELL=/bin/sh
CFLAGS = -lrt -Wall -lblas
CC = gcc

all: ddot dscal dgemm dsymm dsyrk

ddot: timing_blas_ddot.c
	$(CC) -o ddot timing_blas_ddot.c $(CFLAGS)

dscal: timing_blas_dscal.c
	$(CC) -o dscal timing_blas_dscal.c $(CFLAGS)

dgemm: timing_blas_dgemm.c
	$(CC) -o dgemm timing_blas_dgemm.c $(CFLAGS)

dsymm: timing_blas_dsymm.c
	$(CC) -o dsymm timing_blas_dsymm.c $(CFLAGS)

dsyrk: timing_blas_dsyrk.c
	$(CC) -o dsyrk timing_blas_dsyrk.c $(CFLAGS)

.PHONY: clean
clean:
	rm -r ddot dscal dgemm dsymm dsyrk
