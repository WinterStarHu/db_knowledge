# PG\_PUBLICATION

系统表pg\_publication包含当前数据库中创建的所有publication。

**表 1**  PG\_PUBLICATION字段

pubname text publication的名称。
pubowner oid publication的拥有者。
puballtables boolean 如果为真，这个publication自动包括数据库中的所有表，包括未来将会创建的任何表。
pubinsert boolean 如果为真，为publication中的表复制INSERT操作。
pubupdate boolean 如果为真，为publication中的表复制UPDATE操作。
pubdelete boolean 如果为真，为publication中的表复制DELETE操作。
pubddl bigint 发布时没有指定ddl，其值为0。
指定ddl='table'时，其值为1。
指定ddl='all'时，其值为-1。
