---
title: 集成向量搜索与 LangChain
summary: 学习如何将 TiDB 向量搜索集成到 LangChain。
aliases: ['/zh/tidb/stable/vector-search-integrate-with-langchain/','/zh/tidb/dev/vector-search-integrate-with-langchain/','/zh/tidbcloud/vector-search-integrate-with-langchain/']
---

# 集成向量搜索与 LangChain

本教程演示如何将 [TiDB 向量搜索](/ai/concepts/vector-search-overview.md) 集成到 [LangChain](https://python.langchain.com/)。

> **注意：**
>
> - 向量搜索功能目前为 beta 版本，可能会在未提前通知的情况下发生变更。如果你发现了 bug，可以在 GitHub 上提交 [issue](https://github.com/pingcap/tidb/issues)。
> - 向量搜索功能适用于 [TiDB Self-Managed](/overview.md)、[TiDB Cloud Starter](https://docs.pingcap.com/zh/tidbcloud/select-cluster-tier/#starter)、[TiDB Cloud Essential](https://docs.pingcap.com/zh/tidbcloud/select-cluster-tier/#essential) 和 [TiDB Cloud Dedicated](https://docs.pingcap.com/zh/tidbcloud/select-cluster-tier/#tidb-cloud-dedicated)。对于 TiDB Self-Managed 和 TiDB Cloud Dedicated，TiDB 版本需为 v8.4.0 或更高（推荐 v8.5.0 或更高）。

> **提示**
>
> 你可以在 LangChain 文档中查看完整的[示例代码](https://docs.langchain.com/oss/python/integrations/vectorstores/tidb_vector)。

## 前置条件

完成本教程，你需要：

- 已安装 [Python 3.8 或更高版本](https://www.python.org/downloads/)。
- 已安装 [Jupyter Notebook](https://jupyter.org/install)。
- 已安装 [Git](https://git-scm.com/downloads)。
- 一个 TiDB 集群。

**如果你还没有 TiDB 集群，可以按如下方式创建：**

- （推荐）[创建一个 {{{ .starter }}} 实例](/develop/dev-guide-build-cluster-in-cloud.md)。
- [部署本地测试 TiDB Self-Managed 集群](/quick-start-with-tidb.md#deploy-a-local-test-cluster) 或 [部署生产环境 TiDB Self-Managed 集群](/production-deployment-using-tiup.md)。

## 快速开始

本节将提供将 TiDB 向量搜索与 LangChain 集成以进行语义搜索的分步指导。

### 步骤 1. 新建 Jupyter Notebook 文件

在你选择的目录下，新建一个名为 `integrate_with_langchain.ipynb` 的 Jupyter Notebook 文件：

```shell
touch integrate_with_langchain.ipynb
```

### 步骤 2. 安装所需依赖

在你的项目目录下，运行以下命令安装所需依赖包：

```shell
!pip install langchain langchain-community
!pip install langchain-openai
!pip install pymysql
!pip install tidb-vector
```

在 Jupyter Notebook 中打开 `integrate_with_langchain.ipynb` 文件，然后添加以下代码以导入所需包：

```python
from langchain_community.document_loaders import TextLoader
from langchain_community.vectorstores import TiDBVectorStore
from langchain_openai import OpenAIEmbeddings
from langchain_text_splitters import CharacterTextSplitter
```

### 步骤 3. 配置环境

根据你选择的 TiDB 部署方式，配置环境变量。

### 步骤 4. 加载示例文档

#### 步骤 4.1 下载示例文档

在你的项目目录下，新建 `data/how_to/` 目录，并从 [langchain-ai/langchainjs](https://github.com/langchain-ai/langchainjs) GitHub 仓库下载示例文档 [`state_of_the_union.txt`](https://github.com/langchain-ai/langchainjs/blob/main/examples/state_of_the_union.txt)。

```shell
!mkdir -p 'data/how_to/'
!wget 'https://raw.githubusercontent.com/langchain-ai/langchainjs/refs/heads/main/examples/state_of_the_union.txt' -O 'data/how_to/state_of_the_union.txt'
```

#### 步骤 4.2 加载并切分文档

从 `data/how_to/state_of_the_union.txt` 加载示例文档，并使用 `CharacterTextSplitter` 将其切分为约 1,000 个字符的块。

```python
loader = TextLoader("data/how_to/state_of_the_union.txt")
documents = loader.load()
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
docs = text_splitter.split_documents(documents)
```

### 步骤 5. 嵌入并存储文档向量

TiDB 向量存储支持余弦距离（`cosine`）和欧氏距离（`l2`）两种向量相似度度量方式。默认策略为余弦距离。

以下代码将在 TiDB 中创建一个名为 `embedded_documents` 的表，该表已针对向量搜索进行了优化。

```python
embeddings = OpenAIEmbeddings()
vector_store = TiDBVectorStore.from_documents(
    documents=docs,
    embedding=embeddings,
    table_name="embedded_documents",
    connection_string=tidb_connection_string,
    distance_strategy="cosine",  # 默认，另一个选项为 "l2"
)
```

执行成功后，你可以直接在 TiDB 数据库中查看和访问 `embedded_documents` 表。

### 步骤 6. 执行向量搜索

本步骤演示如何在文档 `state_of_the_union.txt` 中搜索 “What did the president say about Ketanji Brown Jackson”。

```python
query = "What did the president say about Ketanji Brown Jackson"
```

#### 选项 1：使用 `similarity_search_with_score()`

`similarity_search_with_score()` 方法会计算文档与查询在向量空间中的距离。该距离作为相似度分数，由所选的 `distance_strategy` 决定。该方法返回分数最低的前 `k` 个文档。分数越低，文档与查询的相似度越高。

```python
docs_with_score = vector_store.similarity_search_with_score(query, k=3)
for doc, score in docs_with_score:
   print("-" * 80)
   print("Score: ", score)
   print(doc.page_content)
   print("-" * 80)
```

#### 选项 2：使用 `similarity_search_with_relevance_scores()`

`similarity_search_with_relevance_scores()` 方法返回相关性分数最高的前 `k` 个文档。分数越高，文档与查询的相似度越高。

```python
docs_with_relevance_score = vector_store.similarity_search_with_relevance_scores(query, k=2)
for doc, score in docs_with_relevance_score:
    print("-" * 80)
    print("Score: ", score)
    print(doc.page_content)
    print("-" * 80)
```

### 作为检索器使用

在 LangChain 中，[retriever](https://python.langchain.com/v0.2/docs/concepts/#retrievers) 是一个用于非结构化查询搜索文档的接口，功能比向量存储更丰富。以下代码演示如何将 TiDB 向量存储作为检索器使用。

```python
retriever = vector_store.as_retriever(
   search_type="similarity_score_threshold",
   search_kwargs={"k": 3, "score_threshold": 0.8},
)
docs_retrieved = retriever.invoke(query)
for doc in docs_retrieved:
   print("-" * 80)
   print(doc.page_content)
   print("-" * 80)
```

预期输出如下：

```
--------------------------------------------------------------------------------
Tonight. I call on the Senate to: Pass the Freedom to Vote Act. Pass the John Lewis Voting Rights Act. And while you’re at it, pass the Disclose Act so Americans can know who is funding our elections.

Tonight, I’d like to honor someone who has dedicated his life to serve this country: Justice Stephen Breyer—an Army veteran, Constitutional scholar, and retiring Justice of the United States Supreme Court. Justice Breyer, thank you for your service.

One of the most serious constitutional responsibilities a President has is nominating someone to serve on the United States Supreme Court.

And I did that 4 days ago, when I nominated Circuit Court of Appeals Judge Ketanji Brown Jackson. One of our nation’s top legal minds, who will continue Justice Breyer’s legacy of excellence.
--------------------------------------------------------------------------------
```

### 移除向量存储

如需移除已存在的 TiDB 向量存储，可使用 `drop_vectorstore()` 方法：

```python
vector_store.drop_vectorstore()
```

## 使用元信息过滤进行搜索

你可以通过元信息过滤，进一步筛选搜索结果，仅返回符合过滤条件的最近邻结果。

### 支持的元信息类型

TiDB 向量存储中的每个文档都可以携带元信息，结构为 JSON 对象的键值对。键始终为字符串，值可以是以下类型之一：

- 字符串
- 数值：整数型或浮点型
- 布尔型：`true` 或 `false`

例如，以下是一个有效的元信息负载：

```json
{
  "page": 12,
  "book_title": "Siddhartha"
}
```

### 元信息过滤语法

可用的过滤器包括：

- `$or`：匹配任意一个条件的向量。
- `$and`：同时匹配所有条件的向量。
- `$eq`：等于指定值。
- `$ne`：不等于指定值。
- `$gt`：大于指定值。
- `$gte`：大于等于指定值。
- `$lt`：小于指定值。
- `$lte`：小于等于指定值。
- `$in`：在指定值数组中。
- `$nin`：不在指定值数组中。

如果某文档的元信息如下：

```json
{
  "page": 12,
  "book_title": "Siddhartha"
}
```

以下元信息过滤器均可匹配该文档：

```json
{ "page": 12 }
```

```json
{ "page": { "$eq": 12 } }
```

```json
{
  "page": {
    "$in": [11, 12, 13]
  }
}
```

```json
{ "page": { "$nin": [13] } }
```

```json
{ "page": { "$lt": 11 } }
```

```json
{
  "$or": [{ "page": 11 }, { "page": 12 }],
  "$and": [{ "page": 12 }, { "page": 13 }]
}
```

在元信息过滤器中，TiDB 会将每个键值对视为独立的过滤子句，并使用 `AND` 逻辑运算符将这些子句组合。

### 示例

以下示例向 `TiDBVectorStore` 添加两个文档，并为每个文档添加 `title` 字段作为元信息：

```python
vector_store.add_texts(
    texts=[
        "TiDB Vector offers advanced, high-speed vector processing capabilities, enhancing AI workflows with efficient data handling and analytics support.",
        "TiDB Vector, starting as low as $10 per month for basic usage",
    ],
    metadatas=[
        {"title": "TiDB Vector functionality"},
        {"title": "TiDB Vector Pricing"},
    ],
)
```

预期输出如下：

```plain
[UUID('c782cb02-8eec-45be-a31f-fdb78914f0a7'),
 UUID('08dcd2ba-9f16-4f29-a9b7-18141f8edae3')]
```

使用元信息过滤器进行相似度搜索：

```python
docs_with_score = vector_store.similarity_search_with_score(
    "Introduction to TiDB Vector", filter={"title": "TiDB Vector functionality"}, k=4
)
for doc, score in docs_with_score:
    print("-" * 80)
    print("Score: ", score)
    print(doc.page_content)
    print("-" * 80)
```

预期输出如下：

```plain
--------------------------------------------------------------------------------
Score:  0.12761409169211535
TiDB Vector offers advanced, high-speed vector processing capabilities, enhancing AI workflows with efficient data handling and analytics support.
--------------------------------------------------------------------------------
```

## 高级用例示例：旅行社

本节演示将向量搜索与 LangChain 集成的旅行社场景。目标是为客户生成个性化旅行报告，帮助他们查找拥有特定设施（如干净的休息室和素食选项）的机场。

流程主要分为两步：

1. 对机场评论进行语义搜索，找出符合所需设施的机场代码。
2. 执行 SQL 查询，将这些代码与航线信息关联，突出显示符合用户偏好的航空公司和目的地。

### 准备数据

首先，创建用于存储机场航线数据的表：

```python
# 创建用于存储航班计划数据的表。
vector_store.tidb_vector_client.execute(
    """CREATE TABLE airplan_routes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        airport_code VARCHAR(10),
        airline_code VARCHAR(10),
        destination_code VARCHAR(10),
        route_details TEXT,
        duration TIME,
        frequency INT,
        airplane_type VARCHAR(50),
        price DECIMAL(10, 2),
        layover TEXT
    );"""
)

# 向 airplan_routes 和向量表插入一些示例数据。
vector_store.tidb_vector_client.execute(
    """INSERT INTO airplan_routes (
        airport_code,
        airline_code,
        destination_code,
        route_details,
        duration,
        frequency,
        airplane_type,
        price,
        layover
    ) VALUES
    ('JFK', 'DL', 'LAX', 'Non-stop from JFK to LAX.', '06:00:00', 5, 'Boeing 777', 299.99, 'None'),
    ('LAX', 'AA', 'ORD', 'Direct LAX to ORD route.', '04:00:00', 3, 'Airbus A320', 149.99, 'None'),
    ('EFGH', 'UA', 'SEA', 'Daily flights from SFO to SEA.', '02:30:00', 7, 'Boeing 737', 129.99, 'None');
    """
)
vector_store.add_texts(
    texts=[
        "Clean lounges and excellent vegetarian dining options. Highly recommended.",
        "Comfortable seating in lounge areas and diverse food selections, including vegetarian.",
        "Small airport with basic facilities.",
    ],
    metadatas=[
        {"airport_code": "JFK"},
        {"airport_code": "LAX"},
        {"airport_code": "EFGH"},
    ],
)
```

预期输出如下：

```plain
[UUID('6dab390f-acd9-4c7d-b252-616606fbc89b'),
 UUID('9e811801-0e6b-4893-8886-60f4fb67ce69'),
 UUID('f426747c-0f7b-4c62-97ed-3eeb7c8dd76e')]
```

### 执行语义搜索

以下代码搜索拥有干净设施和素食选项的机场：

```python
retriever = vector_store.as_retriever(
    search_type="similarity_score_threshold",
    search_kwargs={"k": 3, "score_threshold": 0.85},
)
semantic_query = "Could you recommend a US airport with clean lounges and good vegetarian dining options?"
reviews = retriever.invoke(semantic_query)
for r in reviews:
    print("-" * 80)
    print(r.page_content)
    print(r.metadata)
    print("-" * 80)
```

预期输出如下：

```plain
--------------------------------------------------------------------------------
Clean lounges and excellent vegetarian dining options. Highly recommended.
{'airport_code': 'JFK'}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Comfortable seating in lounge areas and diverse food selections, including vegetarian.
{'airport_code': 'LAX'}
--------------------------------------------------------------------------------
```

### 获取机场详细信息

从搜索结果中提取机场代码，并查询数据库获取详细航线信息：

```python
# 从元信息中提取机场代码
airport_codes = [review.metadata["airport_code"] for review in reviews]

# 执行查询获取机场详情
search_query = "SELECT * FROM airplan_routes WHERE airport_code IN :codes"
params = {"codes": tuple(airport_codes)}

airport_details = vector_store.tidb_vector_client.execute(search_query, params)
airport_details.get("result")
```

预期输出如下：

```plain
[(1, 'JFK', 'DL', 'LAX', 'Non-stop from JFK to LAX.', datetime.timedelta(seconds=21600), 5, 'Boeing 777', Decimal('299.99'), 'None'),
 (2, 'LAX', 'AA', 'ORD', 'Direct LAX to ORD route.', datetime.timedelta(seconds=14400), 3, 'Airbus A320', Decimal('149.99'), 'None')]
```

### 流程简化

你也可以通过单条 SQL 查询简化整个流程：

```python
search_query = f"""
    SELECT
        VEC_COSINE_DISTANCE(se.embedding, :query_vector) as distance,
        ar.*,
        se.document as airport_review
    FROM
        airplan_routes ar
    JOIN
        {TABLE_NAME} se ON ar.airport_code = JSON_UNQUOTE(JSON_EXTRACT(se.meta, '$.airport_code'))
    ORDER BY distance ASC
    LIMIT 5;
"""
query_vector = embeddings.embed_query(semantic_query)
params = {"query_vector": str(query_vector)}
airport_details = vector_store.tidb_vector_client.execute(search_query, params)
airport_details.get("result")
```

预期输出如下：

```plain
[(0.1219207353407008, 1, 'JFK', 'DL', 'LAX', 'Non-stop from JFK to LAX.', datetime.timedelta(seconds=21600), 5, 'Boeing 777', Decimal('299.99'), 'None', 'Clean lounges and excellent vegetarian dining options. Highly recommended.'),
 (0.14613754359804654, 2, 'LAX', 'AA', 'ORD', 'Direct LAX to ORD route.', datetime.timedelta(seconds=14400), 3, 'Airbus A320', Decimal('149.99'), 'None', 'Comfortable seating in lounge areas and diverse food selections, including vegetarian.'),
 (0.19840519342700513, 3, 'EFGH', 'UA', 'SEA', 'Daily flights from SFO to SEA.', datetime.timedelta(seconds=9000), 7, 'Boeing 737', Decimal('129.99'), 'None', 'Small airport with basic facilities.')]
```

### 清理数据

最后，通过删除创建的表来清理资源：

```python
vector_store.tidb_vector_client.execute("DROP TABLE airplan_routes")
```

预期输出如下：

```plain
{'success': True, 'result': 0, 'error': None}
```

## 相关文档

- [向量数据类型](/ai/reference/vector-search-data-types.md)
- [向量搜索索引](/ai/reference/vector-search-index.md)
