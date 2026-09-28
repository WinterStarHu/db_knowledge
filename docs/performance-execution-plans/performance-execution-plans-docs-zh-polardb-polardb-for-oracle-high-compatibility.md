# 什么是PolarDB PostgreSQL版（兼容Oracle）引擎的高度兼容性能力-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-oracle/high-compatibility

什么是PolarDB PostgreSQL版（兼容Oracle）引擎的高度兼容性能力-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

产品计费

动态与公告

快速入门

运维指南

自研内核能力

插件指南

开发指南

时空引擎（GanosBase）

技术白皮书

性能白皮书

性能调优指南

安全合规

API参考

SDK下载

常见问题

术语

相关协议

首页

云原生数据库 PolarDB

云原生数据库PolarDB PostgreSQL版（兼容Oracle）

技术白皮书

产品技术架构和核心能力

核心能力解读

高度兼容性

高度兼容性

更新时间：

复制 MD 格式

产品详情 我的收藏

PolarDB PostgreSQL版（兼容Oracle）提供全面的Oracle语法兼容性，采用share everything架构，与Oracle保持一致文件组织架构与多版本并发控制，提供常用Oracle语法支持及Oracle常用特性支持以及OCI原生接口，全面支持助力一键从Oracle迁移上云。

PolarDB PostgreSQL版（兼容Oracle）高度兼容Oracle语法，全量兼容Oracle所有基础数据类型及内置对象体系，如内置函数、核心功能包、关键系统视图等。支持高级特性，包括但不限于二级分区管理、全局索引、嵌套自治事务、ConnectBy层次查询、RowNum伪列、同义词体系、JSON原生类型、闪回表技术、全局临时表等核心特性。完整支持Oracle过程语言框架，包含标准PL/SQL编程范式、自定义包开发规范、高维集合类型实现、高维集合类型的组合嵌套及方法调用等关键编程要素。根据历史数千个客户实际迁移经验，Oracle语法兼容度ADAM评估结果在95%以上。
PolarDB PostgreSQL版（兼容Oracle）兼容了丰富的表分区功能包括常用的RANGE分区、INTERVAL分区、分区SPLIT和MERGE、分区模板等，基于表分区的全局索引可以极大的提升用户的查询性能。
存储过程开发语言 存储过程开发语言是业务应用常用的一种数据库开发语言，被很多应用开发同学所熟悉，PolarDB PostgreSQL版（兼容Oracle）对Oracle存储过程语言有着很高的兼容度，包括COLLECTION、GOTO、SAVEPOINT、ROLLBACK TO、CURSOR、EXECUTE IMMEDIATE RETURN等大量语法。
DBLINK DBLINK支持将不同数据源中的数据集成到PolarDB PostgreSQL版（兼容Oracle）中，像使用本地数据一样可以进行SQL查询。现有foreign data wrapper, database link，dblink function三种形态提供使用，可以实现PolarDB PostgreSQL版（兼容Oracle）到PolarDB PostgreSQL版（兼容Oracle），PolarDB PostgreSQL版（兼容Oracle）到Oracle，PolarDB PostgreSQL版（兼容Oracle）到PostgreSQL，PolarDB PostgreSQL版（兼容Oracle）到MySQL等各种流行数据产品之间的数据连接查询。在DBLINK使用复杂SQL进行查询时，PolarDB PostgreSQL版（兼容Oracle）实现了谓词下推、join下推、排序下推、分组下推等优化，将计算尽可能的下推到远程数据库中，极大的提高了查询性能。
高级功能兼容 同时，PolarDB PostgreSQL版（兼容Oracle）对与HINT、SPM、CREATE TYPE、MVIEW、PROFILE等高级功能，OCI、Pro*C等常用驱动程序、也都有很好的兼容性。除Oracle兼容性外，PolarDB PostgreSQL版（兼容Oracle）对PostgreSQL可以达到100%兼容度，包括语法兼容、生态工具兼容等，为用户提供更加多样的数据库兼容生态。

上一篇：云原生能力下一篇：高可用能力

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
