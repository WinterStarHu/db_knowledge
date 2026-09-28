---
title: 预处理语句
summary: 介绍 TiDB 的预处理语句功能。
aliases: ['/zh/tidb/dev/prepared-statement','/zh/tidb/stable/dev-guide-prepared-statement/','/zh/tidb/dev/dev-guide-prepared-statement/','/zh/tidbcloud/dev-guide-prepared-statement/']
---

# 预处理语句

[预处理语句](/sql-statements/sql-statement-prepare.md)是一种将多个仅有参数不同的 SQL 语句进行模板化的语句，它让 SQL 语句与参数进行了分离。可以用它提升 SQL 语句的：

- 安全性：因为参数和语句已经分离，所以避免了 [SQL 注入攻击](https://en.wikipedia.org/wiki/SQL_injection)的风险。
- 性能：因为语句在 TiDB 端被预先解析，后续执行只需要传递参数，节省了完整 SQL 解析、拼接 SQL 语句字符串以及网络传输的代价。

在大部分的应用程序中，SQL 语句是可以被枚举的，可以使用有限个 SQL 语句来完成整个应用程序的数据查询，所以使用预处理语句是最佳实践之一。

## SQL 语法

本节将介绍创建、使用及删除预处理语句的 SQL 语法。

### 创建预处理语句

```sql
PREPARE {prepared_statement_name} FROM '{prepared_statement_sql}';
```

|            参数             |                  描述                  |
| :-------------------------: | :------------------------------------: |
| `{prepared_statement_name}` |             预处理语句名称             |
| `{prepared_statement_sql}`  | 预处理语句 SQL，以英文半角问号做占位符 |

你可查看 [PREPARE 语句](/sql-statements/sql-statement-prepare.md)获得更多信息。

### 使用预处理语句

预处理语句仅可使用用户变量作为参数，因此，需先使用 [SET 语句](/sql-statements/sql-statement-set-variable.md)设置变量后，供 [EXECUTE 语句](/sql-statements/sql-statement-execute.md)调用预处理语句。

```sql
SET @{parameter_name} = {parameter_value};
EXECUTE {prepared_statement_name} USING @{parameter_name};
```

|            参数             |                                 描述                                  |
| :-------------------------: | :-------------------------------------------------------------------: |
|     `{parameter_name}`      |                              用户参数名                               |
|     `{parameter_value}`     |                              用户参数值                               |
| `{prepared_statement_name}` | 预处理语句名称，需和[创建预处理语句](#创建预处理语句)中定义的名称一致 |

你可查看 [EXECUTE 语句](/sql-statements/sql-statement-execute.md)获得更多信息。

### 删除预处理语句

```sql
DEALLOCATE PREPARE {prepared_statement_name};
```

|            参数             |                                 描述                                  |
| :-------------------------: | :-------------------------------------------------------------------: |
| `{prepared_statement_name}` | 预处理语句名称，需和[创建预处理语句](#创建预处理语句)中定义的名称一致 |

你可查看 [DEALLOCATE 语句](/sql-statements/sql-statement-deallocate.md)获得更多信息。

## 例子

本节以使用预处理语句，完成查询数据和插入数据两个场景的示例。

### 查询示例

例如，需要查询 [Bookshop 应用](/develop/dev-guide-bookshop-schema-design.md#books-表)中，`id` 为 1 的书籍信息。

### 插入示例

还是使用 [books 表](/develop/dev-guide-bookshop-schema-design.md#books-表)为例，需要插入一个 `title` 为 `TiDB Developer Guide`, `type` 为 `Science & Technology`, `stock` 为 `100`, `price` 为 `0.0`, `published_at` 为 `插入的当前时间` 的书籍信息。需要注意的是，`books` 表的主键包含 `AUTO_RANDOM` 属性，无需指定它。如果你对插入数据还不了解，可以在[插入数据](/develop/dev-guide-insert-data.md)一节了解更多数据插入的相关信息。
