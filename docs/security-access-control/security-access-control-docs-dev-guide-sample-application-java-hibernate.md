---
title: 使用 Hibernate 连接到 TiDB
summary: 了解如何使用 Hibernate 连接到 TiDB。本文提供了使用 Hibernate 与 TiDB 交互的 Java 示例代码片段。
aliases: ['/zh/tidb/stable/dev-guide-sample-application-java-hibernate/','/zh/tidb/dev/dev-guide-sample-application-java-hibernate/','/zh/tidbcloud/dev-guide-sample-application-java-hibernate/']
---

# 使用 Hibernate 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[Hibernate](https://hibernate.org/orm/) 是当前比较流行的开源 Java 应用持久层框架。由于 TiDB 与 MySQL 高度兼容，建议使用 `org.hibernate.dialect.MySQLDialect` 作为 Hibernate 的方言 (Dialect)，以获得更好的长期兼容性。或者，也可以使用 TiDB 特定的方言 (`org.hibernate.community.dialect.TiDBDialect`)，该方言位于 [Hibernate community dialects](https://github.com/hibernate/hibernate-orm/tree/main/hibernate-community-dialects) 项目中，但该项目并非由 {{{ .company }}} 维护。如果你在使用 `MySQLDialect` 时遇到兼容性问题，可以在 GitHub 上提交 [issue](https://github.com/pingcap/tidb/issues)。

本文档将展示如何使用 TiDB 和 Hibernate 来完成以下任务：

- 配置你的环境。
- 使用 Hibernate 连接到 TiDB。
- 构建并运行你的应用程序。你也可以参考[示例代码片段](#示例代码片段)，完成基本的 CRUD 操作。

> **注意**
>
> 本文档适用于 {{{ .starter }}}、{{{ .essential }}}、{{{ .premium }}}、TiDB Cloud Dedicated 和本地部署的 TiDB。

## 前置需求

- 推荐 **Java Development Kit** (JDK) **17** 及以上版本。你可以根据公司及个人需求，自行选择 [OpenJDK](https://openjdk.org/) 或 [Oracle JDK](https://www.oracle.com/hk/java/technologies/downloads/)。
- [Maven](https://maven.apache.org/install.html) **3.8** 及以上版本。
- [Git](https://git-scm.com/downloads)。
- TiDB 集群。如果你还没有 TiDB 集群，可以按照以下方式创建：
  - （推荐方式）[创建 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md)。
  - [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster)或[部署正式 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 运行代码并连接到 TiDB

本小节演示如何运行示例应用程序的代码，并连接到 TiDB。

### 第 1 步：克隆示例代码仓库到本地

运行以下命令，将示例代码仓库克隆到本地：

```bash
git clone https://github.com/tidb-samples/tidb-java-hibernate-quickstart.git
cd tidb-java-hibernate-quickstart
```

### 第 2 步：配置连接信息

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

### 第 3 步：运行代码并查看结果

1. 运行下述命令，执行示例代码：

    ```shell
    make
    ```

2. 查看 [`Expected-Output.txt`](https://github.com/tidb-samples/tidb-java-hibernate-quickstart/blob/main/Expected-Output.txt)，并与你的程序输出进行比较。结果近似即为连接成功。

## 示例代码片段

你可参考以下关键代码片段，完成自己的应用开发。

完整代码及其运行方式，见代码仓库 [tidb-java-hibernate-quickstart](https://github.com/tidb-samples/tidb-java-hibernate-quickstart/blob/main/README-zh.md)。

### 连接到 TiDB

编写配置文件 `hibernate.cfg.xml`：

```xml
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

com.mysql.cj.jdbc.Driver
org.hibernate.dialect.MySQLDialect
${tidb_jdbc_url}
${tidb_user}
${tidb_password}
false

create-drop

true
true
```

请将 `${tidb_jdbc_url}`、`${tidb_user}`、`${tidb_password}` 等替换为你的 TiDB 的实际值。随后编写以下函数：

```java
public SessionFactory getSessionFactory() {
    return new Configuration()
            .configure("hibernate.cfg.xml")
            .addAnnotatedClass(${your_entity_class})
            .buildSessionFactory();
}
```

在使用该函数时，你需要替换 `${your_entity_class}` 为自己的数据实体类。如果你有多个实体类，需要添加多个 `.addAnnotatedClass(${your_entity_class})` 语句。此外，这仅是 Hibernate 的其中一种配置方式。在配置中遇到任何问题，或想了解更多关于 Hibernate 的信息，你可参考 [Hibernate 官方文档](https://hibernate.org/orm/documentation)。

### 插入或更新数据

```java
try (Session session = sessionFactory.openSession()) {
    session.persist(new PlayerBean("id", 1, 1));
}
```

更多信息参考[插入数据](/develop/dev-guide-insert-data.md)和[更新数据](/develop/dev-guide-update-data.md)。

### 查询数据

```java
try (Session session = sessionFactory.openSession()) {
    PlayerBean player = session.get(PlayerBean.class, "id");
    System.out.println(player);
}
```

更多信息参考[查询数据](/develop/dev-guide-get-data-from-single-table.md)。

### 删除数据

```java
try (Session session = sessionFactory.openSession()) {
    session.remove(new PlayerBean("id", 1, 1));
}
```

更多信息参考[删除数据](/develop/dev-guide-delete-data.md)。

## 与 `MySQLDialect` 的兼容性

在 TiDB 中使用 `MySQLDialect` 时，请注意以下行为：

### `SERIALIZABLE` 隔离级别

如果应用尝试将事务隔离级别设置为 `SERIALIZABLE`，TiDB 会返回如下错误：

```
The isolation level 'SERIALIZABLE' is not supported. Set tidb_skip_isolation_level_check=1 to skip this error
```

要避免该错误，请在服务端设置以下 TiDB 系统变量：

```sql
SET GLOBAL tidb_skip_isolation_level_check=1;
```

启用该变量后，TiDB 会接受请求中指定 `SERIALIZABLE` 而不返回错误。TiDB 内部仍然使用 `REPEATABLE-READ`，这是 TiDB 所支持的最强事务隔离级别。更多信息，请参见 [`tidb_skip_isolation_level_check`](/system-variables.md#tidb_skip_isolation_level_check)。

> **注意：**
>
> 社区版的 `TiDBDialect` 会自动处理此行为，通过跳过依赖 `SERIALIZABLE` 隔离级别的相关特性来避免问题。

### `CHECK` 约束

Hibernate 的 [`@Check`](https://docs.hibernate.org/orm/6.5/javadocs/org/hibernate/annotations/Check.html) 注解会生成 DDL `CHECK` 约束。[MySQL 8.0.16 及之后版本](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html) 默认会强制执行这些约束。但在 TiDB 中，如果没有显式启用，则不会强制执行。

要在 TiDB 中启用 `CHECK` 约束的强制执行，请设置以下系统变量：

```sql
SET GLOBAL tidb_enable_check_constraint=ON;
```

如果未启用该设置，TiDB 会接受 `CHECK` 约束的语法但不会强制执行，这可能导致数据完整性问题。更多信息，请参见 [`CHECK` 约束](/constraints.md#check-约束)。

## 下一步

- 关于 Hibernate 的更多使用方法，可以参考 [Hibernate 官方文档](https://hibernate.org/orm/documentation)。
- 你可以继续阅读开发者文档，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。
- 我们还额外提供针对 Java 开发者的课程：[使用 Connector/J - TiDB v6](https://learn.pingkai.cn/learner/course/840002?utm_source=docs-cn-dev-guide) 及[在 TiDB 上开发应用的最佳实践 - TiDB v6](https://learn.pingkai.cn/learner/course/780002?utm_source=docs-cn-dev-guide)。

## 需要帮助?

- 在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问
- [提交 TiDB Cloud 工单](https://tidb.support.pingcap.com/servicedesk/customer/portals)
- [提交 TiDB 工单](/support.md)
