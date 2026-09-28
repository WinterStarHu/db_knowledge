# GS\_THREAD\_MEMORY\_CONTEXT

GS\_THREAD\_MEMORY\_CONTEXT视图统计所有的线程的内存使用情况，以MemoryContext节点来统计。该视图在关闭线程池（enable\_thread\_pool = off）时等价于GS\_SESSION\_MEMORY\_DETAIL视图。

其中内存上下文“TempSmallContextGroup”，记录当前线程中所有内存上下文字段“totalsize”小于8192字节的信息汇总，并且内存上下文统计计数记录到“usedsize”字段中。所以在视图中，“TempSmallContextGroup”内存上下文中的“totalsize”和“freesize”是该线程中所有内存上下文“totalsize”小于8192字节的汇总总和，usedsize字段表示统计的内存上下文个数。

**表 1**  GS\_THREAD\_MEMORY\_CONTEXT字段

threadid text 线程启动时间+线程标识（字符串信息为timestamp.sessionid）。
tid bigint 线程标识。
thrdtype text 线程类型。
contextname text 内存上下文名称。
level smallint 当前上下文在整体内存上下文中的层级。
parent text 父内存上下文名称。
totalsize bigint 当前内存上下文的内存总数，单位Byte。
freesize bigint 当前内存上下文中已释放的内存总数，单位Byte。
usedsize bigint 当前内存上下文中已使用的内存总数，单位Byte；“TempSmallContextGroup”内存上下文中该字段含义为统计计数。
