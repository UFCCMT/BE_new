#!/bin/bash

#core_list="256 1024 2048 4096 8192"
core_list="256"
lx1_list="20"
elpercore_list="2 8 16 32 64"
lpartpercore="0 1024 4096 65536 131072"
root=`pwd`

for core in $core_list
do
  for lx1 in $lx1_list
  do
    for elpercore in $elpercore_list
    do
      for lpart in $lpartpercore
      do
			#<Pre-jobscript data>
                        cd $root
			mkdir 'core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
			cp SIZE './core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
                        cp * './core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
		        cd './core_'$core'lx1_'$lx1'lelt_'$elpercore'lpart_'$lpart
			
			lelg=$core*$elpercore
		        sed -i "s/(lx1=5,/(lx1=$lx1,/" SIZE
			sed -i "s/(lxd=5,/(lxd=$lx1,/" SIZE
			sed -i "s/,lelt=512,/,lelt=$elpercore,/" SIZE
			sed -i "s/(lelg = 512)/(lelg = $lelg)/" SIZE
			sed -i "s/(lp =512)/(lp =$core)/" SIZE
			sed -i "s/(lpart = 128000 )/(lpart = $lpart )/" SIZE
                        nelt=$(($elpercore * $core))
			nelx=$(expr "$nelt" / 64)
			nw=$lpart
			sed -i "s;nw = 50000;nw = ($nw)/2;" cmtparticles.usrp
			if [ $nelx -gt 900 ]
			then
				nlx=$(expr "$nelx" / 4)
				sed -i "s/-8  -8  -8/-$nlx  -16  -16/" box.box
			else
				sed -i "s/-8  -8  -8/-$nelx  -8  -8/" box.box
			fi
			echo "box.box" > gbox.in
			echo "Updates Complete!!!"
			module load intel/2016.0.109 openmpi/1.10.2
			genbox < gbox.in
			mv box.rea b3dp.rea
			echo "b3dp" > gmap.in
			echo "0.2" >> gmap.in
			genmap < gmap.in
			chmod 777 generate.sh
			chmod 777 clean.sh
			echo "Running the job script"
			#</Pre-jobscript data>
			./generate.sh $core
			
			#<Generate Script>
			#!/bin/bash
			chmod 777 makenek
			./makenek b3dp
			echo b3dp > SESSION.NAME
			echo `pwd`'/' >> SESSION.NAME
			mkdir profiles
			#<SBATCH Submit>
			echo "#!/bin/bash" > jobfile
			echo '#SBATCH -D '`pwd` >> jobfile
			echo "#SBATCH --job-name=job-${PWD##*/}.job" >> jobfile	#Job name
			echo '#SBATCH --mail-type=ALL' >> jobfile		#Mail events (NONE,BEGIN,END,ALL)
			echo '#SBATCH --mail-user=schenna@ufl.edu'  >> jobfile		#your email id
			echo "#SBATCH --ntasks=$1" >> jobfile		#Number of MPI ranls
			echo "#SBATCH --cpus-per-task=1" >> jobfile			#Number of cores per MPI rank
			#echo "#SBATCH --nodes=1" >> jobfile		#Number of Nodes
			echo "#SBATCH --mem-per-cpu=1gb" >> jobfile			#Per processor memory
			echo "#SBATCH -t 08:00:00" >> jobfile				#Walltime
			echo "#SBATCH -o job-${PWD##*/}.out" >> jobfile	#STDOUT
			echo "#SBATCH -e job-${PWD##*/}.err" >> jobfile	#STDERR
			echo " " >> jobfile
			echo "module load intel/2016.0.109 openmpi/1.10.2" >> jobfile
			echo " " >> jobfile
			echo "mpirun -np $1 ./nek5000 b3dp > log_${PWD##*/}.txt" >> jobfile
			cp jobfile job-${PWD##*/}.job

			sbatch --qos=ccmt job-${PWD##*/}.job
			#</SBATCH Submit>
			#</Generate Script>
		   
      done
    done
  done
done
