# 使用CHECK REPLICA TABLE校验GDN主从实例数据-云原生数据库 PolarDB-阿里云

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/gdn-online-data-verification

使用CHECK REPLICA TABLE校验GDN主从实例数据-云原生数据库 PolarDB-阿里云

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

AI和智能体

快速入门

产品计费

动态与公告

用户指南

开发指南

SQL调优指南

技术白皮书

性能白皮书

最佳实践

分布式常见问题

安全合规

API参考

错误码

术语表

相关协议

PolarDB-X 1.0（DRDS）

PolarDB分布式轻量版

首页

云原生数据库 PolarDB

云原生数据库PolarDB分布式版

用户指南

企业版（分布式）

全球数据库（GDN）

操作指引

主从实例数据校验

主从实例数据校验

更新时间：

复制 MD 格式

产品详情 我的收藏

本文为您介绍全球数据库网络（Global Database Network，简称GDN）主从实例数据校验的方法。

前提条件 已开通GDN服务并添加从实例，详情请参见开通GDN服务。
注意事项

本操作只支持在从实例中执行。

数据校验会占用一部分存储资源，建议在业务低峰期进行。
提交校验任务 语法 CHECK REPLICA TABLE {`test_db`.`test_tb`} | {`test_db`} [CHANNEL='channel_name'] [MODE=direct|snapshot];
使用限制

不支持对无主键表进行校验。

正在校验的表，再次提交校验任务时，新的校验任务会被忽略。

对已经完成校验的表再次进行校验时，系统会自动删除之前的校验结果，然后生成新的校验结果。

说明

校验任务以异步方式执行。

支持对单张表进行校验，也支持对指定库中的所有表进行校验。

CHANNEL：可以通过在从实例上执行SHOW SLAVE STATUS获取Channel_Name字段，详情请参见SHOW SLAVE STATUS。

MODE为校验模式：

snapshot：构造上下游一致性快照进行校验，需要先开启Sync Point，详情请参见开启Sync Point。

direct：直接读取上下游数据进行校验，存在误报率。
示例 mysql> check replica table `testdb`.`testtb` channel='test' mode=direct;
Query OK, 0 rows affected (0.05 sec) 开启Sync Point 在主实例执行如下SQL即可开启Sync Point功能： set global enable_polarx_sync_point = true;
set global enable_sync_point = true;
set global enable_xa_tso = true;
set global enable_auto_commit_tso = true;
# 设置sync point产生的时间间隔，单位：毫秒
set global SYNC_POINT_TASK_INTERVAL = 5000;
开启Sync Point功能后，CDC（Change Data Capture，日志节点）在主从实例数据同步过程中会实时构造主从实例的TSO-MAPPING，您可以通过从实例中的information_schema.rpl_sync_point视图来查看所有的TSO-MAPPING。
mysql> select * from information_schema.rpl_sync_point limit 10;
+-------+---------------------+---------------------+---------------------+
| ID    | PRIMARY_TSO         | SECONDARY_TSO       | CREATE_TIME         |
+-------+---------------------+---------------------+---------------------+
| 31482 | 7211850887478640704 | 7211850889504489536 | 2024-06-27 06:00:41 |
| 31483 | 7211850908445966400 | 7211850910203379776 | 2024-06-27 06:00:46 |
| 31484 | 7211850929417486400 | 7211850931690799168 | 2024-06-27 06:00:51 |
| 31485 | 7211850950393200704 | 7211850952322580544 | 2024-06-27 06:00:56 |
| 31486 | 7211850971368915008 | 7211850973738696768 | 2024-06-27 06:01:01 |
| 31487 | 7211850992327852096 | 7211850994282397760 | 2024-06-27 06:01:06 |
| 31488 | 7211851013303566400 | 7211851015677542464 | 2024-06-27 06:01:11 |
| 31489 | 7211851034275086400 | 7211851036204466240 | 2024-06-27 06:01:16 |
| 31490 | 7211851055250800704 | 7211851057595416640 | 2024-06-27 06:01:21 |
| 31491 | 7211851076218126400 | 7211851078210420800 | 2024-06-27 06:01:26 |
+-------+---------------------+---------------------+---------------------+ 10 rows in set (0.04 sec)

说明 TSO：格式为时间戳，Binlog中每一个事务都包含TSO，用于区分每一个事务。详情请参见日志服务（Binlog）。
TSO-MAPPING：某一时刻主从实例的TSO。
查看校验进度 语法 CHECK REPLICA TABLE {`test_db`.`test_tb`} | {`test_db`} SHOW PROGRESS;

说明 支持查看单张表的校验进度，同时也支持查看指定数据库下所有表的校验进度。
示例 mysql> CHECK REPLICA TABLE `test_db`.`test_tb` SHOW PROGRESS;
+----------+---------+-------+----------+---------+
| DATABASE | TABLE   | STAGE | STATUS   | SUMMARY |
+----------+---------+-------+----------+---------+
| test_db  | test_tb | CHECK | FINISHED | SUCCESS |
+----------+---------+-------+----------+---------+ 1 row in set (0.04 sec) 暂停校验任务 语法 CHECK REPLICA TABLE {`test_db`.`test_tb`} | {`test_db`} PAUSE;

说明 每张表的校验任务会对应一个或多个子任务（根据数据量进行自动拆分）。在执行完暂停校验语句后，处于执行状态的子任务将继续执行，而未进入执行状态的子任务将不再执行。
示例 mysql> CHECK REPLICA TABLE `testdb`.`testtb` PAUSE;
Query OK, 0 rows affected (0.05 sec) 重启校验任务 语法 CHECK REPLICA TABLE {`test_db`.`test_tb`} | {`test_db`} CONTINUE;

说明 重启校验任务后，未进入执行过的子任务将会执行。
示例 mysql> CHECK REPLICA TABLE `testdb`.`testtb` CONTINUE;
Query OK, 0 rows affected (0.05 sec) 查看校验结果 语法 CHECK REPLICA TABLE {`test_db`.`test_tb`} | {`test_db`} SHOW DIFF;
示例 mysql> CHECK REPLICA TABLE `test_db`.`test_tb` SHOW DIFF;
+----------+---------+------------+--------+--------------+-------------+--------------+-------------+
| DATABASE | TABLE   | ERROR_TYPE | STATUS | SRC_KEY_NAME | SRC_KEY_VAL | DST_KEY_NAME | DST_KEY_VAL |
+----------+---------+------------+--------+--------------+-------------+--------------+-------------+
| test_db  | test_tb | Miss       | FOUND  | [id]         | [2]         | [id]         | NULL        |
+----------+---------+------------+--------+--------------+-------------+--------------+-------------+ 1 row in set (0.00 sec)

说明 ERROR_TYPE字段用于表示产生差异数据的原因，其取值范围如下所示：

Miss：下游缺少数据。

Orphan：下游多数据。

Diff：上下游数据不一致。
删除校验任务 语法 CHECK REPLICA TABLE {`test_db`.`test_tb`} | {`test_db`} CANCEL;

说明 删除校验任务后，将会同时清理校验结果。
示例 mysql> CHECK REPLICA TABLE `testdb`.`testtb` CANCEL;
Query OK, 0 rows affected (0.05 sec)

上一篇：移除从实例下一篇：开发指南

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
