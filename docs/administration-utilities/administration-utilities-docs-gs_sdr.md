# gs\_sdr

## 背景信息

从openGauss 3.1.0版本开始，openGauss提供了gs\_sdr工具，在不借助额外存储介质的情况下实现跨region的异地容灾。提供流式容灾搭建，容灾升主，计划内主备切换，容灾解除、容灾状态监控功能、显示帮助信息和显示版本号信息等功能。

## 约束条件

- 搭建容灾的两个集群必须是具备cm工具的集群。
- 搭建容灾的主备集群版本号必须相同。
- 流式容灾搭建前不支持已存在级联备。
- 搭建容灾的两个集群的初始数据库用户及密码必须相同，所有指令需在数据库用户下执行；
- 如果搭建容灾的两个集群存在数据不一致情况，在进行容灾搭建命令执行时，会对灾备集群进行全量build完成初始化，搭建前请确认清楚。
- 容灾搭建指令、计划内主备切换指令执行，需要同时在主备集群（执行节点：集群内主备节点均可）执行对应指令。因为主备集群执行过程会进行交互等待。
- 搭建容灾关系前，主集群需创建容灾用户，用于容灾鉴权，主备集群必须使用相同的容灾用户名和密码，一次容灾搭建后，该用户密码不可修改。若需修改容灾用户名与密码，需要解除容灾，使用新的容灾用户重新进行搭建。容灾用户密码中不可包含以下字符“| ;&$<>`'"{}()[]~*?!\n-空白”。
- 搭建容灾关系时，如果集群副本数<=2，会设置most_available_sync为on，在容灾解除或者failover后此参数不会恢复初始值，持续保证集群为最大可用模式。
- 搭建容灾关系时，会设置synchronous_commit为on，解除容灾或failover升主时恢复初始值。灾备集群可读不可写。
- 灾备集群通过failover命令升主后，和原主集群灾备关系将失效，需要重新搭建容灾关系。
- 在主数据库实例和灾备数据库实例处于normal状态时可进行容灾搭建；在主数据库实例处于normal态并且灾备数据库实例已经升主的情况下，主数据库实例可执行容灾解除，其他数据库实例状态不支持。在主数据库实例和灾备数据库实例处于normal状态时，通过计划内switchover命令，-    主数据库实例可切换为灾备数据库实例，灾备数据库实例可切换为主数据库实例。灾备数据库实例处于非Normal且非Degraded状态时，无法升主，无法作为灾备数据库实例继续提供容灾服务，需要手动修复或重建灾备数据库实例。
- 灾备集群DN多数派故障或者CMS、DN全故障，无法启动容灾，灾备集群无法升主，无法作为灾备集群，需要重建灾备集群。
- 主集群如果进行了强切操作，需要重建灾备集群。
- 主备集群都支持gs_probackup工具中全备和增备。
- 容灾关系搭建之后，不支持DN实例端口修改。
- 建立容灾关系的主数据库实例与灾备数据库实例之间不支持GUC参数的同步。
- 主备集群不支持节点替换、修复、升降副本，DCF模式。
- 当灾备数据库实例为2副本时，灾备数据库实例在1个副本损坏时，仍可以升主对外提供服务，如果剩余的这个副本也损坏，将导致不可避免的数据丢失。
- 容灾状态下仅支持灰度升级，且继承原升级约束，容灾状态下升级需要遵循先升级主集群，再升级备集群，再提交备集群，再提交主集群的顺序。
- 建议对于流式容灾流复制IP的选择，应考虑尽量使集群内的网络平面与跨集群网络平面分离，便于压力分流并提高安全性。
- 升级过程中不支持容灾搭建、主备切换、容灾升主、容灾查询、容灾解除操作。
- 需以操作系统用户omm执行gs\_sdr命令。

## 语法

- 容灾搭建

    ```
    gs_sdr -t start -m [primary|disaster_standby] [-U DR_USERNAME] [-W DR_PASSWORD] [-X XMLFILE] [--json JSONFILE] [--time-out=SECS] [-l LOGFILE]
    ```

- 容灾升主

    ```
    gs_sdr -t failover [-l LOGFILE]
    ```

- 计划内主备切换

    ```
    gs_sdr -t switchover -m [primary|disaster_standby] [--time-out=SECS] [-l LOGFILE]
    ```

- 容灾解除

    ```
    gs_sdr -t stop [-X XMLFILE] [--json JSONFILE] [-l LOGFILE]
    ```

- 容灾状态监控

    ```
    gs_sdr -t query [-l LOGFILE]
    ```

## 参数说明

gs\_sdr参数可以分为如下几类：

- 通用参数：
  - -t

gs\_sdr命令的类型。

取值范围：start、failover、switchover、stop、query。

  - -l

指定日志文件及存放路径。

默认值：$GAUSSLOG/om/gs\_sdr-YYYY-MM-DD\_hhmmss.log

  - -?, --help

显示帮助信息。

  - -V, --version

显示版本号信息。

- 搭建容灾参数：
  - -m

期望该集群在容灾关系中成为的角色

取值范围：primary\(主集群\)或disaster\_standby\(灾备集群\)

  - -U

具有流复制权限的容灾用户名称

  - -W

容灾用户密码

>[!NOTE]说明
>
>1. 搭建容灾关系前，主集群需创建容灾用户，用于容灾鉴权，主备集群必须使用相同的容灾用户名和密码，一次容灾搭建后，该用户密码不可修改。若需修改容灾用户名与密码，需要解除容灾，使用新的容灾用户重新进行搭建。容灾用户密码中不可包含以下字符“| ;&$<>`\'"{}()[]~*?!\n空白”。
>2. -U、-W 参数如果搭建命令行未带，则在搭建过程中支持交互式输入。
>3. -W 参数在命令行中输入时，其他终端可以通过ps方式查看到密码，存在安全风险。建议通过交互方式输入。

  - -X

集群安装时的xml，xml中也可以配置容灾信息用于容灾搭建，即在安装xml的基础上扩展三个字段（"localStreamIpmap1"、"remoteStreamIpmap1"、"remotedataPortBase"）

新增字段的配置方式如下，加粗字体内容为示例。每行信息均有注释进行说明。

        ```

        ```

  - --json

带有容灾信息的json文件。

json文件的配置方式如下，加粗字体内容为示例。

        ```
        {
            "remoteClusterConf": {
                "port": 26000,
                "shards": [[
                    {"ip": "10.244.45.144", "dataIp": "172.31.2.200"},
                    {"ip": "10.244.45.40", "dataIp": "172.31.0.38"},
                    {"ip": "10.244.46.138", "dataIp": "172.31.11.145"},
                    {"ip": "10.244.48.60", "dataIp": "172.31.9.37"},
                    {"ip": "10.244.47.240", "dataIp": "172.31.11.125"}
                ]]
            },
            "localClusterConf": {
                "port": 26000,
                "shards": [[
                    {"ip": "10.244.44.216", "dataIp": "172.31.12.58"},
                    {"ip": "10.244.45.120", "dataIp": "172.31.0.91"}
                ]]
            }
        }
        参数说明：
        # remoteClusterConf：对端集群的dn分片信息。其中port为对端集群主dn的端口，{"ip": "10.244.45.144", "dataIp": "172.31.2.200"}为对端集群dn分片上各节点用于SSH可信通道的IP与流复制的IP映射关系。
        # localClusterConf：本集群的dn分片信息。其中port为本集群主dn的端口，{"ip": "10.244.44.216", "dataIp": "172.31.12.58"}为本集群dn分片上各节点用于SSH可信通道的IP与流复制的IP映射关系。
        ```

>[!NOTE]说明
>
>-X与--json参数支持二选一方式进行配置容灾信息，如果命令行中两个参数全部下发，则以json为准。

  - --time-out=SECS

指定超时时间，主集群会等待备集群连接的超时时间，超时则判定失败，om脚本自动退出。单位：s。

取值范围：正整数，建议值1200。

默认值：1200

>[!NOTE]说明
>
>需要注意的是，build和start集群都有自己的超时时间设置。对于build集群，默认的超时时间为1209600秒（14天），如果在这个时间内没有完成构建操作，将自动退出。而对于start集群，默认的超时时间为604800秒（一周），即一周内如果没有完成启动操作，将自动退出。如果不指定--time-out=SECS参数，那么在build集群中，超时时间为1200秒后不会自动退出；而在start集群中，超时时间为1200秒后也不会自动退出。

- 容灾升主参数：

无

- 容灾解除参数：
  - -X

集群安装时的xml，需要额外配置容灾信息，即扩展三个字段（"localStreamIpmap1"、"remoteStreamIpmap1"、"remotedataPortBase"）

  - --json

带有本端及对端容灾信息的json文件。

>[!NOTE]说明
>
>-X、--json的配置方式请参考本节容灾搭建参数配置。

- 容灾查询参数：
  - 无

容灾状态查询结果说明如下：

hadr_cluster_stat 流式容灾中数据库实例状态 normal 标识该数据库实例未参与流式容灾 full_backup 主数据库实例数据全量复制中 流式容灾中仅主数据库实例有此状态 archive 主数据库实例日志流式复制中 流式容灾中仅主数据库实例有此状态 backup_fail 主数据库实例数据全量复制失败 流式容灾中仅主数据库实例有此状态 archive_fail 主数据库实例日志流式复制失败 流式容灾中仅主数据库实例有此状态 switchover 计划内主备倒换中 流式容灾中主备数据库实例皆有此状态 restore 灾备数据库实例数据全量恢复中 流式容灾中仅灾备数据库实例有此状态 restore_fail 灾备数据库实例全备恢复失败 流式容灾中仅灾备数据库实例有此状态 recovery 灾备数据库实例日志流式复制中 流式容灾中仅灾备数据库实例有此状态 recovery_fail 灾备数据库实例日志流式复制失败 流式容灾中仅灾备数据库实例有此状态 promote 灾备数据库实例升主中 流式容灾中仅灾备数据库实例有此状态 promote_fail 灾备数据库实例升主失败 流式容灾中仅灾备数据库实例有此状态 hadr_switchover_stat 流式容灾主备数据库实例计划内倒换进度展示 百分比 倒换进度展示 hadr_failover_stat 流式容灾灾备数据库实例升主进度展示 百分比 倒换进度展示 RTO 此时发生灾难，数据恢复所需要的时长 数据库实例停机，网络异常等导致流式容灾中断 流式容灾中仅主数据库实例可查 数据恢复所需要的时长，单位s RPO 此时发生灾难，数据库实例丢失的数据时长 数据库实例停机，网络异常等导致流式容灾中断 流式容灾中仅主数据库实例可查 数据库实例可能丢失的数据时长，单位s

## 示例

- 主集群搭建容灾关系。

    ```
    gs_sdr -t start -m primary -X /opt/install_streaming_primary_cluster.xml --time-out=1200 -U 'hadr_user' -W '******'
    --------------------------------------------------------------------------------
    Streaming disaster recovery start 2b9bc268d8a111ecb679fa163e2f2d28
    --------------------------------------------------------------------------------
    Start create streaming disaster relationship ...
    Got step:[-1] for action:[start].
    Start first step of streaming start.
    Start common config step of streaming start.
    Start generate hadr key files.
    Streaming key files already exist.
    Finished generate and distribute hadr key files.
    Start encrypt hadr user info.
    Successfully encrypt hadr user info.
    Start save hadr user info into database.
    Successfully save hadr user info into database.
    Start update pg_hba config.
    Successfully update pg_hba config.
    Start second step of streaming start.
    Successfully check cluster status is: Normal
    Successfully check instance status.
    Successfully check cm_ctl is available.
    Successfully check cluster is not under upgrade opts.
    Start checking disaster recovery user.
    Successfully check disaster recovery user.
    Start prepare secure files.
    Start copy hadr user key files.
    Successfully copy secure files.
    Start fourth step of streaming start.
    Starting reload wal_keep_segments value: 16384.
    Successfully reload wal_keep_segments value: 16384.
    Start fifth step of streaming start.
    Successfully set [/omm/CMServer/backup_open][0].
    Start sixth step of streaming start.
    Start seventh step of streaming start.
    Start eighth step of streaming start.
    Waiting main standby connection..
    Main standby already connected.
    Successfully check cluster status is: Normal
    Start ninth step of streaming start.
    Starting reload wal_keep_segments value: {'6001': '128'}.
    Successfully reload wal_keep_segments value: {'6001': '128'}.
    Successfully removed step file.
    Successfully do streaming disaster recovery start.
    ```

- 备集群搭建容灾关系。

    ```
    gs_sdr -t start -m disaster_standby -X /opt/install_streaming_standby_cluster.xml --time-out=1200 -U 'hadr_user' -W '******'
    --------------------------------------------------------------------------------
    Streaming disaster recovery start e34ec1e4d8a111ecb617fa163e77e94a
    --------------------------------------------------------------------------------
    Start create streaming disaster relationship ...
    Got step:[-1] for action:[start].
    Start first step of streaming start.
    Start common config step of streaming start.
    Start update pg_hba config.
    Successfully update pg_hba config.
    Start second step of streaming start.
    Successfully check cluster status is: Normal
    Successfully check instance status.
    Successfully check cm_ctl is available.
    Successfully check cluster is not under upgrade opts.
    Start build key files from remote cluster.
    Start copy hadr user key files.
    Successfully build and distribute key files to all nodes.
    Start fourth step of streaming start.
    Start fifth step of streaming start.
    Successfully set [/omm/CMServer/backup_open][2].
    Stopping the cluster by node.
    Successfully stopped the cluster by node for streaming cluster.
    Start sixth step of streaming start.
    Start seventh step of streaming start.
    Start eighth step of streaming start.
    Starting the cluster.
    Successfully started primary instance. Please wait for standby instances.
    Waiting cluster normal...
    Successfully started standby instances.
    Successfully check cluster status is: Normal
    Start ninth step of streaming start.
    Successfully removed step file.
    Successfully do streaming disaster recovery start.
    ```

- 计划内主集群降备。

    ```
    gs_sdr -t switchover -m disaster_standby
    --------------------------------------------------------------------------------
    Streaming disaster recovery switchover 6897d15ed8a411ec82acfa163e2f2d28
    --------------------------------------------------------------------------------
    Start streaming disaster switchover ...
    Streaming disaster cluster switchover...
    Successfully check cluster status is: Normal
    Parse cluster conf from file.
    Successfully parse cluster conf from file.
    Successfully check cluster is not under upgrade opts.
    Got step:[-1] for action:[switchover].
    Stopping the cluster.
    Successfully stopped the cluster.
    Starting the cluster.
    Successfully started primary instance. Please wait for standby instances.
    Waiting cluster normal...
    Successfully started standby instances.
    Start checking truncation, please wait...
    Stopping the cluster.
    Successfully stopped the cluster.
    Starting the cluster.
    Successfully started primary instance. Please wait for standby instances.
    Waiting cluster normal...
    Successfully started standby instances.
    .
    The cluster status is Normal.
    Successfully removed step file.
    Successfully do streaming disaster recovery switchover.
    ```

- 计划内备集群升主。

    ```
    gs_sdr -t switchover -m primary
    --------------------------------------------------------------------------------
    Streaming disaster recovery switchover 20542bbcd8a511ecbbdbfa163e77e94a
    --------------------------------------------------------------------------------
    Start streaming disaster switchover ...
    Streaming disaster cluster switchover...
    Waiting for cluster and instances normal...
    Successfully check cluster status is: Normal
    Parse cluster conf from file.
    Successfully parse cluster conf from file.
    Successfully check cluster is not under upgrade opts.
    Waiting for switchover barrier...
    Got step:[-1] for action:[switchover].
    Stopping the cluster by node.
    Successfully stopped the cluster by node for streaming cluster.
    Starting the cluster.
    Successfully started primary instance. Please wait for standby instances.
    Waiting cluster normal...
    Successfully started standby instances.
    Successfully check cluster status is: Normal
    Successfully removed step file.
    Successfully do streaming disaster recovery switchover.
    ```

- 灾备集群容灾升主。

    ```
    gs_sdr -t failover
    --------------------------------------------------------------------------------
    Streaming disaster recovery failover 65535214d8a611ecb804fa163e2f2d28
    --------------------------------------------------------------------------------
    Start streaming disaster failover ...
    Got step:[-1] for action:[failover].
    Successfully check cluster status is: Normal
    Successfully check cluster is not under upgrade opts.
    Parse cluster conf from file.
    Successfully parse cluster conf from file.
    Got step:[-1] for action:[failover].
    Starting drop all node replication slots
    Finished drop all node replication slots
    Stopping the cluster by node.
    Successfully stopped the cluster by node for streaming cluster.
    Start remove replconninfo for instance:6001
    Start remove replconninfo for instance:6002
    Start remove replconninfo for instance:6003
    Start remove replconninfo for instance:6005
    Start remove replconninfo for instance:6004
    Successfully removed replconninfo for instance:6001
    Successfully removed replconninfo for instance:6004
    Successfully removed replconninfo for instance:6003
    Successfully removed replconninfo for instance:6002
    Successfully removed replconninfo for instance:6005
    Start remove pg_hba config.
    Finished remove pg_hba config.
    Starting the cluster.
    Successfully started primary instance. Please wait for standby instances.
    Waiting cluster normal...
    Successfully started standby instances.
    Successfully check cluster status is: Normal
    Try to clean hadr user info.
    Successfully clean hadr user info from database.
    Successfully removed step file.
    Successfully do streaming disaster recovery failover.
    ```

- 主集群容灾解除。

    ```
    gs_sdr -t stop -X /opt/install_streaming_standby_cluster.xml
    --------------------------------------------------------------------------------
    Streaming disaster recovery stop dae8539ed8a611ecade9fa163e77e94a
    --------------------------------------------------------------------------------
    Start remove streaming disaster relationship ...
    Got step:[-1] for action:[stop].
    Start first step of streaming stop.
    Start second step of streaming start.
    Successfully check cluster status is: Normal
    Check cluster type succeed.
    Successfully check cluster is not under upgrade opts.
    Start third step of streaming stop.
    Start remove replconninfo for instance:6001
    Start remove replconninfo for instance:6002
    Successfully removed replconninfo for instance:6001
    Successfully removed replconninfo for instance:6002
    Start remove cluster file.
    Finished remove cluster file.
    Start fourth step of streaming stop.
    Start remove pg_hba config.
    Finished remove pg_hba config.
    Start fifth step of streaming start.
    Starting drop all node replication slots
    Finished drop all node replication slots
    Start sixth step of streaming stop.
    Successfully check cluster status is: Normal
    Try to clean hadr user info.
    Successfully clean hadr user info from database.
    Successfully removed step file.
    Successfully do streaming disaster recovery stop.
    ```

- 查询容灾状态。

    ```
    gs_sdr -t query
    --------------------------------------------------------------------------------
    Streaming disaster recovery query 1201b062d8a411eca83efa163e2f2d28
    --------------------------------------------------------------------------------
    Start streaming disaster query ...
    Successfully check cluster is not under upgrade opts.
    Start check archive.
    Start check recovery.
    Start check RPO & RTO.
    Successfully execute streaming disaster recovery query, result:
    {'hadr_cluster_stat': 'archive', 'hadr_failover_stat': '', 'hadr_switchover_stat': '', 'RPO': '0', 'RTO': '0'}
    ```
