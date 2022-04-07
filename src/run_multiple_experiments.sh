#!/bin/bash

path="/root/workloads/$1.f"


# $1: chosen metric

# $2: chosen personality

# $3: oltp flag. if $3 -eq 1 -> nshadows and ndbwriters increase. if $3 -eq 2 -> nshadows and ndbwriters decrease
# if $3 -eq 3 -> nshadows increase and ndbwriters decrease. if $3 -eq 4 -> nshadows decrease and ndbwriters increase.

/bin/bash ./preparation.sh 


runExperiments(){
	/bin/bash ./preparation.sh	

	if [ $1 == "fileserver" ];then
		run=10
		filesize=128	# KB
		nthreads=50
		# we'll place a for here to update the parameters and run experiment.py multiple times.
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "oltp" ];then
		run=10
		filesize=10	# MB
		nshadows=200
		ndbwriters=25
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize+10))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters+5))
				
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize+10))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize+10))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize+10))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters+5))
			done
		fi

				
		
	elif [ $1 == "randomread" ];then
		run=10
		filesize=5000	# GB
		nthreads=1
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "randomwrite" ];then
		run=10
		filesize=5000	# GB
		nthreads=1
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "singlestreamread" ];then
		run=10
		filesize=5000	# GB
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
		filesize=10000	# GB
		nthreads=48
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "webproxy" ];then
		run=10
		meanfilesize=16	  # KB
		nthreads=100
		/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
		python3 experiment.py $2 $1

	elif [ $1 == "webserver" ];then
		run=10
		filesize=16	# KB
		nthreads=100
		/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreadas 0 0
		python3 experiment.py $2 $1

	else
		echo "<filebench personality options> : {fileserver, oltp, randomread, randomwrite, singlestreamread, singlestreamwrite, varmail, videoserver, webproxy, webserver}"
	fi
	
	echo "$(column -s, -t --table-columns 95%_conf_interval,std_dev,mean,throughput,filesize,filesize_mean,meanfilesize,nthreads,nshadows,ndbwriters /root/Desktop/experiment_stats.txt)" > /root/Desktop/experiment_stats.txt
}


# init_parameters $2
runExperiments $2 $1 $3


