# 作业失败自动重试

## 可获得性

本特性自openGauss 1.0.0版本开始引入。

## 特性简介

批处理作业中，在由于网络异常、锁冲突等出错情况下能够保证作业自动重试。

## 客户价值

网络异常、锁冲突等出错场景下无需人工干预，自动对出错查询进行重试，提高了可用性。

## 特性描述

openGauss数据库提供作业重试机制gsql Retry。

gsql Retry，对于需要进行重试的错误使用唯一的错误码（SQL STATE）进行标识。对客户端工具gsql进行功能增强，使用错误码配置文件（retry\_errcodes.conf，置于和gsql同级的安装目录下）对需要重试的错误列表进行配置。gsql提供如下元命令来开启/关闭错误重试功能，重试次数设为范围为5\~10，缺省值为5。

```
set RETRY [number]
```

打开该功能时gsql会读取上述配置文件，错误重试控制器通过容器记录错误码列表。如果打开后出现配置文件中某一个错误，控制器会将每次缓存的查询语句重新发送给服务端进行重试，直到成功或超过重试次数报错。

## 特性增强

无。

## 特性约束

- 功能范围限制：

仅能提高故障发生时SQL语句执行成功率，不能保证100%的执行成功。

- 错误类型约束：

SQL语句出错时能够被识别和重试的错误，仅限在[表1](#table123551925257)中定义的错误。

**表 1**  支持的错误类型列表

错误类型 错误码 对端连接重置（CONNECTION_RESET_BY_PEER） YY001 TCP通信错误：Connection reset by peer 对端流重置（STREAM_CONNECTION_RESET_BY_PEER） YY002 TCP通信错误：Stream connection reset by peer（DN和DN间通信） 锁等待超时（LOCK_WAIT_TIMEOUT） YY003 锁超时，Lock wait timeout 连接超时（CONNECTION_TIMED_OUT） YY004 TCP通信错误，Connection timed out 查询设置错误（SET_QUERY_ERROR） YY005 SET命令发送失败，Set query error 超出逻辑内存（OUT_OF_LOGICAL_MEMORY） YY006 内存申请失败，Out of logical memory 通信库内存分配（SCTP_MEMORY_ALLOC） YY007 SCTP通信错误，Memory allocate error 无通信库缓存数据（SCTP_NO_DATA_IN_BUFFER） YY008 SCTP通信错误，SCTP no data in buffer 通信库释放内存关闭（SCTP_RELEASE_MEMORY_CLOSE） YY009 SCTP通信错误，Release memory close SCTP、TCP断开（SCTP_TCP_DISCONNECT） YY010 SCTP、TCP通信错误，SCTP、TCP disconnect 通信库断开（SCTP_DISCONNECT） YY011 SCTP通信错误，SCTP disconnect 通信库远程关闭（SCTP_REMOTE_CLOSE） YY012 SCTP通信错误，Stream closed by remote 等待未知通信库通信（SCTP_WAIT_POLL_UNKNOW） YY013 等待未知通信库通信，SCTP wait poll unknow 无效快照（SNAPSHOT_INVALID） YY014 快照非法，Snapshot invalid 通讯接收信息错误（ERRCODE_CONNECTION_RECEIVE_WRONG） YY015 连接获取错误，Connection receive wrong 内存耗尽（OUT_OF_MEMORY） 53200 内存耗尽，Out of memory 连接异常（CONNECTION_EXCEPTION） 08000 连接出现错误，和DN的通讯失败，Connection exception 管理员关闭系统（ADMIN_SHUTDOWN） 57P01 管理员关闭系统，Admin shutdown 关闭远程流接口（STREAM_REMOTE_CLOSE_SOCKET） XX003 关闭远程套接字，Stream remote close socket 重复查询编号（ERRCODE_STREAM_DUPLICATE_QUERY_ID） XX009 重复查询，Duplicate query id stream查询并发更新同一行（ERRCODE_STREAM_CONCURRENT_UPDATE） YY016 stream查询并发更新同一行，Stream concurrent update

- 语句类型约束：

支持单语句存储过程、函数、匿名块。不支持事务块中的语句。

- 存储过程语句约束：
  - 包含EXCEPTION的存储过程，如果在执行过程中（包含语句块执行和EXCEPTION中的语句执行）错误被抛出，可以retry，如果报错被EXCEPTION捕获则不能retry。
  - 不支持使用全局变量的高级包。
  - 不支持DBE\_TASK。
  - 不支持PKG\_UTIL文件操作。

- 数据导入约束：
  - 不支持COPY FROM STDIN语句。
  - 不支持gsql \\copy from元命令。
  - 不支持JDBC CopyManager copyIn导入数据。

## 依赖关系

该特性依赖gsql工具端可以正常工作、错误列表配置正确。
