# USER\_LOGIN

USER\_LOGIN用来记录用户登录和退出次数的相关信息。

**表 1**  USER\_LOGIN字段

node_name text 数据库进程名称。
user_name text 用户名称。
user_id integer 用户oid（同pg_authid中的oid字段）。
login_counter bigint 登录次数。
logout_counter bigint 退出次数。
