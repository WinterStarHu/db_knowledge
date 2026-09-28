# 角色

角色是一组用户的集合。通过GRANT把角色授予用户后，用户即具有了角色的所有权限。推荐使用角色进行高效权限分配。例如，可以为设计、开发和维护人员创建不同的角色，将角色GRANT给用户后，再向每个角色中的用户授予其工作所需数据的差异权限。在角色级别授予或撤消权限时，这些更改将作用到角色下的所有成员。

openGauss提供了一个隐式定义的拥有所有角色的组PUBLIC，所有创建的用户和角色默认拥有PUBLIC所拥有的权限。关于PUBLIC默认拥有的权限请参考[GRANT](../sql_reference/grant.md)。要撤销或重新授予用户和角色对PUBLIC的权限，可通过在GRANT和REVOKE指定关键字PUBLIC实现。

要查看所有角色，请查询系统表PG\_ROLES：

```
SELECT * FROM PG_ROLES;
```

## 创建、修改和删除角色

非[三权分立](separation_of_duties.md)时，只有系统管理员和具有CREATEROLE属性的用户才能创建、修改或删除角色。三权分立下，只有初始用户和具有CREATEROLE属性的用户才能创建、修改或删除角色。

- 要创建角色，请使用[CREATE ROLE](../sql_reference/create_role.md)。
- 要在现有角色中添加或删除用户，请使用[ALTER ROLE](../sql_reference/alter_role.md)。
- 要删除角色，请使用[DROP ROLE](../sql_reference/drop_role.md)。DROP ROLE只会删除角色，并不会删除角色中的成员用户帐户。

## 内置角色

openGauss提供了一组默认角色，以gs\_role\_开头命名。它们提供对特定的、通常需要高权限的操作的访问，可以将这些角色GRANT给数据库内的其他用户或角色，让这些用户能够使用特定的功能。在授予这些角色时应当非常小心，以确保它们被用在需要的地方。[表1](#table2118117460)描述了内置角色允许的权限范围：

**表 1**  内置角色权限描述

权限描述 gs_role_copy_files 具有执行copy … to/from filename的权限，但需要先打开GUC参数enable_copy_server_files。
gs_role_signal_backend 具有调用函数pg_cancel_backend、pg_terminate_backend和pg_terminate_session来取消或终止其他会话的权限，但不能操作属于初始用户和PERSISTENCE用户的会话。
gs_role_tablespace 具有创建表空间（tablespace）的权限。
gs_role_replication 具有调用逻辑复制相关函数的权限，例如kill_snapshot、pg_create_logical_replication_slot、pg_create_physical_replication_slot、pg_drop_replication_slot、pg_replication_slot_advance、pg_create_physical_replication_slot_extern、pg_logical_slot_get_changes、pg_logical_slot_peek_changes、pg_logical_slot_get_binary_changes、pg_logical_slot_peek_binary_changes。
gs_role_account_lock 具有加解锁用户的权限，但不能加解锁初始用户和PERSISTENCE用户。
gs_role_pldebugger 具有执行dbe_pldebugger下调试函数的权限。
gs_role_directory_create 具有执行创建directory对象的权限，但需要先打开GUC参数enable_access_server_directory。
gs_role_directory_drop 具有执行删除directory对象的权限，但需要先打开GUC参数enable_access_server_directory。

关于内置角色的管理有如下约束：

- 以gs\_role\_开头的角色名作为数据库的内置角色保留名，禁止新建以“gs\_role\_”开头的用户/角色，也禁止将已有的用户/角色重命名为以“gs\_role\_”开头；
- 禁止对内置角色的ALTER和DROP操作；
- 内置角色默认没有LOGIN权限，不设预置密码；
- gsql元命令\\du和\\dg不显示内置角色的相关信息，但若显示指定了pattern为特定内置角色则会显示；
- 三权分立关闭时，初始用户、具有SYSADMIN权限的用户和具有内置角色ADMIN OPTION权限的用户有权对内置角色执行GRANT/REVOKE管理。三权分立打开时，初始用户和具有内置角色ADMIN OPTION权限的用户有权对内置角色执行GRANT/REVOKE管理。例如：

    ```
    GRANT gs_role_signal_backend TO user1;
    REVOKE gs_role_signal_backend FROM user1;
    ```
