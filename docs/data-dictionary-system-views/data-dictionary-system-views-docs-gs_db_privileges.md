# GS\_DB\_PRIVILEGES

GS\_DB\_PRIVILEGES系统视图记录ANY权限的授予情况，每条记录对应一条授权信息。

**表 1**  GS\_DB\_PRIVILEGES字段

rolename name 用户名。
privilege_type text 用户拥有的ANY权限，取值参考表1。
admin_option boolean 是否具有privilege_type列记录的ANY权限的再授权权限。
yes：表示具有。no：表示不具有。
