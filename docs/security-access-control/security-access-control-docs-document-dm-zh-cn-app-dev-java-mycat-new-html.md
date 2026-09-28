# MyCat 框架 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/java-mycat_new.html

MyCat 框架 | 达梦技术文档

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

MyCat 框架

一、前言

MyCat 是一个开源的、面向企业应用开发的大数据库集群；一个支持事务、ACID 、可以替代 MySQL 的加强版数据库；一个新颖的数据库中间件产品。MyCat 天生与 MySQL 完美结合，支持前端作为 MySQL 通用代理，后端 JDBC 方式支持 Oracle 等数据库。此处我们将 MyCat 与 DM 数据库进行适配使用，利用 MyCat 对 DM 数据库进行分库分表。

二、数据库连接

2.1 准备工作

本次 window 环境下使用的 MyCat 版本为 Mycat-server-1.6.5-DEV-20161231120132-win.zip ，linux 环境下使用 MyCat 版本为 Mycat-server-1.6.5-DEV-20161231120132-linux.zip 。

MySQL 连接器版本为 mysql-connector-j-8.2.0.zip 。

MyCat 安装包官方下载地址为 http://www.mycat.org.cn/ 。

达梦数据库安装请参考数据库环境准备。

2.2 DM 数据库连接 MyCat 配置

达梦数据库端准备。

使用 MyCat 分库分表功能，先在数据库端建立两个实例 5236 ， 5237 ，并分别在实例中创建好用户，分别在不同用户对应的模式下创建表结构完全一致的表。语句如下所示：

/*在 5236 ， 5237 实例中分别以 SYSDBA/***** 用户分别登录达梦数据库。
在实例 5236 中创建用户 mydb1 ，此时会自动生成与用户名同名的模式，并在 mydb1 模式下创建表。*/ create user "mydb1" identified by "a123456789";
grant VTI to mydb1;
create table mydb1.PRODUCT_CATEGORY( ID INT PRIMARY KEY, NAME VARCHAR(50) NOT NULL) ;
/*在实例5237中创建用户mydb2 ，此时会自动生成与用户名同名的模式，并在mydb2模式下创建表。*/ create user "mydb2" identified by "a123456789";
grant VTI to mydb2;
create table mydb2.PRODUCT_CATEGORY( ID INT PRIMARY KEY, NAME VARCHAR(50) NOT NULL) ;

创建完成后如下图所示：

MyCat 配置：

（1）将 DM 数据库的 JDBC 驱动包（在’\DM 安装目录\drivers\jdbc\’中）复制到 MyCat 安装路径下 lib 文件夹内。

（2）配置 mycat/conf/server.xml 配置文件。

主要是配置 MyCat 服务启动后，对外提供数据库访问的用户信息，如下图所示：

****** PRODUCTION <!-- --> ****** PRODUCTION true

（3）配置 /mycat/conf/schema.xml 配置文件。

select user() select user()

启动 MyCat 中间件服务。

配置完成后，双击 /mycat/bin/startup_nowrap.bat 即可启动 MyCat 中间件服务。

使用 JDBC 连接 MyCat 中间件服务操作数据库。

因为 MyCat 完全适配 MySQL ，所以无论是什么数据库，都要使用 mysql-connect-java 的 JDBC 驱动包，可从 mysql-connector-java 包 下载指定 jar 包。

新建项目 JAVA_Mycat，并导入项目所需 jar 包，如下图所示：

注意

复制 jar 包到 lib 文件夹后，要选择所有 jar 包，鼠标右键，Build path-->Add to Build path 。

三、开发示例

3.1 基础操作示例

编写 mycat_Demo.java 文件。

package dameng.mycat;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
public class mycat_Demo { // 定义 DM JDBC 驱动串 static String jdbcString = "com.mysql.cj.jdbc.Driver";
// 定义 DM URL 连接串 static String urlString = "jdbc:mysql://localhost:8066/PRODUCTION";
// 定义连接用户名 static String userName = "root";
// 定义连接用户口令 static String password = "******";
// 定义连接对象 static Connection conn = null;
// 定义 SQL 语句执行对象 static Statement state = null;
// 定义结果集对象 static ResultSet rs = null;
public static void main(String[] args) { try { //1.加载 JDBC 驱动程序 System.out.println("Loading JDBC Driver...");
Class.forName(jdbcString);
//2.连接 DM 数据库 System.out.println("Connecting to DM Server...");
conn = DriverManager.getConnection(urlString, userName, password);
//3.通过连接对象创建 java.sql.Statement 对象 state = conn.createStatement();
//-------------------------------------------------------------------------------------------------- //基础操作:此处操作对应的数据库,为示例库中的 PRODUCTION 模式中的 PRODUCT_CATEGORY 表 //增加 //定义增加的 SQL--这里由于此表中的结构为主键,自增,只需插入 name 列的值 String sql_insert = "insert into PRODUCT_CATEGORY (id,name)values(1,'小说'),"+ "(2,'文学'),(3,'计算机'),(4,'英语'),(5,'管理'),(6,'少儿'),(7,'金融')";
//执行添加的 SQL 语句 state.executeUpdate(sql_insert);
//删除 //定义删除的 SQL 语句 String sql_delete = "delete from PRODUCT_CATEGORY where name = '厨艺'";
//执行删除的 SQL 语句 state.execute(sql_delete);
//修改 String sql_update = "update PRODUCT_CATEGORY set name = '国学' where name = '文学'";
state.executeUpdate(sql_update);
//查询表中数据 //定义查询 SQL String sql_selectAll = "select * from PRODUCT_CATEGORY";
//执行查询的 SQL 语句 rs = state.executeQuery(sql_selectAll);
displayResultSet(rs);
//--------------------------------------------------------------------------------------------------- } catch (ClassNotFoundException e) { e.printStackTrace();
} catch (SQLException e) { e.printStackTrace();
} finally { try { //关闭资源 rs.close();
state.close();
conn.close();
} catch (SQLException e) { e.printStackTrace();
} } } //显示结果集 public static void displayResultSet(ResultSet rs) throws SQLException{ while (rs.next()) { int i=1;
Object id = rs.getObject(i++);
Object name = rs.getObject(i++);
System.out.println(id+"  "+name);
} } }

运行结果截图。

运行前数据库表数据截图如下所示：

运行后控制台截图如下所示：

运行后数据库表截图，可以看到数据分别插入两张表中，如下图所示：

3.2 基础绑定参数示例

编写 mycat_prepareStatement.java 类。

package dameng.mycat;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
public class mycat_prepareStatement{ // 定义 DM JDBC 驱动串 static String jdbcString = "com.mysql.cj.jdbc.Driver";
// 定义 DM URL 连接串 static String urlString = "jdbc:mysql://localhost:8066/PRODUCTION";
// 定义连接用户名 static String userName = "root";
// 定义连接用户口令 static String password = "******";
// 定义连接对象 static Connection conn = null;
// 定义 SQL 语句执行对象 static PreparedStatement pstate = null;
public static void main(String[] args) { try { //1.加载 JDBC 驱动程序 System.out.println("Loading JDBC Driver...");
Class.forName(jdbcString);
//2.连接 DM 数据库 System.out.println("Connecting to DM Server...");
conn = DriverManager.getConnection(urlString, userName, password);
//---------------------------------------------------------------------------- //绑定操作：此处操作对应的数据库，为示例库中的 PRODUCTION 模式中的 //PRODUCT_CATEGORY 表 //根据指定 id 修改 PRODUCT_CATEGORY 表中的 name 的值 //这里 name 和 id 不确认用?代替 String sql_updateNameById = "update PRODUCT_CATEGORY "+ "set name = ? where ID  = ? ";
//3.通过连接对象和修改语句的模板，创建 java.sql.PreparedStatement 对象 pstate = conn.prepareStatement(sql_updateNameById);
//4.绑定?对应的参数：理论上有多少个?就要绑定多少个值;
//把 id 为 3 所对应的 name 值修改为 "魔幻" pstate.setString(1, "魔幻");
pstate.setInt(2, 3);
//5. 执行 SQL 语句 pstate.executeUpdate();
//---------------------------------------------------------------------------- } catch (ClassNotFoundException e) { e.printStackTrace();
} catch (SQLException e) { e.printStackTrace();
} finally { try { pstate.close();
conn.close();
} catch (SQLException e) { e.printStackTrace();
} } } }

运行结果截图。

运行后数据库表数据如下图所示：

四、 常见问题

4.1 MyCat 启动报错 1

【问题描述】：报错信息如下图：

【解决方法】：该报错是没有修改 rule.xml 文件导致的，修改 rule.xml 中的内对应的数字即可，数字为 schema.xml 文件中配置的 dataNode 数量。

4.2 MyCat 启动报错 2

【问题描述】：报错信息如下图：

【解决方法】：编码格式不一致，删除 xml 文件中文内容，或者转换为操作系统适合的编码。

4.3 MyCat 启动报错 3

【问题描述】：报错信息如下图：

【解决方法】：

Linux 环境下：

需要在 /mycat/bin/startup_nowrap.sh 调大 MaxDirectMemorySize 大小。

window 环境下：

需要在 /mycat/bin/startup_nowrap.bat 文件调大 MaxDirectMemorySize 大小，下图所示此参数已从 1G 调大为 2G。

4.4 代码运行报错 1

【问题描述】：报错信息如下图：

详细报错信息：

Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary .

java.sql.SQLNonTransientConnectionException: CLIENT_PLUGIN_AUTH is required .

【解决方法】：com.mysql.jdbc.Driver 改为 com.mysql.cj.jdbc.Driver  。

4.5 代码运行报错 2

【问题描述】：报错信息如下图：

【解决方法】：

此现象是 mysql  版本和所连接的 mysql 版本不一致导致的。

如果 mysql-connector-java 用的 6.0 以上的，数据库驱动是：com.mysql.cj.jdbc.Driver 。

如果 mysql-connector-java 用的 6.0 以下的，数据库驱动是：com.mysql.jdbc.Driver 。

4.6 代码运行时报无效的模式名

【问题描述】：报错截图如下：

【问题分析】：代码里面有模式名时，运行时 sql 时会直接将带模式名的 sql 传入数据库。

在 schema.xml 文件中，checkSQLschema 参数说明如下：

当值设置为 true 时，会把模式名删除后执行 sql，例如上图中的 SQL 语句会变为如下 SQL：

insert into PRODUCT_CATEGORY (id,name)values(1,'小说'),"+ "(2,'文学'),(3,'计算机'),(4,'英语'),(5,'管理'),(6,'少儿'),(7,'金融');

如果语句所带的模式名不是通过 schema 标签指定 name，这种情况下例如有 SQL：select * from db1.travelrecord; 那么 MyCat 并不会删除 db1 这个模式名，会直接传到 DM 连接用户下执行，这种情况会报错无效的模式名，所以在写 SQL 语句时建议不带模式名。

当值设置为 false 时，不会删除模式名，会按照原 sql 执行。

【问题处理】：如果想运行 sql 时删除模式名，需要在 schema.xml 文件中指定 name 为当前 sql 语句中的模式名，并且 checkSQLschema 为 true 。

如果想运行 sql 时带有模式名，则在 schema.xml 文件中不指定 name 或配置 checkSQLschema 为 false 。

4.7 其他问题

其他更多 MyCat 相关的常见问题请参考：

https://eco.dameng.com/document/dm/zh-cn/faq/faq-java.html 。

五、参考

1．示例代码下载：参考下面文件 JAVA_MYCAT.zip 。

2．以上文档内容参考过程中遇到任何问题，可到达梦技术社区提问交流。

上次更新：2026-09-26 上一篇下一篇

MyCat 框架

一、前言 二、数据库连接
2.1 准备工作
2.2 DM 数据库连接 MyCat 配置
三、开发示例
3.1 基础操作示例
3.2 基础绑定参数示例
四、 常见问题
4.1 MyCat 启动报错 1
4.2 MyCat 启动报错 2
4.3 MyCat 启动报错 3
4.4 代码运行报错 1
4.5 代码运行报错 2
4.6 代码运行时报无效的模式名
4.7 其他问题
五、参考

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
