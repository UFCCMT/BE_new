#!/bin/sh
awk 'NR > 2 { print }' 'logconfig32-64-0.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-1.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-64-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG32.64 =,",sum/NR}' temp.csv > results.csv

awk 'NR > 2 { print }' 'logconfig32-128-0.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-1.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-128-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG32.128 =,",sum/NR}' temp.csv >> results.csv

awk 'NR > 2 { print }' 'logconfig32-256-0.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-1.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-256-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG32.256 =,",sum/NR}' temp.csv >> results.csv

awk 'NR > 2 { print }' 'logconfig32-512-0.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-1.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-512-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG32.512 =,",sum/NR}' temp.csv >> results.csv

awk 'NR > 2 { print }' 'logconfig32-1024-0.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-1.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-1024-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG32.1024 =,",sum/NR}' temp.csv >> results.csv

awk 'NR > 2 { print }' 'logconfig32-2048-0.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-1.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig32-2048-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG32.2048 =,",sum/NR}' temp.csv >> results.csv

rm temp.csv