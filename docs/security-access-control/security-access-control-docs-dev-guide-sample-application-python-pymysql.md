---
title: 使用 PyMySQL 连接到 TiDB
summary: 了解如何使用 PyMySQL 连接到 TiDB。本文提供了使用 PyMySQL 与 TiDB 交互的 Python 示例代码片段。
aliases: ['/zh/tidb/stable/dev-guide-sample-application-python-pymysql/','/zh/tidb/dev/dev-guide-sample-application-python-pymysql/','/zh/tidbcloud/dev-guide-sample-application-python-pymysql/']
---

# 使用 PyMySQL 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[PyMySQL](https://github.com/PyMySQL/PyMySQL) 为当前流行的开源 Python Driver 之一。

本文档将展示如何使用 TiDB 和 PyMySQL 来完成以下任务：

- 配置你的环境。
- 使用 PyMySQL 连接到 TiDB。
- 构建并运行你的应用程序。你也可以参考[示例代码片段](#示例代码片段)，完成基本的 CRUD 操作。

> **注意**
>
> 本文档适用于 {{{ .starter }}}、{{{ .essential }}}、{{{ .premium }}}、TiDB Cloud Dedicated 和 TiDB Self-Managed。

## 前置需求

- 推荐 [Python 3.8](https://www.python.org/downloads/) 及以上版本。
- [Git](https://git-scm.com/downloads)。
- TiDB 集群。如果你还没有 TiDB 集群，可以按照以下方式创建：
  - （推荐方式）[创建 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md#step-1-create-a-starter-instance)。
  - [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster)或[部署正式 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 运行代码并连接到 TiDB

本小节演示如何运行示例应用程序的代码，并连接到 TiDB。

### 第 1 步：克隆示例代码仓库到本地

运行以下命令，将示例代码仓库克隆到本地：

```bash
git clone https://github.com/tidb-samples/tidb-python-pymysql-quickstart.git
cd tidb-python-pymysql-quickstart
```

### 第 2 步：安装依赖

运行以下命令，安装示例代码所需要的依赖（包括 `pymysql`）：

```bash
pip install -r requirements.txt
```

### 第 3 步：配置连接信息

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

### 第 4 步：运行代码并查看结果

1. 运行下述命令，执行示例代码：

    ```bash
    python pymysql_example.py
    ```

2. 查看 [`Expected-Output.txt`](https://github.com/tidb-samples/tidb-python-pymysql-quickstart/blob/main/Expected-Output.txt)，并与你的程序输出进行比较。结果近似即为连接成功。

## 示例代码片段

你可参考以下关键代码片段，完成自己的应用开发。

完整代码及其运行方式，见代码仓库 [tidb-samples/tidb-python-pymysql-quickstart](https://github.com/tidb-samples/tidb-python-pymysql-quickstart)。

### 连接到 TiDB

```python
from pymysql import Connection
from pymysql.cursors import DictCursor

def get_connection(autocommit: bool = True) -> Connection:
    config = Config()
    db_conf = {
        "host": ${tidb_host},
        "port": ${tidb_port},
        "user": ${tidb_user},
        "password": ${tidb_password},
        "database": ${tidb_db_name},
        "autocommit": autocommit,
        "cursorclass": DictCursor,
    }

    if ${ca_path}:
        db_conf["ssl_verify_cert"] = True
        db_conf["ssl_verify_identity"] = True
        db_conf["ssl_ca"] = ${ca_path}

    return pymysql.connect(**db_conf)
```

在使用该函数时，你需要将 `${tidb_host}`、`${tidb_port}`、`${tidb_user}`、`${tidb_password}`、`${tidb_db_name}` 以及 `${ca_path}` 替换为你的 TiDB 的实际值。

### 插入数据

```python
with get_connection(autocommit=True) as conn:
    with conn.cursor() as cur:
        player = ("1", 1, 1)
        cur.execute("INSERT INTO players (id, coins, goods) VALUES (%s, %s, %s)", player)
```

更多信息参考[插入数据](/develop/dev-guide-insert-data.md)。

### 查询数据

```python
with get_connection(autocommit=True) as conn:
    with conn.cursor() as cur:
        cur.execute("SELECT count(*) FROM players")
        print(cursor.fetchone()["count(*)"])
```

更多信息参考[查询数据](/develop/dev-guide-get-data-from-single-table.md)。

### 更新数据

```python
with get_connection(autocommit=True) as conn:
    with conn.cursor() as cur:
        player_id, amount, price = "1", 1, 50
        cur.execute(
            "UPDATE players SET goods = goods + %s, coins = coins + %s WHERE id = %s",
            (-amount, price, player_id),
        )
```

更多信息参考[更新数据](/develop/dev-guide-update-data.md)。

### 删除数据

```python
with get_connection(autocommit=True) as conn:
    with conn.cursor() as cur:
        player_id = "1"
        cur.execute("DELETE FROM players WHERE id = %s", player_id)
```

更多信息参考[删除数据](/develop/dev-guide-delete-data.md)。

## 注意事项

### 使用驱动程序还是 ORM 框架？

Python 驱动程序提供对数据库的底层访问，但要求开发者：

- 手动建立和释放数据库连接
- 手动管理数据库事务
- 手动将数据行（在 pymysql 中表示为元组 (tuple) 或者字典 (dict)）映射为数据对象

建议仅在需要编写复杂的 SQL 语句时使用驱动程序。其他情况下，建议使用 [ORM](https://zh.wikipedia.org/wiki/对象关系映射) 框架进行开发，例如 [SQLAlchemy](/develop/dev-guide-sample-application-python-sqlalchemy.md)、[Peewee](/develop/dev-guide-sample-application-python-peewee.md) 和 [Django](/develop/dev-guide-sample-application-python-django.md)。ORM 可以帮助你：

- 减少管理连接和事务的[模板代码](https://en.wikipedia.org/wiki/Boilerplate_code)
- 使用数据对象代替大量 SQL 语句来操作数据

## 下一步

- 关于 PyMySQL 的更多使用方法，可以参考 [PyMySQL 官方文档](https://pymysql.readthedocs.io)。
- 你可以继续阅读开发者文档，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。

## 需要帮助?

- 在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问
- [提交 TiDB Cloud 工单](https://tidb.support.pingcap.com/servicedesk/customer/portals)
- [提交 TiDB 工单](/support.md)
