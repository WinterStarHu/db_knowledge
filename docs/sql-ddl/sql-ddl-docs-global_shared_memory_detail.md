# GLOBAL\_SHARED\_MEMORY\_DETAIL

查询openGauss中所有正常节点下的共享内存上下文的使用信息。

**表 1**  GLOBAL\_SHARED\_MEMORY\_DETAIL字段

node_name name 数据库进程名称。
contextname text 内存上下文的名称。
level smallint 内存上下文的级别。
parent text 上级内存上下文。
totalsize bigint 共享内存总大小（单位：字节）。
freesize bigint 共享内存剩余大小（单位：字节）。
usedsize bigint 共享内存使用大小（单位：字节）。
