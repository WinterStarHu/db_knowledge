# 如何创建并使用PolarDBMySQL引擎集群-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-mysql/getting-started

如何创建并使用PolarDBMySQL引擎集群-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

产品计费

产品规格

动态与公告

快速入门

PolarDB AI能力

用户指南

性能白皮书

最佳实践

安全合规

API参考

SDK下载

常见问题

视频专区

术语

相关协议

PolarDB MySQL版边缘集群

首页

云原生数据库 PolarDB

云原生数据库PolarDB MySQL版

快速入门

快速入门

更新时间：

复制 MD 格式

产品详情 我的收藏

本文将为您详细介绍如何快速使用PolarDB MySQL版，包括创建集群、配置白名单、创建数据库账号以及连接数据库等相关操作。

使用教程

若您在以下任何步骤中存在疑问，请点击相应步骤以查看详细说明。

1. 创建集群

您可以前往PolarDB的快速购买页面，通过少量配置即可快速创建PolarDB MySQL版集群。配置参数如下，其他设置可保持默认。详细创建集群过程，请参见自定义购买集群。

配置项

说明

计费类型

选择集群的计费类型。更多信息，请参见计费类型。

包年包月：预付费模式。在创建集群时，您需选择固定规格的资源，并预先支付集群的费用。购买周期越长，所享受的折扣也越大。该模式一般适用于业务需求长期稳定的场景。

按量付费：后付费模式。在创建集群时，您需选择固定规格的资源，但无需提前支付集群的费用。该模式根据您实际使用的时长进行计费，一般适用于业务需求灵活的场景。

Serverless：后付费模式。在创建集群时，您无需选择固定规格的资源，也无需提前支付集群的费用。该模式是指PolarDB集群的动态弹性扩缩容能力，能够根据系统业务负载的变化进行调整。一般适用于业务波动、不确定负载或不可预测的业务场景。

地域

选择集群的所在地域。

说明

请确保PolarDB与需要连接的ECS位于同一个地域，否则它们内网无法直接互通。

数据库引擎

选择集群的数据库引擎。

MySQL 8.0.1

MySQL 8.0.2

说明

快速购买仅支持购买MySQL 8.0版本。若您需要购买其他MySQL版本，请在左上角选择自定义购买页签。

产品版本

选择集群的产品版本。

企业版

标准版

说明

企业版和标准版在功能上有所差异。具体信息，请参见企业版和标准版功能对比。

网络类型

配置集群的VPC网络和交换机。

说明

如果您已创建符合您网络规划的VPC，可以直接选择该VPC和交换机。例如，如果您已创建ECS，且该ECS所在的VPC符合您的规划，那么您可以选择该VPC和交换机。

如果您未创建符合您网络规划的VPC，您可以使用默认VPC和交换机。

部署模式（可选）

选择集群的节点个数以及高可用模式。更多信息，请参见高可用模式（热备集群）。

单节点：仅包含一个主节点（读写节点）。

节点个数：1

高可用模式：单AZ（关闭存储热备集群）

双节点高可用：包含一个主节点（读写节点）一个只读节点。

节点个数：2

高可用模式：单AZ（关闭存储热备集群）

跨AZ高可用：包含一个主节点（读写节点）一个只读节点。数据分布在多个可用区内，主可用区和备可用区各保存一份完整数据。

节点个数：2

高可用模式：双AZ（开启存储热备集群）

说明

仅当计费类型为包年包月或按量付费时，才需选择集群的高可用模式。

节点规格

选择集群的计算节点规格。您可以根据实际需求选择，若您需要购买其他规格，请在左上角选择自定义购买页签。

存储空间（可选）

配置集群的存储空间大小。

说明

仅当产品版本为标准版时，才需配置集群的存储空间大小。

2. 配置白名单

您可以前往PolarDB控制台，在集群列表中单击目标集群ID进入集群详情页。在配置与管理 > 集群白名单中添加IP白名单或安全组。更多信息，请参见设置集群白名单与设置安全组。

说明

如果您是使用ECS访问PolarDB，并且ECS与PolarDB位于同一VPC内，则可以将ECS所在的VPC网段添加至default分组中。

如果您是使用ECS访问PolarDB，但ECS与PolarDB不在同一VPC内，则可以将ECS的公网IP地址添加至新的IP白名单分组，或将ECS所在的安全组添加至集群白名单中。

如果您是在本地环境中访问PolarDB，请将您本地环境的公网IP地址添加至新的IP白名单分组中。

本地环境的公网IP地址获取方法如下：

Linux操作系统：打开终端，输入curl ifconfig.me命令后回车。

Windows操作系统：打开命令提示符，输入curl ip.me命令后回车。

macOS操作系统：打开终端，输入curl ifconfig.me命令后回车。

若您的本地网络环境存在代理等情况，以上方式获取的IP可能并非您的真实公网IP。您可以将IP段0.0.0.0/0添加至PolarDB集群白名单中，成功连接集群后，执行SHOW PROCESSLIST;命令获取真实公网IP地址，并将其加入到集群白名单中。随后删除白名单中的IP段0.0.0.0/0。

xxx        | aurora                | 100.104.xxx.xxx:59236 | information_schema | Sleep   |            47 |          | NULL 268459868  | polardb_mysql_account | 47.94.74.xxx:39160    | NULL               | Query   |             0 | starting | SHOW PROCESSLIST

IP段0.0.0.0/0表示允许所有的访问源访问集群，将其设置在集群白名单中存在极大的风险，如非必要，切勿将其添加至白名单。

3. 创建数据库账号

您可以前往PolarDB控制台，在集群列表中单击目标集群ID进入集群详情页。在配置与管理 > 账号管理中创建数据库账号。更多信息，请参见创建和管理数据库账号。

说明

数据库账号类型分为高权限账号和普通账号，这两种账号的权限存在差异。您可以根据实际业务需求选择创建相应的数据库账号。更多信息，请参见账号权限。

4. 获取集群地址

您可以前往PolarDB控制台，在集群列表中单击目标集群ID进入集群详情页。在数据库连接中获取数据连接地址。更多信息，请参见管理连接地址。在数据库连接页面，找到集群地址【推荐】区域，单击私网地址右侧的复制获取连接地址。

说明

推荐使用集群地址，默认端口号为3306。

请根据您的访问环境选择私网或公网。

如果您是使用ECS访问PolarDB，并且ECS与PolarDB位于同一VPC内，请选择私网。

如果您是在本地环境中访问PolarDB，请选择公网。公网地址单击右侧申请即可。

公网即因特网，通过公网访问将无法实现PolarDB集群的最佳性能。

暂不支持使用虚拟主机和轻量服务器使用私网地址连接PolarDB集群。

5. 连接数据库

连接数据库集群的方法有很多种，您可以根据实际业务需求来选择适合的连接方式。以下列举了部分连接数据库集群的示例：

使用DMS连接集群 DMS是阿里云提供的图形化的数据管理工具，它是一种集数据管理、结构管理、用户授权、安全审计、数据趋势、数据追踪、BI图表、性能与优化和服务器管理于一体的数据管理服务。您无需借助其他工具，即可直接在DMS上管理您的PolarDB集群。

前往PolarDB控制台，在集群列表中单击目标集群ID进入集群详情页。在页面右上角单击登录数据库。

在弹出的对话框中，输入PolarDB MySQL版集群中创建的数据库账号和数据库密码，单击登录。

登录后，您可以在左侧导航栏的已登录实例中查看到所登录的PolarDB MySQL版集群，并进行相应的管理操作。

使用客户端连接集群 您可以使用任何通用的客户端连接PolarDB集群。此处以MySQL Workbench 8.0.29版本为例，其它客户端的操作类似。

安装MySQL Workbench。官方下载地址请参见MySQL Workbench下载页面。

打开MySQL Workbench，选择Database > Connect to Database。

输入连接信息，单击OK。

参数 说明 示例

Hostname 数据库连接地址。
pc-2***.rwlb.rds.aliyuncs.com

Port 数据库连接地址的端口号，与数据库连接地址相对应。

说明 默认端口为3306。
3306

Username 数据库账号。
polardb_mysql_user

Password 数据库账号密码。
Pass***233

使用命令行连接集群 如果您的服务器安装了MySQL客户端，可以通过命令行连接PolarDB MySQL版数据库集群。
语法： mysql -h<连接地址> -P<端口> -u<数据库用户名> -p<数据库用户密码> 示例： mysql -h pc-2***.rwlb.rds.aliyuncs.com -P3306 -upolardb_mysql_user -pPass***233

参数 说明 示例

-h 数据库连接地址。
pc-2***.rwlb.rds.aliyuncs.com

-P 数据库连接地址的端口号，与数据库连接地址相对应。

说明

默认端口为3306。

如果端口号为默认端口，该参数可以不填写。
3306

-u 数据库账号。
polardb_mysql_user

-p 数据库账号密码。

说明 该参数为必填参数。

如果不填写该参数，在Enter password后会重新要求输入密码。

如果填写该参数，-p与数据库密码之间不能有空格。
Pass***233

使用应用程序连接集群 连接PolarDB MySQL版集群的方式与连接其他MySQL数据库的方式一样，仅需将数据库连接地址、端口、账号及密码等进行替换即可。以下为您列举部分开发语言如何通过应用程序访问PolarDB数据库： Java 此处以Maven项目为例，使用MySQL JDBC驱动连接PolarDB MySQL版集群。

首先，您需要在pom.xml文件中添加MySQL JDBC驱动的依赖，代码示例： <dependency> <groupId>mysql</groupId> <artifactId>mysql-connector-java</artifactId> <version>8.0.27</version> </dependency>

连接集群。请将参数<HOST>、端口号、<USER>、<PASSWORD>、<DATABASE>、<YOUR_TABLE_NAME>及<YOUR_TABLE_COLUMN_NAME>进行替换。
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseConnection { public DatabaseConnection() { }

public static void main(String[] args) { // PolarDB集群连接地址、端口、需要连接的数据库名 String url = "jdbc:mysql://<HOST>:3306/<DATABASE>?useSSL=false&serverTimezone=UTC";
// 数据库账号 String user = "<USER>";
// 数据库账号的密码 String password = "<PASSWORD>";

try { Class.forName("com.mysql.cj.jdbc.Driver");
Connection conn = DriverManager.getConnection(url, user, password);
Statement stmt = conn.createStatement();
// 需要检索的数据表名 ResultSet rs = stmt.executeQuery("SELECT * FROM `<YOUR_TABLE_NAME>`");

while(rs.next()) { // 需要检索的数据表的列名 System.out.println(rs.getString("<YOUR_TABLE_COLUMN_NAME>"));
}

rs.close();
stmt.close();
conn.close();
} catch (Exception var7) { var7.printStackTrace();
}

} } Python 此处以Python3为例，使用PyMySQL库连接PolarDB MySQL版集群。

首先，您需要安装PyMySQL库。如果您还没有安装，可以通过以下命令进行安装： pip3 install PyMySQL

连接集群。请将参数<HOST>、端口号、<USER>、<PASSWORD>、<DATABASE>及<YOUR_TABLE_NAME>进行替换。
import pymysql

# 数据库连接参数
host = '<HOST>'  # PolarDB集群连接地址 port = 3306  # 默认端口3306 user = '<USER>'  # 数据库账号 password = '<PASSWORD>'  # 数据库账号的密码 database = '<DATABASE>'  # 需要连接的数据库名

try:
# 创建数据库连接
connection = pymysql.connect( host=host, port=port, user=user, passwd=password, db=database )

# 获取操作游标
with connection.cursor() as cursor:
# 执行 SQL 查询
sql = "SELECT * FROM `<YOUR_TABLE_NAME>`"  # 需要检索的数据表名 cursor.execute(sql)

# 获取查询结果
results = cursor.fetchall() for row in results:
print(row)

finally:
# 关闭数据库连接
if 'connection' in locals() and connection.open:
connection.close()

Go 此处以go1.23.0为例，使用database/sql包和go-sql-driver/mysql驱动来连接PolarDB MySQL版集群。

首先，您需要安装go-sql-driver/mysql驱动。您可以通过以下命令进行安装： go get -u github.com/go-sql-driver/mysql

连接集群。请将参数<HOST>、端口号、<USER>、<PASSWORD>、<DATABASE>及<YOUR_TABLE_NAME>进行替换。
package main

import (
"database/sql" "fmt" "log" _ "github.com/go-sql-driver/mysql" )

func main() { // 数据库连接参数 dbHost := "<HOST>"       // PolarDB集群连接地址 dbPort := "3306"         // 默认端口3306 dbUser := "<USER>"       // 数据库账号 dbPass := "<PASSWORD>"   // 数据库账号的密码 dbName := "<DATABASE>"   // 需要连接的数据库名

// 构建 DSN (Data Source Name) dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local", dbUser, dbPass, dbHost, dbPort, dbName)

// 打开数据库连接 db, err := sql.Open("mysql", dsn) if err != nil { log.Fatalf("Failed to connect to database: %v", err) } defer db.Close()

// 测试连接 err = db.Ping() if err != nil { log.Fatalf("Failed to ping database: %v", err) }

// 创建一个操作游标 var result string err = db.QueryRow("SELECT VERSION()").Scan(&result) if err != nil { log.Fatalf("Failed to execute query: %v", err) }

// 输出数据库版本 fmt.Printf("Connected to database, version: %s\n", result)

// 执行 SQL 查询 rows, err := db.Query("SELECT * FROM `<YOUR_TABLE_NAME>`") // 需要检索的数据表名 if err != nil { log.Fatalf("Failed to execute query: %v", err) } defer rows.Close() }

集群管理

节点管理

变更集群配置

高可用

备份恢复

自定义节点名称

重启节点

手动变配/增加或删除节点

临时升配/临时增加节点

自动变配（弹性扩缩容）

主备节点切换

手动更换可用区/自动切换可用区

自动备份/手动备份

全量恢复/库表恢复

闪回查询

数据库代理

监控与优化

版本管理

Binlog管理

负载均衡

一致性级别

连接池

连接保持

过载保护

性能监控

一键诊断

慢SQL

SQL洞察

小版本升级

大版本升级

开启和关闭Binlog

管理Binlog文件保存时长

常见问题

ECS无法连接PolarDB集群

请您按以下步骤进行排查：

检查PolarDB集群的运行状态是否为运行中。

检查数据库连接地址、端口、账号及密码是否正确。更多信息，请参见获取数据库连接地址。

检查网络因素，您可以在ECS内执行ping 数据库连接地址或telnet 数据库连接地址 端口来测试网络连通性。

若您使用的是私网地址：

检查ECS与PolarDB集群是否位于同一VPC下。若不在同一VPC下，则无法使用私网地址。您可以使用以下任意一种解决方法使ECS与PolarDB集群位于同一VPC下：

切换ECS所在的VPC。

若您的集群为集群版系列，则可以切换集群所在的VPC。

使用云企业网实现同地域VPC之间的互通。

检查ECS的私网IP地址、IP段或安全组是否已添加至集群白名单。

若您使用的是公网地址，检查ECS的公网IP地址或安全组是否已添加至集群白名单。

说明 暂不支持使用虚拟主机和轻量服务器使用私网地址连接PolarDB集群。

本地环境无法连接PolarDB集群

请您按以下步骤进行排查：

检查PolarDB集群的运行状态是否为运行中。

检查数据库连接地址、端口、账号及密码是否正确。更多信息，请参见获取数据库连接地址。

说明 数据库连接地址需为公网地址。若您使用的是ECS并与PolarDB集群位于同一VPC下，可以使用私网地址。

检查网络因素，您可以在本地环境执行ping <数据库连接地址>或telnet <数据库连接地址> <端口>来测试网络连通性。

检查本地环境的公网IP地址或IP段是否已添加至集群白名单。
本地环境的公网IP地址获取方法如下：

Linux操作系统：打开终端，输入curl ifconfig.me命令后回车。

Windows操作系统：打开命令提示符，输入curl ip.me命令后回车。

macOS操作系统：打开终端，输入curl ifconfig.me命令后回车。
若您的本地网络环境存在代理等情况，以上方式获取的IP可能并非您的真实公网IP。您可以将IP段0.0.0.0/0添加至PolarDB集群白名单中，成功连接集群后，执行SHOW PROCESSLIST;命令获取真实公网IP地址，并将其加入到集群白名单中。随后删除白名单中的IP段0.0.0.0/0。

无法连接PolarDB集群，报错：Access denied for user 'xxx'@'xxx' (using password: YES)

数据库账号或密码错误，请检查您是否输入正确。您可以前往PolarDB控制台，在配置与管理 > 账号管理中管理数据库账号和密码。

无法连接PolarDB集群，报错：Unknown MySQL server host 'xxx'

数据库连接地址错误，请检查您是否输入正确，正确格式为pc-xxxxxx.rwlb.rds.aliyuncs.com。您可以前往PolarDB控制台，在基本信息 > 数据库连接中管理您的数据库连接地址。

无法连接PolarDB集群，报错：Can't connect to MySQL server on 'xxx'或Connection timed out

可能是您当前环境的公网IP地址或IP段未被添加至PolarDB集群的白名单中，或您填写的公网IP地址或IP段存在错误。
本地环境的公网IP地址获取方法如下：

Linux操作系统：打开终端，输入curl ifconfig.me命令后回车。

Windows操作系统：打开命令提示符，输入curl ip.me命令后回车。

macOS操作系统：打开终端，输入curl ifconfig.me命令后回车。
若您的本地网络环境存在代理等情况，以上方式获取的IP可能并非您的真实公网IP。您可以将IP段0.0.0.0/0添加至PolarDB集群白名单中，成功连接集群后，执行SHOW PROCESSLIST;命令获取真实公网IP地址，并将其加入到集群白名单中。随后删除白名单中的IP段0.0.0.0/0。

上一篇：功能风险提醒下一篇：PolarDB AI能力

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
