# SNAPSHOT.SNAPSHOT

SNAPSHOT表记录当前系统中存储的WDR快照数据的索引信息、开始时间和结束时间。只能在系统库中查询到结果，在用户库中无法查询。

**表 1**  SNAPSHOT表属性

snapshot_id bigint WDR快照序号。
start_ts timestamp WDR快照的开始时间。
2019-12-28 17:11:27.423742+08 end_ts timestamp WDR快照的结束时间。
2019-12-28 17:11:43.67726+08

>[!TIP]须知
>用户应该禁止对Snapshot schema下的表进行增删改等操作，人为对这些表的修改或破坏可能会导致WDR各种异常情况甚至WDR不可用。
