# 智能巡检

## 概述

在现网业务中需要定期对数据库实例进行巡检并输出健康报告。DBMind构建了二十多个巡检项，包括硬件状态、实例状态、数据库资源、数据库性能与诊断优化等类别，并对其中关键资源指标趋势进行风险判断，避免不易发现的潜在问题影响实例健康。同时，支持生成日报、周报、月报供用户查看，并基于当前巡检项情况给出健康评分。支持用户对巡检项自定义设置告警阈值，方便用户根据业务特性进行调整，避免无意义告警。

>[!NOTE]说明
>
>- 月报与周报生成约束：
>- 如果未构建日报，则无法生成周报与月报；
>- 当日报数量不满足连续7天时，无法生成这7天对应的周报；
>- 当日报数量不满足连续14天以上时，无法生成对应的月报；
>- 如出现实例IP和port的变化，会导致周报/月报无法生成；
>- 如节点实例被删除，会导致周报/月报无法生成；
>- 采用定时方式生成周报和月报时，建议控制并发量，避免影响实时任务。
>- 在配置文件中，必须将实例的IP地址映射关系记录到ip\_map中，否则无法确保巡检时获取到的是实例的管理IP地址。
>- 周报和月报仅支持对所有巡检项进行巡检，不支持部分巡检项的拼接；因此周报和月报的自定义阈值需要由前端传入，规则与实时巡检等一致，没有传入的巡检项默认不进行告警（除了部分由前端控制的巡检项，见[使用指导](#useguide)）。
>- 调用巡检接口时需要传递实例，该实例必须为主数据库实例。
>- 智能巡检中db\_size、buffer\_hit\_rate、db\_tmp\_file、db\_deadlock、db\_transaction等巡检项仅展示主节点的数据库结果，如果出现主备切换等主节点切换的情况，可能出现结果跳变（不同节点的结果拼接）。
>- 智能巡检中db\_size、buffer\_hit\_rate、db\_transaction、db\_tmp\_file、db\_deadlock等巡检项仅展示主节点的数据库结果；user\_login\_out、db\_latency、thread\_pool等巡检项展示所有节点的结果；xlog\_accumulate巡检项展示所有节点的结果。
>- 为了确保不遗漏关键信息，log\_error\_check和core\_dump这两个巡检项在实时巡检中仅支持分析最近45小时内的数据。其他巡检项的数据分析则不能超出TSDB（时序数据库）的数据存储范围，以确保数据的完整性和可用性。
>- 日报无论是否选择GUC参数巡检，均不会影响周检和月检的全量校验，依然能够生成周报/月报；此外，周报和月报不选择GUC参数巡检，不会获取GUC参数巡检结果；选择GUC参数巡检，均会生成GUC参数巡检结果。
>- 智能巡检暂不支持容灾数据库实例。
>- 当数据库实例只有单节点时，ping\_packet\_rate指标没有数据，无法进行网络状态巡检获取对应数据。
>- 动态内存、程序内存、其他内存三个巡检项依赖于pg\_total\_memory\_detail\_mbytes指标，当pv\_total\_memory\_detail视图无法查询时，无法获取相关数据进行巡检。
>- 负载高、网络异常和数据库实例不可用的场景下，巡检功能不可用。
>- 由于oldestXmin长时间未推进巡检项需要采集12小时数据来判断是否推进，因此在前12小时内，该巡检项无数据。
>- 除top\_query、long\_transaction和guc\_param三个巡检项取当前值作为巡检结果，其余巡检项均取起止时间范围内数据进行巡检，实时巡检默认时间范围为\[当前时间-6小时, 当前时间\]，日检默认时间范围为\[昨天00:00, 今天00:00\]。
>- 在prometheus中构造数据导致出现两个实例一致的数据时，由于DBMind依赖prometheus进行数据采集，因此无法判断数据是否存在异常，此构造场景下巡检结果无法保证准确。

**表 1**  巡检项与权重设置

巡检类 巡检项 巡检字段 分数权重 系统资源 system_resource CPU使用率。
os_cpu_usage
0.06
系统磁盘占用率。
os_disk_usage
0.06
内存使用率。
os_mem_usage
0.06
磁盘I/O使用率。
os_disk_ioutils
0.06
网络状况。
network_packet_loss
0.06
实例状态 instance_status 组件异常。
component_error
0.05
数据库资源 database_resource 数据库目录占用率。
data_directory
0.04
数据库日志目录占用率。
log_directory
0.04
数据库大小。
db_size 数据库性能 database_performance Buffer命中率。
buffer_hit_rate
0.03
用户登录登出次数。
user_login_out 活跃Session率。
active_session_rate
0.03
日志异常检查。
log_error_check
0.03
线程池占用率。
thread_pool
0.03
数据库时延。
db_latency
0.08
数据库事务。
db_transaction 数据库临时文件大小。
db_tmp_file 数据库执行语句。
db_exec_statement 数据库死锁。
db_deadlock
0.03
数据库TPS性能。
db_tps 数据库Top Query。
db_top_query 长事务。
long_transaction
0.05
Xlog堆积。
xlog_accumulate
0.05
oldestXmin长时间未推进。
xmin_stuck
0.05
诊断优化 diagnosis_optimization Core dump。
core_dump
0.04
动态内存。
dynamic_memory
0.04
程序内存。
process_memory
0.04
其他内存。
other_memory
0.03
GUC参数。
guc_params
0.04

### 各巡检项实现细节与告警设置

- 系统资源
  - CPU使用率：获取TSDB中的“os\_cpu\_user\_usage”和“os\_cpu\_iowait\_usage”两个指标。
  - 对于os\_cpu\_user\_usage，观测数值是否大于0.7，若超出阈值，则进行告警；最后，进行趋势预测，判断未来24小时数值是否大于0.7，若超出阈值，则进行告警。
  - 对于os\_cpu\_iowait\_usage，当数值大于0.3时，进行告警。

  - 系统磁盘占用率：获取TSDB中的“os\_disk\_usage”指标，观测其中系统盘（mount\_point='/'）的磁盘使用率，当数值大于0.8时，进行告警。
  - 系统总内存使用率：获取TSDB中的“os\_mem\_usage”指标，当发现持续上升时会进行告警；当数值大于0.7时，进行告警；最后，进行趋势预测，如果判断未来24小时数值大于0.8，进行告警。
  - 磁盘I/O使用率：获取TSDB中的“os\_disk\_ioutils”指标，当数值大于0.8时，进行告警。
  - 网络状况：获取TSDB中的“ping\_packet\_rate”指标，得出数据库节点间的网络连接状况，当丢包率大于0.05时，进行告警。

- 实例状态
  - 组件异常：根据instance从元数据库中获取节点的状态信息，得出时间范围内当前数据库实例的状态，当出现异常状态（即值不为-1）时，进行告警。

- 数据库资源
  - 数据库目录占用率：获取TSDB中的“pg\_node\_info\_uptime”指标，解析出各个数据库实例的数据目录，同时获取“process\_cpu\_usage”指标，匹配判断是否存在change\_root，存在则组合成正确的目录路径，然后获取“os\_disk\_usage”指标，匹配判断对应数据目录的占用率，当发现持续上升时，进行告警；当数值大于0.8时，进行告警；最后，进行趋势预测，如果判断未来24小时数值大于0.8，进行告警；判断文件系统类型是否有误，不匹配则进行告警，匹配范围为\['xfs', 'ext3', 'ext4'\]。
  - 数据库日志目录占用率：获取TSDB中的“pg\_node\_info\_uptime”指标，然后解析出各个数据库实例的日志目录，同时获取“process\_cpu\_usage”指标，匹配判断是否存在change\_root，存在则组合成正确的目录路径，，然后获取“os\_disk\_usage”指标，匹配判断对应日志目录的占用率，当发现持续上升时会进行告警，当数值大于0.8时，同样进行告警，再进行趋势预测，如果判断未来24小时数值大于0.8，也会进行告警，最后还会判断文件系统类型是否有误，不匹配则进行告警，匹配范围为\['xfs', 'ext3', 'ext4'\]。
  - 数据库大小：获取TSDB中的“pg\_database\_size\_bytes”指标，获取所有数据库的大小并进行记录，用于前端进行趋势展示。暂无告警。

- 数据库性能
  - Buffer命中率：获取TSDB中的“pg\_db\_blks\_access”指标，当数值大于0.9时，进行告警。
  - 用户登录登出次数：获取TSDB中的“user\_login”和“user\_logout”两个指标，获取1分钟内平均每秒用户登录/登出次数，用于前端进行趋势展示。暂无告警。
  - 活跃Session率：获取TSDB中的活跃会话数active\_connection和总会话数total\_connection指标，活跃session率即为active\_connection / total\_connection，当其比值小于0.8时，进行告警。
  - 日志异常检查：获取TSDB中日志相关的指标，统计每种日志错误出现的次数并进行相加，如果出现日志异常，则将日志异常的出现次数返回前端，进行告警。具体指标为'deadlock\_count', 'login\_denied', 'errors\_rate', 'panic', 'dn\_ping\_standby', 'node\_restart', 'node\_start', 'cn\_status', 'dn\_status', 'gtm\_status', 'dn\_writable\_failed', 'etcd\_io\_overload', 'cms\_heartbeat\_timeout\_restart', 'cms\_phonydead\_restart', 'cms\_cn\_down', 'cn\_restart\_time\_exceed', 'cms\_read\_only', 'cms\_restart\_pending', 'cms\_heartbeat\_timeout', 'etcd\_restart', 'etcd\_not\_connect\_dial\_tcp', 'etcd\_auth\_failed', 'etcd\_overload', 'etcd\_sync\_timeout', 'etcd\_disk\_full', 'etcd\_be\_killed', 'bind\_ip\_failed', 'gtm\_disconnected\_to\_primary', 'gtm\_panic', 'ffic'。
  - 线程池占用率：获取TSDB中的“pg\_thread\_pool\_rate”指标，当发现持续上升时会进行告警，当数值小于0.9时，进行告警。
  - 数据库时延：获取TSDB中的“statement\_responsetime\_percentile\_p95”和“statement\_responsetime\_percentile\_p80”两个指标，暂无告警。
  - 数据库事务：获取TSDB中的“pg\_db\_xact\_commit”和“pg\_db\_xact\_rollback”两个指标，获取数据库中提交和回滚的次数，用于前端进行趋势展示。暂无告警。
  - 数据库临时文件大小：获取TSDB中的“pg\_db\_temp\_files”指标，获取数据库临时文件的大小，用于前端进行趋势展示。暂无告警。
  - 数据库执行语句：获取TSDB中的“pg\_sql\_count\_select”、“pg\_sql\_count\_update”、“pg\_sql\_count\_insert”和“pg\_sql\_count\_delete”四个指标，获取数据库中select、update、insert、delete的执行次数，用于前端进行趋势展示。暂无告警。
  - 数据库死锁：获取TSDB中的“pg\_db\_deadlocks”指标，获取数据库中出现的死锁情况，当死锁数不为0时，表示数据库出现死锁。数值表示死锁数量。暂无告警。
  - 数据库TPS性能：获取TSDB中的“qps\_by\_instance”和“qps”两个指标，获取数据库的QPS和TPS信息，用于前端进行趋势展示。暂无告警。
  - 数据库Top Query：通过执行SQL语句从dbe\_perf.statement查询出现调用次数最多的TopK个查询，用于前端展示。当前K为10。暂无告警。
  - 长事务：通过执行SQL语句从pg\_catalog.pg\_stat\_activity查询超过12小时未结束的活跃事务，当返回结果列表的长度大于0时，表示存在长事务，进行告警。
  - xLog堆积：获取TSDB中的“xlog\_count”指标，获取xlog目录下的文件数量，当数量大于3000时，进行告警。
  - oldestXmin长时间未推进：获取TSDB中的“oldestxmin\_increase”指标，当oldestxmin超过12小时未出现变化，则表示长时间未推进，此时巡检返回数据中数值为0，进行告警。

- 诊断优化
  - Core dump：获取TSDB中的“log\_ffic”指标，当返回值中count大于0时，表示出现core dump，进行告警。
  - 动态内存：获取TSDB中的“pg\_total\_memory\_detail\_mbytes”指标，计算其中“dynamic\_used\_memory”相对于“max\_dynamic\_memory”的比例，当数值大于0.8时，进行告警；计算其中“dynamic\_used\_shrctx”相对于“max\_dynamic\_memory”的比例，当数值大于0.8时，同样进行告警。
  - 程序内存：获取TSDB中的“pg\_total\_memory\_detail\_mbytes”指标，计算其中“process\_used\_memory”相对于“max\_process\_memory”的比例，当数值大于0.8时，进行告警。
  - 其他内存：获取TSDB中的“pg\_total\_memory\_detail\_mbytes”指标，获取其中“other\_used\_memory”的值，当发现持续上升时会进行告警，当超过20G时，进行告警。
  - GUC参数：获取TSDB中的“pg\_total\_memory\_detail\_mbytes”和“pg\_settings\_setting”指标，获取其中“max\_process\_memory”、“shared\_buffers”和“work\_mem”的值，将当前的值与DBMind根据workload推算出的最优参数进行对比，如果当前参数与最优参数相差大，结果中的warning字段为true，进行告警。
  - 对于"work\_mem"：
  - 独立部署DN时，最优值a= \(内存/16G） \* 16MB，如果a\>128MB，设置为128MB，若a < 16MB, 设置 16MB。基于最优值取\[0.9a, 1.1a\]作为可选区间，当实际work\_mem参数在\[0.9a, 1.1a\]范围外时，进行告警。

  - 对于"max\_process\_memory"：
  - 系统总内存\> 256GB，设置：系统总内存 \*0.875。
  - 系统总内存=128GB，设置：内存\*0.75。
  - 系统总内存<128GB，设置：系统总内存 \* 0.625。

  - 对于"shared\_buffer"：

最优值：系统总内存/4。

>[!NOTE]说明
>
>健康评分根据各巡检项的重要性权重以及异常程度来给出评分，最后汇总成当前实例的健康评分，具体计算公式如下：
>![](figures/zh-cn_formulaimage_0000002294473813.png)
>上述：
>![](figures/zh-cn_formulaimage_0000002259760648.png)
>Si  = 0 or 1（其中0代表巡检项异常，1代表正常）。
>此外，结论中会提供TOP3列表，TOP3指的是异常情况最严重的三个巡检项，通过统计各个巡检项的异常数量，再结合巡检项的权重进行排序，取前3个作为TOP3列表，如果没有异常，则为空。
>各巡检项的异常数量：网络状态按照双向通信异常进行计算；buffer\_hit\_rate巡检项按照数据库实例异常数量计算；长事务按照长事务数量进行计算；其他巡检项按照节点异常数量进行计算。

### 支持的巡检自定义阈值

当前巡检项的告警类型与默认设置如下表所示。

- √和范围表示该巡检项已设置默认告警阈值。
- -表示该巡检项支持设置对应告警类型。
- ×表示该巡检项不支持设置对应告警类型。

巡检项 巡检项 数值范围 异常类型 判断标准 超过阈值 预测超过阈值 持续上升 文件类型有误 CPU使用率-os_cpu_user_usage os_cpu_usage [0, 1] &gt;0.7 &gt;0.7 任意异常出现则告警。
CPU使用率-os_cpu_iowait_usage os_cpu_usage [0, 1] &gt;0.3 任意异常出现则告警。
磁盘I/O使用率 os_disk_ioutils [0, 1] &gt;0.8 任意异常出现则告警。
系统磁盘占用率 os_disk_usage [0, 1] &gt;0.8 任意异常出现则告警。
内存使用率 os_mem_usage [0, 1] &gt;0.7 &gt;0.8 任意异常出现则告警。
网络状况 network_packet_loss [0, 1] &gt;0.05 任意异常出现则告警。
组件异常 component_error 任意异常出现则告警。
数据库目录占用率 data_directory [0, 1] &gt;0.8 &gt;0.8 任意异常出现则告警。
数据库日志目录占用率 log_directory [0, 1] &gt;0.8 &gt;0.8 任意异常出现则告警。
数据库大小 db_size [0, ∞) 暂无告警。
Buffer命中率 buffer_hit_rate [0, 1] &lt;0.9 任意异常出现则告警。
用户登录登出次数 user_login_out [0, ∞) 暂无告警。
活跃Session率 active_session_rate [0, 1] &lt;0.8 任意异常出现则告警。
日志异常检查 log_error_check 存在则告警。
线程池占用率 thread_pool [0, 1] &gt;0.9 任意异常出现则告警。
数据库时延 db_latency [0, ∞) 任意异常出现则告警。
数据库事务 db_transaction [0, ∞) 暂无告警。
数据库临时文件大小 db_tmp_file [0, ∞) 暂无告警。
数据库执行语句 db_exec_statement [0, ∞) 暂无告警。
数据库死锁 db_deadlock [0, ∞) 暂无告警。
数据库TPS性能 db_tps [0, ∞) 暂无告警。
数据库Top Query db_top_query 暂无告警。
长事务 long_transaction 存在则告警。
oldestXmin长时间未推进 xmin_stuck [0, ∞) 任意异常出现则告警。
Xlog堆积 xlog_accumulate [0, ∞) &gt;3000 任意异常出现则告警。
Core dump core_dump 存在则告警。
动态内存 dynamic_memory [0, 1] &gt;0.8 任意异常出现则告警。
程序内存 process_memory [0, 1] &gt;0.8 任意异常出现则告警。
其他内存 other_memory [0, ∞) &gt;20*1024 任意异常出现则告警。
GUC参数 guc_params warning中存在值则告警。

>[!NOTE]说明
>
>- 持续上升和预测超过阈值两类告警涉及检测算法，会占用DBMind性能，配置时减少开启的数量，避免影响服务性能以及返回时间等。
>- 持续上升检测器除了判断数据本身持续上升以外，还需要时间范围内80%以上的数据超过阈值范围，才判断为持续上升告警。
>- 预测超过阈值（告警）需要设置预测的时间范围，以分钟为单位，设置范围\(0, 48 \* 60\]。建议设置的预测时间长度小于巡检数据的时间长度，或者通过自定义阈值调整预测的时间长度。
> 预测超过阈值（告警）会预测未来时间范围内的数值，判断数值是否存超过阈值。预测超过阈值对于巡检数据不进行判断，如果巡检数据已经超过阈值，仍会继续进行预测，判断未来是否会一直超过阈值，还是会在某个时间点回归正常范围。

## 使用指导

### 通过巡检相关API实现功能调用

- 智能巡检接口

示例：

    ```
    curl -X 'POST' "http://127.0.0.1:8080/v1/api/app/real-time-inspection?inspection_type=real_time_check&start_time=1689210000000&end_time=1689296400000&instance=127.0.0.1:5432" -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"system_resource": ["os_mem_usage"], "instance_status": [], "database_resource": [], "database_performance": [], "diagnosis_optimization": []}' -H "Authorization: bearer xxx"
    ```

如果使用HTTPS协议，则查询示例：

    ```
    curl -X 'POST' "https://127.0.0.1:8080/v1/api/app/real-time-inspection?inspection_type=real_time_check&start_time=1689210000000&end_time=1689296400000&instance=127.0.0.1:5432" -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"system_resource": ["os_mem_usage"], "instance_status": [], "database_resource": [], "database_performance": [], "diagnosis_optimization": []}' -H "Authorization: bearer xxx" --cacert xx.crt --key xx.key --cert xx.crt
    ```

如果使用自定义阈值，查询示例：

    ```
    curl -X 'POST' "https://127.0.0.1:8080/v1/api/app/real-time-inspection?inspection_type=real_time_check&start_time=1689210000000&end_time=1689296400000&instance=127.0.0.1:5432" -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"system_resource": [{"os_mem_usage": {"increase": false, "threshold": [], "forecast": [1440, 0.0, 0.8]}}], "instance_status": [], "database_resource": [], "database_performance": [], "diagnosis_optimization": []}' -H "Authorization: bearer xxx" --cacert xx.crt --key xx.key --cert xx.crt
    ```

返回结构示例如下：

    ```
    {
     "data": {
      "conclusion": {
       "full_score": 0.06,
       "health_score": 0.06,
       "health_status": "bad",
       "top3": []
      },
      "database_performance": {},
      "database_resource": {},
      "diagnosis_optimization": {},
      "instance_status": {},
      "system_resource": {
       "os_mem_usage": {
        "127.0.0.1": {
         "data": [0.31643905373281667],
         "statistic": {
          "avg": 0.311,
          "max": 0.3166,
          "min": 0.3057,
          "the_95th": 0.3153
         },
         "timestamps": [1694674713000],
         "warnings": {
          "increase_warning": true
         }
        }
       }
      }
     },
     "success": true
    }
    ```

- 展示巡检任务接口示例：

    ```
    curl -X 'GET' "http://127.0.0.1:8080/v1/api/app/real-time-inspection/list?instance=127.0.0.1:5432" -H 'accept: application/json' -H "Authorization: bearer xxx"
    ```

如果使用HTTPS协议，则查询示例：

    ```
    curl -X 'GET' "https://127.0.0.1:8080/v1/api/app/real-time-inspection/list?instance=127.0.0.1:5432" -H 'accept: application/json' -H "Authorization: bearer xxx" --cacert xx.crt --key xx.key --cert xx.crt
    ```

返回结构如下：

    ```
    {"data":{"header":["instance","start","end","id","state","cost_time","inspection_type"],"rows":[["127.0.0.1:5432",1689210000000,1689296400000,5,"success",0.033701,"real_time_check"]]},"success":true}
    ```

- 获取指定巡检任务的巡检结果接口示例：

    ```
    curl -X 'GET' "http://127.0.0.1:8080/v1/api/summary/real-time-inspection?spec_id=5&instance=127.0.0.1:5432" -H 'accept: application/json' -H "Authorization: bearer xxx"
    ```

如果使用HTTPS协议，则查询示例：

    ```
    curl -X 'GET' "https://127.0.0.1:8080/v1/api/summary/real-time-inspection?spec_id=5&instance=127.0.0.1:5432" -H 'accept: application/json' -H "Authorization: bearer xxx" --cacert xx.crt --key xx.key --cert xx.crt
    ```

返回结构与[智能巡检接口返回结构](#zh-cn_topic_0000001714949077_li1189616251116)一致。

- 删除指定的巡检任务接口示例：

    ```
    curl -X 'DELETE' "http://127.0.0.1:8080/v1/api/app/real-time-inspection? spec_id=5&instance=127.0.0.1:5432" -H 'accept: application/json' -H "Authorization: bearer xxx"
    ```

如果使用HTTPS协议，则删除示例：

    ```
    curl -X 'DELETE' "https://127.0.0.1:8080/v1/api/app/real-time-inspection? spec_id=5&instance=127.0.0.1:5432" -H 'accept: application/json' -H "Authorization: bearer xxx" --cacert xx.crt --key xx.key --cert xx.crt
    ```

返回结构如下：

    ```
    {"data":{"success":true},"success":true}
    ```

### 自定义阈值参数

- 自定义阈值传参方式，各告警类型对应的key如[表1](#zh-cn_topic_0000001714949077_table1895281092115)所示：

**表 1**  告警类型以及对应的key

告警类型 持续上升 increase 超过阈值 threshold 预测超过阈值 forecast 文件类型有误 ftype

  - 启用默认告警配置（505.1.0之前的版本）

        ```
        {
        "system_resource": [
        "os_mem_usage"
        ],
        "instance_status": [],
        "database_resource": [],
        "database_performance": [],
        "diagnosis_optimization": []
        }
        ```

  - 启用默认告警配置（505.1.0及之后版本）

        ```
        {
        "system_resource": [
        {
        "os_mem_usage": true
        }
        ],
        "instance_status": [],
        "database_resource": [],
        "database_performance": [],
        "diagnosis_optimization": []
        }
        ```

  - 不启用告警

        ```
        {
        "system_resource": [
        {
        "os_mem_usage": false
        }
        ],
        "instance_status": [],
        "database_resource": [],
        "database_performance": [],
        "diagnosis_optimization": []
        }
        ```

  - 启用自定义告警。如下所示，os\_mem\_usage启用持续上升告警、自定义设置阈值告警和预测阈值告警；os\_disk\_usage不启用持续上升告警、阈值告警、启用预测阈值告警。

        ```
        {
        "system_resource": [
        {
        "os_mem_usage": {
        "increase": true,
        "threshold": [0.0, 0.8],
        "forecast": [1440, 0.0, 0.8]
        },
        "os_disk_usage": {
        "forecast": [1440, 0.0, 0.8]
        }
        }
        ],
        "instance_status": [],
        "database_resource": [],
        "database_performance": [],
        "diagnosis_optimization": []
        }
        ```

- 部分巡检项不支持自定义配置阈值：组件异常、日志异常检查、数据库Top Query、长事务、oldestXmin长时间未推进、Core dump、GUC参数。
- 各个巡检项支持的阈值类型见[概述](#概述)中自定义阈值表格，前端传入不支持的告警类型会报错。
- 对于部分巡检项，存在子巡检项，如[表2](#zh-cn_topic_0000001714949077_table76804585243)所示：

**表 2**  巡检项及子巡检项

巡检项 子巡检项 os_cpu_usage cpu_user cpu_iowait user_login_out login logout db_latency p95 p80 db_transaction commit rollback db_exec_statement select update insert delete db_tps tps qps dynamic_memory dynamic_used_memory dynamic_used_shrctx

当子巡检项的告警配置一致时，可以省略重复值，具体方式如下：

  - 重复设置os\_cpu\_usage阈值自定义

        ```
        {
        "system_resource": [
        {
        "os_cpu_usage": {
        "cpu_user": {
        "increase": false,
        "threshold": [],
        "forecast": [1440, 0.0, 0.8]
        },
        "cpu_iowait": {
        "increase": false,
        "threshold": [],
        "forecast": [1440, 0.0, 0.8]
        }
        }
        }
        ],
        "instance_status": [],
        "database_resource": [],
        "database_performance": [],
        "diagnosis_optimization": []
        }
        ```

  - 简化设置os\_cpu\_usage阈值自定义

        ```
        {
        "system_resource": [
        {
        "os_cpu_usage": {
        "increase": false,
        "threshold": [],
        "forecast": [1440, 0.0, 0.8]
        }
        }
        ],
        "instance_status": [],
        "database_resource": [],
        "database_performance": [],
        "diagnosis_optimization": []
        }
        ```

### 巡检项结果返回值示例

- 数据库实例

以1主DN、2备DN为例，共3个节点：

主DN：127.0.0.1:19996

备DN：127.0.0.2:19996, 127.0.0.3:19996

- 返回结构类型
  - ①：以节点为key：\{"127.0.0.1": xxx, "127.0.0.2": xxx, "127.0.0.3": xxx\}
  - ②：以DN为key：\{"127.0.0.1:19996": xxx, "127.0.0.2:19996": xxx, "127.0.0.3:19996": xxx\}
  - ③：以DB为key：\{"db1": xxx, "db2": xxx, "db3": xxx\}
  - ④：返回list: \[\{xxx\}\]

巡检项对应的返回结构如[表3](#zh-cn_topic_0000001714949077_table13634114013376)所示。

**表 3**  巡检项返回结构

巡检项 返回结构 os_cpu_usage 两层结构，子巡检项：cpu_user、cpu_iowait。
os_disk_ioutils os_disk_usage os_mem_usage network_packet_loss 两层结构，展示节点到节点的网络状况。
component_error data_directory log_directory db_size buffer_hit_rate user_login_out 两层结构，子巡检项：login、logout。
active_session_rate log_error_check thread_pool db_latency 两层结构，子巡检项：p80、p95。
db_transaction 两层结构，子巡检项：commit、rollback。
db_tmp_file db_exec_statement 两层结构，子巡检项：select、update、insert、delete。
db_deadlock db_tps 两层结构，子巡检项：qps、tps。
db_top_query long_transaction xmin_stuck xlog_accumulate core_dump dynamic_memory 两层结构，子巡检项：dynamic_used_memory、dynamic_used_shrctx。
process_memory other_memory guc_params

>[!NOTE]说明
>巡检结果会存储到DBMind元数据库中，DBMind会定期清除老数据以避免磁盘膨胀。

## 命令参考

**表 1**  智能巡检接口

API 参数介绍 请求方法 功能描述与预期返回结果 /v1/api/app/real-time-inspection inspection_type start_time end_time instance inspection_items 巡检类型，String，必选。
起始时间，String，可选。
终止时间，String，可选。
时区信息，String，可选。
实例IP:PORT，String，必选。
巡检项，dict，必选。
POST 执行智能巡检功能并返回巡检结果。
/v1/api/app/real-time-inspection/list instance 实例IP:PORT，String，必选。
GET 展示巡检任务的基础信息。
/v1/api/summary/real-time-inspection instance spec_id 实例IP:PORT，String，必选。
巡检任务ID，String，必选。
GET 获取指定巡检任务的巡检结果。
/v1/api/app/real-time-inspection instance spec_id 实例IP:PORT，String，必选。
巡检任务ID，String，必选。
DELETE 删除指定的巡检任务。

## 常见问题处理

- 月报与周报生成基于日报：如果未构建日报，则无法生成周报与月报；当日报数量不满足连续7天时，无法生成这7天对应的周报；当日报数量不满足连续14天以上时，无法生成对应的月报。此外，周报和月报的生成基于实例，比如出现实例IP和port的变化，会导致周报/月报无法生成；比如节点实例被删除，会导致周报/月报无法生成。采用定时方式生成周报和月报时，建议控制并发量，避免影响实时任务。配置文件中需要将实例的ip映射关系写到ip\_map中，否则无法保证巡检结果的实例为管理IP。
- 周报和月报仅支持所有巡检项的巡检，不支持部分巡检项的拼接；因此周报和月报的自定义阈值需要由前端传入，规则与实时巡检等一致，没有传入的巡检项默认不进行告警（除了部分由前端控制的巡检项，见[使用指导](#使用指导)）
- 调用巡检接口时需要传递实例，该实例需要为数据库实例主节点实例，否则在节点出现异常时无法返回所有节点的巡检结果。
- 智能巡检中db\_size、buffer\_hit\_rate、db\_tmp\_file、db\_deadlock、db\_transaction等巡检项仅展示主节点的数据库结果，如果出现主备切换等主节点切换的情况，可能出现结果跳变（不同节点的结果拼接）。
- 智能巡检中db\_size、buffer\_hit\_rate、db\_transaction、db\_tmp\_file、db\_deadlock等巡检项仅展示主节点的数据库结果；user\_login\_out、db\_latency、thread\_pool等巡检项展示所有节点的结果；xlog\_accumulate巡检项展示所有节点的结果。
- log\_error\_check和core\_dump两个巡检项防止遗漏关键信息，在实时巡检时仅支持45小时内数据；其他巡检项不能超过TSDB数据存储范围。
