# DCL语法一览表

DCL（Data Control Language数据控制语言），是用来创建用户角色、设置或更改数据库用户或角色权限的语句。

## 定义角色

角色是用来管理权限的，从数据库安全的角度考虑，可以把所有的管理和操作权限划分到不同的角色上。所涉及的SQL语句，请参考[表1](#zh-cn_topic_0283136632_zh-cn_topic_0237122051_zh-cn_topic_0059777960_tf1770f1724d84240998305bfca259f11)。

**表 1**  角色定义相关SQL

相关SQL 创建角色 CREATE ROLE 修改角色属性 ALTER ROLE 删除角色 DROP ROLE

## 定义用户

用户是用来登录数据库的，通过对用户赋予不同的权限，可以方便地管理用户对数据库的访问及操作。所涉及的SQL语句，请参考[表2](#zh-cn_topic_0283136632_zh-cn_topic_0237122051_zh-cn_topic_0059777960_t52a128d57b274569b95a3b35f6871348)。

**表 2**  用户定义相关SQL

相关SQL 创建用户 CREATE USER 修改用户属性 ALTER USER 删除用户 DROP USER

## 授权

openGauss提供了针对数据对象和角色授权的语句，请参考[GRANT](grant.md)。

## 收回权限

openGauss提供了收回权限的语句，请参考[REVOKE](revoke.md)。

## 设置默认权限

openGauss允许设置应用于将来创建的对象的权限，请参考[ALTER DEFAULT PRIVILEGES](alter_default_privileges.md)。

## 关闭当前节点

openGauss支持使用shutdown命令关闭当前数据库节点，请参考[SHUTDOWN](shutdown.md)。
