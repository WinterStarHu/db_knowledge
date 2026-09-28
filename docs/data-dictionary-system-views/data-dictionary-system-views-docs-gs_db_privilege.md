# GS\_DB\_PRIVILEGE

GS\_DB\_PRIVILEGE系统表记录ANY权限的授予情况，每条记录对应一条授权信息。

**表 1**  GS\_DB\_PRIVILEGE字段

oid oid 行标识符（隐含字段，必须明确选择）。
roleid oid 用户标识。
privilege_type text 用户拥有的ANY权限，取值参考表1。
admin_option boolean 是否具有privilege_type列记录的ANY权限的再授权权限。
t：表示具有。f：表示不具有。
