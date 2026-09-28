---
title: 使用 GORM 连接到 TiDB
summary: 了解如何使用 GORM 连接到 TiDB。本文提供了使用 GORM 与 TiDB 交互的 Golang 示例代码片段。
aliases: ['/zh/tidb/stable/dev-guide-sample-application-golang-gorm/','/zh/tidb/dev/dev-guide-sample-application-golang-gorm/','/zh/tidbcloud/dev-guide-sample-application-golang-gorm/']
---

# 使用 GORM 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[GORM](https://gorm.io/index.html) 是当前比较流行的开源 Golang ORM 框架并且适配了 TiDB 的 `AUTO_RANDOM` 等特性。同时，TiDB 为 [GORM 的默认支持数据库](https://gorm.io/zh_CN/docs/connecting_to_the_database.html#TiDB)。

本文档将展示如何使用 TiDB 和 GORM 来完成以下任务：

- 配置你的环境。
- 使用 GORM 连接到 TiDB。
- 构建并运行你的应用程序。你也可以参考[示例代码片段](#示例代码片段)，完成基本的 CRUD 操作。

> **注意**
>
> 本文档适用于 {{{ .starter }}}、{{{ .essential }}}、{{{ .premium }}}、TiDB Cloud Dedicated 和本地部署的 TiDB。

## 前置需求

- 推荐 [Go](https://go.dev/) **1.20** 及以上版本。
- [Git](https://git-scm.com/downloads)。
- TiDB 集群。如果你还没有 TiDB 集群，可以按照以下方式创建：
  - （推荐方式）[创建 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md#step-1-create-a-starter-instance)。
  - [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster)或[部署正式 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 运行代码并连接到 TiDB

本小节演示如何运行示例应用程序的代码，并连接到 TiDB。

### 第 1 步：克隆示例代码仓库到本地

运行以下命令，将示例代码仓库克隆到本地：

```shell
git clone https://github.com/tidb-samples/tidb-golang-gorm-quickstart.git
cd tidb-golang-gorm-quickstart
```

### 第 2 步：配置连接信息

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

### 第 3 步：运行代码并查看结果

1. 运行下述命令，执行示例代码：

    ```shell
    make
    ```

2. 查看 [`Expected-Output.txt`](https://github.com/tidb-samples/tidb-golang-gorm-quickstart/blob/main/Expected-Output.txt)，并与你的程序输出进行比较。结果近似即为连接成功。

## 示例代码片段

你可参考以下关键代码片段，完成自己的应用开发。

完整代码及其运行方式，见代码仓库 [tidb-golang-gorm-quickstart](https://github.com/tidb-samples/tidb-golang-gorm-quickstart)。

### 连接到 TiDB

```golang
func createDB() *gorm.DB {
    dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&tls=%s",
        ${tidb_user}, ${tidb_password}, ${tidb_host}, ${tidb_port}, ${tidb_db_name}, ${use_ssl})

    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
        Logger: logger.Default.LogMode(logger.Info),
    })
    if err != nil {
        panic(err)
    }

    return db
}
```

在使用该函数时，你需要将 `${tidb_host}`、`${tidb_port}`、`${tidb_user}`、`${tidb_password}`、`${tidb_db_name}` 等替换为你的 TiDB 的实际值。因为 {{{ .starter }}} 要求使用 TLS (SSL) connection，因此在连接到 {{{ .starter }}} 时 `${use_ssl}` 的值应为 `true`。

### 插入数据

```golang
db.Create(&Player{ID: "id", Coins: 1, Goods: 1})
```

更多信息参考[插入数据](/develop/dev-guide-insert-data.md)。

### 查询数据

```golang
var queryPlayer Player
db.Find(&queryPlayer, "id = ?", "id")
```

更多信息参考[查询数据](/develop/dev-guide-get-data-from-single-table.md)。

### 更新数据

```golang

db.Save(&Player{ID: "id", Coins: 100, Goods: 1})
```

更多信息参考[更新数据](/develop/dev-guide-update-data.md)。

### 删除数据

```golang
db.Delete(&Player{ID: "id"})
```

更多信息参考[删除数据](/develop/dev-guide-delete-data.md)。

## 下一步

- 关于 GORM 的更多使用方法，可以参考 [GORM 官方文档](https://gorm.io/zh_CN/docs/index.html)及 GORM 官方文档中的 [TiDB 章节](https://gorm.io/zh_CN/docs/connecting_to_the_database.html#TiDB)。
- 你可以继续阅读开发者文档，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。

## 需要帮助?

- 在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问
- [提交 TiDB Cloud 工单](https://tidb.support.pingcap.com/servicedesk/customer/portals)
- [提交 TiDB 工单](/support.md)
