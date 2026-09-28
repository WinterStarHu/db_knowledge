# 扩展语法

openGauss提供的扩展语法如下。

**表 1**  扩展SQL语法

语法关键字 创建表CREATE TABLE column_constraint： REFERENCES reftable [ ( refcolumn ) ] [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ][ ON DELETE action ] [ ON UPDATE action ] 支持用REFERENCES reftable[ ( refcolumn ) ] [ MATCH FULL |MATCH PARTIAL | MATCH SIMPLE ] [ ON DELETE action ] [ ON UPDATE action ] 为表创建外键约束。
加载模块 CREATE Extension 把一个新的模块（例如DBLINK）加载进当前数据库中。
DROP Extension 删除已加载的模块。
聚集函数 CREATE AGGREGATE 定义一个新的聚集函数。
ALTER AGGREGATE 修改一个聚集函数的定义。
DROP AGGREGATE 删除一个现存的聚集函数。
