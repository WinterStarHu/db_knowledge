# GS\_REDO\_STAT

GS\_REDO\_STAT视图用于统计会话线程日志回放情况。

示例：

  ```sql
  openGauss=# select * from gs_redo_stat;
   phywrts | phyblkwrt | writetim | avgiotim | lstiotim | miniotim | maxiowtm
  ---------+-----------+----------+----------+----------+----------+----------
  ```

**表 1**  GS\_REDO\_STAT字段

phywrts bigint 日志回放过程中写数据的次数。
phyblkwrt bigint 日志回放过程中写数据的块数。
writetim bigint 日志回放过程中写数据所耗的总时间。
avgiotim bigint 日志回放过程中写一次数据的平均消耗时间。
lstiotim bigint 日志回放过程中最后一次写数据消耗的时间。
miniotim bigint 日志回放过程中单次写数据消耗的最短时间。
maxiowtm bigint 日志回放过程中单次写数据消耗的最长时间。
