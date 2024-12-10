#!/bin/bash
#set -x

tar -xzvf etl_edr_1.0.0.tar.gz >>etl_edr_1.0.0_untar_log.txt
mkdir -p ${APP_HOME}/etl_edr_module/

mv etl_edr_1.0.0/etl_edr_p1_p2/etl_edr_p1_p2_1.0.0.jar ${RELEASE_HOME}/binary/
mv etl_edr_1.0.0/etl_edr_p3/etl_edr_p3_1.0.0.jar ${RELEASE_HOME}/binary/
mv etl_edr_1.0.0/edr_msisdn_update/edr_msisdn_update_1.0.0.jar ${RELEASE_HOME}/binary/

mv etl_edr_1.0.0/*  ${APP_HOME}/etl_edr_module/

cd ${APP_HOME}/etl_edr_module/etl_edr_p1_p2/
ln -sf ${RELEASE_HOME}/binary/etl_edr_p1_p2_1.0.0.jar etl_edr_p1_p2.jar
ln -sf ${RELEASE_HOME}/global_config/log4j2.xml log4j2.xml
chmod +x *.sh

cd ${APP_HOME}/etl_edr_module/etl_edr_p3/
ln -sf ${RELEASE_HOME}/binary/etl_edr_p3_1.0.0.jar etl_edr_p3.jar
ln -sf ${RELEASE_HOME}/global_config/log4j2.xml log4j2.xml
chmod +x *.sh

cd ${APP_HOME}/etl_edr_module/edr_msisdn_update/
ln -sf ${RELEASE_HOME}/binary/edr_msisdn_update_1.0.0.jar edr_msisdn_update.jar
ln -sf ${RELEASE_HOME}/global_config/log4j2.xml log4j2.xml
chmod +x *.sh

cd ${APP_HOME}/etl_edr_module/
chmod +x *.sh

cd ${APP_HOME}/etl_edr_module/etl_edr_sql/
chmod +x *.sh


base="${DATA_HOME}/etl_edr_module/"
p1_path="etl_edr_p1_p2"

for i in output ; do
  for j in seatel metfone cellcard smart; do
    tmp=""
    if [ "$j" == "seatel" ]; then
      tmp="st_edr1 all_edr"
    elif [ "$j" == "metfone" ]; then
      tmp="mf_edr1 mf_edr2 all_edr"
    elif [ "$j" == "smart" ]; then
      tmp="sm_edr1 sm_edr2 all_edr"      
    elif [ "$j" == "cellcard" ]; then
      tmp="cc_edr1 cc_edr2 all_edr"
    fi
    for k in $tmp; do
      for l in error processed output; do
        mkdir -p "$base/$p1_path/$i/$j/$k/$l"
      done
    done
  done
done


for x in etl_edr_p3 etl_edr_sql; do
  for y in input processed; do
      for t in seatel metfone cellcard smart; do
      	  for z in {1..10}; do
      mkdir -p "$base/$x/$y/$t/$z"
    done
done 
  done
done


exit ;




