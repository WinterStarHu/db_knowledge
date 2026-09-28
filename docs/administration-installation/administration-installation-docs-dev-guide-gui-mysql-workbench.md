---
title: 使用 MySQL Workbench 连接到 TiDB
summary: 了解如何使用 MySQL Workbench 连接到 TiDB。
aliases: ['/zh/tidb/stable/dev-guide-gui-mysql-workbench/','/zh/tidb/dev/dev-guide-gui-mysql-workbench/','/zh/tidbcloud/dev-guide-gui-mysql-workbench/']
---

# 使用 MySQL Workbench 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[MySQL Workbench](https://www.mysql.com/products/workbench/) 是为 MySQL 数据库用户提供的 GUI 工具集。

> **警告**
>
> - 尽管由于 MySQL Workbench 兼容 MySQL，你可以使用 MySQL Workbench 连接到 TiDB，但 MySQL Workbench 并不完全支持 TiDB。由于 MySQL Workbench 将 TiDB 视为 MySQL，因此在使用过程中可能会遇到一些问题。
> - 建议使用其它 TiDB 完全支持的 GUI 工具进行连接，例如 DataGrip，DBeaver 以及 VS Code SQLTools。TiDB 完全支持的 GUI 工具的完整列表，参考 [TiDB 支持的第三方工具](/develop/dev-guide-third-party-support.md#gui)。

在本文档中，你可以学习如何使用 MySQL Workbench 连接到 TiDB。

> **注意**
>
> 本文档适用于 {{{ .starter }}}、{{{ .essential }}}、{{{ .premium }}}、TiDB Cloud Dedicated 和本地部署的 TiDB。

## 前置需求

为了能够顺利完成本文中的操作，你需要：

- [MySQL Workbench](https://dev.mysql.com/downloads/workbench/) **8.0.31** 或以上版本。
- 准备一个 TiDB 集群。

**如果你还没有 TiDB 集群，可以按如下方式创建一个：**

- （推荐方式）[创建 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md)。
- [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster)或[部署正式 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 连接到 TiDB

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

## 常见问题

### 如何处理连接超时错误 "Error Code: 2013. Lost connection to MySQL server during query"？

这个错误表示查询执行时间超过了超时限制。要解决这个问题，可以按照以下步骤调整超时设置：

1. 启动 MySQL Workbench 并打开 **Workbench Preferences** 页面。
2. 在 **SQL Editor** > **MySQL Session** 部分，调整 **DBMS connection read timeout interval (in seconds)** 的设置。该字段控制了 MySQL Workbench 在断开与服务器的连接之前查询可以执行的最长时间（以秒为单位）。

![MySQL Workbench: adjust timeout option in SQL Editor settings](/media/develop/mysql-workbench-adjust-sqleditor-read-timeout.jpg)

更多信息，可以参考 [MySQL Workbench 常见问题](https://dev.mysql.com/doc/workbench/en/workbench-faq.html)。

## 下一步

- 关于 MySQL Workbench 的更多使用方法，可以参考 [MySQL Workbench 官方文档](https://dev.mysql.com/doc/workbench/en/)。
- 你可以继续阅读[开发者文档](/develop/_index.md)，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。

## 需要帮助?

如果在开发的过程中遇到问题，可以在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问，或从 {{{ .company }}} 官方或 TiDB 社区[获取支持](/support.md)。
