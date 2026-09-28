---
title: Gemini 向量嵌入
summary: 了解如何在 TiDB Cloud 中使用 Google Gemini 向量嵌入模型。
aliases: ['/zh/tidbcloud/vector-search-auto-embedding-gemini/']
---

# Gemini 向量嵌入

本文档介绍如何在 TiDB Cloud 中结合 [Auto Embedding](/ai/integrations/vector-search-auto-embedding-overview.md) 使用 Gemini 向量嵌入模型，通过文本查询实现语义搜索。

> **注意：**
>
> [Auto Embedding](/ai/integrations/vector-search-auto-embedding-overview.md) 仅适用于托管在 AWS 上的 {{{ .starter }}} 实例。

## 可用模型

如果你自带 Gemini API 密钥（BYOK），则所有 Gemini 模型均可通过 `gemini/` 前缀使用。例如：

**gemini-embedding-001**

- 名称：`gemini/gemini-embedding-001`
- 维度：128–3072（默认：3072）
- 距离度量：Cosine，L2
- 最大输入文本 token 数：2,048
- 价格：由 Google 收费
- 由 TiDB Cloud 托管：❌
- 支持 Bring Your Own Key（BYOK，由用户自行提供 API 密钥）：✅

完整可用模型列表请参见 [Gemini 文档](https://ai.google.dev/gemini-api/docs/embeddings)。

## 使用示例

以下示例展示如何创建向量表、插入文档，并使用 Google Gemini 向量嵌入模型进行相似度搜索。

### 步骤 1：连接数据库

### 步骤 2：配置 API 密钥

在 [Google AI Studio](https://makersuite.google.com/app/apikey) 创建你的 API 密钥，并自带密钥（BYOK）以使用向量嵌入服务。

### 步骤 3：创建向量表

创建一个包含向量字段的表，使用 `gemini-embedding-001` 模型生成 3072 维（默认）向量：

### 步骤 4：向表中插入数据

### 步骤 5：搜索相似文档

## 自定义向量嵌入维度

`gemini-embedding-001` 模型通过 Matryoshka Representation Learning (MRL) 支持灵活的维度。你可以在向量嵌入函数中指定所需的维度：

请根据你的性能需求和存储约束选择合适的维度。更高的维度可以提升准确性，但会占用更多存储和计算资源。

## 选项

所有 [Gemini 选项](https://ai.google.dev/gemini-api/docs/embeddings) 均可通过 `EMBED_TEXT()` 函数的 `additional_json_options` 参数进行设置。

**示例：指定任务类型以提升质量**

```sql
CREATE TABLE sample (
  `id`        INT,
  `content`   TEXT,
  `embedding` VECTOR(1024) GENERATED ALWAYS AS (EMBED_TEXT(
                "gemini/gemini-embedding-001",
                `content`,
                '{"task_type": "SEMANTIC_SIMILARITY"}'
              )) STORED
);
```

**示例：使用不同维度**

```sql
CREATE TABLE sample (
  `id`        INT,
  `content`   TEXT,
  `embedding` VECTOR(768) GENERATED ALWAYS AS (EMBED_TEXT(
                "gemini/gemini-embedding-001",
                `content`,
                '{"output_dimensionality": 768}'
              )) STORED
);
```

所有可用选项请参见 [Gemini 文档](https://ai.google.dev/gemini-api/docs/embeddings)。

## 另请参阅

- [Auto Embedding 概览](/ai/integrations/vector-search-auto-embedding-overview.md)
- [向量搜索](/ai/concepts/vector-search-overview.md)
- [向量函数与操作符](/ai/reference/vector-search-functions-and-operators.md)
- [混合搜索](/ai/guides/vector-search-hybrid-search.md)
