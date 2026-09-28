# ALTER MATERIALIZED VIEW

## 功能描述

更改一个现有物化视图的多个辅助属性。

可用于ALTER MATERIALIZED VIEW的语句形式和动作是ALTER TABLE的一个子集，并且在用于物化视图时具有相同的含义。详见[ALTER TABLE](alter_table.md)。

## 注意事项

- 只有物化视图的所有者有权限执行ALTER TMATERIALIZED VIEW命令，系统管理员默认拥有此权限。
- 不支持更改物化视图结构。

## 语法格式

- 修改物化视图的所属用户。

    ```
    ALTER MATERIALIZED VIEW [ IF EXISTS ] mv_name
        OWNER TO new_owner;
    ```

- 修改物化视图的列。

    ```
    ALTER MATERIALIZED VIEW [ IF EXISTS ] mv_name
        RENAME [ COLUMN ] column_name TO new_column_name;
    ```

- 重命名物化视图。

    ```
    ALTER MATERIALIZED VIEW [ IF EXISTS ] mv_name

        RENAME TO new_name;
    ```

## 参数说明

- **mv\_name**

一个现有物化视图的名称，可以用模式修饰。

取值范围：字符串，符合标识符命名规范。

- **column\_name**

一个新的或者现有的列的名称。

取值范围：字符串，符合标识符命名规范。

- **new\_column\_name**

一个现有列的新名称。

- **new\_owner**

该物化视图的新拥有者的用户名。

- **new\_name**

该物化视图的新名称。

## 示例

```
--把物化视图foo重命名为bar。
openGauss=# ALTER MATERIALIZED VIEW foo RENAME TO bar;
```

## 相关链接

[CREATE MATERIALIZED VIEW](create_materialized_view.md)，[CREATE INCREMENTAL MATERIALIZED VIEW](create_incremental_materialized_view.md)，[DROP MATERIALIZED VIEW](drop_materialized_view.md)，[REFRESH INCREMENTAL MATERIALIZED VIEW](refresh_incremental_materialized_view.md)  ，[REFRESH MATERIALIZED VIEW](refresh_materialized_view.md)
