#!/bin/bash 

path="/root/workloads/$1"

filesize=$(grep -hnr "\<filesize\>=[0-9][0-9]*" "$path")
filesize=${filesize#*=}
filesize=$((filesize/(1024*1024)))

filesize_with_mean=$(grep -hnr "parameters=mean:[0-9][0-9]*" "$path")
filesize_with_mean=${filesize_with_mean#*:}
filesize_with_mean=${filesize_with_mean%%;*}
filesize_with_mean=${filesize_with_mean#*:}
filesize_with_mean=$((filesize_with_mean/1024))

meanfilesize=$(grep -hnr "meanfilesize=[0-9][0-9]*" "$path")
meanfilesize=${meanfilesize#*=}
meanfilesize=$((meanfilesize/1024))

nthreads=$(grep -hnr "nthreads=[0-9][0-9]*" "$path")
nthreads=${nthreads#*=}
nthreads=$((nthreads/1))

nshadows=$(grep -hnr "nshadows=[0-9][0-9]*" "$path")
nshadows=${nshadows#*=}
nshadows=$((nshadows/1))

ndbwriters=$(grep -hnr "ndbwriters=[0-9][0-9]*" "$path")
ndbwriters=${ndbwriters#*=}
ndbwriters=$((ndbwriters/1))

# $2: 95% confidence interval 
# $3: standard deviation 
# $4: mean
# $5: throughput

echo "$2, $3, $4, $5, $filesize, $filesize_with_mean, $meanfilesize, $nthreads, $nshadows, $ndbwriters" >> /root/Desktop/experiment_stats.txt

# we'll use this later, maybe in the final script, right before we plot stuff.
# echo "$(column -s, -t --table-columns 95%_conf_interval,std_dev,mean,throughput,filesize,filesize_mean,meanfilesize,nthreads,nshadows,ndbwriters /root/Desktop/experiment_stats.txt)" > /root/Desktop/experiment_stats.txt


