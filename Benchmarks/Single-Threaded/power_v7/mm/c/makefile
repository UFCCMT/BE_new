
SHELL = /bin/sh

CFLAGS = -lrt -lm -O3
CC = xlc

MAIN = src/main.c
WITH = src/init.c src/thread_fn.c
INCLUDE = header/
OUT = mm_udn

all: $(MAIN)
	@$(CC) $(CFLAGS) $(WITH) $(MAIN) -o $(OUT) -I $(INCLUDE);\
	echo "Compiled......";

clean: 
	rm -f $(OUT)
