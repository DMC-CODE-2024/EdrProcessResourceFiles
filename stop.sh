#!/bin/bash

. ~/.bash_profile

operator=$1

script_name="./stop.sh"
count=`ps -ef | grep $operator | grep -v grep | grep -v "$script_name" | wc -l`

 if [ $count -eq 0 ]
        then
                echo "No Process Runing"
        else
        kill  $(ps aux | grep "$operator" | grep -v grep | grep -v "$script_name" | awk '{print $2}')
        sleep 5
	ps -ef | grep "$operator" | grep -v grep |  grep -v "$script_name" | awk '{print $2}' | xargs kill 
	echo "Process $operator killed"
 fi
exit;
