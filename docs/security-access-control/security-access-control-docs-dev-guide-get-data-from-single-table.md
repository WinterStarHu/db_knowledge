---
title: 单表查询
summary: 介绍 TiDB 中的单表查询功能。
aliases: ['/zh/tidb/dev/get-data-from-single-table','/zh/tidb/stable/dev-guide-get-data-from-single-table/','/zh/tidb/dev/dev-guide-get-data-from-single-table/','/zh/tidbcloud/dev-guide-get-data-from-single-table/']
---

# 单表查询

在这个章节当中，将开始介绍如何使用 SQL 来对数据库中的数据进行查询。

## 开始之前

下面将围绕 [Bookshop](/develop/dev-guide-bookshop-schema-design.md) 这个应用程序来对 TiDB 的数据查询部分展开介绍。

在阅读本章节之前，你需要做以下准备工作：

1. 构建 TiDB 集群（推荐使用 [TiDB Cloud](/develop/dev-guide-build-cluster-in-cloud.md) 或 [TiUP](/production-deployment-using-tiup.md)）。
2. [导入 Bookshop 应用程序的表结构和示例数据](/develop/dev-guide-bookshop-schema-design.md#导入表结构和数据)。
3. [连接到 TiDB](/develop/dev-guide-connect-to-tidb.md)。

## 简单的查询

在 Bookshop 应用程序的数据库当中，`authors` 表存放了作家们的基础信息，可以通过 `SELECT ... FROM ...` 语句将数据从数据库当中调取出去。

## 对结果进行筛选

查询得到的结果非常多，但是并不都是你想要的？可以通过 `WHERE` 语句对查询的结果进行过滤，从而找到想要查询的部分。

例如，想要查找众多作家当中找出在 1998 年出生的作家：

## 对结果进行排序

使用 `ORDER BY` 语句可以让查询结果按照期望的方式进行排序。

例如，可以通过下面的 SQL 语句对 `authors` 表的数据按照 `birth_year` 列进行降序 (`DESC`) 排序，从而得到最年轻的作家列表。

查询结果如下：

```
+-----------+------------------------+------------+
| id        | name                   | birth_year |
+-----------+------------------------+------------+
| 83420726  | Terrance Dach          | 2000       |
| 57938667  | Margarita Christiansen | 2000       |
| 77441404  | Otto Dibbert           | 2000       |
| 61338414  | Danial Cormier         | 2000       |
| 49680887  | Alivia Lemke           | 2000       |
| 45460101  | Itzel Cummings         | 2000       |
| 38009380  | Percy Hodkiewicz       | 2000       |
| 12943560  | Hulda Hackett          | 2000       |
| 1294029   | Stanford Herman        | 2000       |
| 111453184 | Jeffrey Brekke         | 2000       |
...
300000 rows in set (0.23 sec)
```

## 限制查询结果数量

如果希望 TiDB 只返回部分结果，可以使用 `LIMIT` 语句限制查询结果返回的记录数。

查询结果如下：

```
+-----------+------------------------+------------+
| id        | name                   | birth_year |
+-----------+------------------------+------------+
| 83420726  | Terrance Dach          | 2000       |
| 57938667  | Margarita Christiansen | 2000       |
| 77441404  | Otto Dibbert           | 2000       |
| 61338414  | Danial Cormier         | 2000       |
| 49680887  | Alivia Lemke           | 2000       |
| 45460101  | Itzel Cummings         | 2000       |
| 38009380  | Percy Hodkiewicz       | 2000       |
| 12943560  | Hulda Hackett          | 2000       |
| 1294029   | Stanford Herman        | 2000       |
| 111453184 | Jeffrey Brekke         | 2000       |
+-----------+------------------------+------------+
10 rows in set (0.11 sec)
```

通过观察查询结果你会发现，在使用 `LIMIT` 语句之后，查询的时间明显缩短，这是 TiDB 对 `LIMIT` 子句进行优化后的结果，你可以通过 [TopN 和 Limit 下推](/topn-limit-push-down.md)章节了解更多细节。

## 聚合查询

如果你想要关注数据整体的情况，而不是部分数据，你可以通过使用 `GROUP BY` 语句配合聚合函数，构建一个聚合查询来帮助你对数据的整体情况有一个更好的了解。

比如说，你希望知道哪些年出生的作家比较多，你可以将作家基本信息按照 `birth_year` 列进行分组，然后分别统计在当年出生的作家数量：

查询结果如下：

```
+------------+--------------+
| birth_year | author_count |
+------------+--------------+
|       1932 |          317 |
|       1947 |          290 |
|       1939 |          282 |
|       1935 |          289 |
|       1968 |          291 |
|       1962 |          261 |
|       1961 |          283 |
|       1986 |          289 |
|       1994 |          280 |
...
|       1972 |          306 |
+------------+--------------+
71 rows in set (0.00 sec)
```

除了 `COUNT` 函数外，TiDB 还支持了其他聚合函数。详情请参考 [GROUP BY 聚合函数](/functions-and-operators/aggregate-group-by-functions.md)。
