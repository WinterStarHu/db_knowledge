# DROP ROW LEVEL SECURITY POLICY

## 功能描述

删除表上某个行访问控制策略。

## 注意事项

仅表的所有者或者管理员用户才能删除表的行访问控制策略。

## 语法格式

```
DROP [ ROW LEVEL SECURITY ] POLICY [ IF EXISTS ] policy_name ON table_name [ CASCADE | RESTRICT ]
```

## 参数说明

- **IF EXISTS**

如果指定的行访问控制策略不存在，发出一个notice而不是抛出一个错误。

- **policy\_name**

要删除的行访问控制策略的名称。

  - table\_name

行访问控制策略所在的数据表名。

  - CASCADE/RESTRICT

仅适配此语法，无对象依赖于该行访问控制策略，CASCADE和RESTRICT效果相同。

## 示例

```
--创建数据表all_data
openGauss=# CREATE TABLE all_data(id int, role varchar(100), data varchar(100));

--创建行访问控制策略
openGauss=# CREATE ROW LEVEL SECURITY POLICY all_data_rls ON all_data USING(role = CURRENT_USER);

--删除行访问控制策略
openGauss=# DROP ROW LEVEL SECURITY POLICY all_data_rls ON all_data;
```

## 相关链接

[ALTER ROW LEVEL SECURITY POLICY](alter_row_level_security_policy.md)，[CREATE ROW LEVEL SECURITY POLICY](create_row_level_security_policy.md)
