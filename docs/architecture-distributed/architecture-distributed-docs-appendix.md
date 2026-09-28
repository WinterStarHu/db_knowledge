# 附录

>[!NOTE]说明
>
>API的参数分为可选和必选两类，但是DBMind针对部分必选参数设置了默认值。DBMind后台在收到用户请求后首先会对参数进行校验，其中也包括检查是否有必选参数未传递的情况。因此，当一个参数既是必选参数，又没有默认值，用户又没有传入时，请求会在参数校验阶段报错。

DBMind进程启动后，其提供的HTTP\(S\)接口信息如下：

**表 1**  DBMind Restful API列表

API 请求方法 功能描述 返回值 /v1/api/token POST 获取数据库访问令牌。
param username：必选，用户名。param grant_type：可选，授权类型。param password：必选，密码。param scope：必选，数据库实例。param client_id：可选，客户端id。param client_secret：可选，客户端密钥。
返回token。
{"access_token":"qmWWgt28VSu0YAH5","token_type":"bearer","expires_in":600} /v1/api/agents GET 获取所有代理列表。
返回所有代理列表。
{"data":{"ip1":["ip1","ip2","ip3"]} /v1/api/agents PUT 更新代理信息（包含强制更新） param force：可选，强制更新。
返回更新代理结果。
{"data":true,"success":true} /v1/api/app/slow-sql-rca POST 获取慢SQL的根因分析结果。
param query：必选，SQL查询语句，字符串长度需小于10240。param db_name：必选，数据库名称。param schema_name：可选，schema名称，默认为public。param start_time：可选，13位时间戳，建议传递，开始时间。param finish_time：可选，13位时间戳，建议传递，结束时间。param template_id：可选，建议传递，归一化SQL ID。param debug_query_id：可选，建议传递，唯一SQL ID。param n_soft_parse：可选，软解析次数。param n_hard_parse：可选，硬解析次数。param query_plan: 建议传递，执行计划。param n_returned_rows：可选，结果中元组个数。param n_tuples_fetched：可选，随机扫描行数。param n_tuples_returned：可选，顺序扫描行数。param n_tuples_inserted：可选，插入行数。param n_tuples_updated：可选，更新行数param n_tuples_deleted：可选，删除行数。param n_blocks_fetched：可选，buffer的块访问次数。param n_blocks_hit：可选，buffer的块命中次数。param db_time：可选，有效的DB时间花费，单位：微秒。param cpu_time：可选，CPU时间，单位：微秒。param parse_time：可选，解析时间，单位：微秒。param plan_time：可选，执行时间，单位：微秒。param data_io_time：可选，IO时间，单位：微秒。param hash_spill_count：可选，hash过程中，若发生落盘，写文件的次数。param sort_spill_count：可选，sort过程中，若发生落盘，写文件的次数。param n_calls：可选，调用次数。param lock_wait_time：可选，加锁等待耗时。param lwlock_wait_time：可选，轻量级加锁时间。param tz：可选，若存在时区差异则建议传递，慢SQL时区信息，只支持UTC标准。
返回慢SQL的根因分析结果。
{"data":[true,"public","Seq Scan on t2  (cost=0.00..3.25 rows=1 width=70)\n  Filter: (c1 = 'dadsadasds'::text)\n",[[["1. MISSING_INDEXES: (0.53) Missing required index.","2. HEAVY_SCAN_OPERATOR: (0.47) Existing expensive seq scans. Detail: (name: Seq Scan on t2, parent: None, rows:t2(100), cost rate: 100.0%)"]],[["1. Recommended index: (schema: public, index: t2(c1)).","2. According to business adjustments, try to avoid it"]]]],"success":true} /v1/api/app/risk-analysis/{metric} POST 获取风险分析结果。
param metric：必选，metric名称。param instance：必选，实例地址。param warning_hours：可选，风险分析时长。param upper：可选，metric的上限。param lower：可选，metric的下限。param labels：可选，metric的标签。支持如下两种格式：“k1=v1,k2=v2”的kv pairs格式；“{'k1':'v1','k2':'v2'}”的json字符串格式；
param tz：可选，时区参数，只支持UTC标准。
返回当前指标未来风险分析结果。
{"data":{},"success":true} /v1/api/app/anomaly-detection/detectors/{name} PUT 添加新的异常检测检测器或修改当前检测器。
param name：必选，检测器的名称 需要传入json结构体:
"duration": 10, "forecasting_seconds": 0, "alarm_info": { "alarm_type": "SYSTEM", "alarm_level": "ERROR" "detector_info": [ "detector_name": "EsdTestDetector", "metric_name": "openGauss_blks_hit_ratio", "detector_kwargs": { "alpha": 0.05 detector_info字段下检测算法的可选范围及对应检测参数，见表格下方说明。
返回添加状态： 成功返回 Success: add {检测器名称} for {数据库实例IP}失败返回 Failed: add {检测器名称} for {数据库实例IP} {"data":"Success: add detector for IP","success":true} /v1/api/app/anomaly-detection/detectors/{name} DELETE 删除指定的异常检测检测器。
param name：必选，检测器的名称。
返回删除状态。
{"data":"Success: delete detector for IP","success":true} /v1/api/app/anomaly-detection/detectors/{name}/pause PUT 暂停指定的异常检测检测器。
param name：必选，检测器的名称。
返回暂停状态。
{"data":"Success: pause detector for IP","success":true} /v1/api/app/anomaly-detection/detectors/{name}/resume PUT 继续指定的异常检测检测器。
param name：必选，检测器的名称。
返回继续状态。
{"data":"Success: resume detector for IP","success":true} /v1/api/app/anomaly-detection/detectors/{name} GET 查看指定的异常检测检测器信息。
param name：必选，检测器的名称。
返回异常检测器信息。
{"data":{"alarm_info":{"alarm_cause":null,"alarm_content":null,"alarm_level":"ERROR","alarm_type":"SYSTEM","extra":null},"detector_info":[...],"duration":10,"forecasting_seconds":0,"running":1},"success":true} /v1/api/app/anomaly-detection/detectors/all/rebuild PUT 根据后端落盘信息重建所有异常检测检测器。
返回重建状态。
{"data":"Success: rebuild detectors for IP","success":true} /v1/api/app/workload-collection POST 获取数据库工作负载数据。
param data_source：必选，数据源，取值范围：('asp', 'dbe_perf.statement_history', 'pg_stat_activity')。param databases：可选，数据库列表。param schemas：可选，schema列表。param start_time：可选，开始时间。param end_time：可选，结束时间，仅适用于asp和dbe_perf.statement_history。param db_users：可选，数据库用户列表。param sql_types：可选，SQL语句类型，取值范围：('SELECT', 'UPDATE', 'DELETE', 'INSERT')。param template_id：可选，SQL模板id。param duration：可选，SQL语句的执行时间，单位ms，仅适用于dbe_perf.statement_history和pg_stat_activity。
返回工作负载信息。
{"data":{"header":["user_name","db_name","schema_name","application_name","unique_query_id","start_time","finish_time","duration","n_returned_rows","n_tuples_fetched","n_tuples_returned","n_tuples_inserted","n_tuples_updated","n_tuples_deleted","n_blocks_fetched","n_blocks_hit","n_soft_parse","n_hard_parse","db_time","cpu_time","parse_time","plan_time","data_io_time","lock_wait_time","lwlock_wait_time","query"],"rows":[["user1","db1","public"...]...]},"success":true} /v1/api/summary/metrics GET 获取所有指标列表。
返回TSDB上的所有指标列表。
{"data":["openGauss_blks_hit_ratio","openGauss_blks_read_rate"...],"success":true} /v1/api/summary/metrics/{name} GET 获取最新的指定名称序列的指标。
param name：必选，指定metric的名称。param instance：可选，metric所属的实例地址。param latest_minutes：可选，指定的时间范围。param from_timestamp：可选，开始时间时间戳，适用于latest_minutes为空的情况。param to_timestamp：可选，结束时间时间戳，适用于latest_minutes为空的情况。param step：可选，获取数据的时间间隔，单位为毫秒，正整数Prometheus约束查询结果的时序序列中不得多于11000个点，如果该参数选择的值相较于时间区间过小，会引入该报错风险。。param fetch_all：可选，是否获取所有序列或只获取一次。param regex：可选，当instance非空，用正则表达式过滤instanceparam labels：可选，用指定标签过滤序列。支持如下两种格式：“k1=v1,k2=v2”的kv pairs格式；“{'k1':'v1','k2':'v2'}”的json字符串格式。
param regex_labels：可选，使用正则表达式过滤序列。支持如下两种格式：k1=v1,k2=v2”的kv pairs格式；“{'k1':'v1','k2':'v2'}”的json字符串格式。
param tz：可选，时区参数，只支持UTC标准。
返回指定序列的详情。
如果Prometheus短期内存入了大量数据，或者查询的区间过大，有可能导致查询超时，或由于内存不足导致查询失败。
{"data":[{"labels":{"device":"device","from_instance":"ip","from_job":"exporter","fstype":"ext4","instance":"ip:port","job":"exporter","mountpoint":"mounpoint"},"name":"os_disk_usage","timestamps":[1684900929939,1684900944939,1684900959939,1684900974939],"values":[0.7115459280083043,0.7115460512887748,0.7115461745692453,0.7115462978497158]}],"success":true} /v1/api/summary/alarms GET 获取历史告警列表。
param pagesize：可选，每页展示个数，建议传递。param current：可选，当前页，建议传递。param instance：可选，告警所属实例，如果不传递则返回当前集群内的告警。param alarm_type：可选，告警类型，参数可选范围为['SYSTEM', 'SLOW_QUERY', 'ALARM_LOG', 'ALARM', 'SECURITY', 'PERFORMANCE']。param alarm_level：可选，告警级别，参数可选范围为['CRITICAL', 'FATAL', 'ERROR', 'WARNING', 'WARN', 'INFO', 'NOTICE', 'DEBUG', 'NOTSET']。param metric_name：可选，指标名称。param start_at：可选，查询开始时间戳，建议传递。param end_at：可选，查询结束时间戳，建议传递。param anomaly_type：可选，异常类型。param group：可选，是否根据告警类型和内容划分告警。
返回历史告警列表。
{"data":{"header":["history_alarm_id","instance","metric_name","metric_filter","alarm_type","alarm_level","start_at","end_at","alarm_content","extra_info","anomaly_type","alarm_cause"],"rows":[[65,"ip","os_mem_usage",null,"SYSTEM",30,1684762097001,1684762547001,"mem_usage_spike_detector:Find obvious spikes in memory usage.",null,"Spike"]]},"success":true} /v1/api/summary/alarms/count GET 获取历史告警数量。
param instance：可选，告警所属实例，如果不传递则返回当前集群内的告警。param alarm_type：可选，告警类型，参数可选范围为：['SYSTEM', 'SLOW_QUERY', 'ALARM_LOG', 'ALARM', 'SECURITY', 'PERFORMANCE']。param alarm_level：可选，告警级别，参数可选范围为：['CRITICAL', 'FATAL', 'ERROR', 'WARNING', 'WARN', 'INFO', 'NOTICE', 'DEBUG', 'NOTSET']。param metric_name：可选，指标名称。param start_at：可选，查询开始时间戳，不得晚于end_at，建议传递。param end_at：可选，查询结束时间戳，不得早于start_at，建议传递。param anomaly_type：可选，异常类型。param group：可选，是否根据告警类型和内容划分告警。
返回历史告警数量。
{"data":30,"success":true} /v1/api/app/index-recommendation POST 获取建议的索引列表。
param instance：必选，数据库实例。param database：可选，数据库名称。param max_index_num：可选，推荐索引个数的最大值。param max_index_storage：可选，推荐索引的内存使用的最大值。param sqls：必选，SQL语句列表。
返回建议的索引列表。
{"data":[{"advise_indexes":[],"redundant_indexes":[],"total":0,"useless_indexes":[{"columns":"c1","schemaName":"public","statement":"DROP INDEX t1_c1_idx;","tbName":"t1","type":3},{"columns":"c2","schemaName":"public","statement":"DROP INDEX t2_c2_idx;","tbName":"t2","type":3}]},{}],"success":true}

>[!NOTE]说明
>
>在调用/v1/api/app/anomaly-detection/detectors/\{name\}接口，使用PUT方法新增或修改异常检测器时，需要将检测器信息以json的形式传入，其中的detecor\_info字段下的detector\_name检测算法以及对应的detector\_kwargs检测算法超参数字段的参数范围可以参考如下说明：
>
>- 学生化残差检测器-EsdTestDetector：\{"alpha":0.05\}。
>- 梯度检测器-GradientDetector：\{"max\_coef":1,"side":\["positive",\["positive","negative","both"\]\]\}。
>- 单调趋势检测器-IncreaseDetector：\{"alpha":null,"side":\["positive",\["positive","negative","both"\]\]\}。
>- 四分位间距检测器-InterQuartileRangeDetector：\{"outliers":\[3,3\]\}。
>- 均值漂移检测器-LevelShiftDetector：\{"agg":\["median",\["median","mean","std"\]\],"outliers":\[null,6\], "side":\["both",\["positive","negative","both"\]\],"window":5\}。
>- 分位数检测器-QuantileDetector：\{"high":1,"low":0\}。
>- 周期数据检测器-SeasonalDetector：\{"high\_ac\_threshold":0.1,"min\_seasonal\_freq":2,"outliers":\[null,3\], "period":null,"side":\["positive,\["positive","negative","both"\]\],"window":10\}"。
>- 尖峰检测器-SpikeDetector：\{"agg":\["median",\["median","mean","std"\]\],"outliers":\[null,3\], "side":\["both",\["positive","negative","both"\]\],"window":1\}。
>- 阈值检测器-ThresholdDetector：\{"high":null,"low":null,"percentage":\[null,\[0,1\]\]\}。
>- 波动率漂移检测器-VolatilityShiftDetector：\{"agg":\["std",\["median","mean","std"\]\],"outliers":\[null,6\], "side":\["both",\["positive","negative","both"\]\],"window":10\}。
>此外，在检测器信息json中还会包含alarm\_info告警信息字段，其中的两个子字段alarm\_type告警类型和alarm\_level告警级别的相关补充说明如下，使用/v1/api/summary/alarms接口或/v1/api/summary/alarms/count接口查询落盘的异常告警结果详情或数量时，可以使用上述两个参数字段对结果进行进一步筛选：
>- alarm\_level参数的所有级别及其对应的权重：CRITICAL、FATAL：50，ERROR：40，WARNING、WARN：30，INFO、NOTICE：20，DEBUG：10、NOTSET：0。
>- alarm\_type参数的所有类型：SYSTEM、SLOW\_QUERY、ALARM\_LOG、ALARM、SECURITY、PERFORMANCE。
>查询异常告警时，还可以通过anomaly\_type字段对异常类型进行筛选。

## 微服务模式接口

DBMind以微服务化模式启动后，具备如下几个特征：

- 与全服务模式不同，微服务模式时无需进行用户管理，因此使用DBMind接口时不再需要身份认证与Token鉴权机制；
- 由于无需身份认证，因此在此模式下强制使用HTTPS的双向认证以保证服务与数据安全；
- 由于无需身份认证与用户管理，因此该模式下的全部接口的实例信息都为必选参数，通过该参数在相应的实例执行相应的任务；

鉴于上述特征，即使接口功能相同，微服务模式下的接口为单独开放的接口，与全服务模式下接口不互通，只有在DBMind以微服务模式启动时才支持调用。通过API的路由版本前缀区分两种模式下的接口，全服务为v1前缀，微服务为v2前缀。其提供的HTTPS接口信息如下：

**表 2**  DBMind微服务Restful API列表

API 请求方法 功能描述 返回值 /v2/api/app/slow-sql-rca POST 获取慢SQL的根因分析结果 param query：必选，SQL查询语句，字符串长度需小于10240。param db_name：必选，数据库名称。param schema_name：可选，schema名称，默认为public。param start_time：可选，13位时间戳，建议传递，开始时间。param finish_time：可选，13位时间戳，建议传递，结束时间。param template_id：可选，建议传递，归一化SQL ID。param debug_query_id：可选，建议传递，唯一SQL ID。param n_soft_parse：可选，软解析次数，默认为0。param n_hard_parse：可选，硬解析次数，默认为0。param query_plan：可选，执行计划。param n_returned_rows：可选，结果中元组个数，默认为0。param n_tuples_fetched：可选，随机扫描行数，默认为0。param n_tuples_returned：可选，顺序扫描行数，默认为0。param n_tuples_inserted：可选，插入行数，默认为0。param n_tuples_updated：可选，更新行数，默认为0。param n_tuples_deleted：可选，删除行数，默认为0。param n_blocks_fetched：可选，buffer的块访问次数，默认为0。param n_blocks_hit：可选，buffer的块命中次数，默认为0。param db_time：可选，有效的DB时间花费，单位：微秒，默认为0。param cpu_time：可选，CPU时间，单位：微秒，默认为0。param parse_time：可选，解析时间，单位：微秒，默认为0。param plan_time：可选，执行时间，单位：微秒，默认为0。param data_io_time：可选，IO时间，单位：微秒，默认为0。param hash_spill_count：可选，hash过程中，若发生落盘，写文件的次数，默认为0。param sort_spill_count：可选，sort过程中，若发生落盘，写文件的次数，默认为0。param n_calls：必选，调用次数，默认为1。param lock_wait_time：可选，加锁等待耗时，默认为0。param lwlock_wait_time：可选，轻量级加锁时间，默认为0。param tz: 可选，若存在时区差异则建议传递，慢SQL时区信息，只支持UTC标准。需要传入json结构体，用于连接数据库： 'host': 必选，需要执行慢SQL诊断任务的数据库IP, 'port': 必选，需要执行慢SQL诊断任务的数据库端口, 'user': 必选，需要执行慢SQL诊断任务的数据库用户名, 'pwd': 必选，需要执行慢SQL诊断任务的数据库用户密码 返回慢SQL的根因分析结果。
{"data":["Seq Scan on t1  (cost=0.00..1868.00 rows=100 width=70)\n",[[["1. HEAVY_SCAN_OPERATOR: (1.00) Existing expensive seq scans. Detail:..."]]...]],"success":true} /v2/api/app/correlation POST 获取性能指标相关性分析结果 param metric_name：必选，metric名称。param instance：必选，实例地址。param start_time：必选，开始时间的时间戳，选取指标该时间戳后的值。param end_time：必选，结束时间的时间戳，选取指标该时间戳前的值。start_time和end_time是两个独立参数，并非为选取时间窗口，所以不强制要求start_time早于end_time。param metric_filter: 可选，metric的标签。 支持如下两种格式：“k1=v1,k2=v2”的kv pairs格式。“{'k1':'v1','k2':'v2'}”的json字符串格式。
返回异常关联指标及其时序数据。
{"data":{"os_mem_usage from ip":[["gs_total_memory_detail_mbytes{\"nodename\": \"dn_6001_6002\", \"type\": \"dynamic_used_memory\"} from ip",1.0,0,[0.32950820234487...]]...]},"success":true} /v2/api/app/risk-analysis/{metric} POST 获取风险分析结果 param metric：必选，metric名称。param instance：必选，实例地址。param warning_hours：可选，风险分析时长，默认为1。param upper：可选，metric的上限。param lower：可选，metric的下限。param labels：可选，metric的标签。支持如下两种格式：“k1=v1,k2=v2”的kv pairs格式。“{'k1':'v1','k2':'v2'}”的json字符串格式。
param tz：可选，时区参数，只支持UTC标准。
返回当前指标未来风险分析结果。
{"data": {"os_disk_usage": [{"abnormal_detail": "No risk identified.","forecast_timestamps": null,"forecast_values": null,"labels": {"device": "/dev/sdd1","from_instance": "ip","from_job": "node_exporter","fstype": "xfs","instance": "ip","job": "reprocessing_exporter","mountpoint": "/data3"},"timestamps": [1733382426553553...],"values": [0.6772665517200114...]}]},"success": true} /v2/api/app/workload-collection POST 获取数据库工作负载数据 param data_source：必选，数据源，取值范围：('asp', 'dbe_perf.statement_history', 'pg_stat_activity')。param databases：可选，数据库列表。param schemas：可选，schema列表。param start_time：可选，开始时间。param end_time：可选，结束时间，仅适用于asp和dbe_perf.statement_history。param db_users：可选，数据库用户列表。param sql_types：可选，SQL语句类型，取值范围：('SELECT', 'UPDATE', 'DELETE', 'INSERT')。param template_id：可选，SQL模板id。param duration：可选，SQL语句的执行时间，单位ms，仅适用于dbe_perf.statement_history和pg_stat_activity，默认为60。
需要传入json结构体，用于连接数据库： 'host': 必选，需要执行工作负载采集的数据库IP, 'port': 必选，需要执行工作负载采集的数据库端口, 'user': 必选，需要执行工作负载采集的数据库用户名, 'pwd': 必选，需要执行工作负载采集的数据库用户密码 返回工作负载信息。
{"data":{"header":["user_name","db_name","schema_name","application_name","unique_query_id","start_time","finish_time","duration","n_returned_rows","n_tuples_fetched","n_tuples_returned","n_tuples_inserted","n_tuples_updated","n_tuples_deleted","n_blocks_fetched","n_blocks_hit","n_soft_parse","n_hard_parse","db_time","cpu_time","parse_time","plan_time","data_io_time","lock_wait_time","lwlock_wait_time","query"],"rows":[["user1","db1","public"...]...]},"success":true} /v2/api/summary/alarms GET 获取历史告警列表 param pagesize：可选，每页展示个数，建议传递，默认为20。param current：可选，当前页，建议传递，默认为0。param instance：必选，告警所属实例，如果不传递则返回当前集群内的告警。param alarm_type：可选，告警类型，参数可选范围为['SYSTEM', 'SLOW_QUERY', 'ALARM_LOG', 'ALARM', 'SECURITY', 'PERFORMANCE']。param alarm_level：可选，告警级别，参数可选范围为['CRITICAL', 'FATAL', 'ERROR', 'WARNING', 'WARN', 'INFO', 'NOTICE', 'DEBUG', 'NOTSET']。param metric_name：可选，指标名称。param start_at：可选，查询开始时间戳，建议传递。param end_at：可选，查询结束时间戳，建议传递。param anomaly_type：可选，异常类型。param group：可选，是否根据告警类型和内容划分告警，默认为False。
返回历史告警列表。
{"data":{"header":["history_alarm_id","instance","metric_name","metric_filter","alarm_type","alarm_level","start_at","end_at","alarm_content","extra_info","anomaly_type","alarm_cause"],"rows":[[65,"ip","os_mem_usage",null,"SYSTEM",30,1684762097001,1684762547001,"mem_usage_spike_detector:Find obvious spikes in memory usage.",null,"Spike"]]},"success":true} /v2/api/summary/alarms/count GET 获取历史告警数量 param instance：必选，告警所属实例，如果不传递则返回当前集群内的告警。param alarm_type：可选，告警类型，参数可选范围为['SYSTEM', 'SLOW_QUERY', 'ALARM_LOG', 'ALARM', 'SECURITY', 'PERFORMANCE']。param alarm_level：可选，告警级别，参数可选范围为['CRITICAL', 'FATAL', 'ERROR', 'WARNING', 'WARN', 'INFO', 'NOTICE', 'DEBUG', 'NOTSET']。param metric_name：可选，指标名称。param start_at：可选，查询开始时间戳，不得晚于end_at，建议传递。param end_at：可选，查询结束时间戳，不得早于start_at，建议传递。param anomaly_type：可选，异常类型。param group：可选，是否根据告警类型和内容划分告警。
返回历史告警数量。
{"data":30,"success":true} /v2/api/summary/cluster-diagnosis GET 获取历史集群诊断列表 param pagesize：可选，每页展示个数，建议传递，默认为20。param current：可选，当前页，建议传递，默认为0。param instance：必选，实例IP，如果不传递则返回当前集群内的诊断结果。param start_at：可选，查询开始时间戳，仅返回timestamp大于等于该时间戳的结果，建议传递。param end_at：可选，查询结束时间戳，仅返回timestamp小于等于该时间戳的结果，建议传递。若start_at和end_at都不传递，则不对timestamp列进行任何值的筛选，返回全量时间戳的结果。param cluster_role：可选，节点类型，参数可选范围为['cn', 'dn']。param diagnosis_method：可选，诊断算法，参数可选范围为['tree', 'logical']。param alarm_type：可选，告警类型，参数可选范围为['SYSTEM', 'SLOW_QUERY', 'ALARM_LOG', 'ALARM', 'SECURITY', 'PERFORMANCE']。param alarm_level：可选，告警级别，参数可选范围为['CRITICAL', 'FATAL', 'ERROR', 'WARNING', 'WARN', 'INFO', 'NOTICE', 'DEBUG', 'NOTSET']。param is_normal：可选，是否包含诊断结果为Normal的数据，默认为True。
返回历史集群诊断列表。
{"data":{"header":["diagnosis_id","instance","timestamp","cluster_role","diagnosis_method","cluster_feature","diagnosis_result","status_code","alarm_type","alarm_level"],"rows":[[1,ip,1695110107087,"cn","logical","{\"ping\": 0, \"cn_status\": 0, \"bind_ip_failed\": 0, \"panic\": 0, \"ffic_updated\": 0, \"cms_heartbeat_restart\": 0, \"cms_phonydead_restart\": 0, \"cn_dn_disconnected\": 0, \"cn_down_to_delete\": 0, \"cn_restart_time_exceed\": 0, \"cn_read_only\": 0, \"cn_restart\": 0, \"cn_start\": 0, \"cn_manual_stop\": 0, \"cn_disk_damage\": 0, \"cn_nic_down\": 0, \"cn_port_conflict\": 0}","Normal",-1,"ALARM",0]]},"success":true} /v2/api/summary/cluster-diagnosis/count GET 获取历史集群诊断数量 param instance：可选，实例IP，如果不传递则返回当前集群内的诊断结果。param start_at：可选，建议传递，查询开始时间戳，仅返回timestamp大于等于该时间戳的结果，建议传递。param end_at：可选，建议传递，查询结束时间戳，仅返回timestamp小于等于该时间戳的结果，建议传递。若start_at和end_at都不传递，则不对timestamp列进行任何值的筛选，返回全量时间戳的结果。param cluster_role：可选，节点类型，参数可选范围为['cn', 'dn']。param diagnosis_method：可选，诊断算法，参数可选范围为['tree', 'logical']。param alarm_type：可选，告警类型，参数可选范围为['SYSTEM', 'SLOW_QUERY', 'ALARM_LOG', 'ALARM', 'SECURITY', 'PERFORMANCE']。param alarm_level：可选，告警级别，参数可选范围为['CRITICAL', 'FATAL', 'ERROR', 'WARNING', 'WARN', 'INFO', 'NOTICE', 'DEBUG', 'NOTSET']。param is_normal：可选，是否包含诊断结果为Normal的数据，默认为True。
返回历史集群诊断数量。
{"data":30,"success":true} /v2/api/app/index-recommendation POST 获取建议的索引列表 param database：必选，数据库名称。param max_index_num：可选，推荐索引个数的最大值。param max_index_storage：可选，推荐索引的内存使用的最大值。
需要传入json结构体，用于连接数据库与传入需要推荐索引的工作负载： 'host': 必选，需要执行索引推荐的数据库IP, 'port': 必选，需要执行索引推荐的数据库端口, 'user': 必选，需要执行索引推荐的数据库用户名, 'pwd': 必选，需要执行索引推荐的数据库用户密码， 'sqls':必选，需要执行索引推荐的工作负载列表 返回建议的索引列表。
{"data":[{"advise_indexes":[],"redundant_indexes":[],"total":0,"useless_indexes":[{"columns":"c1","schemaName":"public","statement":"DROP INDEX t1_c1_idx;","tbName":"t1","type":3},{"columns":"c2","schemaName":"public","statement":"DROP INDEX t2_c2_idx;","tbName":"t2","type":3}]},{}],"success":true} /v2/api/summary/database-list GET 获取数据库列表 param instance：必选，需要获取数据库列表的实例。
返回数据库列表。
{"data":["db1","db2","db3","db4","db5"...],"success":true} /v2/api/app/metric-diagnosis POST 执行指标异常诊断 param metric_name：必选，指标名称。取值范围：os_cpu_user_usage，     pg_thread_pool_rate，os_mem_usage，os_disk_usage，mount_usage，os_disk_await，xlog_margin，pg_long_transaction_count。param metric_filter：必选，筛选指标。支持如下两种格式：“k1=v1,k2=v2”的kv pairs格式；“{'k1':'v1','k2':'v2'}”的json字符串格式。
param alarm_cause：必选，选择分析方法。取值范围：high_cpu_usage,  high_thread_pool_rate,  high_dynamic_mem_usage,  high_shared_mem_usage,  high_disk_usage, high_io_delay，mem_leak，high_xlog_count，long_transaction。param start：必选，分析指标开始时间戳，单位毫秒。param end：必选，分析指标结束时间戳，单位毫秒。
返回指标异常根因。
{"data":{[{'reason1': 0.0, 'reason2': 1.0}, 'conclusion', 'advice']},"success":true} /v2/api/summary/sql-trace GET SQL全链路查询 param instance_id：必选，实例id。param labels：必选，过滤使用的指标标签。param is_online：必选，数据来源是否是在线的。param from_timestamp：可选，查询开始时间。param to_timestamp：可选，查询结束时间。param tz：可选，时区参数，仅支持UTC标准。
返回SQL全链路信息。
"data": [ "all_time": 3477357, "application_name": "xxx", "client_addr": "", "client_port": 0, "component_id": "xxx", "db_name": "xxx", "execution_time_details": { "kernel_time": { "all_time": 3477357, "kernel_time_details": { "execution_time": 3466386, "other_time": 4958, "parse_time": 453, "plan_time": 5244, "rewrite_time": 316 "resource_time": { "all_time": 3477357, "resource_time_details": { "cpu_time": 98756, "data_io_time": 0, "other_time": 3378601 "wait_event_time": { "code_wait_event_time": { "all_time": 3477357, "code_wait_event_time_details": { "events": [ "event_name": "xxx", "event_time": 16810 "event_name": "xxx", "event_time": 5330 "event_name": "xxx", "event_time": 5195 "event_name": "xxx", "event_time": 197 "left_time": 0, "other_time": 3449825 "resource_wait_event_time": { "all_time": 3477357, "other_time": 3477357, "resource_wait_event_time_details": { "data_io_time": { "all_time": 0, "data_io_time_details": { "events": [ "event_name": "xxx", "event_time": 742 "left_time": 0, "other_time": -27532 "lock_time": { "all_time": 0, "lock_time_details": { "events": [], "left_time": 0, "other_time": 0 "lwlock_time": { "all_time": 0, "lwlock_time_details": { "events": [], "left_time": 0, "other_time": 0 "finish_time": "2023-08-01 17:50:04.923701+08", "node_id": "0", "schema_name": "user,public", "session_id": 1658590, "sql_exec_id": 72339069024193250, "sql_id": 1951225884, "start_time": "2023-08-01 17:50:01.446446+08", "trace_id": "0", "transaction_id": "0", "user_name": "user" "success": true /v2/api/summary/metric-unit/{metric} GET 指标单位单位查询 param metric：必选，指标名。
返回指标单位。
{"data":"{'en': 'rate', 'cn': '比率'}","success":true} /v2/api/app/metric-diagnosis-insight POST 获取指标异常诊断的额外信息 param metric_name：必选，指标名称。取值范围：os_cpu_user_usage，     pg_thread_pool_rate，os_mem_usage，os_disk_usage，mount_usage，os_disk_await，xlog_margin，pg_long_transaction_count。param metric_filter：必选，筛选指标。支持如下两种格式：“k1=v1,k2=v2”的kv pairs格式；“{'k1':'v1','k2':'v2'}”的json字符串格式。
param alarm_cause：必选，选择分析方法。取值范围：high_cpu_usage,  high_thread_pool_rate,  high_dynamic_mem_usage,  high_shared_mem_usage,  high_disk_usage, high_io_delay，mem_leak，high_xlog_count，long_transaction。param start：必选，分析指标开始时间戳，单位毫秒。param end：必选，分析指标结束时间戳，单位毫秒。
需要传入json结构体，用于连接数据库： 'host': 必选，需要执行指标异常诊断的数据库IP, 'port': 必选，需要执行指标异常诊断的数据库端口, 'user': 必选，需要执行指标异常诊断的数据库用户名, 'pwd': 必选，需要执行指标异常诊断的数据库用户密码 返回指标异常根因的额外信息。
{"data":{"insight_1":[{"k1":v1,"k2":v2,...},{"k1":v1,"k2":v2,...},...],"insight_2":[{"k1":v1,"k2":v2,...},{"k1":v1,"k2":v2,...},...]},..."success":true} /v2/api/app/timed-tasks POST 触发一次指定的定时任务 param task_name：必选，需要触发的定时任务名，参数可选范围为['discard_expired_results','anomaly_detection','cluster_diagnose','update_statistics']。需要传入json结构体，用于设定定时任务的执行参数： 'cn': 定时任务为cluster_diagnose时，与'dn'字段至少其中一个必选，需要执行集群诊断任务的cn ip列表，默认为空， 'dn': 定时任务为cluster_diagnose时，与'cn'字段至少其中一个必选，需要执行集群诊断任务的dn ip列表，默认为空， "detector_name": 定时任务为anomaly_detection时必选，异常检测器的名字，默认为空， "duration": 定时任务为anomaly_detection时必选，异常检测截取指标的时间窗口，单位为秒，默认为600, "alarm_info": 定时任务为anomaly_detection时必选，告警详细信息，共有四个字段 "alarm_content":告警内容， "alarm_type": 告警类型，参数可选范围为['SYSTEM', 'SLOW_QUERY', 'ALARM_LOG', 'ALARM', 'SECURITY', 'PERFORMANCE'] "alarm_level": 告警级别，参数可选范围为['CRITICAL', 'FATAL', 'ERROR', 'WARNING', 'WARN', 'INFO', 'NOTICE', 'DEBUG', 'NOTSET'] "alarm_cause": 告警原因， "detector_info": 定时任务为anomaly_detection时必选，检测逻辑信息，一个检测器可以叠加多个检测逻辑，为一个列表值，其中每一项代表一个检测逻辑，每一项共有四个字段 [{"metric_name": 检测的指标名， "detector_name":  检测算法，参数可选范围为['GradientDetector', 'IncreaseDetector', 'InterQuartileRangeDetector', 'LevelShiftDetector', 'SeasonalDetector', 'SpikeDetector', 'ThresholdDetector', 'VolatilityShiftDetector', 'QuantileDetector', 'EsdTestDetector', 'ForecastingAnomalyDetector'] "metric_filter": 指标标签筛选条件， "detector_kwargs": 检测算法超参数 }], 返回定时任务执行情况。
{"data":{"msg": "The task {task_name} has been successfully executed."}, 'success':true}

>[!NOTE]说明
>
>DBMind在微服务模式下启动时为无状态运行，对纳管的实例不感知。因此，在使用DBMind的V2接口时，后台依然会对涉及实例地址的相关参数进行校验，但仅限于IP合法性校验，无法校验该实例是否被纳管。如果DBMind后台通过用户提供的实例地址进行指标查询与计算时出现查询结果为空的情况，DBMind无法判断是该指标确实为空还是用户输入的实例地址参数有误。

## 指标单位查询接口

/v1/api/summary/metric-unit/\{metric\}支持的自研指标列表如[表3](#table12110048191610)所示，部分由开源组件node\_exporter以及Prometheus采集的指标和云原生未开放采集的自研指标暂不展示：

**表 3**  自研指标说明

指标说明 opengauss_exporter_fixed_info opengauss-exporter结构化信息 os_cpu_iowait_usage CPU等I/O占比 os_cpu_system_usage CPU系统使用占比 os_cpu_idle_usage CPU空闲占比 os_cpu_processor_num CPU核数 os_cpu_user_usage CPU用户使用占比 os_disk_await 磁盘读写I/O时长 os_disk_io_read_bytes 磁盘I/O读字节数 os_disk_io_write_bytes 磁盘I/O写字节数 os_disk_iops 磁盘I/O频率 os_disk_io_queue_length 磁盘I/O队列长度 os_disk_io_read_delay 磁盘I/O读时延 os_disk_io_write_delay 磁盘I/O写时延 os_disk_ioutils 磁盘I/O时间占比 os_disk_usage 磁盘用量 os_network_receive_bytes 网络收字节数 os_process_fds_rate 占用中的文件描述符占比 os_mem_usage 内存用量 os_network_transmit_bytes 网络发字节数

## DBMind定时任务

DBMind内嵌了可定期拉起并自动执行的定时任务，可以在DBMind的配置文件confpath/dbmind.conf中开启或关闭特定的定时任务。DBMind已经支持的定时任务，以及其对应的简要说明，可以在dbmind.conf中的\[TIMED\_TASK\_LIST\]中查看。

- 要开启一个定时任务：在dbmind.conf中的\[TIMED\_TASK\_LIST\]中找到要开启的定时任务的名称，然后将其编辑加入\[TIMED\_TASK\]的TASK字段中并保存，用","分割多个定时任务。例如，要开启"清理元数据库中的超期数据"的定时任务，可以在\[TIMED\_TASK\]的TASK字段中编辑加入"discard\_expired\_results"。
- 要关闭一个定时任务：在dbmind.conf中的\[TIMED\_TASK\]的TASK字段中，将需要关闭的定时任务编辑删除并保存。

在dbmind.conf中\[TIMED\_TASK\]的其他字段下可以自行配置各个定时任务自动执行周期，如：配置"discard\_expired\_results\_interval"对应的值，可以对应地修改“清理元数据库中的超期数据”定时任务的自动执行周期。

修改配置文件后运行如下命令使修改生效：

```
gs_dbmind service reload -c confpath
```

**表 4**  DBMind内嵌的定时任务说明

定时任务名称 定时任务说明 定时任务自动执行周期配置字段 默认自动执行周期（秒） 是否默认启动 额外说明 anomaly_detection 异常检测 anomaly_detection_interval 180 不建议关闭，否则将无法进行实时指标异常监控，历史告警将停止更新。
discard_expired_results 清理元数据库中的超期数据 discard_expired_results_interval 3600 不建议关闭，否则元数据中存储的时效性数据，如历史告警、历史集群诊断记录将持续增长，元数据库大小将持续膨胀。
agent_update_detect Agent自动检测 agent_update_detect_interval 不建议关闭，该定时任务可定时检测实例的纳管情况，从而在纳管实例发生变化时（如主备倒换、增加纳管、减少纳管、扩缩容等）及时更新异常检测器的检测范围。
update_statistics 长周期监控指标统计值计算 update_statistic_interval 1800 不建议关闭，否则长周期持久化存储的指标将停止更新，影响亚健康相关的诊断结果。

## DBMind的元数据库结构

DBMind元数据库是储存DBMind各类运行数据的数据库，其数据结构如下。

**表 5**  tb\_anomaly\_detectors列说明

detector_id 检测器id cluster_name 集群名称（ip1:port1, ip2:port2） detector_name 检测器名称 alarm_cause 根因分析手段 alarm_content 异常内容 alarm_level 异常级别 alarm_type 异常类型 extra 额外信息 detector_info 检测器信息 duration 检测时间窗口长度 forecasting_seconds 预测时长 running 运行状态

**表 6**  tb\_existing\_indexes列说明

索引id instance 节点地址 db_name 数据库名 tb_name columns index_stmt 索引表达式

**表 7**  tb\_healing\_records列说明

记录id instance 节点地址 trigger_events 触发事件 trigger_root_causes 触发事件原因 action called_method 引用方法 success 成功与否 detail occurrence_at 发生时间

**表 8**  tb\_high\_availability\_status列说明

高可用记录 instance 节点地址 timestamp 时间戳 interface_type 事件类型 interface_info 事件信息

**表 9**  tb\_history\_alarms列说明

history_alarm_id 告警id instance 节点地址 metric_name 指标名称 metric_filter 指标过滤器 alarm_type 异常类型 alarm_level 异常级别 start_at 异常开始时间 end_at 异常结束时间 alarm_content 告警内容 extra_info 额外信息 anomaly_type 检测器名 alarm_cause 根因分析手段

**表 10**  tb\_history\_cluster\_diagnosis列说明

diagnosis_id 集群诊断记录id instance 节点地址 timestamp 时间戳 cluster_role 集群角色 diagnosis_method 诊断方法 cluster_feature 模型输入 diagnosis_result 诊断结果 status_code 诊断结果状态码 alarm_type 异常类型 alarm_level 异常级别

**表 11**  tb\_index\_recommendation列说明

索引推荐记录id instance 节点地址 db_name 数据库名 schema_name schema名 tb_name columns optimized 是否优化 index_type 索引类型 stmt_count 语句数量 select_ratio select语句比例 insert_ratio insert语句比例 update_ratio update语句比例 delete_ratio delete语句比例 index_stmt 索引表达式

**表 12**  tb\_index\_recommendation\_stats列说明

索引推荐统计id instance 节点地址 db_name 数据库名 recommend_index_count 推荐索引数量 redundant_index_count 冗余索引数量 invalid_index_count 异常索引数量 stmt_count 语句数量 positive_stmt_count 正向语句数量 table_count 表数量 stmt_source 语句来源 occurrence_time 发生时间

**表 13**  tb\_index\_recommendation\_stmt\_details列说明

索引推荐表达式细节id instance 节点地址 db_name 数据库名 index_id 索引id template_id 模板id stmt optimized 是否优化 correlation_type 相关性类型 stmt_count 语句数量

**表 14**  tb\_index\_recommendation\_stmt\_templates列说明

索引推荐语句模板id instance 节点地址 db_name 数据库名 template

**表 15**  tb\_knob\_recommendation\_details列说明

参数推荐细节id instance 节点地址 name 优化项 current 当前值 recommend 推荐值 min 最小值 max 最大值 restart 是否重启

**表 16**  tb\_knob\_recommendation\_metric\_snapshot列说明

参数推荐快照id instance 节点地址 metric 指标名 value

**表 17**  tb\_knob\_recommendation\_warnings列说明

参数推荐告警id instance 节点地址 comment 告警内容 level 告警级别

**表 18**  tb\_metric\_statistics列说明

stat_id 指标统计id metric_name 指标名称 method 统计方法 length 保留长度 step start 开始时间戳 metric_filter 指标过滤项 value_list 数值表

**表 19**  tb\_regular\_inspections列说明

巡检id instance 节点地址 inspection_type 巡检类型 report conclusion start 开始时间 end 结束时间 state 节点状态 cost_time 耗费时长

**表 20**  tb\_security\_anomaly\_values列说明

安全异常检测id host 节点地址 metric_name 指标名称 metric_time 监测时间 metric_value 指标值

**表 21**  tb\_security\_metric\_models列说明

安全异常检测模型id host 节点地址 metric_name 指标名称 parameter_name 参数名 parameter_value 参数值 time_saved 模型保存时间

**表 22**  tb\_slow\_queries列说明

slow_query_id 慢查询id instance 节点地址 schema_name schema名 db_name 数据库名 query 查询语句 query_type 查询类型 involving_systable 涉及的系统表 template_id 模板id hashcode1 哈希码1 hashcode2 哈希码2 insert_at 插入时间 hit_rate buffer命中率 fetch_rate 语句fetch率 cpu_time cpu计算时长 data_io_time 数据io时长 plan_time 计划时长 parse_time 解析时长 db_time 数据库内部时长 root_cause suggestion

**表 23**  tb\_slow\_queries\_journal列说明

journal_id 慢查询日报id slow_query_id 慢查询id start_at 开始时间 round_start_at 开始日期 duration_time 持续时长 instance 节点地址

**表 24**  tb\_killed\_slow\_queries列说明

killed_query_id 被查杀的慢查询id instance 节点地址 db_name 数据库名 query 查询语句 killed 是否被查杀 username 用户名 elapsed_time 花费时间 killed_time 被查杀时间
