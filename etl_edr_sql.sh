#!/bin/bash 

#set -x

module_name="etl_edr_sql"
main_module="etl_edr" #keep it empty "" if there is no main module 
#log_level="INFO" # INFO, DEBUG, ERROR

########### DO NOT CHANGE ANY CODE OR TEXT AFTER THIS LINE #########

source $commonConfigurationFile  2> /dev/null

op_name=$1
counter=$2

#alertUrl=${eirs.alert.url}

cd ${APP_HOME}/${main_module}_module/${module_name}
#source $commonConfigurationFile   2>/dev/null
source application.properties 

dbDecryptPassword=$(java -jar ${pass_dypt} dbEncyptPassword)


function generateAlertUsingUrl() 
{
  alertId="alert006"
  alertMessage="Not able to execute sql process for file $1 "
  alertProcess="$module_name"

  curlOutput=$(curl --header "Content-Type: application/json"   --request POST   --data '{"alertId":"'$alertId'",
    "alertMessage":"'"$alertMessage"'", "userId": "0", "alertProcess": "'"$alertProcess"'", "serverName": "'"$serverName"'",  "featureName": "${main_module}"}' "$alertUrl") 

  echo $curlOutput
}


function get_value() 
{
  key=$1
  grep "^$key=" "$commonConfigurationFile" | cut -d'=' -f2
}

echo "$(date) ${module_name} [${op_name}]-[${counter}]: ==> starting sql process..."   

alertUrl=$(get_value "eirs.alert.url");
sql_input_path=${INPUTPATH}/${op_name}/${counter}  ## {INPUTPATH} is defined in app config file

mkdir ${sql_input_path} -p

f_count=`ls -tr ${sql_input_path} | wc -l` >> /dev/null

if [ ${f_count} == 0 ]
then
  echo "$(date) ${module_name} [${op_name}]-[${counter}]: no P3 sql output file to start the sql process..."

else
  cd ${sql_input_path}
  file_list=flist.txt

  ls -tr *.sql > $file_list

  totalfile=`cat $file_list | wc -l`

  i=1

  while [ $i -le $totalfile ]
  do
    file=`cat $file_list | head -$i | tail -1`

    if [ "$file" == '' ] 
    then
      echo "$(date) ${module_name} [${op_name}]-[${counter}]: ${file} not found..."

    else
      repdate=$(date +"%Y_%m_%d_%F_%T")
      wordcnt=`cat ${file} | wc -l`
      now1="$(date +%F_%T)"
      realFileName=$(echo $file | sed -e 's/.sql//g')	

      ## update status to stats table ##

      query="update ${STATSCHEMA}.cdr_file_processed_detail  set modified_on='$now1', status = 'SQL_START' , sql_process_start_time= '$now1' , total_update_sql = '$wordcnt' where FILE_NAME = '$realFileName' ;"

      mysql -h$dbIp -P${dbPort}  ${STATSCHEMA} -u${dbUsername}  -p${dbDecryptPassword} <<EOFMYSQL

      ${query}       

EOFMYSQL

      #### Start execute sql statement line by line from file #####

      echo "$(date) ${module_name} [${op_name}]-[${counter}]: ${realFileName}: start executing the sql script..."
      mysql -h$dbIp -P${dbPort} $STATSCHEMA -u$dbUsername  -p${dbDecryptPassword} <<EOFMYSQL

      source ${sql_input_path}/${file}

EOFMYSQL

      sql_return_code=$?

      if [ $sql_return_code != 0 ]
      then
        echo "$(date) ${module_name} [${op_name}]-[${counter}]: ${realFileName}: ERROR CODE ${sql_return_code} : the update sql script failed to execute. Please refer to alert logs for more information !!! "

        generateAlertUsingUrl ${file}

        rm ${sql_input_path}/$file_list
        exit 0

      else 
        echo "$(date) ${module_name} [${op_name}]-[${counter}]: ${realFileName}: all script are executed successfully... "

      fi
    
      #### Update processing state in logs table ####

      now2="$(date +%F_%T)"

      query="update ${STATSCHEMA}.cdr_file_processed_detail  set modified_on= '$now2' , status = 'SQL_DONE' , sql_process_start_time= '$now1' , sql_process_end_time = '$now2' , total_query_sql = '$wordcnt' , total_update_sql = '$wordcnt' where FILE_NAME = '$realFileName' ;"
		
      mysql -h$dbIp -P${dbPort}  ${STATSCHEMA} -u${dbUsername}  -p${dbDecryptPassword} <<EOFMYSQL

      ${query}       

EOFMYSQL

      echo "$(date) ${module_name} [${op_name}]-[${counter}]: ${realFileName}: successfully updated status in cdr_file_processed_detail table... start_time='$now1' , end_time='$now2' , total_sql_script='$wordcnt' "
    
      sql_processed_path=${PROCESSEDPATH}/${op_name}/${counter}  ## {PROCESSEDPATH} is defined in app config file

      mkdir ${sql_processed_path} -p

      mv ${file} ${sql_processed_path}

      echo "$(date) ${module_name} [${op_name}]-[${counter}]: ${realFileName}: moved file to ${sql_processed_path}..."

    fi

    i=`expr $i + 1`

  done

  rm ${sql_input_path}/$file_list

fi

echo "$(date) ${module_name} [${op_name}]-[${counter}]: sql process for ${op_name} [${counter}] is completed..."

