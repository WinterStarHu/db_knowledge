# PostgreSQL 18 核心源码

来源:postgres @ REL_18_4
内容:src/backend, src/include

## 目录 -> 知识域映射
- `src/backend/` 或等价 -> SQL 解析/执行器/优化器/存储/事务/锁
  - `parser/` -> SQL 语法解析
  - `optimizer/` -> 执行计划优化
  - `executor/` -> 执行引擎
  - `storage/` -> 存储引擎/MVCC/锁
  - `tcop/` -> 查询调度
- `src/include/` -> 头文件/数据结构定义

## 切片(DB-GPT)
tree-sitter 按 C/C++ AST 切,函数/结构体级检索。保留原目录结构。

## 版权
见 [DISCLAIMER.md](DISCLAIMER.md)。
