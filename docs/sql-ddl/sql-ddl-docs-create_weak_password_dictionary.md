# CREATE WEAK PASSWORD DICTIONARY

## 功能描述

向gs\_global\_config表中插入一个或者多个弱口令。

## 注意事项

- 只有初始用户、系统管理员和安全管理员拥有权限执行本语法。
- 弱口令字典中的口令存放在gs\_global\_config系统表中。
- 弱口令字典默认为空，用户通过本语法可以新增一条或多条弱口令。
- 当用户尝试通过本语法插入gs\_global\_config表中已存在的弱口令时，会只在表中保留一条该弱口令。

## 语法格式

```
CREATE WEAK PASSWORD DICTIONARY
       [WITH VALUES] ( {'weak_password'} [, ...] );
```

## 参数说明

weak\_password

弱口令。

范围：字符串。

## 示例

```
--向gs_global_config系统表中插入单个弱口令。
openGauss=# CREATE WEAK PASSWORD DICTIONARY WITH VALUES ('password1');

--向gs_global_config系统表中插入多个弱口令。
openGauss=# CREATE WEAK PASSWORD DICTIONARY WITH VALUES ('password2'),('password3');

--清空gs_global_config系统表中所有弱口令。
openGauss=# DROP WEAK PASSWORD DICTIONARY;

--查看现有弱口令。
openGauss=# SELECT * FROM gs_global_config WHERE NAME LIKE 'weak_password';
```

## 相关链接

[DROP WEAK PASSWORD DICTIONARY](drop_weak_password_dictionary.md)
