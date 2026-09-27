# db-knowledge 全局索引

数据库知识库,一仓多分支。每个分支 = 一个 DB + 版本 = 一个 DB-GPT 知识库。

## 文档分支

| 分支 | 数据库 | 版本 | 说明 |
|---|---|---|---|
| oracle-19c | Oracle | 19c | 安全指南/数据字典视图/网络连接 |
| mysql-9.7 | MySQL | 9.7 | Reference Manual(含 NDB Cluster) |
| postgresql-18 | PostgreSQL | 18 | 1148 篇官方文档 |
| postgresql-9.2 | PostgreSQL | 9.2 | openGauss fork 基础参考(PDF 待转) |
| gaussdb-v2.0-25.860.0 | GaussDB | V2.0-25.860.0 | 华为产品文档(分布式+集中式) |
| gaussdb-v2.0-26.861.1 | GaussDB | V2.0-26.861.1 | 华为产品文档(华为云Stack+轻量化) |
| gaussdb-25.1.32 | GaussDB | 25.1.32 | 云数据库+轻量化部署形态 |
| gaussdb-24.7.30.10 | GaussDB | 24.7.30.10 | 云数据库(华为云Stack) |
| opengauss-6.0 | openGauss | 6.0 LTS | 官方文档(中文,基于 PG 9.2.4 fork) |
| oceanbase-4.3 | OceanBase | 4.3 | 中文文档(gitee,1689md) |
| tidb-8 | TiDB | 8 | 中文文档(pingcap/docs-cn,523md) |
| clickhouse-24.3 | ClickHouse | 24.3 | 英文文档(reference/operations等,1692) |
| redis-7.4 | Redis | 7.4 | 命令文档(redis-doc,371) |
| mongodb-7 | MongoDB | 7 | 完整用户文档(mongodb/docs tarball,137md) |
| sqlite-3.46 | SQLite | 3.46 | 关键文档(sqlite.org,13页) |
| spanner-2026 | Google Spanner | 2026(云服务快照) | 中文(经代理 docs.cloud.google.com,100页) |
| polardb-pg-15 | PolarDB-PG | 15 | 阿里云文档(PostgreSQL兼容,80页) |
| polardb-mysql-8.0 | PolarDB-MySQL | 8.0 | 阿里云文档(MySQL兼容,80页) |
| polardb-xscale-2.0 | PolarDB-Xscale | 2.0 | 分布式版,阿里云中文(100页) |
| tencentdb-mysql-8.0 | TencentDB-MySQL | 8.0 | 腾讯云中文(cloud.tencent.com,56页) |
| tencentdb-postgresql-14 | TencentDB-PG | 14 | 腾讯云中文(40页) |
| tencentdb-sqlserver-2019 | TencentDB-SQLServer | 2019 | 腾讯云中文(32页) |
| kingbase-v9r1 | 金仓 KingBase | V9R1 | 文档(docs.kingbase.com.cn,150页) |
| dm-8 | 达梦 DM | 8 | 官方文档(爬 eco.dameng.com,100页) |


## 源码分支

| 分支 | 说明 |
|---|---|
| postgres-18-core-code | PG 18 核心 src/backend+src/include (@REL_18_4, 71M) |
| postgres-18-test-code | PG 18 回归测试 SQL (233 个 .sql) |
| opengauss-6.0-core-code | openGauss 6.0 核心 src/gausskernel+src/include (@v6.0.0, 82M) |
| opengauss-6.0-test-code | openGauss 6.0 回归测试 SQL (1427 个 .sql) |
| mysql-8.4-core-code | MySQL 8.4 核心 sql/+include/+storage/innobase (56M) |
| mysql-8.4-test-code | MySQL 8.4 测试用例 mysql-test/t (19M) |
| sqlite-core-code | SQLite 核心 src/ (95 C 文件) |
| redis-core-code | Redis 核心 src/ (219 C 文件,12M) |
| clickhouse-24.3-core-code | ClickHouse 核心 src/ (9067 C++文件,112M) |
| oceanbase-4.3-core-code | OceanBase 4.3 核心 src/ (10071 文件,269M) |
| mongodb-7-core-code | MongoDB 7 核心 src/ (gitee) |
| db-papers | 经典论文 | - | Spanner+Raft(PDF转文本) |

## 使用

```bash
# 1. clone main(浅克隆,不 fetch 其它分支)
git clone --depth 1 -b main git@github.com:WinterStarHu/db-knowledge.git

# 2. 按需拉一个分支到 worktree(不全量 fetch,避免索引灾难)
bash setup-worktree.sh 19c
bash setup-worktree.sh postgresql-18
# ...
```

## 统一分类法

所有分支共用 13 个顶层目录:sql/ architecture/ storage/ transactions/ administration/
performance/ availability/ security/ development/ networking/ data-dictionary/ troubleshooting/ migration/

每个 Level 2 子目录下:docs/ papers/ blogs/ examples/(有内容才建)。

详见 [DISCLAIMER.md](DISCLAIMER.md)。

