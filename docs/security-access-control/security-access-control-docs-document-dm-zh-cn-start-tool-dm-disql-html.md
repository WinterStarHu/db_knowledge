# SQL 交互式查询工具 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/tool-dm-disql.html

SQL 交互式查询工具 | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

DM 数据库版本介绍

版本区别 版本获取

DM 数据库安装

Windows 安装

安装前准备 数据库安装 配置实例 启动、停止数据库

Linux 安装

安装前准备 数据库安装 配置实例 注册服务 启动、停止数据库

数据库目录结构介绍

DM 数据库工具介绍

DM 服务查看器 DM 管理工具 DM 数据迁移工具 SQL 交互式查询工具 DM 数据库配置助手 DM 性能监视工具 DM 控制台工具 SQLark 数据库开发、管理和迁移工具

DM 数据库基本操作

创建表空间

创建用户

创建用户关联表空间 授予权限 用户与模式的关系

创建数据库对象

DM 数据移植

从 Oracle 移植到 DM 从 MySQL 移植到 DM 从 PostgreSQL 移植到 DM 从 SQL Server 移植到 DM 从 DB2 移植到 DM

基于 SQLark 进行数据迁移

从Oracle迁移到DM 从MySQL迁移到DM 从PostgreSQL迁移到DM

DM 应用程序开发

C/C++ Python .NET

GO

GO_DM GO_ODBC

JAVA PHP QODBC GeoServer JBOSS 添加达梦数据源

DM 数据库集群介绍

数据守护集群 共享存储集群 新一代分布式集群

达梦数据复制软件DMDRS

产品介绍 安装部署 功能特性 平台介绍

SQL 交互式查询工具

一、概述

disql 是一款命令行客户端工具，用于进行 SQL 交互式查询，disql 工具一般用于没有图形界面时的操作，或者使用的连接工具为命令行形式，如 Xshell、SCRT 等工具。

二、DISQL 登录数据库

2.1 Linux 登录 disql

Linux 登录，进入数据库软件安装目录的 bin 目录下。登录方式主要有两种，分别如下：

方式一：

./disql username/password@IP:PORT

以 /home/dmdba/dmdbms/bin 为例，如下所示：

如果密码含有特殊字符的情况下，需要使用双引号将密码包含进来，同时外层再使用单引号进行转义。以用户名 TEST，密码 TEST@111#2024 为例，如下所示：

方式二：

./disql  /nolog   ---进入disql操作终端界面，然后执行下面的操作 conn 用户名/密码@IP:PORT 或者 connect 用户名/密码@IP:PORT 或者输入LOGIN命令 login

以 /home/dmdba/dmdbms/bin 为例，disql 中通过 conn 或者 connect 命令连接数据库，操作如下所示：

如上所示，当密码存在特殊字符时，在 disql 操作界面中只需要使用双引号包含密码即可，而直接使用 disql 命令包含用户名密码信息时，需要使用双引号将密码包含进来，同时外层再使用单引号进行转义，见方式一。

login 命令操作如下：

连接选项：

服务名：IP:PORT 或者 dm_svc.conf 文件中配置的服务名；

用户名：输入登录的数据库用户名；

密码：输入用户密码   （注：密码无需加转义符）。

其余回车即可，上述 conn、connect、login 大小写均可。

2.2 Windows 登录 disql

Windows 登录方式也有两种，分别如下：

方式一：

CMD 中使用 disql 命令登录数据库，如下图所示：

如果密码有特殊字符，在 Windows 命令行界面需要使用三个双引号将密码包含起来，如上图所示。

方式二：

点击【开始界面】，选择【达梦数据库】菜单，点击【 SQL 交互式查询工具】，如下图所示：

进入 CMD 命令行方式，如下图所示：

使用 LOGIN 或 CONN 命令登录到指定数据库。

以 LOGIN 为例，登录到 IP 地址为 localhost 的机器上，用户名和密码为：SYSDBA/*****，端口号为 5236，非读写分离集群。其他全部敲回车，采用缺省输入，密码不会显到屏幕上。如下图所示：

三、disql 登出数据库

登出命令在 Windows、Linux 均相同，主要分为两类，一类是 logout、disconnect；另一类是 exit、quit。其中，logout/disconnect 只退出或者断开当前登录的会话连接，不退出 disql。exit/quit 表示退出当前登录会话连接并且退出 disql 操作界面。如下所示：

四、disql 的使用

4.1 脚本使用

可在登录时直接同时进行脚本的执行，以 Linux 上脚本位置  /home/dmdba/test.sql、Windows 上脚本位置 C:\dm8_326_p6\sel.sql 为例，如下所示：

Windows 环境下不需要对反波浪号“`”进行转义，而 Linux 环境下需要对其进行转义。

也可以在登录成功后执行脚本，通过符号“`”和“start”命令加上脚本位置执行脚本，如下所示：

4.2 环境变量参数设置

可通过设置 disql 的参数，来调整交互界面的显示效果，以达成输出的显示结果更加直观。通过 set 命令语法进行使用，off 表示该参数关闭，on 表示该参数开启。可以同时 SET 多个环境变量，如：set heading on timing on 。需要注意的是，SET 之后某个环境变量出错，那么该变量之后的环境变量参数将不再起作用。

disql 常用部分参数如下所示：

--设置一页有多少行数 SET PAGESIZE 1000 --显示每个 SQL 语句花费的执行时间 SET TIMING ON --显示系统的当前时间 SET TIME ON --设置屏幕上一行显示宽度 SET LINESIZE 1000 --设置查看执行计划 SET AUTOTRACE --在块中有打印信息时，是否打印，以及打印的格式 SET SERVEROUTPUT ON --设置 SQL 语句的编码方式 GBK | GB18030 | UTF8 | DEFAULT SET CHAR_CODE DEFAULT

--输出到文件 SPOOL /home/dmdba/dbchk20200609.txt --结束输出文件 SPOOL OFF;

更多环境变量使用参考《DM8_DIsql 使用手册》。

4.3 变量设置案例

关闭显示行号，SET  LINESHOW  OFF。

显示系统当前时间，SET  TIME  ON。

设置兼容 MySQL 的打印格式，SET  ISQL_MODE  3 。

4、DISQL 中使用 INSERT 语句且当插入的值包含 & 符号时，需要将 DEFINE 环境变量关闭或者设置成其他值。DEFINE 环境变量默认为 & 前缀，即 SQL 语句中包含 & 符号时，& 符号后面的字符会识别为 SQL 语句中变量名，如后面字符中包含 $ 符号，则从 & 符号与 $  符号中间的字符识别为 SQL 语句中的变量名。关闭 DEFINE 功能，SET  DEFINE  OFF 。

4.4 常用命令

DISQL 部分常用命令如下：

HELP   ---帮助命令，可以查看相关命令配置项的用法，help set、help show SET  ---设置disql环境变量，可同时设置多个变量，使用空格分开。
SHOW 变量名  ---查看当前disql环境变量，可同时查看多个变量，使用空格分开。
ED或者EDIT 文件名  ---编辑指定的文本文件，缺省调用notepad或者vi HOST 操作系统命令  ---调用执行操作系统命令 DESC  模式名.对象名  ---获取表或视图、存储过程、函数、包、记录、类的结构描述。
EXPLAIN  SQL语句  ---查看SQL语句预估的执行计划

4.5 使用配置文件设置环境变量

disql 在连接成功数据库时会自动运行两个配置文件 glogin.sql 和 login.sql。glogin.sql 文件中的设置永久生效，该配置文件需要用户自行创建在 $DM_HOME/bin/disql_conf 路径下，其中 $DM_HOME 为 DM 的安装目录，需要用户在操作系统配置 DM_HOME 环境变量，disql_conf 目录需要用户自行创建。login.sql 文件为用户自定义配置文件，对其存放路径不做限制。

glogin.sql 文件和 login.sql 文件的执行顺序如下：

默认在 $DM_HOME/bin/disql_conf 路径下查找 glogin.sql 文件并执行;

默认在当前工作目录下（注意不是 DIsql 工具所在的目录，而是启动 disql 时所在的目录）查找 login.sql 文件并执行，若未找到则执行步骤 3;

判断操作系统是否配置了 DM_SQL PATH 环境变量，如果配置了该变量则在对应路径下查找 login.sql 文件并执行。

disql 执行上述配置文件时并不会在 DIsql 窗口打印信息，如果没有找到上述配置文件则忽略。

例如，用户配置 DM_HOME 环境变量后，在 $DM_HOME/bin/disql_conf 目录下创建 glogin.sql 文件，内容如下：

set time on set lineshow off

另外，用户在当前工作目录下创建了 login.sql 文件，内容如下：

set FEEDBACK OFF

disql 启动并连接数据库服务器后，上述两个配置文件中的设置立即生效。

上次更新：2026-09-26 上一篇下一篇

SQL 交互式查询工具

一、概述 二、DISQL 登录数据库
2.1 Linux 登录 disql
2.2 Windows 登录 disql
三、disql 登出数据库 四、disql 的使用
4.1 脚本使用
4.2 环境变量参数设置
4.3 变量设置案例
4.4 常用命令
4.5 使用配置文件设置环境变量

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

DM 数据库版本介绍

版本区别 版本获取

DM 数据库安装

Windows 安装

安装前准备 数据库安装 配置实例 启动、停止数据库

Linux 安装

安装前准备 数据库安装 配置实例 注册服务 启动、停止数据库

数据库目录结构介绍

DM 数据库工具介绍

DM 服务查看器 DM 管理工具 DM 数据迁移工具 SQL 交互式查询工具 DM 数据库配置助手 DM 性能监视工具 DM 控制台工具 SQLark 数据库开发、管理和迁移工具

DM 数据库基本操作

创建表空间

创建用户

创建用户关联表空间 授予权限 用户与模式的关系

创建数据库对象

DM 数据移植

从 Oracle 移植到 DM 从 MySQL 移植到 DM 从 PostgreSQL 移植到 DM 从 SQL Server 移植到 DM 从 DB2 移植到 DM

基于 SQLark 进行数据迁移

从Oracle迁移到DM 从MySQL迁移到DM 从PostgreSQL迁移到DM

DM 应用程序开发

C/C++ Python .NET

GO

GO_DM GO_ODBC

JAVA PHP QODBC GeoServer JBOSS 添加达梦数据源

DM 数据库集群介绍

数据守护集群 共享存储集群 新一代分布式集群

达梦数据复制软件DMDRS

产品介绍 安装部署 功能特性 平台介绍

简体中文

简体中文
