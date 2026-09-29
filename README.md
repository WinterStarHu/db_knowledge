# db-knowledge

数据库知识库,服务于 DB-GPT(数据库专家 agent)。一仓多分支:每个分支 = 一个 DB + 版本 = 一个 DB-GPT 知识库。

## 结构(每个分支)
```
分支/
├── docs/          # 完整文档(整本保留,不切分)
├── README.md
├── INDEX.md
└── DISCLAIMER.md
```
DB-GPT 按 Markdown 标题(H1/H2/H3)自动切 chunk + bge-m3 向量 + BM25 检索,无需预拆。

## 分支
- 文档(25):oracle-19c / mysql-9.7 / postgresql-18 / postgresql-9.2 / gaussdb×4 / openGauss / oceanbase / tidb / clickhouse / redis / mongodb / sqlite / sqlserver / spanner / kingbase / dm / polardb×3 / tencentdb×3
- 源码(14):postgres-18/9.2 / openGauss / mysql-8.4 / redis / clickhouse / oceanbase / mongodb / sqlite / tidb / polardb-pg 各 core-code + PG/openGauss/mysql test-code
- 论文:db-papers(181 篇,13 分类)
- 书籍:books(23 本,8 分类)
- 博客:blogs(888 篇,阿里云数据库内核月报)
- main:索引+脚本

## 怎么用

### 1. 克隆 main 分支(浅克隆,不 fetch 其它分支,避免索引灾难)
```bash
git clone --depth 1 -b main git@github.com:WinterStarHu/db_knowledge.git
cd db-knowledge
```

### 2. 按需拉一个分支到 worktree(不全量 fetch)
```bash
# 语法: bash setup-worktree.sh <分支名>
bash setup-worktree.sh oracle-19c
bash setup-worktree.sh postgresql-18
bash setup-worktree.sh opengauss-6.0
bash setup-worktree.sh tidb-8
bash setup-worktree.sh clickhouse-24.3
bash setup-worktree.sh redis-7.4
bash setup-worktree.sh mongodb-7
bash setup-worktree.sh sqlite-3.46
bash setup-worktree.sh sqlserver-2022
bash setup-worktree.sh spanner-2026
bash setup-worktree.sh kingbase-v9r1
bash setup-worktree.sh dm-8
bash setup-worktree.sh polardb-pg-15
bash setup-worktree.sh polardb-mysql-8.0
bash setup-worktree.sh polardb-xscale-2.0
bash setup-worktree.sh tencentdb-mysql-8.0
bash setup-worktree.sh tencentdb-postgresql-14
bash setup-worktree.sh tencentdb-sqlserver-2019
bash setup-worktree.sh oceanbase-4.3
bash setup-worktree.sh gaussdb-v2.0-25.860.0
bash setup-worktree.sh gaussdb-v2.0-26.861.1
bash setup-worktree.sh gaussdb-25.1.32
bash setup-worktree.sh gaussdb-24.7.30.10
bash setup-worktree.sh mysql-9.7
bash setup-worktree.sh postgresql-9.2
bash setup-worktree.sh db-papers
bash setup-worktree.sh books
bash setup-worktree.sh blogs
```

### 3. DB-GPT 导入
DB-GPT 知识库 → 选 "Git Repository" → URL 填 `git@github.com:WinterStarHu/db_knowledge.git` → 分支填 `oracle-19c`
(或本地 clone 后用 "File" 方式导入 worktree 目录)

