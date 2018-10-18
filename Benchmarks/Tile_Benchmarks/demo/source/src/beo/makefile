#Compilation macros

ROOT = /home/amartya/Documents/CHREC/smp/smp_sim/
CC = g++
SOURCE_FILES = commBEO/*.cc procBEO/*.cc meshBEO/*.cc
OBJECT_FILES = *.o
INCLUDE = ../../headers
OUT = libsmpBEO.so.1.0

COMPILE_FLAGS = -Wall -fPIC 
LINK_FLAGS = -shared -Wl,-soname,libsmpds.so.1 -lpthread
LIBPATH = $(ROOT)libs/

#Compilation commands
libbeo:
	$(CC) $(COMPILE_FLAGS) -c $(SOURCE_FILES) -I $(INCLUDE); \
	$(CC) $(LINK_FLAGS) -o $(OUT) $(OBJECT_FILES) -L $(LIBPATH) -lsmpds -lsmpinterpolation;
	
clean:
	@rm *.o;  \
	 rm *.so.*; \
	
	
