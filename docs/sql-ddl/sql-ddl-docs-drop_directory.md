# DROP DIRECTORY

## 功能描述

删除指定的directory对象。

## 注意事项

当enable_access_server_directory=off时，只允许初始用户删除directory对象；当enable_access_server_directory=on时，具有SYSADMIN权限的用户、directory对象的属主、被授予了该directory的DROP权限的用户或者继承了内置角色gs_rloe_directory_drop权限的用户可以删除directory。

##

## 语法格式

```
DROP DIRECTORY [ IF EXISTS ] directory_name;
```

## 参数说明

- **directory\_name**

目录名称。

取值范围：已经存在的目录名。

## 示例

```
--创建目录。
openGauss=# CREATE OR REPLACE DIRECTORY  dir  as '/tmp/';

--删除目录。
openGauss=# DROP DIRECTORY dir;
```

## 相关链接

[CREATE DIRECTORY](create_directory.md)，[ALTER DIRECTORY](alter_directory.md)
