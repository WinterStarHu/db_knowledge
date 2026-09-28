# 如何远程获取并解析PolarDBMySQL引擎Binlog日志-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-mysql/remotely-obtain-and-parse-binary-log-records-from-a-cluster-of-the-polardb-for-mysql

如何远程获取并解析PolarDBMySQL引擎Binlog日志-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

最佳实践

远程获取并解析PolarDB MySQL版Binlog日志

远程获取并解析PolarDB MySQL版Binlog日志

更新时间：

复制 MD 格式

产品详情 我的收藏

本文介绍如何远程获取PolarDB MySQL版Binlog日志，并通过mysqlbinlog工具查看并解析Binlog日志。

Binlog获取策略

连接方式 Binlog获取策略

主地址

默认集群地址

包含主节点的自定义集群地址 均从主节点获取。

说明 如何设置集群连接地址，请参见配置数据库代理。

仅包含只读节点的自定义集群地址 从任意只读节点获取。

说明 集群版本需为以下版本之一：

PolarDB MySQL版8.0版本且Revision version为8.0.1.1.12或以上

PolarDB MySQL版5.7版本且Revision version为5.7.1.0.12或以上 否则，将返回Only allow to dump binary log on primary instance报错。
关于如何查看集群版本和升级集群版本，请参见小版本管理。
远程获取Binlog日志

为PolarDB MySQL版集群开启Binlog，详细操作步骤，请参见开启Binlog。

说明 您需要先为集群开启Binlog才能查看并获取Binlog日志，否则将出现You are not using binary logging错误提示。

在本地服务器上安装MySQL。

通过MySQL客户端连接PolarDB集群，详细操作步骤，请参见连接数据库集群。本文以Linux系统为例。

root@xxx:~# mysql -h xxx-polardb.rwlb.rds.aliyuncs.com -P3306 -utest_api -p Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is xxx Server version: 8.0.13 Source distribution

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its affiliates. Other names may be trademarks of their respective owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

在已连接PolarDB集群的客户端中执行如下命令查看目标集群的Binlog文件列表： show binary logs;

返回结果如下： +------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000005 |      2639 |
+------------------+-----------+ 1 row in set (0.00 sec)

在客户端执行如下命令，远程获取Binlog日志并保存至本地。

本文中以Linux系统为例，在执行如下语句前，需先执行exit退出MySQL后，才能远程获取Binlog日志并保存至本地。

mysql> exit Bye root@xxx:~# mysqlbinlog -utest_api -p -hxxx-polardb.rwlb.rds.aliyuncs.com --read-from-remote-server --raw mysql-bin.000005 Enter password:
root@xxx:~#

mysqlbinlog -u<用户名> -p<密码> -h<连接地址> --read-from-remote-server --raw mysql-bin.******

示例： mysqlbinlog -utest_api -p -htest-polardb.rwlb.rds.aliyuncs.com --read-from-remote-server --raw mysql-bin.000005

参数 说明 示例值

-u PolarDB MySQL版集群中的账号名称。如何创建账号，请参见创建和管理数据库账号。
test_api

-p 以上账号的密码。如果此处留空，则在执行此命令后会被要求输入。
TestPwd123

-h PolarDB MySQL版的私网地址或公网地址。

说明

若您的PolarDB MySQL版集群连接地址使用的是默认的端口号，端口号可省略不写，否则需要在连接地址后加上端口号。

若您访问的PolarDB MySQL版集群位于相同的地域且使用相同的网络类型，请选择私有网络地址进行连接。例如，所有位于华东1（杭州）的专有网络集群均建议使用私有网络地址，这样可以确保安全高效的访问体验。

其他情况只能使用公网地址。如何申请公网连接地址，请参见管理连接地址。
test-polardb.rwlb.rds.aliyuncs.com

--raw 表示将获取到的Binlog文件按数据原有格式打印，而不会展示解析后的数据。
--raw

mysql-bin.****** 通过show binary logs;命令获取的目标Binlog文件的名字，即Log_name。
mysql-bin.000005 使用mysqlbinlog工具查看、解析Binlog日志

执行如下命令，通过mysqlbinlog工具查看Binlog日志文件内容： mysqlbinlog -vv --base64-output=decode-rows mysql-bin.****** | more

说明

-vv：查看具体SQL语句及备注。

--base64-output=decode-rows：解析Binlog日志文件。

建议使用与PolarDB MySQL版本数据库引擎一致的MySQL版本，以避免出现解析Binlog日志失败等问题。
解析后的 Binlog 日志内容示例如下：

[root@iZ          ~]# mysqlbinlog -vv --base64-output=decode-rows mysql-bin.000110 | more /*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!40019 SET @@session.max_insert_delayed_threads=0*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#160217 23:04:37 server id 2802943055  end_log_pos 107  Start: binlog v 4, server v 5.5.18.1-log created 160217 23:04:37
# at 107
#160217 23:04:38 server id 2802943055  end_log_pos 171  Query     thread id=584632      exec time=0     error code=0
SET TIMESTAMP=1455721478/*!*/;
SET @@session.pseudo_thread_id=584632/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=2097152/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=33/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
BEGIN /*!*/;
# at 171

解析Binlog日志 关于如何解析Binlog日志，请参见解析Binlong日志。
常见问题

Q：执行show binary logs;后，为什么会提示You are not using binary logging错误信息？
A：PolarDB集群默认关闭Binlog参数，请确保您已开启Binlog。

说明 开启或关闭Binlog后，集群会自动重启使参数新配置生效。建议您在业务低谷期进行操作并确保应用程序具备重连机制。

Q：为什么远程获取Binlog日志失败，并出现如下错误提示？
ERROR: Error in Log_event::read_log_event(): 'Sanity check failed', data_len: 151, event_type: 35 ERROR: Could not read entry at offset 120: Error in log format or read error.
ERROR: Goterrorreadingpacketfromserver: 'Slave can not handle replication events with the checksum that master is configured to log;
A：当您使用的mysqlbinlog工具版本过低时，可能会出现以上错误提示中的任意一种。请检查您使用的mysqlbinlog工具版本，建议您升级到较高版本的mysqlbinlog工具再尝试远程获取Binlog日志。例如使用Ver 3.3版本出现如上错误提示，您可以将mysqlbinlog工具升级至Ver 3.4版本进行查看。

Q：为什么远程获取Binlog日志失败，并出现如下错误提示？
ERROR: Failed on connect: Lost connection to MySQL server at 'reading initial communication packet', system error: 104 A：这个错误通常指示无法与MySQL服务器建立连接。您可以从以下几个方面排查问题：

网络问题：建议您检查网络连接是否正常，确保可以访问PolarDB集群。

集群白名单设置：建议您检查是否将本地IP已添加到白名单，如何查看是否已添加到白名单，请参见设置白名单。

数据库配置：建议您检查本地MySQL能否正常连接数据库，确保可以正常访问数据库。

Q：为什么我看到的Binlog日志内容未经过解析？
A：若在查看Binlog日志时，未使用--base64-output=decode-rows参数，导出的Binlog日志将会显示未经解析的日志。请确保在使用mysqlbinlog工具查看Binlog日志时，已使用--base64-output=decode-rows参数。
以下为未使用--base64-output=decode-rows参数时，mysqlbinlog 输出的未经解析的 Binlog 日志示例，其中 BINLOG 语句中的 base64 编码数据即为未解析的内容：

[root@iz        ~]# mysqlbinlog -vv mysql-bin.000110 | more /*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!40019 SET @@session.max_insert_delayed_threads=0*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#160217 23:04:37 server id 2802943055  end_log_pos 107  Start: binlog v 4, server v 5.5.18.1-log created 160217 23:04:37
BINLOG ' BYzEVg9PhBGnZwAAAGsAAAAAAAAQANS41LjE4LjEtbG9nAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAEzgNAAgAEgAEBAQEEgAAVAAEGggAAAAICAgCAAA== '/*!*/;
# at 107
#160217 23:04:38 server id 2802943055  end_log_pos 171  Query    thread_id=584632      exec_time=0     error_code=0

Q：从只读节点获取Binlog时，为什么出现Only allow to dump binary log on primary instance错误提示？

A：当集群版本为以下版本之一时：

PolarDB MySQL版8.0版本且Revision version为8.0.1.1.12或以上。

PolarDB MySQL版5.7版本且Revision version为5.7.1.0.12或以上。
支持从只读节点获取Binlog。如何查看集群版本和升级集群版本，请参见小版本管理。

Q：从只读节点获取的Binlog时，为什么有时候结果会与从主节点上获取的不一致？
A：PolarDB支持在主节点和只读节点间共享Binlog，当主节点上的Binlog源信息同步到只读节点后，才能从只读节点获取Binlog。当出现同步延迟（源信息数据量很小，延迟一般不会很大）时，只读节点可能会读不到主节点上新写入的Binlog。

Q：为什么在超出保存时长参数（binlog_expire_logs_seconds）设置的时间后，Binlog并没有被删除？
A：若只读节点上有线程正在获取Binlog，该Binlog不会被立即删除。当主节点写入新的Binlog后，会再次检查是否有超时的Binlog，若此时该Binlog未参与任何只读节点上的线程，即被删除。

上一篇：PolarDB 列存索引加速复杂查询下一篇：订阅PolarDB MySQL版集群日志

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
