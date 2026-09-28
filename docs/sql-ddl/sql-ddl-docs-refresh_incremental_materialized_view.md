# REFRESH INCREMENTAL MATERIALIZED VIEW

## 功能描述

REFRESH INCREMENTAL MATERIALIZED VIEW会以增量刷新的方式对物化视图进行刷新。

## 注意事项

- 增量刷新仅支持增量物化视图。
- 刷新物化视图需要当前用户拥有基表的SELECT权限。

## 语法格式

```
REFRESH INCREMENTAL MATERIALIZED VIEW mv_name;
```

## 参数说明

- **mv\_name**

要刷新的物化视图的名称。

## 示例

```
--创建一个普通表
openGauss=# CREATE TABLE my_table (c1 int, c2 int);
--创建增量物化视图
openGauss=# CREATE INCREMENTAL MATERIALIZED VIEW my_imv AS SELECT * FROM my_table;
--基表写入数据
openGauss=# INSERT INTO my_table VALUES(1,1),(2,2);
--对增量物化视图my_imv进行增量刷新
openGauss=# REFRESH INCREMENTAL MATERIALIZED VIEW my_imv;
```

## 相关链接

[ALTER MATERIALIZED VIEW](alter_materialized_view.md)，[CREATE INCREMENTAL MATERIALIZED VIEW](create_incremental_materialized_view.md)，[CREATE MATERIALIZED VIEW](create_materialized_view.md)，[CREATE TABLE](create_table.md)，  [DROP MATERIALIZED VIEW](drop_materialized_view.md)，[REFRESH MATERIALIZED VIEW](refresh_materialized_view.md)
