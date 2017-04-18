mv kevin/Automatic\ OBD\ data kevin/obd
mv Alessio/Automatic\ OBD\ data Alessio/obd
mv charity/Automatic\ OBD\ data charity/obd
mv jon/Automatic\ OBD\ data jon/obd


hdfs dfs -copyFromLocal kevin/obd/* /user/hive/warehouse/hdap.db/obd_kevin/

hdfs dfs -copyFromLocal Alessio/obd/* /user/hive/warehouse/hdap.db/obd_alessio/

hdfs dfs -copyFromLocal charity/obd/* /user/hive/warehouse/hdap.db/obd_charity/

hdfs dfs -copyFromLocal jon/obd/* /user/hive/warehouse/hdap.db/obd_jon/


