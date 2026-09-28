# GLOBAL\_FILE\_IOSTAT

得到所有节点上的数据文件IO统计信息。

**表 1**  GLOBAL\_FILE\_IOSTAT字段

node_name name 数据库进程名称。
filenum oid 文件标识。
dbid oid 数据库标识。
spcid oid 表空间标识。
phyrds bigint 读物理文件的数目。
phywrts bigint 写物理文件的数目。
phyblkrd bigint 读物理文件块的数目。
phyblkwrt bigint 写物理文件块的数目。
readtim bigint 读文件的总时长（单位：微秒）。
writetim bigint 写文件的总时长（单位：微秒）。
avgiotim bigint 读写文件的平均时长（单位：微秒）。
lstiotim bigint 最后一次读文件时长（单位：微秒）。
miniotim bigint 读写文件的最小时长（单位：微秒）。
maxiowtm bigint 读写文件的最大时长（单位：微秒）。
