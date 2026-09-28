# 使用pgbench测试PolarDB PostgreSQL兼容Oracle版最大性能-云原生数据库 PolarDB-阿里云

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-oracle/performance-white-paper-1

使用pgbench测试PolarDB PostgreSQL兼容Oracle版最大性能-云原生数据库 PolarDB-阿里云

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

性能白皮书

性能白皮书

更新时间：

复制 MD 格式

产品详情 我的收藏

PostgreSQL自带一款轻量级的压力测试工具pgbench。pgbench是一种在PostgreSQL（兼容Oracle）上运行基准测试的简单程序，它可以在并发的数据库会话中重复运行相同的SQL命令。本文介绍如何使用pgbench测试PolarDB PostgreSQL版（兼容Oracle）集群的最大性能。
测试环境 所有测试均在华北1（青岛）地域完成，PolarDB集群和ECS实例在同一可用区。
ECS的实例规格：ecs.g5.16xlarge（64核 256 GiB）。
ECS存储规格：SSD本地盘200 GiB。
网络类型：专有网络（VPC），PolarDB集群和ECS实例在同一VPC。
操作系统：CentOS 7.6 x64。
PolarDB集群节点数：1个主节点和1个只读节点。

说明 CentOS 6不支持PostgreSQL 11。
测试指标 只读QPS 数据库只读时每秒执行的SQL数（仅包含SELECT）。
读写QPS 数据库读写时每秒执行的SQL数（包含INSERT、SELECT、UPDATE）。
准备工作 安装测试工具 执行如下命令在ECS实例中安装PostgreSQL 11。
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm sudo yum install -y postgresql11 修改集群参数 PolarDB集群需要修改的配置参数如下： log_statement = 'none' enable_hashjoin=off enable_mergejoin=off enable_bitmapscan=off

说明 目前仅log_statement参数支持在控制台修改。设置集群参数的方式，请参见设置集群参数。
修改配置参数后，重启集群让配置生效。
测试方法 通过以下命令配置环境变量： export PGHOST=<PolarDB集群地址的私网地址> export PGPORT=<PolarDB集群地址的私网端口> export PGDATABASE=postgres export PGUSER=<PolarDB数据库用户名> export PGPASSWORD=<PolarDB对应用户的密码>

说明 如何查看PolarDB PostgreSQL版（兼容Oracle）集群的连接地址，请参见查看连接地址和端口。
根据目标库大小初始化测试数据，具体命令如下： 初始化数据10亿： /usr/pgsql-11/bin/pgbench -i -s 10000 初始化数据5亿： /usr/pgsql-11/bin/pgbench -i -s 5000 初始化数据1亿： /usr/pgsql-11/bin/pgbench -i -s 1000 创建只读和读写的测试脚本。
创建只读脚本ro.sql： 在命令行执行vim ro.sql命令。
按I键进入编辑页面。
在编辑页面输入如下内容： \set aid random_gaussian(1, :range, 10.0) SELECT abalance FROM pgbench_accounts WHERE aid = :aid;
按Esc键退出编辑，输入:wq进行保存并退出。
创建读写脚本rw.sql： 在命令行执行vim rw.sql命令。
按I键进入编辑页面。
在编辑页面输入如下内容： \set aid random_gaussian(1, :range, 10.0) \set bid random(1, 1 * :scale) \set tid random(1, 10 * :scale) \set delta random(-5000, 5000) BEGIN;
UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;
SELECT abalance FROM pgbench_accounts WHERE aid = :aid;
UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid;
UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid;
INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);
END;
按Esc键退出编辑，输入:wq进行保存并退出。
在命令行执行如下命令测试： 只读测试： 88C 710 GB(polar.o.x8.12xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 256 -j 128 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 256 -j 128 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 256 -j 128 -T 120 -D scale=10000 -D range=1000000000

64C 512 GB(polar.o.x8.8xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 256 -j 128 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 256 -j 128 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 256 -j 128 -T 120 -D scale=10000 -D range=1000000000

32C 256 GB(polar.o.x8.4xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 128 -j 128 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 128 -j 128 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 128 -j 128 -T 120 -D scale=10000 -D range=1000000000

16cC 128 GB(polar.o.x8.2xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=1000000000

8C 64 GB(polar.o.x8.xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 64 -j 32 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 64 -j 32 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 64 -j 32 -T 120 -D scale=10000 -D range=1000000000

8C 32 GB(polar.o.x4.xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 64 -j 32 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 64 -j 32 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 64 -j 32 -T 120 -D scale=10000 -D range=1000000000

4C 16 GB(polar.o.x4.large) 总数据量5亿，热数据5000万 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 32 -j 32 -T 120 -D scale=5000 -D range=50000000 总数据量5亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 32 -j 32 -T 120 -D scale=5000 -D range=100000000

2C 4 GB(polar.o.x4.medium) 总数据量1亿，热数据5000万 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./ro.sql -c 16 -j 32 -T 120 -D scale=1000 -D range=50000000 总数据量1亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./ro.sql -c 16 -j 32 -T 120 -D scale=1000 -D range=100000000 读写测试： 88C 710 GB(polar.o.x8.12xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 256 -j 256 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 256 -j 256 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 256 -j 256 -T 120 -D scale=10000 -D range=1000000000

64C 512 GB(polar.o.x8.8xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 256 -j 256 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 256 -j 256 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 256 -j 256 -T 120 -D scale=10000 -D range=1000000000

32C 256 GB(polar.o.x8.4xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 128 -j 128 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 128 -j 128 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 128 -j 128 -T 120 -D scale=10000 -D range=1000000000

16C 128 GB(polar.o.x8.2xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=1000000000

8C 64 GB(polar.o.x8.xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 64 -j 64 -T 120 -D scale=10000 -D range=1000000000

8C 32 GB(polar.o.x4.xlarge) 总数据量10亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 32 -j 32 -T 120 -D scale=10000 -D range=100000000 总数据量10亿，热数据5亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 32 -j 32 -T 120 -D scale=10000 -D range=500000000 总数据量10亿，热数据10亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 32 -j 32 -T 120 -D scale=10000 -D range=1000000000

4C 16 GB(polar.o.x4.large) 总数据量5亿，热数据5000万 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 16 -j 16 -T 120 -D scale=5000 -D range=50000000 总数据量5亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 16 -j 16 -T 120 -D scale=5000 -D range=100000000

2C 8 GB(polar.o.x4.medium) 总数据量1亿，热数据5000万 /usr/pgsql-11/bin/pgbench -M prepared -v -r -P 1 -f ./rw.sql -c 8 -j 8 -T 120 -D scale=1000 -D range=50000000 总数据量1亿，热数据1亿 /usr/pgsql-11/bin/pgbench -M prepared -n -r -P 1 -f ./rw.sql -c 8 -j 8 -T 120 -D scale=1000 -D range=100000000

说明 scale：该值乘以10万表示测试数据量。
range：表示活跃数据量。
-c：表示测试连接数，测试连接数不代表该规格的最大连接数，最大连接数请参考计算节点规格。
测试结果 规格测试数据量热（活跃）数据量只读QPS读写QPS

polar.o.x8.12xlarge 88核 710 GB10亿1亿630650.40263746.37 5亿601262.24247352.76 10亿589405.79218788.92

polar.o.x8.8xlarge 64核 512 GB10亿1亿592064.65227352.23 5亿554777.11213343.13 10亿508404.07203331.35

polar.o.x8.4xlarge 32核 256 GB10亿1亿522182.92213212.34 5亿509372.85203322.34 10亿489349.72198531.37

polar.o.x8.2xlarge 16核 128 GB10亿1亿263893.72152863.27 5亿250221.62129238.26 10亿239832.62106212.82

polar.o.x8.xlarge 8核 64 GB10亿1亿142836.5669725.29 5亿133931.6955927.65 10亿124151.0250786.21

polar.o.x4.xlarge 8核 32 GB10亿1亿126748.0759738.33 5亿113432.3248372.25 10亿104232.8449763.64

polar.o.x4.large 4核 16 GB5亿5000万76238.8947388.27 1亿69892.8343638.85

polar.o.x4.medium 2核 8 GB1亿5000万28320.7018152.63 1亿30792.1919111.15

说明 规格：PolarDB PostgreSQL版（兼容Oracle）的规格代码。
测试数据量：本轮测试数据的记录条数。
热（活跃）数据量：本轮测试的查询、更新SQL的记录条数。
只读QPS：只读测试的结果，表示每秒请求数。
读写QPS：读写测试的结果，表示每秒请求数。

上一篇：未来规划下一篇：性能调优指南

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
