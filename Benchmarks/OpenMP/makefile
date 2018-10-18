
# August 2013 - Dylan Rudolph
#Originally -O3 optimization in CFLAGS

SHELL = /bin/sh

CFLAGS = -fopenmp -lm -lrt -Wall -O3
CC = gcc

MAIN = omp_mm.c
OUT = omp_mm

all: $(MAIN)
	$(CC) $(CFLAGS) $(MAIN) -o $(OUT)

