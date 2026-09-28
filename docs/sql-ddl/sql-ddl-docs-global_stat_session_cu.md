# GLOBAL\_STAT\_SESSION\_CU

GLOBAL\_STAT\_SESSION\_CU用于查询openGauss各个节点，当前运行session的CU命中情况。session退出相应的统计数据会清零。openGauss重启后，统计数据也会清零。

**表 1**  GLOBAL\_STAT\_SESSION\_CU字段

mem_hit integer 内存命中次数。
hdd_sync_read integer 硬盘同步读次数。
hdd_asyn_read integer 硬盘异步读次数。
