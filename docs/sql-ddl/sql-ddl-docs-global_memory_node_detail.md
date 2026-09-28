# GLOBAL\_MEMORY\_NODE\_DETAIL

显示当前openGauss中所有正常节点下的内存使用情况。

此视图依赖内存保护功能开启。

**表 1**  GLOBAL\_MEMORY\_NODE\_DETAIL字段

nodename text 数据库进程名称。
memorytype text memorymbytes integer 内存使用的大小，单位为MB。
