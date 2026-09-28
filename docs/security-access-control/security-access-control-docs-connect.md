---
title: 连接 TiDB
summary: 学习如何使用 `pytidb` 客户端连接到 TiDB 数据库。
---

# 连接 TiDB

本指南介绍如何使用 `pytidb` 客户端连接到 TiDB 数据库。

## 安装依赖项

[`pytidb`](https://github.com/pingcap/pytidb) 是一个基于 [SQLAlchemy](https://sqlalchemy.org/) 构建的 Python 客户端。它提供了一系列高级 API，帮助你存储和搜索向量嵌入，无需编写原始 SQL。

要安装 Python 客户端，请运行以下命令：

```bash
pip install pytidb
```

## 使用连接参数进行连接

请根据你的 TiDB 部署类型选择相应步骤：

连接成功后，你可以使用 `db` 对象进行表操作、数据查询等。

## 使用连接字符串进行连接

如果你更喜欢使用连接字符串（数据库 URL），可以根据你的部署类型参考以下格式：

## 使用 SQLAlchemy 数据库引擎连接

如果你的应用已经有 SQLAlchemy 数据库引擎，可以通过 `db_engine` 参数复用：

```python title="main.py"
from pytidb import TiDBClient

db = TiDBClient(db_engine=db_engine)
```

## 后续步骤

连接到 TiDB 数据库后，你可以参考以下指南，学习如何操作你的数据：

- [表操作](/ai/guides/tables.md)：学习如何在 TiDB 中定义和管理表。
- [向量搜索](/ai/guides/vector-search.md)：使用向量嵌入进行语义搜索。
- [全文搜索](/ai/guides/vector-search-full-text-search-python.md)：通过关键字搜索文档。
- [混合搜索](/ai/guides/vector-search-hybrid-search.md)：结合向量和全文搜索，获得更相关的结果。
