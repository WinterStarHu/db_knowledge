# 获取帮助

用户可以通过“--help”命令获取Exporter组件启动或停止等操作的帮助信息，例如：

```
gs_dbmind component opengauss_exporter --help
gs_dbmind component reprocessing_exporter --help
gs_dbmind component cmd_exporter --help
```

自研Exporter组件状态查询和修复的RESTful API列表如下：

## opengauss-exporter

**表 1**  opengauss-exporter组件RESTful API列表

API 参数介绍 请求方法 功能描述与预期返回结果 GET，POST exporter基本信息。
/info GET，POST 采集的实例信息。
/metrics GET 按Prometheus协议封装的单次采集指标数据。
/v1/api/check-status cmd 组件启动命令，String，必选。
POST 获取exporter组件的状态信息并返回状态详情。
/v1/api/repair cmd 组件启动命令，String，必选。
POST 修复exporter组件并返回修复结果。
/rpc json结构体 username DBMind Agent用户名，String，必选。
POST DBMind主服务Agent挂载接口，用于主服务连接业务实例远程执行SQL，私有接口。
pwd DBMind Agent密码，Sting，必选。
funcname DBMind RPC功能选项，String，必选。
args DBMind RPC功能参数，list，必选。
kwargs DBMind RPC功能kv参数，dict，必选。
_jsonable 接口json结构体私有标识，bool，必选。
_dtype 接口数据类型私有标识，tuple，必选。

## cmd-exporter

**表 2**  cmd-exporter组件RESTful API列表

API 参数介绍 请求方法 功能描述与预期返回结果 GET，POST exporter基本信息。
/metrics GET 按Prometheus协议封装的单次采集指标数据。
/v1/api/check-status cmd 组件启动命令，String，必选。
POST 获取exporter组件的状态信息并返回状态详情。
/v1/api/repair cmd 组件启动命令，String，必选。
POST 修复exporter组件并返回修复结果。

## reprocessing-exporter

**表 3**  reprocessing-exporter组件RESTful API列表

API 参数介绍 请求方法 功能描述与预期返回结果 GET，POST exporter基本信息。
/metrics GET 按Prometheus协议封装的单次采集指标数据。
/v1/api/check-status cmd 组件启动命令，String，必选。
POST 获取exporter组件的状态信息并返回状态详情。
/v1/api/repair cmd 组件启动命令，String，必选。
POST 修复exporter组件并返回修复结果。
