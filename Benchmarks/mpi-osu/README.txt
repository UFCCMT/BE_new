@Author: Nalini Kumar
@Source: http://mvapich.cse.ohio-state.edu/benchmarks/ 

OSU Micro-benchmarks for measuring the performance of MPI over Infiniband, Omni-Path, Ethernet etc.
It contains extensions for CUDA and OpenACC.

The source contains:
1. Point-to-Point MPI Benchmarks: 
	Latency, multi-threaded latency, multi-pair latency, 
	multiple bandwidth / message rate test bandwidth, bidirectional bandwidth
2. Collective MPI Benchmarks: 
	Collective latency tests for various MPI collective operations such as 
	MPI_Allgather, MPI_Alltoall, MPI_Allreduce, MPI_Barrier, MPI_Bcast, MPI_Gather, 
	MPI_Reduce, MPI_Reduce_Scatter, MPI_Scatter and vector collectives.
3. Non-Blocking Collective (NBC) MPI Benchmarks: 
	Collective latency and Overlap tests for various MPI collective operations such as 
	MPI_Iallgather, MPI_Ialltoall, MPI_Ibarrier, MPI_Ibcast, MPI_Igather, MPI_Iscatter & vector collectives.
4. One-sided MPI Benchmarks: 
	one-sided put latency, one-sided put bandwidth, one-sided put bidirectional bandwidth, 
	one-sided get latency, one-sided get bandwidth, one-sided accumulate latency, compare and swap latency,
	fetch and operate and get_accumulate latency for MVAPICH2 (MPI-2 and MPI-3).
5. Point-to-Point OpenSHMEM Benchmarks: 
	put latency, get latency, message rate, atomics,
6. Collective OpenSHMEM Benchmarks: 
	collect latency, broadcast latency, reduce latency, and barrier latency
7. Point-to-Point UPC Benchmarks: 
	put latency, get latency
8. Collective UPC Benchmarks: 
	broadcast latency, scatter latency, gather latency, all_gather latency, and exchange latency
9. Point-to-Point UPC++ Benchmarks: 
	async copy put latency, async copy get latency
10. Collective UPC++ Benchmarks: 
	broadcast latency, scatter latency, gather latency, reduce latency, all_gather latency, & all_to_all latency
11. Startup Benchmarks: 
	osu_init, osu_hello



