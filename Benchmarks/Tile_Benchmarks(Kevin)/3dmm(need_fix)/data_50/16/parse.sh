#!/bin/sh
#Average
awk 'NR > 4 { print }' 'log_5config16.csv' > temp.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
} END { 
	print "AVERAGE,",
	"N = 5,",
	sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR
	}' temp.csv > average.csv
#Median
awk -F "," '{
	a[lines++] = $1;
	b[lines++] = $2;
	c[lines++] = $3;
	d[lines++] = $4;
	e[lines++] = $5;
} END { 
	n = asort(a);
	n = asort(b);
	n = asort(c);
	n = asort(d);
	n = asort(e);
	if (NR % 2) {
		print "MEDIAN,",
		"N = 5,", 
		a[(NR+1)/2],
		",",
		b[(NR+1)/2],
		",",
		c[(NR+1)/2],
		",",
		d[(NR+1)/2],
		",",
		e[(NR+1)/2]
	} else {
		print "MEDIAN,",
		"N = 5,", 
		(a[(NR/2)]+a[(NR/2)+1])/2.0,
		",",
		(b[(NR/2)]+b[(NR/2)+1])/2.0,
		",",
		(c[(NR/2)]+c[(NR/2)+1])/2.0,
		",",
		(d[(NR/2)]+d[(NR/2)+1])/2.0,
		",",
		(e[(NR/2)]+e[(NR/2)+1])/2.0
	}
}' temp.csv > median.csv

awk 'NR > 4 { print }' 'log_10config16.csv' > temp.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
} END { 
	print "AVERAGE,",
	"N = 10,",
	sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR
	}' temp.csv >> average.csv
#Median
awk -F "," '{
	a[lines++] = $1;
	b[lines++] = $2;
	c[lines++] = $3;
	d[lines++] = $4;
	e[lines++] = $5;
} END { 
	n = asort(a);
	n = asort(b);
	n = asort(c);
	n = asort(d);
	n = asort(e);
	if (NR % 2) {
		print "MEDIAN,",
		"N = 10,", 
		a[(NR+1)/2],
		",",
		b[(NR+1)/2],
		",",
		c[(NR+1)/2],
		",",
		d[(NR+1)/2],
		",",
		e[(NR+1)/2]
	} else {
		print "MEDIAN,",
		"N = 10,", 
		(a[(NR/2)]+a[(NR/2)+1])/2.0,
		",",
		(b[(NR/2)]+b[(NR/2)+1])/2.0,
		",",
		(c[(NR/2)]+c[(NR/2)+1])/2.0,
		",",
		(d[(NR/2)]+d[(NR/2)+1])/2.0,
		",",
		(e[(NR/2)]+e[(NR/2)+1])/2.0
	}
}' temp.csv >> median.csv


awk 'NR > 4 { print }' 'log_15config16.csv' > temp.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
} END { 
	print "AVERAGE,",
	"N = 15,",
	sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR
	}' temp.csv >> average.csv
#Median
awk -F "," '{
	a[lines++] = $1;
	b[lines++] = $2;
	c[lines++] = $3;
	d[lines++] = $4;
	e[lines++] = $5;
} END { 
	n = asort(a);
	n = asort(b);
	n = asort(c);
	n = asort(d);
	n = asort(e);
	if (NR % 2) {
		print "MEDIAN,",
		"N = 15,", 
		a[(NR+1)/2],
		",",
		b[(NR+1)/2],
		",",
		c[(NR+1)/2],
		",",
		d[(NR+1)/2],
		",",
		e[(NR+1)/2]
	} else {
		print "MEDIAN,",
		"N = 15,", 
		(a[(NR/2)]+a[(NR/2)+1])/2.0,
		",",
		(b[(NR/2)]+b[(NR/2)+1])/2.0,
		",",
		(c[(NR/2)]+c[(NR/2)+1])/2.0,
		",",
		(d[(NR/2)]+d[(NR/2)+1])/2.0,
		",",
		(e[(NR/2)]+e[(NR/2)+1])/2.0
	}
}' temp.csv >> median.csv

awk 'NR > 4 { print }' 'log_20config16.csv' > temp.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
} END { 
	print "AVERAGE,",
	"N = 20,",
	sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR
	}' temp.csv >> average.csv
#Median
awk -F "," '{
	a[lines++] = $1;
	b[lines++] = $2;
	c[lines++] = $3;
	d[lines++] = $4;
	e[lines++] = $5;
} END { 
	n = asort(a);
	n = asort(b);
	n = asort(c);
	n = asort(d);
	n = asort(e);
	if (NR % 2) {
		print "MEDIAN,",
		"N = 20,", 
		a[(NR+1)/2],
		",",
		b[(NR+1)/2],
		",",
		c[(NR+1)/2],
		",",
		d[(NR+1)/2],
		",",
		e[(NR+1)/2]
	} else {
		print "MEDIAN,",
		"N = 20,", 
		(a[(NR/2)]+a[(NR/2)+1])/2.0,
		",",
		(b[(NR/2)]+b[(NR/2)+1])/2.0,
		",",
		(c[(NR/2)]+c[(NR/2)+1])/2.0,
		",",
		(d[(NR/2)]+d[(NR/2)+1])/2.0,
		",",
		(e[(NR/2)]+e[(NR/2)+1])/2.0
	}
}' temp.csv >> median.csv

awk 'NR > 4 { print }' 'log_25config16.csv' > temp.csv
awk -F "," '{
	sum1+=$1;
	sum2+=$2;
	sum3+=$3;
	sum4+=$4;
	sum5+=$5;
} END { 
	print "AVERAGE,",
	"N = 25,",
	sum1/NR,
	",",
	sum2/NR,
	",",
	sum3/NR,
	",",
	sum4/NR,
	",",
	sum5/NR
	}' temp.csv >> average.csv
#Median
awk -F "," '{
	a[lines++] = $1;
	b[lines++] = $2;
	c[lines++] = $3;
	d[lines++] = $4;
	e[lines++] = $5;
} END { 
	n = asort(a);
	n = asort(b);
	n = asort(c);
	n = asort(d);
	n = asort(e);
	if (NR % 2) {
		print "MEDIAN,",
		"N = 25,", 
		a[(NR+1)/2],
		",",
		b[(NR+1)/2],
		",",
		c[(NR+1)/2],
		",",
		d[(NR+1)/2],
		",",
		e[(NR+1)/2]
	} else {
		print "MEDIAN,",
		"N = 25,", 
		(a[(NR/2)]+a[(NR/2)+1])/2.0,
		",",
		(b[(NR/2)]+b[(NR/2)+1])/2.0,
		",",
		(c[(NR/2)]+c[(NR/2)+1])/2.0,
		",",
		(d[(NR/2)]+d[(NR/2)+1])/2.0,
		",",
		(e[(NR/2)]+e[(NR/2)+1])/2.0
	}
}' temp.csv >> median.csv
rm temp.csv