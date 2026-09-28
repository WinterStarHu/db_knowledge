# SUMMARY\_STAT\_BAD\_BLOCK

获得openGauss内汇聚的表、索引等文件的读取失败信息。

**表 1**  SUMMARY\_STAT\_BAD\_BLOCK字段

databaseid integer database的oid。
tablespaceid integer tablespace的oid。
relfilenode integer relation的file node。
forknum bigint fork编号。
error_count bigint error的数量。
first_time timestamp with time zone 坏块第一次出现的时间。
last_time timestamp with time zone 坏块最后出现的时间。
