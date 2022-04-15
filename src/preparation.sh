#!/bin/bash

declare -a WORKLOAD_FILES

chmod 755 ./run_multiple_experiments.sh
chmod 755 ./stats.sh
chmod 755 ./parameter_handler.sh

WORKLOAD_FILES=(/root/filebench-1.5-alpha3/workloads/singlestreamread.f
		/root/filebench-1.5-alpha3/workloads/singlestreamwrite.f
		/root/filebench-1.5-alpha3/workloads/randomread.f
		/root/filebench-1.5-alpha3/workloads/randomwrite.f
		/root/filebench-1.5-alpha3/workloads/webserver.f
		/root/filebench-1.5-alpha3/workloads/fileserver.f
		/root/filebench-1.5-alpha3/workloads/oltp.f
		/root/filebench-1.5-alpha3/workloads/webproxy.f
		/root/filebench-1.5-alpha3/workloads/videoserver.f)


makePreparations(){

	# clear stats file.
	> /root/Desktop/experiment_stats_temp.txt
	> /root/Desktop/experiment_stats.txt

	echo "500" >> "/proc/sys/vm/dirty_expire_centisecs"
	echo "100" >> "/proc/sys/vm/dirty_writeback_centisecs"


	if [ -z "$(ls -A /root/workloads)" ]; then 
   		mv ${WORKLOAD_FILES[@]} /root/workloads
	fi	
}


printExperimentScriptSyntax(){
	printf "\n"
	echo "----------------------- Experiment script's syntax -----------------------"
	printf "\npython3 experiment.py <metric> <filebench personality>\n"
	printf "\n<metric> = {usr_avg, sys_avg, iostat_avg, free, inact, active, tps, kB_read_rate, kB_write_rate, kB_read, kB_wrtn}\n"
	printf "\n<filebench personality> = {fileserver, oltp, randomread, randomwrite, singlestreamread, singlestreamwrite, varmail, videoserver, webproxy, webserver}\n"
	echo "--------------------------------------------------------------------------"
}


makePreparations
# printExperimentScriptSyntax






