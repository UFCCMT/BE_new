#!/bin/bash

DATASIZE=(2 4 8 16 32 64 128 256 512 1024 2048);

for n in ${DATASIZE[@]}
do
	echo "Datasize: $n"
	./loop "$n";
done




