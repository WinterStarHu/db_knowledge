# SESSION\_MEMORY\_DETAIL

统计线程的内存使用情况，以MemoryContext节点来统计。

**表 1**  SESSION\_MEMORY\_DETAIL字段

sessid text 线程启动时间+线程标识。
sesstype text 线程名称。
contextname text 内存上下文名称。
level smallint 内存上下文的重要级别。
parent text 父级内存上下文名称。
totalsize bigint 总申请内存大小（单位：字节）。
freesize bigint 空闲内存大小（单位：字节）。
usedsize bigint 使用内存大小（单位：字节）。
