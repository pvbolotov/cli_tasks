#!/bin/bash

config_file="./screenshot_maker.config"
username_string=$LOGNAME"_INTERVAL="
dump_interval=-1
default_dump_interval=-1

while read line
do
	if [[ $line =~ "STORAGE=" ]]
	then
		storage_dir=$(echo $line | sed "s|^STORAGE=||" | sed "s|\"||g")
	elif [[ $line =~ "DUMP_INTERVAL=" ]]
	then
		default_dump_interval=$(echo $line | sed "s|^DUMP_INTERVAL=||")
	elif [[ $line =~ "$username_string" ]]
	then
		dump_interval=$(echo $line | sed "s|$username_string||")
	fi
done < $config_file

if ((dump_interval == -1))
then
	if ((default_dump_interval != -1))
	then
		dump_interval=$default_dump_interval
	else
		echo "Default dump interval is not specified." > log.txt
		exit 1
	fi
fi

while true
do
	xwd -root | convert - "$storage_dir/screenshot_$LOGNAME_$(date +"%Y-%m-%d_%H-%M-%S").png"
	sleep "$dump_interval"s
done
