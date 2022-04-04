#!/bin/bash 

declare -a WORKLOAD_FILES


# $1: workbench running time in seconds
# $2: meanfilesize in KB
# $3: filesize_with_mean in KB or filesize in MB
# $4: $nthreads 
# $5: $nshadows (number of processes executing reading operations) for oltp.f. Default: 200
# $6: $ndbwriters (number of processes executing writing operations) for otlp.f. Default: 10

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
	echo "500" >> "/proc/sys/vm/dirty_expire_centisecs"
	echo "100" >> "/proc/sys/vm/dirty_writeback_centisecs"
	dirty_expire_csecs=$(< /proc/sys/vm/dirty_expire_centisecs)
	mean_file_size=$(( $2 * 1024 ))  	# in KB
	filesize_with_mean=$(($3 * 1024))	# in KB
	filesize=$(($3 * 1024 * 1024))		# in MB
	nthreads=$(($4))
	nshadows=$(($5))
	ndbwriters=$(($6))
	
	if [ $((dirty_expire_csecs/100)) > $1 ]; then
		echo "WARNING: some data may not have been written into secondary storage."
	fi
	

	if [ -z "$(ls -A /root/workloads)" ]; then 
   		mv ${WORKLOAD_FILES[@]} /root/workloads
	fi
		

	for file in /root/workloads/*.f
	do
		sed -i 's/meanfilesize=.*/meanfilesize='$mean_file_size'/' "$file"
		sed -i 's/nthreads=.*/nthreads='$nthreads'/' "$file"
		sed -i 's/nshadows=.*/nshadows='$nshadows'/' "$file"
		sed -i 's/ndbwriters=.*/ndbwriters='$ndbwriters'/' "$file"

		if grep "parameters=mean:" "$file" ; then
			sed -i 's/parameters=mean:[0-9][0-9]*/parameters=mean:'$filesize_with_mean'/' "$file"
		else
			sed -i 's/\<filesize\>=.*/\<filesize\>='$filesize'/' "$file"
			sed -i 's/<filesize>/filesize/' "$file"
		fi

		if tail -1 "$file" | grep "run "; then
			sed -i '$ d' "$file"
			echo "run $1" >> "$file"

		else
			echo "run $1" >> "$file"
		fi
	done
	
	rm $1
}

do_stuff $1 $2 $3 $4 $5 $6

	



