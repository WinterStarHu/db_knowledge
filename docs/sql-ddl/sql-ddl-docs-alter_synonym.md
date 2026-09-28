# ALTER SYNONYM

## 功能描述

修改SYNONYM对象的属性。

## 注意事项

- 目前仅支持修改SYNONYM对象的属主。
- 只有系统管理员有权限修改SYNONYM对象的属主信息。
- 新属主必须具有SYNONYM对象所在模式的CREATE权限。

## 语法格式

```
ALTER SYNONYM synonym_name
    OWNER TO new_owner;
```

## 参数描述

- **synonym**

待修改的同义词名字，可以带模式名。

取值范围：字符串，需要符合标识符的命名规范。

- **new\_owner**

同义词对象的新所有者。

取值范围：字符串，有效的用户名。

## 示例

```
--创建系统管理员用户。
openGauss=# CREATE USER sysadmin WITH SYSADMIN PASSWORD 'XXXXXXXX';

--切换管理员用户。
openGauss=# \c - sysadmin

--创建同义词t1。
openGauss=# CREATE OR REPLACE SYNONYM t1 FOR ot.t1;

--创建新用户u1。
gaussdbopenGauss=# CREATE USER u1 PASSWORD 'XXXXXXXX';

--给新用户赋权限。
openGauss=# GRANT ALL ON SCHEMA sysadmin TO u1;

--修改同义词t1的owner为u1。
openGauss=# ALTER SYNONYM t1 OWNER TO u1;

--删除同义词t1。
openGauss=# DROP SYNONYM t1;

--收回用户u1权限。
openGauss=# REVOKE ALL ON SCHEMA sysadmin FROM u1;

--删除用户u1。
openGauss=# DROP USER u1;
```

## 相关链接

[CREATE SYNONYM](create_synonym.md)，[DROP SYNONYM](drop_synonym.md)
