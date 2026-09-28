# GLOBAL\_FILE\_REDO\_IOSTAT

得到openGauss内各节点的Redo（WAL）相关统计信息。

示例：

```sql
openGauss=# select * from DBE_PERF.GLOBAL_FILE_REDO_IOSTAT;
 node_name | phywrts | phyblkwrt | writetim | avgiotim | lstiotim | miniotim | maxiowtm
-----------+---------+-----------+----------+----------+----------+----------+----------
```

**表 1**  GLOBALXC\_FILE\_REDO\_IOSTAT字段

node_name name 数据库进程名称。
phywrts bigint 向wal buffer中写的次数。
phyblkwrt bigint 向wal buffer中写的block的块数。
writetim bigint 向xlog文件中写操作的时间（单位：微秒）。
avgiotim bigint 平均写xlog的时间（writetim/phywrts）（单位：微秒）。
lstiotim bigint 最后一次写xlog的时间（单位：微秒）。
miniotim bigint 最小的写xlog时间（单位：微秒）。
maxiowtm bigint 最大的写xlog时间（单位：微秒）。
