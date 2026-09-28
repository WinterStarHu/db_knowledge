# 查看数据库连接数

## 背景信息

当用户连接数达到上限后，无法建立新的连接。因此，当数据库管理员发现某用户无法连接到数据库时，需要查看是否连接数达到了上限。控制数据库连接的主要以下几种选项。

- 全局的最大连接数：由运行参数max\_connections指定。
- 某用户的连接数：在创建用户时由CREATE ROLE命令的CONNECTION LIMIT connlimit子句直接设定，也可以在设定以后用ALTER ROLE的CONNECTION LIMIT connlimit子句修改。
- 某数据库的连接数：在创建数据库时，由CREATE DATABASE的CONNECTION LIMIT connlimit参数指定。

## 操作步骤

1.以操作系统用户omm登录数据库主节点。

2.使用如下命令连接数据库。

```
gsql -d postgres -p 8000
```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

```
gsql ((openGauss 1.0 build 290d125f) compiled at 2020-05-08 02:59:43 commit 2143 last mr 131）
Non-SSL connection (SSL connection is recommended when requiring high-security)
Type "help" for help.
openGauss=#
```

3.查看全局会话连接数限制。

```
openGauss=# SHOW max_connections;
    max_connections
-----------------
    800
(1 row)
```

其中800是最大会话连接数。

4.查看已使用的会话连接数。
具体命令请参见[表1](#zh-cn_topic_0237121094_zh-cn_topic_0059779140_t608a1965463e41f1b6eacd02f97a65ba)。

>[!TIP]须知
>除了创建的时候用双引号引起的数据库和用户名称外，以下命令中用到的数据库名称和用户名称，其中包含的英文字母必须使用小写。

**表 1**  查看会话连接数

查看指定用户的会话连接数上限。
执行如下命令查看连接到指定用户omm的会话连接数上限。其中-1表示没有对用户omm设置连接数的限制。
openGauss=# SELECT ROLNAME,ROLCONNLIMIT FROM PG_ROLES WHERE ROLNAME='omm';
rolname  | rolconnlimit
----------+--------------
omm |           -1 (1 row) 查看指定用户已使用的会话连接数。
执行如下命令查看指定用户omm已使用的会话连接数。其中，1表示omm已使用的会话连接数。
openGauss=# CREATE OR REPLACE VIEW DV_SESSIONS AS SELECT sa.sessionid AS SID, 0::integer AS SERIAL#, sa.usesysid AS USER#, ad.rolname AS USERNAME FROM pg_stat_get_activity(NULL) AS sa LEFT JOIN pg_authid ad ON(sa.usesysid = ad.oid) WHERE sa.application_name &lt;&gt; 'JobScheduler';
openGauss=# SELECT COUNT(*) FROM DV_SESSIONS WHERE USERNAME='omm';
count \--------------------- 1 (1 row) 查看指定数据库的会话连接数上限。
执行如下命令查看连接到指定数据库postgres的会话连接数上限。其中-1表示没有对数据库postgres设置连接数的限制。
openGauss=# SELECT DATNAME,DATCONNLIMIT FROM PG_DATABASE WHERE DATNAME='postgres';
datname  | datconnlimit
----------+--------------
postgres |           -1 (1 row) 查看指定数据库已使用的会话连接数。
执行如下命令查看指定数据库postgres上已使用的会话连接数。其中，1表示数据库postgres上已使用的会话连接数。
openGauss=# SELECT COUNT(*) FROM PG_STAT_ACTIVITY WHERE DATNAME='postgres';
count \--------------------- 1 (1 row) 查看所有用户已使用会话连接数。
执行如下命令查看所有用户已使用的会话连接数。
openGauss=# CREATE OR REPLACE VIEW DV_SESSIONS AS SELECT sa.sessionid AS SID, 0::integer AS SERIAL#, sa.usesysid AS USER#, ad.rolname AS USERNAME FROM pg_stat_get_activity(NULL) AS sa LEFT JOIN pg_authid ad ON(sa.usesysid = ad.oid) WHERE sa.application_name &lt;&gt; 'JobScheduler';
openGauss=# SELECT COUNT(*) FROM DV_SESSIONS;
count \--------------------- 10 (1 row)

​ ​ ​
