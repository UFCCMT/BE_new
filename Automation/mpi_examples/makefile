
CC=mpicc

CFLAGS= -g -Wall -O2

hello_world:
	$(CC) -o hello_world.o mpi_hello_world.c

mat_mult:
	$(CC) -o mat_mult.o mpi_mat_mult.c	

bcast:
	$(CC) -o bcast.o mpi_bcast.o

reduce:
	$(CC) -o reduce.o mpi_reduce.c

send_recv:
	$(CC) -o send_recv.o mpi_send_recv.c
	$(CC) -c $(CFLAGS) mpi_send_recv.c -o send_recv.o

clean:
	rm -rf *.o $(TARGET)
