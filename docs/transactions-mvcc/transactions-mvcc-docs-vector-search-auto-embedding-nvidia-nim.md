---
title: NVIDIA NIM Embeddings
summary: 了解如何在 TiDB Cloud 中使用 NVIDIA NIM embedding 模型。
aliases: ['/zh/tidbcloud/vector-search-auto-embedding-nvidia-nim/']
---

# NVIDIA NIM Embeddings

本文档介绍如何在 TiDB Cloud 中结合 [Auto Embedding](/ai/integrations/vector-search-auto-embedding-overview.md) 使用 NVIDIA NIM embedding 模型，通过文本查询实现语义搜索。

> **注意：**
>
> [Auto Embedding](/ai/integrations/vector-search-auto-embedding-overview.md) 仅适用于托管在 AWS 上的 {{{ .starter }}} 实例。

## 可用模型

托管在 NVIDIA NIM 上的 embedding 模型可通过 `nvidia_nim/` 前缀使用，前提是你自带 [NVIDIA NIM API key](https://build.nvidia.com/settings/api-keys)（BYOK）。

为方便起见，以下章节以一个流行模型为例，展示如何结合 Auto Embedding 使用。如需完整模型列表，请参见 [NVIDIA NIM Text-to-embedding Models](https://build.nvidia.com/models?filters=usecase%3Ausecase_text_to_embedding)。

## bge-m3

- 名称：`nvidia_nim/baai/bge-m3`
- 维度：1024
- 距离度量：Cosine，L2
- 最大输入文本 token 数：8,192
- 价格：由 NVIDIA 收费
- TiDB Cloud 托管：❌
- 支持 Bring Your Own Key（BYOK，由用户自行提供 API 密钥）：✅
- 文档：

示例：

```sql
SET @@GLOBAL.TIDB_EXP_EMBED_NVIDIA_NIM_API_KEY = 'your-nvidia-nim-api-key-here';

CREATE TABLE sample (
  `id`        INT,
  `content`   TEXT,
  `embedding` VECTOR(1024) GENERATED ALWAYS AS (EMBED_TEXT(
                "nvidia_nim/baai/bge-m3",
                `content`
              )) STORED
);

INSERT INTO sample
    (`id`, `content`)
VALUES
    (1, "Java: Object-oriented language for cross-platform development."),
    (2, "Java coffee: Bold Indonesian beans with low acidity."),
    (3, "Java island: Densely populated, home to Jakarta."),
    (4, "Java's syntax is used in Android apps."),
    (5, "Dark roast Java beans enhance espresso blends.");

SELECT `id`, `content` FROM sample
ORDER BY
  VEC_EMBED_COSINE_DISTANCE(
    embedding,
    "How to start learning Java programming?"
  )
LIMIT 2;
```

结果：

```
+------+----------------------------------------------------------------+
| id   | content                                                        |
+------+----------------------------------------------------------------+
|    1 | Java: Object-oriented language for cross-platform development. |
|    4 | Java's syntax is used in Android apps.                         |
+------+----------------------------------------------------------------+
```

## nv-embed-v1

本示例展示如何使用 `nvidia/nv-embed-v1` 模型创建向量表、插入文档并进行相似度搜索。

### 步骤 1：连接数据库

### 步骤 2：配置 API key

如果你使用需要身份验证的 NVIDIA NIM 模型，可以配置你的 API key。你可以通过 [NVIDIA Developer Program](https://developer.nvidia.com/nim) 免费访问 NIM API 端点，或在 [NVIDIA Build Platform](https://build.nvidia.com/settings/api-keys) 创建你的 API key：

### 步骤 3：创建向量表

创建包含向量字段的表，使用 NVIDIA NIM 模型生成 embedding：

### 步骤 4：向表中插入数据

### 步骤 5：搜索相似文档

## 另请参阅

- [Auto Embedding 概览](/ai/integrations/vector-search-auto-embedding-overview.md)
- [向量搜索](/ai/concepts/vector-search-overview.md)
- [向量函数与运算符](/ai/reference/vector-search-functions-and-operators.md)
- [混合搜索](/ai/guides/vector-search-hybrid-search.md)
