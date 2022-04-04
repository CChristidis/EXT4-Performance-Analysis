#!/bin/bash 

declare -a WORKLOAD_FILES


# $1: workbench running time in seconds

WORKLOAD_FILES=(/root/filebench-1.5-alpha3/workloads/singlestreamread.f
		/root/filebench-1.5-alpha3/workloads/singlestreamwrite.f
		/root/filebench-1.5-alpha3/workloads/randomread.f
		/root/filebench-1.5-alpha3/workloads/randomwrite.f
		/root/filebench-1.5-alpha3/workloads/webserver.f
		/root/filebench-1.5-alpha3/workloads/fileserver.f
		/root/filebench-1.5-alpha3/workloads/oltp.f
		/root/filebench-1.5-alpha3/workloads/webproxy.f
		/root/filebench-1.5-alpha3/workloads/videoserver.f)

do_stuff(){
	dirty_expire_csecs=$(< /proc/sys/vm/dirty_expire_centisecs)
	
	if [ $dirty_expire_csecs > $1 ]; then
		echo "WARNING: some data may not have been written into secondary storage."
	fi
	

	if [ -z "$(ls -A /root/workloads)" ]; then 
   		mv ${WORKLOAD_FILES[@]} /root/workloads
	fi
		

	for file in /root/workloads/*.f
	do
		if tail -1 "$file" | grep "run "; then
			sed -i '$ d' "$file"
			echo "run $1" >> "$file"

		else
			echo "run $1" >> "$file"
		fi
	done
}

do_stuff $1

	



