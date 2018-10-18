#Compilation macros
CC = icpc
SOURCE_FILES = data_structures/*.cc interpolation/*.cc beo/procBEO/*.cc beo/commBEO/*.cc beo/meshBEO/*.cc
OBJECT_FILES = *.o
INCLUDE = ../headers
OUT = libsmp.so.1.0

COMPILE_FLAGS = -Wall -fPIC  -mmic
LINK_FLAGS = -shared -Wl,-soname,libsmp.so.1.0 -mmic

#Compilation commands
lib_data_structures:
	@$(CC) $(COMPILE_FLAGS) -c $(SOURCE_FILES) -I $(INCLUDE); \
	$(CC) $(LINK_FLAGS) -o $(OUT) $(OBJECT_FILES) ;
	
clean:
	@rm *.o 2>/dev/null;  \
	 rm *.so.* 2>/dev/null; \
	
	
