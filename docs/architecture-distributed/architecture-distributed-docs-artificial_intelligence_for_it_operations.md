# 智能运维

## 前置操作

在使用智能运维之前，需要先注册集群，注册集群后绑定用户需要诊断的集群。另外，还需要绑定用户需要使用的大语言模型。

以用户ID为test\_user，会话ID为test\_session，集群实例地址为10.x.x.x:1为例。

### 注册、绑定集群

1. 注册集群

    ```
    curl -X 'POST' 'https://x.x.x.x:x/v1/api/clusters/register' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt -d '{ "cluster_name": "cluster1", "host": "10.x.x.x", "port": "1", "username": "user", "password": "db_password"}' --pass "***"
    ```

2. 绑定集群

    ```
    curl -X 'PUT' 'https://x.x.x.x:x/v1/api/clusters?instance=10.x.x.x:1&user_id=test_user&session_id=test_session' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
    ```

如果返回结果中data值为True，说明绑定成功。如果需要换绑其他集群，仅需修改instance参数值，重新调用该接口即可。如果用户创建新会话，不重新绑定集群的话，默认使用上次绑定的集群。
> 注意：user_id和session_id需满足一定的复杂度要求，（1）长度：2 ~ 120 个字符；（2）字符集 ：仅字母、数字、下划线（ [a-zA-Z0-9_] ）；（3）不允许空格、中文、特殊符号（ - . @ 等都不行）。

### 绑定大语言模型

1. 查询可用的大语言模型

    ```
    curl -X 'GET' 'https://x.x.x.x:x/v1/api/llms' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
    ```

2. 绑定大语言模型

    ```
    curl -X 'PUT' 'https://x.x.x.x:x/v1/api/llms?name=xxx&user_id=xxx&session_id=xxx' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
    ```

如果返回结果中data值为True，说明绑定成功。如果需要换绑其他大语言模型，仅需修改name参数值，重新调用该接口即可。

如果不绑定大语言模型，直接调用app/intelligent-interaction接口，使用配置文件中默认配置的大语言模型。

## 工具交互

在用户进行工具交互前，需要先执行完成[前置操作](#0000002258589378)，之后可以使用问答的方式对GaussMaster服务进行提问，后台接口为/v1/api/app/intelligent-interaction。此接口参数“mode”的值必须为“tool\_interaction”，即当前模式为工具交互，API详情请参考[API: /v1/api/app/intelligent-interaction](#section95391566019)。工具交互默认支持多轮对话，对话记录长度为1轮。用户可以通过参数"history\_len"指定对话记录的长度，可支持的对话记录长度为\[1-3\]，即大语言模型最多可以记住3轮对话历史。

工具交互的流程图如下[图1](#fig518531224414)所示：

**图 1**  工具交互流程图 ![](figures/工具交互流程图.png)

### 工具交互约束

1. 用户可以使用华为云提供的pangu-38b开源模型工具，识别准确率为90%。也可以指定其他开源模型，通过接口的形式进行调用，使用其他开源模型做工具交互时，识别准确率无法保证。
2. 智能运维中工具交互支持参数追问，参数不全时可基于历史内容进行补全。
3. DBMind/openGauss组件不可用/升级等场景下，GaussMaster服务会受到影响。
4. GaussMaster智能运维不提供前台页面，且目前只支持中文问答。

当前内部已支持的DBmind工具（API）共22个（其中告警查询需要用到DBMind的两个API），如下表：

**表 1**  API列表

API接口 关键信息 对话示例 /v1/api/status/data-directory
- instance：str类型，必要参数，需要查询的数据库的数据节点的ip和port
数据库实例，数据库数据目录状态。
查询10.90.56.xxx:xxx的数据目录状态。
/v1/api/app/workload-collection?data_source=dbe_perf.statement_history
- start_time：str类型，必要参数，通过SQL语句的开始时间对SQL语句进行筛选，格式为%Y-%m-%d %H:%M:%S
- end_time：str类型，必要参数，通过SQL语句的结束时间对SQL语句进行筛选，格式为%Y-%m-%d %H:%M:%S
- database：str类型，非必要参数，通过SQL语句运行的数据库名对SQL语句进行筛选，未指定默认为None
- schema:  str类型，非必要参数，通过SQL语句运行的数据库模式对SQL语句进行筛选，未指定默认为None
开始时间、结束时间、数据库名（非必须）、 schema（非必须）。
查询test_db数据库中上午10点到11点的sql列表。
/v1/api/app/workload-collection?data_source=pg_stat_activity
- database：str类型，非必要参数，通过SQL语句运行的数据库名对SQL语句进行筛选，未指定默认为None
- schema:  str类型，非必要参数，通过SQL语句运行的数据库模式对SQL语句进行筛选，未指定默认为None
数据库名，正在执行的SQL。
查询test_db数据库中当前正在执行的SQL。
/v1/api/summary/sql/top None 执行频繁的SQL。
查询top SQL。
/v1/api/summary/sql/locking None 锁等待、阻塞、SQL。
查询当前被阻塞的SQL。
/v1/api/summary/alarms和/v1/api/summary/cluster-diagnosis
- start_time：str类型，必要参数，用来筛选告警的时间范围的开始时间，格式为%Y-%m-%d %H:%M:%S
- end_time：str类型，必要参数，用来筛选告警的时间范围的结束时间，格式为%Y-%m-%d %H:%M:%S
开始时间、结束时间、查询告警。
查询今天10点到12点的告警。
/v1/api/agents None 查询纳管集群信息。
查询当前纳管的所有集群信息。
/v1/api/status/instances None 数据库实例状态。
查询当前数据库实例状态。
/v1/api/summary/database-list None 查询数据库列表。
查询当前实例下所有的数据库列表。
/v1/api/summary/knob-recommendation/snapshots None 指标快照。
查询当前指标快照。
/v1/api/summary/knob-recommendation/details None 参数推荐详情。
查询参数推荐详情。
/v1/api/summary/knob-recommendation/warnings None 不合理或告警的指标配置。
查询当前不合理的指标配置。
/v1/api/status/overview None 数据库概览信息。
查询数据库概览。
/v1/api/summary/metrics/pg_settings_setting
- name:  str类型，必要参数，需要查询的GUC参数的名称
GUC参数名。
查询GUC参数wdr_snapshot_retention_days的值。
/v1/api/summary/metrics/{name}
- name:  str类型，必要参数，需要查询的GUC参数的名称
指标名、开始时间、结束时间。
查询指标os_mem_usage在今天上午8点到9点的数据。
/v1/api/app/slow-sql-rca
- query:  str类型，必要参数，需要进行SQL根因分析的查询语句SQL
- db_name:  str类型，必要参数，需要进行SQL根因分析的查询语句SQL所在的数据库名
sql语句、数据库名、慢SQL根因分析。
数据库test_db中有一条慢SQL：select * from t1 where id = 10000;请帮我进行根因分析。
/v1/api/app/cluster-diagnosis
- start_time：str类型，必要参数，进行集群诊断的时间点，格式为%Y-%m-%d %H:%M:%S
集群诊断、时间、实例ip地址 请帮忙对今天12点集群10.90.56.xxx的状态进行诊断。
/v1/api/app/metric-diagnosis-detail
- metric_name：str类型，必要参数，指标名
- alarm_cause：str类型，必要参数，告警原因
- start_time：str类型，必要参数，开始时间，格式为%Y-%m-%d %H:%M:%S
- end_time：str类型，必要参数，结束时间，格式为%Y-%m-%d %H:%M:%S
- metric_filter：str类型，非必要参数，指标过滤条件，要求格式为：key1=value1,key2=value2
指标诊断、指标名、告警原因、开始时间、结束时间、指标过滤条件（非必需）。
请帮忙诊断指标xlog_margin在上午8点到10点，发生告警high_xlog_count的原因。
/v1/api/app/memory-check
- latest_hours：int类型，非必要参数，对内存进行趋势预测的预测时长，默认值为4小时
内存情况，诊断时长。
请对最近1小时的内存情况进行分析。
/v1/api/app/index-recommendation
- sql：str类型，必要参数，需要进行索引推荐的查询语句SQL
- db_name：str类型，必要参数，需要进行索引推荐的查询语句SQL所在的数据库名
sql语句，数据库名。
请对test_db数据库中sql语句select * from t1 where id = 1000;进行索引推荐。
/v1/api/app/risk-analysis/{metric}
- metric：str类型，必要参数，用来指定需要被预测的指标名
- warning_hours：int类型，必要参数，需要趋势预测的未来的长度，单位：小时
风险分析或指标预测、指标名、预测时长。
对指标os_mem_usage未来2小时的状态进行预测。

### 工具交互参考示例

工具交互调用API详情如下：

```
curl -X 'POST' 'https://x.x.x.x:x/v1/api/app/intelligent-interaction' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{
"query":"数据库test_db中有条sql语句select* from t1 where id = 10000;请帮我进行一下索引推荐",
     "mode":"tool_interaction",
     "user_id":"user123",
     "session_id":"session123",
     "history_len ":1
}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

工具交互的结果以流式返回，结果中包含多行，每行以“data:”开头，以“\\n\\n”结尾：

```
data:{"data":[{"content":"工具匹配中...","type":"progress"}],"success":true}\n\n
data:{"data":[{"content":"提取参数中...","type":"progress"}],"success":true}\n\n
data:{"data":[{"content":"工具调用中...","type":"progress"}],"success":true}\n\n
data:{"data":[{"color":"black","content":"推荐的索引如下表所示：","type":"str"},{"content":{"headers":["索引描述","预计占用","预计提升"],"rows":[["CREATEINDEX idx_t1_id ON public.t1(id);","2.49MB","99.91%"]]},"type":"table"}],"success":true}\n\n
data:{"data":[{"content":"DONE","type":"progress"}],"success":true}\n\n
```

>[!NOTE]说明
>在工具交互的过程中，会在日志中记录各阶段的耗时，包括如下4个阶段：
>
>1. 推理工具。
>2. 推理参数。
>3. 调用工具。
>4. 调用大语言模型。
>日志级别为INFO，用户可以根据需要查看各阶段的耗时。

## API接口说明

本章节介绍智能运维模块提供的RESTful API接口。

### API: /v1/api/app/intelligent-interaction

功能描述：通过交互的方式使用运维工具。

请求方式：POST

参数及其解释：如下表所示：

**表 1**  接口参数说明

参数名 是否必填 query str 用户的问题。
user_id str 用户id，要求长度大于等于2，只能由字符、数字和下划线组成。
session_id str 会话id，要求长度大于等于2，只能由字符、数字和下划线组成。
mode str 交互类型，可选范围为['tool_interaction', 'fault_diagnostic']。
'tool_interaction'：工具交互模式。'fault_diagnostic'：故障诊断模式。
history_len int 历史对话轮数，默认为1，可选范围[1, 2, 3]。

返回结果类型：流式event

测试接口样例1：

```
curl -X 'POST' 'https://x.x.x.x:x/v1/api/app/intelligent-interaction' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{
"query":"数据库test_db中有条sql语句select* from t1 where id = 10000;请帮我进行一下索引推荐",
     "mode":"tool_interaction",
     "user_id":"user123",
     "session_id":"session123",
     "history_len":1
}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果格式：

```
data:{"data":[{"content":"工具匹配中...","type":"progress"}],"success":true}\n\n
data:{"data":[{"content":"提取参数中...","type":"progress"}],"success":true}\n\n
data:{"data":[{"content":"工具调用中...","type":"progress"}],"success":true}\n\n
data:{"data":[{"color":"black","content":"推荐的索引如下表所示：","type":"str"},{"content":{"headers":["索引描述","预计占用","预计提升"],"rows":[["CREATEINDEX idx_t1_id ON public.t1(id);","2.49MB","99.91%"]]},"type":"table"}],"success":true}\n\n
data:{"data":[{"content":"DONE","type":"progress"}],"success":true}\n\n
```

测试接口样例2（query参数值可通过工具交互的告警查询结果获取）：

```
curl -X 'POST' 'https://x.x.x.x:x/v1/api/app/intelligent-interaction' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{
     "query":"{\"history_alarm_id\": \"c_190471\", \"metric_name\": \"gaussdb_cluster_state\", \"instance\": \"10.90.56.xx\", \"alarm_type\": \"ALARM\", \"alarm_level\": 20, \"start_time\": \"2024-09-05 15:28:56\", \"alarm_content\": \"10.90.56.xx(dn   ): {\\\"ping\\\": 0, \\\"dn_status\\\": 1, \\\"bind_ip_failed\\\": 0, \\\"dn_ping_standby\\\": 0, \\\"ffic_updated\\\": 0, \\\"cms_phonydead_restart\\\": 0, \\\"cms_restart_pending\\\": 0, \\\"dn_read_only\\\": 0, \\\"dn_manual_stop\\\": 0, \\\"dn_disk_damage\\\": 0, \\\"dn_nic_down\\\": 0, \\\"dn_port_conflict\\\": 0, \\\"dn_writable\\\": 0} Unknown\", \"source\": \"dbmind\", \"status\": 0}",
     "mode":"fault_diagnostic",
     "model_name":"pangu",
     "user_id":"user123",
     "session_id":"session123"
}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果格式：

```
    data:{"data":[{"content":"查询故障树...","type":"progress"}],"success":true}
    data:{"data":[{"content":"异常告警信息识别中...","type":"progress"}],"success":true}
    data:{"data":[{"content":"参数识别中...","type":"progress"}],"success":true}
    data:{"data":[{"color":"black","content":"'cluster_feature'","type":"str"}],"success":true}
    data:{"data":[{"content":"DONE","type":"progress"}], "success": true}
```

异常情况：

```
    data:{"data":[{"content":"工具执行异常","type":"str"}],"success":true}\n\n
    data:{"data":[{"content":"大模型服务异常","type":"str"}],"success":true}\n\n
    data:{"data":[{"content":"运维知识库异常","type":"str"}],"success":true}\n\n
```

### API: /v1/api/llms

功能描述：获取所有可用的大语言模型列表。

请求方式：GET

参数及其解释：无

测试接口样例：

```
curl -X 'GET' 'https://x.x.x.x:x/v1/api/llms' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果格式：

获取成功1：

```
{"data":{"local":[],"online":["pangu_cloud_sigma_unify_plugin_38b","Llama3-8B-Chinese-Chat"]},"success":true}
```

获取成功2：

```
{"data":true,"success":true}
```

### API: /v1/api/llms

功能描述：切换大模型。

请求方式：PUT

参数及其解释：如下表所示：

**表 2**  接口参数说明

参数名 是否必填 name str 大模型名称。
user_id str 用户id，要求长度大于等于2，只能由字符、数字和下划线组成。
session_id str 会话id，要求长度大于等于2，只能由字符、数字和下划线组成。

测试接口样例：

```
curl -X 'PUT' 'https://x.x.x.x:x/v1/api/llms?name=pangu&user_id=xxx&session_id=xxx' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果格式：

切换成功：

```
{"data":true,"success":true}
```

切换失败1（模型切换失败的详细原因记录在日志中）：

```
{"data":false,"success":true}
```

切换失败2：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/clusters

功能描述：获取DBMind纳管的所有数据库集群信息。

请求方式：GET

参数及其解释：无

测试接口样例：

```
curl -X 'GET' 'https://x.x.x.x:x/v1/api/clusters' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果格式：

获取成功1：

```
{"data":{"x.x.x.x:x":{"cluster_name":"cluster1","intances":["x.x.x.x:x","x.x.x.x:x"],"managed":true},"x.x.x.x:x":{"cluster_name":"cluster2","intances":["x.x.x.x:x","x.x.x.x:x"],"managed":false}},"success":true}
```

获取成功2：

```
{"data":{},"success":true}
```

获取失败：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/clusters

功能描述：切换当前监控的数据库集群

请求方式：PUT

参数及其解释：如下表所示：

**表 3**  接口参数说明

参数名 是否必填 instance str 数据库实例ip地址，需要带端口号，例如：192.168.100.100:8080 user_id str 用户id，要求长度大于等于2，只能由字符、数字和下划线组成。
session_id str 会话id，要求长度大于等于2，只能由字符、数字和下划线组成。

测试接口样例：

```
curl -X 'PUT' 'https://x.x.x.x:x/v1/api/clusters?instance=x.x.x.x:x&user_id=xxx&session_id=xxx' -H 'accept: application/json' -H 'Content-Type: application/json' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果格式：

切换成功：

```
{"data":true,"success":true}
```

切换失败1：

```
{"data":false,"success":true}
```

切换失败2：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/clusters/register

功能描述：注册dbmind纳管范围的数据库集群。

请求方式：POST

参数及其解释：如下表所示：

**表 4**  接口参数说明

参数名 是否必填 cluster_name str 集群名称。
host str 数据库IP（集群内的任意一个IP即可）。
port int 端口。
username str 数据库用户名。
password str 数据库密码。

测试接口样例：

```
curl -X 'POST' 'https://x.x.x.x:x/v1/api/clusters/register' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{ "cluster_name": "cluster1", "host": "db_host_ip", "port": "5432", "username": "db_user", "password": "db_password"}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果格式

注册成功：

```
{"data":{"msg":"注册成功","status":0},"success":true}
```

注册集群的账号密码错误：

```
{"data":{"msg":"无法连接到此集群","status":503},"success":true}
```

注册集群不在dbmind纳管范围：

```
{"data":{"msg":"dbmind没有纳管此集群，无法注册","status":1001},"success":true}
```

注册集群的名字重复：

```
{"data":{"msg":"该集群名已被占用","status":1002},"success":true}
```

>[!NOTE]说明
>注册成功后，集群信息存储在集群管理表，表接口参考附录中[表6](appendix_gaussmaster.md#table56641357133711)。
