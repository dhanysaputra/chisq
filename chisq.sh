#!/bin/bash -l

minbq=0
minmq=0
file=''
pvalue='1e-12'
n=0
for ARG in $*
do
	if [[ $ARG == file=* ]] && [[ $ARG == *.snvcount.txt ]];
	then
		myparam=$( cut -d '=' -f 2- <<< "$ARG" | awk -F ".snvcount.txt" '{print $1}' )
		file2=$myparam
		file=$file2.snvcount.txt
	elif [[ $ARG == minbq=* ]];
	then
		myparam=$( cut -d '=' -f 2- <<< "$ARG" )
		minbq=$myparam
	elif [[ $ARG == minmq=* ]];
	then
		myparam=$( cut -d '=' -f 2- <<< "$ARG" )
		minmq=$myparam
	elif [[ $ARG == pvalue=* ]];
	then
		myparam=$( cut -d '=' -f 2- <<< "$ARG" )
		pvalue=$myparam
	elif [[ $ARG == n=* ]];
	then
		myparam=$( cut -d '=' -f 2- <<< "$ARG" )
		n=$myparam
	fi
done
if [[ ${#file} ==  0 ]];
then
	echo "You need to specify the name of the TN snv count file"
fi
if [[ ${#minmq} ==  0 ]];
then
	echo "Minimum mapping quality is set to 0 since you didn't specify minmq"
fi
if [[ ${#minbq} ==  0 ]];
then
	echo "Minimum base quality is set to 0 since you didn't specify minbq"
fi
if [[ ${#pvalue} ==  '1e-12' ]];
then
	echo "Maximum p-value is set to 1e-12"
fi
if [[ ${#file} !=  0 ]];
then
	date;
	paste <(tail -n +2 $file | cut -f 1,2,3) <(tail -n +2 $file | cut -f 12,16 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=minbq && $j>=minmq) counter+=1;} print counter}') <(tail -n +2 $file | cut -f 13,17 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=minbq && $j>=minmq) counter+=1;} print counter}') <(tail -n +2 $file | cut -f 14,18 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=minbq && $j>=minmq) counter+=1;} print counter}') <(tail -n +2 $file | cut -f 15,19 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=minbq && $j>=minmq) counter+=1;} print counter}') <(tail -n +2 $file | cut -f 28,32 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=minbq && $j>=minmq) counter+=1;} print counter}') <(tail -n +2 $file | cut -f 29,33 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=minbq && $j>=minmq) counter+=1;} print counter}') <(tail -n +2 $file | cut -f 30,34 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=minbq && $j>=minmq) counter+=1;} print counter}') <(tail -n +2 $file | cut -f 31,35 | awk -v minmq=$minmq -v minbq=$minbq -F '[;\t]' '{counter=0; for (i=1; i<=NF/2; i+=1) {j=i*2; if ($i>=0 && $j>=30) counter+=1;} print counter}') | awk 'function abs(x){return ((x < 0.0) ? -x : x)} { if ($4+$8 >= $5+$9) {one=$4; two=$8; three=$5; four=$9;} else {one=$5; two=$9; three=$4; four=$8;} if ($6+$10 > $three+$four) { if ($6+$10 > $one+$two) {three=one; four=two; one=$6; two=$10;} else {three=$6; four=$10;} } if ($7+$11 > $three+$four) { if ($7+$11 > $one+$two) {three=one; four=two; one=$7; two=$11;} else { three=$7; four=$11;} }; if (one+two!=0 && one+three!=0 && three+four!=0 && two+four!=0) {N=one+two+three+four; adbc=abs(one*four-two*three)-N/2; print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t"  N*adbc*adbc/(one+three)/(two+four)/(one+two)/(three+four) } }' | python chisqpro.py | sort -t$'\t' -k13,13g > $file2.chisquare.txt;
	if [[ ${#n} == 0 ]]; then
		less $file2.chisquare.txt | awk -v pvalue=$pvalue '{ if ($13<pvalue) print $0 }' | python nsnp.py $file2.vcf > $file2.vcffiltered
	else
		less $file2.chisquare.txt | awk -v pvalue=$pvalue '{ if ($13<pvalue) print $0 }' | head -$n | python nsnp.py $file2.vcf > $file2.vcffiltered
	fi
	date;
fi