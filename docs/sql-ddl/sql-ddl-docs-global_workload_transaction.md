# GLOBAL\_WORKLOAD\_TRANSACTION

显示各节点上的workload的负载信息。

**表 1**  GLOBAL\_WORKLOAD\_TRANSACTION字段

node_name name 数据库进程名称。
workload name 负载的名称。
commit_counter bigint 用户事务commit数量。
rollback_counter bigint 用户事务rollback数量。
resp_min bigint 用户事务最小响应时间（单位：微秒）。
resp_max bigint 用户事务最大响应时间（单位：微秒）。
resp_avg bigint 用户事务平均响应时间（单位：微秒）。
resp_total bigint 用户事务总响应时间（单位：微秒）。
bg_commit_counter bigint 后台事务commit数量。
bg_rollback_counter bigint 后台事务rollback数量。
bg_resp_min bigint 后台事务最小响应时间（单位：微秒）。
bg_resp_max bigint 后台事务最大响应时间（单位：微秒）。
bg_resp_avg bigint 后台事务平均响应时间（单位：微秒）。
bg_resp_total bigint 后台事务总响应时间（单位：微秒）。
