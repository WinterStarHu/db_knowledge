# DROP PROCEDURE

## 功能描述

删除已存在的存储过程。

## 注意事项

通过[DROP FUNCTION](drop_function.md)也能删除存储过程。

## 语法格式

```
DROP PROCEDURE [ IF EXISTS ] procedure_name
[ ( [ {[ argname ] [ argmode ] argtype} [, ...] ] ) [ CASCADE | RESTRICT ] ];
```

## 参数说明

- **IF EXISTS**

如果指定的存储过程不存在，发出一个notice而不是抛出一个错误。

- **procedure\_name**

要删除的存储过程名称。

取值范围：已存在的存储过程名。

## 相关链接

[CREATE PROCEDURE](create_procedure.md)
