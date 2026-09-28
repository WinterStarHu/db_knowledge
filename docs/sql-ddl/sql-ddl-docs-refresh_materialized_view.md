# REFRESH MATERIALIZED VIEW

## 功能描述

REFRESH MATERIALIZED VIEW会以全量刷新的方式对物化视图进行刷新。

## 注意事项

- 全量刷新既可以对全量物化视图执行，也可以对增量物化视图执行。
- 刷新物化视图需要当前用户拥有基表的SELECT权限。

## 语法格式

```
REFRESH MATERIALIZED VIEW mv_name;
```

## 参数说明

- **mv\_name**

要刷新的物化视图的名称。

## 示例

```
--创建一个普通表
openGauss=# CREATE TABLE my_table (c1 int, c2 int);
--创建全量物化视图
openGauss=# CREATE MATERIALIZED VIEW my_mv AS SELECT * FROM my_table;
--创建增量物化视图
openGauss=# CREATE INCREMENTAL MATERIALIZED VIEW my_imv AS SELECT * FROM my_table;
--基表写入数据
openGauss=# INSERT INTO my_table VALUES(1,1),(2,2);
--对全量物化视图my_mv进行全量刷新
openGauss=# REFRESH MATERIALIZED VIEW my_mv;
--对增量物化视图my_imv进行全量刷新
openGauss=# REFRESH MATERIALIZED VIEW my_imv;
```

## 相关链接

[ALTER MATERIALIZED VIEW](alter_materialized_view.md)，[CREATE INCREMENTAL MATERIALIZED VIEW](create_incremental_materialized_view.md)，  [CREATE MATERIALIZED VIEW](create_materialized_view.md)，[CREATE TABLE](create_table.md)，  [DROP MATERIALIZED VIEW](drop_materialized_view.md)，[REFRESH INCREMENTAL MATERIALIZED VIEW](refresh_incremental_materialized_view.md)
