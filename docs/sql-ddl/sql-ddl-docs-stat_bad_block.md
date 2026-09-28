# STAT\_BAD\_BLOCK

获得当前节点表、索引等文件的读取失败信息。

**表 1**  STAT\_BAD\_BLOCK字段

nodename text 数据库进程名称。
databaseid integer database的oid。
tablespaceid integer tablespace的oid。
relfilenode integer relation的file node。
bucketid smallint 一致性hash bucket ID。
forknum integer fork编号。
error_count integer error的数量。
first_time timestamp with time zone 坏块第一次出现的时间。
last_time timestamp with time zone 坏块最后出现的时间。
