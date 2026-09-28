---
title: 使用 Spring Boot 连接到 TiDB
summary: 了解如何使用 Spring Boot 连接到 TiDB。本文提供了使用 Spring Boot 与 TiDB 交互的 Java 示例代码片段。
aliases: ['/zh/tidb/dev/dev-guide-sample-application-spring-boot', '/zh/tidb/dev/sample-application-spring-boot','/zh/tidb/stable/dev-guide-sample-application-java-spring-boot/','/zh/tidb/dev/dev-guide-sample-application-java-spring-boot/','/zh/tidbcloud/dev-guide-sample-application-java-spring-boot/']
---

# 使用 Spring Boot 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[Spring](https://spring.io/) 是当前比较流行的开源 Java 容器框架，本文选择 [Spring Boot](https://spring.io/projects/spring-boot) 作为使用 Spring 的方式。

本文档将展示如何使用 TiDB 和 [Spring Data JPA](https://spring.io/projects/spring-data-jpa) 及 [Hibernate](https://hibernate.org/orm/) 作为 JPA 提供者来完成以下任务：

- 配置你的环境。
- 使用 Spring Data JPA 与 Hibernate 连接到 TiDB。
- 构建并运行你的应用程序。你也可以参考[示例代码片段](#示例代码片段)，完成基本的 CRUD 操作。

> **注意**
>
> 本文档适用于 {{{ .starter }}}、{{{ .essential }}}、{{{ .premium }}}、TiDB Cloud Dedicated 和本地部署的 TiDB。

## 前置需求

- 推荐 **Java Development Kit** (JDK) **17** 及以上版本。你可以根据公司及个人需求，自行选择 [OpenJDK](https://openjdk.org/) 或 [Oracle JDK](https://www.oracle.com/hk/java/technologies/downloads/)。
- [Maven](https://maven.apache.org/install.html) **3.8** 及以上版本。
- [Git](https://git-scm.com/downloads)。
- TiDB 集群。如果你还没有 TiDB 集群，可以按照以下方式创建：
  - （推荐方式）[创建 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md#step-1-create-a-starter-instance)。
  - [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster)或[部署正式 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 运行代码并连接到 TiDB

本小节演示如何运行示例应用程序的代码，并连接到 TiDB。

### 第 1 步：克隆示例代码仓库到本地

运行以下命令，将示例代码仓库克隆到本地：

```bash
git clone https://github.com/tidb-samples/tidb-java-springboot-jpa-quickstart.git
cd tidb-java-springboot-jpa-quickstart
```

### 第 2 步：配置连接信息

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

### 第 3 步：运行代码并查看结果

1. 运行下述命令，启动示例代码编写的服务：

    ```shell
    make
    ```

2. 打开另一个终端，开启请求脚本：

    ```shell
    make request
    ```

3. 查看 [`Expected-Output.txt`](https://github.com/tidb-samples/tidb-java-springboot-jpa-quickstart/blob/main/Expected-Output.txt)，并与你的服务程序输出进行比较。结果近似即为连接成功。

## 示例代码片段

你可参考以下关键代码片段，完成自己的应用开发。

完整代码及其运行方式，见代码仓库 [tidb-java-springboot-jpa-quickstart](https://github.com/tidb-samples/tidb-java-springboot-jpa-quickstart/blob/main/README-zh.md)。

### 连接到 TiDB

编写配置文件 `application.yml`：

```yaml
spring:
  datasource:
    url: ${TIDB_JDBC_URL:jdbc:mysql://localhost:4000/test}
    username: ${TIDB_USER:root}
    password: ${TIDB_PASSWORD:}
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    show-sql: true
    database-platform: org.hibernate.dialect.TiDBDialect
    hibernate:
      ddl-auto: create-drop
```

请在配置后将环境变量 `TIDB_JDBC_URL`、`TIDB_USER` 和 `TIDB_PASSWORD` 设置为你的 TiDB 的实际值。此配置文件带有环境变量默认配置，即在不配置环境变量时，变量的值为：

- `TIDB_JDBC_URL`: `"jdbc:mysql://localhost:4000/test"`
- `TIDB_USER`: `"root"`
- `TIDB_PASSWORD`: `""`

### 数据管理

Spring Data JPA 通过 `@Entity` 注册数据实体，并绑定数据库的表。

```java
@Entity
@Table(name = "player_jpa")
public class PlayerBean {
}
```

`PlayerRepository` 通过继承 `JpaRepository` 接口，由 `JpaRepositoryFactoryBean` 为其自动注册对应的 Repository Bean。同时，`JpaRepository` 接口的默认实现类 `SimpleJpaRepository` 提供了增删改查函数的具体实现。

```java
@Repository
public interface PlayerRepository extends JpaRepository {
}
```

随后，在需要使用 `PlayerRepository` 的类中，你可以通过 `@Autowired` 自动装配，这样就可以直接使用增删改查函数了。示例代码如下：

```java
@Autowired
private PlayerRepository playerRepository;
```

### 插入或更新数据

```java
playerRepository.save(player);
```

更多信息参考[插入数据](/develop/dev-guide-insert-data.md)和[更新数据](/develop/dev-guide-update-data.md)。

### 查询数据

```java
PlayerBean player = playerRepository.findById(id).orElse(null);
```

更多信息参考[查询数据](/develop/dev-guide-get-data-from-single-table.md)。

### 删除数据

```java
playerRepository.deleteById(id);
```

更多信息参考[删除数据](/develop/dev-guide-delete-data.md)。

## 下一步

- 关于本文使用到的第三方库及框架，可以参考各自官方文档：

  - [Spring Framework 官方文档](https://spring.io/projects/spring-framework)
  - [Spring Boot 官方文档](https://spring.io/projects/spring-boot)
  - [Spring Data JPA 官方文档](https://spring.io/projects/spring-data-jpa)
  - [Hibernate 官方文档](https://hibernate.org/orm/documentation)
- 你可以继续阅读开发者文档，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。
- 我们还额外提供针对 Java 开发者的课程：[使用 Connector/J - TiDB v6](https://learn.pingkai.cn/learner/course/840002?utm_source=docs-cn-dev-guide) 及[在 TiDB 上开发应用的最佳实践 - TiDB v6](https://learn.pingkai.cn/learner/course/780002?utm_source=docs-cn-dev-guide)。

## 需要帮助?

- 在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问
- [提交 TiDB Cloud 工单](https://tidb.support.pingcap.com/servicedesk/customer/portals)
- [提交 TiDB 工单](/support.md)
