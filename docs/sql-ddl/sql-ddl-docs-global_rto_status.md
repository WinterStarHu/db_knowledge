# global\_rto\_status

global\_rto\_status视图显示关于主机和备机的日志流控信息（本节点除外、备DN上不可使用）。

**表 1**  remote\_rto\_status参数说明

node_name text 节点的名称，包含主机和备机。
rto_info text 流控的信息，包含了备机当前的日志流控时间（单位：秒），备机通过GUC参数设置的预期流控时间（单位：秒），为了达到这个预期主机所需要的睡眠时间（单位：微秒）。
