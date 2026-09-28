# SUMMARY\_FILE\_REDO\_IOSTAT

openGauss内汇聚所有的Redo（WAL）相关的统计信息。

示例：

```sql
openGauss=# select * from DBE_PERF.SUMMARY_FILE_REDO_IOSTAT;
 phywrts | phyblkwrt | writetim | avgiotim | lstiotim | miniotim | maxiowtm
---------+-----------+----------+----------+----------+----------+----------
```

**表 1**  SUMMARY\_FILE\_REDO\_IOSTAT字段

phywrts numeric 向wal buffer中写的次数。
phyblkwrt numeric 向wal buffer中写的block的块数。
writetim numeric 向xlog文件中写操作的时间（单位：微秒）。
avgiotim bigint 平均写xlog的时间（writetim/phywrts）（单位：微秒）。
lstiotim bigint 最后一次写xlog的时间（单位：微秒）。
miniotim bigint 最小的写xlog时间（单位：微秒）。
maxiowtm bigint 最大的写xlog时间（单位：微秒）。
