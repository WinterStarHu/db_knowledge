# Slow Query Diagnosis

## 概述

在数据运维工作中，慢SQL一直是个痛点问题。如何准确诊断出慢SQL的根本原因，是当下数据运维领域面临的一大挑战。

本工具结合openGauss自身特点，同时融入了DBA在现网中的慢SQL诊断方面的经验，从而具备了强大的慢SQL根因分析能力。它能够依据可能性的高低，同时给出多个慢SQL的根本原因，并针对每个原因提供具体的解决方案建议 。

## 环境部署

- 数据库运行正常。
- 指标采集系统运行正常。

## 使用指导

当前版本支持的慢SQL根因如[表1](#zh-cn_topic_0000001667029292_table17449477176)所示。

**表 1**  慢SQL根因列表

根因解释 补充说明 LOCK_CONTENTION 锁竞争。
语句执行期间被锁阻塞，导致单SQL执行较慢。
MANY_DEAD_TUPLES 废弃元组数量较多。
表中废弃元组占比超过设定阈值会降低查询效率，导致单SQL执行较慢。
HEAVY_SCAN_OPERATOR 扫描算子代价较大。
执行计划中扫描算子代价较大，导致单SQL执行较慢。
ABNORMAL_PLAN_TIME 异常执行计划生成时间。
SQL生成执行计划时间较长。
UNUSED_AND_REDUNDANT_INDEX 无用/冗余索引。
表中存在无用/冗余索引，影响插入更新语句性能。
UPDATE_LARGE_DATA 更新大量元组。
批量更新大量元组，导致单SQL语句性能较差。
INSERT_LARGE_DATA 插入大量元组。
批量插入大量元组，导致单SQL语句性能较差。
DELETE_LARGE_DATA 删除大量元组。
批量删除大量元组，导致单SQL语句性能较差。
TOO_MANY_INDEX 表中存在太多索引。
表中存在大量索引，影响插入更新语句性能。
DISK_SPILL 磁盘溢出。
由于GUC参数设置不当等原因导致SQL执行期间发生落盘现象。
WORKLOAD_CONTENTION 数据库负载集中。
数据库负载集中导致实例整体执行性能较差。
CPU_RESOURCE_CONTENTION 系统CPU负载集中。
由于外部进程等其他原因导致CPU资源紧张，实例整体SQL执行性能较差。
IO_RESOURCE_CONTENTION 系统IO资源集中。
由于外部进程等其他原因导致IO资源紧张，实例整体SQL执行性能较差。
MEMORY_RESOURCE_CONTENTION 系统内存资源集中。
由于外部进程等其他原因导致内存资源紧张，实例整体SQL执行性能较差。
ABNORMAL_NETWORK_STATUS 异常网络状态。
网络异常，导致SQL执行性能较差。
OS_RESOURCE_CONTENTION 句柄资源紧张。
系统句柄资源紧张影响整体执行性能。
WAIT_EVENT 等待事件。
SQL执行期间的等待事件影响执行性能。
LACK_STATISTIC_INFO 统计信息缺失。
没有及时更新表统计信息，可能导致执行计划不优进而影响SQL执行性能。
MISSING_INDEXES 缺少索引。
缺失索引导致单SQL执行性能较差。
POOR_JOIN_PERFORMANCE JOIN代价较大。
JOIN算子代价较大，影响SQL语句执行性能。
COMPLEX_BOOLEAN_EXPRESSIONS 复杂的布尔表达式。
主要针对not in (item1, item2, ...)情况，如果元素数量太多可能会导致执行计划较差，从而影响SQL的性能。
STRING_MATCHING 字符串匹配。
由于不恰当使用函数等原因导致索引失效，进而影响SQL性能。
COMPLEX_EXECUTION_PLAN 复杂的执行计划。
执行计划较复杂，执行时间较长。
CORRELATED_SUBQUERY 关联子查询。
有相关子查询导致执行性能较差。
POOR_AGGREGATION_PERFORMANCE 聚合代价较大。
聚合性能较差进而影响SQL执行性能。
DATABASE_VIEW 系统视图。
当前不对系统视图相关的慢SQL进行诊断，统一返回此根因。
NO_ROOT_CAUSE_FOUND 没有发现根因。
没有发现当前慢SQL的根因。

假设用户已经初始化配置文件目录confpath，则可以通过下述命令实现本特性的功能：

- 仅启动慢SQL诊断功能（慢SQL诊断根因数量由算法运行结果决定，数量不固定），启动命令如下（更多用法参考对service子命令的说明）：

    ```
    gs_dbmind service start -c confpath --only-run slow_query_diagnosis
    ```

- 用户查询慢SQL诊断历史，命令如下：

    ```
    gs_dbmind component slow_query_diagnosis show -c confpath --instance instance --query SQL --start-time timestamps0 --end-time timestamps1
    ```

- 用户交互式诊断慢SQL，命令如下：

    ```
    gs_dbmind component slow_query_diagnosis diagnosis -c confpath --database dbname --schema schema_name --query SQL
    ```

- 启用慢SQL诊断后台任务，首先将opengauss-exporter下的pg\_sql\_statement\_history开启，具体步骤如下：

    ```
    1、停止opengauss-exporter进程；
    2、进入dbmind/components/opengauss_exporter/yamls/statements.yml中，将该指标的status设置为enable；
    3、重启opengauss-exporter进程；
    4、将slow_query_diagnosis加入到配置文件dbmind.conf下TIMED_TASK的task中，任务之间用逗号隔离，同时该任务运行间隔由配置文件dbmind.conf下TIMED_TASK的slow_query_diagnosis_interval控制，默认120秒，该参数支持用户修改；
    5、运行 gs_dbmind service reload -c confpath 命令，启动慢SQL诊断后台任务；
    ```

- 用户手动清理历史预测结果，命令如下：

    ```
    gs_dbmind component slow_query_diagnosis clean -c confpath --retention-days DAYS
    ```

- 停止已启动的服务，命令如下：

    ```
    gs_dbmind service stop -c confpath
    ```

## 获取帮助

**模块命令行说明：**

使用如下命令查看帮助信息

```
gs_dbmind component slow_query_diagnosis --help

usage:  [-h] -c DIRECTORY [--instance INSTANCE] [--database DATABASE] [--schema SCHEMA]
        [--query SLOW_QUERY] [--start-time TIMESTAMP_IN_MICROSECONDS]
        [--end-time TIMESTAMP_IN_MICROSECONDS] [--retention-days DAYS]
        {show,clean,diagnosis}

Slow Query Diagnosis: Analyse the root cause of slow query

positional arguments:
  {show,clean,diagnosis}
                        choose a functionality to perform

optional arguments:
  -h, --help            show this help message and exit
  -c DIRECTORY, --conf DIRECTORY
                        set the directory of configuration files
  --instance INSTANCE   Set the instance of slow query. Using in show.
  --database DATABASE   name of database
  --schema SCHEMA       schema of database
  --query SLOW_QUERY    set a slow query you want to retrieve
  --start-time TIMESTAMP_IN_MICROSECONDS
                        set the start time of a slow SQL diagnosis result to
                        be retrieved
  --end-time TIMESTAMP_IN_MICROSECONDS
                        set the end time of a slow SQL diagnosis result to be
                        retrieved
  --retention-days DAYS
                        clear historical diagnosis results and set the maximum
                        number of days to retain data
```

## 命令参考

**表 1**  gs\_dbmind component slow\_query\_diagnosis 命令行说明

参数说明 取值范围 -h, --help （可选）帮助命令。
-c，--conf 配置目录。
--instance （可选）慢SQL所属实例。action为show时使用。
格式为IP:PORT。样例：127.0.0.1:5432。
--database （可选）慢SQL关联的数据库。
--schema （可选）慢SQL关联的schema，默认为public。
--query （可选）慢SQL文本。
--start-time （可选）显示开始时间的时间戳，单位毫秒；或格式为 %Y-%m-%d %H:%M:%S 的日期时间。action为show时使用。
正整数或日期时间格式。
--end-time （可选）显示结束时间的时间戳，单位毫秒；或格式为 %Y-%m-%d %H:%M:%S 的日期时间。action为show时使用。
正整数或日期时间格式。
--retention-days （可选）清理天数及结果。action为clean时使用。
实数（当其小于等于0时，会将结果全部删除）。
action 动作参数。
show：结果展示。clean：清理结果。diagnosis：交互诊断。

## 注意事项说明

DBMind当前支持三种模式的慢SQL诊断能力，分别是：后台定时任务、命令行交互和API调用，下面对这三种方式的注意事项进行说明。

>[!NOTE]说明
>如果没有特别指出具体使用模式，则表示该项三种模式都适用。

- 当前慢SQL诊断定时任务依赖opengauss-exporter指标采集慢SQL流水，该指标默认关闭，如果不启用该指标采集，则慢SQL诊断功能无法正常运行。启动慢SQL采集的方法是先手动将opengauss\_exporter/yamls/statements.yaml中pg\_sql\_statement\_history指标的status设置成enable，再重启opengauss-exporter进程。
- 慢SQL诊断定时任务间隔支持用户自行配置，用户需要修改配置文件dbmind.conf中TIMED\_TASK的slow\_query\_diagnosis\_interval，然后执行reload操作才能生效，命令参考[service子命令](service.md)。
- 慢SQL诊断定时任务依赖dbe\_perf.statement\_history视图，当其数据量较大时可能会查询超时，此时慢SQL后台诊断任务不会生成新的诊断结果。用户可以根据数据库状况设置该指标的超时时间timeout，以免超时时间太小不能采集到指标，具体的修改方法可以参见[Prometheus Exporter组件](prometheus_exporter_overview.md)。
- 在慢SQL诊断定时任务中，由于慢SQL流水数据源dbe\_perf.statement\_history视图中的query字段可能会出现截断，导致query不完整，此时如果没有提供执行计划则不能进行诊断。
- 慢SQL诊断定时任务的采集基于opengauss-exporter实现，服务运行时不能保证全量采集，可能会遗漏部分慢SQL数据。
- 使用慢SQL交互诊断功能时，工具基于RPC和数据采集服务获取必要的数据，因此如果RPC和数据采集服务未启动则无法诊断。
- 使用慢SQL交互诊断功能时，工具会对传入的数据库名和schema进行检测，如果数据库或schema不存在则会进行提示，不能正常进行诊断。
- 使用慢SQL诊断功能时，工具会对传入的数据库名和schema进行检测，如果其中包含非法字符则会进行提示并拒绝诊断。
- 慢SQL诊断过程需要获取诊断语句的执行计划，在调用慢SQL诊断API接口时建议传递执行计划（对应query\_plan参数），如果前端没有传递执行计划，那么工具会主动获取执行计划内容，此时需要确保执行诊断的用户具有获取query执行计划的权限。另外，在获取执行计划过程中，如果SQL属于归一化SQL，那么工具会基于PBE方式获取执行计划，获取过程中如果由于语法结构不支持、SQL截断等原因导致获取失败则会诊断失败；如果SQL不属于归一化SQL，那么SQL截断时也不能正常诊断。
- 使用慢SQL诊断API接口时，如果用户传入的db\_name不存在则无法诊断，另外当工具在传入的schema\_name下获取执行计划失败时会自动在其他schema下尝试获取执行计划直到成功获取为止，否则诊断失败。
- 当DBMind纳管多个实例时，使用慢SQL交互诊断功能时会提示用户选择哪一个实例，然后再进行诊断动作。
- 当前慢SQL诊断只支持DML语句。
- 慢SQL诊断每次只能诊断一条语句，如果输入多条则只会对第一条进行诊断。
- 当前不对系统视图根因进行诊断，根因统一为DATABASE\_VIEW。
- 慢SQL诊断过程中，如果用户不传schema信息，则schema默认为public。
- 由于reprocessing-exporter在采集磁盘占用率时只支持EXT和XFS文件系统，因此当非上述文件系统磁盘超过阈值时不会出现磁盘空间不足的根因。
- 如果需要诊断LOCK\_CONTENTION或WAIT\_EVENT根因，需要使用API调用的方式，并传入debug\_query\_id参数。
