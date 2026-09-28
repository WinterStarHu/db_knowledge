# SNAPSHOT.TABLES\_SNAP\_TIMESTAMP

TABLES\_SNAP\_TIMESTAMP表记录所有存储的WDR snapshot中数据库、表对象、以及数据采集的开始和结束时间。

**表 1**  TABLES\_SNAP\_TIMESTAMP表属性

snapshot_id bigint WDR快照序号。
db_name text WDR snapshot对应的database。
tpcc1000 tablename text WDR snapshot对应的table。
snap_xc_statio_all_indexes start_ts timestamp WDR快照的开始时间。
2019-12-28 17:11:27.425849+08 end_ts timestamp WDR快照的结束时间。
2019-12-28 17:11:27.707398+08

>[!TIP]须知
>用户应该禁止对Snapshot schema下的表进行增删改等操作，人为对这些表的修改或破坏可能会导致WDR各种异常情况甚至WDR不可用。
