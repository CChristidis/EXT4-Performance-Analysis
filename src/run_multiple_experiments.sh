#!/bin/bash

path="/root/workloads/$1.f"


init_parameters(){
	/bin/bash ./preparation.sh	

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

init_parameters $1



