# PolarDB-X Zero-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/polardb-x-zero

PolarDB-X Zero-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

AI和智能体

PolarDB-X Zero

PolarDB-X Zero

更新时间：

复制 MD 格式

产品详情 我的收藏

PolarDB-X Zero是PolarDB-X面向AI时代提供的免费分布式MySQL兼容数据库服务，主打零注册、零配置、开箱即用。无需账号登录与付费，即可通过API一键创建一个独立的PolarDB-X实例，用于AI Agent记忆存储、原型验证、轻量应用开发与教学演示等场景。PolarDB-X Zero同时作为PolarDB-X各类AI能力（记忆引擎、向量检索、AI IDE集成等）的统一体验入口，帮助开发者在最低成本下完整体验PolarDB-X的分布式与AI能力。

体验入口 如需创建实例、查看完整API、SKILL.md接入指南及FAQ，请前往PolarDB-X ZERO官网。
核心能力

100% MySQL兼容：完整兼容MySQL协议，任意MySQL客户端、ORM、驱动均可直连使用，无学习与改造成本。

原生AI Agent记忆库：内置VECTOR类型与HNSW向量索引，原生兼容Mem0等主流Agent记忆框架，关系查询与语义检索可在同一条SQL中完成。

AI IDE一键集成：基于MCP协议与SKILL.md标准，可在Qoder、Cursor等AI编程工具中直接创建并操作Zero实例，让Agent自带数据库能力。

极简交付：通过HTTP API创建实例，秒级返回连接串，无需控制台、无需VPC配置。
适用场景

AI Agent的会话记忆、长期记忆与个性化向量库。

个人开发者、学生的轻量应用，Hackathon，教学Demo。

新项目原型验证与功能预研，体验PolarDB-X与AI能力。

说明 若您需要将PolarDB-X Zero用于生产环境，建议转正后使用，避免因实例释放而影响业务。
规格与生命周期

项目 说明

实例规格

标准版：2核4 GB。

企业版：节点数2个，计算节点2核4 GB，存储节点2核8 GB。

默认有效期 1天。

最长有效期 30天。

到期处理 实例到期后自动回收并释放资源，数据不再保留。

计费方式 完全免费。

使用限制 同一IP最多保留2个有效实例，创建频率5次/分钟。

说明 建议在到期前通过mysqldump或其他MySQL兼容工具导出所需数据。
通过AI Agent一键部署 PolarDB-X Zero原生适配AI编程助手，无需手工调API或写脚本，让Agent自带数据库能力。
在Qoder、Cursor、OpenClaw等支持MCP/SKILL.md的AI编程助手中，只需输入以下一句指令，即可自动完成PolarDB-X Zero实例创建、连接串获取与项目接入： Read https://zero.polardbx.com/SKILL.md and follow the instructions to create a database using PolarDB-X Zero.
Agent会自动调用PolarDB-X Zero的HTTP API创建实例、获取连接串并写入项目配置。

说明 PolarDB-X Zero实例默认vidx_disabled=ON，且不开放SUPER或SYSTEM_VARIABLES_ADMIN权限，因此无法通过SET GLOBAL vidx_disabled = OFF自行开启原生VECTOR类型和HNSW索引。
若您仅需在当前PolarDB-X Zero实例上快速体验向量检索，可参见本文向量检索示例（余弦相似度）章节，使用标准SQL手写余弦相似度公式完成Top-N检索，无需依赖原生向量能力。
若需生产级向量能力（原生VECTOR类型、HNSW索引与ANN检索），请通过转正路径（迁移到PolarDB-X商业版）迁移到PolarDB-X商业版实例，并参见开启向量索引功能开启并使用。
向量检索示例（余弦相似度） 若不希望依赖原生VECTOR类型和HNSW索引，可直接在PolarDB-X Zero实例上使用标准SQL手写余弦相似度（Cosine Similarity）公式完成Top-N检索。本示例基于MySQL 8.0标准SQL，PolarDB-X Zero标准版与企业版均可直接运行。
以下示例以3维向量演示，先建表并写入3条测试数据： CREATE DATABASE test_cosine;

USE test_cosine;

CREATE TABLE items ( id   INT PRIMARY KEY, name VARCHAR(50), v1   FLOAT, v2   FLOAT, v3   FLOAT );

INSERT INTO items VALUES (1, '苹果', 0.90, 0.10, 0.20), (2, '香蕉', 0.80, 0.30, 0.10), (3, '汽车', 0.10, 0.20, 0.90);
以[0.9, 0.1, 0.2]作为目标向量，通过点积÷模长乘积计算余弦相似度并按相似度从大到小返回Top 3： SET @q1 = 0.9, @q2 = 0.1, @q3 = 0.2;

SELECT id, name, ROUND((v1*@q1 + v2*@q2 + v3*@q3) / (SQRT(v1*v1 + v2*v2 + v3*v3) * SQRT(@q1*@q1 + @q2*@q2 + @q3*@q3)), 4) AS cosine_similarity FROM items ORDER BY cosine_similarity DESC LIMIT 3;
返回示例： +----+------+-------------------+
| id | name | cosine_similarity |
+----+------+-------------------+
|  1 | 苹果 |            1.0000 |
|  2 | 香蕉 |            0.9652 |
|  3 | 汽车 |            0.3372 |
+----+------+-------------------+ 3 rows in set

说明 本示例适合原型验证、教学演示与轻量应用（千级到十万级向量、维度不超过1024）。若需生产级性能（百万级以上向量、毫秒级延迟）或更高维度支持，建议改用原生VECTOR类型和HNSW索引，详见使用原生向量索引进行相似性检索。
转正路径（迁移到PolarDB-X商业版） 当原型阶段完成、需要将业务正式上线时，可在PolarDB-X Zero控制台直接将当前实例转为PolarDB-X云盘版、按量付费实例，原地升级，数据无需导出，业务无感。转正后即可享受高可用、备份恢复、监控告警、企业级安全与售后支持。
推荐流程：

一键转正：一键转到商业版PolarDB-X集群，根据Zero实例创建方式获取转正链接。

人工创建的实例：请前往PolarDB-X ZERO官网，单击转入我的阿里云账号，或打开转正链接https://polardb-x.console.aliyun.com/transfer?claim=clm_xxx（其中clm_xxx为实例对应的认领凭证）后查看。

Agent创建的实例：创建Agent对话框会返回转正链接，或者随时询问Agent如何转正。

变更网络：选择专有网络 (VPC)和虚拟交换机 (VSwitch)。

能力升级：商业版额外提供高可用多副本（RPO=0）、列存只读节点、什么是全球数据库网络（GDN）、PolarDB-X AI助手智能诊断与巡检等企业级能力。
了解PolarDB-X云盘版规格、按量付费定价与转正入口，请前往PolarDB-X ZERO官网或PolarDB-X产品主页与控制台。

上一篇：AI和智能体下一篇：PolarDB-X Agent

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
