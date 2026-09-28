# 通信矩阵

**表 1**  通信矩阵

源设备 源IP 源端口 目的设备 目的IP 目的端口 （侦听） 端口说明 侦听端口是否可更改 认证方式 加密方式 所属平面 端口引入版本 特殊场景 客户端 源设备所在机器的节点IP 1024～65535 Datanode所在机器的节点IP dataPortBase TCP 【作用】客户端的连接请求。
【说明】端口范围1024~65529，实际值等于guc参数port值 【安装后是否默认开启】是 方式一：user/password，基于sha256/sm3认证 支持SSL加密 用户面 openGauss 1.0.0 SQL 方式二：user/password，基于md5认证（默认不支持，为兼容开源第三方工具保留，不推荐使用） 支持SSL加密 方式三：基于cert证书认证 数据用SSL加密 内部工具 集群内部所在机器的节点IP 1024～65535 dataPortBase+1 TCP 【作用】内部工具连接请求 【说明】端口范围1025~65530，实际值等于guc参数port值加1 【安装后是否默认开启】是 方式一：user/password，基于sha256/sm3认证或md5认证（md5默认不支持，为兼容开源第三方工具保留，不推荐使用） 方式二：基于local trust认证（仅限初始化用户并且用户名与运行数据库的OS系统用户名称相同） 支持SSL加密 维护面 openGauss 1.0.0 DN主备 源设备所在机器的节点IP 1024～65535 haPort TCP 【作用】DN主备之间复制的连接端口，DN备连接DN主 【说明】端口范围1025~65530，实际值等于guc参数replconninfo连接串中的localport值，该值通常默认为port+1，即和（dataPortBase+1）共用一个端口 【安装后是否默认开启】是 IP地址认证或者IP+kerberos认证 支持SSL加密 维护面 openGauss 1.0.0 客户端 源设备所在机器的节点IP 1024-65535 TCP 【作用】连接DN抽取逻辑日志 【说明】端口范围1025~65530，实际值等于guc参数replconninfo连接串中的localport值，该值通常默认为port+1，即和（dataPortBase+1）共用一个端口 【安装后是否默认开启】是 user/password，基于sha256/sm3认证或md5认证（md5默认不支持，为兼容开源第三方工具保留，不推荐使用） 支持SSL加密 用户面 openGauss 1.0.0 DN备 源设备所在机器的节点IP 1024～65535 remote heartbeat port TCP 【作用】DN主备之间心跳连接请求 【说明】端口范围1029~65535，实际值等于guc参数replconninfo连接串中的remoteheartbeatport值，该值通常默认为port+5 【安装后是否默认开启】是 IP地址认证 数据不加密 维护面 openGauss 1.0.0 DN主备 源设备所在机器的节点IP 1024～65535 dcf_config Port TCP 【作用】处理主备DN间的连接和消息请求 【说明】端口范围1024~65535，源端口为随机端口，目的端口：以配置文件设置的端口值为准。
【安装后是否默认开启】启用DCF模式时开启 IP地址认证 + SSL证书认证 支持SSL加密 维护面 openGauss 3.0.0 DCF CM Agent/cm_ctl 源设备所在机器的节点IP 1024～65535 CM Server CM Server所在机器的节点IP cmServerPortBase TCP 【作用】处理CM Agent/cm_ctl连接请求 【说明】端口范围1024~65534，默认值5000 【安装后是否默认开启】是 IP地址认证或者IP+kerberos认证或者IP地址认证+SSL证书认证 支持SSL加密 维护面 openGauss 3.0.0 kerberos客户端（DN/Cmagent） 源设备所在机器的节点IP 1024～65535 Kerberos Kerberos服务所在机器的节点IP 21732 UDP 【作用】Kerberos KDC服务侦听端口, 提供集群内部节点间认证能力（启动kerberos认证后开启） 【说明】默认值21732 【安装后是否默认开启】由用户配置 用户名密码或者keytab文件认证 AES256算法加密 维护面 openGauss 1.0.0 CMServer 源设备所在机器的节点IP 1024～65535 CM Server cmserver所在机器的节点IP cmServerPortHa cmServerPortBase+1 TCP 【作用】CMS之间内部通信使用 【说明】端口范围1024~65535，源端口为随机端口，目的端口：如果xml文件不设置该端口，则该端口默认值为cmServerPortBase+1；如果设置该端口值，则以设置的端口值为准。
【安装后是否默认开启】是 IP地址认证或IP地址认证+SSL证书认证 支持SSL加密 维护面 openGauss 3.0.0 Prometheus server 源设备所在机器的节点IP 1024～65535 Prometheus exporter exporter所在机器的节点IP 通过exporter的命令行参数 --web.listen-port 指定 HTTPS/HTTP 【作用】供开源监控系统Prometheus采集和处理监控信息 【说明】openGauss-exporter默认为9187，reprocessing-exporter默认为8181 【安装后是否默认开启】否，由用户配置 Prometheus server支持SSL证书认证，Prometheus exporter不支持证书认证 支持SSL加密 用户面 openGauss 3.0.0 客户端 源设备所在机器的节点IP 1024～65535 Dolphin Server dolphin server所在机器的节点IP dolphin_server_port TCP 【作用】MySQL客户端的连接请求。
【说明】端口范围1024~65529，实际值等于guc参数dolphin_server_port值 【安装后是否默认开启】否, 需要enable_dolphin_proto,并使用B兼容类型的数据库 mysql_native_password插件方式认证 暂不支持SSL加密 用户面 openGauss 3.1.0 SQL

Scrlock

源设备所在机器的节点IP

1024～65535

Scrlock

Scrlock所在机器的节点IP

通过SS_SRCLOCK_SERVER_PORT参数指定

TCP

【作用】Scrlock服务端侦听端口号

【说明】默认为8000

【安装后是否默认开启】应用资源池化模式，且开启Scrlock后自动开启

SSL证书认证

支持SSL加密

用户面

openGauss 5.0.0

资源池化

共享模式下DN主备

源设备所在机器的节点IP

1024～65535

DN所在机器的节点IP

通过SS_INTERCONNECT_URL参数指定

TCP/RDMA

【作用】资源池化模式下主备节点间通信

【说明】为可配置端口，端口范围1024~65535，资源池化模式下主备节点通信时星型连接，节点间互为服务端%客户端，服务器端口参见SS_INTERCONNECT_URL参数指定，客户端端口为随机端口。通常该值为dataPortBase+20

【安装后是否默认开启】应用资源池化模式时开启

SSL证书认证

支持SSL加密

维护面

openGauss 5.0.0

资源池化

CMAgent

源设备所在机器的节点IP

1024～65535

CMAgent

CMAgent所在机器节点的IP

cmServerPortBase+2

TCP

【作用】cma检测节点间通信连通性

【说明】为可配置端口，端口范围1024~65535，cma监听dms的IP，每个cma即为服务端也为客户端，源端口为随机端口，目的端口：cmServerPortBase+2

【安装后是否默认开启】开启

SSL证书认证

支持SSL加密

维护面

openGauss 5.0.0

DSS Server

源设备所在机器的节点IP

1024～65535

DSS Server

DSS Server所在机器节点的IP

通过DSS_NODES_LIST参数指定

TCP/RDMA

DSS Server节点之间通信使用

【说明】为可配置端口，端口范围1024~65535，源端口为随机端口，目的端口：通过DSS_NODES_LIST参数指定。该值通常为dataPortBase+10

【安装后是否默认开启】应用资源池化模式时开启

SSL证书认证

支持SSL加密

维护面

openGauss 5.0.0

资源池化

客户端

源设备所在机器的节点IP

1024～65535

客户端

客户端所在机器节点的IP

通过guc配置comm_sctp_port参数

TCP

【作用】客户端节点之间libcomm通信使用

【说明】为可配置端口，端口范围0~65535，通过guc配置。该值通常为dataPortBase+30

【安装后是否默认开启】应用资源池化模式时开启

IP地址认证

不加密

用户面

openGauss 5.1.1

资源池化

客户端

源设备所在机器的节点IP

1024～65535

客户端

客户端所在机器节点的IP

通过guc配置comm_control_port参数

TCP

【作用】客户端节点之间libcomm通信使用

【说明】为可配置端口，端口范围0~65535，通过guc配置。该值通常为dataPortBase+40

【安装后是否默认开启】应用资源池化模式时开启

IP地址认证

不加密

用户面

openGauss 5.1.1

资源池化

UWAL服务运行服务器

openGauss给UWAL配置的IP地址

随机端口

UWAL服务运行服务器

openGauss给UWAL配置的IP地址

可配置范围为9000~65535，默认值9999

TCP

该端口用于监听TCP连接

是，运行时通过UWAL的接口传入

TLS

TLS_AES_128_GCM_SHA256

数据面

openGauss 5.1.1

UWAL服务运行服务器

openGauss给UWAL配置的IP地址

随机端口

UWAL服务运行服务器

openGauss给UWAL配置的IP地址

可配置范围为9000~65535，默认值9999

RDMA

如果用户选择了RDMA协议，则需要用到两个端口，一个是通过UWAL接口传入的端口号，用于TCP通信；另一个端口号WAL接口传入的端口号加1，用于RDMA通信

是，运行时通过UWAL的接口传入

TLS

EVP_aes_128_gcm

数据面

openGauss 5.1.1

分布式锁服务运行服务器

openGauss给分布式锁配置的IP地址

随机端口

RDMA网卡/UB网卡

openGauss给分布式锁配置的IP地址

可配置范围为1024~65535，默认值21616

TCP

DLock Primary Server默认面向客户端的服务端口号为21616；如果配置的端口号在系统新建连接的端口号范围内，可能会导致端口号被占用，进而导致server init/reinit失败；建议不要和新建连接的端口号范围冲突或者将该管理服务端口号配置到ip_local_reserved_ports中

是，可在启动Server时配置对应端口号

SSL认证，支持最低协议版本为TLS1_3_VERSION

加密套件为TLS_AES_256_GCM_SHA384

DLock管理面

openGauss 5.1.1

数据库和大数据等分布式业务场景

分布式锁服务运行服务器

openGauss给分布式锁配置的IP地址

随机端口

RDMA网卡/UB网卡

openGauss给分布式锁配置的IP地址

可配置范围为1024~65535

TCP

DLock使用组件URMA作为底层通信库，URMA会向系统申请一个端口监听，用于交互RDMA建链必要的信息

否，通过系统分配

URMA管理面

openGauss 5.1.1

RDMA场景，用于交换数据面建链的必要信息，不涉及用户数据，无需认证和加密。即使本链被劫持、伪造等等，均不影响数据面的安全

分布式锁服务运行服务器

RDMA网卡/UB网卡

RoCEv2

RDMA场景无端口概念

加密套件为TLS_AES_256_GCM_SHA384

数据面

openGauss 5.1.1

认证由DLock管理面负责，加解密密钥由DLock管里面交互得到

MCP Client

MCP Client程序所在IP地址

随机端口

MCP Server

MCP Server所在节点IP地址

1024~65535

HTTP/HTTPS

【作用】MCP客户端连接MCP服务端 【说明】端口范围1024~65535

IP地址认证或IP地址加证书认证

用户面

openGauss 7.0.0
