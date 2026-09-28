# PG\_SHDEPEND

PG\_SHDEPEND系统表记录数据库对象和共享对象（比如角色）之间的依赖性关系。这些信息允许openGauss保证在企图删除这些对象之前，这些对象是没有被引用的。

[PG\_DEPEND](pg_depend.md)的作用类似，只是它是用于在一个数据库内部的对象的依赖性关系的。

和其它大多数系统表不同，PG\_SHDEPEND是在openGauss里面所有的数据库之间共享的：每个openGauss只有一个PG\_SHDEPEND，而不是每个数据库一个。

**表 1**  PG\_SHDEPEND字段

dbid oid PG_DATABASE.oid 依赖对象所在的数据库的OID，如果是共享对象，则为零。
classid oid PG_CLASS.oid 依赖对象所在的系统表的OID。
objid oid 任意OID属性 指定的依赖对象的OID。
objsubid integer 对于一个表字段，这是字段号（objid和classid参考表本身）。对于所有其他对象类型，这个字段为零。
refclassid oid PG_CLASS.oid 被引用对象所在的系统表的OID（必须是一个共享表）。
refobjid oid 任意OID属性 指定的被引用对象的OID。
deptype "char" 一段代码，定义了这个依赖性关系的特定语义；参阅下文。
objfile text 用户定义函数库文件路径。

在任何情况下，一条PG\_SHDEPEND记录就表明这个被引用的对象不能在未删除依赖对象的前提下删除。不过，deptype同时还标出了几种不同的子风格：

- SHARED\_DEPENDENCY\_OWNER \(o\)

被引用的对象（必须是一个角色）是依赖对象的所有者。

- SHARED\_DEPENDENCY\_ACL \(a\)

被引用的对象（必须是一个角色）在依赖对象的ACL（访问控制列表，也就是权限列表）里提到。SHARED\_DEPENDENCY\_ACL不会在对象的所有者头上添加的，因为所有者会有一个SHARED\_DEPENDENCY\_OWNER记录。

- SHARED\_DEPENDENCY\_PIN \(p\)

没有依赖对象；这类记录标识系统自身依赖于该被依赖对象，因此这样的对象绝对不能被删除。这种类型的记录只是由initdb创建。这样的依赖对象的字段都是零。

- SHARED\_DEPENDENCY\_ DBPRIV\(d\)

被引用的对象（必须是一个角色）具有依赖对象所对应的ANY权限（指定的依赖对象的OID对应的是系统表gs\_db\_privilege中一行）。
