# September 2013 - Dylan Rudolph

SHELL = /bin/sh

CFLAGS = -lm -lrt -Wall -O2
CC = gcc

MAIN = dotprod.c
OUT = dotprod

all: $(MAIN)
	$(CC) $(CFLAGS) $(MAIN) -o $(OUT)

clean: 
	rm -f $(OUT)
