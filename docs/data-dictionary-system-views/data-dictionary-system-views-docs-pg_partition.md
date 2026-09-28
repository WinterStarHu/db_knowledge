# PG\_PARTITION

PG\_PARTITION系统表存储数据库内所有分区表（partitioned table）、分区（table partition）、分区上toast表和分区索引（index partition）四类对象的信息。分区表索引（partitioned index）的信息不在PG\_PARTITION系统表中保存。

**表 1**  PG\_PARTITION字段

oid oid 行标识符（隐含属性，必须明确选择）。
relname name 分区表、分区、分区上toast表和分区索引的名称。
parttype "char" parentid oid 当对象为分区表或分区时，此字段表示分区表在PG_CLASS中的OID。
当对象为index partition时，此字段表示所属分区表索引（partitioned index）的OID。
rangenum integer 保留字段。
intervalnum integer 保留字段。
partstrategy "char" relfilenode oid table partition、index partition、分区上toast表的物理存储位置。
reltablespace oid table partition、index partition、分区上toast表所属表空间的OID。
relpages double precision 统计信息：table partition、index partition的数据页数量。
reltuples double precision 统计信息：table partition、index partition的元组数。
relallvisible integer 统计信息：table partition、index partition的可见数据页数。
reltoastrelid oid table partition所对应toast表的OID。
reltoastidxid oid table partition所对应toast表的索引的OID。
indextblid oid index partition对应table partition的OID。
indisusable boolean 分区索引是否可用。
reldeltarelid oid Delta表的OID。
reldeltaidx oid Delta表的索引表的OID。
relcudescrelid oid CU描述表的OID。
relcudescidx oid CU描述表的索引表的OID。
relfrozenxid xid32 冻结事务ID号。
为保持前向兼容，保留此字段，新增relfrozenxid64用于记录此信息。
intspnum integer 间隔分区所属表空间的个数。
partkey int2vector 分区键的列号。
intervaltablespace oidvector 间隔分区所属的表空间，间隔分区以round-robin方式落在这些表空间内。
interval text[] 间隔分区的间隔值。
boundaries text[] 范围分区和间隔分区的上边界。
transit text[] 间隔分区的跳转点。
reloptions text[] 设置partition的存储属性，与pg_class.reloptions的形态一样，用“keyword=value”格式的字符串来表示，目前用于在线扩容的信息搜集。
relfrozenxid64 xid 冻结事务ID号。
relminmxid xid 冻结多事务ID号。
partitionno integer partitionno是一个永久自增列，可以通过语法ALTER TABLE t_name RESET PARTITION或者VACUUM FULL命令重置/回收。
subpartitionno integer subpartitionno是一个永久自增列，可以通过语法ALTER TABLE t_name RESET PARTITION或者VACUUM FULL命令重置/回收。
partkeyexpr text 用于存储分区表表达式分区键的解析内容，如果分区键是单独的列则该属性为空
