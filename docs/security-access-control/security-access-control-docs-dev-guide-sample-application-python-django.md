---
title: 使用 Django 连接到 TiDB
summary: 了解如何使用 Django 连接到 TiDB。本文提供了使用 Django 与 TiDB 交互的 Python 示例代码片段。
aliases: ['/zh/tidb/dev/dev-guide-sample-application-django','/zh/tidb/stable/dev-guide-sample-application-python-django/','/zh/tidb/dev/dev-guide-sample-application-python-django/','/zh/tidbcloud/dev-guide-sample-application-python-django/']
---

# 使用 Django 连接到 TiDB

TiDB 是一个兼容 MySQL 的数据库。[Django](https://www.djangoproject.com/) 为当前流行的 Python Web 框架之一，它内部实现了一个强大的 ORM (Object Relational Mapper) 系统。

本文档将展示如何使用 TiDB 和 Django 来完成以下任务：

- 配置你的环境。
- 使用 Django 连接到 TiDB。
- 构建并运行你的应用程序。你也可以参考[示例代码片段](#示例代码片段)，完成基本的 CRUD 操作。

> **注意**
>
> 本文档适用于 {{{ .starter }}}、{{{ .essential }}}、{{{ .premium }}}、TiDB Cloud Dedicated 和 TiDB Self-Managed。

## 前置需求

- 推荐 [Python 3.8](https://www.python.org/downloads/) 及以上版本。
- [Git](https://git-scm.com/downloads)。
- TiDB 集群。如果你还没有 TiDB 集群，可以按照以下方式创建：
  - （推荐方式）[创建 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md)。
  - [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster)或[部署正式 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 运行代码并连接到 TiDB

本小节演示如何运行示例应用程序的代码，并连接到 TiDB。

### 第 1 步：克隆示例代码仓库到本地

运行以下命令，将示例代码仓库克隆到本地：

```bash
git clone https://github.com/tidb-samples/tidb-python-django-quickstart.git
cd tidb-python-django-quickstart
```

### 第 2 步：安装依赖

运行以下命令，安装示例代码所需要的依赖（包括 Django、django-tidb 和 mysqlclient）：

```bash
pip install -r requirements.txt
```

如果你在安装 mysqlclient 时遇到问题，请参考 [mysqlclient 官方文档](https://github.com/PyMySQL/mysqlclient#install)。

#### `django-tidb` 是什么？

`django-tidb` 是一个为 Django 提供的 TiDB 适配器，它解决了 TiDB 与 Django 之间的兼容性问题。

安装 `django-tidb` 时，请选择与你的 Django 版本匹配的版本。例如，如果你使用的是 `django==4.2.*`，则应安装 `django-tidb>=4.2.0,<4.3.0`，其中 minor 版本号不需要完全相同。建议使用最新的 minor 版本。

更多信息，请参考 [django-tidb 仓库](https://github.com/pingcap/django-tidb)。

### 第 3 步：配置连接信息

根据不同的 TiDB 部署方式，使用不同的方法连接到 TiDB。

### 第 4 步：初始化数据库

在示例项目根目录执行以下命令，初始化数据库：

```shell
python manage.py migrate
```

```shell
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sample_project, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying sample_project.0001_initial... OK
  Applying sessions.0001_initial... OK
```

### 第 5 步：运行示例应用程序

1. 在开发模式下运行示例应用程序：

    ```shell
    python manage.py runserver
    ```

应用程序默认在 `8000` 端口上运行。如果你想要使用其他端口号，可以在命令后添加端口号，例如：

    ```shell
    python manage.py runserver 8080
    ```

2. 打开浏览器，在地址栏输入 `http://localhost:8000/`，访问示例应用程序，你可以进行以下操作：

  - 创建一个新的 Player
  - 批量创建 Player
  - 查看所有的 Player
  - 更新 Player
  - 删除 Player
  - 在两个 Player 之间交易物品

## 示例代码片段

你可参考以下关键代码片段，完成自己的应用开发。

完整代码及其运行方式，见代码仓库 [tidb-samples/tidb-python-django-quickstart](https://github.com/tidb-samples/tidb-python-django-quickstart)。

### 配置数据库连接

打开 `sample_project/settings.py` 文件，添加以下配置：

```python
DATABASES = {
    "default": {
        "ENGINE": "django_tidb",
        "HOST": '${tidb_host}',
        "PORT": '${tidb_port}',
        "USER": '${tidb_user}',
        "PASSWORD": '${tidb_password}',
        "NAME": '${tidb_db_name}',
        "OPTIONS": {
            "charset": "utf8mb4",
        },
    }
}

TIDB_CA_PATH = '${ca_path}'
if TIDB_CA_PATH:
    DATABASES["default"]["OPTIONS"]["ssl_mode"] = "VERIFY_IDENTITY"
    DATABASES["default"]["OPTIONS"]["ssl"] = {
        "ca": TIDB_CA_PATH,
    }
```

在使用该函数时，你需要将 `${tidb_host}`、`${tidb_port}`、`${tidb_user}`、`${tidb_password}`、`${tidb_db_name}` 以及 `${ca_path}` 替换为你的 TiDB 的实际值。

### 声明数据对象

```python
from django.db import models

class Player(models.Model):
    name = models.CharField(max_length=32, blank=False, null=False)
    coins = models.IntegerField(default=100)
    goods = models.IntegerField(default=1)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
```

更多信息参考 [Django 模型](https://docs.djangoproject.com/en/dev/topics/db/models/)。

### 插入数据

```python
# 插入单个对象
player = Player.objects.create(name="player1", coins=100, goods=1)

# 批量插入多个对象
Player.objects.bulk_create([
    Player(name="player1", coins=100, goods=1),
    Player(name="player2", coins=200, goods=2),
    Player(name="player3", coins=300, goods=3),
])
```

更多信息参考[插入数据](/develop/dev-guide-insert-data.md)。

### 查询数据

```python
# 查询单个对象
player = Player.objects.get(name="player1")

# 查询多个对象
filtered_players = Player.objects.filter(name="player1")

# 查询所有对象
all_players = Player.objects.all()
```

更多信息参考[查询数据](/develop/dev-guide-get-data-from-single-table.md)。

### 更新数据

```python
# 更新单个对象
player = Player.objects.get(name="player1")
player.coins = 200
player.save()

# 批量更新多个对象
Player.objects.filter(coins=100).update(coins=200)
```

更多信息参考[更新数据](/develop/dev-guide-update-data.md)。

### 删除数据

```python
# 删除单个对象
player = Player.objects.get(name="player1")
player.delete()

# 批量删除多个对象
Player.objects.filter(coins=100).delete()
```

更多信息参考[删除数据](/develop/dev-guide-delete-data.md)。

## 下一步

- 关于 Django 的更多使用方法，可以参考 [Django 官方文档](https://www.djangoproject.com/)。
- 你可以继续阅读开发者文档，以获取更多关于 TiDB 应用开发的最佳实践。例如：[插入数据](/develop/dev-guide-insert-data.md)、[更新数据](/develop/dev-guide-update-data.md)、[删除数据](/develop/dev-guide-delete-data.md)、[单表读取](/develop/dev-guide-get-data-from-single-table.md)、[事务](/develop/dev-guide-transaction-overview.md)、[SQL 性能优化](/develop/dev-guide-optimize-sql-overview.md)等。
- 如果你更倾向于参与课程进行学习，我们也提供专业的 [TiDB 开发者课程](https://pingkai.cn/learn)支持，并在考试后提供相应的[资格认证](https://learn.pingkai.cn/learner/certification-center)。

## 需要帮助?

- 在 [AskTUG 论坛](https://pingkai.cn/tidbcommunity/forum/?utm_source=docs-cn-dev-guide) 上提问
- [提交 TiDB Cloud 工单](https://tidb.support.pingcap.com/servicedesk/customer/portals)
- [提交 TiDB 工单](/support.md)
