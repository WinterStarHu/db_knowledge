---
title: 使用 Navicat 连接到 TiDB
summary: 了解如何使用 Navicat 连接到 TiDB。
aliases: ['/zh/tidb/stable/dev-guide-gui-navicat/','/zh/tidb/dev/dev-guide-gui-navicat/','/zh/tidbcloud/dev-guide-gui-navicat/']
---

# 使用 Navicat 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[Navicat](https://www.navicat.com) 是为数据库用户提供的 GUI 工具集。本教程使用 [Navicat Premium](https://www.navicat.com/en/products/navicat-premium) 工具连接 TiDB。

在本文档中，你可以学习如何使用 Navicat 连接到 TiDB。

> **注意**
>
> 本文档适用于 {{{ .starter }}}、{{{ .essential }}}、{{{ .premium }}}、TiDB Cloud Dedicated 和本地部署的 TiDB。

## 前置需求

为了能够顺利完成本文中的操作，你需要：

- [Navicat Premium](https://www.navicat.com/en/products/navicat-premium) **17.1.6** 或以上版本。
- 一个 Navicat Premium 的付费账号。
- 准备一个 TiDB 集群。

**如果你还没有 TiDB 集群，可以按如下方式创建一个：**

- （推荐方式）[创建一个 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md)。
- [部署一个本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster)或[部署一个生产 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 连接到 TiDB

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

## 下一步

- 你可以继续阅读[开发者文档](/develop/_index.md)，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。

## 需要帮助?

如果在开发的过程中遇到问题，可以在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问，或从 {{{ .company }}} 官方或 TiDB 社区[获取支持](/support.md)。
