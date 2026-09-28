# PG\_VARIABLE\_INFO

PG\_VARIABLE\_INFO视图用于查询openGauss中当前节点的xid、oid的状态。

**表 1**  PG\_VARIABLE\_INFO字段

node_name text 节点名称。
next_oid oid 该节点下一次生成的oid。
next_xid xid 该节点下一次生成的事务号。
oldest_xid xid 该节点最老的事务号。
xid_vac_limit xid 强制autovacuum的临界点。
oldest_xid_db oid 该节点datafrozenxid最小的数据库oid。
last_extend_csn_logpage xid 最后一次扩展csnlog的页面号。
start_extend_csn_logpage xid csnlog扩展的起始页面号。
next_commit_seqno xid 该节点下次生成的csn号。
latest_completed_xid xid 该节点提交或者回滚后节点上的最新事务号。
startup_max_xid xid 该节点关机前的最后一个事务号。
