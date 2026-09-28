# PG\_STAT\_REPLICATION

PG\_STAT\_REPLICATION视图用于描述日志同步状态信息，例如发起端发送日志位置，接收端接收日志位置等。

**表 1**  PG\_STAT\_REPLICATION字段

pid bigint 线程的PID。
usesysid oid 用户系统ID。
usename name 用户名。
application_name text 程序名称。
client_addr inet 客户端地址。
client_hostname text 客户端名。
client_port integer 客户端端口。
backend_start timestamp with time zone 程序启动时间。
state text 日志复制的状态： 追赶状态。一致的流状态。
sender_sent_location text 发送端发送日志位置。
receiver_write_location text 接收端write日志位置。
receiver_flush_location text 接收端flush日志位置。
receiver_replay_location text 接收端replay日志位置。
sync_priority integer 同步复制的优先级（0表示异步）。
sync_state text 同步状态： 异步复制。同步复制。潜在同步者。quorum：在同步与异步之间切换，保证备机中有大于一定数量的同步备机，同步备机数量一般为(n+1)/2-1，n为总副本个数。是否为同步备机取决于是否先接到了日志。详情可参考synchronous_standby_names参数描述。
