# component子命令

该子命令可以用于启动DBMind的子组件（或插件），包括可用于监控指标的exporter，以及AI功能等。该命令可以将用户通过命令行传入的命令转发给对应的子组件，故不同的子组件命令需参考其功能的对应说明，详见后文各个子组件对应章节，此处不再赘述。

## 命令参考

用户可以通过“--help”选项获得该模式的帮助信息，例如：

```
gs_dbmind component --help
```

```
usage:  component [-h] COMPONENT_NAME ...

positional arguments:
  COMPONENT_NAME  choice a component to start. For centralized/distributed instance: ['anomaly_detection', 'cluster_diagnosis', 'cmd_exporter', 'dkr', 'extract_log', 'index_advisor', 'opengauss_exporter',
                  'reprocessing_exporter', 'slow_query_diagnosis', 'sql_rewriter', 'sqldiag', 'xtuner'], for cloud-native instance: ['opengauss_exporter', 'reprocessing_exporter', 'sqldiag']
  ARGS            arguments for the component to start

optional arguments:
  -h, --help      show this help message and exit
```

**表 1**  gs\_dbmind component 子命令说明

参数说明 取值范围 COMPONENT_NAME 子组件（即插件）名。
'opengauss_exporter', 'reprocessing_exporter', 'sqldiag' ARGS 子组件的参数。
参考子组件的命令说明。
-h, --help 帮助命令。
