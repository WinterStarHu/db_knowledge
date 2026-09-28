# gs\_collector

## 背景信息

当openGauss发生故障时，使用此工具收集OS信息、日志信息以及配置文件等信息，来定位问题。可以使用-C参数，指定收集不同的信息内容，具体支持收集的内容信息如[表1](#zh-cn_topic_0237152334_table18101312318)所示。

**表 1**  gs\_collector内容收集对照表

name="zh-cn_topic_0237152334_p171112382318">TypeName name="zh-cn_topic_0237152334_p21183192318">Content name="zh-cn_topic_0237152334_p21116316232">描述 name="zh-cn_topic_0237152334_p12111832231">是否默认收集 name="zh-cn_topic_0237152334_p121114320238">System name="zh-cn_topic_0237152334_p9173483258">HardWareInfo name="zh-cn_topic_0237152334_p6181348172513">RunTimeInfo

name="zh-cn_topic_0237152334_p11283122310">是 name="zh-cn_topic_0237152334_p111263102314">Database name="zh-cn_topic_0237152334_p103186476250">具体列表见<a href="system_catalogs_and_views_supported_by_gs_collector.md#zh-cn_topic_0237637502_table15624104912196">表1。
name="zh-cn_topic_0237152334_p127501419122615">收集系统视图或者系统表的内容。
name="zh-cn_topic_0237152334_p022210297269">是，默认收集pg_locks、pg_stat_activity和 pg_thread_wait_status三个视图的信息。
name="zh-cn_topic_0237152334_p6133313233">Log name="zh-cn_topic_0237152334_p8657174819262">DataNode name="zh-cn_topic_0237152334_p46574483267">ClusterManager name="zh-cn_topic_0237152334_p46574483267">DSS name="zh-cn_topic_0237152334_ul122531334158"><a name="zh-cn_topic_0237152334_ul122531334158"> 收集DataNode的pg_log和gs_profile 收集ClusterManager的日志信息包括：<a name="zh-cn_topic_0237152334_ul19311954111513"> gs_ctl gs_guc gs_initdb 收集资源池化日志信息包括：<a name="zh-cn_topic_0237152334_ul19311954111513"> $DSS_HOME/log pg_log/DMS pg_log/DSS name="zh-cn_topic_0237152334_p1014133162314">是 name="zh-cn_topic_0237152334_p1514135239">Config name="zh-cn_topic_0237152334_p20995135132817">DataNode name="zh-cn_topic_0237152334_ul498532372610"><a name="zh-cn_topic_0237152334_ul498532372610"> 收集DataNode的配置信息：<a name="zh-cn_topic_0237152334_ul1741811415273"> postgresql.conf gaussdb.state pg_hba.conf pg_control pg_replslot pg_ident.conf name="zh-cn_topic_0237152334_p515933239">是 name="zh-cn_topic_0237152334_p81518317232">Gstack name="zh-cn_topic_0237152334_p979113464295">DataNode name="zh-cn_topic_0237152334_p41510310234">利用gstack命令得到DataNode的当前堆栈信息。
name="zh-cn_topic_0237152334_p12151316239">否 name="zh-cn_topic_0237152334_p2151038237">CoreDump name="zh-cn_topic_0237152334_p86827507318">gs_ctl、gaussdb、GaussMaster、AioWorker、AlarmChecker、Archiver、Auditor、AutoVacLauncher、AutoVacWorker、AuxMain、BackendMode、BgWriter、BootStrap、Catchup、CBMWriter、Checkpointer、CommAuxStream、CommPoolCleaner、CommRcvStream、CommRcvWorker、CommSendStream、CpMonitor、DataRcvWriter、DataReceiver、DataSender、ExtremeRTO、FencedUDFMaster、Heartbeater、JobExecutor、JobScheduler、LWLockMonitor、PageWriter、ParallelRecov、PercentileJob、Reaper、RemoteSrv、StartupProcess、StatCollector、Stream、SysLogger、ThdPoolListener、TwoPhaseCleaner、WalRcvWriter、WalReceiver、WalSender、WalWriter、WDRSnapshot、WlmArbiter、WlmCollector、WlmMonitor name="zh-cn_topic_0237152334_p5229047123010">通过时间筛选gaussdb进程的core文件。

name="zh-cn_topic_0237152334_p181614310230">否 name="zh-cn_topic_0237152334_p71613318234">XLog name="zh-cn_topic_0237152334_p566195453213">DataNode name="zh-cn_topic_0237152334_p0174312313">通过时间筛选收集xlog。资源池化模式通过指定文件数量，收集磁阵中最新生成的xlog。
name="zh-cn_topic_0237152334_p16174392310">否 name="zh-cn_topic_0237152334_p9138429193316">Plan name="zh-cn_topic_0237152334_p713892916335">*

name="zh-cn_topic_0237152334_p8138132953313">否 name="zh-cn_topic_0237152334_p9138429193316">DssConfig name="zh-cn_topic_0237152334_p713892916335">*

name="zh-cn_topic_0237152334_p8138132953313">是 name="zh-cn_topic_0237152334_p9138429193316">DssDiskInfo name="zh-cn_topic_0237152334_p713892916335">vgname name="zh-cn_topic_0237152334_p713892916335">pri_vgname

name="zh-cn_topic_0237152334_p8138132953313">是

## 前提条件

日志收集工具依赖操作系统工具，例如gstack为其中一种，如果未安装该工具，则提示错误后，跳过该收集项。

## 语法

- 日志收集（非root用户）

    ```
    gs_collector --begin-time="BEGINTIME" --end-time="ENDTIME" [-h HOSTNAME | -f HOSTFILE] [--keyword=KEYWORD] [--speed-limit=SPEED] [-o OUTPUT] [-l LOGFILE] [-C CONFIGFILE] [--timeout=TIMEOUT]
    ```

- 显示帮助信息

    ```
    gs_collector -? | --help
    ```

- 显示版本号信息

    ```
    gs_collector -V | --version
    ```

## 参数说明

- -h

收集信息的主机名称。

取值范围：主机名称，如果不指定则默认收集所有主机的信息。

- -f

主机名称列表文件。该文件为纯文本格式。

>[!NOTE]说明
>-f和-h参数不能同时使用。

取值范围：主机名称列表。

- -o

将收集日志以压缩包形式输出到指定的文件夹。

不指定则将检查结果以压缩包形式输出到配置文件中tmpMppdbPath选项所指定的目录中。

若配置文件中未配置tmpMppdbPath选项且未指定-o参数，则默认将检查结果以压缩包形式输出到“$GAUSSLOG”目录中。

- -l

指定的日志文件的绝对路径。

- -C

指定待收集内容的配置文件，利用TypeName指定需要收集的信息类型，利用Content指定每一类信息的具体内容，利用Count指定此类信息收集的次数，利用Interval指定收集间隔，单位为秒。

TypeName和Content不允许缺失或者内容为空。

Interval和Count可以不指定，如果没有指定Count，则默认收集一次。如果没有指定Interval则表示间隔为0秒，Interval和Count的值不能小于0。

FileNumber的值不能小于0。

如果不指定则使用默认的配置文件。

配置文件格式采用json格式，模板如下：

  ```
  {
      "Collect":
      [
          {"TypeName": "name", "Content":"value","Interval":"seconds", "Count":"count", "FileNumber":"number"}
      ]
  }
  ```

  >[!NOTE]说明
  >
  >TypeName和对应的Content取值范围见表1gs\_collector内容收集对照表。
  >对于Log、CoreDump、Config和XLog四种类型，Interval和Count参数不生效。
  >FileNumber仅用于资源池化模式收集XLog，指定收集的XLog文件数量。

默认配置文件内容如下：

  ```
  {
  "Collect":
  [
  {"TypeName": "System", "Content":"RunTimeInfo, HardWareInfo","Interval":"0", "Count":"1", "FileNumber":"0"},
  {"TypeName": "Log", "Content" : "DataNode,ClusterManager,DSS", "Interval":"0", "Count":"1", "FileNumber":"0"},
  {"TypeName": "Database", "Content": "pg_locks,pg_stat_activity,pg_thread_wait_status","Interval":"0", "Count":"1", "FileNumber":"0"},
  {"TypeName": "Config", "Content": "DataNode", "Interval":"0", "Count":"1", "FileNumber":"0"},
  {"TypeName": "DssConfig", "Content": "DataNode", "Interval":"0", "Count":"1", "FileNumber":"0"},
  {"TypeName": "DssDiskInfo", "Content": "vgname, pri_vgname", "Interval":"0", "Count":"1", "FileNumber":"0"}
  ]
  }
  ```

- --keyword=KEYWORD

包含关键字KEYWORD的日志文件。

若关键字KEYWORD中含有空格，需要使用双引号包围。

  >[!NOTE]说明
  >
  > 性能日志为二进制日志，关键字搜集功能不支持该日志的搜集。

- --begin-time

日志的开始时间。输入格式为“yyyymmdd hh:mm”。该值需要比日志的最后修改时间小。

- --end-time

日志的结束时间。输入格式为“yyyymmdd hh:mm”。该值需要比日志的创建时间大，且需大于--begin-time设置的时间。

- --speed-limit

日志收集时的收集速率，输入格式为非负整数，单位为MB/s。

该参数主要是为了防止日志收集过程中产生过高的磁盘或网络IO，导致数据库节点故障（如果它们与$GAUSSLOG/$PGHOST部署在同一个磁盘上）。该值应当不超过openGauss内上述磁盘IO与网络IO速率的最小值的1/3。

资源池化下允许指定该参数，但是不生效。

该参数依赖rsync工具。未安装时请执行：yum -y install rsync

- --timeout

日志、xlog与core文件收集时最长收集时间，输入格式为非负整数，单位为s。

- -?, --help

显示帮助信息。

- -V, --version

显示版本号信息。

## 示例

执行如下命令收集OS信息和日志信息。

```
gs_collector --begin-time="20180131 23:00" --end-time="20180201 20:00" -h plat1
Successfully parsed the configuration file.
create Dir.
Successfully create dir.
do system check interval 0 : count 1
Collecting OS information.
Successfully collected OS information.
do database check interval 0 : count 1
Collecting catalog statistics.
Successfully collected catalog statistics.
do log check interval 0 : count 1
Collecting Log files.
Successfully collected Log files.
do Config check 0:1
Collecting Config files.
Successfully collected Config files.
Collecting files.
Successfully collected files.
All results are stored in $PGHOST/collector_20200624_134541.tar.gz.
```

查看收集到的统计信息。

```
tar -zxvf $PGHOST/collector_20200624_134541.tar.gz
collector_20200624_134541/
collector_20200624_134541/plat1.tar.gz
collector_20200624_134541/Detail.log
collector_20200624_134541/Summary.log
cd collector_20200624_134541
tar -zxvf plat1.tar.gz
plat1/
plat1/catalogfiles/
plat1/catalogfiles/gs_clean_20200624_134548283647.txt
plat1/catalogfiles/dn_6001_pg_locks_20200624_134547746215.csv
plat1/catalogfiles/dn_6001_pg_thread_wait_status_20200624_134548068716.csv
plat1/catalogfiles/dn_6001_pg_stat_activity_20200624_134547851117.csv
plat1/configfiles/
plat1/logfiles/
plat1/logfiles/log_20200624_134548540916.tar.gz
plat1/coreDumpfiles/
plat1/gstackfiles/
plat1/systemfiles/
plat1/systemfiles/OS_information_20200624_134542218134.txt
plat1/systemfiles/database_system_info_20200624_134546282006.txt
plat1/planSimulatorfiles/
plat1/xlogfiles/
cd plat1/logfiles/
tar -zxvf log_20200624_134548540916.tar.gz
./
./om/
./om/gs_preinstall-2020-06-24_113654.log
./om/gs_local-2020-06-24_113710.log
./om/gs_install-2020-06-24_113911.log
./om/gs_checkperf-2020-06-24_114311.log
./om/gs_collector-2020-06-24_114240.log
./om/gs_backup-2020-06-24_114101.log
./om/gs_om-2020-06-24_114052.log
./bin/
./bin/gs_initdb/
./bin/gs_initdb/gs_initdb-2020-06-24_114010-current.log
./bin/gs_guc/
./bin/gs_guc/gs_guc-2020-06-24_114033-current.log
./bin/gs_ctl/
./bin/gs_ctl/gs_ctl-2020-06-24_114041-current.log
./pg_log/
./pg_log/dn_6001/
./pg_log/dn_6001/postgresql-2020-06-24_114043.log
./pg_log/dn_6001/postgresql-2020-06-24_114330.log
./pg_log/dn_6001/postgresql-2020-06-24_114316.log
./gs_profile/
./gs_profile/dn_6001_6002/
./gs_profile/dn_6001_6002/postgresql-2020-06-24_114330.prf
./gs_profile/dn_6001_6002/postgresql-2020-06-24_114316.prf
./gs_profile/dn_6001_6002/postgresql-2020-06-24_114043.prf
```

资源池化模式查看收集到的统计信息。

```
tar -zxvf $GAUSSLOG/collector_20231128_175344.tar.gz
collector_20231128_175344/
collector_20231128_175344/plat1.tar.gz
collector_20231128_175344/Detail.log
collector_20231128_175344/Summary.log
cd collector_20231128_175344/
tar -zxvf plat1.tar.gz
plat1/
plat1/planSimulatorfiles/
plat1/gstackfiles/
plat1/catalogfiles/
plat1/catalogfiles/dn_6001_pg_thread_wait_status_20231128_175353339795.csv
plat1/catalogfiles/gs_clean_20231128_175353466332.txt
plat1/catalogfiles/dn_6001_pg_stat_activity_20231128_175353203128.csv
plat1/catalogfiles/dn_6001_pg_locks_20231128_175353066230.csv
plat1/logfiles/
plat1/logfiles/log_20231128_175354071864.tar.gz
plat1/configfiles/
plat1/configfiles/pg_cotrol
plat1/configfiles/config_20231128_175355276285/
plat1/configfiles/config_20231128_175355276285/dn_6001/
plat1/configfiles/config_20231128_175355276285/dn_6001/pg_ident.conf
plat1/configfiles/config_20231128_175355276285/dn_6001/postgresql.conf
plat1/configfiles/config_20231128_175355276285/dn_6001/pg_hba.conf
plat1/configfiles/config_20231128_175355276285/dn_6001/gaussdb.state
plat1/systemfiles/
plat1/systemfiles/database_system_info_20231128_175349300695.txt
plat1/systemfiles/OS_information_20231128_175345132506.txt
plat1/xlogfiles/
plat1/coreDumpfiles/
plat1/dssdiskinfo/
plat1/dssdiskinfo/disk/
plat1/dssdiskinfo/disk/p0/
plat1/dssdiskinfo/disk/p0/root_ft_block
plat1/dssdiskinfo/disk/p0/vg_header
plat1/dssdiskinfo/disk/p0/volume_ctrl
plat1/dssdiskinfo/disk/p0/core_ctrl
plat1/dssdiskinfo/disk/data/
plat1/dssdiskinfo/disk/data/root_ft_block
plat1/dssdiskinfo/disk/data/vg_header
plat1/dssdiskinfo/disk/data/volume_ctrl
plat1/dssdiskinfo/disk/data/core_ctrl
plat1/dssdiskinfo/inq/
plat1/dssdiskinfo/inq/lun
plat1/dssdiskinfo/inq/reg
plat1/dssdiskinfo/vg_info
plat1/dssconfigfiles/
plat1/dssconfigfiles/dss_vg_conf.ini
plat1/dssconfigfiles/dss_inst.ini
cd plat1/logfiles/
tar -zxvf log_20231128_175354071864.tar.gz
./
./cm/
./cm/cm_client/
./cm/cm_client/dss-2023-11-28_153931-current.log
./cm/cm_client/dms_res-2023-11-28_153936-current.log
./cm/cm_agent/
./cm/cm_agent/pg_log/
./cm/cm_agent/pg_log/postgresql-2023-11-28_073928.log
./cm/cm_agent/system_alarm-2023-11-28_153928-current.log
./cm/cm_agent/cm_agent-2023-11-28_153928-current.log
./cm/cm_ctl/
./cm/cm_ctl/cm_ctl-2023-11-28_153742-current.log
./cm/cm_server/
./cm/cm_server/system_alarm-2023-11-28_153928-current.log
./cm/cm_server/key_event-2023-11-28_153928-current.log
./cm/cm_server/cm_server-2023-11-28_153928-current.log
./cm/om_monitor/
./cm/om_monitor/om_monitor-2023-11-28_153800-current.log
./cm/om_monitor/system_alarm-2023-11-28_153800-current.log
./pg_log/
./pg_log/DMS/
./pg_log/DMS/dms.rlog
./pg_log/dn_6001/
./pg_log/dn_6001/postgresql-2023-11-28_153934.log
./pg_log/DSS/
./pg_log/DSS/dss.rlog
./bin/
./bin/gs_guc/
./bin/gs_guc/gs_guc-2023-11-28_153911-current.log
./bin/gs_cgroup/
./bin/gs_cgroup/gs_cgroup-2023-11-28_153446.log
./bin/gs_initdb/
./bin/gs_initdb/gs_initdb-2023-11-28_153804-current.log
./gs_profile/
./gs_profile/dn_6001_6002/
./gs_profile/dn_6001_6002/postgresql-2023-11-28_153934.prf
./om/
./om/gs_local-2023-11-28_153139.log
./om/gs_preinstall-2023-11-28_153108.log
./om/gs_install-2023-11-28_153658.log
./DSSLog/
./DSSLog/dsscmd.rlog
./DSSLog/dssinstance.rlog

```
