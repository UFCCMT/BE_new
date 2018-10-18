#!/bin/sh
awk 'NR > 6 { print }' 'log 2.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	
awk 'NR > 6 { print }' 'log 4.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 4," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 8.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 8," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 16.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 16," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 32.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 32," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 64.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 64," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 128.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 128," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 256.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 256," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 512.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 512," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 1024.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 1024," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv

awk 'NR > 6 { print }' 'log 2048.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 2048," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 4096.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 4096," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 8192.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 8192," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 16384.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 16384," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 32768.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
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
	print "N = 32768," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3}' temp2.csv >> results.csv

rm temp.csv
rm temp1.csv
rm temp2.csv
