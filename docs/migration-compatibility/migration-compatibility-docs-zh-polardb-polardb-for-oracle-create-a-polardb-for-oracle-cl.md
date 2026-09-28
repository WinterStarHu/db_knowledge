# 如何创建PolarDB PostgreSQL版（兼容Oracle）引擎数据库集群-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-oracle/create-a-polardb-for-oracle-cluster

如何创建PolarDB PostgreSQL版（兼容Oracle）引擎数据库集群-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

运维指南

集群管理

创建PolarDB PostgreSQL版（兼容Oracle）集群

创建PolarDB PostgreSQL版（兼容Oracle）集群

更新时间：

复制 MD 格式

产品详情 我的收藏

本文介绍如何通过PolarDB管理控制台创建PolarDB PostgreSQL版（兼容Oracle）数据库集群。

前提条件 已注册并登录阿里云账号，详细操作步骤请参见注册和登录阿里云账号。
背景信息 一个集群包含一个主节点以及最多十五个只读节点（最少一个只读节点），用于提供双主（Active-Active）高可用。节点是虚拟化的数据库服务器，节点中可以创建和管理多个数据库。

说明

PolarDB PostgreSQL版（兼容Oracle）仅支持专有网络VPC（Virtual Private Cloud）。VPC是阿里云上一种隔离的网络环境，安全性比传统的经典网络更高。

PolarDB与其他阿里云产品通过内网互通时才能发挥PolarDB的最佳性能，因此，建议将PolarDB与云服务器ECS配合使用，且与ECS创建于同一个VPC，否则PolarDB无法发挥最佳性能。如果您ECS的网络类型为经典网络，需将ECS从经典网络迁移到VPC，详情请参见ECS实例迁移。
优惠活动 首购折扣价：首次购买PolarDB享受折扣价。详情请参见优惠活动。
操作步骤 PolarDB PostgreSQL版（兼容Oracle）创建集群操作步骤请参见自定义购买或购买包年包月集群。
相关API

API 描述

CreateDBCluster 创建数据库集群。

DescribeDBClusters 查看集群列表。

DescribeDBClusterAttribute 查看指定PolarDB集群的详细属性。

DescribeAutoRenewAttribute 查询PolarDB包年包月集群自动续费状态。

ModifyAutoRenewAttribute 设置PolarDB包年包月集群自动续费状态。

上一篇：集群管理下一篇：临时升配

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
