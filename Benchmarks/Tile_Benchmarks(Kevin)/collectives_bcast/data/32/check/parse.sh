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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv > results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv
	
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
	if ($17>max) {max = $17; max_thread = 16};
	if ($18>max) {max = $18; max_thread = 17};
	if ($19>max) {max = $19; max_thread = 18};
	if ($20>max) {max = $20; max_thread = 19};
	if ($21>max) {max = $21; max_thread = 20};
	if ($22>max) {max = $22; max_thread = 21};
	if ($23>max) {max = $23; max_thread = 22};
	if ($24>max) {max = $24; max_thread = 23};
	if ($25>max) {max = $25; max_thread = 24};
	if ($26>max) {max = $26; max_thread = 25};
	if ($27>max) {max = $27; max_thread = 26};
	if ($28>max) {max = $28; max_thread = 27};
	if ($29>max) {max = $29; max_thread = 28};
	if ($30>max) {max = $30; max_thread = 29};
	if ($31>max) {max = $31; max_thread = 30};
	if ($32>max) {max = $32; max_thread = 31};
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
	if ($2==15) {th15+=1};
	if ($2==16) {th16+=1};
	if ($2==17) {th17+=1};
	if ($2==18) {th18+=1};
	if ($2==19) {th19+=1};
	if ($2==20) {th20+=1};
	if ($2==21) {th21+=1};
	if ($2==22) {th22+=1};
	if ($2==23) {th23+=1};
	if ($2==24) {th24+=1};
	if ($2==25) {th25+=1};
	if ($2==26) {th26+=1};
	if ($2==27) {th27+=1};
	if ($2==28) {th28+=1};
	if ($2==29) {th29+=1};
	if ($2==30) {th30+=1};
	if ($2==31) {th31+=1}} END {
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
	th15 \
	",thread16 =," \
	th16 \
	",thread17 =," \
	th17 \
	",thread18 =," \
	th18 \
	",thread19 =," \
	th19 \
	",thread20 =," \
	th20 \
	",thread21 =," \
	th21 \
	",thread22 =," \
	th22 \
	",thread23 =," \
	th23 \
	",thread24 =," \
	th24 \
	",thread25 =," \
	th25 \
	",thread26 =," \
	th26 \
	",thread27 =," \
	th27 \
	",thread28 =," \
	th28 \
	",thread29 =," \
	th29 \
	",thread30 =," \
	th30 \
	",thread31 =," \
	th31}' temp2.csv >> results.csv

rm temp.csv
rm temp1.csv
rm temp2.csv
