# DDL语法一览表

DDL（Data Definition Language数据定义语言），用于定义或修改数据库中的对象。如：表、索引、视图等。

>[!NOTE]说明
>
>openGauss不支持数据库主节点不完整时进行DDL操作。例如：openGauss中有1个数据库主节点故障时执行新建数据库、表等操作都会失败。

## 定义客户端加密主密钥

客户端加密主密钥主要用于密态数据库特性，用来加密列加密密钥\(cek\)。客户端加密主密钥定义主要包括创建客户端加密主密钥以及删除客户端加密主密钥。所涉及的SQL语句，请参考[表1](#table1932183717514)。

**表 1**  客户端加密主密钥定义相关SQL

相关SQL 创建客户端加密主密钥 CREATE CLIENT MASTER KEY 删除客户端加密主密钥 DROP CLIENT MASTER KEY

## 定义列加密密钥

列加密密钥主要用于密态数据库特性中，用来加密数据。列加密密钥定义主要包括创建列加密密钥以及删除列加密密钥。所涉及的SQL语句，请参考[表2](#table1932183717514)。

**表 2**  列加密密钥定义相关SQL

相关SQL 创建列加密密钥 CREATE COLUMN ENCRYPTION KEY 删列加密密钥 DROP COLUMN ENCRYPTION KEY

## 定义数据库

数据库是组织、存储和管理数据的仓库，而数据库定义主要包括：创建数据库、修改数据库属性以及删除数据库。所涉及的SQL语句，请参考[表3](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_t986073679146430a8bce8bf0ea8f3607)。

**表 3**  数据库定义相关SQL

相关SQL 创建数据库 CREATE DATABASE 修改数据库属性 ALTER DATABASE 删除数据库 DROP DATABASE

## 定义模式

模式是一组数据库对象的集合，主要用于控制对数据库对象的访问。所涉及的SQL语句，请参考[表4](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_t02977f28a9564837881f110b305d7509)。

**表 4**  模式定义相关SQL

相关SQL 创建模式 CREATE SCHEMA 修改模式属性 ALTER SCHEMA 删除模式 DROP SCHEMA

## 定义表空间

表空间用于管理数据对象，与磁盘上的一个目录对应。所涉及的SQL语句，请参考[表5](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_t9b028195c0d143f6b8fc7065af1ce2f9)。

**表 5**  表空间定义相关SQL

相关SQL 创建表空间 CREATE TABLESPACE 修改表空间属性 ALTER TABLESPACE 删除表空间 DROP TABLESPACE

## 定义表

表是数据库中的一种特殊数据结构，用于存储数据对象以及对象之间的关系。所涉及的SQL语句，请参考[表6](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_tcd92dbef720d4b7eaa5bf7a290b98605)。

**表 6**  表定义相关SQL

相关SQL 创建表 CREATE TABLE 修改表属性 ALTER TABLE 删除表 DROP TABLE

## 定义分区表

分区表是一种逻辑表，数据是由普通表存储的，主要用于提升查询性能。所涉及的SQL语句，请参考[表7](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_t3ec179079c524dbaae801012f990a692)。

**表 7**  分区表定义相关SQL

相关SQL 创建分区表 CREATE TABLE PARTITION 创建分区 ALTER TABLE PARTITION 修改分区表属性 ALTER TABLE PARTITION 删除分区 ALTER TABLE PARTITION 删除分区表 DROP TABLE

## 定义索引

索引是对数据库表中一列或多列的值进行排序的一种结构，使用索引可快速访问数据库表中的特定信息。所涉及的SQL语句，请参考[表8](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_te79920e4b7b849b7a64fb71029436d48)。

**表 8**  索引定义相关SQL

相关SQL 创建索引 CREATE INDEX 修改索引属性 ALTER INDEX 删除索引 DROP INDEX 重建索引 REINDEX

## 定义存储过程

存储过程是一组为了完成特定功能的SQL语句集，经编译后存储在数据库中，用户通过指定存储过程的名称并给出参数（如果该存储过程带有参数）来执行它。所涉及的SQL语句，请参考[表9](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_t0116270962694804b50796a5d6824f3b)。

**表 9**  存储过程定义相关SQL

相关SQL 创建存储过程 CREATE PROCEDURE 删除存储过程 DROP PROCEDURE 修改存储过程 ALTER PROCEDURE

## 定义函数

在openGauss中，它和存储过程类似，也是一组SQL语句集，使用上没有差别。所涉及的SQL语句，请参考[表10](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_tde31d523c25742e2aecc5ae8a17d561b)。

**表 10**  函数定义相关SQL

相关SQL 创建函数 CREATE FUNCTION 修改函数属性 ALTER FUNCTION 删除函数 DROP FUNCTION

## 定义包

包是模块化的思想，由包头（package specification）和包体\(package body\)组成，用来分类管理存储过程和函数，类似于Java、C++等语言中的类。

**表 11**  包定义相关SQL

相关SQL 创建包 CREATE PACKAGE 删除包 DROP PACKAGE 修改包属性 ALTER PACKAGE

## 定义视图

视图是从一个或几个基本表中导出的虚表，可用于控制用户对数据访问，请参考[表12](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_td65563e06b1c491892dbad9b57f3b96d)。

**表 12**  视图定义相关SQL

相关SQL 创建视图 CREATE VIEW 删除视图 DROP VIEW

## 定义游标

为了处理SQL语句，存储过程进程分配一段内存区域来保存上下文联系。游标是指向上下文区域的句柄或指针。借助游标，存储过程可以控制上下文区域的变化，请参考[表13](#zh-cn_topic_0283136643_zh-cn_topic_0237122049_zh-cn_topic_0059777960_t191f977ebe0a4ab5b1348c888403e3b4)。

**表 13**  游标定义相关SQL

相关SQL 创建游标 CURSOR 移动游标 MOVE 从游标中提取数据 FETCH 关闭游标 CLOSE

## 定义聚合函数

又称作汇总函数，可以对一组值执行计算并返回单个值，一般用于对数据集合进行汇总统计。

**表 14**  聚合函数定义相关SQL

相关SQL 创建一个新的聚合函数 CREATE AGGREGATE 修改聚合函数 ALTER AGGREGATE 删除聚合函数 DROP AGGREGATE

## 定义数据类型转换

将数据分类为不同类型时，都不可避免地需要从一种数据类型转换为另一种数据类型。将一种数据类型转换为另一种数据类型的原因包括将数据从一种数据库类型移植到另一种数据库类型、更改列的数据类型或在数据类型之间临时切换以进行计算。

**表 15**  数据类型定义相关SQL

相关SQL 创建一个新的用户自定义数据类型转换 CREATE CAST 删除用户自定义数据类型转换 DROP CAST

## 定义插件扩展

开放的插件接口，为开发者开发自定义插件提供了便利。

**表 16**  插件扩展定义相关SQL

相关SQL 创建一个新的插件扩展 CREATE Extension 修改插件扩展 ALTER Extension 删除插件扩展 DROP Extension

## 定义操作符

操作符/运算符大多用于在SELECT命令的WHERE字句中，表示表达式与其他元素之间的特定算数或逻辑关系，为返回的数据指定更明确的条件。SQL里有多种操作符，能满足不同的查询需求。

**表 17**  操作符定义相关SQL

相关SQL 创建一个新的操作符 CREATE OPERATOR 修改操作符 ALTER OPERATOR 删除操作符 DROP OPERATOR

## 定义运算符族

运算符族定义了一组相关的运算符类，可能还包含一些与该族内运算符类兼容的附加运算符和支持函数。
它们虽然能与运算符类协同工作，但对任何单个索引的实际运行并非必需。

**表 18** 运算符族定义相关 SQL

| 功能                 | 相关 SQL                                             |
| -------------------- | ---------------------------------------------------- |
| 创建一个新的运算符族 | [CREATE OPERATOR FAMILY](create_operator_family.md) |
| 删除运算符族         | [DROP OPERATOR FAMILY](drop_operator_family.md)     |

## 定义过程语言

**表 19**  过程语言定义相关SQL

相关SQL 创建一个新的过程语言 CREATE LANGUAGE 修改过程语言 ALTER LANGUAGE 删除过程语言 DROP LANGUAGE

## 定义数据类型

数据类型定义列中存放的值的种类。 SQL 通用数据类型 数据库表中的每个列都要求有名称和数据类型。

**表 20**  数据类型定义相关SQL 相关SQL 创建一个新的数据类型 CREATE TYPE 修改数据类型 ALTER TYPE 删除数据类型 DROP TYPE
