# PolarDB PostgreSQL版支持哪些插件-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-postgresql/list-of-supported-plug-ins

PolarDB PostgreSQL版支持哪些插件-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

插件指南

支持插件列表

支持插件列表

更新时间：

复制 MD 格式

产品详情 我的收藏

本文列出PolarDB PostgreSQL版的各版本支持的插件及其版本。

说明

如果您的集群实际支持的功能和下表不符，请先升级内核小版本至最新版。

本页面仅列举了常用插件，更多插件的支持情况，可在数据库内使用SELECT * FROM pg_available_extensions;命令查询。

部分插件在使用前，需要将插件加入到shared_preload_libraries参数中，否则无法创建插件。

涉及的插件包括：pg_stat_statements、auth_delay、passwordcheck、auto_explain、 pgaudit、pg_bigm、pg_cron、pg_hint_plan、pg_prewarm、zhparser、timescaledb、pldebugger和pg_jieba。

pldebugger插件加入shared_preload_libraries参数时，取值需配置为plugin_debugger。

修改shared_preload_libraries参数方法请参见设置集群参数。

部分插件（例如，ganos_spatialref）在默认数据库postgres中创建时，如果提示没有权限（ERROR: permission denied for database postgres），请切换到当前账号拥有的数据库中创建该插件。

如安装插件异常，且使用SELECT * FROM pg_available_extensions;查询当前集群已支持该插件，请提交工单处理。

重要

PolarDB PostgreSQL版支持插件策略调整，将于2023年4月27日起，部分插件在指定内核小版本才能创建，已创建的插件使用不受影响。更多信息，请参见2023年4月27日起PolarDB PostgreSQL版部分插件在低内核版本限制创建。

X86架构集群

插件名

PolarDB PostgreSQL版

描述

18

17

16

15

14

11

address_standardizer

3.3.7

3.3.7

3.3.7

3.3.7

3.3.7

3.3.4

提供地址标准化计算。

address_standardizer_data_us

3.3.7

3.3.7

3.3.7

3.3.7

3.3.7

3.3.4

地址标准化美国数据。

AGE

-

-

1.5.1

1.5.0

1.5.0

-

数据库的图插件，使用cypher语言对数据库中的图进行查询。

bloom

1.0

1.0

1.0

1.0

1.0

1.0

提供一种基于布鲁姆过滤器的索引访问方法。

btree_gin

1.3

1.3

1.3

1.3

1.3.1

1.3

提供一个为多种数据类型和所有enum类型实现B树等价行为的GIN操作符类示例。

btree_gist

1.8

1.7

1.7

1.7

1.6.1

1.5

提供一个为多种数据类型和所有enum类型实现B树等价行为的GiST操作符类示例。

citext

1.8

1.6

1.6

1.6

1.6

1.5

提供一种大小写不敏感的字符串类型。

cube

1.5

1.5

1.5

1.5

1.5

1.4

提供一种数据类型来表示多维立方体。

dblink

1.2

1.2

1.2

1.2

1.2

1.2

跨库操作表。

decoderbufs

0.1.0

0.1.0

0.1.0

0.1.0

0.1.0

0.1.0

根据Protocol Buffers协议，输出能够适配Debezium平台的数据。

dict_int

1.0

1.0

1.0

1.0

1.0

1.0

附加全文搜索词典模板的示例。

earthdistance

1.2

1.2

1.2

1.1

1.1

1.1

提供两种不同的方法来计算地球表面的大圆距离。

fuzzystrmatch

1.2

1.2

1.2

1.1

1.1

1.1

判断字符串之间的相似性和距离。

ganos_address_standardizer

7.8

7.7

7.9

7.7

7.9

6.8

基于PAGC标准的地名标准化插件。

ganos_address_standardizer_data_us

7.8

7.7

7.9

7.7

7.9

6.8

基于PAGC标准的地名标准化美国部分数据插件。

ganos_geometry

7.8

7.7

7.9

7.7

7.9

6.8

提供空间几何类型的计算分析功能。

ganos_geometry_pyramid

7.8

7.7

7.9

7.7

7.9

6.8

用于二维空间几何大数据的快速显示。

ganos_geometry_sfcgal

7.8

7.7

7.9

7.7

7.9

6.8

提供空间几何sfcgal插件扩展功能。

ganos_geometry_topology

7.8

7.7

7.9

7.7

7.9

6.8

提供空间几何类型的计算分析功能。

ganos_networking

7.8

7.7

7.9

7.7

7.9

6.8

提供空间几何网络类型的计算分析功能。

ganos_pointcloud

7.8

7.7

7.9

7.7

7.9

6.8

提供点云的存储计算分析功能。

ganos_pointcloud_geometry

7.8

7.7

7.9

7.7

7.9

6.8

提供点云的存储计算分析功能。

ganos_raster

7.8

7.7

7.9

7.7

7.9

6.8

提供空间栅格数据的存储计算分析功能。

ganos_spatialref

7.8

7.7

7.9

7.7

7.9

6.8

提供空间参考的计算分析功能。

ganos_tiger_geocoder

7.8

7.7

7.9

7.7

7.9

6.8

提供USCB Tiger数据类型支持。

ganos_trajectory

7.8

7.7

7.9

7.7

7.9

6.8

ganos移动对象（MOD）数据计算分析功能。

hll

2.18

2.18

2.18

2.18

2.17

2.17

快速预估PV、UV等业务指标。

hstore

1.8

1.8

1.8

1.8

1.8

1.5

在单一PostgreSQL值中存储键值对。

hypopg

1.4.0

-

1.4.0

1.3.1

1.4.0

1.3.1

创建虚拟索引。

imgsmlr

-

-

1.0

-

1.0

-

支持相似图像搜索功能。

intagg

1.1

1.1

1.1

1.1

1.1

1.1

提供一个整数聚集器和一个枚举器。

intarray

1.5

1.5

1.5

1.5

1.5

1.2

提供一些有用的函数和操作符来操纵不含空值的整数数组。

ip4r

2.4

2.4

2.4

2.4

2.4

2.4

使PostgreSQL支持IP地址范围类型。

isn

1.3

1.2

1.2

1.2

1.2

1.2

按照一个硬编码的前缀列表对输入进行验证，也被用来在输出时连接号码。

ltree

1.3

1.3

1.2

1.2

1.2

1.1

用于表示存储在一个层次树状结构中的数据的标签。

oss_fdw

-

-

1.1

-

1.1

1.1

读写OSS里的数据。

pase

0.0.1

0.0.1

0.0.1

0.0.1

0.0.1

0.0.1

高效向量检索。

pg_bigm

1.2

1.2

1.2

1.2

1.2

1.2

创建一个二元语法（2-gram）的GIN索引来加速全文搜索过程。

pg_buffercache

1.6

1.6

1.6

1.4

1.5

1.3

提供一种方法实时检查共享缓冲区。

polar_concurrency_control

-

-

1.0

-

1.0

1.0

用于对SQL进行并发控制。

polar_tde_utils

1.0

1.0

1.0

-

1.0

1.0

TDE批量加解密插件。

pg_cron

1.5

1.5

1.5

1.5

1.5

1.2

设置定时任务。

pg_freespacemap

1.3

1.2

1.2

1.2

1.2

1.2

检查空闲空间映射（FSM）。

pg_jieba

1.1.0

1.1.0

1.1.0

1.1.0

1.1.0

1.1.0

对中文全文实现分词。

pg_pathman

-

-

-

-

1.5

1.5

高性能分区表插件。

pg_hint_plan

-

-

1.6.2

-

1.4.1

1.3.7

通过特殊的注释语句提示，使PostgreSQL改变其既定的执行计划。

pg_profile

-

4.10

4.10

4.10

4.1

1.0

资源密集活动统计。

pg_prewarm

1.2

1.2

1.2

1.2

1.2

1.2

提供一种方便的方法将数据载入到操作系统缓冲区或者PostgreSQL缓冲区。

pg_sphere

-

-

1.0

-

1.0

1.0

提供PostgreSQL的球面的数据类型、函数、运算符和索引。

pg_stat_kcache

2.3.1

2.3.0

2.3.0

2.3.0

2.2.1

2.2.1

系统读写信息统计。

pg_stat_statements

1.12

1.11

1.10.1

1.10

1.9.2

1.6

提供一种方法追踪服务器执行的所有SQL语句的执行统计信息。

pg_trgm

1.6

1.6

1.6

1.6

1.6

1.4

提供字母数字文本相似度的函数和操作符，以及支持快速搜索相似字符串的索引操作符类。

pgaudit

18.1

17.1

16.1

1.7.1

1.6.2

1.3.3

提供详细的会话和对象审计日志记录。

pgcrypto

1.4

1.3

1.3

1.3

1.3

1.3

为PostgreSQL提供了密码函数。

pgrouting

3.4.2

3.4.2

3.4.2

3.4.2

3.4.2

3.4.2

提供空间几何网络的计算分析功能。

pgrowlocks

1.2

1.2

1.2

1.2

1.2

1.2

提供一个函数来显示一个指定表的行锁定信息。

pgstattuple

1.5

1.5

1.5

1.5

1.5

1.5

提供多种函数来获得元组层的统计信息。

pgvector

0.8.0

0.8.0

0.8.0

0.8.0

0.8.0

0.5.0

高维向量相似度搜索插件。

pldebugger

1.1

1.1

1.1

1.1

1.1

1.1

存储过程调试插件。

plperl

1.0

1.0

1.0

1.0

1.0

1.0

提供perl过程语言。

plpgsql

1.0

1.0

1.0

1.0

1.0

1.0

提供SQL过程语言。

pltcl

1.0

1.0

1.0

1.0

1.0

1.0

提供tcl过程语言。

postgis

3.3.7

3.3.7

3.3.7

3.3.7

3.3.7

3.3.4

PostGIS空间地理信息相关扩展。

postgis_sfcgal

3.3.7

3.3.7

3.3.7

3.3.7

3.3.7

3.3.4

PostGIS SFCGAL空间地理信息相关扩展。

postgis_tiger_geocoder

3.3.7

3.3.7

3.3.7

3.3.7

3.3.7

3.3.4

PostGIS TIGER数据空间地理信息相关扩展。

postgis_topology

3.3.7

3.3.7

3.3.7

3.3.7

3.3.7

3.3.4

PostGIS拓扑数据空间地理信息相关扩展。

q3c

-

-

-

-

-

2.0.0

用于在球体上进行空间索引。

rdkit

-

-

-

-

-

3.8

支持化学分子计算、化学分子检索等功能。

roaringbitmap

0.5

0.5

0.5

0.5

0.5

0.5

使用位图功能，提高查询性能。

rum

1.3

1.3

1.3

1.3

1.3

-

高速全文检索。

sequential_uuid

1.0.3

1.0.3

1.0.3

1.0.3

1.0.2

1.0.2

具有顺序模式的UUID生成器。

smlar

-

-

1.0

-

1.0

1.0

计算两个相同类型数组的相似度。

sslinfo

1.2

1.2

1.2

1.2

1.2

1.2

提供当前客户端提供的SSL证书的有关信息。

tablefunc

1.0

1.0

1.0

1.0

1.0

1.0

包括多个返回表的函数。

tds_fdw

-

-

-

-

2.0.2

2.0.2

查询其他类型数据库的数据。

timescaledb

-

-

2.18.0

-

2.16.1

1.7.1

支持时序数据的自动分片、高效写入、检索和准实时聚合等。

tsm_system_rows

1.0

1.0

1.0

1.0

1.0

1.0

提供表采样方法SYSTEM_ROWS。

tsm_system_time

1.0

1.0

1.0

1.0

1.0

1.0

提供表采样方法SYSTEM_TIME。

unaccent

1.1

1.1

1.1

1.1

1.1

1.1

文本搜索字典，能从词位中移除重音（附加符号）。

uuid-ossp

1.1

1.1

1.1

1.1

1.1

1.1

提供函数使用几种标准算法之一产生通用唯一标识符（UUID）。

varbitx

1.1

1.1

1.1

1.1

1.1

1.1

支持多种BIT操作。

wal2json

2.6

2.6

2.6

2.6

2.6

2.5

将逻辑日志文件输出为JSON格式。

xml2

1.2

1.1

1.1

1.1

1.1

1.1

提供XPath查询和XSLT功能。

zhparser

2.2

2.2

2.2

2.2

1.0

1.0

中文全文搜索。

zombodb

-

-

-

-

-

4.0

强大的文本索引和分析功能。

上一篇：插件指南下一篇：管理插件

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
