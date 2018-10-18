
SHELL = /bin/sh

CFLAGS = -lrt -ltmc -lpthread -lm
CC = tile-gcc

MAIN = src/main_mm_udn.c
WITH = src/transfer_functions.c
OUT = mm_udn

all: $(MAIN)
	@$(CC) $(CFLAGS) $(WITH) $(MAIN) -o $(OUT);\
	echo "Compiled......";

clean: 
	rm -f $(OUT)
