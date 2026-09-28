# GLOBAL\_STAT\_DB\_CU

GLOBAL\_STAT\_DB\_CU视图用于查询openGauss，每个数据库的CU命中情况。可以通过pg\_stat\_reset\(\)进行清零。

**表 1**  GLOBAL\_STAT\_DB\_CU字段

node_name1 text 数据库进程名称。
db_name text 数据库名。
mem_hit bigint 内存命中次数。
hdd_sync_read bigint 硬盘同步读次数。
hdd_asyn_read bigint 硬盘异步读次数。
