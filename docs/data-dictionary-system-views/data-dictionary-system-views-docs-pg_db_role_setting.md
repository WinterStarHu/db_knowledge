# PG\_DB\_ROLE\_SETTING

PG\_DB\_ROLE\_SETTING系统表存储数据库运行时每个角色与数据绑定的配置项的默认值。

**表 1**  PG\_DB\_ROLE\_SETTING字段

setdatabase oid 配置项所对应的数据库，如果未指定数据库，则为0。
setrole oid 配置项所对应的角色，如果未指定角色，则为0。
setconfig text[] 运行时配置项的默认值，配置方法参考表2。
