
# August 2013 - Dylan Rudolph

SHELL = /bin/sh

CFLAGS = -lrt -ltmc -lpthread -lm
#-O2
CC = tile-gcc

MAIN = mm2.c
OUT = mm2

all: $(MAIN)
	$(CC) $(CFLAGS) $(MAIN) -o $(OUT)

