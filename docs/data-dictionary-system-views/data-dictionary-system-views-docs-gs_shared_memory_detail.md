# GS_SHARED\_MEMORY\_DETAIL

查询当前节点所有已产生的共享内存上下文的使用信息。

**表 1**  GS_SHARED\_MEMORY\_DETAIL字段

contextname text 内存上下文的名称。
level smallint 内存上下文的级别。
parent text 上级内存上下文。
totalsize bigint 共享内存总大小（单位：字节）。
freesize bigint 共享内存剩余大小（单位：字节）。
usedsize bigint 共享内存使用大小（单位：字节）。
