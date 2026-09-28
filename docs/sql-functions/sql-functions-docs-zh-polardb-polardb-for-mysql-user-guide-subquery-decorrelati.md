# 如何使用Window Function和Group By Aggregation对子查询解关联-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-mysql/user-guide/subquery-decorrelation

如何使用Window Function和Group By Aggregation对子查询解关联-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

查询优化（Query Optimizer)

查询改写

子查询解关联

子查询解关联

更新时间：

复制 MD 格式

产品详情 我的收藏

子查询解关联是数据库对关联子查询进行优化的一个重要手段。本文档介绍了如何利用Window Function和Group By Aggregation对子查询解关联。

前提条件

集群版本需为PolarDB MySQL版8.0版本且Revision version为8.0.2.2.1及以上。您可以通过查询版本号确认集群版本。

背景信息

关联子查询在分析场景中被广泛使用，例如在决策支持基准TPC-H的22个查询中，有超过1/3的查询包含关联子查询。在没有解关联的时候，外层查询的每一行数据，子查询都会被执行一次。对于外层查询产生数据量较多、子查询没有关联索引等情况，子查询多次执行会导致查询耗时严重。子查询解关联将关联子查询变换为等价的Join语句，可以避免子查询多次执行，同时优化器可以对Join做进一步优化。

利用Window Function解关联

概述

假设原有查询的通用表达形式如下：其中，T1、T2、T3为一个或多个表和视图的集合；T2与T3之间的虚线表示子查询中的T2与主查询中的T3进行关联；T1出现在主查询中，但是不与子查询中的T2关联。

上图中通用表达式的关联子查询，具有以下约束条件：

Scalar subquery中没有limit，输出为Aggregation function，且没有distinct语法。

子查询中的表必须是主查询中表的一部分。

子查询中的关联条件必须是等值连接。主查询包含相同语义的连接条件，且包含有子查询中公共表的过滤条件。

子查询中关联条件的列是主键或者唯一键。

子查询和主查询都不带有自定义函数或随机函数。

利用Window Function将子查询解关联后的形式如下：

使用方法

通过系统参数loose_polar_optimizer_switch开启利用Window function解关联功能。具体操作请参见设置集群参数和节点参数。

参数名称

级别

描述

loose_polar_optimizer_switch

Global、Session

查询优化控制开关。取值范围如下：

unnest_use_window_function：利用Window function解关联的功能开关。

ON（默认值）：开启利用Window function解关联功能。

OFF：关闭利用Window function解关联功能。

unnest_use_group_by：利用Group by解关联的功能开关，该查询变换受基于代价的查询变换控制。

ON（默认值）：开启利用Group by解关联功能。

OFF：关闭利用Group by解关联功能。

derived_merge_cost_based：derived merge功能是否受基于代价的查询变换的控制。

OFF（默认值）：derived merge功能不受基于代价的查询变换的控制。

ON：derived merge功能受基于代价的查询变换的控制。

示例：以TPC-H中的Q2为例，该查询希望查找特定区域，对于指定类型和大小的零件，能够提供最小批发价的供应商。该查询在社区MySQL中执行需要先执行外层查询获取指定类型和大小的零件供应商的信息，然后对获取的每一条数据通过子查询计算该零件在指定区域中所有供应商最小的批发价，然后判断获取的供应商批发价和子查询获取的最小批发价是否一致。
SELECT s_acctbal, s_name, n_name, p_partkey, p_mfgr, s_address, s_phone, s_comment FROM part, supplier, partsupp, nation, region WHERE p_partkey = ps_partkey AND s_suppkey = ps_suppkey AND p_size = 30 AND p_type LIKE '%STEEL' AND s_nationkey = n_nationkey AND n_regionkey = r_regionkey AND r_name = 'ASIA' AND ps_supplycost = ( SELECT MIN(ps_supplycost) FROM partsupp, supplier, nation, region WHERE p_partkey = ps_partkey AND s_suppkey = ps_suppkey AND s_nationkey = n_nationkey AND n_regionkey = r_regionkey AND r_name = 'ASIA' ) ORDER BY s_acctbal DESC, n_name, s_name, p_partkey LIMIT 100;

利用Window function按照指定的分组方式分组计算聚合函数，在原有数据行上增加分组计算的聚合结果。对于TPC-H中的Q2，可以获取特定区域，指定类型和大小零件的供应商同时按照零件信息进行分组计算获得最小批发价。然后通过比较获取的数据行中批发价和分组最小批发价比较来选择需要的数据。Q2经过查询变换后，获得以下查询的等价执行。
SELECT s_acctbal, s_name, n_name, p_partkey, p_mfgr, s_address, s_phone, s_comment FROM ( SELECT MIN(ps_supplycost) OVER(PARTITION BY ps_partkey) as win_min, ps_partkey, ps_supplycost, s_acctbal, n_name, s_name, s_address, s_phone, s_comment FROM part, partsupp, supplier, nation, region WHERE p_partkey = ps_partkey AND s_suppkey = ps_suppkey AND s_nationkey = n_nationkey AND n_regionkey = r_regionkey AND p_size = 30 AND p_type LIKE '%STEEL' AND r_name = 'ASIA') as derived WHERE ps_supplycost = derived.win_min ORDER BY s_acctbal DESC, n_name, s_name, p_partkey LIMIT 100;

通过Hint来控制满足条件的子查询利用Window function解关联。

可以通过UNNEST hint来控制该查询变换。具体变换形式如下： UNNEST([@query_block_name] [strategy [, strategy] ...])   #表示使用Window function或Group By解关联，并且不受polar_optimizer_switch的影响。
NO_UNNEST([@query_block_name] [strategy [, strategy] ...])  #表示禁止使用Window function或Group By解关联，并且不受polar_optimizer_switch的影响。

其中strategy支持WINDOW_FUNCTION和GROUP_BY选项。

示例：
#指定满足条件的子查询利用WINDOW_FUNCTION解关联
SELECT ... FROM ... WHERE ... = (SELECT /*+UNNEST(WINDOW_FUNCTION)*/ agg FROM ...) SELECT /*+UNNEST(@`select#2` WINDOW_FUNCTION)*/ ... FROM ... WHERE ... = (SELECT agg FROM ...)

#指定子查询不要利用WINDOW_FUNCTION解关联
SELECT ... FROM ... WHERE ... = (SELECT /*+NO_UNNEST(WINDOW_FUNCTION)*/ agg FROM ...) SELECT /*+NO_UNNEST(@`select#2` WINDOW_FUNCTION)*/ ... FROM ... WHERE ... = (SELECT agg FROM ...)

性能效果

使用TPC-H 10G标准数据集来测试使用Window Function进行子查询解关联的性能效果，发现对于Q2和Q17分别带来了1.54和4.91倍的加速提升。如下图所示：

利用Group By Aggregation解关联

概述

假设原有查询的通用表达形式如下：

上图中通用表达式的关联子查询，具有以下约束条件：

Scalar subquery中没有显示Group By和limit，输出为Aggregation function。

Scalar subquery在join condition、where condition或select field中。

Scalar subquery和父查询的关联条件必须是等值条件，且各个condition之间是AND连接。

Scalar subquery中没有自定义函数或者随机函数。

利用Group By Aggregation将子查询解关联后的形式如下：

使用方法

通过系统参数 loose_polar_optimizer_switch

开启利用Group By Aggregation解关联功能。具体操作请参见设置集群参数和节点参数 。

参数名称

级别

描述

loose_polar_optimizer_switch

Global、Session

查询优化控制开关。取值范围如下：

unnest_use_window_function：利用Window function解关联的功能开关。

ON（默认值）：开启利用Window function解关联功能。

OFF：关闭利用Window function解关联功能。

unnest_use_group_by：利用Group by解关联的功能开关，该查询变换受基于代价的查询变换控制。

ON（默认值）：开启利用Group by解关联功能。

OFF：关闭利用Group by解关联功能。

derived_merge_cost_based：derived merge功能是否受基于代价的查询变换的控制。

OFF（默认值）：derived merge功能不受基于代价的查询变换的控制。

ON：derived merge功能受基于代价的查询变换的控制。

示例：以下面查询语句为例，希望获取销售订单中大于对应商品采购总量10%的订单明细。
SELECT * FROM sale_lineitem sl WHERE sl.sl_quantity > (SELECT 0.1 * SUM(pl.pl_quantity) FROM purchase_lineitem pl WHERE pl.pl_objectkey = sl.sl_objectkey);

如果不做任何查询变换的话，执行引擎会迭代sale_lineitem表的每一行，获取sl_objectkey填充到子查询中，执行子查询获取采购总量的10%，然后和该行数据上的数量做比较。此时，子查询的执行次数取决于sale_lineitem表的行数，即使在pl_objectkey列上有索引，由于sl_objectkey列一般存在大量重复的值，也会造成purchase_lineitem表的大量重复扫描和重复计算。对于这种执行效率低的关联子查询，在PolarDB中会利用Group By Aggregation解关联。上述查询语句会变换为： SELECT * FROM sale_lineitem sl LEFT JOIN (SELECT (0.1 * sum(pl.pl_quantity)) AS Name_exp_1, pl.pl_objectkey AS Name_exp_2 FROM purchase_lineitem pl GROUP BY pl.pl_objectkey) derived ON derived.Name_exp_2 = sl.sl_objectkey WHERE sl.sl_quantity > derived.name_exp_1;

变换后会先对各个采购商品做分组计算，然后再与sale_lineitem做Join。这样purchase_lineitem表只需要扫描一次，避免了重复扫描和计算。这里变换后的语句可以进一步消除外连接，Join Order可以调整，提升执行效率。

通过Hint来控制满足条件的子查询利用Group By Aggregation解关联。

可以通过UNNEST hint来控制该查询变换。具体变换形式如下： UNNEST([@query_block_name] [strategy [, strategy] ...])   #表示使用Window function或Group By解关联，并且不受polar_optimizer_switch的影响。
NO_UNNEST([@query_block_name] [strategy [, strategy] ...])  #表示禁止使用Window function或Group By解关联，并且不受polar_optimizer_switch的影响。

其中strategy支持WINDOW_FUNCTION和GROUP_BY选项。

示例：
#指定满足条件的子查询利用GROUP_BY解关联
SELECT ... FROM ... WHERE ... = (SELECT /*+UNNEST(GROUP_BY)*/ agg FROM ...) SELECT /*+UNNEST(@`select#2` GROUP_BY)*/ ... FROM ... WHERE ... = (SELECT agg FROM ...)

#指定子查询不要利用GROUP_BY解关联
SELECT ... FROM ... WHERE ... = (SELECT /*+NO_UNNEST(GROUP_BY)*/ agg FROM ...) SELECT /*+NO_UNNEST(@`select#2` GROUP_BY)*/ ... FROM ... WHERE ... = (SELECT agg FROM ...)

上一篇：子查询折叠下一篇：LEFT JOIN（左连接）消除

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
