#!/bin/bash

path="/root/workloads/$1.f"


# $1: chosen metric

# $2: chosen personality

# $3: Experiment type flag. e.g. for oltp: if $3 -eq 1 -> nshadows and ndbwriters increase. if $3 -eq 2 -> nshadows and ndbwriters decrease
# if $3 -eq 3 -> nshadows increase and ndbwriters decrease. if $3 -eq 4 -> nshadows decrease and ndbwriters increase.
# flags 5, 6, 7, 8 correspond only to oltp personality option and decrease the filesize parameter.
/bin/bash ./preparation.sh 


runExperiments(){
	/bin/bash ./preparation.sh	

	if [ $1 == "fileserver" ];then
		run=10
		filesize=128	# KB
		nthreads=50
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize*2))
				((nthreads=nthreads+10))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize/2))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize*2))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize/2))
				((nthreads=nthreads+10))		
			done
		fi
		

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
		elif [ $3 -eq 5 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize-2))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters+5))
				
			done
		elif [ $3 -eq 6 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize-2))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 7 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize-2))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 8 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				python3 experiment.py $2 $1
				((filesize=filesize-2))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters+5))
			done
		fi

				
		
	elif [ $1 == "randomread" ] || [$1 == "randomwrite"] || [$1 == "singlestreamread"];then
		run=10
		filesize=5000	# GB
		nthreads=50
		
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+1000))
				((nthreads=nthreads+10))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-1000))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+1000))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-1000))
				((nthreads=nthreads+10))		
			done
		fi

	elif [ $1 == "singlestreamwrite" ];then
		run=10
		nthreads=50
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 0 $nthreads 0 0
				python3 experiment.py $2 $1
				((nthreads=nthreads+10))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 0 $nthreads 0 0
				python3 experiment.py $2 $1
				((nthreads=nthreads-10))		
			done
		fi

	elif [ $1 == "videoserver" ];then
		run=10
		filesize=10000	# GB
		nthreads=50
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+2000))
				((nthreads=nthreads+10))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-2000))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+2000))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-2000))
				((nthreads=nthreads+10))		
			done
		fi

	elif [ $1 == "webproxy" ];then
		run=10
		meanfilesize=16	  # KB
		nthreads=100
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+3))
				((nthreads=nthreads+20))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-3))
				((nthreads=nthreads+20))		
			done
		fi
		

	elif [ $1 == "webserver" ];then
		run=10
		filesize=16	# KB
		nthreads=100
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+3))
				((nthreads=nthreads+20))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize+3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				python3 experiment.py $2 $1
				((filesize=filesize-3))
				((nthreads=nthreads+20))		
			done
		fi

	else
		echo "<filebench personality options> : {fileserver, oltp, randomread, randomwrite, singlestreamread, singlestreamwrite, varmail, videoserver, webproxy, webserver}"
	fi
	
	echo "$(column -s, -t --table-columns 95%_conf_interval,std_dev,mean,throughput,filesize,filesize_mean,meanfilesize,nthreads,nshadows,ndbwriters /root/Desktop/experiment_stats.txt)" > /root/Desktop/experiment_stats.txt
	# plot here
}


# init_parameters $2
runExperiments $2 $1 $3


