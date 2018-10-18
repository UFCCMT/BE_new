#!/bin/bash

if [ $# -lt 1 ]; then
	echo "x---x---x---x---x---x---x---x---x"
	echo "No command line argument supplied"
	echo "Run again with file name as cmd line inputs"
	echo "x---x---x---x---x---x---x---x---x"
	exit 0
fi

FOUR=4
TOTAL=$(ls --size | grep total | awk '{print $2}')
SIZE=$(expr $TOTAL - $FOUR)
#echo "TOTAL = $TOTAL"
#echo "SIZE = $SIZE"
if [ $SIZE -eq 0 ]; then
	echo "x---x---x---x---x---x---x---x---x"    
    echo "No file exists to make .csv files!"
    echo "Aborting"
    echo "x---x---x---x---x---x---x---x---x"
    exit 0
fi

echo "Making .csv files"

cat *.out > $1'.csv'
grep "Average" $1'.csv' > $1'-avg.csv'
grep "10,1" $1'.csv' > $1'-params.csv'

FILES=$(ls *.csv | wc -l)
if [ $FILES -eq 0 ]; then
    echo "No .csv files were created! Check folder and script!"
else    
    echo ".csv files made!"
fi

echo "Listing *.csv files"
echo "-----------------------------------------"
ls *.csv
echo "-----------------------------------------"

echo "*---*---* COMPLETED *---*---*"
