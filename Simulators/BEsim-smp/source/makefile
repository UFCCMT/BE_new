#Makefile for smp.

SHELL = /bin/bash

#Compiler macros
CC = g++
COMPILE_FLAGS = -c -Wall -fPIC 
LINK_FLAGS = -shared -Wl,-soname,libsmp.so.1.0 -lpthread
INCLUDE = ./headers

OBJECT_FILES = *.o
OUT = libsmp.so.1.0

#Source files
SOURCE_FILES = src/data_structures/*.cc src/interpolation/*.cc src/beo/procBEO/*.cc src/beo/worker_threads/*.cc src/exascale_machine/*.cc


#Compile commands
build_lib:
	$(CC) $(COMPILE_FLAGS) $(SOURCE_FILES) -I $(INCLUDE); \
	$(CC) $(LINK_FLAGS)  -o $(OUT) $(OBJECT_FILES); \
	echo -e "\nCompilation done...\n";
	
clean:
	@rm *.o 2>/dev/null; \
	echo -e "Removing object files.\n"; \
	rm *.so.* 2>/dev/null; \
	echo -e "Removing shared library.\n\nCleaned files.....\n"; \
	rm *~ 2>/dev/null;
