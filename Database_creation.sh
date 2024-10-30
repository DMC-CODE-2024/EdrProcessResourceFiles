source ~/.bash_profile

source $commonConfigurationFilePath
dbDecryptPassword=$(java -jar  ${APP_HOME}/encryption_utility/PasswordDecryptor-0.1.jar spring.datasource.password)

mysql  -h$dbIp -P$dbPort -u$dbUsername -p${dbDecryptPassword} $edrappdbName <<EOFMYSQL

CREATE TABLE if not exists active_foreign_imei_with_different_imsi (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  tac varchar(8) DEFAULT '',
  msisdn varchar(20) DEFAULT '',
  failed_rule_id int DEFAULT '0',
  failed_rule_name varchar(50) DEFAULT '',
  imsi varchar(20) DEFAULT '',
  mobile_operator varchar(20) DEFAULT '',
  create_filename varchar(100) DEFAULT '',
  update_filename varchar(100) DEFAULT '',
  updated_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  protocol varchar(50) DEFAULT '',
  action varchar(50) DEFAULT '',
  period varchar(50) DEFAULT '',
  failed_rule_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  mobile_operator_id int DEFAULT '0',
  tax_paid int DEFAULT '0',
  feature_name varchar(50) DEFAULT '',
  record_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  actual_imei varchar(20) DEFAULT '',
  timestamp timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(20) DEFAULT '',
  raw_cdr_file_name varchar(100) DEFAULT '',
  imei_arrival_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  source varchar(20) DEFAULT '',
  update_raw_cdr_file_name varchar(100) DEFAULT '',
  update_imei_arrival_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  update_source varchar(20) DEFAULT '',
  server_origin varchar(255) DEFAULT '',
  actual_operator varchar(20) DEFAULT NULL,
  is_test_imei int DEFAULT '0',
  is_used int DEFAULT '0',
  PRIMARY KEY (id),
  KEY INX_create_dt (created_on),
  KEY INX_DUP_ACTUAL_IMEI (imei),
  KEY INX_DUP_DB_IMEI (imei),
  KEY INX_DUP_IMSI_EDR (imsi),
  KEY INX_DVCDUP_TAC (tac),
  KEY INX_IDX_DPLCT_IMS (imei,imsi)
) ;

CREATE TABLE if not exists active_imei_with_different_imsi (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  tac varchar(8) DEFAULT '',
  msisdn varchar(20) DEFAULT '',
  failed_rule_id int DEFAULT '0',
  failed_rule_name varchar(50) DEFAULT '',
  imsi varchar(20) DEFAULT '',
  mobile_operator varchar(20) DEFAULT '',
  create_filename varchar(100) DEFAULT '',
  update_filename varchar(100) DEFAULT '',
  updated_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  protocol varchar(50) DEFAULT '',
  action varchar(50) DEFAULT '',
  period varchar(50) DEFAULT '',
  failed_rule_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  mobile_operator_id int DEFAULT '0',
  tax_paid int DEFAULT '0',
  feature_name varchar(50) DEFAULT '',
  record_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  actual_imei varchar(20) DEFAULT '',
  timestamp timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(20) DEFAULT '',
  raw_cdr_file_name varchar(100) DEFAULT '',
  imei_arrival_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  source varchar(20) DEFAULT '',
  update_raw_cdr_file_name varchar(100) DEFAULT '',
  update_imei_arrival_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  update_source varchar(20) DEFAULT '',
  server_origin varchar(255) DEFAULT '',
  actual_operator varchar(20) DEFAULT '',
  is_test_imei int DEFAULT '0',
  is_used int DEFAULT '0',
  PRIMARY KEY (id),
  KEY DUPINX_createdt (created_on),
  KEY ACTUALIMEI_INDEXDUPDB (actual_imei),
  KEY INX_DUPLICATE_DB_IMEI (imei),
  KEY INXDUP_imsi (imsi),
  KEY DVCDUP_TAC_INDX (tac),
  KEY UNQ_IDX_DPLCT_IMS (imei,imsi)
);

CREATE TABLE if not exists active_unique_foreign_imei (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  foregin_rule varchar(255) DEFAULT '',
  tac varchar(50) DEFAULT '',
  msisdn varchar(20) DEFAULT '',
  failed_rule_id varchar(10) DEFAULT '',
  failed_rule_name varchar(255) DEFAULT '',
  imsi bigint DEFAULT '0',
  mobile_operator varchar(255) DEFAULT '',
  create_filename varchar(255) DEFAULT '',
  update_filename varchar(255) DEFAULT '',
  updated_on timestamp NULL DEFAULT NULL,
  protocol varchar(255) DEFAULT '',
  action varchar(255) DEFAULT '',
  period varchar(255) DEFAULT '',
  failed_rule_date varchar(255) DEFAULT '',
  mobile_operator_id int DEFAULT '0',
  tax_paid int DEFAULT '0',
  feature_name varchar(255) DEFAULT '',
  record_time timestamp NULL DEFAULT NULL,
  actual_imei varchar(20) DEFAULT '',
  timestamp timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(25) DEFAULT '',
  raw_cdr_file_name varchar(100) DEFAULT NULL,
  imei_arrival_time timestamp NULL DEFAULT NULL,
  source varchar(255) DEFAULT '',
  update_raw_cdr_file_name varchar(255) DEFAULT '',
  update_imei_arrival_time timestamp NULL DEFAULT NULL,
  update_source varchar(255) DEFAULT '',
  server_origin varchar(255) DEFAULT '',
  actual_operator varchar(20) DEFAULT NULL,
  is_test_imei int DEFAULT '0',
  is_used int DEFAULT '0',
  foreign_rule varchar(50) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY INX_UNQ_DB_IMEI (imei),
  KEY INX_createdt (created_on),
  KEY foreign_imei (imei),
  KEY INX_FORG_IMSI (imsi),
  KEY INX_FOR_TACI (tac),
  KEY INX_ACT_IMEI (actual_imei)
);

CREATE TABLE if not exists active_unique_imei (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  foregin_rule varchar(50) DEFAULT '',
  tac varchar(8) DEFAULT '',
  msisdn varchar(20) DEFAULT '',
  failed_rule_id int DEFAULT '0',
  failed_rule_name varchar(50) DEFAULT '',
  imsi varchar(20) DEFAULT '',
  mobile_operator varchar(20) DEFAULT '',
  create_filename varchar(100) DEFAULT '',
  update_filename varchar(100) DEFAULT '',
  updated_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  protocol varchar(50) DEFAULT '',
  action varchar(50) DEFAULT '',
  period varchar(50) DEFAULT '',
  failed_rule_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  mobile_operator_id int DEFAULT '0',
  tax_paid int DEFAULT '0',
  feature_name varchar(50) DEFAULT '',
  record_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  actual_imei varchar(50) DEFAULT '',
  timestamp timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(20) DEFAULT '',
  raw_cdr_file_name varchar(100) DEFAULT '',
  imei_arrival_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  source varchar(20) DEFAULT '',
  update_raw_cdr_file_name varchar(100) DEFAULT '',
  update_imei_arrival_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  update_source varchar(20) DEFAULT '',
  server_origin varchar(255) DEFAULT '',
  actual_operator varchar(20) DEFAULT '',
  is_test_imei int DEFAULT '0',
  is_used int DEFAULT '0',
  foreign_rule varchar(50) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY UNQ_DB_IMEI_UNI (imei),
  KEY INX_imei (imei),
  KEY INX_createdt (created_on),
  KEY DVCUSGTACI_NDX (tac),
  KEY ACTUALIMEI_INDEX (actual_imei),
  KEY InXun_imsi (imsi)
);

 CREATE TABLE if not exists cdr_file_pre_processing_detail (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  file_type varchar(10) DEFAULT '',
  file_name varchar(100) DEFAULT '',
  total_records bigint DEFAULT '0',
  total_blacklist_record bigint DEFAULT '0',
  total_error_records bigint DEFAULT '0',
  total_duplicate_records bigint DEFAULT '0',
  total_output_records bigint DEFAULT '0',
  start_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  end_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  time_taken int DEFAULT '0',
  tps int DEFAULT '0',
  operator_name varchar(20) DEFAULT '',
  source_name varchar(20) DEFAULT '',
  volume int DEFAULT '0',
  tag varchar(20) DEFAULT '',
  file_count int DEFAULT '0',
  head_count int DEFAULT '0',
  servername varchar(50) DEFAULT '',
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

 CREATE TABLE if not exists cdr_file_processed_detail (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  starttime timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  endtime timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  file_name varchar(100) DEFAULT '',
  operator varchar(20) DEFAULT '',
  source varchar(20) DEFAULT '',
  total_error_record_count int DEFAULT '0',
  total_insert_in_dup_db int DEFAULT '0',
  total_insert_in_null_db int DEFAULT '0',
  total_inserts_in_usage_db int DEFAULT '0',
  total_updates_in_usage_db int DEFAULT '0',
  total_updates_in_dup_db int DEFAULT '0',
  total_update_in_null_db int DEFAULT '0',
  total_records_count int DEFAULT '0',
  sql_process_start_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  sql_process_end_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  total_query_sql int DEFAULT '0',
  total_update_sql int DEFAULT '0',
  raw_cdr_file_name varchar(100) DEFAULT '',
  foreignmsisdn int DEFAULT '0',
  status varchar(50) DEFAULT '',
  server_origin varchar(50) DEFAULT '',
  total_insert_in_foreigndup_db int DEFAULT '0',
  total_inserts_in_foreignusage_db int DEFAULT '0',
  total_updates_in_foreignusage_db int DEFAULT '0',
  total_updates_in_foreigndup_db int DEFAULT '0',
  PRIMARY KEY (id)
);

 CREATE TABLE if not exists invalid_imei (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  device_launch_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  device_id_type varchar(255) DEFAULT '',
  device_status varchar(255) DEFAULT '',
  device_type varchar(255) DEFAULT '',
  file_name varchar(255) DEFAULT '',
  imei_esn_meid varchar(255) DEFAULT '',
  multiple_sim_status varchar(255) DEFAULT '',
  operator_id int DEFAULT '0',
  operator_name varchar(255) DEFAULT '',
  operator_type varchar(20) DEFAULT '',
  record_date varchar(50) DEFAULT '',
  rule_name varchar(255) DEFAULT '',
  sn_of_device varchar(255) DEFAULT '',
  imsi varchar(20) DEFAULT '',
  msisdn varchar(20) DEFAULT '',
  PRIMARY KEY (id)
);

CREATE TABLE if not exists test_imei_details (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(20) DEFAULT '',
  imsi varchar(20) DEFAULT '',
  msisdn varchar(20) DEFAULT '',
  timestamp timestamp NULL DEFAULT NULL,
  protocol varchar(15) DEFAULT '',
  source varchar(20) DEFAULT '',
  raw_cdr_file_name varchar(50) DEFAULT '',
  imei_arrival_time timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  operator varchar(20) DEFAULT '',
  file_name varchar(60) DEFAULT NULL,
  PRIMARY KEY (id)
);
 insert into app.sys_param ( tag , value , feature_name) values ('EDR_IMEI_LENGTH_CHECK','True','EDR');
insert into app.sys_param ( tag , value , feature_name) values ('EDR_IMEI_LENGTH_VALUE','14,15,16','EDR');
insert into app.sys_param ( tag , value , feature_name) values ('EDR_NULL_IMEI_CHECK','True','EDR');
insert into app.sys_param ( tag , value , feature_name) values ('EDR_ALPHANUMERIC_IMEI_CHECK','True','EDR');
insert into app.sys_param ( tag , value , feature_name) values ('EDR_NULL_IMEI_REPLACE_PATTERN','888888888888888','EDR');

insert into app.sys_param (tag,value) values ('CELLCARD_CC_EDR_FILE_PATTERN','CELLCARD_EIRID-17-8');
insert into app.sys_param (tag,value) values ('CELLCARD_CC_EDR2_FILE_PATTERN','CELLCARD_EIRID-17-8');
insert into app.sys_param (tag,value) values ('SMART_SM_EDR2_FILE_PATTERN','SMART_EIRID-14-8');
insert into app.sys_param (tag,value) values ('METFONE_MF_EDR2_FILE_PATTERN','METFONE_EIRID-16-8');
insert into app.sys_param (tag,value) values ('SEATEL_ST_EDR2_FILE_PATTERN','SEATEL_EIRID-15-8');
insert into app.sys_param (tag,value) values ('CELLCARD_CC_EDR1_FILE_PATTERN','CELLCARD_EIRID-17-8');
insert into app.sys_param (tag,value) values ('SMART_SM_EDR1_FILE_PATTERN','SMART_EIRID-14-8');
insert into app.sys_param (tag,value) values ('METFONE_MF_EDR1_FILE_PATTERN','METFONE_EIRID-16-8');
insert into app.sys_param (tag,value) values ('SEATEL_ST_EDR1_FILE_PATTERN ','SEATEL_EIRID-15-8');

insert ignore into app.sys_param (tag , value, feature_name) values ('TEST_IMEI_SERIES ','001,0044','EDR');
insert ignore into app.sys_param (tag , value, feature_name) values ('IS_USED_EXTENDED_DAYS','365','EDR');
insert ignore into app.sys_param (tag,value, feature_name) values ('enableForeignSimHandling','True','EDR');

EOFMYSQL
