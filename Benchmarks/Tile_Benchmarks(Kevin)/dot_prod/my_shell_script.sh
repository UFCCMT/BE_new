#! /bin/bash

#./execute.sh $1 $2
timeout 60s ./execute.sh $1

rc=$?

if [[ $rc != 0 ]] ; then
    sshpass -p "kcFAA888" ssh -o StrictHostKeyChecking=no cheng@tile-2.hcs.ufl.edu \
	"kill -9 -1"
	
	sleep 5
	
	./execute_restart.sh $1
fi


exit 0