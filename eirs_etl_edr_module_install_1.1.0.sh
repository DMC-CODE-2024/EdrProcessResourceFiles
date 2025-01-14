 

cd /u02/eirsdata/release/etl_edr_module/1.1.0
tar -xzvf etl_edr_1.1.0.tar.gz >>etl_edr_1.1.0_untar_log.txt

mv etl_edr_1.1.0/etl_edr_p1_p2_1.1.0.jar ${RELEASE_HOME}/binary/
mv etl_edr_1.1.0/etl_edr_p3_1.1.0.jar ${RELEASE_HOME}/binary/

mv etl_edr_1.1.0/application.properties etl_edr_1.1.0/etl_edr_p1_p2.sh  ${APP_HOME}/etl_edr_module/etl_edr_p1_p2/
mv etl_edr_1.1.0/etl_edr_sql.sh ${APP_HOME}/etl_edr_module/etl_edr_sql/

cd ${APP_HOME}/etl_edr_module/etl_edr_p1_p2/
rm etl_edr_p1_p2.jar
ln -sf ${RELEASE_HOME}/binary/etl_edr_p1_p2_1.1.0.jar etl_edr_p1_p2.jar

cd ${APP_HOME}/etl_edr_module/etl_edr_p3/
rm etl_edr_p3.jar
ln -sf ${RELEASE_HOME}/binary/etl_edr_p3_1.1.0.jar etl_edr_p3.jar
