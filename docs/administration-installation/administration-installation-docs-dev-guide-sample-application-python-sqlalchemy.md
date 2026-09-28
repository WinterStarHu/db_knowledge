---
title: 使用 SQLAlchemy 连接到 TiDB
summary: 了解如何使用 SQLAlchemy 连接到 TiDB。本文提供了使用 SQLAlchemy 与 TiDB 交互的 Python 示例代码片段。
aliases: ['/zh/tidb/stable/dev-guide-sample-application-python-sqlalchemy/','/zh/tidb/dev/dev-guide-sample-application-python-sqlalchemy/','/zh/tidbcloud/dev-guide-sample-application-python-sqlalchemy/']
---

# 使用 SQLAlchemy 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[SQLAlchemy](https://www.sqlalchemy.org/) 为当前流行的开源 Python ORM (Object Relational Mapper) 之一。

本文档将展示如何使用 TiDB 和 SQLAlchemy 来完成以下任务：

- 配置你的环境。
- 使用 SQLAlchemy 连接到 TiDB。
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
git clone https://github.com/tidb-samples/tidb-python-sqlalchemy-quickstart.git
cd tidb-python-sqlalchemy-quickstart
```

### 第 2 步：安装依赖

运行以下命令，安装示例代码所需要的依赖（包括 SQLAlchemy 和 PyMySQL）：

```bash
pip install -r requirements.txt
```

#### 为什么安装 PyMySQL？

SQLAlchemy 是一个支持多种数据库的 ORM 库。它是对数据库的高层抽象，可以帮助开发者以更面向对象的方式编写 SQL 语句。但 SQLAlchemy 并不提供数据库驱动，因此需要单独安装用于连接 TiDB 的驱动。本示例项目使用 PyMySQL 作为数据库驱动。PyMySQL 是一个与 TiDB 兼容的纯 Python 实现的 MySQL 客户端库，并可以在所有平台上安装。

你也可以使用其他数据库驱动，例如 [mysqlclient](https://github.com/PyMySQL/mysqlclient) 以及 [mysql-connector-python](https://dev.mysql.com/doc/connector-python/en/)。但是它们不是纯 Python 库，需要安装对应的 C/C++ 编译器和 MySQL 客户端库进行编译。更多信息，参考 [SQLAlchemy 官方文档](https://docs.sqlalchemy.org/en/20/core/engines.html#mysql)。

### 第 3 步：配置连接信息

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

### 第 4 步：运行代码并查看结果

1. 运行下述命令，执行示例代码：

    ```bash
    python sqlalchemy_example.py
    ```

2. 查看 [`Expected-Output.txt`](https://github.com/tidb-samples/tidb-python-sqlalchemy-quickstart/blob/main/Expected-Output.txt)，并与你的程序输出进行比较。结果近似即为连接成功。

## 示例代码片段

你可参考以下关键代码片段，完成自己的应用开发。

完整代码及其运行方式，见代码仓库 [tidb-samples/tidb-python-sqlalchemy-quickstart](https://github.com/tidb-samples/tidb-python-sqlalchemy-quickstart)。

### 连接到 TiDB

```python
from sqlalchemy import create_engine, URL
from sqlalchemy.orm import sessionmaker

def get_db_engine():
    connect_args = {}
    if ${ca_path}:
        connect_args = {
            "ssl_verify_cert": True,
            "ssl_verify_identity": True,
            "ssl_ca": ${ca_path},
        }
    return create_engine(
        URL.create(
            drivername="mysql+pymysql",
            username=${tidb_user},
            password=${tidb_password},
            host=${tidb_host},
            port=${tidb_port},
            database=${tidb_db_name},
        ),
        connect_args=connect_args,
    )

engine = get_db_engine()
Session = sessionmaker(bind=engine)
```

在使用该函数时，你需要将 `${tidb_host}`、`${tidb_port}`、`${tidb_user}`、`${tidb_password}`、`${tidb_db_name}` 以及 `${ca_path}` 替换为你的 TiDB 的实际值。

### 声明数据对象

```python
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Player(Base):
    id = Column(Integer, primary_key=True)
    name = Column(String(32), unique=True)
    coins = Column(Integer)
    goods = Column(Integer)

    __tablename__ = "players"
```

更多信息参考 [SQLAlchemy 声明式映射表](https://docs.sqlalchemy.org/en/20/orm/declarative_mapping.html)。

### 插入数据

```python
with Session() as session:
    player = Player(name="test", coins=100, goods=100)
    session.add(player)
    session.commit()
```

更多信息参考[插入数据](/develop/dev-guide-insert-data.md)以及 [SQLAlchemy Query](https://docs.sqlalchemy.org/en/20/orm/queryguide/index.html)。

### 查询数据

```python
with Session() as session:
    player = session.query(Player).filter_by(name == "test").one()
    print(player)
```

更多信息参考[查询数据](/develop/dev-guide-get-data-from-single-table.md)以及 [SQLAlchemy Query](https://docs.sqlalchemy.org/en/20/orm/queryguide/index.html)。

### 更新数据

```python
with Session() as session:
    player = session.query(Player).filter_by(name == "test").one()
    player.coins = 200
    session.commit()
```

更多信息参考[更新数据](/develop/dev-guide-update-data.md)以及 [SQLAlchemy Query](https://docs.sqlalchemy.org/en/20/orm/queryguide/index.html)。

### 删除数据

```python
with Session() as session:
    player = session.query(Player).filter_by(name == "test").one()
    session.delete(player)
    session.commit()
```

更多信息参考[删除数据](/develop/dev-guide-delete-data.md)以及 [SQLAlchemy Query](https://docs.sqlalchemy.org/en/20/orm/queryguide/index.html)。

## 下一步

- 关于 SQLAlchemy 的更多使用方法，可以参考 [SQLAlchemy 官方文档](https://www.sqlalchemy.org/)。
- 你可以继续阅读开发者文档，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。

## 需要帮助?

- 在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问
- [提交 TiDB Cloud 工单](https://tidb.support.pingcap.com/servicedesk/customer/portals)
- [提交 TiDB 工单](/support.md)
