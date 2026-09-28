# 使用SQL语句创建表和索引并增删改查数据-云原生数据库 PolarDB-阿里云

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/basic-sql-operations

使用SQL语句创建表和索引并增删改查数据-云原生数据库 PolarDB-阿里云

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

快速入门

执行SQL基本操作

执行SQL基本操作

更新时间：

复制 MD 格式

产品详情 我的收藏

本文介绍如何在PolarDB-X中执行常用的SQL语句。

查看数据库 创建、查看和删除表 增加列、删除列、修改列的数据类型 创建、查看和删除本地索引 增删改查表数据 查看数据库 查看数据库： SHOW DATABASES;
创建、查看和删除表

说明 以下示例以DRDS模式数据库为例说明，DRDS模式数据库介绍请参见AUTO模式数据库与DRDS模式数据库。
创建表。
创建单表： CREATE TABLE single_tbl( id int, name varchar(30), primary key(id) );
创建一个对目标列（如ID列）使用HASH函数进行拆分的表： CREATE TABLE multi_db_single_tbl( id int auto_increment, name varchar(30), primary key(id) ) dbpartition by hash(id);
查看建表语句。
查看单表建表语句： SHOW CREATE TABLE single_tbl;
查看通过HASH函数进行拆分的表的建表语句： SHOW CREATE TABLE multi_db_single_tbl;
删除表。

警告 删除表可能会引起业务中断的风险，请谨慎操作。
删除单表： DROP TABLE single_tbl;
删除通过HASH函数进行拆分的表： DROP TABLE multi_db_single_tbl;
查看数据库中的所有表： SHOW TABLES;
增加列、删除列、修改列的数据类型 增加列： ALTER TABLE multi_db_single_tbl ADD COLUMN textcol text;
修改列的数据类型： ALTER TABLE multi_db_single_tbl MODIFY COLUMN textcol varchar(40);
删除列： ALTER TABLE multi_db_single_tbl DROP COLUMN textcol;
创建、查看和删除本地索引 您可以使用如下两种语句中的任意一种创建本地索引：

CREATE INDEX idx_name ON multi_db_single_tbl (name);

ALTER TABLE multi_db_single_tbl ADD INDEX idx_name(name);
查看本地索引： SHOW INDEX FROM multi_db_single_tbl;
您可以使用如下两种语句中的任意一种删除本地索引：

DROP INDEX idx_name ON multi_db_single_tbl;

ALTER TABLE multi_db_single_tbl DROP INDEX idx_name;
增删改查表数据 插入表数据： INSERT INTO multi_db_single_tbl (name) VALUES ('test_name');
INSERT INTO multi_db_single_tbl (name) VALUES ('test_name');
INSERT INTO multi_db_single_tbl (name) VALUES ('test_name'),('test_namexx');
查询表数据： SELECT * FROM multi_db_single_tbl;
修改表数据： UPDATE multi_db_single_tbl set name='zzz' WHERE id in (100001,100002,100003,100004);
删除表数据： DELETE FROM multi_db_single_tbl WHERE id = 100002;

上一篇：连接数据库下一篇：产品计费

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
