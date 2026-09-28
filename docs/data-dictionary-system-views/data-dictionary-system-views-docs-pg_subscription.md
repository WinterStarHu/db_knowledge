# PG\_SUBSCRIPTION

系统表PG\_SUBSCRIPTION包含所有现有的逻辑复制订阅。需要有系统管理员权限才可以访问此系统表。

和大部分系统表不同，pg\_subscription在数据库实例的所有数据库之间共享，即在每个节点上有只有一份pg\_replication\_origin，而不是每个数据库一份。

**表 1**  PG\_SUBSCRIPTION字段

oid oid 行标识符（隐含属性，必须明确选择）。
subdbid oid 订阅所在的数据库的OID。
subname text 订阅的名称。
subowner oid 订阅的拥有者。
subenabled bool 如果为真，订阅被启用并且应该被复制。
subconninfo text 到发布端数据库的连接信息。
subslotname text 发布端数据库中复制槽的名称。空表示为NONE。
subsynccommit text 订阅worker的synchronous_commit设置的值。
subpublications text[] 被订阅的publication名称的数组。这些引用的是发布者服务器上的publication。
subbinary bool 如果为真，发布端和订阅端之间传输数据是以二进制的格式进行传输。
subskiplsn text commit_lsn为该lsn的事务会被跳过，不被应用。
submatchddlowner boolean 当订阅时指定选项matchddlowner为false时，该值为false，默认为true。该选项指示订阅端在应用DDL操作时，是否切换到DDL日志信息中指定owner用户。
