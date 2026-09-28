# PGXC\_NODE

PGXC\_NODE系统表存储集群节点信息。PGXC\_NODE系统表仅在分布式场景下有具体含义，openGauss只能查询表定义。

**表 1**  PGXC\_NODE字段

oid oid 行标识符（隐含字段，必须明确选择）。
node_name name 节点名称。
node_type "char" node_port integer 节点的端口号。
node_host name 节点的主机名称或者IP（如配置为虚拟IP，则为虚拟IP）。
node_port1 integer 复制节点的端口号。
node_host1 name 复制节点的主机名称或者IP（如配置为虚拟IP，则为虚拟IP）。
hostis_primary boolean 表明当前节点是否发生主备切换。
t（true）：表示发生。f（false）：表示不发生。
nodeis_primary boolean 在replication表下，是否优选当前节点作为优先执行的节点进行非查询操作。
t（true）：表示优选。f（false）：表示不优选。
nodeis_preferred boolean 在replication表下，是否优选当前节点作为首选的节点进行查询。
t（true）：表示优选。f（false）：表示不优选。
node_id integer 节点标志符。由node_name经过hash函数计算后得到。
sctp_port integer 主节点使用TCP代理通信库或SCTP通信库的数据通道侦听端口。
control_port integer 主节点使用TCP代理通信库或SCTP通信库的控制通道侦听端口。
sctp_port1 integer 备节点使用TCP代理通信库或SCTP通信库的数据通道侦听端口。
control_port1 integer 备节点使用TCP代理通信库或SCTP通信库的控制通道侦听端口。
nodeis_central boolean 表明当前节点是否为中心控制节点，只用于CN，对DN无效。
t（true）：表示是。f（false）：表示不是。
nodeis_active boolean 表明当前节点是否是正常状态，用于标记CN是否被剔除，对DN无效。
t（true）：表示是。f（false）：表示不是。
