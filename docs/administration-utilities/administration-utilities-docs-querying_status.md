# 查看状态

## 背景信息

openGauss支持查看整个openGauss的状态，通过查询结果确认openGauss或者单个主机的运行状态是否正常。

## 前提条件

openGauss已经启动。

## 操作步骤

1. 以操作系统用户omm登录数据库主节点。

2. 使用如下命令查询openGauss状态：

    ```
    gs_om -t status --detail
    ```

openGauss状态显示结果的参数说明请参见[表1](#zh-cn_topic_0237088790_table9610118112610)。

若要查询某主机上的实例状态，请在命令中增加“-h”项。示例如下：

    ```
    gs_om -t status -h plat2
    ```

其中，plat2为待查询主机的名称。

## 参数说明

**表 1**  节点角色说明

字段含义 字段值 cluster_state openGauss状态。显示整个openGauss是否运行正常。
Normal：表示openGauss可用，且数据有冗余备份。所有进程都在运行，主备关系正常。Unavailable：表示openGauss不可用。Degraded：表示openGauss可用，但存在故障的数据库节点、数据库主节点实例。
node 主机名称 表示该实例所在的主机名称。多AZ时会显示AZ编号。
node_ip 主机IP 表示该实例所在的主机IP。
instance 实例ID 表示该实例的ID。
state 实例角色 Normal：表示单主机实例。Primary：表示实例为主实例。Standby：表示实例为备实例。Cascade Standby：表示实例为级联备实例。Pending：表示该实例在仲裁阶段。Unknown：表示实例状态未知。Down：表示实例处于宕机状态。Abnormal：表示节点处于异常状态。Manually stopped：表示节点已经被手动停止。

每个角色也存在不同的状态，例如启动、连接等，其各个状态说明如下：

**表 2**  节点状态说明

字段含义 Normal 表示节点启动正常 Need repair 当前节点需要修复 Starting 节点正在启动中 Wait promoting 节点正等待升级中，例如备机向主机发送升级请求后，正在等待主机回应时的状态 Promoting 备节点正在升级为主节点的状态 Demoting 节点正在降级中，如主机正在降为备机中 Building 备机启动失败，需要重建 Catchup 备节点正在追赶主节点 Coredump 节点程序崩溃 Unknown 节点状态未知

当节点出现Need repair状态时，可能需要对该节点进行重建使其恢复正常。通常情况下，节点重建原因说明如下：

**表 3** 节点重建原因说明

字段含义 Normal 表示节点启动正常 WAL segment removed 主机日志/WAL日志不存在，或者备机日志比主机日志新 Disconnect 备机不能连接主机 Version not matched 主备二进制版本不一致 Mode not matched 主备角色不匹配，例如两个备机互联 System id not matched 主备数据库系统id不一致，主备双机要求System ID必须一致 Timeline not matched 日志时间线不一致 Unknown 其他原因

## 示例

查看openGauss详细状态信息，含实例状态信息。

```
gs_om -t status --detail
[   Cluster State   ]

cluster_state   : Normal
redistributing  : No
current_az      : AZ_ALL

[  Datanode State   ]
node                           node_ip           port                           instance                                   state
----------------------------------------------------------------------------------------------------------------
1  pekpopgsci00235  10.244.62.204    5432      6001 /opt/gaussdb/cluster/data/dn1   P Primary Normal
2  pekpopgsci00238  10.244.61.81      5432      6002 /opt/gaussdb/cluster/data/dn1   S Standby Normal

```
