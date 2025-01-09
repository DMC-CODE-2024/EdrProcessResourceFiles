#!/bin/bash


#. /home/eirsapp/.bash_profile > /dev/null


module_name="etl_edr"
main_module="" #keep it empty "" if there is no main module 

#log_level="INFO" # INFO, DEBUG, ERROR

########### DO NOT CHANGE ANY CODE OR TEXT AFTER THIS LINE #########

script_status=`ps -ef | grep ./${module_name} | grep -v vi | grep -v grep | grep -v etl_edr_p4 | wc -l`
if [ "$script_status" -gt 0 ]
then
  echo "${module_name} related processes are currently running... process skip to start !!!"
  echo `ps -ef | grep ./${module_name} | grep -v vi | grep -v grep`
  exit

fi

build_path="${APP_HOME}/${module_name}_module"
log_file="${LOG_HOME}/${module_name}_module/${module_name}_$(date "+%Y%m%d").log"

mkdir ${LOG_HOME}/${module_name}_module -p

cd ${build_path}

source application.properties > /dev/null

op_names+=("smart" "metfone" "cellcard" "seatel")
node1_name=${node1}
node2_name=${node2}


### Check VIP status of current node ###

echo "***************************************************************" >> ${log_file}
echo "** $(date): starting ${module_name} process **" >> ${log_file}
echo "***************************************************************" >> ${log_file}

echo "$(date): ETL node1 is ${node1_name}" >> ${log_file}
echo "$(date): ETL node2 is ${node2_name}" >> ${log_file}
echo "$(date): virtual IP is ${vip_ip}" >> ${log_file}

nc -z $node1_name $ssh_port > /dev/null
t1=$?
echo "$(date): ETL node1 IP response time: "$t1 >> ${log_file}

nc -z $node2_name $ssh_port > /dev/null
t2=$?
echo "$(date): ETL node2 IP response time: "$t2 >> ${log_file}

vip_status=`/usr/sbin/ip add show | grep "$vip_ip/"` ## to check if current server is running as VIP
vip_status_vip=""

echo "$(date): VIP active operator list: ${op_vip_active}" >> ${log_file}

## check vip_status_flag for all operators

for ((i=0; i<${#op_names[@]}; i++)); # loop operator who is listed in vip_active config 
do
  vip_status_flag[i]="N"

  for j in ${op_vip_active//,/ }
  do
    if [ "${op_names[i]}" == "${j}" ]
    then
      vip_status_flag[i]="Y"
    fi
  
  done
done


## start process by checking operator vip status ##
for (( i=0; i<${#op_names[@]}; i++ ));
do

  script_status=`ps -ef | grep ${module_name} | grep ${op_names[i]} | grep -v grep`

  if [ "$script_status" != "" ]
  then
    echo "$(date): ${module_name} process for ${op_names[i]} already running" >> ${log_file}

  else

    ## primary & secondary noes are up
    
    p1_p2_process=${module_name}_p1_p2

    cd ${build_path}/${p1_p2_process}

    if [ "$t1" -eq 0 ] && [ "$t2" -eq 0 ]
    then
      echo "$(date): both ETL node1 (${node1_name}) and node2 (${node2_name}) are up and running" >> ${log_file} 

      if [ "${vip_status_flag[i]}" = Y ] && [ "$vip_status" != "" ]   ## operator enabled (Y) + current node is VIP running
      then
        echo "$(date): operator ${op_names[i]} will run in VIP node and current node is VIP active..." >> ${log_file}
        script_status=`ps -ef | grep ${module_name} | grep ${op_names[i]} | grep -v grep`

        if [ "$script_status" != "" ]
        then
          echo "$(date): ${module_name} process for ${op_names[i]} already running" >> ${log_file}

        else
	  echo "$(date): calling P1_P2 process to start for ${op_names[i]}..." >> ${log_file}
          ./${p1_p2_process}.sh ${op_names[i]} 1>> ${log_file} 2>> ${log_file} &   ## start process for all (Y) operators in parallel 

        fi

      elif [ "${vip_status_flag[i]}" = N ] && [ "$vip_status" == "" ]  ## operator not enabled (N) + current node is no VIP running
      then
        echo "$(date): operator ${op_name[i]} will run in non-VIP node and current node is not VIP active..."
        script_status=`ps -ef | grep ${module_name} | grep ${op_names[i]} | grep -v grep`

        if [ "$script_status" != "" ]
        then
          echo "$(date): ${module_name} process for ${op_names[i]} already running" >> ${log_file}
        else
 	  echo "$(date): calling P1_P2 process to start for ${op_names[i]}..." >> ${log_file}
          ./${p1_p2_process}.sh ${op_names[i]} 1>> ${log_file} 2>>${log_file} &  ## start process for all disabed operator in parallel

        fi
      else  ## operator not enabled (N) + current node is VIP running   or  operator enabled (Y) + current node is not VIP running
        echo "$(date): ${module_name} process is skipped for ${op_names[i]}..." >> ${log_file}
      fi

    ## ## primary or secondary nodes is down

    else
      echo "$(date): another node is not reachable, thus all operators process will run from this node only..." >> ${log_file}
      echo "$(date): calling P1_P2 process to start for ${op_names[i]}..." >> ${log_file}
      ./${p1_p2_process}.sh ${op_names[i]} 1>> ${log_file} 2>>${log_file} &   ## start process p1 for all data source in parallel 

    fi
  fi
done
