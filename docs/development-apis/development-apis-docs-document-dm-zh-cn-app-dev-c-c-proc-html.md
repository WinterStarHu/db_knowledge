# Pro*C 接口 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/c_c++_proc.html

Pro*C 接口 | 达梦技术文档

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

Pro*C 接口

一、前言

SQL 语言作为结构化的查询语言，可以完成对数据库的定义、查询、更新、控制、维护、恢复、安全管理等一系列操作，充分体现了关系数据库的特征。但 SQL 语言是非过程性语言，本身没有过程性结构，大多数语句都是独立执行，与上下文无关，而绝大多数完整的应用都是过程性的，需要根据不同的条件来执行不同的任务。因此，单纯用 SQL 语言很难实现这样的应用，DM 数据库提供了 SQL 的两种使用方式：

交互方式

嵌入方式

嵌入方式是将 SQL 语言嵌入到高级语言中，这样一来，既发挥了高级语言数据类型丰富、处理方便灵活的优势，又以 SQL 语言弥补了高级语言难以描述数据库操作的不足，从而为用户提供了建立大型管理信息系统和处理复杂事务所需要的工作环境。

在这种方式下使用的 SQL 语言称为嵌入式 SQL，而嵌入 SQL 的高级语言称为主语言或宿主语言。DM 数据库允许 C 作为嵌入方式的主语言。在 DM 系统中，我们将嵌有 SQL 语句的 C 语言程序称为 PRO*C 程序。

二、开发环境准备

2.1 达梦数据库版本

名称 版本

DM 数据库 DM 8.0 及以上版本

2.2 达梦数据库安装

请参考数据库环境准备。

2.3 gcc 环境检查

gcc --version

执行结果如下：

[root@localhost proctest]# gcc --version gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-36) Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

2.4 项目目录结构

proctest ├── proc_bind.c             // 绑定变量示例 ├── proc_conn.c             // 数据库连接示例 ├── proc_dml.c              // 基本操作示例 ├── file                   // 大字段操作示例中导入和导出文件目录
|   ├── DM8_SQL.pdf        // 大字段操作示例中导入文件
├── makfile                // makefile 编译脚本

makefile 脚本如下：

root@RS1821 proctest]# cat makefile CC=gcc

includepath=$(DM_HOME)/include libpath=$(DM_HOME)/bin vpath=./

CFLAGS=-I$(includepath) -DDM64 -Wall LINKFLAGS=-L$(libpath) -ldmdpc -Wall -Wl,-rpath $(libpath)

%.c:%.pc $(DM_HOME)/bin/dpc_new file=$<

%.o:%.c $(CC) -g -c $(CFLAGS) $< -o $@

object_file1=proc_conn.o object_file2=proc_dml.o object_file3=proc_bind.o

object_files=proc_conn.o proc_dml.o proc_bind.o

final_objects=proc_conn proc_dml proc_bind

all : $(final_objects)

.PHONY : all clean rebuild

proc_conn : $(object_file1) $(CC) -o $@ $(object_file1) -g $(LINKFLAGS) @echo make ok.

proc_dml : $(object_file2) $(CC) -o $@ $(object_file2) -g $(LINKFLAGS) @echo make ok.

proc_bind : $(object_file3) $(CC) -o $@ $(object_file3) -g $(LINKFLAGS) @echo make ok.

clean :
@rm -rf $(object_files) @rm -rf $(final_objects)

rebuild : clean all

三、数据库连接

3.1 数据库连接示例

PROC*C 接口登录登出示例程序 proc_conn.c 如下：

#include
#include
#include
#include

EXEC SQL INCLUDE SQLCA;
EXEC SQL BEGIN DECLARE SECTION;

char username[10]="SYSDBA";
char password[10]="*****";
char dbserver[20]="localhost:51236";

EXEC SQL END DECLARE SECTION;

int main() { EXEC SQL LOGIN :username PASSWORD :password SERVER :dbserver;
if ( sqlca.sqlcode!=0 ) { printf( "login fail![%d, %s]\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc ) ;
exit(-1);
}

printf( "proc：conn to server success\n" );

EXEC SQL LOGOUT;
return 0;
}

执行结果如下：

[root@RS1821 proctest]# ./proc_conn proc: conn to server success [root@RS1821 proctest]#

四、开发示例

4.1 基础操作示例

PROC*C 接口增、删、改、查四个基本操作，示例程序 proc_dml.c 如下：

#include
#include
#include
#include

EXEC SQL INCLUDE SQLCA;
EXEC SQL BEGIN DECLARE SECTION;

char username[10]="SYSDBA";
char password[10]="*****";
char dbserver[20]="192.168.104.21:51236";

int c1 = 0;
char c2[51] = {0};

EXEC SQL END DECLARE SECTION;

int main() { EXEC SQL LOGIN :username PASSWORD :password SERVER :dbserver;
if ( sqlca.sqlcode!=0 ) { printf( "login fail![%d, %s]\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc ) ;
exit(-1);
} printf( "proc: conn to server success\n" ) ;

//清空表，初始化测试环境 EXEC SQL DELETE FROM PRODUCTION.PRODUCT_CATEGORY;
EXEC SQL COMMIT;

//插入数据 EXEC SQL INSERT INTO PRODUCTION.PRODUCT_CATEGORY(NAME) VALUES('语文'), ('数学'), ('英语'), ('体育');
EXEC SQL COMMIT;

//删除数据 EXEC SQL DELETE PRODUCTION.PRODUCT_CATEGORY WHERE NAME='数学';
EXEC SQL COMMIT;

//更新数据 EXEC SQL UPDATE PRODUCTION.PRODUCT_CATEGORY SET NAME='英语-新课标'  WHERE NAME='英语';
EXEC SQL COMMIT;

//查询数据 EXEC SQL DECLARE t_cur CURSOR FOR SELECT * FROM PRODUCTION.PRODUCT_CATEGORY;
EXEC SQL OPEN t_cur;

EXEC SQL WHENEVER NOT FOUND GOTO NEXTONE;
for(;;) { EXEC SQL FETCH t_cur INTO :c1,:c2;
printf("%d\t%s\n", c1, c2);
}

NEXTONE:
EXEC SQL WHENEVER NOT FOUND CONTINUE;
EXEC SQL CLOSE t_cur ;

EXEC SQL LOGOUT;
return 0;
}

执行结果如下：

[root@RS1821 proctest]# ./proc_dml proc: conn to server success 34 语文 36 英语-新课标 37 体育

4.2 绑定变量示例

PROC*C 接口绑定变量示例程序 proc_bind.c 如下：

#include
#include
#include
#include

EXEC SQL INCLUDE SQLCA;
EXEC SQL BEGIN DECLARE SECTION;

char username[10]="SYSDBA";
char password[10]="*****";
char dbserver[20]="192.168.104.21:51236";

int c1_out = 0;
char c2_in[51] = "物理";
char c2_out[51] = {0};
char sql[128] = {0};
EXEC SQL END DECLARE SECTION;

int main() { EXEC SQL LOGIN :username PASSWORD :password SERVER :dbserver;
if ( sqlca.sqlcode!=0 ) { printf( "login fail![%d, %s]\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc ) ;
exit(-1);
} printf( "proc: conn to server success\n" ) ;

//清空表，初始化测试环境 EXEC SQL DELETE FROM PRODUCTION.PRODUCT_CATEGORY;
EXEC SQL COMMIT;

//绑定参数方式插入数据 strcpy((char *)sql,"INSERT INTO PRODUCTION.PRODUCT_CATEGORY(NAME) VALUES(?)");
EXEC SQL PREPARE stmt FROM :sql;
EXEC SQL EXECUTE stmt USING :c2_in;
EXEC SQL COMMIT;

//查询数据 EXEC SQL DECLARE t_cur CURSOR FOR SELECT * FROM PRODUCTION.PRODUCT_CATEGORY;
EXEC SQL OPEN t_cur;

EXEC SQL WHENEVER NOT FOUND GOTO NEXTONE;
for(;;) { EXEC SQL FETCH t_cur INTO :c1_out,:c2_out;
printf("%d\t%s\n", c1_out, c2_out);
}

NEXTONE:
EXEC SQL WHENEVER NOT FOUND CONTINUE;
EXEC SQL CLOSE t_cur ;

EXEC SQL LOGOUT;
return 0;
}

执行结果如下：

[root@RS1821 proctest]# ./proc_bind proc: conn to server success 38 物理

五、常见问题

预编译的时候加入 MODE=ORACLE 启用兼容模式，MACRO=Y 允许宏定义以及 INCLUDE_SQLCA=Y 启用 sqlca 通信区，使用 c++ 加入 TYPE=CPP，生成目标文件使用 -DDM64。

oracle 中编译 proc 常用命令如下：

proc DYNAMIC=ANSI threads=yes code=cpp CPP_SUFFIX=cpp iname=test.pc
##说明：
##DYNAMIC 指定动态 sql 语意、THREADS 指定机构多线程应用、CPP_SUFFIX 覆盖缺省的 C++ 文件名后缀、INAME 输入文件名，这些都是预编译配置选项；

g++ -c -g -pthread -D_XOPEN_SOURCE_EXTENDED -D_GLIBCXX_USE_CXX11_ABI=0 -I /usr/include -I $ORACLE_HOME/precomp/public -I /usr/lib/gcc/i386-redhat-linux/4.1.1/include -I./ test.cpp
##说明：
##-c 只激活预处理，编译，和汇编，也就是它只把程序做成 obj 文件、-g 在编译的时候，产生调试信息、-pthread 用于在编译时增加多线程的支持、-I指定头文件路径；

g++ -g -lc -pthread -D_XOPEN_SOURCE_EXTENDED -D_GLIBCXX_USE_CXX11_ABI=0 -o test test.o -L $ORACLE_HOME/lib -lclntsh -lpthread
##说明：
##-lc 链接 libc 库文件、GCC5.1 引入了 ` -D_GLIBCXX_USE_CXX11_ABI` 来控制编译器到底链接哪一个 `libstdc++.so（c++03/c++11）`，`-D_GLIBCXX_USE_CXX11_ABI=0` 链接旧版库，`-D_GLIBCXX_USE_CXX11_ABI=1` 链接新版库、-o 指定目标文件名称，默认的时候，gcc 编译出来的文件是 a.out、-L 指定连接的动态库或者静态库路径、-lclntsh 链接 libclntsh.so。

六、参考

示例代码下载：proc_code.zip。

以上文档内容参考过程中遇到任何问题，可到 达梦技术社区 提问交流。

上次更新：2026-09-26 上一篇下一篇

Pro*C 接口

一、前言 二、开发环境准备
2.1 达梦数据库版本
2.2 达梦数据库安装
2.3 gcc 环境检查
2.4 项目目录结构
三、数据库连接
3.1 数据库连接示例
四、开发示例
4.1 基础操作示例
4.2 绑定变量示例
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
