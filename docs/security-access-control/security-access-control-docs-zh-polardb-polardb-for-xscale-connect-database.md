# 如何通过MySQL命令行连接到PolarDB-X数据库-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/connect-database

如何通过MySQL命令行连接到PolarDB-X数据库-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

AI和智能体

快速入门

产品计费

动态与公告

用户指南

开发指南

SQL调优指南

技术白皮书

性能白皮书

最佳实践

分布式常见问题

安全合规

API参考

错误码

术语表

相关协议

PolarDB-X 1.0（DRDS）

PolarDB分布式轻量版

首页

云原生数据库 PolarDB

云原生数据库PolarDB分布式版

快速入门

连接数据库

连接数据库

更新时间：

复制 MD 格式

产品详情 我的收藏

PolarDB-X支持通过数据管理DMS、MySQL命令行、第三方客户端以及符合MySQL官方交互协议的第三方程序代码进行连接。

准备工作 在连接PolarDB-X数据库前，您需要进行以下操作：

获取数据库连接地址与端口

您可以前往PolarDB分布式版控制台，在实例列表中单击目标实例ID进入实例基本信息页面。在连接信息区域获取数据库连接地址和端口。

说明

请根据您的访问环境选择内网或外网。

如果您是使用ECS访问PolarDB-X，并且ECS与PolarDB-X位于同一VPC内，请选择私网，可以发挥PolarDB-X的最佳性能。

如果您是在本地环境中访问PolarDB-X，请选择公网。公网地址单击右侧申请外网地址即可。公网即因特网，通过公网访问将无法实现PolarDB-X实例的最佳性能。

暂不支持使用虚拟主机和轻量服务器使用私网地址连接PolarDB-X实例。

创建数据库账号。

设置实例白名单

您可以前往PolarDB分布式版控制台，在实例列表中单击目标实例ID进入实例详情页。在配置与管理 > 安全管理中配置IP白名单或新增白名单分组。具体操作，请参见设置白名单。

说明

如果您是使用ECS访问PolarDB-X，并且ECS与PolarDB-X位于同一VPC内，您可以选择将ECS的内网IP地址添加至新的IP白名单分组。

如果您是使用ECS访问PolarDB-X，但ECS与PolarDB-X不在同一VPC内，您可以选择将ECS的公网IP地址添加至新的IP白名单分组。

如果您是在本地环境中访问PolarDB-X，请将您本地环境的公网IP地址添加至新的IP白名单分组中。
本地环境的公网IP地址获取方法如下：

Linux操作系统：打开终端，输入curl ifconfig.me命令后回车。

Windows操作系统：打开命令提示符，输入curl ip.me命令后回车。

macOS操作系统：打开终端，输入curl ifconfig.me命令后回车。
若您的本地网络环境存在代理等情况，以上方式获取的IP可能并非您的真实公网IP。您可以将IP段0.0.0.0/0添加至PolarDB-X实例白名单中，成功连接实例后，执行SHOW PROCESSLIST;命令获取真实公网IP地址，并将其加入到实例白名单中。随后删除白名单中的IP段0.0.0.0/0。

IP段0.0.0.0/0表示允许所有的访问源访问实例，将其设置在实例白名单中存在极大的风险，如非必要，切勿将其添加至白名单。
连接数据库 连接数据库实例的方法有很多种，您可以根据实际业务需求来选择适合的连接方式。以下列举了部分连接数据库实例的示例： 使用DMS连接到数据库 DMS是阿里云提供的图形化的数据管理工具，它是一种集数据管理、结构管理、用户授权、安全审计、数据趋势、数据追踪、BI图表、性能与优化和服务器管理于一体的数据管理服务。您无需借助其他工具，即可直接在DMS上管理您的PolarDB-X实例。

前往PolarDB分布式版控制台，在实例列表中单击目标实例ID进入实例详情页。在页面右上角单击登录数据库。

在弹出的对话框中，输入PolarDB-X实例中创建的数据库账号和数据库密码，单击登录。

说明

首次通过DMS登录时，管控模式默认为自由操作。登录成功后，您还可以通过编辑实例功能来修改管控模式。更多信息，请参见编辑实例信息和管控模式。

配置完登录参数后，您可以单击左下角测试连接。如果测试连接失败，请按照报错提示检查录入的实例信息，如账号或密码是否正确。

系统会自动尝试往云数据库的白名单中添加DMS的服务器访问地址，若自动添加失败请手动添加。

登录后，您可以在左侧导航栏的已登录实例中查看到所登录的PolarDB-X实例，并进行相应的管理操作。

使用客户端连接数据库 PolarDB-X支持通过如下第三方客户端进行连接，您可以去对应的官方网站下载客户端。

MySQL Workbench（推荐）

SQLyog

Sequel Pro

Navicat for MySQL

说明 第三方GUI客户端可执行基础的数据库操作，包括数据的增删改查和DDL操作，对于工具高级特性，PolarDB-X可能并不支持。
以下以MySQL Workbench 8.0.29版本为例，其他客户端的操作类似。

安装MySQL Workbench。官方下载地址请参见MySQL Workbench下载页面。

打开MySQL Workbench，选择Database > Connect to Database。

输入连接信息，单击OK。

参数 说明 示例

Hostname 数据库连接地址。
pxc-xxx.polarx.rds.aliyuncs.com

Port 数据库连接地址的端口号，与数据库连接地址相对应。

说明 默认端口为3306。
3306

Username 数据库账号。
polardb_x_user

Password 数据库账号密码。
Pass***233 使用MySQL命令行连接数据库 如果您的服务器安装了MySQL客户端，可以通过命令行连接PolarDB-X实例。
语法： mysql -h -P -u -p -D 示例： mysql -hpxc-xxx.polarx.rds.aliyuncs.com -P3306 -upolardb_mysql_user -pPass***233 -Dtest_db

参数 说明 示例

-h 数据库连接地址。
pxc-xxx.polarx.rds.aliyuncs.com

-P 数据库连接地址的端口号，与数据库连接地址相对应。

说明

默认端口为3306。

如果端口号为默认端口，该参数可以不填写。
3306

-u 数据库账号。
polardb_x_user

-p 数据库账号密码。

说明 该参数为必填参数。

如果不填写该参数，在Enter password后会重新要求输入密码。

如果填写该参数，-p与数据库密码之间不能有空格。
Pass***233

-D 需要登录的数据库名称。

说明 该参数非必填参数。
test_db 使用应用程序连接数据库 连接PolarDB-X实例的方式与连接其他MySQL数据库的方式一样，仅需将数据库连接地址、端口、账号及密码等进行替换即可。以下为您列举部分开发语言如何通过应用程序访问PolarDB数据库： Java 此处以Maven项目为例，使用MySQL JDBC驱动连接PolarDB-X实例。

首先，您需要在pom.xml文件中添加MySQL JDBC驱动的依赖，代码示例： mysql mysql-connector-java
8.0.27

连接实例。请将参数、端口号、、、、及进行替换。
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseConnection { public DatabaseConnection() { }

public static void main(String[] args) { // PolarDB实例连接地址、端口、需要连接的数据库名 String url = "jdbc:mysql://:3306/?useSSL=false&serverTimezone=UTC";
// 数据库账号 String user = "";
// 数据库账号的密码 String password = "";

try { Class.forName("com.mysql.cj.jdbc.Driver");
Connection conn = DriverManager.getConnection(url, user, password);
Statement stmt = conn.createStatement();
// 需要检索的数据表名 ResultSet rs = stmt.executeQuery("SELECT * FROM ``");

while(rs.next()) { // 需要检索的数据表的列名 System.out.println(rs.getString(""));
}

rs.close();
stmt.close();
conn.close();
} catch (Exception var7) { var7.printStackTrace();
}

} } Python 此处以Python3为例，使用PyMySQL库连接PolarDB-X实例。

首先，您需要安装PyMySQL库。如果您还没有安装，可以通过以下命令进行安装： pip3 install PyMySQL

连接实例。请将参数、端口号、、、及进行替换。
import pymysql

# 数据库连接参数
host = ''  # PolarDB实例连接地址 port = 3306  # 默认端口3306 user = ''  # 数据库账号 password = ''  # 数据库账号的密码 database = ''  # 需要连接的数据库名

try:
# 创建数据库连接
connection = pymysql.connect( host=host, port=port, user=user, passwd=password, db=database )

# 获取操作游标
with connection.cursor() as cursor:
# 执行 SQL 查询
sql = "SELECT * FROM ``"  # 需要检索的数据表名 cursor.execute(sql)

# 获取查询结果
results = cursor.fetchall() for row in results:
print(row)

finally:
# 关闭数据库连接
if 'connection' in locals() and connection.open:
connection.close()

Go 此处以go1.23.0为例，使用database/sql包和go-sql-driver/mysql驱动来连接PolarDB-X实例。

首先，您需要安装go-sql-driver/mysql驱动。您可以通过以下命令进行安装： go get -u github.com/go-sql-driver/mysql

连接实例。请将参数、端口号、、、及进行替换。
package main

import (
"database/sql" "fmt" "log" _ "github.com/go-sql-driver/mysql" )

func main() { // 数据库连接参数 dbHost := ""       // PolarDB实例连接地址 dbPort := "3306"         // 默认端口3306 dbUser := ""       // 数据库账号 dbPass := ""   // 数据库账号的密码 dbName := ""   // 需要连接的数据库名

// 构建 DSN (Data Source Name) dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local", dbUser, dbPass, dbHost, dbPort, dbName)

// 打开数据库连接 db, err := sql.Open("mysql", dsn) if err != nil { log.Fatalf("Failed to connect to database: %v", err) } defer db.Close()

// 测试连接 err = db.Ping() if err != nil { log.Fatalf("Failed to ping database: %v", err) }

// 创建一个操作游标 var result string err = db.QueryRow("SELECT VERSION()").Scan(&result) if err != nil { log.Fatalf("Failed to execute query: %v", err) }

// 输出数据库版本 fmt.Printf("Connected to database, version: %s\n", result)

// 执行 SQL 查询 rows, err := db.Query("SELECT * FROM ``") // 需要检索的数据表名 if err != nil { log.Fatalf("Failed to execute query: %v", err) } defer rows.Close()

// 处理查询结果 for rows.Next() { var id int var name string if err := rows.Scan(&id, &name); err != nil { log.Fatalf("Failed to scan row: %v", err) } fmt.Printf("ID: %d, Name: %s\n", id, name) }

// 检查是否有错误 if err := rows.Err(); err != nil { log.Fatalf("Error during iteration: %v", err) } }

常见问题

ECS无法连接PolarDB-X实例

请您按以下步骤进行排查：

检查PolarDB-X实例的运行状态是否为运行中。

检查数据库连接地址、端口、账号及密码是否正确。

检查网络因素，您可以在ECS内执行ping 数据库连接地址或telnet 数据库连接地址 端口来测试网络连通性。

若您使用的是私网地址：

检查ECS与PolarDB-X实例是否位于同一VPC下。若不在同一VPC下，则无法使用私网地址。您可以使用以下任意一种解决方法使ECS与PolarDB-X实例位于同一VPC下：

切换ECS所在的VPC。

若PolarDB-X实例使用的是默认VPC，可以切换PolarDB-X实例所在的VPC。

使用云企业网实现VPC之间的互通。更多信息，请参见同地域VPC互通。

检查ECS的私网IP地址、IP段是否已添加至PolarDB-X实例的白名单中。更多信息，请参见设置实例白名单。

若您使用的是公网地址，检查ECS的公网IP地址是否已添加至PolarDB-X实例的白名单中。更多信息，请参见设置实例白名单。

说明 暂不支持使用虚拟主机和轻量服务器使用私网地址连接PolarDB-X实例。

本地环境无法连接PolarDB-X实例

请您按以下步骤进行排查：

检查PolarDB-X实例的运行状态是否为运行中。

检查数据库连接地址、端口、账号及密码是否正确。

说明 数据库连接地址需为公网地址。若您使用的是ECS并与PolarDB-X实例位于同一VPC下，可以使用私网地址。

检查网络因素，您可以在本地环境执行ping 或telnet  来测试网络连通性。

检查本地环境的公网IP地址或IP段是否已添加至PolarDB-X实例的白名单中。更多信息，请参见设置实例白名单。
本地环境的公网IP地址获取方法如下：

Linux操作系统：打开终端，输入curl ifconfig.me命令后回车。

Windows操作系统：打开命令提示符，输入curl ip.me命令后回车。

macOS操作系统：打开终端，输入curl ifconfig.me命令后回车。
若您的本地网络环境存在代理等情况，以上方式获取的IP可能并非您的真实公网IP。您可以将IP段0.0.0.0/0添加至PolarDB-X实例白名单中，成功连接实例后，执行SHOW PROCESSLIST;命令获取真实公网IP地址，并将其加入到实例白名单中。随后删除白名单中的IP段0.0.0.0/0。

无法连接PolarDB-X实例，报错：Access denied for user 'xxx'@'xxx' (using password: YES)

数据库账号或密码错误，请检查您是否输入正确。您可以前往PolarDB分布式版控制台，在配置与管理 > 账号管理中管理数据库账号和密码。

无法连接PolarDB-X实例，报错：Unknown MySQL server host 'xxx'

数据库连接地址错误，请检查您是否输入正确，正确格式为pxc-xxx.polarx.rds.aliyuncs.com。您可以前往PolarDB分布式版控制台，在基本信息 > 连接信息中管理您的数据库连接地址。

无法连接PolarDB-X实例，报错：Can't connect to MySQL server on 'xxx'或Connection timed out

可能是您当前环境的公网IP地址或IP段未被添加至PolarDB-X实例的白名单中，或您填写的公网IP地址或IP段存在错误。
本地环境的公网IP地址获取方法如下：

Linux操作系统：打开终端，输入curl ifconfig.me命令后回车。

Windows操作系统：打开命令提示符，输入curl ip.me命令后回车。

macOS操作系统：打开终端，输入curl ifconfig.me命令后回车。
若您的本地网络环境存在代理等情况，以上方式获取的IP可能并非您的真实公网IP。您可以将IP段0.0.0.0/0添加至PolarDB-X实例白名单中，成功连接实例后，执行SHOW PROCESSLIST;命令获取真实公网IP地址，并将其加入到实例白名单中。随后删除白名单中的IP段0.0.0.0/0。

数据库的超时设置的推荐实践

若您的应用使用了一些常见的ORM框架（例如SpringBoot+MyBatis+JDBC Driver等）来访问数据库，这些ORM框架通常支持从事务、SQL语句、网络收发包等多个维度对SQL查询时的客户端侧超时时间进行设置。例如Spring的transaction_timeout，MyBatis的statement_timeout ，JDBC MySQL Driver的query_timeout等。
本质上，这些客户端侧的超时机制大多都需要执行数据库的Kill语句来中断查询。在分布式数据库场景，Kill语句执行成本偏高，高频执行会对数据库系统的资源消耗相对较大。因此，不推荐大量使用上述的超时机制连接数据库。
从最佳实践来看，您的应用应该直接使用JDBC URL的socket_timeout参数（网络套接字超时参数）来指定SQL的执行超时，因为该参数依赖TCP协议自身的超时机制，超时触发时不会产生Kill语句的行为。示例如下： ...

上一篇：创建数据库下一篇：执行SQL基本操作

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
