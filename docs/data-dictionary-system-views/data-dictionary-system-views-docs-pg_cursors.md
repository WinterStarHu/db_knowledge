# PG\_CURSORS

PG\_CURSORS视图列出了当前可用的游标。

**表 1**  PG\_CURSORS字段

name text 游标名。
statement text 声明该游标时的查询语句。
is_holdable boolean 如果该游标是持久的（就是在声明该游标的事务结束后仍然可以访问该游标）则为TRUE，否则为FALSE。
is_binary boolean 如果该游标被声明为BINARY则为TRUE，否则为FALSE。
is_scrollable boolean 如果该游标可以滚动（就是允许以不连续的方式检索）则为TRUE，否则为FALSE。
creation_time timestamp with time zone 声明该游标的时间戳。
