# PG\_GET\_SENDERS\_CATCHUP\_TIME

PG\_GET\_SENDERS\_CATCHUP\_TIME视图显示数据库节点上当前活跃的主备发送线程的追赶信息。

**表 1**  PG\_GET\_SENDERS\_CATCHUP\_TIME字段

pid bigint 当前sender的线程ID。
lwpid integer 当前sender的lwpid。
local_role text 本地的角色。
peer_role text 对端的角色。
state text 当前sender的复制状态。
type text 当前sender的类型。
catchup_start timestamp with time zone catchup启动的时间。
catchup_end timestamp with time zone catchup结束的时间。
