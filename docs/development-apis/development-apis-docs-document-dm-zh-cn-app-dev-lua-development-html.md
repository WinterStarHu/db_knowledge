# lua接口 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/lua-development.html

lua接口 | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

lua接口

一、环境准备

1.1 达梦数据库安装

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，安装步骤请参考数据库环境准备。

1.2 注册 ODBC 数据源

请参考通过 ODBC 连接数据库。

1.3 下载 Lua 源码

点击 luasql 下载源码。

二、配置 LuaSQL

2.1 解压 LuaSQL

unzip luasql-master.zip

2.2 修改配置文件

修改 odbc 配置参数。

cd luasql-master vi config

DRIVER_LIBS_odbc ?= -L/usr/local/lib -lodbc   //odbc动态链接库 DRIVER_INCS_odbc ?= -DUNIXODBC -I/usr/local/include  //c头文件目录

2.3 生成 C 程序库

make odbc install

三、测试用例

3.1 测试连接

创建 test.lua 文件，测试连接的代码如下：

local luasql =  require "luasql.odbc" env = luasql.odbc() con = env:connect ("DM8","SYSDBA","*****") conn =assert(con) if conn then print("连接成功") con:close() else print("连接失败") end env:close()

执行命令 lua test.lua，结果如下：

3.2 测试插入

创建 test2.lua 文件，插入数据的代码如下：

local luasql =  require "luasql.odbc" env = luasql.odbc() con = env:connect ("DM8","SYSDBA","*****") conn =assert(con)

con:execute("DROP TABLE IF EXISTS SYSDBA.TEST01;")

local create_table_sql = [[ create table "SYSDBA"."TEST01" ( "ID" INTEGER, "NAME" VARCHAR(100) );
]]

local res, err = conn:execute(create_table_sql) if res then print("Table created successfully!") else print("Failed to create table: " .. err) end

local insert_sql = [[ INSERT INTO "SYSDBA"."TEST01" (ID, NAME) VALUES (1,'Alice');
INSERT INTO "SYSDBA"."TEST01" (ID, NAME) VALUES (2,'Bob');
]]

local res, err = conn:execute(insert_sql) if res then print("Data inserted successfully!") else print("Failed to insert data: " .. err) end

local update_sql = "UPDATE SYSDBA.TEST01 SET ID = 31 WHERE NAME = 'Alice';" local res, err = conn:execute(update_sql) if res then print("Data updated successfully!") else print("Failed to update data: " .. err) end

local delete_sql = "DELETE FROM SYSDBA.TEST01 WHERE NAME = 'Bob';" local res, err = conn:execute(delete_sql) if res then print("Data deleted successfully!") else print("Failed to delete data: " .. err) end

cur = con:execute ("SELECT * FROM SYSDBA.TEST01;") row = cur:fetch ({}, "a") local result_set = {}

while row do table.insert(result_set, row) row = cur:fetch(row, "a") end cur:close() con:close() env:close() for i, row in ipairs(result_set) do for k, v in pairs(row) do print(k, v) end print("-----") end

执行命令 lua test.lua，结果如下：

查看数据：

上次更新：2026-09-26 上一篇下一篇

lua接口

一、环境准备
1.1 达梦数据库安装
1.2 注册 ODBC 数据源
1.3 下载 Lua 源码
二、配置 LuaSQL
2.1 解压 LuaSQL
2.2 修改配置文件
2.3 生成 C 程序库
三、测试用例
3.1 测试连接
3.2 测试插入

微信扫码 分享文档

扫一扫 联系客服

关于我们

合作伙伴

招贤纳士

英文站

达梦官网

达梦技术

蜀天梦图

微信公众号

24小时热线

400 991 6599

商务咨询转 1 号线

技术咨询转 2 号线

技术支持

dmtech@dameng.com

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

简体中文

简体中文
