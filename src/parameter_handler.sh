#!/bin/bash 

# $1: filepath which parameters we wish to modify
# $2: workbench running time (in seconds)
# $3: meanfilesize (in KB)
# $4: filesize_with_mean (in KB) or filesize (in MB)
# $5: $nthreads 
# $6: $nshadows (number of processes executing reading operations).   ONLY for oltp.f. Default: 200
# $7: $ndbwriters (number of processes executing writing operations). ONLY for otlp.f. Default: 10

file="/root/workloads/$1.f"


changeParameters(){
	
	dirty_expire_csecs=$(< /proc/sys/vm/dirty_expire_centisecs)

	mean_file_size=$(( $3 * 1024 ))  	# in KB
	filesize_with_mean=$(($4 * 1024))	# in KB
	filesize=$(($4 * 1024 * 1024))		# in MB
	nthreads=$(($5))
	nshadows=$(($6))
	ndbwriters=$(($7))
	
	if [ $((dirty_expire_csecs/100)) -gt $2 ]; then
		echo "WARNING: some data may not have been written into secondary storage.\n"
		echo "Please increase the running time of filebench personality."
	fi
	
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
		echo "run $2" >> "$file"

	else
		echo "run $2" >> "$file"
	fi

	
}


changeParameters $1 $2 $3 $4 $5 $6 $7

	



