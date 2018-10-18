
SHELL = /bin/sh

LIBS = -lsmp -lpthread -lm
CC = icpc

MAIN = src/main.cc
WITH = src/init.cc  src/finalize.cc src/thread_fn.cc
INCLUDE = header/
LIBPATH = ../../libs
OUT = sobel

all: $(MAIN)
	@$(CC)  $(WITH) $(MAIN) -o $(OUT) -mmic -I $(INCLUDE) -L $(LIBPATH) $(LIBS);\
	echo "Compiled......";

clean: 
	rm -f $(OUT)
