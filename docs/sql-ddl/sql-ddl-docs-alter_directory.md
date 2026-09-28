# ALTER DIRECTORY

## 功能描述

对directory属性进行修改。

## 注意事项

- 目前只支持修改directory属主。
- 当enable_access_server_directory=off时，只允许初始用户修改directory属主；当enable_access_server_directory=on时，具有SYSADMIN权限的用户和directory对象的属主可以修改directory，且要求该用户是新属主的成员。
- 当修改directory属主时，若新属主与原属主相同，视为未修改属主。即使用户没有修改DIERECTORY的权限，也不会报错。

## 语法格式

```
ALTER DIRECTORY directory_name
    OWNER TO new_owner;
```

## 参数描述

**directory\_name**

需要修改的目录名称，范围为已经存在的目录名称。

## 示例

```
--创建目录。
openGauss=# CREATE OR REPLACE DIRECTORY  dir  as '/tmp/';

--修改目录的owner。
openGauss=# ALTER DIRECTORY dir OWNER TO system;

--删除目录。
openGauss=# DROP DIRECTORY dir;
```

## 相关链接

[CREATE DIRECTORY](create_directory.md)，[DROP DIRECTORY](drop_directory.md)
