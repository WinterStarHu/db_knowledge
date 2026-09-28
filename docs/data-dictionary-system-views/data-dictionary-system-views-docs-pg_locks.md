# PG\_LOCKS

PG\_LOCKS视图存储各打开事务所持有的锁信息。

**表 1**  PG\_LOCKS字段

locktype text 被锁定对象的类型：relation、extend、page、tuple、transactionid、virtualxid、object、userlock、advisory。
database oid PG_DATABASE.oid 被锁定对象所在数据库的OID。
如果被锁定的对象是共享对象，则OID为0。如果是一个事务ID，则为NULL。
relation oid PG_CLASS.oid 关系的OID，如果锁定的对象不是关系，也不是关系的一部分，则为NULL。
page integer 关系内部的页面编号，如果对象不是关系页或者不是行页，则为NULL。
tuple smallint 页面里边的行编号，如果对象不是行，则为NULL。
bucket integer 子表对应的bucket number。如果目标不是表的话，则为NULL。
virtualxid text 事务的虚拟ID，如果对象不是一个虚拟事务ID，则为NULL。
transactionid xid 事务的ID，如果对象不是一个事务ID，则为NULL。
classid oid PG_CLASS.oid 包含该对象的系统表的OID，如果对象不是普通的数据库对象，则为NULL。
objid oid 对象在其系统表内的OID，如果对象不是普通数据库对象，则为NULL。
objsubid smallint 对于表的一个字段，这是字段编号；对于其他对象类型，这个字段是0；如果这个对象不是普通数据库对象，则为NULL。
virtualtransaction text 持有此锁或者在等待此锁的事务的虚拟ID。
pid bigint 持有或者等待这个锁的服务器线程的逻辑ID。如果锁是被一个预备事务持有的，则为NULL。
sessionid bigint 持有或者等待这个锁的会话ID。
mode text 这个线程持有的或者是期望的锁模式。
granted boolean 如果锁是持有锁，则为TRUE。如果锁是等待锁，则为FALSE。
fastpath boolean 如果通过fast-path获得锁，则为TRUE；如果通过主要的锁表获得，则为FALSE。
locktag text 会话等待锁信息，可通过locktag_decode()函数解析。
global_sessionid text &nbsp;&nbsp;
全局会话ID。
waitstart TimestampTz 等锁起始记时，当获得锁后该值为NULL 注意: 该值有可能在短暂时段内被设置为NULL即使granted字段为 FALSE
