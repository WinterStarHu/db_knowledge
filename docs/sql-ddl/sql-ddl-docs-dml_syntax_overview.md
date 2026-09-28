# DML语法一览表

DML（Data Manipulation Language数据操作语言），用于对数据库表中的数据进行操作。如：插入、更新、查询、删除。

## 插入数据

插入数据是往数据库表中添加一条或多条记录，请参考[INSERT](insert.md)。

## 修改数据

修改数据是修改数据库表中的一条或多条记录，请参考[UPDATE](update.md)。

## 查询数据

数据库查询语句SELECT是用于在数据库中检索适合条件的信息，请参考[SELECT](select.md)。

## 删除数据

openGauss提供了两种删除表数据的语句：删除表中指定条件的数据，请参考[DELETE](delete.md)；或删除表的所有数据，请参考[TRUNCATE](truncate.md)。

TRUNCATE快速地从表中删除所有行，它和在每个表上进行无条件的DELETE有同样的效果，不过因为它不做表扫描，因而快得多。在大表上最有用。

## 拷贝数据

openGauss提供了在表和文件之间拷贝数据的语句，请参考[COPY](copy.md)。

## 锁定表

openGauss提供了多种锁模式用于控制对表中数据的并发访问，请参考[LOCK](lock_sql.md)。

## 调用函数

openGauss提供了三个用于调用函数的语句，它们在语法结构上没有差别，请参考[CALL](call.md)。

## 操作会话

用户与数据库之间建立的连接称为会话，请参考[表1](#zh-cn_topic_0283137022_zh-cn_topic_0237122050_zh-cn_topic_0059777960_t320d7e04ba33427cbe2132b994ef6cb2)。

**表 1**  会话相关SQL

相关SQL 修改会话 ALTER SESSION 结束会话 ALTER SYSTEM KILL SESSION
