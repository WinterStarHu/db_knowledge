# DROP MATERIALIZED VIEW

## 功能描述

强制删除数据库中已有的物化视图。

## 注意事项

物化视图的所有者、物化视图所在模式的所有者、被授予了物化视图DROP权限的用户或拥有DROP ANY TABLE权限的用户才有权限执行DROP MATERIALIZED VIEW命令，系统管理员默认拥有此权限。

## 语法格式

```
DROP MATERIALIZED VIEW [ IF EXISTS ] mv_name [, ...] [ CASCADE | RESTRICT ];
```

## 参数说明

- **IF EXISTS**

如果指定的物化视图不存在，则发出一个notice而不是抛出一个错误。

- **mv\_name**

要删除的物化视图名称。

- **CASCADE | RESTRICT**
  - CASCADE：级联删除依赖此物化视图的对象。
  - RESTRICT：如果有依赖对象存在，则拒绝删除此物化视图。此选项为缺省值。

## 示例

```
--删除名为my_mv的物化视图。
openGauss=# DROP MATERIALIZED VIEW my_mv;
```

## 相关链接

[ALTER MATERIALIZED VIEW](alter_materialized_view.md)，[CREATE INCREMENTAL MATERIALIZED VIEW](create_incremental_materialized_view.md)，  [CREATE MATERIALIZED VIEW](create_materialized_view.md)，[CREATE TABLE](create_table.md)，[REFRESH INCREMENTAL MATERIALIZED VIEW](refresh_incremental_materialized_view.md)，[REFRESH MATERIALIZED VIEW](refresh_materialized_view.md)
