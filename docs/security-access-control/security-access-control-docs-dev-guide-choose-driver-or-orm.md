---
title: 选择驱动或 ORM 框架
summary: 选择驱动或 ORM 框架连接 TiDB。
aliases: ['/zh/tidb/dev/choose-driver-or-orm','/zh/tidb/stable/dev-guide-choose-driver-or-orm/','/zh/tidb/dev/dev-guide-choose-driver-or-orm/','/zh/tidbcloud/dev-guide-choose-driver-or-orm/']
---

# 选择驱动或 ORM 框架

> **注意：**
>
> TiDB 支持等级说明：
>
> - **Full**：表明 TiDB 已经兼容该工具的绝大多数功能，并且在该工具的新版本中对其保持兼容。{{{ .company }}} 将定期地对 [TiDB 支持的第三方工具](/develop/dev-guide-third-party-support.md)中的新版本进行兼容性测试。
> - **Compatible**：表明由于该工具已适配 MySQL，而 TiDB 高度兼容 MySQL 协议，因此 TiDB 可以兼容该工具的大部分功能。但 {{{ .company }}} 并未对该工具作出完整的兼容性验证，有可能出现一些意外的行为。
>
> 关于更多 TiDB 支持的第三方工具，你可以查看 [TiDB 支持的第三方工具](/develop/dev-guide-third-party-support.md)。

TiDB 兼容 MySQL 的协议，但存在部分与 MySQL 不兼容或有差异的特性，具体信息可查看[与 MySQL 兼容性对比](/mysql-compatibility.md)。

## Java

本节介绍 Java 语言的 Driver 及 ORM 的使用方式。

### Java Drivers

### Java ORM 框架

### Java 客户端负载均衡

**tidb-loadbalance**

支持等级：**Full**

[tidb-loadbalance](https://github.com/pingcap/tidb-loadbalance) 是应用端的负载均衡组件。通过 tidb-loadbalance，你可以实现自动维护 TiDB server 的节点信息，根据节点信息使用 tidb-loadbalance 策略在客户端分发 JDBC 连接。客户端应用与 TiDB server 之间使用 JDBC 直连，性能高于使用负载均衡组件。

目前 tidb-loadbalance 已实现轮询、随机、权重等负载均衡策略。

> **注意：**
>
> tidb-loadbalance 需配合 mysql-connector-j 一起使用。

如果你使用的是 Maven，请将以下内容添加到你的 ``：

```xml
io.github.lastincisor
mysql-connector-java
8.0.29-tidb-1.0.2
io.github.lastincisor
tidb-loadbalance
0.0.5
```

如果你使用的是 Gradle，请将以下内容添加到你的 `dependencies`：

```gradle
implementation group: 'io.github.lastincisor', name: 'mysql-connector-java', version: '8.0.29-tidb-1.0.2'
implementation group: 'io.github.lastincisor', name: 'tidb-loadbalance', version: '0.0.5'
```

## Golang

本节介绍 Golang 语言的 Driver 及 ORM 的使用方式。

### Golang Drivers

**go-sql-driver/mysql**

支持等级：**Full**

按照 [go-sql-driver/mysql 文档](https://github.com/go-sql-driver/mysql)中的说明获取并配置 Golang 驱动程序即可使用。

有关一个完整的实例应用程序，可参阅[使用 Go-MySQL-Driver 连接到 TiDB](/develop/dev-guide-sample-application-golang-sql-driver.md)。

### Golang ORM 框架

**GORM**

支持等级：**Full**

GORM 是一个流行的 Golang 的 ORM 框架，你可以使用 `go get` 获取你的应用程序的所有依赖项。

```shell
go get -u gorm.io/gorm
go get -u gorm.io/driver/mysql
```

使用 GORM 进行 TiDB 应用程序构建的例子，可参阅[使用 GORM 连接到 TiDB](/develop/dev-guide-sample-application-golang-gorm.md)。

## Python

本节介绍 Python 语言的 Driver 及 ORM 的使用方式。

### Python Drivers

### Python ORM 框架
