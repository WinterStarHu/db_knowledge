# PG\_OBJECT

PG\_OBJECT系统表存储限定类型对象（普通表、索引、序列、视图、存储过程和函数）的创建用户、创建时间和最后修改时间。

**表 1**  PG\_OBJECT字段

object_oid oid 对象标识符。
object_type "char" 对象类型： r 表示普通表。i 表示索引。s 表示序列。l 表示Large序列。v 表示视图。p 表示存储过程和函数。S 表示package的specification。B 表示package的body。m 表示物化视图。
creator oid 创建用户的标识符。
ctime timestamp with time zone 对象的创建时间。
mtime timestamp with time zone 对象的最后修改时间，修改行为包括ALTER操作和GRANT、REVOKE操作。
createcsn int8 对象创建时的CSN。
changecsn int8 对表或索引执行DDL操作时的CSN。
valid bool 表示当前对象是否有效，引起对象失效的原因可能有存储过程、兼容Oracle风格的函数、包或视图依赖的引用对象被修改或删除。
object_options int4 存储与对象类型相关的选项和参数。

>[!TIP]须知
>
>- 无法记录初始化数据库（initdb）过程中所创建或修改的对象，即PG\_OBJECT无法查询到该对象记录。
>- 对于升级前创建的对象，再次修改时会记录其修改时间（mtime），对表或索引执行DDL操作时会记录其所属事务的事务提交序列号（changecsn）。由于无法得知该对象创建时间，因此ctime和createcsn为空。
>- ctime和mtime所记录的时间为用户当次操作所属事务的起始时间。
>- 由扩容引起的对象修改时间也会被记录。
>- createcsn和changecsn记录的是用户当次操作所属事务的事务提交序列号。
>- enable_gtt_concurrent_truncate开启时，truncate全局临时表不会刷新mtime字段。
