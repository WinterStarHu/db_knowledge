# PG\_PREPARED\_XACTS

PG\_PREPARED\_XACTS视图显示当前准备好进行两阶段提交的事务的信息。

**表 1**  PG\_PREPARED\_XACTS字段

transaction xid 预备事务的数字事务标识。
gid text 赋予该事务的全局事务标识。
prepared timestamp with time zone 事务准备好提交的时间。
owner name PG_AUTHID.rolname 执行该事务的用户的名称。
database name PG_DATABASE.datname 执行该事务所在的数据库名。
