

SHELL = /bin/sh

CFLAGS = -lrt -ltmc -lpthread 
CC = tile-gcc

MAIN = src/main.c
WITH = src/transfer_functions.c src/init.c src/thread_fn.c
OUT = pattern

INCLUDE = ./headers/

all: $(MAIN)
	@$(CC) $(CFLAGS) $(WITH) $(MAIN) -o $(OUT) -I $(INCLUDE);\
	echo "Compiled......";

clean: 
	rm -f $(OUT)
