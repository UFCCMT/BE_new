
SHELL = /bin/sh

CFLAGS = -lrt -lm -O3
CC = gcc

MAIN = src/main.c
WITH = src/thread_fn.c
INCLUDE = header/
OUT = sobel

all: $(MAIN)
	@$(CC) $(CFLAGS) $(WITH) $(MAIN) -o $(OUT) -I $(INCLUDE);\
	echo "Compiled......";

clean: 
	rm -f $(OUT)
