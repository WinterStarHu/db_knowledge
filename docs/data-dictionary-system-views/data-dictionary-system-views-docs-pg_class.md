# PG\_CLASS

PG\_CLASS系统表存储数据库对象信息及其之间的关系。

**表 1**  PG\_CLASS字段

oid oid 行标识符（隐含属性，必须明确选择）。
relname name 表、索引、视图等对象的名称。
relnamespace oid 包含这个关系的名称空间的OID。
reltype oid 对应这个表的行类型的数据类型（索引为零，因为索引没有pg_type记录）。
reloftype oid 复合类型的OID，0表示其他类型。
relowner oid 关系所有者。
relam oid 如果行是索引，则就是所用的访问模式（B-tree、hash等）。
relfilenode oid 这个关系在磁盘上的文件的名称，如果没有则为0。
reltablespace oid 这个关系存储所在的表空间。如果为零，则意味着使用该数据库的缺省表空间。如果关系在磁盘上没有文件，则这个字段没有什么意义。
relpages double precision 以页（大小为BLCKSZ）为单位的此表在磁盘上的大小，它只是优化器用的一个近似值。
reltuples double precision 表中行的数目，只是优化器使用的一个估计值。
relallvisible integer 被标识为全可见的表中的页的数量。此字段是优化器用来做SQL执行优化使用的。VACUUM、ANALYZE和一些DDL语句（例如，CREATE INDEX）会引起此字段更新。
reltoastrelid oid 与此表关联的TOAST表的OID，如果没有则为0。
TOAST表在一个从属表里“离线”存储大字段。
reltoastidxid oid 对于TOAST表是它的索引的OID，如果不是TOAST表则为0。
reldeltarelid oid Delta表的OID。
Delta表附属于列存表。用于存储数据导入过程中的甩尾数据。
reldeltaidx oid Delta表的索引表OID。
relcudescrelid oid CU描述表的OID。
CU描述表（Desc表）附属于列存表。用于控制表目录中存储数据的可见性。
relcudescidx oid CU描述表的索引表OID。
relhasindex boolean 如果它是一个表而且至少有（或者最近有过）一个索引，则为真。
它是由CREATE INDEX设置的，但DROP INDEX不会立即将它清除。如果VACUUM进程检测一个表没有索引，将会把它将清理relhasindex字段，将值设置为假。
relisshared boolean 如果该表在openGauss中由所有数据库共享则为真。只有某些系统表（比如pg_database）是共享的。
relpersistence "char" p：表示永久表。u：表示非日志表。t：表示临时表。g：表示全局临时表。
relkind "char" r：表示普通表。i：表示索引。I：表示分区表GLOBAL索引。S：表示序列。L：表示Large序列。v：表示视图。c：表示复合类型。t：表示TOAST表。f：表示外表。m：表示物化视图。z：表示全局缓存类型的序列。Z：表示全局缓存类型的Large序列。
relnatts smallint 关系中用户字段数目（除了系统字段以外）。在pg_attribute里肯定有相同数目对应行。
relchecks smallint 表里的检查约束的数目；参阅pg_constraint表。
relhasoids boolean 如果为关系中每行都生成一个OID则为真。
relhaspkey boolean 如果这个表有一个（或者曾经有一个）主键，则为真。
relhasrules boolean 如表有规则就为真。是否有规则可参考系统表PG_REWRITE。
relhastriggers boolean True表示表中有触发器，或者曾经有过触发器。系统表pg_trigger中记录了表和视图的触发器。
relhassubclass boolean 如果有（或者曾经有）任何继承的子表，为真。
relcmprs tinyint relhasclusterkey boolean 是否有局部聚簇存储。
relrowmovement boolean parttype "char" relfrozenxid xid32 该表中所有在这个之前的事务ID已经被一个固定的（“frozen”）事务ID替换。该字段用于跟踪此表是否需要为了防止事务ID重叠（或者允许收缩pg_clog）而进行清理。如果该关系不是表则为零（InvalidTransactionId）。
为保持前向兼容，保留此字段，新增relfrozenxid64用于记录此信息。
relacl aclitem[] 访问权限。
查询的回显结果为以下形式： rolename=xxxx/yyyy  --赋予一个角色的权限 =xxxx/yyyy  --赋予public的权限 xxxx表示赋予的权限，yyyy表示授予这个权限的角色。权限的参数说明请参见表2。
reloptions text[] 表或索引的访问方法，使用"keyword=value"格式的字符串。
relreplident "char" relfrozenxid64 xid 该表中所有在这个之前的事务ID已经被一个固定的（"frozen"）事务ID替换。该字段用于跟踪此表是否需要为了防止事务ID重叠（或者允许收缩pg_clog）而进行清理。如果该关系不是表则为零（InvalidTransactionId）。
relbucket oid pg_hashbucket中的桶信息。
relbucketkey int2vector 哈希分区列号。
relminmxid xid 该表中所有在这个之前的多事务ID已经被一个事务ID替换。这用于跟踪该表是否需要为了防止多事务ID重叠或者允许收缩pg_clog而进行清理。如果该关系不是表则为零(InvalidTransactionId)。

**表 2**  权限的参数说明

参数说明 SELECT（读） UPDATE（写） INSERT（插入） DELETE TRUNCATE REFERENCES TRIGGER EXECUTE USAGE CREATE CONNECT TEMPORARY ALTER DROP COMMENT INDEX VACUUM 给前面权限的授权选项
