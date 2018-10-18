#!/bin/sh
awk 'NR > 6 { print }' 'log 2.csv' > temp.csv
awk -F "," '{ print $3","$6 }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1}} END {
	print "N = 2," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv > results.csv
	
	
rm temp.csv
rm temp1.csv
rm temp2.csv
