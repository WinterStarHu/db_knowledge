# DROP PACKAGE

## 功能描述

删除已存在的PACKAGE或者PACKAGE BODY。

## 注意事项

删除PACKAGE BODY后，PACKAGE内的存储过程及函数会同时失效。

## 语法格式

```
DROP PACKAGE [ IF EXISTS ] package_name;
DROP PACKAGE BODY [ IF EXISTS ] package_name;
```

## 相关链接

[CREATE PACKAGE](create_package.md)，[ALTER PACKAGE](alter_package.md)
