---
title: 集成 TiDB 向量搜索与 SQLAlchemy
summary: 学习如何将 TiDB 向量搜索与 SQLAlchemy 集成，以存储嵌入向量并执行语义搜索。
aliases: ['/zh/tidb/stable/vector-search-integrate-with-sqlalchemy/','/zh/tidb/dev/vector-search-integrate-with-sqlalchemy/','/zh/tidbcloud/vector-search-integrate-with-sqlalchemy/']
---

# 集成 TiDB 向量搜索与 SQLAlchemy

本教程将指导你如何使用 [SQLAlchemy](https://www.sqlalchemy.org/) 与 [TiDB 向量搜索](/ai/concepts/vector-search-overview.md) 进行交互，存储嵌入向量，并执行向量搜索查询。

> **注意：**
>
> - 向量搜索功能目前为 beta 版本，可能会在无提前通知的情况下发生变更。如果你发现了 bug，可以在 GitHub 上提交 [issue](https://github.com/pingcap/tidb/issues)。
> - 向量搜索功能适用于 [TiDB Self-Managed](/overview.md)、[TiDB Cloud Starter](https://docs.pingcap.com/zh/tidbcloud/select-cluster-tier/#starter)、[TiDB Cloud Essential](https://docs.pingcap.com/zh/tidbcloud/select-cluster-tier/#essential) 和 [TiDB Cloud Dedicated](https://docs.pingcap.com/zh/tidbcloud/select-cluster-tier/#tidb-cloud-dedicated)。对于 TiDB Self-Managed 和 TiDB Cloud Dedicated，TiDB 版本需为 v8.4.0 或更高（推荐 v8.5.0 及以上）。

## 前置条件

完成本教程，你需要：

- 已安装 [Python 3.8 或更高版本](https://www.python.org/downloads)。
- 已安装 [Git](https://git-scm.com/downloads)。
- 一个 TiDB 集群。

**如果你还没有 TiDB 集群，可以按如下方式创建：**

- （推荐）[创建一个 TiDB Cloud {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md)。
- [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster) 或 [部署生产环境 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 运行示例应用

你可以按照以下步骤快速学习如何将 TiDB 向量搜索与 SQLAlchemy 集成。

### 第 1 步：克隆仓库

将 `tidb-vector-python` 仓库克隆到本地：

```shell
git clone https://github.com/pingcap/tidb-vector-python.git
```

### 第 2 步：创建虚拟环境

为你的项目创建一个虚拟环境：

```bash
cd tidb-vector-python/examples/orm-sqlalchemy-quickstart
python3 -m venv .venv
source .venv/bin/activate
```

### 第 3 步：安装所需依赖

为示例项目安装所需依赖：

```bash
pip install -r requirements.txt
```

或者，你也可以为你的项目单独安装以下包：

```bash
pip install pymysql python-dotenv sqlalchemy tidb-vector
```

### 第 4 步：配置环境变量

根据你选择的 TiDB 部署方式配置环境变量。

### 第 5 步：运行示例

```bash
python sqlalchemy-quickstart.py
```

示例输出：

```text
Get 3-nearest neighbor documents:
  - distance: 0.00853986601633272
    document: fish
  - distance: 0.12712843905603044
    document: dog
  - distance: 0.7327387580875756
    document: tree
Get documents within a certain distance:
  - distance: 0.00853986601633272
    document: fish
  - distance: 0.12712843905603044
    document: dog
```

## 示例代码片段

你可以参考以下示例代码片段开发你的应用。

### 创建向量表

#### 连接到 TiDB {#connect-to-tidb}

```python
import os
import dotenv

from sqlalchemy import Column, Integer, create_engine, Text
from sqlalchemy.orm import declarative_base, Session
from tidb_vector.sqlalchemy import VectorType

dotenv.load_dotenv()

tidb_connection_string = os.environ['TIDB_DATABASE_URL']
engine = create_engine(tidb_connection_string)
```

#### 定义向量列

创建一个包含名为 `embedding` 的 3 维向量列的表。

```python
Base = declarative_base()

class Document(Base):
    __tablename__ = 'sqlalchemy_demo_documents'
    id = Column(Integer, primary_key=True)
    content = Column(Text)
    embedding = Column(VectorType(3))
```

### 存储带嵌入向量的文档

```python
with Session(engine) as session:
   session.add(Document(content="dog", embedding=[1, 2, 1]))
   session.add(Document(content="fish", embedding=[1, 2, 4]))
   session.add(Document(content="tree", embedding=[1, 0, 0]))
   session.commit()
```

### 搜索最近邻文档

基于余弦距离函数，搜索与查询向量 `[1, 2, 3]` 语义最接近的前 3 个文档。

```python
with Session(engine) as session:
   distance = Document.embedding.cosine_distance([1, 2, 3]).label('distance')
   results = session.query(
      Document, distance
   ).order_by(distance).limit(3).all()
```

### 搜索距离在指定范围内的文档

搜索与查询向量 `[1, 2, 3]` 余弦距离小于 0.2 的文档。

```python
with Session(engine) as session:
    distance = Document.embedding.cosine_distance([1, 2, 3]).label('distance')
    results = session.query(
        Document, distance
    ).filter(distance < 0.2).order_by(distance).limit(3).all()
```

## 另请参阅

- [向量数据类型](/ai/reference/vector-search-data-types.md)
- [向量搜索索引](/ai/reference/vector-search-index.md)
