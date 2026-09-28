# SQL Rewriter

## 概述

SQL Rewriter是一个SQL改写工具，根据预先设定的规则，将查询语句转换为更为高效或更为规范的形式，使得查询效率得以提升。

>[!NOTE]说明
>
>- 本功能不适用包含子查询的语句。
>- 本功能只支持SELECT语句和对整个表格进行删除的DELETE语句。
>- 本功能包含12个改写规则，对不符合改写规则的语句，将不会进行处理。
>- 本功能会对原始查询语句和改写后语句进行屏幕输出，不建议对包含涉敏感信息的SQL语句进行改写。
>- union转union all规则避免了去重，从而提升了查询性能，所得结果有可能存在冗余。
>- 语句中若包含“order by”+ 指定列名或“group by”+ 指定列名，将无法适用SelfJoin规则。
>- 工具不保证查询语句等价转换，其目的是提升查询语句效率，一些推荐结果，需要结合业务实践进行优化，例如显性要求指定select的字段名。

## 使用指导

### 前提条件

数据库状态正常、连接正常。

### 使用方法示例

以tpcc数据库为例：

```
gs_dbmind component sql_rewriter 5030 tpcc queries.sql --db-host 127.0.0.1 --db-user myname --schema public
```

queries.sql为需要改写的SQL文件，内容如下：

```
DELETE FROM bmsql_config;
DELETE FROM bmsql_config WHERE cfg_name='1';
```

结果为多个改写后的查询语句，显示在屏幕（无法改写的语句，显示为空），如下：

```
+--------------------------------------------------------------------------+------------------------------+
| Raw SQL                                                                  | Rewritten SQL                |
+--------------------------------------------------------------------------+------------------------------+
| DELETE FROM bmsql_config;                                                | TRUNCATE TABLE bmsql_config; |
| DELETE FROM bmsql_config WHERE cfg_name='1';                             |                              |
+--------------------------------------------------------------------------+------------------------------+
```

## 获取帮助

使用SQL Rewriter前，您可以通过以下指令获取帮助。

```
gs_dbmind component sql_rewriter --help
```

显示如下帮助信息：

```
usage:  [-h] [--db-host DB_HOST] [--db-user DB_USER] [--schema SCHEMA]
        [-v] db_port database file

SQL Rewriter

positional arguments:
  db_port            Port for database
  database           Name for database
  file               File containing SQL statements which need to rewrite

optional arguments:
  -h, --help         show this help message and exit
  --db-host DB_HOST  Host for database
  --db-user DB_USER  Username for database log-in
  --schema SCHEMA    Schema name for the current business data
  -v, --version      show program's version number and exit
```

密码通过管道输入或交互式输入，对于免密用户，任意输入都可通过检验。

## 命令参考

**表 1**  命令行参数说明

参数名称 -h, --help 帮助命令。
db_port 数据库端口号。
database 数据库名称。
file 包含多个查询语句的文件路径。
--db-host （可选）数据库主机号。
--db-user （可选）数据库用户名。
--schema （可选）模式，不指定时默认为public。
-v, --version 获取版本号。

## 常见问题处理

- SQL无法改写：请查看SQL是否符合改写规则或SQL语法是否正确。
