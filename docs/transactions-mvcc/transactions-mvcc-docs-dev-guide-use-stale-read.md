---
title: Stale Read
summary: 使用 Stale Read 在特定情况下加速查询。
aliases: ['/zh/tidb/dev/use-stale-read','/zh/tidb/stable/dev-guide-use-stale-read/','/zh/tidb/dev/dev-guide-use-stale-read/','/zh/tidbcloud/dev-guide-use-stale-read/']
---

# Stale Read

Stale Read 是一种读取历史数据版本的机制，通过 Stale Read 功能，你能从指定时间点或时间范围内读取对应的历史数据，从而在数据强一致需求没那么高的场景降低读取数据的延迟。当使用 Stale Read 时，TiDB 默认会随机选择一个副本来读取数据，因此能利用所有保存有副本的节点的处理能力。

在实际的使用当中，请根据具体的[场景](/stale-read.md#场景描述)判断是否适合在 TiDB 当中开启 Stale Read 功能。如果你的应用程序不能容忍读到非实时的数据，请勿使用 Stale Read，否则读到的数据可能不是最新成功写入的数据。

TiDB 提供了语句级别、事务级别、会话级别三种级别的 Stale Read 功能，接下来将逐一进行介绍：

## 引入

在 [Bookshop](/develop/dev-guide-bookshop-schema-design.md) 应用程序当中，你可以通过下面的 SQL 语句查询出最新出版的书籍以及它们的价格：

```sql
SELECT id, title, type, price FROM books ORDER BY published_at DESC LIMIT 5;
```

运行结果为：

```
+------------+------------------------------+-----------------------+--------+
| id         | title                        | type                  | price  |
+------------+------------------------------+-----------------------+--------+
| 3181093216 | The Story of Droolius Caesar | Novel                 | 100.00 |
| 1064253862 | Collin Rolfson               | Education & Reference |  92.85 |
| 1748583991 | The Documentary of cat       | Magazine              | 159.75 |
|  893930596 | Myrl Hills                   | Education & Reference | 356.85 |
| 3062833277 | Keven Wyman                  | Life                  | 477.91 |
+------------+------------------------------+-----------------------+--------+
5 rows in set (0.02 sec)
```

看到此时（2022-04-20 15:20:00）的列表中，**The Story of Droolius Caesar** 这本小说的价格为 100.0 元。

于此同时，卖家发现这本书很受欢迎，于是他通过下面的 SQL 语句将这本书的价格高到了 150.0 元。

```sql
UPDATE books SET price = 150 WHERE id = 3181093216;
```

运行结果为：

```
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

当再次查询最新书籍列表时，发现这本书确实涨价了。

```
+------------+------------------------------+-----------------------+--------+
| id         | title                        | type                  | price  |
+------------+------------------------------+-----------------------+--------+
| 3181093216 | The Story of Droolius Caesar | Novel                 | 150.00 |
| 1064253862 | Collin Rolfson               | Education & Reference |  92.85 |
| 1748583991 | The Documentary of cat       | Magazine              | 159.75 |
|  893930596 | Myrl Hills                   | Education & Reference | 356.85 |
| 3062833277 | Keven Wyman                  | Life                  | 477.91 |
+------------+------------------------------+-----------------------+--------+
5 rows in set (0.01 sec)
```

如果不要求必须使用最新的数据，可以让 TiDB 通过 Stale Read 功能直接返回可能已经过期的历史数据，避免使用强一致性读时数据同步带来的延迟。

假设在 Bookshop 应用程序当中，在用户浏览书籍列表页时，不对书籍价格的实时性进行要求，只有用户在点击查看书籍详情页或下单时才去获取实时的价格信息，可以借助 Stale Read 能力来进一步提升应用的吞吐量。

## 语句级别

## 事务级别

通过 `START TRANSACTION READ ONLY AS OF TIMESTAMP` 语句，你可以开启一个基于历史时间的只读事务，该事务基于所提供的历史时间来读取历史数据。

通过 `SET TRANSACTION READ ONLY AS OF TIMESTAMP` 语句，你可以将当前事务或下一个事务设置为基于指定历史时间的只读事务。该事务将会基于所提供的历史时间来读取历史数据。

## 会话级别

为支持读取历史版本数据，TiDB 从 5.4 版本起引入了一个新的系统变量 `tidb_read_staleness`。系统变量 `tidb_read_staleness` 用于设置当前会话允许读取的历史数据范围，其数据类型为 int，作用域为 SESSION。

## 扩展阅读

- [Stale Read 功能的使用场景](/stale-read.md)
- [使用 AS OF TIMESTAMP 语法读取历史数据](/as-of-timestamp.md#语法方式)
- [通过系统变量 tidb_read_staleness 读取历史数据](/tidb-read-staleness.md)
