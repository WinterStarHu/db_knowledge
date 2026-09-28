# ODBC 接口 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/c_c++_odbc.html

ODBC 接口 | 达梦技术文档

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

ODBC 接口

一、前言

ODBC 提供访问不同类型的数据库的途径。结构化查询语言 SQL 是一种用来访问数据库的语言。通过使用 ODBC，应用程序能够使用相同的源代码和各种各样的数据库交互。这使得开发者不需要以特殊的数据库管理系统 DBMS 为目标，或者了解不同支撑背景的数据库的详细细节，就能够开发和发布客户/服务器应用程序。

DM ODBC 3.0 遵照 Microsoft ODBC 3.0 规范设计与开发，实现了 ODBC 应用程序与 DM 数据库的互连接口。用户可以直接调 DM ODBC 3.0 接口函数访问 DM，也可以使用可视化编程工具如 C++ Builder、PowerBuilder 等利用 DM ODBC 3.0 访问 DM 数据库。

二、开发环境准备

2.1 达梦数据库版本

名称 版本

DM 数据库 DM 8.0 及以上版本

2.2 达梦数据库安装

请参考数据库环境准备。

2.3 数据源创建

2.3.1 Windows 环境创建 ODBC 数据源

在客户使用 ODBC 方法访问 DM 数据库服务器之前，必须先对自己的应用程序所用的 ODBC 数据源进行配置。本小节将介绍如何安装和配置 ODBC 数据源。

在 Windows 上使用 ODBC 数据源管理程序，配置 ODBC 数据源的步骤如下：

在控制面板上访问 ODBC 构件，显示 ODBC 数据源管理器对话框，如下图所示：

ODBC 数据源管理器对话框包含的标签如下所示：

用户 DSN：添加、删除或配置本机上的数据源，它们只可由当前用户使用。
系统 DSN：添加、删除或配置本机上的数据源，它们可由任何用户使用。
文件 DSN：添加、删除或配置在分离文件中的数据源。这些文件可以被安装了同样数据库驱动器的用户共享。
驱动程序：列出了安装在客户机上的数据库驱动器。
跟踪：用于测试你的数据库应用程序。它跟踪客户机和数据库服务器之间的 ODBC API 的调用。
连接池：允许不同的应用程序自动复用多个连接。这有助于限制和数据库服务器的通信过载。
关于：显示主要 ODBC 组件的版本。

设置和配置一个系统 DSN，请单击系统 DSN 标签，单击添加按钮增加一个新的 DSN，如下图所示：

选择 DM ODBC 3.0 驱动程序即 DM ODBC DRIVER，单击【完成】按钮，显示 DM ODBC 3.0 数据源配置对话框，如下图所示：

输入数据源的名称、描述，并选择你想要连接的数据库服务器的名字使用的端口号、验证登录用户 ID 真伪的方式。如果使用 DMServer 验证方式则需要输入登录数据源的 ID 以及密码等信息，选择系统提示信息的语种，以及选择是否使用 DMServer 的增强选项。

单击测试按钮测试配置的数据源是否正确，如下图所示：

单击确定按钮保存新的系统数据源，如下图所示：

单击确定按钮关闭 ODBC 数据源管理器对话框。

2.3.2 Linux 环境创建 ODBC 数据源

下载 unixODBC 和 unixODBC-devel。

安装 unixODBC 和 unixODBC-devel。

[root@RS1821 wt]# rpm -ivh unixODBC-devel-2.3.1-14.el7.x86_64.rpm unixODBC-2.3.1-14.el7.x86_64.rpm warning: unixODBC-devel-2.3.1-14.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY Preparing...                          ################################# [100%] Updating / installing...
1:unixODBC-2.3.1-14.el7            ################################# [ 50%] 2:unixODBC-devel-2.3.1-14.el7      ################################# [100%] [root@RS1821 wt]#

查看安装结果。

[root@RS1821 odbc]# odbcinst -j unixODBC 2.3.1 DRIVERS............: /etc/odbcinst.ini SYSTEM DATA SOURCES: /etc/odbc.ini FILE DATA SOURCES..: /etc/ODBCDataSources USER DATA SOURCES..: /root/.odbc.ini SQLULEN Size.......: 8 SQLLEN Size........: 8 SQLSETPOSIROW Size.: 8

2.3.2.1 配置 DM 数据源

配置 /etc/odbcinst.ini 文件，在 odbcinst.ini 文件中添加以下信息：

[DM8 ODBC DRIVER] Description = DM ODBC DRIVER FOR DM8 Driver = /opt/dm8/bin

注意

/opt/dm8/bin 对应 $DM_HOME/bin。

配置 /etc/odbc.ini 文件，在 odbc.ini 文件中添加以下信息：

[DM] DRIVER = DM8 ODBC DRIVER SERVER = 192.168.104.21 UID = SYSDBA PWD = ****** TCP_PORT = 51236

2.3.2.2 gcc 环境检查

gcc --version

执行结果如下：

[root@localhost odbctest]# gcc --version gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-36) Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions. There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

2.3.2.3 项目目录结构

odbctest ├── odbc_bind.c             // 绑定变量示例 ├── odbc_conn.c             // 数据库连接示例 ├── odbc_dml.c              // 基本操作示例 ├── odbc_lob.c              // 大字段操作示例 ├── file                   // 大字段操作示例中导入和导出文件目录
|   ├── DM8_SQL.pdf        // 大字段操作示例中导入文件
├── makfile                // makefile 编译脚本

注意

代码编译和运行前请确认相关文件的用户权限，建议全部使用dmdba用户。

makefile 脚本如下：

[dmdba@localhost odbctest]# cat makefile CC=gcc

includepath=$(DM_HOME)/include libpath=$(DM_HOME)/bin vpath=./

CFLAGS=-I$(includepath) -DDM64 -Wall LINKFLAGS=-L$(libpath) -ldodbc -Wall -Wl,-rpath $(libpath)

%.o:%.c $(CC) -g -c $(CFLAGS) $< -o $@

object_file1=odbc_conn.o object_file2=odbc_dml.o object_file3=odbc_bind.o object_file4=odbc_lob.o

object_files=odbc_conn.o odbc_dml.o odbc_bind.o odbc_lob.o

final_objects=odbc_conn odbc_dml odbc_bind odbc_lob

all : $(final_objects)

.PHONY : all clean rebuild

odbc_conn : $(object_file1) $(CC) -o $@ $(object_file1) -g $(LINKFLAGS) @echo make ok.

odbc_dml : $(object_file2) $(CC) -o $@ $(object_file2) -g $(LINKFLAGS) @echo make ok.

odbc_bind : $(object_file3) $(CC) -o $@ $(object_file3) -g $(LINKFLAGS) @echo make ok.

odbc_lob : $(object_file4) $(CC) -o $@ $(object_file4) -g $(LINKFLAGS) @echo make ok.

clean :
@rm -rf $(object_files) @rm -rf $(final_objects)

rebuild : clean all

makefile 编译截图：

三、数据库连接

3.1 数据库连接示例

ODBC 接口登录登出示例程序 odbc_conn.c 如下：

#include
#include
#include
#include
#include

/* 检测返回代码是否为成功标志，当为成功标志返回 TRUE，否则返回 FALSE */
#define RC_SUCCESSFUL(rc) ((rc) == SQL_SUCCESS || (rc) == SQL_SUCCESS_WITH_INFO)
/* 检测返回代码是否为失败标志，当为失败标志返回 TRUE，否则返回 FALSE */
#define RC_NOTSUCCESSFUL(rc) (!(RC_SUCCESSFUL(rc)))

HENV henv;/* 环境句柄 */ HDBC hdbc;/* 连接句柄 */ HSTMT hsmt;/* 语句句柄 */ SQLRETURN sret; /* 返回代码 */

int main(void) { /* 申请一个环境句柄 */ SQLAllocHandle(SQL_HANDLE_ENV, NULL, &henv);
/* 设置环境句柄的 ODBC 版本 */ SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3, SQL_IS_INTEGER);
/* 申请一个连接句柄 */ SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);

sret = SQLConnect(hdbc, (SQLCHAR *)"DM", SQL_NTS, (SQLCHAR *)"SYSDBA", SQL_NTS, (SQLCHAR *)"******", SQL_NTS);
if (RC_NOTSUCCESSFUL(sret)) { /* 连接数据源失败! */ printf("odbc: fail to connect to server!\n");
SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
SQLFreeHandle(SQL_HANDLE_ENV, henv);
exit(0);
} printf("odbc: connect to server success!\n");

/* 断开与数据源之间的连接 */ SQLDisconnect(hdbc);
/* 释放连接句柄 */ SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
/* 释放环境句柄 */ SQLFreeHandle(SQL_HANDLE_ENV, henv);

return 0;
}

执行结果如下：

[dmdba@localhost odbctest]# ./odbc_conn odbc: connect to server success!

四、开发示例

4.1 基础操作示例

ODBC 接口增、删、改、查四个基本操作，示例程序 odbc_dml.c 如下：

#include
#include
#include
#include
#include

/* 检测返回代码是否为成功标志，当为成功标志返回 TRUE，否则返回 FALSE */
#define RC_SUCCESSFUL(rc) ((rc) == SQL_SUCCESS || (rc) == SQL_SUCCESS_WITH_INFO)
/* 检测返回代码是否为失败标志，当为失败标志返回 TRUE，否则返回 FALSE */
#define RC_NOTSUCCESSFUL(rc) (!(RC_SUCCESSFUL(rc)))

HENV henv;/* 环境句柄 */ HDBC hdbc;/* 连接句柄 */ HSTMT hstmt;/* 语句句柄 */ SQLRETURN sret; /* 返回代码 */

int main(void) { int     out_c1 = 0;
SQLCHAR out_c2[20]= { 0 };
SQLLEN out_c1_ind = 0;
SQLLEN out_c2_ind = 0;

/* 申请句柄 */ SQLAllocHandle(SQL_HANDLE_ENV, NULL, &henv);
SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3, SQL_IS_INTEGER);
SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);

sret = SQLConnect(hdbc, (SQLCHAR *)"DM", SQL_NTS, (SQLCHAR *)"SYSDBA", SQL_NTS, (SQLCHAR *)"******", SQL_NTS);
if (RC_NOTSUCCESSFUL(sret)) { printf("odbc: fail to connect to server!\n");
SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
SQLFreeHandle(SQL_HANDLE_ENV, henv);
exit(0);
} printf("odbc: connect to server success!\n");

/* 申请一个语句句柄 */ SQLAllocHandle(SQL_HANDLE_STMT, hdbc, &hstmt);

//清空表，初始化测试环境 sret = SQLExecDirect(hstmt, (SQLCHAR *) "delete from PRODUCTION.PRODUCT_CATEGORY", SQL_NTS);

//插入数据 sret = SQLExecDirect(hstmt, (SQLCHAR *) "insert into PRODUCTION.PRODUCT_CATEGORY(NAME) values('语文'), ('数学'), ('英语'), ('体育') ", SQL_NTS);
if (RC_NOTSUCCESSFUL(sret)) { printf("odbc: insert fail\n");
} printf("odbc: insert success\n");

//删除数据 sret = SQLExecDirect(hstmt, (SQLCHAR *) "delete from PRODUCTION.PRODUCT_CATEGORY where name='数学' ", SQL_NTS);
if (RC_NOTSUCCESSFUL(sret)) { printf("odbc: delete fail\n");
} printf("odbc: delete success\n");

//更新数据 sret = SQLExecDirect(hstmt, (SQLCHAR *) "update PRODUCTION.PRODUCT_CATEGORY set name = '英语-新课标' where name='英语' ", SQL_NTS);
if (RC_NOTSUCCESSFUL(sret)) { printf("odbc: update fail\n");
} printf("odbc: update success\n");

//查询数据 SQLExecDirect(hstmt, (SQLCHAR *) "select * from PRODUCTION.PRODUCT_CATEGORY", SQL_NTS);
SQLBindCol(hstmt, 1, SQL_C_SLONG, &out_c1, sizeof(out_c1), &out_c1_ind);
SQLBindCol(hstmt, 2, SQL_C_CHAR, &out_c2, sizeof(out_c2), &out_c2_ind);

printf("odbc: select from table...\n");
while(SQLFetch(hstmt) != SQL_NO_DATA) { printf("c1 = %d, c2 = %s ,\n", out_c1, out_c2);
} printf("odbc: select success\n");

SQLFreeHandle(SQL_HANDLE_STMT, hstmt);

SQLDisconnect(hdbc);
SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
SQLFreeHandle(SQL_HANDLE_ENV, henv);
return 0;
}

执行结果如下：

[dmdba@localhost odbctest]# ./odbc_dml odbc: connect to server success!
odbc: insert success odbc: delete success odbc: update success odbc: select from table...
c1 = 19, c2 = 语文 , c1 = 21, c2 = 英语-新课标 , c1 = 22, c2 = 体育 , odbc: select success

4.2 绑定变量示例

ODBC 接口绑定变量示例程序 odbc_bind.c 如下：

#include
#include
#include
#include
#include
#include

/* 检测返回代码是否为成功标志，当为成功标志返回 TRUE，否则返回 FALSE */
#define RC_SUCCESSFUL(rc) ((rc) == SQL_SUCCESS || (rc) == SQL_SUCCESS_WITH_INFO)
/* 检测返回代码是否为失败标志，当为失败标志返回 TRUE，否则返回 FALSE */
#define RC_NOTSUCCESSFUL(rc) (!(RC_SUCCESSFUL(rc)))

HENV henv;/* 环境句柄 */ HDBC hdbc;/* 连接句柄 */ HSTMT hstmt;/* 语句句柄 */ SQLRETURN sret; /* 返回代码 */

int main(void) { SQLCHAR     sql[]="insert into PRODUCTION.PRODUCT_CATEGORY(NAME) values(?)";
SQLCHAR     in_c1[20] = { 0 };
SQLLEN      in_c1_ind_ptr;

memcpy(in_c1, "物理", 8);
in_c1_ind_ptr = 8;

int     out_c1 = 0;
SQLCHAR out_c2[20]= { 0 };
SQLLEN  out_c1_ind = 0;
SQLLEN  out_c2_ind = 0;

/* 申请句柄 */ SQLAllocHandle(SQL_HANDLE_ENV, NULL, &henv);
SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3, SQL_IS_INTEGER);
SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);

sret = SQLConnect(hdbc, (SQLCHAR *)"DM", SQL_NTS, (SQLCHAR *)"SYSDBA", SQL_NTS, (SQLCHAR *)"******", SQL_NTS);
if (RC_NOTSUCCESSFUL(sret)) { printf("odbc: fail to connect to server!\n");
SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
SQLFreeHandle(SQL_HANDLE_ENV, henv);
exit(0);
} printf("odbc: connect to server success!\n");

/* 申请一个语句句柄 */ SQLAllocHandle(SQL_HANDLE_STMT, hdbc, &hstmt);

//清空表，初始化测试环境 sret = SQLExecDirect(hstmt, (SQLCHAR *) "delete from PRODUCTION.PRODUCT_CATEGORY", SQL_NTS);

//绑定参数方式插入数据 printf( "insert with bind..\nsql: %s\npara: %s\n", (char*)sql, (char*)in_c1);
sret = SQLPrepare(hstmt, sql, SQL_NTS);
sret = SQLBindParameter(hstmt, 1, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, sizeof(in_c1), 0, in_c1, 0, &in_c1_ind_ptr);
sret = SQLExecute(hstmt);
if (RC_NOTSUCCESSFUL(sret)) { printf( "odbc: insert into table with bind fail!\n" );
} printf( "odbc: insert into table with bind success!\n" );

//查询数据 SQLExecDirect(hstmt, (SQLCHAR *) "select * from PRODUCTION.PRODUCT_CATEGORY", SQL_NTS);
SQLBindCol(hstmt, 1, SQL_C_SLONG, &out_c1, sizeof(out_c1), &out_c1_ind);
SQLBindCol(hstmt, 2, SQL_C_CHAR, &out_c2, sizeof(out_c2), &out_c2_ind);

printf("odbc: select from table...\n");
while(SQLFetch(hstmt) != SQL_NO_DATA) { printf("c1 = %d, c2 = %s ,\n", out_c1, out_c2);
} printf("odbc: select success\n");

SQLFreeHandle(SQL_HANDLE_STMT, hstmt);

SQLDisconnect(hdbc);
SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
SQLFreeHandle(SQL_HANDLE_ENV, henv);
return 0;
}

执行结果如下：

[dmdba@localhost odbctest]# ./odbc_bind odbc: connect to server success!
insert with bind..
sql: insert into PRODUCTION.PRODUCT_CATEGORY(NAME) values(?) para: 物理 odbc: insert into table with bind success!
odbc: select from table...
c1 = 23, c2 = 物理 , odbc: select success

4.3 大字段操作示例

ODBC 接口大字段操作包括大字段的插入，查询等。示例程序 odbc_lob.c 如下：

#include
#include
#include
#include
#include
#include

/* 检测返回代码是否为成功标志，当为成功标志返回 TRUE，否则返回 FALSE */
#define RC_SUCCESSFUL(rc) ((rc) == SQL_SUCCESS || (rc) == SQL_SUCCESS_WITH_INFO)
/* 检测返回代码是否为失败标志，当为失败标志返回 TRUE，否则返回 FALSE */
#define RC_NOTSUCCESSFUL(rc) (!(RC_SUCCESSFUL(rc)))

#define IN_FILE "./file/DM8_SQL.pdf"
#define OUT_FILE "./file/DM8_SQL1.pdf"
#define CHARS 80*1024 //一次读取和写入的字节数 80 KB

HENV henv;/* 环境句柄 */ HDBC hdbc;/* 连接句柄 */ HSTMT hstmt;/* 语句句柄 */ SQLRETURN sret; /* 返回代码 */

SQLSMALLINT errmsglen;
SQLINTEGER errnative;
UCHAR errmsg[255];
UCHAR errstate[5];

int main(void) { FILE*   pfile = NULL;
SQLCHAR tmpbuf[CHARS];
SQLLEN  len = 0;
SQLLEN  val_len = 0;

SQLLEN      c1 =1;
SQLLEN      c2 = SQL_DATA_AT_EXEC;
SQLLEN      c1_ind_ptr = 0;
SQLLEN      c2_ind_ptr = SQL_DATA_AT_EXEC;
PTR         c2_val_ptr;

/* 申请句柄 */ SQLAllocHandle(SQL_HANDLE_ENV, NULL, &henv);
SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3, SQL_IS_INTEGER);
SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);

sret = SQLConnect(hdbc, (SQLCHAR *)"DM", SQL_NTS, (SQLCHAR *)"SYSDBA", SQL_NTS, (SQLCHAR *)"******", SQL_NTS);
if (RC_NOTSUCCESSFUL(sret)) { printf("odbc: fail to connect to server!\n");
SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
SQLFreeHandle(SQL_HANDLE_ENV, henv);
exit(0);
} printf("odbc: connect to server success!\n");

/* 申请一个语句句柄 */ SQLAllocHandle(SQL_HANDLE_STMT, hdbc, &hstmt);

//清空表，初始化测试环境 sret = SQLExecDirect(hstmt, (SQLCHAR *)"drop table PRODUCTION.BIG_DATA", SQL_NTS);
sret = SQLExecDirect(hstmt, (SQLCHAR *)"create table PRODUCTION.BIG_DATA(c1 int, c2 blob)", SQL_NTS);

//读取文件，插入到 LOB 列 pfile = fopen(IN_FILE, "rb");
if (pfile == NULL) { printf("open %s fail\n", IN_FILE);
return SQL_ERROR;
}

sret = SQLPrepare(hstmt, (SQLCHAR *)"insert into PRODUCTION.BIG_DATA(c1,c2) values(?,?)", SQL_NTS);
sret = SQLBindParameter(hstmt, 1, SQL_PARAM_INPUT, SQL_C_SLONG,  SQL_INTEGER, sizeof(c1), 0, &c1, sizeof(c1), NULL);
sret = SQLBindParameter(hstmt, 2, SQL_PARAM_INPUT, SQL_C_BINARY,  SQL_VARBINARY, sizeof(c2), 0, (void *)1, sizeof(c2), &c2_ind_ptr);
sret = SQLExecute(hstmt);
if (sret == SQL_NEED_DATA) { if (SQLParamData(hstmt, &c2_val_ptr) == SQL_NEED_DATA) /* 绑定数据 */ { while (!feof(pfile)) { len = fread(tmpbuf, sizeof(char), CHARS, pfile);
if (len <= 0) { return SQL_ERROR;
} SQLPutData(hstmt, tmpbuf, len);
} } SQLParamData(hstmt, &c2_val_ptr); /* 绑定数据 */ }else if( sret == SQL_ERROR ) { SQLGetDiagRec(SQL_HANDLE_STMT, hstmt, 1, errstate, &errnative, errmsg, sizeof(errmsg), &errmsglen);
printf( "error:%s\n", errmsg );
}

printf("odbc: insesret data into col of lob success\n");
fclose(pfile);

//读取 LOB 列数据，写入文件 pfile = fopen((const char *)OUT_FILE, "wb");
if (pfile == NULL) { printf("open %s fail\n", OUT_FILE);
return SQL_ERROR;
}

sret = SQLExecDirect(hstmt, (SQLCHAR *)"select c1, c2 from PRODUCTION.BIG_DATA", SQL_NTS);
sret = SQLBindCol(hstmt, 1, SQL_C_SLONG, &c1, sizeof(c1), &c1_ind_ptr);
while(SQLFetch(hstmt) != SQL_NO_DATA) { while(1) { sret = SQLGetData(hstmt, 2, SQL_C_BINARY, tmpbuf, CHARS, &val_len);
if ((sret) == SQL_SUCCESS || (sret) == SQL_SUCCESS_WITH_INFO) { len = val_len > CHARS ? CHARS : val_len;
fwrite(tmpbuf, sizeof(char), len, pfile);
continue;
} break;
} }

fclose(pfile);
printf("odbc: get data from col of lob success\n");

SQLFreeHandle(SQL_HANDLE_STMT, hstmt);

SQLDisconnect(hdbc);
SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
SQLFreeHandle(SQL_HANDLE_ENV, henv);
return 0;
}

执行结果如下：

[dmdba@localhost odbctest]# ./odbc_lob odbc: connect to server success!
odbc: insesret data into col of lob success odbc: get data from col of lob success

五、常见问题

1. 动态链接库文件不存在

【问题描述】：odbcinstall.ini 配置文件编写错误，无法找到文件，报错信息如下图：

【问题解决】：修改 odbcinstall.ini 配置文件。

2. ODBC 连接失败

【问题描述】：报错信息如下图：

【问题解决】：odbc.ini 文件中服务名配置错误，导致无法找到对应服务名，修改 odbc.ini 文件中服务名即可。

六、参考

示例代码下载：请下载附件示例代码 (odbc_code.zip)。

以上文档内容参考过程中遇到任何问题，可到达梦技术社区提问交流。

上次更新：2026-09-26 上一篇下一篇

ODBC 接口

一、前言 二、开发环境准备
2.1 达梦数据库版本
2.2 达梦数据库安装
2.3 数据源创建
2.3.1 Windows 环境创建 ODBC 数据源
2.3.2 Linux 环境创建 ODBC 数据源
2.3.2.1 配置 DM 数据源
2.3.2.2 gcc 环境检查
2.3.2.3 项目目录结构
三、数据库连接
3.1 数据库连接示例
四、开发示例
4.1 基础操作示例
4.2 绑定变量示例
4.3 大字段操作示例
五、常见问题 六、参考

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
