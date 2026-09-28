# gs\_hadr\_local\_rto\_and\_rpo\_stat

gs\_hadr\_local\_rto\_and\_rpo\_stat视图显示流式容灾的主数据库实例和备数据库实例日志流控信息（只可在主数据库实例的数据库主节点使用，数据库备节点以及备数据库实例均上不可获取到统计信息）。

**表 1**  gs\_hadr\_local\_rto\_and\_rpo\_stat参数说明

hadr_sender_node_name text 节点的名称，包含主数据库实例和备数据库实例首备。
hadr_receiver_node_name text 备数据库实例首备名称。
source_ip text 主数据库实例数据库主节点 IP地址。
source_port int 主数据库实例数据库主节点通信端口。
dest_ip text 备数据库实例首数据库备节点 IP地址。
dest_port int 备数据库实例首数据备节点通信端口。
current_rto int 流控的信息，当前主备数据库实例的日志rto时间（单位：秒）。
target_rto int 流控的信息，目标主备数据库实例间的rto时间（单位：秒）。
current_rpo int 流控的信息，当前主备数据库实例的日志rpo时间（单位：秒）。
target_rpo int 流控的信息，目标主备数据库实例间的rpo时间（单位：秒）。
rto_sleep_time int RTO流控信息，为了达到目标rto，预期主机walsender所需要的睡眠时间（单位：微秒）。
rpo_sleep_time int RPO流控信息，为了达到目标rpo，预期主机xlogInsert所需要的睡眠时间（单位：微秒）。
