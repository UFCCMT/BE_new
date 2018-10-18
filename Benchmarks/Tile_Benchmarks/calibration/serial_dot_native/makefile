
SHELL = /bin/sh

CFLAGS = -lrt -ltmc -lpthread 
CC = tile-gcc

MAIN = src/dot.c
OUT  = dot_serial

all: $(MAIN)
	@$(CC) $(CFLAGS) $(MAIN) -o $(OUT);\
	echo "Compiled......";

clean: 
	rm -f $(OUT)
