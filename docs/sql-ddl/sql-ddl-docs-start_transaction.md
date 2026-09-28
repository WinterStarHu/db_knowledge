# START TRANSACTION

## 功能描述

通过START TRANSACTION启动事务。如果声明了隔离级别、读写模式，那么新事务就使用这些特性，类似执行了[SET TRANSACTION](set_transaction.md)。

## 注意事项

无。

## 语法格式

格式一：START TRANSACTION格式

```
START TRANSACTION
  [
    {
       ISOLATION LEVEL { READ COMMITTED | SERIALIZABLE | REPEATABLE READ }
       | { READ WRITE | READ ONLY } | WITH CONSISTENT SNAPSHOT
    }  [, ...]
  ];
```

格式二：BEGIN格式

```
BEGIN [ WORK | TRANSACTION ]
  [
    {
       ISOLATION LEVEL { READ COMMITTED | SERIALIZABLE | REPEATABLE READ }
       | { READ WRITE | READ ONLY }
      } [, ...]
  ];
```

## 参数说明

- **WORK | TRANSACTION**

BEGIN格式中的可选关键字，没有实际作用。

- **ISOLATION LEVEL**

指定事务隔离级别，它决定当一个事务中存在其他并发运行事务时它能够看到什么数据。

>[!NOTE]说明
>在事务中第一个数据修改语句（SELECT、 INSERT、DELETE、UPDATE、FETCH、COPY）执行之后，事务隔离级别就不能再次设置。

取值范围：

  - READ COMMITTED：读已提交隔离级别，只能读到已经提交的数据，而不会读到未提交的数据。这是缺省值。
  - REPEATABLE READ：可重复读隔离级别，仅仅看到事务开始之前提交的数据，它不能看到未提交的数据，以及在事务执行期间由其它并发事务提交的修改。
  - SERIALIZABLE：openGauss目前功能上不支持此隔离级别，等价于REPEATABLE READ。

- **READ WRITE | READ ONLY**

指定事务访问模式（读/写或者只读）。

- **WITH CONSISTENT SNAPSHOT**

仅在可重复读隔离级别下生效，开启事务时即生成快照，其余隔离级别不生效，并产生告警。

## 示例

```
--以默认方式启动事务。
openGauss=# START TRANSACTION;
openGauss=# SELECT * FROM tpcds.reason;
openGauss=# END;

--以默认方式启动事务。
openGauss=# BEGIN;
openGauss=# SELECT * FROM tpcds.reason;
openGauss=# END;

--以隔离级别为READ COMMITTED，读/写方式启动事务。
openGauss=# START TRANSACTION ISOLATION LEVEL READ COMMITTED READ WRITE;
openGauss=# SELECT * FROM tpcds.reason;
openGauss=# COMMIT;

--可重复读隔离级别下，带WITH CONSISTENT SNAPSHOT开启事务。
openGauss=# START TRANSACTION WITH CONSISTENT SNAPSHOT;
openGauss=# SELECT * FROM tpcds.reason;
openGauss=# COMMIT;

--非可重复读隔离级别下，带WITH CONSISTENT SNAPSHOT开启事务。
openGauss=# START TRANSACTION WITH CONSISTENT SNAPSHOT;
WARNING:  with constent snapshot only effected in repeatable read mode
openGauss=# SELECT * FROM tpcds.reason;
openGauss=# COMMIT;
```

## 相关链接

[COMMIT | END](commit_end.md)，[ROLLBACK](rollback.md)，[SET TRANSACTION](set_transaction.md)
