# gs\_om

## 背景信息

openGauss提供了gs\_om工具帮助对openGauss进行维护，包括启动openGauss、停止openGauss、查询openGauss状态、查询静态配置、生成静态配置文件、查询openGauss状态详细信息、生成动态配置文件、SSL证书替换、显示帮助信息和显示版本号信息等功能。

## 前提条件

需以操作系统用户omm执行gs\_om命令。

## 语法

- 启动openGauss

    ```
    gs_om -t start [-h HOSTNAME] [-D dataDir] [--time-out=SECS] [--security-mode=MODE] [--cluster-number=None] [-l LOGFILE]
    ```

- 停止openGauss

    ```
    gs_om -t stop [-h HOSTNAME] [-D dataDir]  [--time-out=SECS] [-m MODE] [-l LOGFILE]
    ```

- 重启openGauss

    ```
    gs_om -t restart [-h HOSTNAME] [-D dataDir] [--time-out=SECS] [--security-mode=MODE] [-l LOGFILE] [-m MODE]
    ```

- 查询openGauss状态

    ```
    gs_om -t status [-h HOSTNAME] [-o OUTPUT] [--detail] [--all] [-l LOGFILE]
    ```

- 生成静态配置文件

  ```
  gs_om -t generateconf -X XMLFILE [--distribute] [-l LOGFILE]
  gs_om -t generateconf --old-values=old --new-values=new [--distribute] [-l LOGFILE]
  ```

- 生成动态配置文件，在不带CM工具的集群中，备机failover或switchover成主机后，需要执行此操作

    ```
    gs_om -t refreshconf
    ```

- 查看静态配置

    ```
    gs_om -t view [-o OUTPUT]
    ```

- 查询openGauss状态详细信息

    ```
    gs_om -t query [-o OUTPUT]
    ```

- SSL证书替换

    ```
    gs_om -t cert --cert-file=CERTFILE [-l LOGFILE]
    gs_om -t cert --rollback
    ```

- 开启、关闭数据库内kerberos认证

    ```
    gs_om -t kerberos -m [install|uninstall] -U USER [-l LOGFILE] [--krb-client|--krb-server]
    ```

- 根据当前集群状态生成xml配置文件，生成的xml文件在当前用户家目录下，文件名是xml_output_时间戳.xml。

注：不支持级联备，不支持cmvip功能，最多支持一主八备。

    ```
    gs_om -t generate_xml [--add-hostname=hostname1,hostname2] [--add-hostip=hostip1,hostip2]
    ```

- 查询历史升级记录

    ```
    gs_om -t query_upgrade_records
    ```

- 显示帮助信息

    ```
    gs_om -? | --help
    ```

- 显示版本号信息

    ```
    gs_om -V | --version
    ```

## 参数说明

gs\_om参数可以分为如下几类：

- 通用参数：
  - -t

gs\_om命令的类型。

取值范围：start、stop、status、generateconf、cert、view、query、refreshconf、kerberos。

  - -l

指定日志文件及存放路径。

默认值：$GAUSSLOG/om/gs\_om-YYYY-MM-DD\_hhmmss.log（virtualip的默认值：/tmp/gs\_virtualip/gs\_om-YYYY-MM-DD\_hhmmss.log）

  - -?, --help

显示帮助信息。

  - -V, --version

显示版本号信息。

- 启动openGauss参数：
  - -h

指定需要启动的服务器名称。一次只能启动一个服务器。

取值范围：服务器名称。

不指定服务器名称时，表示启动openGauss。

  - -D

指定数据库节点路径。

取值范围：数据库节点路径。

不指定数据库节点路径，表示使用静态文件中的数据库节点路径。

[!NOTE]说明 针对部署了CM工具的集群，如果在对单个实例进行启停时候指定了-D参数，只会启动或者停止数据库进程，不会影响CM相关进程。

假设当前实例的数据库和CM进程都停止，在启动该实例时候如果指定了-D参数，那么只会尝试拉起数据库进程，此时由于CM进程不存在会导致数据库进程也拉起失败。可以去掉-D参数，启动整个实例。

  - --time-out=SECS

指定超时时间，如果超时，om脚本自动退出。单位：s。

取值范围：正整数，建议值300。

默认值：300。

  - --security-mode

指定是否以安全模式启动数据库。

取值范围：

  - on以安全模式启动。
  - off不以安全模式启动，默认不开启安全模式。

  - --cluster-number

指定启动时内核运行版本号。

取值范围： 内核版本号。

- 停止openGauss参数：
  - -h

指定需要停止实例所在的服务器名称。一次只能停止一个服务器。

取值范围：实例所在的服务器名称。

不指定服务器名称时，表示停止openGauss。

  - -m, --mode=MODE

停止模式设置。

取值范围：支持两种停止模式。

  - fast方式：保证有主备关系的实例数据是一致的。
  - immediate方式：不保证有主备关系的实例数据是一致的。

默认值：fast方式。

  - --time-out=SECS

指定超时时间，如果超时，om脚本自动退出。单位：s。

取值范围：正整数，建议值300。

默认值：300。

- 查询状态参数：

openGauss状态显示结果的参数说明请参见[表1](#table1171617665)。

  - -h

指定需要待查询的服务器名称。

取值范围：服务器名称。

不指定服务器时，表示查询openGauss。

  - --az

指定需要查询的AZ名称，比如--az=AZ1。

取值范围：AZ名称，不指定AZ名称时，表示查询所有AZ。

  - -o

输出到指定的output文件中。

如果不指定，直接显示在屏幕上。

  - --detail

显示详细信息。如果不指定，只提示该服务器是否正常。
本参数通过在每个数据库节点执行gs_ctl query命令进行查询并汇总结果，来获取openGauss的详细信息。

  - --all
显示openGauss所有节点信息。
本参数通过在每个数据库节点执行gsql查询系统表并汇总结果，来获取openGauss所有节点的信息。为保证显示信息的正确性，在使用本参数前请确认gsql可以查询。

- 生成配置文件参数：
  - -X

选择openGauss配置文件路径。

取值范围：clusterconfig.xml的路径。

  - --old-values=old

需要修改的静态文件中的旧值。

取值范围：port、ip、hostname，可以输入多个值，用逗号隔开。

  - --new-values=new

需要修改的静态文件中的新值。

取值范围：port、ip、hostname，可以输入多个值，用逗号隔开，与old-values一一对应。

  - --distribute

将静态配置文件发布到openGauss实例的安装目录。

- 开启、关闭数据库内kerberos认证：
  - -U

指定数据库部署用户。

取值范围：数据库部署用户。

  - -m

指定所要进行的操作。

取值范围：

install：开启数据库内kerberos认证。

uninstall：关闭数据库内kerberos认证。

  - --krb-server安装kerberos服务端认证。
  - --krb-client安装kerberos客户端认证。

注：需要先安装--krb-server，卸载时同步卸载不需要该参数。

- SSL证书替换：
  - --cert-file

指定本地SSL证书zip压缩包所在路径。

  - --rollback

证书回退到上一次成功备份的状态。

  - -L

制定该参数时，仅对当前节点进行。

- 根据当前集群状态生成xml配置文件参数。
  - --add-hostname

指定主机名，多个主机名用逗号隔开。

  - --add-hostip

指定主机ip，多个主机ip用逗号隔开，主机名和主机ip一一对应。

注：指定该参数时，会获取当前集群的信息和要添加的该主机信息；不指定时，会获取当前集群的信息；指定了add-hostname必须指定add-hostip。

**表 1**  状态说明

字段含义 字段值 cluster_state openGauss状态。显示openGauss是否运行正常。
Normal：表示openGauss可用，且数据有冗余备份。所有进程都在运行，主备关系正常。Unavailable：表示openGauss不可用。Degraded：表示openGauss可用，但数据没有冗余备份。
redistributing 数据重分布状态。
Yes：表示openGauss处于数据重分布状态。No：表示openGauss未处于数据重分步状态。
balanced 平衡状态。显示是否有openGauss实例发生过主备切换而导致主机负载不均衡。
Yes：表示openGauss处于负载均衡状态。No：表示openGauss未处于负载均衡状态。
node 主机名称。
表示该实例所在的主机名称。多AZ时会显示AZ编号。
node_ip 主机IP。
表示该实例所在的主机IP。
instance 实例ID。
表示该实例的ID。
state 实例状态。
P: 节点的初始角色是Primary，数据库安装后就不再变动，从系统静态文件读取。S: 节点的初始角色是Standby，数据库安装后就不再变动，从系统静态文件读取。C: 节点的初始角色是Cascade Standby，数据库安装后就不再变动，从系统静态文件读取。Primary：表示实例为主实例。Standby：表示实例为备实例。Cascade Standby：表示实例为级联备实例。Pending：表示该实例在仲裁阶段。Unknown：表示实例状态未知。Down：表示实例处于宕机状态。

**表 2**  特性ID说明

特性名称 特性ID openGauss产品 多值列 基础版 JSON 不支持License控制 XML 不支持 数据存储格式ORC 基础版 单机支持一主多备，备机可读 策略不放开 多维碰撞分析GPU加速 高级特性 全文索引 基础版 Extension_CONNECTOR 基础版 EXPRESS_CLUSTER 高级版 跨DC协同 高级版 不支持 不支持 PostGis对接 基础版 openGauss内高可用-一主多备 策略不放开 行级权限控制 高级版 透明加密 高级版 私有表 高级版

## 示例

- 启动openGauss。

    ```
    gs_om -t start
    Starting cluster.
    ======================================================================
    .
    ======================================================================

    Successfully started .
    ```

- 停止openGauss。

  ```
  gs_om -t stop
  Stopping cluster.
  =========================================
  Successfully stopped cluster.
  =========================================
  End stop cluster.
  ```

- 查看openGauss详细状态信息，含实例状态信息。

  ```
  gs_om -t status --detail

    [   Cluster State   ]

    cluster_state   : Normal
    redistributing  : No
    current_az      : AZ_ALL

    [  Datanode State   ]

  node                              node_ip         port                 instance                                   state
  -----------------------------------------------------------------------------------------------------------------
  1  pekpopgsci00235  10.244.62.204    5432      6001 /opt/gaussdb/cluster/data/dn1   P Primary Normal
  2  pekpopgsci00238  10.244.61.81      5432      6002 /opt/gaussdb/cluster/data/dn1   S Standby Normal

  ```

- 在openGauss上执行如下命令，生成配置文件。

  ```
  gs_om -t generateconf -X  /opt/software/openGauss/clusterconfig.xml  --distribute
  Generating static configuration files for all nodes.
  Creating temp directory to store static configuration files.
  Successfully created the temp directory.
  Generating static configuration files.
  Successfully generated static configuration files.
  Static configuration files for all nodes are saved in /opt/opengauss/Bigdata/gaussdb/wisequery/script/static_config_files.
  Distributing static configuration files to all nodes.
  Successfully distributed static configuration files.
  ```

- 在openGauss上执行如下命令，修改配置文件，动态配置文件需要执行gs\_om -t refreshconf 手动刷新，实际端口或者ip生效需要手动修改guc参数。

  ```
  gs_om -t generateconf --old-values=26000,192.168.1.1  --new-values=36000,192.168.1.2  --distribute
  Generating static configuration files for all nodes.
  Creating temp directory to store static configuration files.
  Successfully created the temp directory.
  Generating static configuration files.
  Successfully generated static configuration files.
  Static configuration files for all nodes are saved in /opt/huawei/Bigdata/gaussdb/wisequery/script/static_config_files.
  Distributing static configuration files to all nodes.
  Successfully distributed static configuration files.
  ```

然后打开生成的配置文件目录，会看到新生成的3个文件。

  ```
  cd /opt/opengauss/Bigdata/gaussdb/wisequery/script/static_config_files
  ll
  total 456
  -rwxr-xr-x 1 omm dbgrp 155648 2016-07-13 15:51 cluster_static_config_plat1
  -rwxr-xr-x 1 omm dbgrp 155648 2016-07-13 15:51 cluster_static_config_plat2
  -rwxr-xr-x 1 omm dbgrp 155648 2016-07-13 15:51 cluster_static_config_plat3
  ```

- SSL证书回退。

    ```
    gs_om -t cert --rollback
    [plat1] SSL cert files rollback successfully.
    [plat2] SSL cert files rollback successfully.
    [plat3] SSL cert files rollback successfully.
    ```

- 新License注册。

    ```
    gs_om -t license -m register -f MTgsMTkK
    Preparing for the program initialization.
    Lock the OPS operation of OM components.
    Check and make sure the consistency of the license file.
    Backup the license file on all of the cluster hosts.
    Encrypt the product feature information and generate the license file.
    Send message to the 数据库节点 instances to reload the license file.
    Remove the backup license file on all of the cluster hosts.
    License register successfully.
    ```

- 新License反注册。

    ```
    gs_om -t license -m unregister -f MTgsMTkK
    Preparing for the program initialization.
    Lock the OPS operation of OM components.
    Check and make sure the consistency of the license file.
    Backup the license file on all of the cluster hosts.
    Encrypt the product feature information and generate the license file.
    Send message to the 数据库节点 instances to reload the license file.
    Remove the backup license file on all of the cluster hosts.
    License unregister successfully.
    ```

- 根据当前集群状态生成xml配置文件

    ```
    gs_om -t generate_xml --add-hostname=open1 --add-hostip=192.168.0.11
    Start generate xml.
    Successfully generated xml. the xml is /home/xxx/xml_output_20240221103102.xml
    ```

- 查询历史升级记录

    ```
    gs_om -t query_upgrade_records
    Start generate xml.
    Record[1]
    Action: auto-upgrade
    status: begin
    time: 2024-12-23 19:34:32
    oldVersionInfo:
    newVersionInfo:
    oldPkgSha256:
    newPkgSha256:
    details:

    Record[2]
    Action: large-binary-upgrade
    status: success
    time: 2024-12-23 19:37:51
    oldVersionInfo: 6.0.0 92.954 aee4abd5
    newVersionInfo: 7.0.0-RC1 93.026 7ef91864
    oldPkgSha256: c8cd8f90955c22a932e5f66375572cc17e60c49b0ac5afdf03031c1607aaf5a2
    newPkgSha256: 189fd3f0581f7231f78384d171a399f590fa533f77b66b76a82e911f7e2d0b3d
    details: Successfully upgrade all nodes.
    ```
