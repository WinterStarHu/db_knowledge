# GO_ODBC | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/GO_ODBC_NEW.html

GO_ODBC | 达梦技术文档

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

GO_ODBC

本章节主要介绍使用 GO 语言开发时，使用 ODBC 驱动连接达梦数据库。

一、Windows 环境下 go 连接数据库

1.1 准备工作

下载并安装 go，git 。

go 下载地址为 https://studygolang.com/dl 。

git 下载地址为 https://git-scm.com/ 。

本次 Windows 使用 go 版本为 go1.22.0.windows-amd64，git 版本为 2.43.0.windows.1 。

1.2 环境配置

指定系统 path，指定到 go 的 bin 目录。

指定 GOPATH 和 GOROOT。

1.3 创建 ODBC 数据源

1.4 测试连接

使用终端下载需要的依赖。

go get  github.com/alexbrainman/odbc go get github.com/go-xorm/xorm

创建 goodbc.go，执行代码。

package main

import (
"fmt" _ "github.com/alexbrainman/odbc"  // google's odbc driver "github.com/go-xorm/xorm" "xorm.io/core" )

type Person struct { PersonId     int		 `xorm:"PERSONID"` Sex          string		 `xorm:"SEX"` Name         string		 `xorm:"NAME"` Email        string		 `xorm:"EMAIL"` Phone        string 	 `xorm:"PHONE"` }

func main() {

Engine, err := xorm.NewEngine("odbc", "driver={DM8 ODBC DRIVER};server=192.168.40.1:5237;database=DM8;uid=SYSDBA;pwd=*****;charset=utf8") if err != nil { fmt.Println("new engine got error:", err) return } if err := Engine.Ping(); err != nil { fmt.Println("ping got error:", err) return }

Engine.SetTableMapper(core.SameMapper{}) Engine.ShowSQL(true) Engine.SetMaxOpenConns(5) Engine.SetMaxIdleConns(5)

total, err := Engine.Table("PRODUCTION.PRODUCT").Count(&Person{}) if nil != err { fmt.Println(`engine query got error:`, err.Error()) return }

fmt.Println("total count is:",total) }

二、Linux 环境下 go 连接数据库

2.1 准备工作

下载并安装 go，git 。

go 下载地址为 https://studygolang.com/dl 。

本次 Linux 使用 go 版本为 go1.22.0.linux-amd64 。

使用命令下载 git。

yum install git yum install git-svn git-email gitk

2.2 环境配置

修改 /etc/profile 添加 go 环境变量。

vi /etc/profile

根据自己环境添加 PATH , GOPATH , GOROOT 。

export PATH=$PATH:/go/go/bin export GOPATH=/root/go export GOROOT=/go/go

使环境变量生效。

. /etc/profile

2.3 配置 odbc 数据源

DMODBC 在 Linux 操作系统依赖于 UnixODBC 库。

此链接为 2.3.12 版本安装包，https://www.unixodbc.org/unixODBC-2.3.12.tar.gz 。

如果需要下载其他版本 ,点击链接进入官网 https://www.unixodbc.org/ ，选择合适版本进行下载。

下载好后，进行解压，使用命令进行配置。

./configure --enable -gui=no

配置好后进行编译。

make && make install

编译后查找配置文件位置。

odbcinst -j

注意

如果出现 so 文件缺失的情况，大部分可以通过 yum install unixODBC-devel 方式进行解决，如果还有部分缺失，需要自行下载

编辑 /etc/odbcinst.ini ，如下所示：

[DM8 ODBC DRIVER] Description = ODBC DRIVER FOR DM8 Driver = /home/dmdba/dmdbms/bin/libdodbc.so

编辑 /etc/odbc.ini ，如下所示：

[dm8] Description = DM ODBC DSN Driver = DM8 ODBC DRIVER SERVER = localhost UID = SYSDBA PWD = ***** TCP_PORT = 5236

注意 odbc.ini 中的 Driver 内容一定要与 odbcinst.ini 中的 DM 驱动定义的节点名称相同。
odbc.ini 中的 SERVER 可以输入数据库服务器的 IP 。

测试连接，出现以下内容说明连接成功。

isql  dm8

2.4 测试连接

执行以下命令。

go env -w GO111MODULE=on go env -w GOPROXY=https://goproxy.cn,direct go mod init godm go get  github.com/alexbrainman/odbc go get github.com/go-xorm/xorm go get github.com/xorm.io go mod tidy

创建 goodbc.go ，使用 go run goodbc.go 执行代码。

package main

import (
"fmt" _ "github.com/alexbrainman/odbc"  // google's odbc driver "github.com/go-xorm/xorm" "xorm.io/core" )

type Person struct { PersonId     int		 `xorm:"PERSONID"` Sex          string		 `xorm:"SEX"` Name         string		 `xorm:"NAME"` Email        string		 `xorm:"EMAIL"` Phone        string 	 `xorm:"PHONE"` }

func main() {

Engine, err := xorm.NewEngine("odbc", "driver={DM8 ODBC DRIVER};server=192.168.40.1:5237;database=DM8;uid=SYSDBA;pwd=******;charset=utf8") if err != nil { fmt.Println("new engine got error:", err) return } if err := Engine.Ping(); err != nil { fmt.Println("ping got error:", err) return }

Engine.SetTableMapper(core.SameMapper{}) Engine.ShowSQL(true) Engine.SetMaxOpenConns(5) Engine.SetMaxIdleConns(5)

total, err := Engine.Table("PRODUCTION.PRODUCT").Count(&Person{}) if nil != err { fmt.Println(`engine query got error:`, err.Error()) return }

fmt.Println("total count is:",total) }

上次更新：2026-09-26 上一篇下一篇

GO_ODBC

一、Windows 环境下 go 连接数据库
1.1 准备工作
1.2 环境配置
1.3 创建 ODBC 数据源
1.4 测试连接
二、Linux 环境下 go 连接数据库
2.1 准备工作
2.2 环境配置
2.3 配置 odbc 数据源
2.4 测试连接

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
