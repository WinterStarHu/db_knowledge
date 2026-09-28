# gs_ctl

## 背景信息

gs_ctl是openGauss提供的数据库服务控制工具，可以用来启停数据库服务和查询数据库状态。主要供openGauss管理模块调用。

gs_ctl工具由操作系统用户omm执行。

- 启动、停止、重启openGauss节点。
- 在不停止数据库的情况下，重新加载配置文件（postgresql.conf，pg\_hba.conf）。
- 主备切换、主备状态查询、重建和重建状态查询。

gs_ctl build工具支持打印进度，根据已经传输完成的文件大小比上需要传输的总文件大小进行进度打印。

工具运行产生的日志位于$GAUSSLOG/bin/gs\_ctl目录下，每个日志最大16MB，最多保留50个。如果环境变量GAUSSLOG没有配置，则不会产生日志文件。

## 参数说明

gs_ctl参数可分为如下几类：

- option参数，详细请参见[表1](#table145081017222)。
- 公共参数，详细请参见[表2](#zh-cn_topic_0287275989_zh-cn_topic_0237152408_zh-cn_topic_0059777628_t09253ddb2a8a4d4a8ba32b103310bb68)。
- start和restart模式的参数，详细请参见[表3](#zh-cn_topic_0287275989_zh-cn_topic_0237152408_zh-cn_topic_0059777628_t6d75b31bab9540b284e45222396ae38b)。
- stop和restart模式的参数，详细请参见[表4](#zh-cn_topic_0287275989_zh-cn_topic_0237152408_zh-cn_topic_0059777628_t5406d28e9445424c9fcf63658cffc13a)。
- switchover模式的参数，详细请参见[表5](#zh-cn_topic_0287275989_zh-cn_topic_0237152408_zh-cn_topic_0059777628_tb40c07f148df463c8012b9e7183fdb31)。
- build参数，详细请参见[表6](#zh-cn_topic_0287275989_zh-cn_topic_0237152408_zh-cn_topic_0059777628_t22fb7e7152bf4c939f6316c48cb80b5b)。
- query参数，详细请参见[表7](#zh-cn_topic_0287275989_table198621411133319)。
- member参数，详细请参见[表8](#table1055392110383)。
- changerole参数，详细参见[表9](#table591372895218)。
- setrunmode参数，详细参见[表10](#table1451519418810)。
- stack参数，详细参见[表11](#table14515194188888)。
- copy参数，详细参见[表12](#table1451519418811)。
- 资源池化build参数，详细请参见[表13](#table1451519418812)。

**表 1**  option参数

参数说明 init 创建数据库。(与gs_initdb命令使用相同) start 启动数据库。
restart 重启数据库。
build 在主机上重建备实例或级联备实例。
stop 停止数据库。
reload 重载配置文件（postgresql.conf, pg_hba.conf）。
status 显示数据库运行状态。
finishredo 主机故障时，备机停止回放，强制升主。
failover 在主机异常时，将备机切换为主机。
切换成功后，需要执行gs_om -t refreshconf 命令记录当前主备机信息，确保gs_om -t refreshconf 命令执行成功，否则再次重启会影响数据库状态。dcf模式下不支持该操作。
switchover 在主备机正常时，出于维护的需要，将备机切换为主机，可保证切换过程中数据不丢失。
必须在要切换为主机的备机上，执行switchover命令才会生效。在主机上执行switchover命令，仅作查询使用。
切换成功后，需要执行gs_om -t refreshconf 命令记录当前主备机信息，确保gs_om -t refreshconf 命令执行成功，否则再次重启会影响数据库状态。
switchover命令下发后，命令如果超时返回，后台进程的执行状态可能处于不可确定状态。
query 查询主备机之间的状态信息。
notify 启动后再指定主备机。
kill 给指定的进程发送信号量。允许用于 kill 的信号名称包括：ABRT、HUP、INT、QUIT、TERM、USR1、USR2。
querybuild 查看数据库的重建进度。
stack 获取gaussdb的调用栈。
copy 基于共享存储的双中心容灾模式，进行xlog日志拷贝。
member 对成员节点的管理。
changerole 改变节点角色。
setrunmode 设置运行模式。
startwalrcv 通过对日志预解析找到有效日志尾部，启动接收物理日志的walreceiver线程。

**表 2**  公共参数

参数说明 取值范围 -D, --pgdata=DATADIR 指定数据目录的位置。若指定目录中包含配置文件postgresql.conf，且配置文件内data_directory值与-D指定目录不同，将优先按data_directory目录执行。如果省略了-D选项，将使用环境变量PGDATA。
DATADIR的取值必须为有效的数据目录。
-s,  --silent 对reload、restart、stop命令仅打印部分提示信息，对其他命令不生效。打印信息如：server promoting、 server shutting down。不打印信息如：waiting for server to shut down、server stopped等提示信息。
-t, --timeout=SECS 等待数据库启动、关闭或者主备切换完成的最大秒数。如果等待超时，命令会结束退出，并通知不再等待。此后，可以通过gs_om -t status --detail或其他查看数据库状态的命令，来确认数据库是否启动、关闭或主备切换成功。
取值范围：整型（秒）。
默认值：等待数据库启动、停止或者主备切换完成：60秒。
-V , --version 打印gs_ctl的版本信息然后退出。
需要等待操作完成。
默认值：数据库启动、停止或重新启动时需要等待操作完成。
不用等待操作完成。
-M后面需要跟SERVERMODE参数，表示在启动时指定数据库的启动模式。
SERVERMODE的取值范围： primary：本端以主机模式启动。standby：本端以备机模式启动。cascade_standby：本端以级联备机模式启动。pending：本端处于等待状态，等待提升为主机或者备机。
-T 后面跟term，升主命令时会用此term作为主机term，build时会连接大于等于此term的主机进行build。
term的取值范围，无符号整型。
打印更多调试信息。
无参数 生成完成后不自动启动，需要调用者启动。
无参数 -P PASSWORD 与-U参数配合使用，指定连接本地数据库的用户密码。
-U USERNAME 指定连接数据库的用户。此参数只能与notify、query、failover、switchover和querybuild参数配合使用。
对于域用户，使用DOMAIN\username格式。
取值范围：openGauss中存在的用户。
默认值：省略此参数则使用与当前操作系统用户同名的用户。
-Z NODE-TYPE 参数可以设置为 "single_node"。
-?, -h, --help 显示关于gs_ctl命令行参数的帮助信息。

**表 3**  start或restart共有参数

参数说明 取值范围 -c, --core-file 允许gaussdb进程产生内核文件。
-l, --log=FILENAME 把服务器日志输出附加在FILENAME文件上。
FILENAME的取值为启动数据库服务的用户有权限的文件。
例如，data目录下的某文件。
-o OPTIONS 声明要直接传递给由openGauss执行的gaussdb的命令行选项。
参数通常都用单或者双引号包围以保证它们作为一个整体传递。
gaussdb支持的参数。
-p PATH-TO-POSTGRES 声明gaussdb可执行文件的位置。
缺省位于gs_ctl自身所在目录，一般不需要此选项。

**表 4**  stop和restart共有参数

参数说明 取值范围 -m, --mode=MODE 声明关闭模式。
mode的取值： fast：不等待客户端中断连接，所有活跃事务都被回滚并且客户端都被强制断开，然后服务器将被关闭。immediate：强行关闭，在下次重新启动的时候将导致故障恢复。
默认值：fast

**表 5**  switchover参数

参数说明 取值范围 不等待客户端中断连接，所有活跃事务都被回滚并且客户端都被强制断开，然后服务器将被切换，且不做checkpoint。
无参数 -m SWITCHOVER-MODE 声明双机主备实例正常时切换的切换模式。
mode的取值： fast：不等待客户端中断连接，所有活跃事务都被回滚并且客户端都被强制断开，然后服务器将被切换。smart：本版本暂不支持该模式。
默认值：fast

**表 6**   build参数

参数说明 取值范围 -b MODE 指定重建备机的模式。
mode的取值： full：通过全量镜像的方式重新同步 主机的数据目录。
incremental：通过解析Xlog日志获 取主备机差异的数据进行增量修复备机。
-  增量重建不适用于一主一备并且没有开启最大高可用的场景，此种场景下需要使用全量重建或者开启最大高可用后再进行增量重建。
- 备机数据文件损坏、数据目录丢失 等故障通过增量重建的方式无法修复，此时可通过全量重建的方式重 新修复备机。
auto（不指定）：先增量，根据失败 后是否可以再增量选择继续增量或 者全量，三次增量失败后进行全量。
standby_full：通过指定的备机ip和port全量重建故障备机。使用该参数时需要同时使用-C参数指定镜像的ip和port。
copy_secure_files：在流式容灾场景下，获取指定节点数据目录下gs_secure_files目录对应内容。
copy_upgrade_file：在dorado容灾场景下，获取指定节点下升级所需指定文件。
cross_cluster_full：在dorado容灾场景下，通过全量镜像的方式重新同步主机的数据目录。
cross_cluster_standby_full：在dorado容灾场景下，通过全量镜像的方式重新同步备机的数据目录。
cross_cluster_incremental：基于共享存储的同城双中心场景下的跨集群增量build。
check：检测是否需要build，如果需要，返回build的类型。
默认值：auto -r, --recvtimeout=INTERVAL 指定重建过程中备机日志接收等待主机响应的超时时间。
取值范围：整型（秒）。
默认值：120秒 提示：超时时间需根据业务繁忙程度设置，业务繁忙等待主机的响应时间需加长，建议超时时间=checkpoint的执行时间+1min。
重建结束后，是否自动重启。
指定参数场合，不自动重启。
未指定场合，自动重启，重启默认最大等待时间是60秒。如果在此时间内数据库未能启动成功，就会报不再等待，命令退出。此后可以通过gs_om -t status --detail或其他查看数据库状态的命令，来确认数据库是否启动成功。
无参数 -C CONNECTOR 到源端DN的连接串，通过连接源端DN进行本节点上DN的重建。只支持备机到备机的连接。
连接串包含本节点待重建DN的IP和端口和源端DN的IP和端口，格式如下： 'localhost=Local DN IP localport=Local DN Port+1 remotehost=DN IP remoteport=DN Port+1' --verify-commit 增量build时对备机已提交事务进行校验，如果备机与主机存在共同的checkpoint日志，但之后存在不同的提交数据，则为保证这部分数据不丢失，增量build失败，且不会转为全量build。
无参数

**表 7**  query参数

参数说明 取值范围 查询lsn并展示最大长度。
无参数 -D /PATH/TO/DATADIR 指定数据目录的位置，查询数据库状态，显示当前数据库的数据目录以及运行状态等信息。
DATADIR的取值必须为有效的数据目录 -U USERNAME 查询受密码保护的数据库集群，可以使用-U选项来指定用户名 取值范围：openGauss中存在的用户。
默认值：省略此参数则使用与当前操作系统用户同名的用户。
-P PASSWORD 查询受密码保护的数据库集群，可以使用-P选项来指定密码，一般与-U配合使用

**表 8**  member参数

参数说明 取值范围 -O, --operation openGauss数据库实例，DCF模式下，增删节点的操作。
add： 向数据库实例的DCF节点配置中增加一个节点。remove：从数据库实例DCF节点配置中删除一个节点。change：从数据库实例DCF节点配置中更改一个节点。
-u, --nodeid 新增节点的DCF NODE ID。
无符号整型。
-i, --ip 新增节点与数据库实例DCF模块通信的IP。
字符串。
-e, --port 新增节点与数据库实例DCF模块通信的port。
整型。
[-D, --pgdata=]DATADIR 指定数据目录的位置。若指定目录中包含配置文件postgresql.conf，且配置文件内data_directory值与-D指定目录不同，将优先按data_directory目录执行。
DATADIR的取值：用户自定义。
用于设置DCF中的组号。
整型。
--priority 用于设置DCF中的优先级。
整型。

**表 9**  changerole参数

参数说明 取值范围 -R, --role openGauss数据库实例，DCF模式下节点角色（需要在角色为primary的节点上使用）。
passive： passive角色。follower：follower角色。
-u, --nodeid 新增节点的DCF NODE ID。
无符号整型。
[-D, --pgdata=]DATADIR 指定数据目录的位置。若指定目录中包含配置文件postgresql.conf，且配置文件内data_directory值与-D指定目录不同，将优先按data_directory目录执行。
DATADIR的取值：用户自定义。

**表 10**  setrunmode参数

参数说明 取值范围 -v, --votenum 投票个数。
无符号整型。
-x, --xmode 运行模式（在少数派的DN节点上使用）。
minority：少数派强起。normal：加回。
[-D, --pgdata=]DATADIR 指定数据目录的位置。若指定目录中包含配置文件postgresql.conf，且配置文件内data_directory值与-D指定目录不同，将优先按data_directory目录执行。
DATADIR的取值：用户自定义。

**表 11**  stack参数

参数说明 取值范围 用于指定需要获取调用栈的线程的lwtid。
正整数。

**表 12**  copy参数

参数说明 取值范围 指定xlog日志拷贝方向。
copy_from_local：从本地往共享存储上拷贝。
copy_from_share：从共享存储往本地存储上拷贝。
force_copy_from_local：强制从本地往共享存储上拷贝。

**表 13**  资源池化build参数

参数说明 取值范围 -b MODE 指定重建备机的模式。
mode的取值： cross_cluster_full：资源池化执行build，必须结合dorado容灾场景，该参数表示在dorado容灾场景下通过全量镜像的方式重新同步主机的数据目录。
check：判断是否需要build 提示：资源池化build只适用于主备集群间的跨集群build，不能用于资源池化单集群内的主备实例build。
重建结束后，是否自动重启。
指定参数场合，不自动重启。
未指定场合，自动重启，重启默认最大等待时间是60秒。如果在此时间内数据库未能启动成功，就会报不再等待，命令退出。此后可以通过gs_om -t status --detail或其他查看数据库状态的命令，来确认数据库是否启动成功。
无参数 --enable-dss 开启资源池化开关。
无参数 开启资源池化，指定节点做build。
取值范围：整型，[0-63]，需要从0开始 默认值：0 提示：-g入参参数是指资源池化节点id参数ss_instance_id --instance-id=instance_id 启用dss和dms时，实例的ID号。
正整数。
--vgname 卷组名。
数据类型：字符串 。
例如：一个卷组“+data”或者两个卷组中间用“，”连接“+data,+log”。
--socketpath=socketpath dss实例进程使用的socket文件路径。
dss实例进程使用的socket文件路径。
