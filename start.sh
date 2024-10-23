#!/bin/bash
#set -x

. /home/eirsapp/.bash_profile >> /dev/null

VAR=""
script_name="start.sh"
process_file="application.config"
sys_ip_file="sys_ip.conf"
home_path="/u01/eirsapp/etl_module/etl_edr/"
system_port="22024"


check_script_status=`ps -ef | grep $script_name |grep -v vi | grep -v grep | wc -l`
if [ "$check_script_status" -gt 5 ]
then
	exit
fi
primary=($(cat $sys_ip_file | grep P))
echo "Primary ip is ${primary:2:${#primary}}"
primary_ip=${primary:2:${#primary}}

secondary=($(cat $sys_ip_file | grep S))
echo "Secondary ip is ${secondary:2:${#secondary}}"
secondary_ip=${secondary:2:${#secondary}}

virtual=($(cat $sys_ip_file | grep V))
echo "Virtual ip is ${virtual:2:${#virtual}}"
virtual_ip=${virtual:2:${#virtual}}

nc -z $primary_ip $system_port > /dev/null
t1=$?
echo "Primary IP Status: "$t1
nc -z $secondary_ip $system_port > /dev/null
t2=$?
echo "Secondary IP Status: "$t2
vip_status=`/usr/sbin/ip add show | grep "$virtual_ip/"`

process_names=($(awk -F ',' '{printf "%s ", $1}' $process_file))
vip_status_flag=($(awk -F ',' '{printf "%s ", $7}' $process_file))
run_command=($(awk -F ',' '{printf "%s ", $9}' $process_file))
installation_path=($(awk -F ',' '{printf "%s ", $10}' $process_file))

if [ "$t1" -eq 0 ] && [ "$t2" -eq 0 ]
then
	echo "t1 and t2 are 0"
	for (( i=0; i<${#process_names[@]}; i++ ));
        do
		if [ "${vip_status_flag[i]}" = Y ] && [ "$vip_status" != "$VAR" ]
		then
			echo "going to start ${process_names[i]}"
			cd ${installation_path[i]}
			script_status=`ps -ef | grep "${run_command[i]}" | grep -v grep`
			if [ "$script_status" != "$VAR" ]
			then
				echo "process ${process_names[i]} already running"
				continue
			else
				echo "starting ${process_names[i]}"
			         ./run.sh ${process_names[i]} &
			fi
			cd $home_path
		elif [ "${vip_status_flag[i]}" = N ] && [ "$vip_status" == "$VAR" ]
		then
			echo "Flag is N in processConf and Vip is Not Here"
			echo "going to start ${process_names[i]}"
			cd ${installation_path[i]}
			script_status=`ps -ef | grep "${run_command[i]}" | grep -v grep`
			if [ "$script_status" != "$VAR" ]
			then
				echo "process ${process_names[i]} already running"
				continue
			else
				echo "starting ${process_names[i]}"
			        ./run.sh ${process_names[i]} &
			fi
			cd $home_path
		else
			echo "skipped ${process_names[i]}"
		fi
	done
else
	myarr=($(awk -F ',' '{print $1}' $process_file))
	for (( i=0; i<${#myarr[@]}; i++ ));
	do
		status=`ps -ef | grep ${myarr[i]} | grep -v grep`
		if [ "$status" != "$VAR" ]
		then
			echo "${myarr[i]} already running"
			echo $status
		else
			echo "going to start ${myarr[i]}"
			cd ${installation_path[i]}
			script_status=`ps -ef | grep ${myarr[i]} | grep -v grep`
			if [ "$script_status" != "$VAR" ]
			then
				echo "process ${myarr[i]} already running"
				continue
			else
				echo "starting ${myarr[i]}"
				./run.sh  ${myarr[i]} &
			fi
			cd $home_path
		fi
	done
fi
