# GS\_GSC\_MEMORY\_DETAIL

GS\_GSC\_MEMORY\_DETAIL视图描述当前节点当前进程的全局SysCache的内存占用情况，仅在开启GSC的模式下有数据。需要注意的是，这个查询由于是以数据库内存上下文分隔的，因此会缺少一部分内存的统计，缺失的内存统计对应的内存上下文名称为GlobalSysDBCache。

**表 1**  GS\_GSC\_MEMORY\_DETAIL字段

db_id text 数据库id。
totalsize numeric 共享内存总大小，单位Byte。
freesize numeric 共享内存剩余大小，单位Byte。
usedsize numeric 共享内存使用大小，单位Byte。
