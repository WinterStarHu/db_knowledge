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

## 源码分支(将来加)

| 分支 | 说明 |
|---|---|
| postgres-18-core-code | PG 18 核心(src/backend + src/include) |
| postgres-9.2-core-code | PG 9.2 核心(openGauss 基础) |
| mysql-9.7-core-code | MySQL 9.7 核心 |
| opengauss-6.0-core-code | openGauss 6.0 核心 |
| *-test-code | 对应测试用例 |

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
