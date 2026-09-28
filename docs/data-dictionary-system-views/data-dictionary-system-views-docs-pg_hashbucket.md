# PG\_HASHBUCKET

PG\_HASHBUCKET系统表存储hash bucket信息。

**表 1**  PG\_HASHBUCKET字段

oid oid 行标识符（隐含字段，必须明确选择）。
bucketid oid 对bucketvector计算的hash值，通过hash值可以加速对bucketvector的查找。
bucketcnt integer 包含分片的个数。
bucketmapsize integer 所有DN上包含的分片总数。
bucketref integer 预留字段，默认值为1。
bucketvector oidvector_extend 记录此行bucket信息包含的所有bucket的id，在此列上建立唯一索引，具有相同bucketid信息的表共享同一行pg_hashbucket数据。
