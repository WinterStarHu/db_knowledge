---
title: 多表连接查询
summary: 介绍 TiDB 中的多表连接查询功能。
aliases: ['/zh/tidb/dev/join-tables','/zh/tidb/stable/dev-guide-join-tables/','/zh/tidb/dev/dev-guide-join-tables/','/zh/tidbcloud/dev-guide-join-tables/']
---

# 多表连接查询

很多时候，应用程序需要在一个查询当中使用到多张表的数据，这个时候可以通过 `JOIN` 语句将两张或多张表的数据组合在一起。

## Join 类型

此节将详细叙述 Join 的连接类型。

### 内连接 INNER JOIN

内连接的连接结果只返回匹配连接条件的行。

例如，想要知道编写过最多书的作家是谁，需要将作家基础信息表 `authors` 与书籍作者表 `book_authors` 进行连接。

![Inner Join](/media/develop/inner-join.png)

### 左外连接 LEFT OUTER JOIN

左外连接会返回左表中的所有数据行，以及右表当中能够匹配连接条件的值，如果在右表当中没有找到能够匹配的行，则使用 `NULL` 填充。

![Left Outer Join](/media/develop/left-outer-join.png)

在一些情况下，希望使用多张表来完成数据的查询，但是并不希望因为不满足连接条件而导致数据集变小。

例如，在 Bookshop 应用的首页，希望展示一个带有平均评分的最新书籍列表。在这种情况下，最新的书籍可能是还没有经过任何人评分的，如果使用内连接就会导致这些无人评分的书籍信息被过滤掉，而这并不是期望的结果。

### 右外连接 RIGHT OUTER JOIN

右外连接返回右表中的所有记录，以及左表当中能够匹配连接条件的值，没有匹配的值则使用 `NULL` 填充。

![Right Outer Join](/media/develop/right-outer-join.png)

### 交叉连接 CROSS JOIN

当连接条件恒成立时，两表之间的内连接称为[交叉连接](https://zh.wikipedia.org/wiki/%E8%BF%9E%E6%8E%A5#%E4%BA%A4%E5%8F%89%E8%BF%9E%E6%8E%A5)（又被称为“笛卡尔连接”）。交叉连接会把左表的每一条记录和右表的所有记录相连接，如果左表的记录数为 m，右表的记录数为 n，则结果集中会产生 m \* n 条记录。

### 左半连接 LEFT SEMI JOIN

TiDB 在 SQL 语法层面上不支持 `LEFT SEMI JOIN table_name`，但是在执行计划层面，[子查询相关的优化](/subquery-optimization.md)会将 `semi join` 作为改写后的等价 JOIN 查询默认的连接方式。

## 隐式连接

在显式声明连接的 `JOIN` 语句作为 SQL 标准出现之前，在 SQL 语句当中可以通过 `FROM t1, t2` 子句来连接两张或多张表，通过 `WHERE t1.id = t2.id` 子句来指定连接的条件。你可以将其理解为隐式声明的连接，隐式连接会使用内连接的方式进行连接。

## Join 相关算法

TiDB 支持下列三种常规的表连接算法，优化器会根据所连接表的数据量等因素来选择合适的 Join 算法去执行。你可以通过 `EXPLAIN` 语句来查看查询使用了何种算法进行 Join。

- [Index Join](/explain-joins.md#index-join)
- [Hash Join](/explain-joins.md#hash-join)
- [Merge Join](/explain-joins.md#merge-join)

如果发现 TiDB 的优化器没有按照最佳的 Join 算法去执行。你也可以通过 [Optimizer Hints](/optimizer-hints.md) 强制 TiDB 使用更好的 Join 算法去执行。

例如，假设上文当中的左连接查询的示例 SQL 使用 Hash Join 算法执行更快，而优化器并没有选择这种算法，你可以在 `SELECT` 关键字后面加上 Hint `/*+ HASH_JOIN(b, r) */`（注意：如果表名添加了别名，Hint 当中也应该使用表别名）。

```sql
EXPLAIN SELECT /*+ HASH_JOIN(b, r) */ b.id AS book_id, ANY_VALUE(b.title) AS book_title, AVG(r.score) AS average_score
FROM books b
LEFT JOIN ratings r ON b.id = r.book_id
GROUP BY b.id
ORDER BY b.published_at DESC
LIMIT 10;
```

Join 算法相关的 Hints：

- [MERGE_JOIN(t1_name [, tl_name ...])](/optimizer-hints.md#merge_joint1_name--tl_name-)
- [INL_JOIN(t1_name [, tl_name ...])](/optimizer-hints.md#inl_joint1_name--tl_name-)
- [INL_HASH_JOIN(t1_name [, tl_name ...])](/optimizer-hints.md#inl_hash_join)
- [HASH_JOIN(t1_name [, tl_name ...])](/optimizer-hints.md#hash_joint1_name--tl_name-)

## Join 顺序

在实际的业务场景中，多个表的 Join 语句是很常见的，而 Join 的执行效率和各个表参与 Join 的顺序有关。TiDB 使用 Join Reorder 算法来确定多个表进行 Join 的顺序。

当优化器选择的 Join 顺序并不够好时，你可以使用 `STRAIGHT_JOIN` 语法让 TiDB 强制按照 FROM 子句中所使用的表的顺序做联合查询。

```sql
EXPLAIN SELECT *
FROM authors a STRAIGHT_JOIN book_authors ba STRAIGHT_JOIN books b
WHERE b.id = ba.book_id AND ba.author_id = a.id;
```

关于该算法的实现细节和限制你可以通过查看[Join Reorder 算法简介](/join-reorder.md)章节进行了解。

## 扩展阅读

- [用 EXPLAIN 查看 JOIN 查询的执行计划](/explain-joins.md)
- [Join Reorder 算法简介](/join-reorder.md)
