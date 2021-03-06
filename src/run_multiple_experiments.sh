#!/bin/bash

path="/root/workloads/$1.f"


# $1: chosen metric

# $2: chosen personality

# $3: Experiment type flag. e.g. for oltp: if $3 -eq 1 -> nshadows and ndbwriters increase. if $3 -eq 2 -> nshadows and ndbwriters decrease
# if $3 -eq 3 -> nshadows increase and ndbwriters decrease. if $3 -eq 4 -> nshadows decrease and ndbwriters increase.

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
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+20))
				((nthreads=nthreads+10))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-25))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+128))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-25))
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
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+5))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters+5))
				
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+5))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+5))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+5))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters+5))
			done
		elif [ $3 -eq 5 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-2))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters+5))
				
			done
		elif [ $3 -eq 6 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-2))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 7 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-2))
				((nshadows=nshadows+25))
				((ndbwriters=ndbwriters-5))
			done
		elif [ $3 -eq 8 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize 0 $nshadows $ndbwriters
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-2))
				((nshadows=nshadows-25))
				((ndbwriters=ndbwriters+5))
			done
		fi

				
		
	elif [ $1 == "randomread" ] || [ $1 == "randomwrite" ] || [ $1 == "singlestreamread" ];then
		run=10
		filesize=5000	# GB
		nthreads=50
		
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+1000))
				((nthreads=nthreads+10))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-1000))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+1000))
				((nthreads=nthreads-10))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
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
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((nthreads=nthreads+10))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 0 $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((nthreads=nthreads-10))		
			done
		fi

	elif [ $1 == "videoserver" ];then
		run=10
		filesize=16	# GB
		nthreads=16
		if [ $3 -eq 1 ];then
			for i in {1..15};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+1))
				((nthreads=nthreads+1))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..15};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-1))
				((nthreads=nthreads-1))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..15};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+1))
				((nthreads=nthreads-1))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..15};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-1))
				((nthreads=nthreads+1))		
			done
		fi

	elif [ $1 == "webproxy" ];then
		run=10
		meanfilesize=16	  # KB
		nthreads=100
		if [ $3 -eq 1 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+3))
				((nthreads=nthreads+20))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run $meanfilesize 0 $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
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
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+3))
				((nthreads=nthreads+20))		
			done
		elif [ $3 -eq 2 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 3 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize+3))
				((nthreads=nthreads-20))		
			done
		elif [ $3 -eq 4 ];then
			for i in {1..5};do
				/bin/bash ./parameter_handler.sh $1 $run 0 $filesize $nthreads 0 0
				perf stat python3 experiment.py $2 $1 2> perf_stat_results.txt
				python3 perf_stat_results.py
				((filesize=filesize-3))
				((nthreads=nthreads+20))		
			done
		fi

	else
		echo "<filebench personality options> : {fileserver, oltp, randomread, randomwrite, singlestreamread, singlestreamwrite, varmail, videoserver, webproxy, webserver}"
	fi

	

	echo "$(column -s, -t --table-columns 95%_conf_interval,std_dev,mean,throughput,filesize,filesize_mean,meanfilesize,nthreads,nshadows,ndbwriters,task-clock,context-switches,cpu-migrations,page-faults,cycles,instructions,branches,branch-misses /root/Desktop/experiment_stats.txt)" > /root/Desktop/experiment_stats.txt
	# plot here
	python3 plot_results.py /root/Desktop/experiment_stats.txt $2 $1
}


# init_parameters $2
runExperiments $2 $1 $3


