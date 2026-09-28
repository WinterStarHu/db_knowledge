# db-knowledge
数据库知识库(服务于 DB-GPT)。一个仓库,多个分支,每个分支 = 一个 DB + 版本。
## 快速开始
```bash
git clone --depth 1 -b main git@github.com:WinterStarHu/db-knowledge.git
cd db-knowledge
bash setup-worktree.sh oracle-19c   # 按需拉一个分支到 worktree
cd ../db-knowledge-oracle-19c/       # 进目录操作,不用 checkout 切换
```
## 分支列表
文档: oracle-19c / mysql-9.7 / postgresql-18 / postgresql-9.2 / gaussdb-v2.0-25.860.0 / opengauss-6.0
源码: *-core-code / *-test-code
## 目录结构(每个分支统一)
13 顶层分类,每类下有 Level 2 子目录,再下有 Level 3 内容类型(docs/papers/blogs/examples)
