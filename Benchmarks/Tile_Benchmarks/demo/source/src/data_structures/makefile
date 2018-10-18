#Compilation macros
CC = g++
SOURCE_FILES = *.cc
OBJECT_FILES = *.o
INCLUDE = ../../headers
OUT = libsmpds.so.1.0

COMPILE_FLAGS = -Wall -fPIC 
LINK_FLAGS = -shared -Wl,-soname,libsmpds.so.1


#Compilation commands
lib_data_structures:
	$(CC) $(COMPILE_FLAGS) -c $(SOURCE_FILES) -I $(INCLUDE); \
	$(CC) $(LINK_FLAGS) -o $(OUT) $(OBJECT_FILES);
	
clean:
	@rm *.o;  \
	 rm *.so.*; \
	
	
