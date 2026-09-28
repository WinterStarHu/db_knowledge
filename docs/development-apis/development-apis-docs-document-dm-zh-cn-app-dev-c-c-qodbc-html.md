# QODBC 编译 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/c_c++_qodbc.html

QODBC 编译 | 达梦技术文档

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

QODBC 编译

一、前言

本章节详细介绍 QT QODBC 数据库编程连接，QT 为数据库编程提供了一个类似 JDBC 的统一操作模型，它的底层是具体数据库或数据库接口的插件，由它们负责完成真正的数据库操作。可进入达梦云适配中心下载试用下载 QT 接口源码。

QT 自带 QODBC Driver，在 Windows 平台上通过系统提供的 ODBC Driver 可以访问支持 ODBC 的数据库，如 Ms Access、SQL Server 等（ Windows XP 自带 Access 和 SQL Server 的 ODBC Driver）。开发者通过 QODBC 接口连接 DM 数据库。

二、开发环境准备

2.1 达梦数据库版本

名称 版本

DM 数据库 DM 8.0 及以上版本

QT
5.12.1

2.2 达梦数据库安装

请参考数据库环境准备。

2.3 QT 开发环境搭建

下载链接：https://download.qt.io/archive/qt/

2.4 注册 ODBC 数据源

请参考 通过 ODBC 连接数据库 章节。

2.5 编译 libqsqlodbc.so

首先进入 qt 源码目录中修改 qsqldriverbase.pri 文件，将 include 部分修改为下图所示内容。

修改 qt 源码目录中的 odbc.pro 文件，注释 QMAKE_USE += odbc 。

在/data/Qt5.12.1/5.12.1/gcc_64/bin 下执行。INCLUDEPATH 和 LIBS 的查找方式如下：

./qmake "INCLUDEPATH+=/usr/local/include" "LIBS+=-L/usr/local/lib -lodbc" /data/Qt5.12.1/5.12.1/Src/qtbase/src/plugins/sqldrivers/odbc/odbc.pro

会在该目录下生成 Makefile 文件，执行 make 即可生成 libqsqlodbc.so，将此动态库复制到 qt 目录下的 sqldrivers 目录下即可正常使用 qodbc 接口对达梦进行操作。

三、数据库连接

3.1 数据库连接示例

QODBC 通过 ODBC 接口登录登出示例程序 qt_conn.c 如下：

#include
#include
#include
#include

int main(int argc, char *argv[]) { QCoreApplication a(argc, argv);

QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
db.setHostName("192.168.104.21");
db.setPort(51236);
db.setDatabaseName("DM8");
db.setUserName("SYSDBA");
db.setPassword("*****");
if (db.open()) qDebug() << "connect ok!";
else { qDebug() << "connect fail! " << db.lastError().text().toLatin1();
}

return a.exec();
}

2、运行示例截图：

四、开发示例

4.1 基础操作示例

QODBC 通过 ODBC 接口增、删、改、查四个基本操作，示例程序 qt_dml.c 如下：

#include
#include
#include
#include

int main(int argc, char *argv[]) { QCoreApplication a(argc, argv);

QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
db.setHostName("192.168.104.21");
db.setPort(51236);
db.setDatabaseName("DM8");
db.setUserName("SYSDBA");
db.setPassword("*****");
if (db.open()) qDebug() << "connect ok!";
else { qDebug() << "connect fail! " << db.lastError().text().toLatin1();
}

QSqlQuery query;

//清空表，初始化测试环境 QString strsql = "delete from PRODUCTION.PRODUCT_CATEGORY";
query.exec(strsql);

//插入数据 strsql = "insert into PRODUCTION.PRODUCT_CATEGORY(NAME) values('语文'), ('数学'), ('英语'), ('体育')";
if (query.exec(strsql)) { qDebug() << "insert ok!";
} else { qDebug() << "insert fail! " << query.lastError().text();
getchar();
exit(-1);
}

//删除数据 strsql = "delete from PRODUCTION.PRODUCT_CATEGORY where name='数学'";
if (query.exec(strsql)) { qDebug() << "delete ok!";
} else { qDebug() << "delete fail! " << query.lastError().text();
getchar();
exit(-1);
}

//更新数据 strsql = "update PRODUCTION.PRODUCT_CATEGORY set name = '英语—新课标' where name='英语';";
if (query.exec(strsql)) { qDebug() << "update ok!";
} else { qDebug() << "update fail! " << query.lastError().text();
getchar();
exit(-1);
}

//查询数据 strsql = "select name from PRODUCTION.PRODUCT_CATEGORY";
if (query.exec(strsql)) { qDebug() << "select ok!";
} else { qDebug() << "select fail! " << query.lastError().text();
getchar();
exit(-1);
} while (query.next()) { qDebug() << query.value(0).toString().toStdString().c_str();
} query.clear();

return a.exec();
}

运行示例截图：

4.2 绑定变量示例

QODBC 通过 ODBC 接口绑定变量示例程序 qt_bind.c 如下：

#include
#include
#include
#include

int main(int argc, char *argv[]) { QCoreApplication a(argc, argv);

QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
db.setHostName("192.168.104.21");
db.setPort(51236);
db.setDatabaseName("DM8");
db.setUserName("SYSDBA");
db.setPassword("*****");
if (db.open()) qDebug() << "connect ok!";
else { qDebug() << "connect fail! " << db.lastError().text().toLatin1();
}

QSqlQuery query;

//清空表，初始化测试环境 QString strsql = "delete from PRODUCTION.PRODUCT_CATEGORY";
query.exec(strsql);

//绑定参数方式插入数据 strsql = "insert into PRODUCTION.PRODUCT_CATEGORY(name) values(?)";
query.prepare(strsql);
query.bindValue(0, "物理");
if (query.exec()) { qDebug() << "insert ok!";
} else { qDebug() << "insert fail! " << query.lastError().text();
getchar();
exit(-1);
}

//查询数据 strsql = "select name from PRODUCTION.PRODUCT_CATEGORY";
if (query.exec(strsql)) { qDebug() << "select ok!";
} else { qDebug() << "select fail! " << query.lastError().text();
getchar();
exit(-1);
} while (query.next()) { qDebug() << query.value(0).toString().toStdString().c_str();
} query.clear();

return a.exec();
}

运行示例截图：

4.3 大字段操作示例

QODBC 通过 ODBC 接口大字段操作包括大字段的插入，查询等。示例程序 qt_lob.c 如下：

#include
#include
#include
#include

int main(int argc, char *argv[]) { QCoreApplication a(argc, argv);

QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
db.setHostName("192.168.104.21");
db.setPort(51236);
db.setDatabaseName("DM8");
db.setUserName("SYSDBA");
db.setPassword("*****");
if (db.open()) qDebug() << "connect ok!";
else { qDebug() << "connect fail! " << db.lastError().text().toLatin1();
}

QSqlQuery query;

//清理测试环境 QString strsql = "drop table if exists PRODUCTION.BIG_DATA";
query.exec(strsql);
strsql = "create table PRODUCTION.BIG_DATA(c1 int, c2 blob)";
query.exec(strsql);

// 读取文件数据，写入 lob 列 //选择要写入的文件 QString f = "../qt_lob/file/DM8_SQL.pdf";

//转换为字节数组 QByteArray mapData;
QFile file(f);
file.open(QIODevice::ReadOnly);
mapData = file.readAll();
file.close();

//插入数据 query.prepare("INSERT INTO PRODUCTION.BIG_DATA values(?, ?)");
query.bindValue(0, 1);
query.bindValue(1, mapData);
if (!query.exec()) { qDebug() << query.lastError();
} else { qDebug() << "insert OK!";
}

//读取 lob 列数据，写入到文件中 QSqlQuery readquery;

QByteArray databa;
if (readquery.exec("select c2 from PRODUCTION.BIG_DATA")) { QSqlRecord myrecord = readquery.record();

if (readquery.next()) { databa = readquery.value(myrecord.indexOf("C2")).toByteArray();
} }

QFile mybfile("../qt_lob/file/DM81_SQL.pdf");
mybfile.open(QIODevice::WriteOnly);
mybfile.write(databa);
mybfile.close();
qDebug() << "select OK!";

return a.exec();
}

运行示例截图：

五、常见问题

首先尽可能使用源码安装的完整版 qt，否则会缺失基础的 libqsqlodbc.so，如果没有安装源码的情况下使用系统自带的 qt，要注意直接下载的源码 src 版本也要和现有 qt 版本一致，否则会出现头文件缺失等问题，该问题是目录结构不匹配导致；

-isystem /usr/include/aarch64-linux-gnu/qt5/QtSql -isystem /usr/include/aarch64-liunx-gnu/qt5/QtCore -I.moc/debug ql_dm.cpp:59:10: fatal error: qsqldriver_p.h； 没有那个文件或目录
#include

保证 odbc 服务名能够正常进行 isql 测试，否则根据 isql -v dsn 来判断具体原因，大部分都是因为环境变量配置错误导致 libdodbc.so 动态库依赖缺失，arm 平台编译安装 unixodbc 注意加上--build=arm-linux；

避免系统中安装多版本 qt，会导致环境混乱，libqsqlodbc.so 或者 libqsqldm.so 动态库放入 qt 的 sqldrivers 目录中还是无法识别为可用驱动，driver not loaded,可通过临时 export QT_DEBUG_PLUGINS=1 该窗口下运行程序会打印出具体 qt 的插件 debug 信息，从中看是否从正确的目录搜索到了对应动态库，另外对应动态库是否被识别为 plugins，否则需要去考虑 qt 环境方面问题；

pro 文件中需要加上 qt+=sql 否则无法识别驱动；

尽量使用 root 用户打开 qtcreator，避免其他用户环境变量问题导致无法识别一些依赖组件；

qt 中 kit 套件、数据库、odbc 位数需要保持一致。

六、参考

示例代码下载：qt_qodbc_code.zip。

以上文档内容参考过程中遇到任何问题，可到 达梦技术社区 提问交流。

上次更新：2026-09-26 上一篇下一篇

QODBC 编译

一、前言 二、开发环境准备
2.1 达梦数据库版本
2.2 达梦数据库安装
2.3 QT 开发环境搭建
2.4 注册 ODBC 数据源
2.5 编译 libqsqlodbc.so
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
