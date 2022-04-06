#!/bin/bash

path="/root/workloads/$1.f"


# $1: chosen metric

# $2: chosen personality

/bin/bash ./preparation.sh

init_parameters(){
		

	if [ $1 == "fileserver" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 128 50 0 0

	elif [ $1 == "oltp" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 10 0 200 10

	elif [ $1 == "randomread" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 5000 1 0 0

	elif [ $1 == "randomwrite" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 5000 1 0 0

	elif [ $1 == "singlestreamread" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 5000 1 0 0

	elif [ $1 == "singlestreamwrite" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 0 1 0 0

	elif [ $1 == "videoserver" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 10000 48 0 0

	elif [ $1 == "webproxy" ];then
		/bin/bash ./parameter_handler.sh $1 10 16 0 100 0 0

	elif [ $1 == "webserver" ];then
		/bin/bash ./parameter_handler.sh $1 10 0 16 100 0 0

	else
		echo "<filebench personality options> : {fileserver, oltp, randomread, randomwrite, singlestreamread, singlestreamwrite, varmail, videoserver, webproxy, webserver}"
	fi
}


runExperiments(){
	/bin/bash ./preparation.sh	

	if [ $1 == "fileserver" ];then
		run=10
		filesize=128
		nthreads=50
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "oltp" ];then
		run=10
		filesize=10
		nshadows=200
		ndbwriters=10
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
		python3 experiment.py $2 $1

	elif [ $1 == "randomread" ];then
		run=10
		filesize=5000
		nthreads=1
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "randomwrite" ];then
		run=10
		filesize=5000
		nthreads=1
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "singlestreamread" ];then
		run=10
		filesize=5000
		nthreads=1
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "singlestreamwrite" ];then
		run=10
		nthreads=1
		/bin/bash ./parameter_handler.sh $1 $run 0 0 $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "videoserver" ];then
		run=10
		filesize=10000
		nthreads=48
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "webproxy" ];then
		run=10
		meanfilesize=16
		nthreads=100
		/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "webserver" ];then
		run=10
		filesize=16
		nthreads=100
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreadas 0 0
		python3 experiment.py $2 $1

	else
		echo "<filebench personality options> : {fileserver, oltp, randomread, randomwrite, singlestreamread, singlestreamwrite, varmail, videoserver, webproxy, webserver}"
	fi
	
	echo "$(column -s, -t --table-columns 95%_conf_interval,std_dev,mean,throughput,filesize,filesize_mean,meanfilesize,nthreads,nshadows,ndbwriters /root/Desktop/experiment_stats.txt)" > /root/Desktop/experiment_stats.txt
}


# init_parameters $2
runExperiments $2 $1


