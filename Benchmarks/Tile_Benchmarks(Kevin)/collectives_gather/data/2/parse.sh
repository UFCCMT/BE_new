#!/bin/sh
awk 'NR > 6 { print }' 'log 2.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 2,",sum/NR}' temp.csv > results.csv

awk 'NR > 6 { print }' 'log 4.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 4,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 8.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 8,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 16.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 16,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 32.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 32,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 64.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 64,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 128.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 128,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 256.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 256,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 512.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 512,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 1024.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 1024,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 2048.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 2048,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 4096.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 4096,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 8192.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 8192,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 16384.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 16384,",sum/NR}' temp.csv >> results.csv

awk 'NR > 6 { print }' 'log 32768.csv' > temp.csv
awk -F "," '{sum+=$3} END { print "N = 32768,",sum/NR}' temp.csv >> results.csv


rm temp.csv