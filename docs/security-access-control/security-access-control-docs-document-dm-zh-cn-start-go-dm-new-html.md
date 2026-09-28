# GO_DM | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/GO_DM_NEW.html

GO_DM | 达梦技术文档

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

GO_DM

本章节主要介绍使用 GO 语言开发时，使用 DM 驱动连接达梦数据库。

一、Windows 环境下 go 连接数据库

1.1 准备工作

下载并安装 go，git 。

go 下载地址为 https://studygolang.com/dl 。

git 下载地址为 https://git-scm.com/。

本次 Windows 使用 go 版本为 go1.22.0.windows-amd64 ，git 版本为 2.43.0.windows.1 。

1.2 环境配置

指定系统 path，指定到 go 的 bin 目录。

指定 GOPATH 和 GOROOT。

1.3 添加 DM GO 驱动

达梦 GO 驱动位于 C:\dmdbms\drivers\go 下，进行解压后复制到 go 安装目录的 src 目录下。

1.4 开发步骤

提前准备好图片, 本次例子图片在 C:\Users\Administrator\Desktop\th.jpg 。

使用终端下载好所需的模块。

go get github.com/golang/snappy

go get golang.org/x/text/encoding

编写 godm.go ,执行代码。

/*该例程实现插入数据，修改数据，删除数据，数据查询等基本操作。*/ package main // 引入相关包
import (
"database/sql" "dm" "fmt" "io/ioutil" "time" ) var db *sql.DB var err error func main() { driverName := "dm" dataSourceName := "dm://SYSDBA:*****@192.168.40.1:5237" if db, err = connect(driverName, dataSourceName); err != nil { fmt.Println(err) return } if err = insertTable(); err != nil { fmt.Println(err) return } if err = updateTable(); err != nil { fmt.Println(err) return } if err = queryTable(); err != nil { fmt.Println(err) return } if err = deleteTable(); err != nil { fmt.Println(err) return } if err = disconnect(); err != nil { fmt.Println(err) return } } /* 创建数据库连接 */ func connect(driverName string, dataSourceName string) (*sql.DB, error) { var db *sql.DB var err error if db, err = sql.Open(driverName, dataSourceName); err != nil { return nil, err } if err = db.Ping(); err != nil { return nil, err } fmt.Printf("connect to \"%s\" succeed.\n", dataSourceName) return db, nil } /* 往产品信息表插入数据 */ func insertTable() error { var inFileName = "C:\\Users\\Administrator\\Desktop\\th.jpg" var sql = `INSERT INTO production.product(name,author,publisher,publishtime, product_subcategoryid,productno,satetystocklevel,originalprice,nowprice,discount,
description,photo,type,papertotal,wordtotal,sellstarttime,sellendtime)
VALUES(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17);` data, err := ioutil.ReadFile(inFileName) if err != nil { return err } t1, _ := time.Parse("2006-Jan-02", "2005-Apr-01") t2, _ := time.Parse("2006-Jan-02", "2006-Mar-20") t3, _ := time.Parse("2006-Jan-02", "1900-Jan-01") _, err = db.Exec(sql, "三国演义", "罗贯中", "中华书局", t1, 4, "9787101046126", 10, 19.0000, 15.2000,
		8.0,
"《三国演义》是中国第一部长篇章回体小说，中国小说由短篇发展至长篇的原因与说书有关。", data, "25", 943, 93000, t2, t3) if err != nil { return err } fmt.Println("insertTable succeed") return nil } /* 修改产品信息表数据 */ func updateTable() error { var sql = "UPDATE production.product SET name = :name WHERE productid = 11;" if _, err := db.Exec(sql, "三国演义（上）"); err != nil { return err } fmt.Println("updateTable succeed") return nil } /* 查询产品信息表 */ func queryTable() error { var productid int var name string var author string var description dm.DmClob var photo dm.DmBlob var sql = "SELECT productid,name,author,description,photo FROM production.product WHERE productid=11" rows, err := db.Query(sql) if err != nil { return err } defer rows.Close() fmt.Println("queryTable results:") for rows.Next() { if err = rows.Scan(&productid, &name, &author, &description, &photo); err != nil { return err } blobLen, _ := photo.GetLength() fmt.Printf("%v %v %v %v %v\n", productid, name, author, description, blobLen) } return nil } /* 删除产品信息表数据 */ func deleteTable() error { var sql = "DELETE FROM production.product WHERE productid = 12;" if _, err := db.Exec(sql); err != nil { return err } fmt.Println("deleteTable succeed") return nil } /* 关闭数据库连接 */ func disconnect() error { if err := db.Close(); err != nil { fmt.Printf("db close failed: %s.\n", err) return err } fmt.Println("disconnect succeed") return nil }

执行成功。

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

2.3 添加 DM GO 驱动

达梦 GO 驱动位于达梦安装目录下的/drivers/go/下，解压后会生成 dm 文件夹。

复制 dm 文件夹到 go 安装目录下的 src 下，本次例子对应的就是 /go/go/src 下。

2.4 开发步骤

提前准备好图片,本次例子图片是位于 /root/go 下的 th.jpg 。

提前确定 go mod 开启，如果未开启并执行以下命令。

go env -w GO111MODULE=on go env -w GOPROXY=https://goproxy.cn,direct go mod init godm go get github.com/golang/snappy go get golang.org/x/text go mod tidy

编写 godm.go ,使用 go run godm.go 执行代码。

/*该例程实现插入数据，修改数据，删除数据，数据查询等基本操作。*/ package main // 引入相关包
import (
"database/sql" "dm" "fmt" "io/ioutil" "time" ) var db *sql.DB var err error func main() { driverName := "dm" dataSourceName := "dm://SYSDBA:*****@localhost:5236" if db, err = connect(driverName, dataSourceName); err != nil { fmt.Println(err) return } if err = insertTable(); err != nil { fmt.Println(err) return } if err = updateTable(); err != nil { fmt.Println(err) return } if err = queryTable(); err != nil { fmt.Println(err) return } if err = deleteTable(); err != nil { fmt.Println(err) return } if err = disconnect(); err != nil { fmt.Println(err) return } } /* 创建数据库连接 */ func connect(driverName string, dataSourceName string) (*sql.DB, error) { var db *sql.DB var err error if db, err = sql.Open(driverName, dataSourceName); err != nil { return nil, err } if err = db.Ping(); err != nil { return nil, err } fmt.Printf("connect to \"%s\" succeed.\n", dataSourceName) return db, nil } /* 往产品信息表插入数据 */ func insertTable() error { var inFileName = "/root/go/th.jpg" var sql = `INSERT INTO production.product(name,author,publisher,publishtime, product_subcategoryid,productno,satetystocklevel,originalprice,nowprice,discount,
description,photo,type,papertotal,wordtotal,sellstarttime,sellendtime)
VALUES(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17);` data, err := ioutil.ReadFile(inFileName) if err != nil { return err } t1, _ := time.Parse("2006-Jan-02", "2005-Apr-01") t2, _ := time.Parse("2006-Jan-02", "2006-Mar-20") t3, _ := time.Parse("2006-Jan-02", "1900-Jan-01") _, err = db.Exec(sql, "三国演义", "罗贯中", "中华书局", t1, 4, "9787101046126", 10, 19.0000, 15.2000,
		8.0,
"《三国演义》是中国第一部长篇章回体小说，中国小说由短篇发展至长篇的原因与说书有关。", data, "25", 943, 93000, t2, t3) if err != nil { return err } fmt.Println("insertTable succeed") return nil } /* 修改产品信息表数据 */ func updateTable() error { var sql = "UPDATE production.product SET name = :name WHERE productid = 11;" if _, err := db.Exec(sql, "三国演义（上）"); err != nil { return err } fmt.Println("updateTable succeed") return nil } /* 查询产品信息表 */ func queryTable() error { var productid int var name string var author string var description dm.DmClob var photo dm.DmBlob var sql = "SELECT productid,name,author,description,photo FROM production.product WHERE productid=11" rows, err := db.Query(sql) if err != nil { return err } defer rows.Close() fmt.Println("queryTable results:") for rows.Next() { if err = rows.Scan(&productid, &name, &author, &description, &photo); err != nil { return err } blobLen, _ := photo.GetLength() fmt.Printf("%v %v %v %v %v\n", productid, name, author, description, blobLen) } return nil } /* 删除产品信息表数据 */ func deleteTable() error { var sql = "DELETE FROM production.product WHERE productid = 12;" if _, err := db.Exec(sql); err != nil { return err } fmt.Println("deleteTable succeed") return nil } /* 关闭数据库连接 */ func disconnect() error { if err := db.Close(); err != nil { fmt.Printf("db close failed: %s.\n", err) return err } fmt.Println("disconnect succeed") return nil }

上次更新：2026-09-26 上一篇下一篇

GO_DM

一、Windows 环境下 go 连接数据库
1.1 准备工作
1.2 环境配置
1.3 添加 DM GO 驱动
1.4 开发步骤
二、Linux 环境下 go 连接数据库
2.1 准备工作
2.2 环境配置
2.3 添加 DM GO 驱动
2.4 开发步骤

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
