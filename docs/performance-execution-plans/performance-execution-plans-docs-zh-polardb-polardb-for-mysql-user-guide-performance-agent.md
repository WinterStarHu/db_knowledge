# 使用Performance Agent采集与统计集群性能数据-云原生数据库 PolarDB-阿里云

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-mysql/user-guide/performance-agent

使用Performance Agent采集与统计集群性能数据-云原生数据库 PolarDB-阿里云

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

产品计费

产品规格

动态与公告

快速入门

PolarDB AI能力

用户指南

性能白皮书

最佳实践

安全合规

API参考

SDK下载

常见问题

视频专区

术语

相关协议

PolarDB MySQL版边缘集群

首页

云原生数据库 PolarDB

云原生数据库PolarDB MySQL版

用户指南

内核性能监控

Performance Agent

Performance Agent

更新时间：

复制 MD 格式

产品详情 我的收藏

Performance Agent是PolarDB提供的一种更加便捷的性能数据统计方案。通过PolarDB MySQL版插件的方式，实现PolarDB MySQL版集群中的节点内部各项性能数据的采集与统计。

前提条件

PolarDB集群版本需为PolarDB MySQL版8.0版本且Revision version为8.0.2.1.0或以上，您可以参见查询版本号确认集群版本。

loose_performance_schema参数已设置为ON。具体操作请参见设置集群参数和节点参数。
背景信息

Performance Agent在performance_schema系统库下新增了一张内存表PERF_STATISTICS，用于统计最近一段时间的性能数据，您可以直接查询该表获取相关指标的性能数据。

说明 您也可以通过开启performance_schema功能来细粒度监控集群在锁、事务、内存等各方面的性能指标。但是，由于开启performance_schema会占用大量的系统内存并在一定程度上影响集群的性能，故在PolarDB MySQL版中该功能默认关闭。如需开启performance_schema，建议您根据集群的规格资源谨慎配置performance_schema的各项指标。
参数说明 Performance Agent功能相关参数说明如下：

参数 说明

performance_agent_enabled 是否开启Performance Agent功能。取值为ON或OFF。默认值为ON。

performance_agent_interval 性能数据采集间隔。单位为秒，取值范围为1~60，默认值为1。

performance_agent_perfstat_volume_size PERF_STATISTICS表的最大数据条数。默认值为3600（即当采样间隔为1秒时，保存最近1小时的性能数据）。
表结构说明 PERF_STATISTICS内存表的结构如下： CREATE TEMPORARY TABLE `PERF_STATISTICS` ( `TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00', `PROCS_MEM_USAGE` double NOT NULL DEFAULT '0', `PROCS_CPU_RATIO` double NOT NULL DEFAULT '0', `PROCS_IOPS` double NOT NULL DEFAULT '0', `PROCS_IO_READ_BYTES` bigint(21) NOT NULL DEFAULT '0', `PROCS_IO_WRITE_BYTES` bigint(21) NOT NULL DEFAULT '0', `MYSQL_CONN_ABORT` int(11) NOT NULL DEFAULT '0', `MYSQL_CONN_CREATED` int(11) NOT NULL DEFAULT '0', `MYSQL_USER_CONN_COUNT` int(11) NOT NULL DEFAULT '0', `MYSQL_CONN_RUNNING` int(11) NOT NULL DEFAULT '0', `MYSQL_LOCK_IMMEDIATE` int(11) NOT NULL DEFAULT '0', `MYSQL_LOCK_WAITED` int(11) NOT NULL DEFAULT '0', `MYSQL_COM_INSERT` int(11) NOT NULL DEFAULT '0', `MYSQL_COM_UPDATE` int(11) NOT NULL DEFAULT '0', `MYSQL_COM_DELETE` int(11) NOT NULL DEFAULT '0', `MYSQL_COM_SELECT` int(11) NOT NULL DEFAULT '0', `MYSQL_COM_COMMIT` int(11) NOT NULL DEFAULT '0', `MYSQL_COM_ROLLBACK` int(11) NOT NULL DEFAULT '0', `MYSQL_COM_PREPARE` int(11) NOT NULL DEFAULT '0', `MYSQL_LONG_QUERY` int(11) NOT NULL DEFAULT '0', `MYSQL_TCACHE_GET` bigint(21) NOT NULL DEFAULT '0', `MYSQL_TCACHE_MISS` bigint(21) NOT NULL DEFAULT '0', `MYSQL_TMPFILE_CREATED` int(11) NOT NULL DEFAULT '0', `MYSQL_TMP_TABLES` int(11) NOT NULL DEFAULT '0', `MYSQL_TMP_DISKTABLES` int(11) NOT NULL DEFAULT '0', `MYSQL_SORT_MERGE` int(11) NOT NULL DEFAULT '0', `MYSQL_SORT_ROWS` int(11) NOT NULL DEFAULT '0', `MYSQL_BYTES_RECEIVED` bigint(21) NOT NULL DEFAULT '0', `MYSQL_BYTES_SENT` bigint(21) NOT NULL DEFAULT '0', `MYSQL_BINLOG_OFFSET` int(11) NOT NULL DEFAULT '0', `MYSQL_IOLOG_OFFSET` int(11) NOT NULL DEFAULT '0', `MYSQL_RELAYLOG_OFFSET` int(11) NOT NULL DEFAULT '0', `EXTRA` json NOT NULL DEFAULT 'null' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

列名 说明

TIME 时间（UTC），格式为yyyy-MM-dd HH:mm:ss。

PROCS_MEM_USAGE 物理内存使用量，单位为Byte。

PROCS_CPU_RATIO CPU使用率。

PROCS_IOPS 系统IO调用次数。

PROCS_IO_READ_BYTES IO读取数据量，单位为Byte。

PROCS_IO_WRITE_BYTES IO写入数据量，单位为Byte。

MYSQL_CONN_ABORT 断开连接数。

MYSQL_CONN_CREATED 新建连接数。

MYSQL_USER_CONN_COUNT 当前总的用户连接数。

MYSQL_CONN_RUNNING 当前活跃连接数。

MYSQL_LOCK_IMMEDIATE 当前锁占用数。

MYSQL_LOCK_WAITED 当前锁等待数。

MYSQL_COM_INSERT 插入语句数。

MYSQL_COM_UPDATE 更新语句数。

MYSQL_COM_DELETE 删除语句数。

MYSQL_COM_SELECT 查询语句数。

MYSQL_COM_COMMIT 事务提交数（显式提交）。

MYSQL_COM_ROLLBACK 事务回滚数。

MYSQL_COM_PREPARE 预处理语句数。

MYSQL_LONG_QUERY 慢查询数。

MYSQL_TCACHE_GET 缓存表命中数。

MYSQL_TCACHE_MISS 缓存表未命中数。

MYSQL_TMPFILE_CREATED 临时文件创建数。

MYSQL_TMP_TABLES 临时表创建数。

MYSQL_TMP_DISKTABLES 临时磁盘表创建数。

MYSQL_SORT_MERGE 合并排序次数。

MYSQL_SORT_ROWS 排序行数。

MYSQL_BYTES_RECEIVED 接收数据量，单位为Byte。

MYSQL_BYTES_SENT 发送数据量，单位为Byte。

MYSQL_BINLOG_OFFSET 产生的Binlog文件大小，单位为Byte。

MYSQL_IOLOG_OFFSET 主库发送的Binlog文件大小，单位为Byte。

MYSQL_RELAYLOG_OFFSET 从库应用的Binlog文件大小，单位为Byte。

EXTRA InnoDB统计信息。EXTRA包含多个字段，为JSON格式。详细字段介绍请参见下方EXTRA字段说明。

说明 InnoDB统计信息的指标项与SHOW STATUS命令显示的值相同。表 1. EXTRA字段说明

字段 说明

INNODB_TRX_CNT 事务数。

INNODB_DATA_READ 读取数据量，单位为Byte。

INNODB_IBUF_SIZE 合并记录页数。

INNODB_LOG_WAITS Log写入等待次数。

INNODB_MAX_PURGE 清除事务数。

INNODB_N_WAITING 锁等待数。

INNODB_ROWS_READ 读取数据行数。

INNODB_LOG_WRITES 日志写次数。

INNODB_IBUF_MERGES 合并次数。

INNODB_DATA_WRITTEN 写入数据量，单位为Byte。

INNODB_DBLWR_WRITES 双写操作写入次数。

INNODB_IBUF_SEGSIZE 当前插入缓冲大小。

INNODB_ROWS_DELETED 删除数据行数。

INNODB_ROWS_UPDATED 更新数据行数。

INNODB_COMMIT_TRXCNT 提交事务数。

INNODB_IBUF_FREELIST 空闲列表长度。

INNODB_MYSQL_TRX_CNT MySQL事务数。

INNODB_ROWS_INSERTED 插入数据行数。

INNODB_ACTIVE_TRX_CNT 活跃事务数。

INNODB_OS_LOG_WRITTEN 日志文件写入量，单位为Byte。

INNODB_ACTIVE_VIEW_CNT 活跃视图数。

INNODB_RSEG_HISTORY_LEN TRX_RSEG_HISTORY表长度。

INNODB_AVG_COMMIT_TRXTIME 平均事务提交时间。

INNODB_MAX_COMMIT_TRXTIME 最长事务提交时间。

INNODB_DBLWR_PAGES_WRITTEN 双写操作完成写入次数。
使用方法

您可以参见如下示例直接查询系统表，获取性能数据。

查询最近30秒的CPU和内存使用情况，示例如下： MySQL> select TIME, PROCS_MEM_USAGE, PROCS_CPU_RATIO from performance_schema.PERF_STATISTICS order by time DESC limit 30;
+---------------------+-----------------+-----------------+
| TIME                | PROCS_MEM_USAGE | PROCS_CPU_RATIO |
+---------------------+-----------------+-----------------+
| 2020-02-27 11:15:36 |       857812992 |           18.55 |
| 2020-02-27 11:15:35 |       857808896 |           18.54 |
| 2020-02-27 11:15:34 |       857268224 |           19.64 |
| 2020-02-27 11:15:33 |       857268224 |           21.06 |
| 2020-02-27 11:15:32 |       857264128 |           20.39 |
| 2020-02-27 11:15:31 |       857272320 |           20.32 |
| 2020-02-27 11:15:30 |       857272320 |           21.35 |
| 2020-02-27 11:15:29 |       857272320 |            28.8 |
| 2020-02-27 11:15:28 |       857268224 |           29.08 |
| 2020-02-27 11:15:27 |       857268224 |           26.92 |
| 2020-02-27 11:15:26 |       857268224 |           23.84 |
| 2020-02-27 11:15:25 |       857264128 |           13.76 |
| 2020-02-27 11:15:24 |       857264128 |           15.12 |
| 2020-02-27 11:15:23 |       857264128 |           14.76 |
| 2020-02-27 11:15:22 |       857264128 |           15.38 |
| 2020-02-27 11:15:21 |       857260032 |           13.23 |
| 2020-02-27 11:15:20 |       857260032 |           12.75 |
| 2020-02-27 11:15:19 |       857260032 |           12.17 |
| 2020-02-27 11:15:18 |       857255936 |           13.22 |
| 2020-02-27 11:15:17 |       857255936 |           20.51 |
| 2020-02-27 11:15:16 |       857255936 |           28.74 |
| 2020-02-27 11:15:15 |       857251840 |           29.85 |
| 2020-02-27 11:15:14 |       857251840 |           29.31 |
| 2020-02-27 11:15:13 |       856981504 |           28.85 |
| 2020-02-27 11:15:12 |       856981504 |           29.19 |
| 2020-02-27 11:15:11 |       856977408 |           29.12 |
| 2020-02-27 11:15:10 |       856977408 |           29.32 |
| 2020-02-27 11:15:09 |       856977408 |            29.2 |
| 2020-02-27 11:15:08 |       856973312 |           29.36 |
| 2020-02-27 11:15:07 |       856973312 |           28.79 |
+---------------------+-----------------+-----------------+ 30 rows in set (0.08 sec)

查询最近30秒的InnoDB读写的数据行数，示例如下： MySQL> select TIME, EXTRA->'$.INNODB_ROWS_READ', EXTRA->'$.INNODB_ROWS_INSERTED' from performance_schema.PERF_STATISTICS order by time DESC limit 30;
+---------------------+-----------------------------+---------------------------------+
| TIME                | EXTRA->'$.INNODB_ROWS_READ' | EXTRA->'$.INNODB_ROWS_INSERTED' |
+---------------------+-----------------------------+---------------------------------+
| 2020-02-27 11:22:17 | 39209                       | 0                               |
| 2020-02-27 11:22:16 | 36098                       | 0                               |
| 2020-02-27 11:22:15 | 38035                       | 0                               |
| 2020-02-27 11:22:14 | 37384                       | 0                               |
| 2020-02-27 11:22:13 | 38336                       | 0                               |
| 2020-02-27 11:22:12 | 33946                       | 0                               |
| 2020-02-27 11:22:11 | 36301                       | 0                               |
| 2020-02-27 11:22:10 | 36835                       | 0                               |
| 2020-02-27 11:22:09 | 36900                       | 0                               |
| 2020-02-27 11:22:08 | 36402                       | 0                               |
| 2020-02-27 11:22:07 | 39672                       | 0                               |
| 2020-02-27 11:22:06 | 39316                       | 0                               |
| 2020-02-27 11:22:05 | 37830                       | 0                               |
| 2020-02-27 11:22:04 | 36396                       | 0                               |
| 2020-02-27 11:22:03 | 34820                       | 0                               |
| 2020-02-27 11:22:02 | 37350                       | 0                               |
| 2020-02-27 11:22:01 | 39463                       | 0                               |
| 2020-02-27 11:22:00 | 38419                       | 0                               |
| 2020-02-27 11:21:59 | 37673                       | 0                               |
| 2020-02-27 11:21:58 | 35117                       | 0                               |
| 2020-02-27 11:21:57 | 36140                       | 0                               |
| 2020-02-27 11:21:56 | 37592                       | 0                               |
| 2020-02-27 11:21:55 | 39765                       | 0                               |
| 2020-02-27 11:21:54 | 35553                       | 0                               |
| 2020-02-27 11:21:53 | 35882                       | 0                               |
| 2020-02-27 11:21:52 | 37061                       | 0                               |
| 2020-02-27 11:21:51 | 40699                       | 0                               |
| 2020-02-27 11:21:50 | 39608                       | 0                               |
| 2020-02-27 11:21:49 | 39317                       | 0                               |
| 2020-02-27 11:21:48 | 37413                       | 0                               |
+---------------------+-----------------------------+---------------------------------+ 30 rows in set (0.08 sec)

对接性能监控平台（如使用Grafana可视化工具），实现实时监控。

上一篇：内核性能监控下一篇：SQL Trace

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
