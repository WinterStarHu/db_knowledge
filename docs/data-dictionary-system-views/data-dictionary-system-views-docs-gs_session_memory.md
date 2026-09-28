# GS\_SESSION\_MEMORY

GS\_SESSION\_MEMORY视图统计Session级别的内存使用情况，包含执行作业在数据节点上gaussdb线程和Stream线程分配的所有内存。当GUC参数enable\_memory\_limit的值为off时，本视图不可用。

**表 1**  GS\_SESSION\_MEMORY字段

sessid text 线程启动时间+线程标识。
init_mem integer 当前正在执行作业进入执行器前已分配的内存，单位MB。
used_mem integer 当前正在执行作业已分配的内存，单位MB。
peak_mem integer 当前正在执行作业已分配的内存峰值，单位MB。
