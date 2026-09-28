# SESSION\_MEMORY

统计Session级别的内存使用情况，包含执行作业在数据节点上openGauss线程和Stream线程分配的所有内存，单位为MB。

此视图依赖内存保护功能开启。

**表 1**  SESSION\_MEMORY字段

sessid text 线程启动时间+线程标识。
init_mem integer 当前正在执行作业进入执行器前已分配的内存。
used_mem integer 当前正在执行作业已分配的内存。
peak_mem integer 当前正在执行作业已分配的内存峰值。
