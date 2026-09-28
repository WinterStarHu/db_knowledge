# 执行计划中各类算子介绍-云原生数据库 PolarDB-阿里云-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/operators-2

执行计划中各类算子介绍-云原生数据库 PolarDB-阿里云-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

算子介绍

算子介绍

更新时间：

复制 MD 格式

产品详情 我的收藏

本文介绍了一些基本的算子含义和实现。

算子介绍

含义 算子

可下推至DN的算子 LogicalView，LogicalModifyView，PhyTableOperation, IndexScan

连接（Join） BKAJoin，NLJoin，HashJoin，SortMergeJoin，HashSemiJoin，SortMergeSemiJoin，MaterializedSemiJoin

排序 MemSort，TopN， MergeSort

聚合（Group By） HashAgg，SortAgg

数据重分布或者聚合 Exchange、Gather

过滤 Filter

投影 Project

求并集 UnionAll、UnionDistinct

设置结果集输出行数（Limit/Offset...Fetch） Limit

窗口函数 OverWindow

可下推至DN执行的算子

LogicalView

LogicalView表示从存储层MySQL数据源获取数据的算子，类似于其他数据库中的TableScan或IndexScan，但支持更多的下推。LogicalView中包含下推的SQL语句和数据源信息，更像一个视图。其中下推的SQL可能包含Project、Filter、聚合、排序、Join和子查询等。以下示例展示了LogicalView的输出信息及其含义： explain select * From sbtest1 where id > 1000;

返回信息如下： Gather(concurrent=true) LogicalView(tables="[0000-0031].sbtest1_[000-127]", shardCount=128, sql="SELECT * FROM `sbtest1` WHERE (`id` > ?)")LogicalView的信息由三部分构成：

tables：存储层MySQL对应的表名，以英文句号.分割，英文句号.之前是分库对应的编号，之后是表名及其编号，如[000-127]表示表名编号从000到127的所有表。

shardCount：需访问的分表总数，该示例会访问从000到127共计128张分表。

sql：下发至存储层MySQL的SQL模版，PolarDB-X在执行时会将表名替换为物理表名，参数化的常量问号?替换成实际参数，详情请参见执行计划管理。

LogicalModifyView

LogicalModifyView表示对底层数据源进行修改的算子，其中也会记录一个SQL语句，该SQL可能是INSERT、UPDATE或者DELETE。以下示例展示了LogicalModifyView的输出信息及其含义：

示例1 explain update sbtest1 set c='Hello, DRDS' where id > 1000;

返回信息如下： LogicalModifyView(tables="[0000-0031].sbtest1_[000-127]", shardCount=128, sql="UPDATE `sbtest1` SET `c` = ? WHERE (`id` > ?)"

示例2 explain delete from sbtest1 where id > 1000;

返回信息如下： LogicalModifyView(tables="[0000-0031].sbtest1_[000-127]", shardCount=128, sql="DELETE FROM `sbtest1` WHERE (`id` > ?)")

LogicalModifyView查询计划的内容与LogicalView类似，包括下发的物理分表，分表数以及SQL模版。同样，由于开启了执行计划缓存，对SQL做了参数化处理，SQL模版中的常量会用?替换。

PhyTableOperation

PhyTableOperation表示对某个物理分表直接执行一个操作。

说明 通常情况下，该算子仅用于INSERT语句。但当路由分发到一个分片时，该算子也会出现在SELECT语句中。
explain insert into sbtest1 values(1, 1, '1', '1'),(2, 2, '2', '2');

返回信息如下： PhyTableOperation(tables="SYSBENCH_CORONADB_1526954857179TGMMSYSBENCH_CORONADB_VGOC_0000_RDS.[sbtest1_001]", sql="INSERT INTO ? (`id`, `k`, `c`, `pad`) VALUES(?, ?, ?, ?)", params="`sbtest1_001`,1,1,1,1") PhyTableOperation(tables="SYSBENCH_CORONADB_1526954857179TGMMSYSBENCH_CORONADB_VGOC_0000_RDS.[sbtest1_002]", sql="INSERT INTO ? (`id`, `k`, `c`, `pad`) VALUES(?, ?, ?, ?)", params="`sbtest1_002`,2,2,2,2")示例中，INSERT插入两行数据，每行数据对应一个PhyTableOperation算子。PhyTableOperation算子的内容包括三部分：

tables：物理表名，仅有唯一一个物理表名。

sql：SQL模版，该SQL模版中表名和常量均被参数化，用?替换，对应的参数在随后的params中给出。

params：SQL模版对应的参数，包括表名和常量。

IndexScan

IndexScan和LogicalView一样也表示从存储层MySQL数据源获取数据的算子，扫描的是索引表。以下示例展示了IndexScan的输出信息及其含义： explain select * from sequence_one_base where integer_test=1;

返回信息如下： +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| IndexScan(tables="DRDS_POLARX1_QATEST_APP_000000_GROUP.gsi_sequence_one_index_3a0A_01", sql="SELECT `pk`, `integer_test`, `varchar_test`, `char_test`, `blob_test`, `tinyint_test`, `tinyint_1bit_test`, `smallint_test`, `mediumint_test`, `bit_test`, `bigint_test`, `float_test`, `double_test`, `decimal_test`, `date_test`, `time_test`, `datetime_test`, `timestamp_test`, `year_test`, `mediumtext_test` FROM `gsi_dml_sequence_one_index_index1` AS `gsi_dml_sequence_one_index_index1` WHERE (`integer_test` = ?)") |上述SQL正常应该扫描sequence_one_base表，由于integer_test不是分区键，因此需要扫描sequence_one_base所有的分片。但是由于sequence_one_base表在integer_test列上存在全局二级索引gsi_sequence_one_index，将integer_test=1作为谓词条件对索引表做裁剪，实际上会生成IndexScan算子，表示只会扫描gsi_sequence_one_index索引表的一个分片。

可在CN或DN上执行的算子

UnionAll与UnionDistinct

顾名思义，Union All对应UNIONALL，Union Distinct对应UNIONDISTINCT。该算子通常有2个或更多个输入，表示将多个输入的数据合并在一起。例如： explain select * From sbtest1 where id > 1000 union distinct select * From sbtest1 where id < 200;

返回信息如下： UnionDistinct(concurrent=true) Gather(concurrent=true) LogicalView(tables="[0000-0031].sbtest1_[000-127]", shardCount=128, sql="SELECT * FROM `sbtest1` WHERE (`id` > ?)") Gather(concurrent=true) LogicalView(tables="[0000-0031].sbtest1_[000-127]", shardCount=128, sql="SELECT * FROM `sbtest1` WHERE (`id` < ?)")

Gather

Gather将多份数据合并成同份数据。上面的例子中，Gather将各个分表上查询到的数据合并成一份。Gather通常出现在LogicalView上方，表示收集合并各个分表的数据。

Exchange

Exchange是一个逻辑算子，本身不对计算过程中的数据做计算，只是将输入的数据做重分布后，输出给下游算子。一般重分布策略包括：

SINGLETON：将上游多份数据进行合并输出，这种重分布策略等价于Gather。

HASH_DISTRIBUTED：将上游输入的数据按照某些列做repartition，常见于包含Join和Agg的执行计划中。

BROADCAST_DISTRIBUTED：将上游相同一份数据分发成多份，广播给下游多个节点，主要应用于MPP执行计划中。

MergeSort

MergeSort即归并排序算子，表示将有序的数据流进行归并排序，合并成一个有序的数据流。示例如下： explain select * from sbtest1 where id > 1000 order by id limit 5,10;

返回信息如下： MergeSort(sort="id ASC", offset=?1, fetch=?2) LogicalView(tables="[0000-0031].sbtest1_[000-127]", shardCount=128, sql="SELECT * FROM `sbtest1` WHERE (`id` > ?) ORDER BY `id` LIMIT (? + ?)")MergeSort算子包含三部分内容：

sort：表示排序字段以及排列顺序，id ASC表示按照ID字段递增排序，DESC表示递减排序。

offset：表示获取结果集时的偏移量，例子中被参数化了，实际值为5。

fetch：表示最多返回的数据行数。与offset类似，同样是参数化的表示，实际对应的值为10。

Project

Project表示投影操作，即从输入数据中选择部分列输出，或者对某些列进行转换（通过函数或者表达式计算）后输出，也可以包含常量。
explain select '你好, DRDS', 1 / 2, CURTIME();

返回信息如下： Project(你好, DRDS="_UTF-16'你好, DRDS'", 1 / 2="1 / 2", CURTIME()="CURTIME()")Project的计划中包括每列的列名及其对应的列、值、函数或者表达式。
Filter

Filter表示过滤操作，其中包含一些过滤条件。该算子对输入数据进行过滤，若满足条件，则输出，否则丢弃。如下是一个较复杂的例子，包含了以上介绍的大部分算子。
explain select k, avg(id) avg_id from sbtest1 where id > 1000 group by k having avg_id > 1300;

返回信息如下： Filter(condition="avg_id > ?1") Project(k="k", avg_id="sum_pushed_sum / sum_pushed_count") SortAgg(group="k", sum_pushed_sum="SUM(pushed_sum)", sum_pushed_count="SUM(pushed_count)") MergeSort(sort="k ASC") LogicalView(tables="[0000-0031].sbtest1_[000-127]", shardCount=128, sql="SELECT `k`, SUM(`id`) AS `pushed_sum`, COUNT(`id`) AS `pushed_count` FROM `sbtest1` WHERE (`id` > ?) GROUP BY `k` ORDER BY `k`")WHERE id>1000中的条件没有对应的Filter算子，是因为这个算子最终被下推到了LogicalView中，可以在LogicalView的SQL中看到WHERE (id > ?)。

上一篇：调优原理和执行计划下一篇：SQL调优进阶

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
