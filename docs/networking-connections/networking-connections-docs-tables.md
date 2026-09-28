---
title: 使用表
summary: 了解如何在 TiDB 中使用表。
---

# 使用表

TiDB 使用表来组织和存储相关数据集合。它提供了灵活的 schema 定义能力，因此你可以根据具体需求设计表结构。

一个表可以包含多个不同数据类型的列。支持的数据类型包括文本、数字、向量、二进制数据（`BLOB`）、JSON 等。

本文档展示了如何使用 [`pytidb`](https://github.com/pingcap/pytidb) 操作表。

`pytidb` 是 TiDB 官方的 Python SDK，旨在帮助开发者高效构建 AI 应用。

> **注意：**
>
> 完整的可运行示例请参见我们仓库中的 [basic example](https://github.com/pingcap/pytidb/tree/main/examples/basic)。

## 创建表

### 使用 TableModel

`pytidb` 提供了一个 `TableModel` class，用于表示表的 schema。该 class 兼容 [Pydantic model](https://docs.pydantic.dev/latest/concepts/models/)，可以让你以声明式方式定义表。

在以下示例中，你将创建一个名为 `items` 的表，包含以下列：

- `id`：主键列，整数型
- `content`：文本类型列
- `embedding`：3 维向量类型列
- `meta`：JSON 类型列

## 向表中添加数据

### 使用 TableModel

你可以使用 `TableModel` instance 表示一行数据并插入到表中。

插入单条记录：

插入多条记录：

### 使用 Dict

你也可以使用 `dict` 表示行并插入到表中。这种方式更灵活，无需定义 `TableModel` 即可插入数据。

插入单条记录：

## 保存数据到表

`save` method 提供了一种便捷方式来插入或更新单行数据。对于一行数据，如果主键在表中不存在，则插入为新行；如果记录已存在，则覆盖整行数据。

> **注意：**
>
> 如果记录 ID 已存在于表中，`table.save()` 会覆盖整个记录。如需只修改部分字段，请使用 `table.update()`。

## 从表中查询数据

要从表中获取记录：

根据查询条件获取记录：

完整的过滤操作及示例请参考 [Filtering](/ai/guides/filtering.md) 指南。

## 修改表中数据

## 从表中删除数据

## 清空表

## 删除表
