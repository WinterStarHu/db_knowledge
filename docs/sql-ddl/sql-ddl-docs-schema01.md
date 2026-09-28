# Schema

openGauss支持的Schema如下表所示。

**表 1**  openGauss支持的Schema

Schema名称 blockchain 用于存储账本数据库特性中创建防篡改表时自动创建的用户历史表。
cstore 该模式用于储存列存表相关的辅助表如cudesc或者delta表。
db4ai 用于管理AI训练中不同版本的数据信息。
dbe_perf DBE_PERF Schema内视图主要用来诊断性能问题，也是WDR Snapshot的数据来源。数据库安装后，默认只有初始用户和监控管理员具有模式dbe_perf的权限，有权查看该模式下的视图和函数。
dbe_pldeveloper 用于记录PLPGSQL包、函数及存储过程中需要记录的信息。
dbe_sql_util 用于管理SQL PATCH的工具，包括创建、删除、开启、禁用SQL PATCH等系统函数。
dbe_pldebugger 用于调试plpgsql函数及存储过程。
snapshot 用于管理WDR snapshot的相关的数据信息，默认初始化用户或监控管理员用户可以访问。
sqladvisor 用于分布列推荐，openGauss不可用。
public 公共模式，缺省时，创建的表（以及其它对象）自动放入该模式。
pkg_service 用于管理package服务相关信息。
coverage 用于记录存储过程覆盖率相关信息。
