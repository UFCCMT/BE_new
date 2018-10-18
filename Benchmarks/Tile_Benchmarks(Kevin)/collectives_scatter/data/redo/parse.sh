#!/bin/sh
awk 'NR > 2 { print }' 'logconfig2-512-1.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-512-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG2.512 =,",sum/NR}' temp.csv > results.csv

awk 'NR > 2 { print }' 'logconfig2-1024-1.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig2-1024-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG2.1024 =,",sum/NR}' temp.csv >> results.csv

awk 'NR > 2 { print }' 'logconfig4-512-1.csv' > temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-2.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-3.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-4.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-5.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-6.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-7.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-8.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-9.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-10.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-11.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-12.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-13.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-14.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-15.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-16.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-17.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-18.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-19.csv' >> temp.csv
awk 'NR > 2 { print }' 'logconfig4-512-20.csv' >> temp.csv
awk -F "," '{sum+=$3} END { print "CONFIG4.512 =,",sum/NR}' temp.csv >> results.csv

rm temp.csv
