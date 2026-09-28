# 创建XML配置文件

安装openGauss前需要创建cluster\_config.xml文件。cluster\_config.xml文件包含部署openGauss的服务器信息、安装路径、IP地址以及端口号等。用于告知openGauss如何部署。用户需根据不同场景配置对应的XML文件。

下面以一主一备的方案为例，说明如何创建XML配置文件。

## 配置数据库名称及各项目录

在script/gspylib/etc/conf/cluster\_config\_template.xml获取XML文件模板。以下配置内容为示例，可自行替换。每行信息均有注释进行说明。

```xml

```

>[!TIP]须知
>
>- “/opt/huawei/install/om”存放互信等工具，为了避免权限问题，不要把实例数据目录放在此目录下。
>- 安装目录和数据目录需为空或者不存在，否则可能导致安装失败。
>- 在对数据库节点的实例进行具体配置时，需确保配置的目录之间不相互耦合。即各个配置目录不关联，删除其中任意一个目录，不会级联删除其它目录。如gaussdbAppPath为"/opt/huawei/install/app"，gaussdbLogPath为"/opt/huawei/install/app/omm"。当gaussdbAppPath目录被删除时，会级联删除gaussdbLogPath目录，从而引起其它问题。
>- 若需要安装脚本自动创建安装用户时，各配置的目录需保证不与系统创建的默认用户目录耦合关联。
>- 配置openGauss路径和实例路径时，路径中不能包含"|",";","&","$","","\`","\\\\","'","\\"","\{","\}","\(","\)","\[","\]","\~","\*","?"特殊字符。
>- 配置数据库节点名称时，请通过hostname命令获取数据库节点的主机名称，替换示例中的node1\_hostname,node2\_hostname。
>- 配置dcf\_config时，角色的配置有leader，follower，passive，logger，其中可投票的角色有leader，follower，logger，配置角色组网时，可投票的角色不能少于3个，因此dcf模式下至少需要三个节点。
>- 资源池化中请谨慎配置所有包含磁盘信息的参数，安装时工具会低格所有参数中配置的磁盘，所有参数中的磁盘不能重复。
>- 资源池化中的ip和dn的数据ip保持一致，dss的端口是db端口+10，dms的端口是db端口+20。
>- om支持ipv6地址安装管理，所有节点的ip类型需一致（ipv4或者ipv6）。

**表 1**  参数说明

实例类型 整体信息 clusterName openGauss名称。
nodeNames openGauss中主机名称。
backIp1s 主机在后端存储网络中的IP地址（内网IP）。所有openGauss主机使用后端存储网络通讯。
gaussdbAppPath openGauss程序安装目录。此目录应满足如下要求： 磁盘空间&gt;1GB。与数据库所需其它路径相互独立，没有包含关系。
gaussdbLogPath openGauss运行日志和操作日志存储目录。此目录应满足如下要求： 磁盘空间建议根据主机上的数据库节点数规划。数据库节点预留1GB空间的基础上，再适当预留冗余空间。与openGauss所需其它路径相互独立，没有包含关系。
此路径可选。不指定的情况下，openGauss安装时会默认指定“$GAUSSLOG/安装用户名”作为日志目录。
tmpMppdbPath 数据库临时文件存放目录。
若不配置tmpMppdbPath，默认存放在/opt/huawei/wisequery/安装用户名_mppdb目录下，其中"opt/huawei/wisequery"是默认指定的数据库系统工具目录，数据库安装时unix_socket_directory默认配置使用了该路径。
gaussdbToolPath openGauss系统工具目录，主要用于存放互信工具等。此目录应满足如下要求： 磁盘空间&gt;100MB。固定目录，与数据库所需其它目录相互独立，没有包含关系。
此目录可选。不指定的情况下，openGauss安装时会默认指定“/opt/huawei/wisequery”作为数据库系统工具目录。
corePath openGauss core文件的指定目录。
enable_dcf 是否开启DCF模式。资源池化不支持dcf模式。
dcf_config 开启DCF模式时配置，DCF启动节点信息。
enable_dss 资源池化模式开关，取值范围on/off，默认为off， dss_home dss实例目录，enable_dss为on时必选。
ss_dss_vg_name dss共享卷名，enable_dss为on时必选。
dss_vg_info dss挂载卷组信息，包含一个共享卷组，其余为日志卷组，日志卷组的数量和dn的数量保持一致，集中式每个节点最多有一个dn。卷组形如“data:/dev/sdb”，卷组和卷组之间以“，”隔开，enable_dss为on时必选。日志卷组磁盘大小需要大于dn参数max_size_for_xlog_prune的值， votingDiskPath cm的投票卷，enable_dss为on时必选。
shareDiskDir cm的共享卷，enable_dss为on时必选。
dss_ssl_enable dss开启ssl认证开关，取值范围on/off，默认为on。
ss_interconnect_type mes通信协议类型，默认值TCP，取值范围TCP/RDMA，默认为TCP。
ss_rdma_work_config rdma用户态poll占用起止cpu，ss_interconnect_type为RDMA时有效，形如"10 15"，中间以空格分隔。
enableHugeBin 配置为on时启用二进制代码段大页，代码段按照2MB对齐。需要root用户进行部署，且针对操作系统内核在5.10以上、PAGE_SIZE=4k场景下才会生效，不满足这些场景会部署为默认4K代码段方式。
floatIp1、floatIp2、floatIp3 虚拟ip。

## 配置Host基本信息

>[!NOTE]说明
>
>每台Host服务器都必须有如下信息，如下示例以node1为例。
>
内容为示例，可自行替换。每行信息均有注释进行说明。

**Host配置以下信息。**

```txt

```

**表 1**  参数说明

实例类型 整体信息 name 主机名称。
azName 指定azName（Available Zone Name），字符串（不能含有特殊字符），例如AZ1、AZ2、AZ3。
azPriority 指定azPriority的优先级，azName值不同，azPriority的值也必须不同 backIp1 主机在后端存储网络中的IP地址（内网IP）。所有openGauss主机使用后端存储网络通讯。
sshIp1 设置SSH可信通道IP地址（外网IP）。若无外网，则可以不设置该选项或者同backIp1设置相同IP。
sshPort ssh端口，除了默认22端口，自定义的端口范围在（1024-65535）。

>[!NOTE]说明
>配置文件中所有IP参数（包含backIp、sshIp、listenIp等）均只支持配置一个IP。如果配置第二个IP参数，则不会读取第二个参数的配置值。
>示例：xml配置文件中同时配置backIp1和backIp2参数：
>在解析配置文件时仅读取backIp1参数的配置值，不会读取backIp2参数的配置值。
>
>```txt
>
>
>```
>
## 配置数据库主节点信息

内容为示例，可自行替换。每行信息均有注释进行说明。

**数据库主节点配置以下信息。**

```txt

```

**表 1**  参数说明

实例类型 DBnode dataNum 当前主机上需要部署的数据库节点个数。
dataPortBase 数据库节点的基础端口号，默认值40000(约束：如果是部署资源池化，预安装结束后，先利用`cat /proc/sys/net/ipv4/ip_local_port_range`命令查看端口范围，数据库的端口不要配置在这个范围内，否则会导致池化内组件随机端口冲突)。
dataListenIp1 侦听的IP地址。未设置时，使用对应主机上的backIp1生成。
第一个IP是主节点所在主机IP，第二个IP是备节点所在主机IP。
dataNode1 用于指定当前主机上的数据库节点的数据存储目录。此目录为数据库的数据存储目录。应规划到数据盘上。
dataNodeXlogPath1 可选参数，用于指定当前数据库中xlog存储路径。此目录为数据库xlog日志存储目录，只支持绝对路径。如不指定，则默认存放在数据目录的pg_xlog目录下。
dataNode1_syncNum 可选参数，与syncNode_hostname参数二选一。如需配置，仅在主机节点下配置。用于指定当前数据库中同步模式的节点数目。取值范围为0~数据库备机节点数。
syncNode_hostname 可选参数，与dataNode1_syncNum参数二选一。如需配置，需要在所有的节点下同时配置。用于指定当前数据库中同步模式的备机节点方式、数量及顺序。syncNode_hostname中的hostname根据主机名自行替换。参数中指定同步备主机名存在且正确，同步备数量不能超过备选同步备主机个数。参数中FIRST与ANY不可以同时存在，ANY支持组合配置，FIRST不支持组合配置，具体见：一主四备配置文件（支持自定义利用FIRST、ANY设置同步备机）。
dataListenIp1 可选参数，各节点监听ip，若不配置，则默认使用backIp1s的值 floatIpMap1 可选参数，配置VIP时需要配置，表示floatIp与dataListenIp的对应关系，其顺序与dataListenIp1的顺序要相互对应

## 配置CM_SERVER（主、非主）信息

CM支持两节点部署模式

- CM集群最小节点数限制由3节点减少为2节点，带来显著的成本优势
- 通过引入第三方网关IP，有效解决CM集群两节点部署模式下自仲裁问题，同时支持动态配置CM集群故障切换策略和数据库集群脑裂故障恢复策略，从而能够尽可能确保集群数据的完整性和一致性。

**非CMS主节点配置以下信息。**

```txt

```

**表 1**  参数说明

实例类型 cmServerPortBase 主CM Server端口号，默认值5000。
cmServerPortStandby 备CM Server端口号，默认值5500。
cmServerListenIp1 CM Server用于侦听CM Agent连接请求或DBA管理请求的IP地址。
cmServerHaIp1 主、备CM Server间通信的IP地址。
Value中左边为主CM Server的主机IP地址，右边为备CM Server的主机IP地址。未设置时，默认根据主、备CM Server所在主机的backIp1生成。
cmDir CM数据文件路径。保存CM Server和CM Agent用到的数据文件，参数文件等。
各集群主机上均需配置该参数。

**表 2**  目录说明

/opt/huawei/data 集群实例的数据存储总目录。此目录为数据库的数据存储目录。应规划到数据盘上。
此目录应满足如下要求： 磁盘空间请根据实际业务数据量大小规划。各实例间的数据路径相互独立，彼此间没有包含关系。例如本指南中各实例的数据目录规划如表3所示。

**表 3**  数据库实例数据目录

实例名称 实例数据目录 /opt/huawei/data/cm 主DN /opt/huawei/data/masterX 其中，X为从1开始的连续正整数，用于标识当前主机上的第X个DN。
备DN /opt/huawei/data/slaveX 其中，X为从1开始的连续正整数，用X标识当前主机上的第X个备DN。

## 示例

### 单节点配置文件

```xml

```

### 一主一备配置文件

```xml

```

### 一主一备一级联配置文件

```xml

```

### 一主二备配置文件

```xml

```

### 一主三备配置文件

```xml

```

### 一主四备配置文件

```xml

```

### 一主四备配置文件（支持自定义利用FIRST、ANY设置同步备机）

```xml

```
