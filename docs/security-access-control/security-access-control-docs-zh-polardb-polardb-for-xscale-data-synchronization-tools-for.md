# PolarDB-X数据同步的兼容工具与账号权限-云原生数据库 PolarDB-阿里云

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/data-synchronization-tools-for-polardb-x

PolarDB-X数据同步的兼容工具与账号权限-云原生数据库 PolarDB-阿里云

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

数据迁移和同步

PolarDB-X数据同步工具

PolarDB-X数据同步工具

更新时间：

复制 MD 格式

产品详情 我的收藏

兼容的数据同步工具

数据同步工具 兼容版本 说明

MySQL Slave
>=5.4.11
目前不支持GTID模式复制

canal
>=5.4.11
无

DTS
>=5.4.11
具体操作步骤请参见同步方案概览。

debezium
>=5.4.12
不支持快照能力，使用时需要关闭快照 "snapshot.mode": "never"

maxwell
>=5.4.12
无

mysql-binlog-connector-java
>=5.4.11
无 数据同步过程中的账号权限问题

高权限账号，默认拥有所有权限。

PolarDB-X从5.4.11版本开始对外提供了完全兼容MySQL的全局binlog能力，为了保障数据安全性，需要通过GRANT SELECT ON *.* TO 'user'@'host' 语句授予账号实例级的SELECT权限， 方可查看和订阅binlog。

PolarDB-X从5.4.12版本开始，新增了binlog查看和订阅的独立权限。

拥有REPLICATION CLIENT权限GRANT REPLICATION CLIENT ON *.* TO 'user'@'host'，方可执行以下binlog的查询权限。

SHOW MASTER STATUS;
SHOW BINARY LOGS;

拥有REPLICATION SLAVE权限GRANT REPLICATION SLAVE ON *.* TO 'user'@'host'，方可查询binlog event详情和订阅binlog。

SHOW BINLOG EVENTS

上一篇：自建 MySQL 迁移至 PolarDB-X下一篇：PolarDB-X评估迁移工具

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
