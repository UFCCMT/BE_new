
CC=mpicc

CFLAGS=-g -Wall -O2 -DTIMESTEPS=10 -DELEMENT_SIZE=10
#Any #define in cmt-bone-be.c guarded by #ifndef #endif can be reset using CFLAGS


TARGET=cmtbonebe

all: $(TARGET)

$(TARGET): cmt-bone-be.o
	$(CC) -o $@ $^

main.o: cmt-bone-be.c
	$(CC) $(PFLAGS) -c $(CFLAGS) cmt-bone-be.c

clean:
	rm -rf *.o $(TARGET)
