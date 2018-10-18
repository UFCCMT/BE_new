
SHELL = /bin/sh

CFLAGS = -lrt -ltmc -lpthread -lm
CC = tile-gcc

MAIN = src/main.c
WITH = src/init.c src/thread_fn.c
INCLUDE = header/
OUT = sobel

all: $(MAIN)
	@$(CC) $(CFLAGS) $(WITH) $(MAIN) -o $(OUT) -I $(INCLUDE);\
	echo "Compiled......";

clean: 
	rm -f $(OUT)
