# gs_check

## 背景信息

gs_check改进增强，统一化当前系统中存在的各种检查工具，例如[gs_check](gs_check.md)、[gs_checkos](gs_checkos.md)等，帮助用户在openGauss运行过程中，全量的检查openGauss运行环境、操作系统环境、网络环境及数据库执行环境，也有助于在openGauss重大操作之前对各类环境进行全面检查，有效保证操作执行成功。

## 注意事项

- 必须指定-i或-e参数，-i会检查指定的单项，-e会检查对应场景配置中的多项。
- 如果-i参数中不包含root类检查项或-e场景配置列表中没有root类检查项，则不需要交互输入root权限的用户及其密码。
- 可使用--skip-root-items跳过检查项中包含的root类检查，以免需要输入root权限用户及密码。
- MTU值不一致时可能导致检查缓慢或进程停止响应，当巡检工具出现提示时请修改各节点MTU值一致后再进行巡检。
- 交换机不支持当前设置的MTU值时，即使MTU值一致也会出现通信问题引起进程停止响应，需要根据交换机调整MTU大小。

## 语法

- 单项检查：

    ```
    gs_check -i ITEM [...] [-U USER] [-L] [-l LOGFILE] [-o OUTPUTDIR] [--skip-root-items][--set][--routing]
    ```

- 场景检查：

    ```
    gs_check -e SCENE_NAME [-U USER] [-L] [-l LOGFILE] [-o OUTPUTDIR] [--skip-root-items] [--time-out=SECS][--set][--routing][--skip-items]
    ```

- 显示帮助信息：

    ```
    gs_check -? | --help
    ```

- 显示版本号信息：

    ```
    gs_check -V | --version
    ```

## 参数说明

- -U

运行openGauss的用户名称。

取值范围：运行openGauss的用户名称。

- -L

本地执行。

- -i

指定检查项。格式-i CheckXX详细的检查项请参见[表1 openGauss状态检查表](#zh-cn_topic_0237152330_zh-cn_topic_0059777799_t48caf3ebc47a4dce88ed8b7132976edd)。

- -e

场景检查项。默认的场景有inspect（例行巡检）、upgrade（升级前巡检）、binary\_upgrade（就地升级前巡检）、health（健康检查巡检）、install（安装）等，用户可以根据需求自己编写场景。

- -l

指定日志文件路径，指定路径时需添加.log后缀。

- -o

指定检查结果输出文件夹路径。

- --skip-root-items

跳过需要root权限执行的检查项。

- --skip-items

跳过指定的检查项。

- --format

设置结果报告的格式。

- --set

修复支持设置的Abnormal项。

- --cid

检查ID，仅被内部check进程使用。

- --time-out

设置超时时间。单位为秒，默认为1500s，若用户自定义超时时间不得少于1500s。

- --routing

指定业务IP的网段，格式为IP地址:子网掩码。

- --disk-threshold="PERCENT"

检查磁盘占用时可选指定告警阈值，可指定1-99之间的整数，不输入则默认为90。检查其他项时不需要该参数。

- -?, --help

显示帮助信息。

- -V, --version

显示版本号信息。

**表 1**  openGauss状态检查表

巡检项 检查内容 是否支持--set CheckCPU（检查CPU使用率） 检查主机CPU占用率，如果idle大于30%并且iowait小于30%。则检查项通过，否则检查项不通过。
CheckFirewall（检查防火墙状态） 检查主机防火墙状态，如果防火墙关闭则检查项通过，否则检查项不通过。
CheckTimeZone（检查时区一致性） 检查openGauss内各节点时区，如果时区一致则检查通过，否则检查项不通过。
CheckSysParams（检查系统参数） 检查各节点操作系统参数，判断是否等于预期值。检查项不满足warning域则报warning，不满足NG域则检查项不通过，并打印不满足项。
详见操作系统参数。
CheckOSVer（检查操作系统版本） 检查openGauss内各个节点的操作系统版本信息，如果满足版本兼容列表且openGauss在同一混搭列表中则检查通过，否则检查不通过。
CheckNTPD（检查NTPD服务） 检查系统NTPD服务，如果服务开启且各节点时间误差在5分钟以内则检查项通过，否则检查项不通过。
CheckTHP(检查THP服务) 检查系统THP服务，如果服务开启则检查项通过，否则检查项不通过。
CheckSshdService(检查sshd服务是否已启动) 检查系统是否存在sshd服务，若存在则检查项通过，否则检查项不通过。
CheckCrondService(检查crontab服务是否已启动) 检查系统是否存在crontab服务，若存在则检查项通过，否则检查项不通过。
CheckCrontabLeft(检查crontab是否有残留Gauss相关信息) 检查crontab是否残留Gauss相关信息，若无该信息则检查项通过，否则检查项不通过。
CheckDirLeft(检查文件目录是否有残留) 检查文件目录（/opt/huawei/Bigdata/ ,/var/log/Bigdata/, /home/omm）是否存在，（若mount目录包含此目录则忽略）若不存在则查项通过，否则检查项不通过。
CheckProcessLeft(检查进程是否有残留) 检查是否残留gaussdb和omm进程，若未残留则检查项通过，否则检查项不通过。
CheckStack(栈深度检查) 检查栈深度，若各个节点不一致则报warning ，若大于等于3072则检查项通过，否则不通过。
CheckOmmUserExist(检查omm用户是否存在) 检查是否存在omm用户，若不存在omm用户则检查项通过，否则检查项不通过。
CheckPortConflict(检查数据库节点端口是否占用) 检查数据库节点端口是否已被占用，若未占用则检查项通过，否则检查项不通过。
CheckSysPortRange（检查ip_local_port_range设置范围） 检查ip_local_port_range系统参数范围，若范围在26000~65535则检查项通过，否则检查项不通过。
CheckEtcHosts（检查/etc/hosts中是否有重复地址以及localhost配置） 检查/etc/hosts没有配置localhost检查项不通过，存在带有#openGauss注释的映射则检查项不通过，相同IP不同hostname则检查项不通过，否则通过，若hostname相同，但ip不同检查项不通过。
CheckCpuCount（检查CPU核数） 检查CPU核心与可用CPU不符检查项不通过，相符但存在不可用信息Warning。 所有节点CPU信息不相同检查项不通过。
CheckHyperThread（检查超线程是否打开） 检查超线程，若打开则检查项通过，否则检查项不通过。
CheckMemInfo（检查内存总大小） 检查各节点总内存大小是否一致，若检查结果一致，则检查项通过，否则报warning。
CheckSshdConfig（检查sshd服务配置是否正确） 检查/etc/ssh/sshd_config文件， (a)PasswordAuthentication=yes;
(b)MaxStartups=1000;
(c)UseDNS=no;
(d)ClientAliveInterval大于10800或者等于0 配置如上所示则检查项通过，若a、c配置不正确则报warning，b、d配置不正确则检查项不通过。
CheckMaxHandle（检查句柄最大设置） 检查操作系统最大句柄值，如果该值大于等于1000000则检查项通过，否则检查项不通过。
CheckKernelVer（检查内核版本） 检查各节点系统内核版本信息，如果版本信息一致则检查项通过，否则不通过。
CheckEncoding（检查编码格式） 检查openGauss内各个节点的系统编码，如果编码一致则检查项通过，否则检查项不通过。
CheckBootItems（检查启动项） 检查是否有手动添加的启动项，如果没有则检查通过，否则检查不通过。
CheckFilehandle（检查文件句柄） 此检查项检查以下两项，两项都通过为通过，否则为不通过： 检查每个gaussdb进程打开的进程数是否超过80万，不超过则检查通过，否则检查不通过。检查是否有slave进程使用的句柄数超过master进程，如果没有则检查通过，否则检查不通过。
CheckKeyProAdj（检查关键进程omm_adj的值） 检查所有关键进程，如果所有关键进程的omm_adj值不小于0，则通过，否则不通过。
CheckMaxProcMemory（检查max_process_memory参数设置是否合理） 检查数据库节点的max_process_memory值，判断该参数的值是否大于1G，若不大于则检查项通过，否则检查项不通过。
device CheckSwapMemory（检查交换内存） 检查交换内存和总内存大小，若检查结果为0则检查项通过，否则检查项报Warning大于总内存时检查项不通过。
CheckLogicalBlock（检查磁盘逻辑块） 检查磁盘逻辑块大小，若为512则检查项通过，否则检查项不通过。
CheckIOrequestqueue（检查IO请求） 检查IO值，如果该值为32768则检查项通过，否则检查项不通过。
CheckMaxAsyIOrequests（检查最大异步IO请求） 获取当前异步IO请求值，当前异步IO请求值大于当前节点数据库实例数*1048576和104857600则检查项通过，否则检查项不通过。
CheckIOConfigure（检查IO配置） 检查IO配置，如果是deadline则检查项通过，否则检查项不通过。
CheckBlockdev（检查磁盘预读块） 检查磁盘预读块大小，如果预读块大小为16384则检查项通过，否则检查项不通过。
CheckDiskFormat（检查磁盘格式参数） 检查磁盘XFS格式信息，如果配置为'inode64'则检查项通过，否则报warning；如果节点上无XFS格式硬盘，检查时提示相应信息。
CheckInodeUsage（检查磁盘inodes使用率） openGauss路径（GAUSSHOME/PGHOST/GPHOME/GAUSSLOG/tmp及实例目录） 检查以上指定目录使用率，如果使用率超过warning阈值（默认为60%） 报warning超过NG阈值（默认为80%）则检查项不通过，否则通过。
CheckSpaceUsage（检查磁盘使用率） openGauss路径（GAUSSHOME/PGHOST/GPHOME/GAUSSLOG/tmp及实例目录） 检查磁盘以上指定目录（目录列表）使用率，如果使用率超过warning阈值（默认为70%） 报warning超过NG阈值（默认为90%）则检查项不通过。openGauss路径下检查GAUSSHOME/PGHOST/GPHOME/GAUSSLOG/tmp/data路径的剩余空间，不满足阈值则检查项不通过，否则通过。
CheckDiskConfig（检查磁盘空间大小一致性） 检查磁盘名大小挂载点是否一致，若一致则检查项通过，否则报warning。
CheckXid（检查CheckXid数值） 查询xid的数值，如果大于10亿报Warning，大于18亿则检查项不通过。
CheckSysTabSize（检查每个实例的系统表容量） 如果每一块磁盘的剩余容量大于该磁盘上所有实例的系统表容量总和则检查项通过，否则检查项不通过。
cluster CheckClusterState（检查openGauss状态） 检查fencedUDF状态，如果fencedUDF状态为down则报warning；检查openGauss状态，如果openGauss状态为Normal则检查项通过，否则检查项不通过。
CheckDBParams（检查openGauss参数） 检查数据库主节点检查共享缓冲区大小和Sem参数。
数据库节点检查共享缓冲区大小和最大连接数。
共享缓冲区需要大于128KB且大于shmmax且大于shmall*PAGESIZE 若存在数据库主节点，则Sem值需大于(数据库节点最大连接数+150)/16向上取整。
以上项完全满足则检查项通过，否则检查项不通过。
CheckDebugSwitch（检查日志级别） 在各节点检查各实例的配置文件中log_min_messages参数的值，为空则认为是Warning，判断日志级别非waring，则报warning。
CheckUpVer（检查升级版本是否一致） 检查openGauss各个节点上升级包的版本，如果一致则检查项通过，否则检查项不通过。使用时，需指定升级软件包路径。
CheckDirPermissions（检查目录权限） 检查节点目录（实例Xlog路径、GAUSSHOME、GPHOME、PGHOST、GAUSSLOG）权限，如果目录有写入权限且不大于750则检查项通过，否则检查项不通过。
CheckEnvProfile（检查环境变量） 检查节点环境变量（$GAUSSHOME、$LD_LIBRARY_PATH、$PATH），检查CMS/CMA/数据库节点进程的环境变量。如果环境变量存在并配置正确，进程的环境变量存在则检查项通过，否则检查项不通过。
CheckGaussVer（检查gaussdb版本） 检查各个节点gaussdb版本是否一致，如果版本一致则检查项通过，否则检查项不通过。
CheckPortRange（检查端口范围） 若ip_local_port_range的范围在阈值范围内（默认是26000 65535），并且实例端口不在ip_local_port_range范围内则检查项通过，否则检查项不通过。
CheckReadonlyMode（检查只读模式） 检查openGauss数据库主节点default_transaction_read_only值若为off则检查通过，否则不通过。
CheckCatchup（检查Catchup） 检查gaussdb进程堆栈是否能搜索到CatchupMain函数，若搜索不到则检查项通过，否则检查项不通过。
CheckProcessStatus（检查openGauss进程属主） 检查  'gaussdb'进程属主，若不存在omm以外的属主则检查项通过，否则检查项不通过。
CheckSpecialFile（特殊文件检查） 检查tmp目录(PGHOST)、OM目录(GPHOME)、日志目录(GAUSSLOG)、data目录、程序目录(GAUSSHOME)下文件是否存在特殊字符以及非omm用户的文件，若不存在则检查项通过，否则检查项不通过。
CheckCollector（检查openGauss的信息收集） 在output目录下查看信息收集是否成功，若收集成功则检查项通过，否则检查项不通过。
CheckLargeFile（检查数据目录大文件） 检查各个数据库节点目录是否存在超过4G的文件。任一数据库节点目录及其子目录有超过4G的单个文件，则检查不通过，否则检查通过。
CheckProStartTime（关键进程启动时间检测） 检查关键进程启动时间是否间隔超过5分钟，超过则检查不通过，否则检查通过。
CheckDilateSysTab（检查系统表膨胀） 检查系统表是否膨胀，若膨胀则不通过，否则检查通过。
CheckMpprcFile（检测环境变量分离文件改动） 检查是否存在对环境变量分离文件的改动，若存在则检查不通过，否则检查通过。
database CheckLockNum（检查锁数量） 检查数据库锁数量，查询成功检查项通过。
CheckArchiveParameter（检查归档参数） 检查数据库归档参数，如果未打开或打开且在数据库节点下则检查项通过， 打开且不在数据库主节点目录下则检查项不通过。
CheckCurConnCount(检查当前连接数) 检查数据库连接数，如果连接数大于0并且小于最大连接数的90%则检查项通过，否则检查项不通过。
CheckCursorNum(检查当前游标数) 检查数据库的游标数，检查成功则检查项通过，否则检查项不通过。
CheckMaxDatanode(检查comm_max_datanode参数值范围小于数据库节点个数) 检查最大数据库节点数，若最大数据库节点数小于xml配置的节点数*数据库节点数（默认值为90*5）报warning，否则检查项通过。
CheckPgPreparedXacts(检查残留两阶段事务) 检查pgxc_prepared_xacts参数，如果不存在二阶段事务则检查项通过，否则检查项不通过。
CheckPgxcgroup(检查pgxc_group表中需要重分布的个数) 检查pgxc_group表中需要重分布的个数，检查结果为0则通过， 否则不通过。
CheckLockState(openGauss是否被锁) 检查openGauss是否被锁，若openGauss被锁则不通过，否则检查项通过。
CheckIdleSession(检查业务停止) 检查非空闲会话数，如果数量为0则检查项通过，否则检查项不通过。
CheckDBConnection(检查数据库连接) 检查能否连接数据库，如果连接成功则检查项通过，否则检查项不通过。
CheckGUCValue(GUC参数检查) 检查(max_connections + max_prepared_transactions) * max_locks_per_transaction的值，若该值大于等于1000000则检查项通过，否则检查项不通过。
CheckGUCConsistent(检查GUC参数一致性) 检查数据库节点实例GUC参数的值是否一致，一致则检查项通过，否则检查项不通过。
CheckPMKData(检查PMK异常数据) 检查数据库PMK schema是否包含有异常数据，如果不存在异常数据则检查项通过，否则检查项不通过。
CheckSysTable(检查系统表) 检查系统表，检查成功则检查项通过。
CheckSysTabSize（检查每个实例的系统表容量） 如果每一块磁盘的剩余容量大于该磁盘上所有实例的系统表容量总和则检查项通过，否则检查项不通过。
CheckTableSpace(检查表空间路径) 表空间路径和openGauss路径之间不能存在嵌套且表空间路径相互不能存在嵌套，则检查项通过，否则检查项不通过。
CheckTableSkew（检查表级别数据倾斜） 若存在表在openGauss各数据库节点上的数据分布不均衡，且分布数据最多的数据库节点比最低的数据库节点所分布的数据多100000条以上，则检查不通过，否则检查通过。
CheckDNSkew（检查数据库节点级别数据分布倾斜） 检查数据库节点级别的表倾斜数据，若分布数据最高的数据库节点比分布数据最低的数据库节点数据量高于5%，则检查不通过，否则检查通过。
CheckUnAnalyzeTable（检查未做analyze的表） 若存在未做analyze的表，并且表中至少包含一条数据，则检查不通过，否则检查通过。
CheckCreateView（创建视图检查） 创建视图时，如果查询语句中含有子查询，并且子查询结果查询解析和重写之后存在别名重复，检查不通过，否则检查通过。
CheckHashIndex（hash index语法检查） 如果存在hash index则检查不通过，否则检查通过。
CheckNextvalInDefault（检查Default表达式中包含nextval（sequence）） 检查Default表达式中是否包含nextval(sequence)，若包含则不通过，否则通过。
CheckNodeGroupName（Node group编码格式检查） 存在非SQL_ASCII字符的Node Group名称则检查不通过，不存在则检查通过 。
CheckPgxcRedistb（检查重分布残留的临时表 ） 检查数据库中是否存在重分布残留的临时表，若不存在则检查通过，否则检查不通过 。
CheckReturnType（用户自定义函数返回值类型检查） 检查用户自定义函数是否包含非法返回类型，若包含则检查不通过，否则检查通过。
CheckSysadminUser（检查sysadmin用户） 检查除openGauss属主外是否存在数据库管理员用户，若存在则不通过，否则检查通过。
CheckTDDate（TD数据库中orc表date类型列检查） 检查TD模式数据库下的orc表中是否包含date类型的列，若包含检查不通过，否则检查通过。
CheckDropColumn（drop column检查） 如果存在drop column的表，则检查不通过，否则检查通过。
CheckDiskFailure（检查磁盘故障） 对openGauss中的所有数据做全量查询，若存在查询错误则检查不通过，否则检查通过。
network CheckPing(检查网络通畅) 检查openGauss内所有节点的互通性，如果各节点所有IP均可ping通则检查项通过，否则检查项不通过。
CheckRXTX(检查网卡RXTX值) 检查节点backIP的RX/TX值，如果该值为4096则检查项通过，否则检查项不通过。
CheckMTU(检查网卡MTU值) 检查节点backIP对应的网卡MTU值（ bond后的物理网卡要确保一致），如果该值不是8192或1500报warning若openGaussMTU值一致则检查项通过，否则检查项不通过。
CheckNetWorkDrop(检查网络掉包率) 检查各IP1分钟内网络掉包率，如果不超过1%则检查项通过，否则检查项不通过。
CheckBond(检查网卡绑定模式) 检查是否有配置BONDING_OPTS或BONDING_MODULE_OPTS，若没有配置则报warning。检查各节点bond模式是否一致，如果同时满足则检查项通过，否则检查项不通过。
CheckMultiQueue(检查网卡多队列) 检查cat /proc/interrupts，判断是否开启网卡多队列且绑定不同CPU，如果满足则检查项通过，否则检查项不通过。
CheckUsedPort(检查随机端口使用数量) 检查net.ipv4.ip_local_port_range，范围大于等于OS默认值通过（32768-61000）;
检查TCP协议随机端口数，小于总随机端口数的80%通过。
CheckNICModel（网卡型号和驱动版本一致性检查） 检查各个节点的网卡型号以及驱动版本是否一致，一致则通过，否则报warning。
CheckRouting（本地路由表检查） 检查各节点在业务IP网段的IP个数，超过1个则报warning，否则检查通过。
CheckNetSpeed(检查网卡接收带宽，ping值，丢包率) 网络满载时，检查网卡平均接收带宽大于600MB通过;
网络满载时，检查网络ping值，小于1秒通过;
网络满载时，检查网卡丢包率，小于1%通过。
other CheckDataDiskUsage(检查数据库节点磁盘空间使用率) 检查磁盘数据库节点目录使用率，如果使用率低于90%则检查项通过，否则检查项不通过。

>[!NOTE]说明
>CheckNetSpeed检查项：
>
>- CheckNetSpeed不支持-L本地检查模式，-L模式无法构造网络压力，检查的结果不准确。
>- 在节点数小于6时，speed\_test构造的网络压力可能无法跑满带宽，可能会造成检查结果不准确。

## 用户自定义场景

1. 以操作系统用户omm登录数据库主节点。
2. 在script/gspylib/inspection/config路径下新建场景配置文件scene\_XXX.xml。
3. 将检查项写进场景配置文件中，书写格式为：

    ```
    ```

item name为检查项名称

注：用户需自行保证自定义xml的正确性

4. 在home/package/script/gspylib/inspection/config执行如下命令，将此文件分发至执行检查的各个节点

    ```
    scp scene_upgrade.xml SIA1000068994：home/package/script/gspylib/inspection/config/
    ```

>[!NOTE]说明
>
>home/package/script/gspylib/inspection/config就是新建的场景配置文件的绝对路径。

5. 换至omm用户，执行以下命令查看检查结果。

    ```
    gs_check  -e XXX
    ```

## 用户自定义检查项

1. 新增巡检项配置，修改script/gspylib/inspection/config/items.xml文件，格式如下：

    ```
检查CPU占用率
Check CPU Idle and I/O wait
    StandardCPUIdle=30;
    StandardWIO=30
如果idle不足 CPU负载过高，请扩容CPU节点，如果iowait过高，则磁盘为瓶颈，更换高性能磁盘
检查主机CPU占用率，如果idle大于30%并且iowait小于30%，则检查项通过，否则检查项不通过
user
all
default
    ```

  - id：巡检项id。
  - name：巡检项脚本名， 和巡检项脚本文件名相同。
  - title: 巡检项描述名称 （支持多语言）。

：中文版检查内容。

：英文版检查内容。

  - standard：巡检项标准说明（支持多语言）。
  - suggestion： 巡检项修复建议说明（支持多语言）。
  - threshold：巡检项阈值定义，多值之间使用分号隔开，示例Key1=Value1;Key2=Value2。
  - category： 巡检项分类，可选参数：os，device，network，cluster，database，other。
  - permission： 巡检项需要的执行权限，可选参数：root，user默认为user（普通用户）。
  - scope：巡检项执行的节点范围，可选参数：cn-仅在数据库主节点执行，local-仅在当前节点执行，all-在openGauss所有节点执行，默认为all。
  - analysis：巡检项执行结果分析方式，default-检查每个节点的结果，所有节点检查项通过，则最终检查通过，consistent-openGauss内所有节点一致性检查，单节点仅返回结果，各个节点结果一致则判定检查通过，custom-自定义结果分析方式，默认为default。

注：用户需保证自定义xml的正确性

2. 新建检查脚本，脚本名称格式遵循CheckXXXX.py，必须以Check开头，脚本放置在script/gspylib/inspection/items目录下，该目录下脚本安装巡检项分类组织，每个分类一个单独的文件夹，巡检项脚本放置在对应的分类文件夹中。格式如下：

    ```
    class CheckCPU(BaseItem):
    def __init__(self):
    super(CheckCPU, self).__init__(self.__class__.__name__)
    self.idle = None
    self.wio = None
    self.standard = None

    def preCheck(self):
    # check the threshold was set correctly
    if (not self.threshold.has_key('StandardCPUIdle')
    or not self.threshold.has_key('StandardWIO')):
    raise Exception("threshold can not be empty")
    self.idle = self.threshold['StandardCPUIdle']
    self.wio = self.threshold['StandardWIO']

    # format the standard by threshold
    self.standard = self.standard.format(idle=self.idle, iowait=self.wio)

    def doCheck(self):
    cmd = "sar 1 5 2>&1"
    output = SharedFuncs.runShellCmd(cmd)
    self.result.raw = output
    # check the result with threshold
    d = next(n.split() for n in output.splitlines() if "Average" in n)
    iowait = d[-3]
    idle = d[-1]
    rst = ResultStatus.OK
    vals = []
    if (iowait > self.wio):
    rst = ResultStatus.NG
    vals.append("The %s actual value %s is greater than expected value %s" % ("IOWait", iowait, self.wio))
    if (idle < self.idle):
    rst = ResultStatus.NG
    vals.append("The %s actual value %s is less than expected value %s" % ("Idle", idle, self.idle))
    self.result.rst = rst
    if (vals):
    self.result.val = "\n".join(vals)
    ```

所有脚本基于BaseItem基类开发，基类定义的通用的检查流程，通用的检查结果分析方法，默认的结果输出格式。可扩展方法：

  - doCheck:  该方法包含该检查项具体的检查方法，检查结果格式如下：

result.rst ---   检查结果状态，可选参数:

  - OK – 检查项完成，结果通过。
  - NA – 当前节点不涉及该检查项。
  - NG – 检查项完成，结果不通过。
  - WARNING – 检查项完成，结果警告。
  - ERROR – 检查项发生内部错误，未完成检查。

  - preCheck: 检查前条件判定，内置两种实现：cnPreCheck – 用于检查当前执行节点是否包含数据库主节点实例，localPreCheck – 用于检查当前执行节点是否指定节点。可通过巡检项配置文件中的scope参数进行配置。 可重载该方法实现自定义的前置检查
  - postAnalysis：检查结果分析方法，内置两种实现：default、consistent。可通过巡检项配置文件中的analysis参数进行配置。可重载该方法实现自定义的结果分析。

注：用户自定义的检查项名称不得与已有检查项名称相同，同时用户需保证自定义检查项脚本的规范性。

3. 将此脚本分发至所有的执行节点。
4. 以omm用户登录，执行以下命令，查看结果。

本地执行：

    ```
    gs_check -i CheckXXX  -L
    ```

非本地执行：

    ```
    gs_check  -i  CheckXXX
    ```

## 操作系统参数

**表 2**  操作系统参数

参数名称 参数说明 推荐取值 net.ipv4.tcp_max_tw_buckets 表示同时保持TIME_WAIT状态的TCP/IP连接最大数量。如果超过所配置的取值，TIME_WAIT将立刻被释放并打印警告信息。
10000 net.ipv4.tcp_tw_reuse 允许将TIME-WAIT状态的sockets重新用于新的TCP连接。
0表示关闭。1表示开启。
net.ipv4.tcp_tw_recycle 表示开启TCP连接中TIME-WAIT状态sockets的快速回收。
0表示关闭。1表示开启。
net.ipv4.tcp_keepalive_time 表示当keepalive启用的时候，TCP发送keepalive消息的频度。
net.ipv4.tcp_keepalive_probes 在认定连接失效之前，发送TCP的keepalive探测包数量。这个值乘以tcp_keepalive_intvl之后决定了一个连接发送了keepalive之后可以有多少时间没有回应。
net.ipv4.tcp_keepalive_intvl 当探测没有确认时，重新发送探测的频度。
net.ipv4.tcp_retries1 在连接建立过程中TCP协议最大重试次数。
net.ipv4.tcp_syn_retries TCP协议SYN报文最大重试次数。
net.ipv4.tcp_synack_retries TCP协议SYN应答报文最大重试次数。
net.ipv4.tcp_retries2 控制内核向已经建立连接的远程主机重新发送数据的次数，低值可以更早的检测到与远程主机失效的连接，因此服务器可以更快的释放该连接。
发生“connection reset by peer”时可以尝试调大该值规避问题。
vm.overcommit_memory 控制在做内存分配的时候，内核的检查方式。
0：表示系统会尽量精确计算当前可用的内存。1：表示不作检查直接返回成功。2：内存总量×vm.overcommit_ratio/100＋SWAP的总量，如果申请空间超过此数值则返回失败。
内核默认是2过于保守，推荐设置为0，如果系统压力大可以设置为1。
net.ipv4.tcp_rmem TCP协议接收端缓冲区的可用内存大小。分无压力、有压力、和压力大三个区间，单位为页面。
8192 250000 16777216 net.ipv4.tcp_wmem TCP协议发送端缓冲区的可用内存大小。分无压力、有压力、和压力大三个区间，单位为页面。
8192 250000 16777216 net.core.wmem_max socket发送端缓冲区大小的最大值。
21299200 net.core.rmem_max socket接收端缓冲区大小的最大值。
21299200 net.core.wmem_default socket发送端缓冲区大小的默认值。
21299200 net.core.rmem_default socket接收端缓冲区大小的默认值。
21299200 net.ipv4.ip_local_port_range 物理机可用临时端口范围。
26000-65535 kernel.sem 内核信号量参数设置大小。
250 6400000 1000 25600 vm.min_free_kbytes 保证物理内存有足够空闲空间，防止突发性换页。
系统总内存的5% net.core.somaxconn 定义了系统中每一个端口最大的监听队列的长度，这是个全局的参数。
65535 net.ipv4.tcp_syncookies 当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击。
0表示关闭SYN Cookies。1表示开启SYN Cookies。
net.core.netdev_max_backlog 在每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目。
65535 net.ipv4.tcp_max_syn_backlog 记录的那些尚未收到客户端确认信息的连接请求的最大值。
65535 net.ipv4.tcp_fin_timeout 系统默认的超时时间。
kernel.shmall 内核可用的共享内存总量。
1152921504606846720 kernel.shmmax 内核参数定义单个共享内存段的最大值。
18446744073709551615 net.ipv4.tcp_sack 启用有选择的应答，通过有选择地应答乱序接受到的报文来提高性能，让发送者只发送丢失的报文段（对于广域网来说）这个选项应该启用，但是会增加对CPU的占用。
0表示关闭。1表示开启。
net.ipv4.tcp_timestamps TCP时间戳（会在TCP包头增加12节），以一种比重发超时更精确的方式（参考RFC 1323）来启用对RTT的计算，启用可以实现更好的性能。
0表示关闭。1表示开启。
vm.extfrag_threshold 系统内存不够用时，linux会为当前系统内存碎片情况打分，如果超过vm.extfrag_threshold的值，kswapd就会触发memory compaction。所以这个值设置的接近1000，说明系统在内存碎片的处理倾向于把旧的页换出，以符合申请的需要，而设置接近0，表示系统在内存碎片的处理倾向做memory compaction。
500 vm.overcommit_ratio 系统使用绝不过量使用内存的算法时，系统整个内存地址空间不得超过swap+RAM值的此参数百分比，当vm.overcommit_memory=2时此参数生效。
MTU 节点网卡最大传输单元。OS默认值为1500，调整为8192可以提升SCTP协议数据收发的性能。
8192

## 文件系统参数

- soft nofile

说明：soft nofile表示软限制，用户使用的文件句柄数量可以超过该限制，但是如果超过会有告警信息。

推荐取值：1000000

- hard nofile

说明：hard nofile表示硬限制，是一个严格的限制，用户使用的文件句柄数量一定不能超过该设置。

推荐取值：1000000

- stack size

说明：线程堆栈大小。

推荐值：3072

## 示例

执行单项检查结果：

```
perfadm@lfgp000700749:/opt/huawei/perfadm/tool/script> gs_check -i CheckCPU
Parsing the check items config file successfully
Distribute the context file to remote hosts successfully
Start to health check for the cluster. Total Items:1 Nodes:3

Checking...               [=========================] 1/1
Start to analysis the check result
CheckCPU....................................OK
The item run on 3 nodes.  success: 3

Success. All check items run completed. Total:1  Success:1  Failed:0
For more information please refer to /opt/huawei/wisequery/script/gspylib/inspection/output/CheckReport_201902193704661604.tar.gz
```

本地执行结果：

```
perfadm@lfgp000700749:/opt/huawei/perfadm/tool/script> gs_check -i CheckCPU -L

2017-12-29 17:09:29 [NAM] CheckCPU
2017-12-29 17:09:29 [STD] 检查主机CPU占用率，如果idle 大于30%并且iowait 小于 30%.则检查项通过，否则检查项不通过
2017-12-29 17:09:29 [RST] OK

2017-12-29 17:09:29 [RAW]
Linux 4.4.21-69-default (lfgp000700749)  12/29/17  _x86_64_

17:09:24        CPU     %user     %nice   %system   %iowait    %steal     %idle
17:09:25        all      0.25      0.00      0.25      0.00      0.00     99.50
17:09:26        all      0.25      0.00      0.13      0.00      0.00     99.62
17:09:27        all      0.25      0.00      0.25      0.13      0.00     99.37
17:09:28        all      0.38      0.00      0.25      0.00      0.13     99.25
17:09:29        all      1.00      0.00      0.88      0.00      0.00     98.12
Average:        all      0.43      0.00      0.35      0.03      0.03     99.17
```

执行场景检查结果：

```
[perfadm@SIA1000131072 Check]$ gs_check -e inspect
Parsing the check items config file successfully
The below items require root privileges to execute:[CheckBlockdev CheckIOConfigure CheckMTU CheckRXTX CheckMultiQueue CheckFirewall CheckSshdService CheckSshdConfig CheckCrondService CheckMaxProcMemory CheckBootItems CheckFilehandle CheckNICModel ]
Please enter root privileges user[root]:
Please enter password for user[root]:
Check root password connection successfully
Distribute the context file to remote hosts successfully
Start to health check for the cluster. Total Items:57 Nodes:3
Checking...               [=========================] 57/57
Start to analysis the check result
CheckClusterState...........................OK
The item run on 3 nodes.  success: 3
CheckDBParams...............................OK
.........................................................................
CheckMpprcFile..............................OK
The item run on 3 nodes.  success: 3

Analysis the check result successfully
Failed. All check items run completed. Total:57   Success:49   Warning:5   NG:3   Error:0
For more information please refer to /opt/huawei/wisequery/script/gspylib/inspection/output/CheckReport_inspect_201902207129254785.tar.gz
```

## 相关命令

[gs\_checkos](gs_checkos.md)，[gs\_checkperf](gs_checkperf.md)
