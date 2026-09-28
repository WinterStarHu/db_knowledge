# LOCK

## 功能描述

LOCK TABLE获取表级锁。

openGauss在为一个引用了表的命令自动请求锁时，尽可能选择最小限制的锁模式。如果用户需要一种更为严格的锁模式，可以使用LOCK命令。例如，一个应用是在Read Committed隔离级别上运行事务，并且它需要保证表中的数据在事务的运行过程中不被修改。为实现这个目的，则可以在查询之前对表使用SHARE锁模式进行锁定。这样将防止数据不被并发修改，从而保证后续的查询可以读到已提交的持久化的数据。因为SHARE锁模式与任何写操作需要的ROW EXCLUSIVE模式冲突，并且LOCK TABLE name IN SHARE MODE语句将等到所有当前持有ROW EXCLUSIVE模式锁的事务提交或回滚后才能执行。因此，一旦获得该锁，就不会存在未提交的写操作，并且其他操作也只能等到该锁释放之后才能开始。

## 注意事项

- LOCK TABLE只能在一个事务块的内部生效，因为锁在事务结束时就会被释放。出现在任意事务块外面的LOCK TABLE都会报错。
- 如果没有声明锁模式，缺省为最严格的模式ACCESS EXCLUSIVE。
- LOCK TABLE ... IN ACCESS SHARE MODE需要在目标表上有SELECT权限。所有其他形式的LOCK需要UPDATE和/或DELETE权限。
- 没有UNLOCK TABLE命令，锁总是在事务结束时释放。
- LOCK TABLE只处理表级的锁，因此那些带“ROW”字样的锁模式都是有歧义的。这些模式名称通常可理解为用户试图在一个被锁定的表中获取行级的锁。同样，ROW EXCLUSIVE模式也是一个可共享的表级锁。注意，只要是涉及到LOCK TABLE ，所有锁模式都有相同的语意，区别仅在于规则中锁与锁之间是否冲突，规则请参见[表1](#zh-cn_topic_0237122168_zh-cn_topic_0059778442_ta3d4fbc3c92c4f2994f7a9f5583a6ba5)。
- 如果没有打开xc\_maintenance\_mode参数，那么对系统表申请ACCESS EXCLUSIVE级别锁将报错。

## 语法格式

```
LOCK [ TABLE ] {[ ONLY ] name [, ...]| {name [ * ]} [, ...]}
    [ IN {ACCESS SHARE | ROW SHARE | ROW EXCLUSIVE | SHARE UPDATE EXCLUSIVE | SHARE | SHARE ROW EXCLUSIVE | EXCLUSIVE | ACCESS EXCLUSIVE} MODE ]
    [ NOWAIT ];
```

## 参数说明

**表 1**  冲突的锁模式

请求的锁模式/当前锁模式 ACCESS SHARE ROW SHARE ROW EXCLUSIVE SHARE UPDATE EXCLUSIVE SHARE SHARE ROW EXCLUSIVE EXCLUSIVE ACCESS EXCLUSIVE ACCESS SHARE ROW SHARE ROW EXCLUSIVE SHARE UPDATE EXCLUSIVE SHARE SHARE ROW EXCLUSIVE EXCLUSIVE ACCESS EXCLUSIVE

LOCK的参数说明如下所示：

- **name**

要锁定的表的名称，可以有模式修饰。

LOCK TABLE命令中声明的表的顺序就是上锁的顺序。

取值范围：已存在的表名。

- **ONLY**

如果指定ONLY，只有该表被锁定。如果没有声明，该表和他的所有子表将都被锁定。

- **ACCESS SHARE**

ACCESS锁只允许对表进行读取，而禁止对表进行修改。所有对表进行读取而不修改的SQL语句都会自动请求这种锁。例如，SELECT命令会自动在被引用的表上请求一个这种锁。

- **ROW SHARE**

与EXCLUSIVE和ACCESS EXCLUSIVE锁模式冲突。

SELECT FOR UPDATE、SELECT FOR NO KEY UPDATE、SELECT FOR SHARE和SELECT FOR KEY SHARE命令会自动在目标表上请求ROW SHARE锁（且所有被引用但不是FOR KEY SHARE/FOR SHARE/FOR NO KEY UPDATE/FOR UPDATE的其他表上，还会自动加上ACCESS SHARE锁）。

- **ROW EXCLUSIVE**

与ROW SHARE锁相同，ROW EXCLUSIVE允许并发读取表，但是禁止修改表中数据。UPDATE，DELETE，INSERT命令会自动在目标表上请求这个锁（且所有被引用的其他表上还会自动加上的ACCESS SHARE锁）。通常情况下，所有会修改表数据的命令都会请求表的ROW EXCLUSIVE锁。

- **SHARE UPDATE EXCLUSIVE**

这个模式保护一个表的模式不被并发修改，以及禁止在目标表上执行垃圾回收命令（VACUUM ）。

VACUUM（不带FULL选项），ANALYZE，CREATE INDEX CONCURRENTLY命令会自动请求这样的锁。

- **SHARE**

SHARE锁允许并发的查询，但是禁止对表进行修改。

CREATE INDEX（不带CONCURRENTLY选项）语句会自动请求这种锁。

- **SHARE ROW EXCLUSIVE**

SHARE ROW EXCLUSIVE锁禁止对表进行任何的并发修改，而且是独占锁，因此一个会话中只能获取一次。

任何SQL语句都不会自动请求这个锁模式。

- **EXCLUSIVE**

EXCLUSIVE锁允许对目标表进行并发查询，但是禁止任何其他操作。

这个模式只允许并发加ACCESS SHARE锁，也就是说，只有对表的读动作可以和持有这个锁模式的事务并发执行。

任何SQL语句都不会在用户表上自动请求这个锁模式。然而在某些操作的时候，会在某些系统表上请求它。

- **ACCESS EXCLUSIVE**

这个模式保证其所有者（事务）是可以访问该表的唯一事务。

ALTER TABLE，DROP TABLE，TRUNCATE，REINDEX命令会自动请求这种锁。

在LOCK TABLE命令没有明确声明需要的锁模式时，它是缺省锁模式。

- **NOWAIT**

声明LOCK TABLE不去等待任何冲突的锁释放，如果无法立即获取该锁，该命令退出并且发出一个错误信息。

在不指定NOWAIT的情况下获取表级锁时，如果有其他互斥锁存在的话，则等待其他锁的释放。

## 示例

```
--在执行删除操作时对一个有主键的表进行 SHARE ROW EXCLUSIVE 锁。
openGauss=# CREATE TABLE tpcds.reason_t1 (
r_reason_sk integer,
r_reason_id character(16),
r_reason_desc character(100),
primary key (r_reason_sk)
);

openGauss=# insert into tpcds.reason_t1 values (1, 'AAAAAAABAAAAAA','reason1');

openGauss=# insert into tpcds.reason_t1 values (2, 'AAAAAAACAAAAAA','reason2');

openGauss=# insert into tpcds.reason_t1 values (3, 'AAAAAAADAAAAAA','reason3');

openGauss=# insert into tpcds.reason_t1 values (4, 'AAAAAAAEAAAAAA','reason4');

openGauss=# insert into tpcds.reason_t1 values (5, 'AAAAAAAFAAAAAA','reason5');

openGauss=# insert into tpcds.reason_t1 values (6, 'AAAAAAAGAAAAAA','reason6');

openGauss=# insert into tpcds.reason_t1 values (7, 'AAAAAAAHAAAAAA','reason7');

openGauss=# insert into tpcds.reason_t1 values (8, 'AAAAAAAIAAAAAA','reason8');

openGauss=# START TRANSACTION;

openGauss=# LOCK TABLE tpcds.reason_t1 IN SHARE ROW EXCLUSIVE MODE;

openGauss=# DELETE FROM tpcds.reason_t1 WHERE r_reason_desc IN(SELECT r_reason_desc FROM tpcds.reason_t1 WHERE r_reason_sk < 6 );

openGauss=# DELETE FROM tpcds.reason_t1 WHERE r_reason_sk = 7;

openGauss=# COMMIT;

--删除表tpcds.reason_t1。
openGauss=# DROP TABLE tpcds.reason_t1;
```
