
SHELL = /bin/bash

CFLAGS =   -ltmc -lpthread -lm -lrt
CC = tile-gcc

MAIN = src/main.c
WITH = src/init.c src/barrier.c src/finalize.c src/thread_fn.c src/transfer_functions.c
INCLUDE = header/
OUT = mm

all: $(MAIN)
	$(CC) $(WITH) $(MAIN) -o $(OUT) -I $(INCLUDE) $(CFLAGS) ; \
	echo "Compiled......";

clean: 
	rm -f $(OUT)
