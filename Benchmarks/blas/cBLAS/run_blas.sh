#!/bin/bash
clear
NOW=$(date +"%m-%d-%Y")
NOWT=$(date +"%T")
echo
CC=gcc
CFLAGS='-lrt -Wall -lblas'
echo "$NOW $NOWT"
echo "The script starts now."
echo "Hi, $USER!"
echo "Enter the function number you want to run" 
echo "it can be either of the following"
read -p "1 (ddot)/ 2 (dscal)/ 3 (dgemm)/ 4 (dsymm)/ 5 (dsyrk)/ 6 (all) : " OUT

    if [ $OUT -eq $OUT 2>/dev/null ]
    then echo
	else OUT=10
	  echo "invalid function number"  
	fi

if [ -n "$OUT" ] && [ $OUT -gt 0 ] && [ $OUT -lt 7 ]
	then echo "Enter size range of matrix"
	read -p "start : " start

    if [ $start -eq $start 2>/dev/null ]
    then echo
	else start=10
	    echo "invalid value of start. setting the value of start = $start"  
	fi

	if [ -z "$start" ] || [ $start -lt 1 ]
	  then start=10
	    echo "invalid value of start. setting the value of start = $start"  
	fi

	read -p "end : " end

    if [ $end -eq $end 2>/dev/null ]
    then echo
	else num2=1
	  end=`expr $start + $num2`
	  echo "invalid value of end. setting the value of end = $end"  
	fi

	if [ -z "$end" ] || [ $end -lt 1 ]
	  then num2=1
	  end=`expr $start + $num2`
	  echo "invalid value of end. setting the value of end = $end"  
	fi

	if [ $start -gt $end ]
	  then temp=$start
	  start=$end
	  end=$temp
	  echo "Start value is greater than end value. switching the values"
	  echo "Start = $start     end = $end"
	fi

	read -p "increment : " inc

    if [ $inc -eq $inc 2>/dev/null ]
    then echo
	else inc=1
	  echo "invalid value of increment. setting the value of increment = $inc"  
	fi

	if [ -z "$inc" ] || [ $inc -lt 1 ]
	  then inc=1
	  echo "invalid value of increment. setting the value of increment = $inc"
	fi

	read -p "Enter number of times to run the program : " run

    if [ $run -eq $run 2>/dev/null ]
    then echo
	else run=1
	  echo "invalid value of run. setting the value of run = $run"  
	fi

	if [ -z "$run" ] || [ $run -lt 1 ]
	  then run=1
	  echo "invalid value of run. setting the value of run = $run"
	fi

else OUT=10
fi

if [ $OUT = 1 ]
      then OUT=ddot
      echo -e "\n\n$NOW $NOWT\n" >> data_ddot.txt
      for ((size=$start; size<=$end; size+=$inc))
        do
          ./$OUT $run $size $size
        done

elif [ $OUT = 2 ]
      then OUT=dscal
      echo -e "\n\n$NOW $NOWT\n" >> data_dscal.txt
      for ((size=$start; size<=$end; size+=$inc))
        do
          ./$OUT $run $size
        done

elif [ $OUT = 3 ]
      then OUT=dgemm
      echo -e "\n\n$NOW $NOWT\n" >> data_dgemm.txt
      for ((size=$start; size<=$end; size+=$inc))
        do
          ./$OUT $run $size $size $size
        done
elif [ $OUT = 4 ]
      then OUT=dsymm
      echo -e "\n\n$NOW $NOWT\n" >> data_dsymm.txt
      for ((size=$start; size<=$end; size+=$inc))
        do
          ./$OUT $run $size $size
        done
elif [ $OUT = 5 ]
      then OUT=dsyrk
      echo -e "\n\n$NOW $NOWT\n" >> data_dsyrk.txt
      for ((size=$start; size<=$end; size+=$inc))
        do
          ./$OUT $run $size $size
        done
elif [ $OUT = 6 ]
      then echo -e "\n\n$NOW $NOWT\n" >> data_ddot.txt
      echo -e "\n\n$NOW $NOWT\n" >> data_dscal.txt
      echo -e "\n\n$NOW $NOWT\n" >> data_dgemm.txt
      echo -e "\n\n$NOW $NOWT\n" >> data_dsymm.txt
      echo -e "\n\n$NOW $NOWT\n" >> data_dsyrk.txt
      for ((size=$start; size<=$end; size+=$inc))
        do
          ./ddot $run $size $size
          ./dscal $run $size
          ./dgemm $run $size $size $size
          ./dsymm $run $size $size
          ./dsyrk $run $size $size
        done

else echo "Function not recognized. Aborting..."
fi
echo -e "script ends now\n"
