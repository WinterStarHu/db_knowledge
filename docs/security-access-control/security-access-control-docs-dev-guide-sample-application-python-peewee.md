---
title: 使用 peewee 连接到 TiDB
summary: 了解如何使用 peewee 连接到 TiDB。本文提供了使用 peewee 与 TiDB 交互的 Python 示例代码片段。
aliases: ['/zh/tidb/stable/dev-guide-sample-application-python-peewee/','/zh/tidb/dev/dev-guide-sample-application-python-peewee/','/zh/tidbcloud/dev-guide-sample-application-python-peewee/']
---

# 使用 peewee 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[peewee](https://github.com/coleifer/peewee) 为当前流行的开源 Python ORM (Object Relational Mapper) 之一。

本文档将展示如何使用 TiDB 和 peewee 来完成以下任务：

- 配置你的环境。
- 使用 peewee 连接到 TiDB。
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
git clone https://github.com/tidb-samples/tidb-python-peewee-quickstart.git
cd tidb-python-peewee-quickstart
```

### 第 2 步：安装依赖

运行以下命令，安装示例代码所需要的依赖（包括 peewee 和 PyMySQL）：

```bash
pip install -r requirements.txt
```

#### 为什么安装 PyMySQL？

peewee 是一个支持多种数据库的 ORM 库。它是对数据库的高层抽象，可以帮助开发者以更面向对象的方式编写 SQL 语句。但 peewee 并不提供数据库驱动，因此需要单独安装用于连接 TiDB 的驱动。本示例项目使用 [PyMySQL](/develop/dev-guide-sample-application-python-pymysql.md) 作为数据库驱动。PyMySQL 是一个与 TiDB 兼容的纯 Python 实现的 MySQL 客户端库，并可以在所有平台上安装。更多信息，参考 [peewee 官方文档](https://docs.peewee-orm.com/en/latest/peewee/database.html?highlight=mysql#using-mysql)。

### 第 3 步：配置连接信息

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

### 第 4 步：运行代码并查看结果

1. 运行下述命令，执行示例代码：

    ```bash
    python peewee_example.py
    ```

2. 查看 [`Expected-Output.txt`](https://github.com/tidb-samples/tidb-python-peewee-quickstart/blob/main/Expected-Output.txt)，并与你的程序输出进行比较。结果近似即为连接成功。

## 示例代码片段

你可参考以下关键代码片段，完成自己的应用开发。

完整代码及其运行方式，见代码仓库 [tidb-samples/tidb-python-peewee-quickstart](https://github.com/tidb-samples/tidb-python-peewee-quickstart)。

### 连接到 TiDB

```python
from peewee import MySQLDatabase

def get_db_engine():
    connect_params = {}
    if '${ca_path}':
        connect_params = {
            "ssl_verify_cert": True,
            "ssl_verify_identity": True,
            "ssl_ca": '${ca_path}',
        }
    return MySQLDatabase(
        '${tidb_db_name}',
        host='${tidb_host}',
        port='${tidb_port}',
        user='${tidb_user}',
        password='${tidb_password}',
        **connect_params,
    )
```

在使用该函数时，你需要将 `${tidb_host}`、`${tidb_port}`、`${tidb_user}`、`${tidb_password}`、`${tidb_db_name}` 以及 `${ca_path}` 替换为你的 TiDB 的实际值。

### 声明数据对象

```python
from peewee import Model, CharField, IntegerField

db = get_db_engine()

class BaseModel(Model):
    class Meta:
        database = db

class Player(BaseModel):
    name = CharField(max_length=32, unique=True)
    coins = IntegerField(default=0)
    goods = IntegerField(default=0)

    class Meta:
        table_name = "players"

    def __str__(self):
        return f"Player(name={self.name}, coins={self.coins}, goods={self.goods})"
```

更多信息参考 [peewee 模型与字段](https://docs.peewee-orm.com/en/latest/peewee/models.html)。

### 插入数据

```python
# 插入单个对象
Player.create(name="test", coins=100, goods=100)

# 插入多个对象
data = [
        {"name": "test1", "coins": 100, "goods": 100},
        {"name": "test2", "coins": 100, "goods": 100},
]
Player.insert_many(data).execute()
```

更多信息参考[插入数据](/develop/dev-guide-insert-data.md)。

### 查询数据

```python
# 查询所有对象
players = Player.select()

# 查询单个对象
player = Player.get(Player.name == "test")

# 查询多个对象
players = Player.select().where(Player.coins == 100)
```

更多信息参考[查询数据](/develop/dev-guide-get-data-from-single-table.md)。

### 更新数据

```python
# 更新单个对象
player = Player.get(Player.name == "test")
player.coins = 200
player.save()

# 批量更新多个对象
Player.update(coins=200).where(Player.coins == 100).execute()
```

更多信息参考[更新数据](/develop/dev-guide-update-data.md)。

### 删除数据

```python
# 删除单个对象
player = Player.get(Player.name == "test")
player.delete_instance()

# 批量删除多个对象
Player.delete().where(Player.coins == 100).execute()
```

更多信息参考[删除数据](/develop/dev-guide-delete-data.md)。

## 下一步

- 关于 peewee 的更多使用方法，可以参考 [peewee 官方文档](https://docs.peewee-orm.com/)。
- 你可以继续阅读开发者文档，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。

## 需要帮助?

- 在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问
- [提交 TiDB Cloud 工单](https://tidb.support.pingcap.com/servicedesk/customer/portals)
- [提交 TiDB 工单](/support.md)
