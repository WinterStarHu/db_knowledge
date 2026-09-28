# DBMind的AI子功能

用户可以通过gs\_dbmind的component子命令启动对应的AI子功能，下述章节展示不同AI功能的具体内容和使用详情。

## DBMind定时任务

DBMind内嵌了可定期拉起并自动执行的定时任务，可以在DBMind的配置文件confpath/dbmind.conf中开启或关闭特定的定时任务。DBMind已经支持的定时任务，以及其对应的简要说明，可以在dbmind.conf中的\[TIMED\_TASK\_LIST\]中查看。

- 要开启一个定时任务：在dbmind.conf中的\[TIMED\_TASK\_LIST\]中找到要开启的定时任务的名称，然后将其编辑加入\[TIMED\_TASK\]的TASK字段中并保存，用","分割多个定时任务。例如，要开启"清理元数据库中的超期数据"的定时任务，可以在\[TIMED\_TASK\]的TASK字段中编辑加入"discard\_expired\_results"。
- 要关闭一个定时任务：在dbmind.conf中的\[TIMED\_TASK\]的TASK字段中，将需要关闭的定时任务编辑删除并保存。

在dbmind.conf中\[TIMED\_TASK\]的其他字段下可以自行配置各个定时任务自动执行周期，如：配置"discard\_expired\_results\_interval"对应的值，可以对应地修改“清理元数据库中的超期数据”定时任务的自动执行周期。

修改配置文件后运行如下命令使修改生效：

```
gs_dbmind service reload -c confpath
```

**表 1**  DBMind内嵌的定时任务说明

定时任务名称 定时任务说明 定时任务自动执行周期配置字段 默认自动执行周期（秒） 是否默认启动 额外说明 anomaly_detection 异常检测 anomaly_detection_interval 180 不建议关闭，否则将无法进行实时指标异常监控，历史告警将停止更新。
discard_expired_results 清理元数据库中的超期数据 discard_expired_results_interval 3600 不建议关闭，否则元数据中存储的时效性数据，如历史告警、历史集群诊断记录将持续增长，元数据库大小将持续膨胀。
knob_recommend 参数推荐 knob_recommend_interval 3600 slow_query_killer 慢SQL查杀 slow_query_killer_interval 不支持备机上的查杀操作。
slow_query_diagnosis 慢SQL诊断 slow_query_diagnosis_interval 120 cluster_diagnose 集群诊断 cluster_diagnose_interval 不建议关闭，否则将无法进行实时集群异常诊断，历史集群诊断列表将停止更新。
agent_update_detect Agent自动检测 agent_update_detect_interval 不建议关闭，该定时任务可定时检测实例的纳管情况，从而在纳管实例发生变化时（如主备倒换、增加纳管、减少纳管、扩缩容等）及时更新异常检测器的检测范围。
calibrate_security_metrics 自安全指标校准 calibrate_security_metrics_interval 600 check_security_metrics 自安全异常检测 check_security_metrics_interval 600 update_statistics 长周期监控指标统计值计算 update_statistic_interval 1800 不建议关闭，否则长周期持久化存储的指标将停止更新，影响亚健康相关的诊断结果。

- **[X-Tuner](x_tuner_parameter_tuning_and_diagnosis.md)**

- **[Index-advisor](index_advisor_index_recommendation.md)**

- **[Slow Query Diagnosis](slow_query_diagnosis_root_cause_analysis_for_slow_sql_statements.md)**

- **[SQLdiag](sqldiag_slow_sql_discovery.md)**

- **[SQL Rewriter](sql_rewriter_sql_statement_rewriting.md)**

- **[Anomaly detection](anomaly_detection.md)**

- **[Cluster Diagnosis](cluster_diagnosis.md)**

- **[智能巡检](intelligent_inspection.md)**
