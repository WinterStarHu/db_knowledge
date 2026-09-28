# cm\_ctl工具介绍

cm\_ctl是openGauss提供的用来控制数据库实例服务的工具。该工具主要供OM调用，及数据库实例服务自恢复时使用。cm\_ctl的主要功能有：

- 启动数据库实例服务、AZ的所有实例、单个主机上的所有实例或单独启动某个实例进程。
- 停止数据库实例服务、AZ的所有实例、单个主机上的所有实例或单独停止某个节点实例进程。
- 重启逻辑数据库实例服务。
- 查询数据库实例状态或者单个主机的状态。
- 切换主备实例或重置实例状态。
- 重建备机。
- 查看数据库实例配置文件。
- 设置日志级别，一主多备数据库实例部署下cm\_server的仲裁模式、AZ之间的切换模式。
- 获取日志级别，一主多备数据库实例部署下cm\_server的仲裁模式、AZ之间的切换模式。
- 检测实例进程状态。

与cm\_ctl工具相关的文件：

- cluster\_manual\_start

该文件是数据库实例启停标志文件。文件位于_$GAUSSHOME/bin_下。其中，GAUSSHOME为环境变量。启动数据库实例时，cm\_ctl会删除该文件；停止数据库实例时，cm\_ctl会生成该文件，并向文件写入停止模式。

- instance\_manual\_start\_X（X是实例编号）

该文件是单个实例启停标志文件。文件位于_$GAUSSHOME/bin_下。其中，GAUSSHOME为环境变量。启动实例时，cm\_ctl会删除该文件；停止实例时，cm\_ctl会生成该文件，并向文件写入停止模式。

cm\_ctl的相关约束：

- 在安装CM的集群环境下，使用cm\_ctl集群工具来切换数据库角色，而不是gs\_ctl或gs\_om工具。
- 在安装CM的集群环境下，如果要执行的操作没有对应的cm\_ctl命令，可以通过以下流程实现：通过cm\_uninstall工具卸载cm，手动修改完成对应操作，通过cm\_install工具安装重新安装cm。

## 命令说明

cm\_ctl参数可分为如下几类：

- option参数，详细请参见  [表 option参数](#zh-cn_topic_0116784021_table1718281376)。
- 公共参数，详细请参见  [表 公共参数](#zh-cn_topic_0116784021_t73f4b6dad11943ea811a211e6c127669)。
- start模式的参数，详细参见  [表 start参数](#table45722029132319)。
- switchover模式的参数，详细请参见  [表 switchover参数](#table12226155814102)。
- build模式的参数，详细请参见  [表 build参数](#table649003761312)。
- check模式的参数，详细请参见  [表 check参数](#zh-cn_topic_0116784021_t5582631c9b25449da85855fab919ddfd)。
- stop模式的参数，详细请参见  [表 stop参数](#zh-cn_topic_0116784021_t7507cabe697c4b4da00814fccee8e559)。
- query模式的参数，详细请参见  [表 query参数](#zh-cn_topic_0116784021_t19badc48929f4f9abd94b8ac774f06c1)。
- view模式的参数，详细请参见  [表 view参数](#zh-cn_topic_0116784021_table207722104617)。
- set模式的参数，详细请参见  [表 set参数](#zh-cn_topic_0116784021_tef5e0858a71c4d21abce8f80e3ba7723) [表 set cm参数](#table10437204416514)。
- get模式的参数，详情请参见  [表 get参数](#table1599151916313)。
- setrunmode模式的参数，详细请参见  [表 setrunmode参数](#table1656519521713)。
- changerole模式的参数，详细请参见  [表 changerole参数](#table326418392182)。
- changemember功能的参数，详细请参见  [表 changemember参数](#table27311655104911)。
- reload模式的参数，详细请参见  [表 reload 参数](#table11377594818)。
- list模式的参数，详细请参见  [表 list参数](#table0914920191018)。
- encrypt模式的参数，详细请参见  [表 encrypt参数](#table4739105911382)。
- ddb模式的参数，详细请参见  [表 ddb参数](#table9665145942617)。
- switch模式的参数，详细请参见  [表 switch参数](#table7591811163812)。
- res模式的参数，详细请参见  [表 res参数](#table11658339114119)。

使用方法:

```
cm_ctl start [-z AVAILABILITY_ZONE [--cm_arbitration_mode=ARBITRATION_MODE]] | [-n NODEID [-D DATADIR]] [-t SECS]
cm_ctl switchover [-z AVAILABILITY_ZONE] | [-n NODEID -D DATADIR [-f]] | [-a] | [-A] [-t SECS]
cm_ctl finishredo
cm_ctl build [-c] [-n NODEID] [-D DATADIR [-t SECS] [-f] [-b full] [-j NUM]]
cm_ctl check -B BINNAME -T DATAPATH
cm_ctl stop [[-z AVAILABILITY_ZONE] | [-n NODEID [-D DATADIR]]] [-t SECS] [-m SHUTDOWN-MODE]
cm_ctl query [-z ALL] [-l FILENAME] [-v [-C [-w] [-s] [-S] [-d] [-i] [-F] [-x] [-p]] | [-r]] [-t SECS] [- O] [--minorityAz=AZ_NAME]
cm_ctl view [-v | -N | -n NODEID] [-l FILENAME]
cm_ctl set [--log_level=LOG_LEVEL] [--cm_arbitration_mode=ARBITRATION_MODE] [--cm_switchover_az_mode=SWITCHOVER_AZ_MODE] [--cmsPromoteMode=CMS_PROMOTE_MODE -I INSTANCEID]
cm_ctl set --param --agent | --server [-n [NODEID]] -k [PARAMETER]="[value]"
cm_ctl get [--log_level] [--cm_arbitration_mode] [--cm_switchover_az_mode]
cm_ctl setrunmode -n NODEID -D DATADIR  [[--xmode=normal] | [--xmode=minority --votenum=NUM]]
cm_ctl changerole [--role=PASSIVE | --role=FOLLOWER] -n NODEID -D DATADIR [-t SECS]
cm_ctl changemember [--role=PASSIVE | --role=FOLLOWER] [--group=xx] [--priority=xx] -n NODEID -D DATADIR [-t SECS]
cm_ctl reload --param [--agent | --server]
cm_ctl list --param --agent | --server
cm_ctl encrypt [-M MODE] -D DATADIR
cm_ctl ddb DCC_CMD
cm_ctl switch [--ddb_type=[DDB]] [--commit] [--rollback]
```

**表 1**  option参数

参数说明 start 一主多备数据库部署模式下启动数据库实例服务、单个主机上的所有实例或单独启动某个节点实例进程，或者直接启动整个AZ。
switchover 一主多备数据库部署模式下切换数据库主备实例。也支持传统流式容灾架构灾备集群下切换数据库首备级联备实例 finishredo 所有备机停止回放，每个分片中选择一个强制升主。
build 重建备实例。
check 检测实例进程运行状态，用户无需关注，不建议使用。
stop 一主多备数据库部署模式下停止数据库实例服务、单个主机上的所有实例或单独停止某个节点实例进程。
query 一主多备数据库部署模式下查询数据库实例状态或者单个主机的状态。
view 查看数据库实例配置文件。
set 设置日志级别，一主多备数据库部署模式下cm_server的仲裁模式、AZ之间的切换模式、cm_server升主模式。
set --param 设置cm参数，默认set所有节点上的参数，也可以通过-n参数指定set某个节点，具体参数可以参考CM配置参数介绍 get 获取日志级别，一主多备数据库部署模式下cm_server的仲裁模式、AZ之间的切换模式。
setrunmode DCF部署方式下，设置DCF投票数，主要用于DCF强启。
changerole DCF模式下，将角色为primary的修改为passive或者follower。
changemember DCF模式下，改变指定DCF节点属性，包括节点角色、节点所在的逻辑组、节点的选举优先级等。
reload 在线加载数据库实例静态配置文件，用户无需关注，不建议使用。
reload --param 加载可以动态生效的cm参数，部分参数不支持reload，只能重启cm才能生效。
list 列出cm_agent或cm_server所有的参数。
encrypt 对输入的密码进行加密操作，密码支持8~15位，且必须包含三种字符（数字，字母，符号）。
ddb DCC或者share disk模式下，执行对DCC组件或者share disk的配置数据存取命令。CM依赖DCC组件或者share disk对配置数据分布式存取，实现集群配置管理高可用能力。
switch 执行ddb模式的切换。
res 在节点上进行资源配置的新增、修改、查询、删除。
show 展示集群DN节点网络连通性和每个节点的共享盘连通性 rack 显示灵衢场景下UBSE集群内存信息。

**表 2**  公共参数

参数说明 -D DATADIR 指定实例数据目录。仅用于对数据库节点进行操作的命令，如start、stop、switchover、build、setrunmode、changerole、changemember、encrypt。
-l FILENAME 查询结果输出到指定文件。仅用于查询类的命令，如query、view。
-n NODEID 指定节点。
-z AVAILABILITY_ZONE 指定AZ名称。
-t SECS 指定超时时间。超时后，会退出并报错。
-V, --version 打印cm_ctl版本信息，然后退出。
-?, -h,--help 显示关于cm_ctl命令行参数的帮助信息，然后退出。

[!NOTE]说明

此处列出的公共参数并不一定适用于所有命令，而是多个命令支持，为避免冗余信息，所以统一在此说明，详细的使用方法见以上使用方法，也可以使用cm_ctl --help进行查询。

**表 3**  switchover参数

参数说明 将集群的主机重置到初始配置的节点。
将主机切换到一个合适的备机节点上。该参数在数据保险柜集群中无法使用。
指定进行-f类型switchover。不等待客户端中断连接，所有活跃事务都被回滚并且客户端都被强制断开，然后服务器将被切换，且不做checkpoint。使用方式：cm_ctl switchover -n NODEID -D DATADIR -f。
将主机切换到-z参数指定的AZ。

**表 4**  build参数

参数说明 强制重建备机。
-b full 指定进行全量build。不指定情况下，对于一主多备数据库实例部署模式进行auto build。auto build指：先调用增量build，失败之后调用全量build。
重建 cm_server（将主节点的DCC数据目录拷贝到指定节点，只适用于一主一备模式）。

**表 5**  check参数

参数说明 -B BINNAME 指定进程名，其进程名包括“cm_agent”,“gaussdb”和“cm_server”。
-T DATAPATH 指定实例数据目录。

**表 6**  stop参数

参数说明 -m SHUTDOWN-MODE 指定停止模式，停止模式有以下几种： smart（s）：等待用户业务结束后，停止所有数据库实例。fast（f）：不等待用户业务结束，指定数据库实例退出。immediate（i）：不等待用户业务结束，指定数据库实例强制退出。
指定需要停止的资源实例号，可以通过cm_ctl query -Cv查看资源实例和实例号的映射关系

**表 7**  query参数

参数说明 显示导致各个节点主备实例数量不均衡的实例。
按主备关系成对显示数据库实例状态。
显示详细数据库实例状态。
纵向分行显示数据库实例状态（与cms状态显示格式一致）。
显示实例数据目录。
显示物理节点ip。
显示各个节点Fenced UDF状态。
-z ALL 显示数据库实例所在AZ名称。
显示备机redo状态。
显示备份和恢复群集信息。
显示所有异常的数据库实例。
显示数据库实例启动时的状态检查结果。

--minorityAz 只查询指定AZ的cms。
显示数据库实例所有节点端口。
显示一小时内节点因各种原因踢出次数统计。

**表 8**  set参数

参数说明 --log_level=LOG_LEVEL 设置主cm_server日志级别。共分为DEBUG5、DEBUG1、WARNING、LOG、ERROR和FATAL六个级别，日志打印信息级别越来越高。设置日志级别越高，输出日志信息就越少。
--cm_arbitration_mode=ARBITRATION_MODE 一主多备功能，设置cm_server的仲裁模式。共有MAJORITY、MINORITY两种模式，MAJORITY为多数派模式，MINORITY为少数派模式。openGauss不支持少数派，此参数可以设置成MINORITY，但不会生效。
--cm_switchover_az_mode= SWITCHOVER_AZ_MODE 一主多备功能，设置AZ之间的自动切换开关。共有NON_AUTO、AUTO两种模式，NON_AUTO为非自动切换模式，AUTO为自动切换模式。AUTO模式由主cm_server自动控制AZ1和AZ2之间的节点实例切换。
--cmsPromoteMode=CMS_PROMOTE_MODE -I INSTANCEID 设置cm_server的升主方式，共有AUTO、PRIMARY_F两种模式，AUTO为默认自选主方式，PRIMARY_F会强制使-I指定的节点升主，无论当前是否有主，因此，有可能会导致cms存在多主情况。

**表 9**  set cm参数

参数说明 --param 表明需要设置cm参数，不带此参数则不能执行设置cm参数。
--agent | --server 此参数为必带参数，表明当前需要设置cm_server还是cm_agent的参数。
-k parameter="value" 指定设置的参数和参数的值，只能设置已经存在的参数，不支持增加或删减参数。

**表 10**  get参数

参数说明 --log_level 获取主cm_server日志级别LOG_LEVEL。共分为DEBUG5、DEBUG1、WARNING、LOG、ERROR和FATAL六个级别，日志打印信息级别越来越高。设置日志级别越高，输出日志信息就越少。
--cm_arbitration_mode 一主多备功能，获取cm_server的仲裁模式ARBITRATION_MODE。共有MAJORITY、MINORITY两种模式，MAJORITY为多数派模式，MINORITY为少数派模式。少数派模式适用于一主多备数据库部署并且只有AZ3存活时，此时cm_server可以进行正常的仲裁业务，非此模式下将仲裁模式设置成少数派成功后，cm会自动将仲裁模式改为多数派，以保证集群正常运转；多数派模式适用于一主多备数据库部署并且各个组件（cm_server，节点）存活数量大于一半的场景。数据库实例正常情况下默认为多数派模式。
--cm_switchover_az_mode 一主多备功能，获取AZ之间的自动切换开关SWITCHOVER_AZ_MODE。共有NON_AUTO、AUTO两种模式，NON_AUTO为非自动切换模式，AUTO为自动切换模式。AUTO模式由主cm_server自动控制AZ1和AZ2之间的节点实例切换。

**表 11**  view参数

参数说明 显示数据库实例所有节点的静态配置详细信息。
只显示本节点的静态配置信息，即执行cm_ctl view命令的节点的信息，N表示Native。

**表 12**  setrunmode参数

参数说明 取值范围 --xmode 指定DCF的运行模式。
normal：正常模式。minority：少数派模式，需要--votenum指定投票数。
--votenum 指定DCF少数派运行方式的投票数。
正整数，不高于DCF总副本数。

**表 13**  changerole参数

参数说明 取值范围 --role DCF模式下，将角色为primary的修改为passive或者follower。
passive：passive角色。follower：follow角色。

**表 14**  changemember参数

参数说明 取值范围 --role DCF模式下，将角色为primary的修改为passive或者follower。
passive：passive角色。follower：follow角色。
--group DCF模式下，修改group的值。
0~2147483647 --priority DCF模式下，修改priority的值。
0~2147483647

**表 15**  start参数

参数说明 --cm_arbitration_mode=ARBITRATION_MODE 一主多备功能，获取cm_server的仲裁模式。共有MAJORITY、MINORITY两种模式，MAJORITY为多数派模式，MINORITY为少数派模式。少数派模式适用于一主多备数据库部署并且只有AZ3存活时，此时cm_server可以进行正常的仲裁业务，非此模式下将仲裁模式设置成少数派成功后，cm会自动将仲裁模式改为多数派，以保证集群正常运转；多数派模式适用于一主多备数据库部署并且各个组件（cm_server，节点）存活数量大于一半的场景。数据库实例正常情况下默认为多数派模式。
指定需要启动的资源实例号，可以通过cm_ctl query -Cv查看资源实例和实例号的映射关系

**表 16**  reload 参数

参数说明 --param 表明需要加载cm参数，不带此参数则不能执行加载cm参数。
--agent | --server 表明当前需要动态加载cm_server还是cm_agent的参数。

**表 17**  list参数

参数说明 --param 此参数为必带参数，表明需要列出cm参数信息。
--agent | --server 此参数为必带参数，表明当前需要查看cm_server还是cm_agent的参数。

**表 18**  encrypt参数

参数说明 指定加密类型，支持server、client。默认类型为server。
指定生成的加密密码文件路径。

**表 19**  switch参数

参数说明 --ddb_type=[DDB] 选择需要切换DDB模式（opengauss只支持DCC模式）。
--commit 执行切换会使数据库实例无法选主，需要执行commit恢复数据库实例。
--rollback 回滚操作，执行切换失败需要执行回滚操作。

**表 20**  ddb参数

参数说明 --put [key] [value] 往DCC或者share disk中插入键值对，如果键值对已存在则会修改键key所对应的值value。
--get [key] 查询DCC或者share disk中key对应的value。
--delete [key] 删除DCC或者share disk中指定的键值对。
--prefix get或者delete后添加prefix参数，可以实现模糊匹配查询和删除。
--cluster_info DCC部署模式下获取数据库实例信息，share disk部署模式下不支持该命令。
--leader_info DCC部署模式下获取主节点信息，share disk部署模式下不支持该命令。
--help，-h 显示DDB命令帮助信息。
--version，-v DCC部署模式下显示DCC版本信息，share disk部署模式下不支持该命令。

**表 21**  res参数

参数说明 --add --res_name=[name] --res_attr=[res_info] 新增资源配置，name为新增资源的名称，res_info为新增资源的信息。
--del --res_name=[name] 删除资源配置，name为删除资源的名称。
--edit --res_name=[name] --res_attr=[res_info] 修改资源配置，name为被修改资源的名称，res_info为新修改的资源信息。
--edit --res_name=[name] --add_inst=[inst_info] 新增资源实例，name为新增实例的资源名称，inst_info为新增实例的信息。
--edit --res_name=[name] --del_inst=[inst_info] 删除资源实例，name为删除实例的资源名称，inst_info为删除实例的信息。
--check 检查资源配置。不合理处会显示Warning，配置不可用才会报错。

>[!WARNING]注意
>
>- 在部署有CM工具的情况下，对于某些既可以直接调用内核工具，也可以调用CM工具进行执行的命令，如：switchover、build等，请优先使用CM工具，因为如果直接调用内核工具，有可能CM感知不到用户正在手动执行指令，进而误判集群状态异常。
>- CM有进程保活功能，并且会实时监控集群状态并进行自动故障处理，如果运维人员需要手动处理集群状态或进行问题调试定位等，最好执行cm_ctl pause命令将CM服务暂停掉，否则可能会干扰运维操作，待运维操作完成后可以执行cm_ctl resume命令恢复CM服务。

## 命令参考

- 启动实例：

    ```
    cm_ctl start [-z AVAILABILITY_ZONE [--cm_arbitration_mode=ARBITRATION_MODE]] | [-n NODEID [-D DATADIR]] [-t SECS]
    ```

- 数据库主备倒换：

    ```
    cm_ctl switchover [-z AVAILABILITY_ZONE] | [-n NODEID -D DATADIR [-f]] | [-a] | [-A] [-t SECS]
    ```

- 所有备机停止回放，每个分片中选择一个强制升主：

    ```
    cm_ctl finishredo
    ```

- 重建备节点：

    ```
    cm_ctl build -n NODEID -D DATADIR [-t SECS] [-f] [-b full]
    ```

- 检测实例进程运行状态：

    ```
    cm_ctl check -B BINNAME -T DATAPATH
    ```

- 停止实例：

    ```
    cm_ctl stop [[-z AVAILABILITY_ZONE] | [-n NODEID [-D DATADIR [-R]]]] [-t SECS] [-m SHUTDOWN-MODE]
    ```

- 查询集群状态：

    ```
    cm_ctl query [-z ALL] [-l FILENAME] [-v [-C [-s] [-S] [-d] [-i] [-F] [-x] [-p]] | [-r]] [-t SECS] [--minorityAz=AZ_NAME]
    ```

- 查看集群配置文件：

    ```
    cm_ctl view [-v | -N | -n NODEID] [-l FILENAME]
    ```

- 设置参数：

    ```
    cm_ctl set [--log_level=LOG_LEVEL] [--cm_arbitration_mode=ARBITRATION_MODE] [--cm_switchover_az_mode=SWITCHOVER_AZ_MODE]
    ```

- 设置CM参数：

    ```
    cm_ctl set --param --agent | --server [-n NODEID] -k PARAMETER="'value'"
    ```

- 获取参数：

    ```
    cm_ctl get [--log_level] [--cm_arbitration_mode] [--cm_switchover_az_mode]
    ```

- 设置DCF投票数：

    ```
    cm_ctl setrunmode -n NODEID -D DATADIR  [[--xmode=normal] | [--xmode=minority --votenum=NUM]]
    ```

- 改变dcf角色信息：

    ```
    cm_ctl changerole [--role=PASSIVE | --role=FOLLOWER] -n NODEID -D DATADIR [-t SECS]
    ```

- 改变dcf节点属性：

    ```
    cm_ctl changemember [--role=PASSIVE | --role=FOLLOWER] [--group=xx] [--priority=xx] -n NODEID -D DATADIR [-t SECS]
    ```

- 动态加载CM参数：

    ```
    cm_ctl reload --param [--agent | --server]
    ```

- 列出所有CM参数：

    ```
    cm_ctl list --param [--agent | --server]
    ```

- 加密：

    ```
    cm_ctl encrypt [-M MODE] -D DATADIR
    ```

- 执行DDB命令行：

    ```
    cm_ctl ddb DDB_CMD
    设置：cm_ctl ddb --put [key] [value]
    删除：cm_ctl ddb --delete [key]
    查看DDB命令帮助信息：cm_ctl ddb --help
    ```

- 执行switch ddb命令：

    ```
    cm_ctl switch [--ddb_type=[DDB]] [--commit] [--rollback]
    ```

- 执行res命令：

    ```
    新增资源：cm_ctl res --add --res_name=[name] --res_attr=[res_info]
    删除资源：cm_ctl res --del --res_name=[name]
    修改资源：cm_ctl res --edit --res_name=[name] --res_attr=[res_info]
    新增资源实例：cm_ctl res --edit --res_name=[name] --add_inst=[inst_info]
    删除资源实例：cm_ctl res --edit --res_name=[name] --del_inst=[inst_info]
    检查资源：cm_ctl res --check
    ```
