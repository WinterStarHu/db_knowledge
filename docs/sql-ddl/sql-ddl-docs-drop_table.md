# DROP TABLE

## 功能描述

删除指定的表。

## 注意事项

- DROP TABLE会强制删除指定的表，删除表后，依赖该表的索引会被删除，而使用到该表的函数和存储过程将无法执行。删除分区表，会同时删除分区表中的所有分区。
- 表的所有者、被授予了表的DROP权限的用户或被授予DROP ANY TABLE权限的用户，有权删除指定表 ，系统管理员默认拥有该权限。

## 语法格式

```
DROP TABLE [ IF EXISTS ]
    { [schema.]table_name } [, ...] [ CASCADE | RESTRICT ] [ PURGE ];
```

## 参数说明

- **IF EXISTS**

如果指定的表不存在，则发出一个notice而不是抛出一个错误。

- **schema**

模式名称。

- **table\_name**

表名称。

- **CASCADE | RESTRICT**
  - CASCADE：级联删除依赖于表的对象（比如视图）。
  - RESTRICT（缺省项）：如果仅存在视图依赖对象，则允许删除该表，否则拒绝删除该表。查询视图时会提示相应依赖错误；新建表如果表名和列名与视图依赖相匹配，在查询视图时会重新建立与新表的依赖，恢复视图。

>[!TIP]须知
>
>- RESTRICT删除视图依赖表功能支持普通视图和物化视图，增量物化视图不支持。

- **PURGE**

该参数表示即使开启回收站功能，DROP表时，也会直接物理删除表，而不是将其放入回收站中。

## 示例

请参考CREATE TABLE的[示例](create_table.md#zh-cn_topic_0283137629_zh-cn_topic_0237122117_zh-cn_topic_0059778169_s86758dcf05d442d2a9ebd272e76ed1b8)。

## 相关链接

[ALTER TABLE](alter_table.md)，[CREATE TABLE](create_table.md)
