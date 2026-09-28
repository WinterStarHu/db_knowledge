# PG\_COMM\_DELAY

PG\_COMM\_DELAY视图展示单个节点的通信库时延状态。

**表 1**  PG\_COMM\_DELAY字段

node_name text 节点名称。
remote_name text 连接对端节点名称。
remote_host text 连接对端IP地址。
stream_num integer 当前物理连接使用的stream逻辑连接数量。
min_delay integer 当前物理连接一分钟内探测到的最小时延，单位微秒。
average integer 当前物理连接一分钟内探测时延的平均值，单位微秒。
max_delay integer 当前物理连接一分钟内探测到的最大时延，单位微秒。
