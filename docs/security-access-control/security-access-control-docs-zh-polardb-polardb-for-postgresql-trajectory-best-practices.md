# Trajectory常用功能-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-postgresql/trajectory-best-practices

Trajectory常用功能-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

产品计费

产品规格

动态与公告

快速入门

运维指南

PolarDB AI能力

自研内核能力

插件指南

时空引擎（GanosBase）

性能白皮书

性能调优指南

安全合规

API参考

SDK下载

常见问题

术语

相关协议

PolarDB PostgreSQL轻量版

首页

云原生数据库 PolarDB

云原生数据库PolarDB PostgreSQL版

时空引擎（GanosBase）

Trajectory SQL参考

SQL使用入门

Ganos Trajectory常用功能

Ganos Trajectory常用功能

更新时间：

复制 MD 格式

产品详情 我的收藏

本文介绍Ganos Trajectory常用功能。

使用合适的时空索引

合适的索引能加快查询速度，需要根据应用场景的要求来构建合适的索引。可针对轨迹数据类型构建以下索引：

空间索引：只针对轨迹的空间范围建立索引，适合只查询轨迹空间范围情况。

时间索引：只针对轨迹的时间范围建立索引，适合只查询轨迹时间范围情况。

时空复合索引：建立时空联合索引，适合时间和空间同时过滤查询。
--创建基于函数的空间索引，加速空间过滤 create index tr_spatial_geometry_index on trajtab using gist (st_trajectoryspatial(traj));

--创建基于函数的时间段索引，加速时间过滤 create index tr_timespan_time_index on trajtab using gist (st_timespan(traj));

--创建基于函数的轨迹起止时间 create index tr_starttime_index on trajtab using btree (st_starttime(traj));
create index tr_endtime_index on trajtab using btree (st_endtime(traj));

--首先创建btree_gist扩展 create extension btree_gist;

--建立btree_gist 起始时间、终止时间、空间复合索引 create index tr_traj_test_stm_etm_sp_index on traj_test using gist (st_starttime(traj),st_endtime(traj),st_trajectoryspatial(traj));
采用合理的分区表 随着使用时间的增加，数据库中的轨迹数据量也不断增加，导致数据库索引变大，查询变慢。您可考虑采用分区表的模式降低单表数据量。
使用分区表请参见PolarDB文档中分区表。
减少使用字符串类型属性

轨迹属性中如有大量的字符串属性，会导致存储空间浪费和性能下降。

如果字符串为固定内容，可以转换为整型进行枚举，建议在程序中进行转换；

如果无法避免使用字符串类型属性，可指定字符串类型默认长度，避免空间浪费。
设置字符串类型默认长度方法如下： -- 设置字符串类型默认长度为32 Set ganos.trajectory.attr_string_length = 32；
采用批量轨迹生成模式 使用批量轨迹点生成轨迹模式，避免采取单个轨迹点追加模式。
采用优化压缩模式

lz4 压缩算法是一种优秀的压缩算法，具有更高的压缩率和更快的执行速度。如果要启用lz4压缩算法，设置方法如下： -- 设置使用lz4 压缩 Set toast_compression_use_lz4 = true;

-- 使用pg默认压缩算法 Set toast_compression_use_lz4 = false;

如果要对整个数据库默认采用lz4压缩算法，设置方法如下： -- 数据库使用lz4压缩 Alter database dbname Set toast_compression_use_lz4 = true;

-- 数据库使用默认压缩 Alter database dbname Set toast_compression_use_lz4 = false;

上一篇：OSS存储下一篇：SQL参考手册

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
