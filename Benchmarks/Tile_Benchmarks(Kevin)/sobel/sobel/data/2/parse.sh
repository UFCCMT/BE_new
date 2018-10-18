#!/bin/sh
awk 'NR > 6 { print }' 'log_320_240_config2.csv' > temp.csv
#awk -F "," '{ diff=$5-$1; print diff }' temp.csv > temp1.csv
awk 'NR < 2 { print }' 'log_320_240_config2.csv' > results.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
	sum6+=$6;
	sum7+=$7;
	sum8+=$8;
} END { 
	print sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR,
	",",
	sum6/NR,
	",",
	sum7/NR,
	",",
	sum8/NR
}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log_480_320_config2.csv' > temp.csv
awk 'NR < 2 { print }' 'log_480_320_config2.csv' >> results.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
	sum6+=$6;
	sum7+=$7;
	sum8+=$8;
} END { 
	print sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR,
	",",
	sum6/NR,
	",",
	sum7/NR,
	",",
	sum8/NR
}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log_640_480_config2.csv' > temp.csv
awk 'NR < 2 { print }' 'log_640_480_config2.csv' >> results.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
	sum6+=$6;
	sum7+=$7;
	sum8+=$8;
} END { 
	print sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR,
	",",
	sum6/NR,
	",",
	sum7/NR,
	",",
	sum8/NR
}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log_800_600_config2.csv' > temp.csv
awk 'NR < 2 { print }' 'log_800_600_config2.csv' >> results.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
	sum6+=$6;
	sum7+=$7;
	sum8+=$8;
} END { 
	print sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR,
	",",
	sum6/NR,
	",",
	sum7/NR,
	",",
	sum8/NR
}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log_1024_768_config2.csv' > temp.csv
awk 'NR < 2 { print }' 'log_1024_768_config2.csv' >> results.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
	sum6+=$6;
	sum7+=$7;
	sum8+=$8;
} END { 
	print sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR,
	",",
	sum6/NR,
	",",
	sum7/NR,
	",",
	sum8/NR
}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log_1280_1024_config2.csv' > temp.csv
awk 'NR < 2 { print }' 'log_1280_1024_config2.csv' >> results.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
	sum6+=$6;
	sum7+=$7;
	sum8+=$8;
} END { 
	print sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR,
	",",
	sum6/NR,
	",",
	sum7/NR,
	",",
	sum8/NR
}' temp.csv >> results.csv
rm temp.csv
