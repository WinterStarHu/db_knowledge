# GS\_LSC\_MEMORY\_DETAIL

GS\_LSC\_MEMORY\_DETAIL视图统计所有的线程的本地SysCache内存使用情况，以MemoryContext节点来统计，仅在开启GSC的模式下有数据。

**表 1**  GS\_LSC\_MEMORY\_DETAIL字段

threadid text 线程启动时间+线程标识（字符串信息为timestamp.sessionid）。
tid bigint 线程标识。
thrdtype text 线程类型。可以是系统内存在的任何线程类型，如postgresql、wlmmonitor等。
contextname text 内存上下文名称。
level smallint 当前上下文在整体内存上下文中的层级。
parent text 父内存上下文名称。
totalsize bigint 当前内存上下文的内存总数，单位Byte。
freesize bigint 当前内存上下文中已释放的内存总数，单位Byte。
usedsize bigint 当前内存上下文中已使用的内存总数，单位Byte。
