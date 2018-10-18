SHELL = /bin/sh

CFLAGS = -lm -lrt -Wall
CC = gcc

MAIN = dot.c
OUT = dotprod

all: $(MAIN)
	$(CC) $(CFLAGS) $(MAIN) -o $(OUT)

clean: 
	rm -f $(OUT)
