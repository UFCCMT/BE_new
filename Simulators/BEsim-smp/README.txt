***IMPORTANT***

INITIAL SETUP
	1.  Generate library file by running the makefile located in smp_sim_5/source.
	2.  Copy the newly generated libsmp.so.1.0 file, paste in smp_sim_5/libs.

PATH VARIABLE
	The libs directory must be added to the system's PATH either permanently or manually whenever
	the machine is rebooted.

	Command:
		export LD_LIBRARY_PATH={directory path to smp_sim_5/libs}

COMPILING
	General format of the command to compile the appBEO located in smp_sim_5/apps/Example-2dmm:
		g++ -o outputFileName sourceFileNames -I ../../headers -L ../../libs -lsmp -lpthread

	Example:
		g++ -o mm thread_fn.cc main.cc -I ../../headers -L ../../libs -lsmp -lpthread