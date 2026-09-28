# PG\_TOTAL\_MEMORY\_DETAIL

PG\_TOTAL\_MEMORY\_DETAIL视图显示某个数据库节点内存使用情况。

此视图依赖内存保护功能开启。

**表 1**  PG\_TOTAL\_MEMORY\_DETAIL字段

nodename text 节点名称。
memorytype text 内存的名称。
memorymbytes integer 内存使用的大小，单位为MB。
