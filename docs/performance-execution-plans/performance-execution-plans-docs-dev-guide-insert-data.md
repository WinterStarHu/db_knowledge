---
title: 插入数据
summary: 插入数据、批量导入数据的方法、最佳实践及例子。
aliases: ['/zh/tidb/dev/insert-data','/zh/tidb/stable/dev-guide-insert-data/','/zh/tidb/dev/dev-guide-insert-data/','/zh/tidbcloud/dev-guide-insert-data/']
---

# 插入数据

此页面将展示使用 SQL 语言，配合各种编程语言将数据插入到 TiDB 中。

## 在开始之前

在阅读本页面之前，你需要准备以下事项：

- [创建 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md)。
- 阅读[数据库模式概览](/develop/dev-guide-schema-design-overview.md)，并[创建数据库](/develop/dev-guide-create-database.md)、[创建表](/develop/dev-guide-create-table.md)、[创建二级索引](/develop/dev-guide-create-secondary-indexes.md)。

## 插入行

假设你需要插入多行数据，那么会有两种插入的办法，假设需要插入 3 个玩家数据：

- 一个**多行插入语句**：

{{}}

    ```sql
    INSERT INTO `player` (`id`, `coins`, `goods`) VALUES (1, 1000, 1), (2, 230, 2), (3, 300, 5);
    ```

- 多个**单行插入语句**：

{{}}

    ```sql
    INSERT INTO `player` (`id`, `coins`, `goods`) VALUES (1, 1000, 1);
    INSERT INTO `player` (`id`, `coins`, `goods`) VALUES (2, 230, 2);
    INSERT INTO `player` (`id`, `coins`, `goods`) VALUES (3, 300, 5);
    ```

一般来说使用一个`多行插入语句`，会比多个`单行插入语句`快。

## 批量插入

如果你需要快速地将大量数据导入 TiDB，最好的方式并不是使用 `INSERT` 语句，这并不是最高效的方法，而且需要你自行处理异常等问题。推荐使用以下工具进行数据批量插入：

## 避免热点

在设计表时需要考虑是否存在大量插入行为，若有，需在表设计期间对热点进行规避。请查看[创建表 - 选择主键](/develop/dev-guide-create-table.md#选择主键)部分，并遵从[选择主键时应遵守的规则](/develop/dev-guide-create-table.md#选择主键时应遵守的规则)。

更多有关热点问题的处理办法，请参考 [TiDB 热点问题处理](/troubleshoot-hot-spot-issues.md)文档。

## 主键为 `AUTO_RANDOM` 表插入数据

在插入的表主键为 `AUTO_RANDOM` 时，这时默认情况下，不能指定主键。例如 [bookshop](/develop/dev-guide-bookshop-schema-design.md) 数据库中，可以看到 [users 表](/develop/dev-guide-bookshop-schema-design.md#users-表)的 `id` 字段含有 `AUTO_RANDOM` 属性。

此时，不可使用类似以下 SQL 进行插入：

```sql
INSERT INTO `bookshop`.`users` (`id`, `balance`, `nickname`) VALUES (1, 0.00, 'nicky');
```

将会产生错误：

```
ERROR 8216 (HY000): Invalid auto random: Explicit insertion on auto_random column is disabled. Try to set @@allow_auto_random_explicit_insert = true.
```

这是旨在提示你，不建议在插入时手动指定 `AUTO_RANDOM` 的列。这时，你有两种解决办法处理此错误：

- (推荐) 插入语句中去除此列，使用 TiDB 帮你初始化的 `AUTO_RANDOM` 值。这样符合 `AUTO_RANDOM` 的语义。

{{}}

    ```sql
    INSERT INTO `bookshop`.`users` (`balance`, `nickname`) VALUES (0.00, 'nicky');
    ```

- 如果你确认一定需要指定此列，那么可以使用 [SET 语句](/sql-statements/sql-statement-set-variable.md)通过更改用户变量的方式，允许在插入时，指定 `AUTO_RANDOM` 的列。

{{}}

    ```sql
    SET @@allow_auto_random_explicit_insert = true;
    INSERT INTO `bookshop`.`users` (`id`, `balance`, `nickname`) VALUES (1, 0.00, 'nicky');
    ```

## 使用 HTAP

在 TiDB 中，使用 HTAP 能力无需你在插入数据时进行额外操作。不会有任何额外的插入逻辑，由 TiDB 自动进行数据的一致性保证。你只需要在创建表后，[开启列存副本同步](/develop/dev-guide-create-table.md#使用-htap-能力)，就可以直接使用列存副本来加速你的查询。
