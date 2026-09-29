# db-knowledge 全局索引

数据库知识库,一仓多分支。每个分支 = 一个 DB + 版本 = 一个 DB-GPT 知识库。

## 文档分支(25)

| 分支 | 数据库 | 版本 | 语言 | docs/文件数 |
|---|---|---|---|---|
| oracle-19c | Oracle | 19c | EN | 1124 |
| mysql-9.7 | MySQL | 9.7 | EN | 1 |
| postgresql-18 | PostgreSQL | 18 | EN | 1148 |
| postgresql-9.2 | PostgreSQL | 9.2 | EN | 1 |
| gaussdb-v2.0-25.860.0 | GaussDB | V2.0-25.860.0 | ZH | 2 |
| gaussdb-v2.0-26.861.1 | GaussDB | V2.0-26.861.1 | ZH | 2 |
| gaussdb-25.1.32 | GaussDB | 25.1.32 | ZH | 4 |
| gaussdb-24.7.30.10 | GaussDB | 24.7.30.10 | ZH | 1 |
| opengauss-6.0 | openGauss | 6.0 LTS | ZH | 2550 |
| oceanbase-4.3 | OceanBase | 4.3 | ZH | 1687 |
| tidb-8 | TiDB | 8 | ZH | 519 |
| clickhouse-24.3 | ClickHouse | 24.3 | EN | 1686 |
| redis-7.4 | Redis | 7.4 | EN | 371 |
| mongodb-7 | MongoDB | 7 | EN | 133 |
| sqlite-3.46 | SQLite | 3.46 | EN | 10 |
| sqlserver-2022 | SQL Server | 2022 | EN | 561 |
| spanner-2026 | Google Spanner | 2026 | ZH | 100 |
| kingbase-v9r1 | 金仓 KingBase | V9R1 | ZH | 150 |
| dm-8 | 达梦 DM | 8 | ZH | 100 |
| polardb-pg-15 | PolarDB-PG | 15 | ZH | 80 |
| polardb-mysql-8.0 | PolarDB-MySQL | 8.0 | ZH | 80 |
| polardb-xscale-2.0 | PolarDB-Xscale | 2.0 | ZH | 100 |
| tencentdb-mysql-8.0 | TencentDB-MySQL | 8.0 | EN | 100 |
| tencentdb-postgresql-14 | TencentDB-PG | 14 | EN | 64 |
| tencentdb-sqlserver-2019 | TencentDB-SQLServer | 2019 | EN | 114 |

## 源码分支(14)

| 分支 | 引擎 | 语言 |
|---|---|---|
| postgres-18-core-code | PG18 核心 | C |
| postgres-18-test-code | PG18 测试 | SQL |
| postgres-9.2-core-code | PG9.2 核心 | C |
| opengauss-6.0-core-code | openGauss 核心 | C |
| opengauss-6.0-test-code | openGauss 测试 | SQL |
| mysql-8.4-core-code | MySQL 核心 | C++ |
| mysql-8.4-test-code | MySQL 测试 | SQL |
| redis-7.4-core-code | Redis 核心 | C |
| clickhouse-24.3-core-code | ClickHouse 核心 | C++ |
| oceanbase-4.3-core-code | OceanBase 核心 | C++ |
| mongodb-7-core-code | MongoDB 核心 | C++ |
| sqlite-3.46-core-code | SQLite 核心 | C |
| tidb-8-core-code | TiDB 核心 | Go |
| polardb-pg-15-core-code | PolarDB-PG 核心 | C |

## 扩展知识库
| 分支 | 说明 |
|---|---|
| db-papers | 经典论文(181 篇,13 分类,含 Spanner/Raft/Dynamo/GFS/MapReduce/Calvin/PACELC 等) |
| books | 数据库经典书籍(23 本,含 DDIA/High Performance MySQL/Database Internals/Oracle/PG/MySQL Cookbook/Third Manifesto/DBMS/JDBC/数据库内核月报/GPT/Markdown/大模型) |
| blogs | 博客/教程(888 篇,阿里云数据库内核月报,118 分类) |

## 使用

### 1. 克隆 main 分支(浅克隆,不 fetch 其它分支,避免索引灾难)
```bash
git clone --depth 1 -b main git@github.com:WinterStarHu/db_knowledge.git
cd db-knowledge
```

### 2. 按需拉一个分支到 worktree(不全量 fetch)
```bash
# 语法: bash setup-worktree.sh <分支名>
bash setup-worktree.sh oracle-19c
```

### 3. DB-GPT 导入
DB-GPT 知识库 → 选 "Git Repository" → URL 填 `git@github.com:WinterStarHu/db_knowledge.git` → 分支填 `oracle-19c`
(或本地 clone 后用 "File" 方式导入 worktree 目录)

## 免责声明(侵权即删)
文档来源于公开渠道,转 Markdown 仅供内部学习与研究。版权归原作者,不以盈利为目的。侵权即删。
