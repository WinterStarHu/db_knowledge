# SQL调优与执行计划优化实践-云原生数据库 PolarDB-阿里云

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/methods-that-are-used-to-optimize-slow-queries

SQL调优与执行计划优化实践-云原生数据库 PolarDB-阿里云

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

SQL调优指南

调优实践

调优实践

更新时间：

复制 MD 格式

产品详情 我的收藏

本文介绍了SQL调优的方法和实践案例。找出需要调优的慢SQL后，可以先通过EXPLAIN查看执行计划，然后通过如下方法进行优化：对表结构进行优化以便下推更多计算至存储层MySQL、适当增加索引、优化执行计划和增加并行度。

下推更多的计算 PolarDB-X会尽可能将更多的计算下推到存储层MySQL。下推计算能够减少数据传输，减少网络层和PolarDB-X计算层的开销，提升SQL语句的执行效率。PolarDB-X支持下推的计算如下：

过滤条件，如WHERE或HAVING中的条件。

聚合计算，如COUNT，GROUP BY等，会分成两阶段进行。

排序计算，如ORDER BY。

JOIN和子查询，JOIN两边的表Key分片方式必须一样，或其中一边为广播表。
如下示例介绍了如何将更多的计算下推到MySQL来加速执行。

执行EXPLAIN语句，查看执行计划： EXPLAIN SELECT * FROM customer, nation WHERE c_nationkey = n_nationkey AND n_regionkey = 3;
返回执行计划信息如下： Project(c_custkey="c_custkey", c_name="c_name", c_address="c_address", c_nationkey="c_nationkey", c_phone="c_phone", c_acctbal="c_acctbal", c_mktsegment="c_mktsegment", c_comment="c_comment", n_nationkey="n_nationkey", n_name="n_name", n_regionkey="n_regionkey", n_comment="n_comment") BKAJoin(condition="c_nationkey = n_nationkey", type="inner") Gather(concurrent=true) LogicalView(tables="nation", shardCount=2, sql="SELECT * FROM `nation` AS `nation` WHERE (`n_regionkey` = ?)") Gather(concurrent=true) LogicalView(tables="customer_[0-7]", shardCount=8, sql="SELECT * FROM `customer` AS `customer` WHERE (`c_nationkey` IN ('?'))") 上述执行计划中出现了BKAJOIN，BKAJOIN的含义是每次从左表获取一批数据，就会拼成一个IN查询取出右表相关联的行，并在最终执行JOIN操作。由于左表的数据量较大，需要进行多次数据提取，导致执行速度较慢。
无法下推JOIN的原因是：当前情况下，customer表是按照主键c_custkey进行切分的，而nation表是按照主键n_nationkey进行切分的。在本查询中，JOIN Key为c_nationkey和n_nationkey，由于两侧的JOIN Key分片方式不同，因此导致下推失败。

考虑到nation表数据量并不大且几乎没有修改操作，可以使用如下语句将其重建成广播表： CREATE TABLE `nation` ( `n_nationkey` int(11) NOT NULL, `n_name` varchar(25) NOT NULL, `n_regionkey` int(11) NOT NULL, `n_comment` varchar(152) DEFAULT NULL, PRIMARY KEY (`n_nationkey`) ) BROADCAST;  --- 声明为广播表

再次查看执行计划。
EXPLAIN SELECT * FROM customer, nation WHERE c_nationkey = n_nationkey AND n_regionkey = 3;
返回执行计划信息如下： Gather(concurrent=true) LogicalView(tables="customer_[0-7],nation", shardCount=8, sql="SELECT * FROM `customer` AS `customer` INNER JOIN `nation` AS `nation` ON ((`nation`.`n_regionkey` = ?) AND (`customer`.`c_nationkey` = `nation`.`n_nationkey`))") 可以看到执行计划中不再出现JOIN计算，几乎所有计算都被下推到存储层MySQL执行了（LogicalView算子），而上层仅仅是将结果收集并返回给用户（Gather算子），执行性能大大增强。更多关于下推的原理和优化，请参见查询改写与下推。
增加索引 PolarDB-X支持全局二级索引（Global Secondary Index，GSI）。如下示例介绍了如何通过创建GSI来下推更多算子：

执行EXPLAIN语句，查看执行计划： EXPLAIN SELECT o_orderkey, c_custkey, c_name FROM orders, customer WHERE o_custkey = c_custkey AND o_orderdate = '2019-11-11' AND o_totalprice > 100;
返回执行计划信息如下： Project(o_orderkey="o_orderkey", c_custkey="c_custkey", c_name="c_name") HashJoin(condition="o_custkey = c_custkey", type="inner") Gather(concurrent=true) LogicalView(tables="customer_[0-7]", shardCount=8, sql="SELECT `c_custkey`, `c_name` FROM `customer` AS `customer`") Gather(concurrent=true) LogicalView(tables="orders_[0-7]", shardCount=8, sql="SELECT `o_orderkey`, `o_custkey` FROM `orders` AS `orders` WHERE ((`o_orderdate` = ?) AND (`o_totalprice` > ?))") 上述执行计划中，orders表按照o_orderkey拆分而customer按照c_custkey拆分，由于拆分维度不同JOIN计算不能下推。
因为2019-11-11当天总价高于100的订单非常多，跨分片JOIN耗时很高，需要在orders表上创建一个GSI来使得JOIN计算可以下推。查询中使用到了orders表的o_orderkey、o_custkey、o_orderdate和o_totalprice四列，其中o_orderkey和o_custkey分别是主表和索引表的拆分键，o_orderdate和o_totalprice作为覆盖列包含在索引中用于避免回表。

创建全局二级索引。
CREATE GLOBAL INDEX i_o_custkey ON orders(`o_custkey`) COVERING (`o_orderdate`, `o_totalprice`) DBPARTITION BY HASH(`o_custkey`) TBPARTITION BY HASH(`o_custkey`) TBPARTITIONS 4;

执行EXPLAIN语句，查看新的执行计划： EXPLAIN SELECT o_orderkey, c_custkey, c_name FROM orders FORCE INDEX(i_o_custkey), customer WHERE o_custkey = c_custkey AND o_orderdate = '2019-11-11' AND o_totalprice > 100;
返回执行计划信息如下： Gather(concurrent=true) IndexScan(tables="i_o_custkey_[0-7],customer_[0-7]", shardCount=8, sql="SELECT `i_o_custkey`.`o_orderkey`, `customer`.`c_custkey`, `customer`.`c_name` FROM `i_o_custkey` AS `i_o_custkey` INNER JOIN `customer` AS `customer` ON (((`i_o_custkey`.`o_orderdate` = ?) AND (`i_o_custkey`.`o_custkey` = `customer`.`c_custkey`)) AND (`i_o_custkey`.`o_totalprice` > ?))") 增加GSI并通过FORCE INDEX(i_o_custkey)强制使用索引后，跨分片JOIN变为MySQL上的局部JOIN （IndexScan中），并且通过覆盖列避免了回表操作，查询性能得到提升。更多关于全局二级索引的使用细节，请参见全局二级索引。
执行计划调优

大多数情况下，PolarDB-X的查询优化器可以自动产生最佳的执行计划。但是，少数情况下，可能因为统计信息存在缺失、误差等，导致生成的执行计划不够好，此时可以通过Hint语句来干预优化器行为，使之生成更好的执行计划。如下示例介绍了如何进行执行计划的调优。

执行EXPLAIN语句，查看执行计划： EXPLAIN SELECT o_orderkey, c_custkey, c_name FROM orders, customer WHERE o_custkey = c_custkey AND o_orderdate = '2019-11-15' AND o_totalprice < 10;
返回执行计划信息如下： Project(o_orderkey="o_orderkey", c_custkey="c_custkey", c_name="c_name") HashJoin(condition="o_custkey = c_custkey", type="inner") Gather(concurrent=true) LogicalView(tables="customer_[0-7]", shardCount=8, sql="SELECT `c_custkey`, `c_name` FROM `customer` AS `customer`") Gather(concurrent=true) LogicalView(tables="orders_[0-7]", shardCount=8, sql="SELECT `o_orderkey`, `o_custkey` FROM `orders` AS `orders` WHERE ((`o_orderdate` = ?) AND (`o_totalprice` < ?))") 实际上2019-11-15这一天总价低于10元的订单数量很小，只有几条，这时候用BKAJOIN是比Hash JOIN更好的选择，BKAJOIN和Hash JOIN的详细介绍，请参见JOIN优化和执行。

通过/*+TDDL:BKA_JOIN(orders, customer)*/ Hint语句强制优化器使用BKAJOIN（LookupJOIN）： EXPLAIN /*+TDDL:BKA_JOIN(orders, customer)*/ SELECT o_orderkey, c_custkey, c_name FROM orders, customer WHERE o_custkey = c_custkey AND o_orderdate = '2019-11-15' AND o_totalprice < 10;
返回执行计划信息如下： Project(o_orderkey="o_orderkey", c_custkey="c_custkey", c_name="c_name") BKAJoin(condition="o_custkey = c_custkey", type="inner") Gather(concurrent=true) LogicalView(tables="orders_[0-7]", shardCount=8, sql="SELECT `o_orderkey`, `o_custkey` FROM `orders` AS `orders` WHERE ((`o_orderdate` = ?) AND (`o_totalprice` < ?))") Gather(concurrent=true) LogicalView(tables="customer_[0-7]", shardCount=8, sql="SELECT `c_custkey`, `c_name` FROM `customer` AS `customer` WHERE (`c_custkey` IN ('?'))")

从执行计划中看到，增加了/*+TDDL:BKA_JOIN(orders, customer)*/语句后，执行计划更优，可以加快SQL的查询速度。除了直接在SQL中加上Hint语句，更方便的方式是使用执行计划管理（Plan Management）功能对该SQL固定执行计划。具体操作如下： BASELINE FIX SQL /*+TDDL:BKA_JOIN(orders, customer)*/ SELECT o_orderkey, c_custkey, c_name FROM orders, customer WHERE o_custkey = c_custkey AND o_orderdate = '2019-11-15';
对于这条SQL（参数可以不同），PolarDB-X都会采用如上固定的执行计划。更多关于执行计划管理的信息，请参见执行计划管理。
并发执行 您可以通过HINT /*+TDDL:PARALLELISM=4*/ 语句指定并行度，充分利用多核能力加速计算。如下示例介绍了如何通过优化并发执行度来加速查询。
EXPLAIN PHYSICAL SELECT a.k, count(*) cnt FROM sbtest1 a, sbtest1 b WHERE a.id = b.k AND a.id > 1000 GROUP BY k HAVING cnt > 1300 ORDER BY cnt limit 5, 10;
返回执行计划信息如下： +-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| PLAN                                                                                                                                                              |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ExecutorType: AP_LOCAL                                                                                                                                                 |
| The Query's MaxConcurrentParallelism: 2                                                                                                                           |
| Fragment 1                                                                                                                                                        |
|     Shuffle Output layout: [BIGINT, BIGINT] Output layout: [BIGINT, BIGINT]                                                                                       |
|     Output partitioning: SINGLE [] Parallelism: 1                                                                                                                 |
|     TopN(sort="cnt ASC", offset=?2, fetch=?3)                                                                                                                     |
|   Filter(condition="cnt > ?1")                                                                                                                                    |
|     HashAgg(group="k", cnt="COUNT()")                                                                                                                             |
|       BKAJoin(condition="k = id", type="inner")                                                                                                                   |
|         RemoteSource(sourceFragmentIds=[0], type=RecordType(INTEGER_UNSIGNED id, INTEGER_UNSIGNED k))                                                             |
|         Gather(concurrent=true)                                                                                                                                   |
|           LogicalView(tables="[000000-000003].sbtest1_[00-15]", shardCount=16, sql="SELECT `k` FROM `sbtest1` AS `sbtest1` WHERE ((`k` > ?) AND (`k` IN (...)))") |
| Fragment 0                                                                                                                                                        |
|     Shuffle Output layout: [BIGINT, BIGINT] Output layout: [BIGINT, BIGINT]                                                                                       |
|     Output partitioning: SINGLE [] Parallelism: 1 Splits: 16                                                                                                      |
|     LogicalView(tables="[000000-000003].sbtest1_[00-15]", shardCount=16, sql="SELECT `id`, `k` FROM `sbtest1` AS `sbtest1` WHERE (`id` > ?)")                     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+ 从执行计划中可以看到，默认的并行度并不高，可以通过强制指定并行度，利用单机或者多机并行模式来加速查询。
EXPLAIN PHYSICAL /*+TDDL:PARALLELISM=8*/SELECT a.k, count(*) cnt FROM sbtest1 a, sbtest1 b WHERE a.id = b.k AND a.id > 1000 GROUP BY k HAVING cnt > 1300 ORDER BY cnt limit 5, 10;
返回执行计划信息如下： +-------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ExecutorMode: AP_LOCAL                                                                                                                                      |
| Fragment 0 dependency: [] parallelism: 8                                                                                                                    |
| BKAJoin(condition="k = id", type="inner")                                                                                                                   |
|   Gather(concurrent=true)                                                                                                                                   |
|     LogicalView(tables="[000000-000003].sbtest1_[00-15]", shardCount=16, sql="SELECT `id`, `k` FROM `sbtest1` AS `sbtest1` WHERE (`id` > ?)")               |
|   Gather(concurrent=true)                                                                                                                                   |
|     LogicalView(tables="[000000-000003].sbtest1_[00-15]", shardCount=16, sql="SELECT `k` FROM `sbtest1` AS `sbtest1` WHERE ((`k` > ?) AND (`k` IN (...)))") |
| Fragment 1 dependency: [] parallelism: 8                                                                                                                    |
| LocalBuffer                                                                                                                                                 |
|   RemoteSource(sourceFragmentIds=[0], type=RecordType(INTEGER_UNSIGNED id, INTEGER_UNSIGNED k, INTEGER_UNSIGNED k0))                                        |
| Fragment 2 dependency: [0, 1] parallelism: 8                                                                                                                |
| Filter(condition="cnt > ?1")                                                                                                                                |
|   HashAgg(group="k", cnt="COUNT()")                                                                                                                         |
|     RemoteSource(sourceFragmentIds=[1], type=RecordType(INTEGER_UNSIGNED id, INTEGER_UNSIGNED k, INTEGER_UNSIGNED k0))                                      |
| Fragment 3 dependency: [0, 1] parallelism: 1                                                                                                                |
| LocalBuffer                                                                                                                                                 |
|   RemoteSource(sourceFragmentIds=[2], type=RecordType(INTEGER_UNSIGNED k, BIGINT cnt))                                                                      |
| Fragment 4 dependency: [2, 3] parallelism: 1                                                                                                                |
| TopN(sort="cnt ASC", offset=?2, fetch=?3)                                                                                                                   |
|   RemoteSource(sourceFragmentIds=[3], type=RecordType(INTEGER_UNSIGNED k, BIGINT cnt))                                                                      |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------+

上一篇：执行计划管理下一篇：技术白皮书

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
