#!/bin/bash

source $commonConfigurationFilePath > /dev/null

main_module="etl_edr"
module_name="etl_module"
process_name="etl_edr_sql"

dbDecryptPassword=$(java -jar ${APP_HOME}/encryption_utility/PasswordDecryptor-0.1.jar spring.datasource.password)
echo "Password is " ${dbDecryptPassword}

current_date=$(date +"%Y_%m_%d")
fpath=$1

logfile2=$2/sql_${current_date}.log

report_log=${LOG_HOME}/$module_name/$main_module/${process_name}/sql_report/report_"$current_date".log

cd $1

ls -tr *sql > test.txt
echo test.txt >> $logfile2

totalfile=`cat test.txt|wc -l`
echo $totalfile >> $logfile2
i=1
totalUpdateCount=0
while [ $i -le $totalfile ]
do

file=`cat test.txt|head -$i|tail -1`
echo $file >> $logfile2
if [ "$file" == '' ] 
then
	echo "File Not Found"
else
repdate=$(date +"%Y_%m_%d_%F_%T")
logfile=${2}${file}_${repdate}
wordcnt=`cat ${file}|wc -l`
now1="$(date +%F_%T)"
printf "start date and time %s\n" "$now1" >> $logfile
echo name of file to be processsed  ${file}
start_process(){
mysql -h$dbIp -P${dbPort} $appdbName -u$dbUsername  -p${dbDecryptPassword} <<EOFMYSQL
source ${fpath}${file}        
EOFMYSQL

sql_return_code=$?
if [ $sql_return_code != 0 ]
then
echo "The upgrade script failed. Please refer to the loga for more information"
echo "Error code $sql_return_code"

exit 0;
fi
}

start_process

now2="$(date +%F_%T)"
totalUpdateCount=`cat ${logfile}|grep '1 row updated'|wc -l`
printf "End date and time %s\n" "$(date +%F+%T)" >> $logfile
realFileName=$(echo $file | sed -e 's/.sql//g')
query="update $edrappdbName.cdr_file_processed_detail  set status = 'Done' , sql_process_start_time= '$now1' , sql_process_end_time = '$now2' , total_query_sql = '$wordcnt'  , total_update_sql = '$totalUpdateCount' where FILE_NAME = '$realFileName' ;"

updateSqlCount(){
mysql -h$dbIp -P${dbPort}  $appdbName -u$dbUsername  -p${dbDecryptPassword} <<EOFMYSQL
$query       
EOFMYSQL
}
	
updateSqlCount	
echo "$query" >>  $logfile

mv ${file} $3
fi

echo "$file Count:$wordcnt, StartTime:$now1, EndTime: $(date +%F+%T)" >> "$report_log"
i=`expr $i + 1`
 
done

rm $1/test.txt
