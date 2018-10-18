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
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 2," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv > results.csv
	
awk 'NR > 6 { print }' 'log 4.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 4," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 8.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 8," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 16.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 16," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 32.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 32," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 64.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 64," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 128.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 128," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 256.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 256," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 512.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 512," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 1024.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 1024," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 2048.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 2048," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 4096.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 4096," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 8192.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 8192," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 16384.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 16384," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	
awk 'NR > 6 { print }' 'log 32768.csv' > temp.csv
awk -F "," '{ print }' temp.csv > temp1.csv
awk -F "," '{
	max=0;
	max_thread=99;
	if ($1>max) {max = $1; max_thread = 0};
	if ($2>max) {max = $2; max_thread = 1};
	if ($3>max) {max = $3; max_thread = 2};
	if ($4>max) {max = $4; max_thread = 3};
	if ($5>max) {max = $5; max_thread = 4};
	if ($6>max) {max = $6; max_thread = 5};
	if ($7>max) {max = $7; max_thread = 6};
	if ($8>max) {max = $8; max_thread = 7};
	if ($9>max) {max = $9; max_thread = 8};
	if ($10>max) {max = $10; max_thread = 9};
	if ($11>max) {max = $11; max_thread = 10};
	if ($12>max) {max = $12; max_thread = 11};
	if ($13>max) {max = $13; max_thread = 12};
	if ($14>max) {max = $14; max_thread = 13};
	if ($15>max) {max = $15; max_thread = 14};
	if ($16>max) {max = $16; max_thread = 15};
	print max","max_thread
	}' temp1.csv > temp2.csv
awk -F "," '{
	sum+=$1;
	if ($2==0) {th0+=1};
	if ($2==1) {th1+=1};
	if ($2==2) {th2+=1};
	if ($2==3) {th3+=1};
	if ($2==4) {th4+=1};
	if ($2==5) {th5+=1};
	if ($2==6) {th6+=1};
	if ($2==7) {th7+=1};
	if ($2==8) {th8+=1};
	if ($2==9) {th9+=1};
	if ($2==10) {th10+=1};
	if ($2==11) {th11+=1};
	if ($2==12) {th12+=1};
	if ($2==13) {th13+=1};
	if ($2==14) {th14+=1};
	if ($2==15) {th15+=1}} END {
	print "N = 32768," \
	sum/NR \
	",thread0 =," \
	th0 \
	",thread1 =," \
	th1 \
	",thread2 =," \
	th2 \
	",thread3 =," \
	th3 \
	",thread4 =," \
	th4 \
	",thread5 =," \
	th5 \
	",thread6 =," \
	th6 \
	",thread7 =," \
	th7 \
	",thread8 =," \
	th8 \
	",thread9 =," \
	th9 \
	",thread10 =," \
	th10 \
	",thread11 =," \
	th11 \
	",thread12 =," \
	th12 \
	",thread13 =," \
	th13 \
	",thread14 =," \
	th14 \
	",thread15 =," \
	th15}' temp2.csv >> results.csv
	

rm temp.csv
rm temp1.csv
rm temp2.csv
