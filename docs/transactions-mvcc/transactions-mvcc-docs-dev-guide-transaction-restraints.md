---
title: 事务限制
summary: 介绍 TiDB 中的事务限制。
aliases: ['/zh/tidb/dev/transaction-restraints','/zh/tidb/stable/dev-guide-transaction-restraints/','/zh/tidb/dev/dev-guide-transaction-restraints/','/zh/tidbcloud/dev-guide-transaction-restraints/']
---

# 事务限制

本章将简单介绍 TiDB 中的事务限制。

## 隔离级别

TiDB 支持的隔离级别是 RC（Read Committed）与 SI（Snapshot Isolation），其中 SI 与 RR（Repeatable Read）隔离级别基本等价。

![隔离级别](/media/develop/transaction_isolation_level.png)

## SI 可以克服幻读

TiDB 的 SI 隔离级别可以克服幻读异常 (Phantom Reads)，但 ANSI/ISO SQL 标准中的 RR 不能。

所谓幻读是指：事务 A 首先根据条件查询得到 n 条记录，然后事务 B 改变了这 n 条记录之外的 m 条记录或者增添了 m 条符合事务 A 查询条件的记录，导致事务 A 再次发起请求时发现有 n+m 条符合条件记录，就产生了幻读。

例如：系统管理员 A 将数据库中所有学生的成绩从具体分数改为 ABCDE 等级，但是系统管理员 B 就在这个时候插入了一条具体分数的记录，当系统管理员 A 改结束后发现还有一条记录没有改过来，就好像发生了幻觉一样，这就叫幻读。

## SI 不能克服写偏斜

TiDB 的 SI 隔离级别不能克服写偏斜异常（Write Skew），需要使用 Select for update 语法来克服写偏斜异常。

写偏斜异常是指两个并发的事务读取了不同但相关的记录，接着这两个事务各自更新了自己读到的数据，并最终都提交了事务，如果这些相关的记录之间存在着不能被多个事务并发修改的约束，那么最终结果将是违反约束的。

举个例子，假设你正在为医院写一个医生轮班管理程序。医院通常会同时要求几位医生待命，但底线是至少有一位医生在待命。医生可以放弃他们的班次（例如，如果他们自己生病了），只要至少有一个同事在这一班中继续工作。

现在出现这样一种情况，Alice 和 Bob 是两位值班医生。两人都感到不适，所以他们都决定请假。不幸的是，他们恰好在同一时间点击按钮下班。下面用程序来模拟一下这个过程。

SQL 日志：

```sql
/* txn 1 */ BEGIN
    /* txn 2 */ BEGIN
    /* txn 2 */ SELECT COUNT(*) as `count` FROM `doctors` WHERE `on_call` = 1 AND `shift_id` = 123
    /* txn 2 */ UPDATE `doctors` SET `on_call` = 0 WHERE `id` = 2 AND `shift_id` = 123
    /* txn 2 */ COMMIT
/* txn 1 */ SELECT COUNT(*) AS `count` FROM `doctors` WHERE `on_call` = 1 and `shift_id` = 123
/* txn 1 */ UPDATE `doctors` SET `on_call` = 0 WHERE `id` = 1 AND `shift_id` = 123
/* txn 1 */ COMMIT
```

执行结果：

```sql
mysql> SELECT * FROM doctors;
+----+-------+---------+----------+
| id | name  | on_call | shift_id |
+----+-------+---------+----------+
|  1 | Alice |       0 |      123 |
|  2 | Bob   |       0 |      123 |
|  3 | Carol |       0 |      123 |
+----+-------+---------+----------+
```

在两个事务中，应用首先检查是否有两个或以上的医生正在值班；如果是的话，它就假定一名医生可以安全地休班。由于数据库使用快照隔离，两次检查都返回 2，所以两个事务都进入下一个阶段。Alice 更新自己的记录休班了，而 Bob 也做了一样的事情。两个事务都成功提交了，现在没有医生值班了。违反了至少有一名医生在值班的要求。下图(引用自《Designing Data-Intensive Application》)说明了实际发生的情况：

![Write Skew](/media/develop/write-skew.png)

现在更改示例程序，使用 `SELECT FOR UPDATE` 来克服写偏斜问题：

SQL 日志：

```sql
/* txn 1 */ BEGIN
    /* txn 2 */ BEGIN
    /* txn 2 */ SELECT COUNT(*) AS `count` FROM `doctors` WHERE on_call = 1 AND `shift_id` = 123 FOR UPDATE
    /* txn 2 */ UPDATE `doctors` SET on_call = 0 WHERE `id` = 2 AND `shift_id` = 123
    /* txn 2 */ COMMIT
/* txn 1 */ SELECT COUNT(*) AS `count` FROM `doctors` WHERE `on_call` = 1 FOR UPDATE
At least one doctor is on call
/* txn 1 */ ROLLBACK
```

执行结果：

```sql
mysql> SELECT * FROM doctors;
+----+-------+---------+----------+
| id | name  | on_call | shift_id |
+----+-------+---------+----------+
|  1 | Alice |       1 |      123 |
|  2 | Bob   |       0 |      123 |
|  3 | Carol |       0 |      123 |
+----+-------+---------+----------+
```

## 对 savepoint 和嵌套事务的支持

> **注意：**
>
> TiDB 从 v6.2.0 版本开始支持 [savepoint](/sql-statements/sql-statement-savepoint.md) 特性。因此低于 v6.2.0 版本的 TiDB 不支持 `PROPAGATION_NESTED` 传播行为。建议升级至 v6.2.0 及之后版本。如无法升级 TiDB 版本，且基于 Java Spring 框架的应用使用了 `PROPAGATION_NESTED` 传播行为，需要在应用端做出调整，将嵌套事务的逻辑移除。

Spring 支持的 PROPAGATION_NESTED 传播行为会启动一个嵌套的事务，它是当前事务之上独立启动的一个子事务。嵌套事务开始时会记录一个 savepoint，如果嵌套事务执行失败，事务将会回滚到 savepoint 的状态。嵌套事务是外层事务的一部分，它将会在外层事务提交时一起被提交。下面案例展示了 savepoint 机制：

```sql
mysql> BEGIN;
mysql> INSERT INTO T2 VALUES(100);
mysql> SAVEPOINT svp1;
mysql> INSERT INTO T2 VALUES(200);
mysql> ROLLBACK TO SAVEPOINT svp1;
mysql> RELEASE SAVEPOINT svp1;
mysql> COMMIT;
mysql> SELECT * FROM T2;
+------+
|  ID   |
+------+
|  100 |
+------+
```

## 大事务限制

基本原则是要限制事务的大小。TiDB 对单个事务的大小有限制，这层限制是在 KV 层面。反映在 SQL 层面的话，简单来说一行数据会映射为一个 KV entry，每多一个索引，也会增加一个 KV entry。所以这个限制反映在 SQL 层面是：

- 最大单行记录容量为 120 MiB。

  - TiDB v4.0.10 及更高的 v4.0.x 版本、v5.0.0 及更高的版本可通过 tidb-server 配置项 [`performance.txn-entry-size-limit`](/tidb-configuration-file.md#txn-entry-size-limit-从-v4010-和-v500-版本开始引入) 调整，低于 TiDB v4.0.10 的版本支持的单行容量为 6 MiB。
  - 从 v7.6.0 开始，你可以使用 [`tidb_txn_entry_size_limit`](/system-variables.md#tidb_txn_entry_size_limit-从-v760-版本开始引入) 系统变量动态修改该配置项的值。
  - 注意，TiKV 对单个写入请求的数据量大小也有限制。若单个写入请求的数据量超出 [`raftstore.raft-entry-max-size`](/tikv-configuration-file.md#raft-entry-max-size)（默认值为 8 MiB），TiKV 会拒绝处理该请求。当单行记录较大时，需要同时调整 TiDB 的 `tidb_txn_entry_size_limit` 和 TiKV 的 `raftstore.raft-entry-max-size`。

- 支持的最大单个事务容量为 1 TiB。

  - TiDB v4.0 及更高版本可通过 tidb-server 配置项 [`performance.txn-total-size-limit`](/tidb-configuration-file.md#txn-total-size-limit) 调整，低于 TiDB v4.0 的版本支持的最大单个事务容量为 100 MiB。
  - 在 v6.5.0 及之后的版本中，不再推荐使用配置项 [`performance.txn-total-size-limit`](/tidb-configuration-file.md#txn-total-size-limit)。更多详情请参考 [`performance.txn-total-size-limit`](/tidb-configuration-file.md#txn-total-size-limit)。

另外注意，无论是大小限制还是行数限制，还要考虑事务执行过程中，TiDB 做编码以及事务额外 Key 的开销。在使用的时候，为了使性能达到最优，建议每 100 ～ 500 行写入一个事务。

## 自动提交的 `SELECT FOR UPDATE` 语句不会等锁

目前，自动提交下的 `SELECT FOR UPDATE` 不会加锁。下图显示了在两个不同会话中的效果：

![TiDB中的情况](/media/develop/autocommit_selectforupdate_nowaitlock.png)

这是已知的与 MySQL 不兼容的地方。

可以通过使用显式的 `BEGIN;COMMIT;` 解决该问题。
