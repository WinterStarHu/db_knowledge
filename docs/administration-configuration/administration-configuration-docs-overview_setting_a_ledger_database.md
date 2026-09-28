# 账本数据库概述

## 背景信息

账本数据库融合了区块链思想，将用户操作记录至两种历史表中：用户历史表和全局区块表。当用户创建防篡改用户表时，系统将自动为该表添加一个hash列来保存每行数据的hash摘要信息，同时在blockchain模式下会创建一张用户历史表来记录对应用户表中每条数据的变更行为；而用户对防篡改用户表的一次修改行为将记录至全局区块表中。由于历史表具有只可追加不可修改的特点，因此历史表记录串联起来便形成了用户对防篡改用户表的修改历史。

用户历史表命名和结构如下：

**表 1**  用户历史表blockchain.\_\_hist所包含的字段

字段名 rec_num bigint 行级修改操作在历史表中的执行序号。
hash_ins hash16 INSERT或UPDATE操作插入的数据行的hash值。
hash_del hash16 DELETE或UPDATE操作删除的数据行的hash值。
pre_hash hash32 当前用户历史表的数据整体摘要。

**表 2**  hash\_ins与hash\_del场景对应关系

hash_ins hash_del INSERT (√)  插入行的hash值 DELETE (√)  删除行的hash值。
UPDATE (√)  新插入数据的hash值 (√)  删除前该行的hash值。

## 操作步骤

1.创建防篡改模式。

​ 例如，创建防篡改模式ledgernsp。

```
openGauss=# CREATE SCHEMA ledgernsp WITH BLOCKCHAIN;
```

2.在防篡改模式下创建防篡改用户表。

​ 例如，创建防篡改用户表ledgernsp.usertable。

```
openGauss=# CREATE TABLE ledgernsp.usertable(id int, name text);
```

​ 查看防篡改用户表结构及其对应的用户历史表结构。

```
openGauss=# \d+ ledgernsp.usertable;
openGauss=# \d+ blockchain.ledgernsp_usertable_hist;
```

​ 执行结果如下：

```
openGauss=# \d+ ledgernsp.usertable;
                     Table "ledgernsp.usertable"
 Column |  Type   | Modifiers | Storage  | Stats target | Description
--------+---------+-----------+----------+--------------+-------------
 id     | integer |           | plain    |              |
 name   | text    |           | extended |              |
 hash   | hash16  |           | plain    |              |
Has OIDs: no
Options: orientation=row, compression=no
History table name: ledgernsp_usertable_hist

openGauss=# \d+ blockchain.ledgernsp_usertable_hist;
             Table "blockchain.ledgernsp_usertable_hist"
  Column  |  Type  | Modifiers | Storage | Stats target | Description
----------+--------+-----------+---------+--------------+-------------
 rec_num  | bigint |           | plain   |              |
 hash_ins | hash16 |           | plain   |              |
 hash_del | hash16 |           | plain   |              |
 pre_hash | hash32 |           | plain   |              |
Indexes:
    "gs_hist_16388_index" PRIMARY KEY, btree (rec_num int4_ops) TABLESPACE pg_default
Has OIDs: no
Options: internal_mask=263
```

>[!NOTE]说明
>
>+ 防篡改表不支持非行存表、临时表、外表、unlog表、非行存表均无防篡改属性。
>+ 防篡改表在创建时会自动增加一个名为hash的系统列，所以防篡改表单表最大列数为1599。

>[!WARNING]注意
>
>+ dbe_perf和snapshot两个模式不能ALTER为blockchain属性，如：ALTER SCHEMA dbe_perf WITH BLOCKCHAIN;。
>+ 系统模式不能 ALTER 为blockchain属性，如：ALTER SCHEMA pg_catalog WITH BLOCKCHAIN;。
>+ 包含表的SCHEMA不能通过ALTER SCHEMA语句修改属性为blockchain。

3.修改防篡改用户表数据。

例如，对防篡改用户表执行INSERT/UPDATE/DELETE。

```
openGauss=# INSERT INTO ledgernsp.usertable VALUES(1, 'alex'), (2, 'bob'), (3, 'peter');
INSERT 0 3
openGauss=# SELECT *, hash FROM ledgernsp.usertable ORDER BY id;
 id | name  |       hash
----+-------+------------------
  1 | alex  | 1f2e543c580cb8c5
  2 | bob   | 8fcd74a8a6a4b484
  3 | peter | f51b4b1b12d0354b
(3 rows)

openGauss=# UPDATE ledgernsp.usertable SET name = 'bob2' WHERE id = 2;
UPDATE 1
openGauss=# SELECT *, hash FROM ledgernsp.usertable ORDER BY id;
 id | name  |       hash
----+-------+------------------
  1 | alex  | 1f2e543c580cb8c5
  2 | bob2  | 437761affbb7c605
  3 | peter | f51b4b1b12d0354b
(3 rows)

openGauss=# DELETE FROM ledgernsp.usertable WHERE id = 3;
DELETE 1
openGauss=# SELECT *, hash FROM ledgernsp.usertable ORDER BY id;
 id | name |       hash
----+------+------------------
  1 | alex | 1f2e543c580cb8c5
  2 | bob2 | 437761affbb7c605
(2 rows)
```
