# AI Function-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/ai-function

AI Function-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

AI和智能体

快速入门

产品计费

动态与公告

用户指南

开发指南

SQL调优指南

技术白皮书

性能白皮书

最佳实践

分布式常见问题

安全合规

API参考

错误码

术语表

相关协议

PolarDB-X 1.0（DRDS）

PolarDB分布式轻量版

首页

云原生数据库 PolarDB

云原生数据库PolarDB分布式版

AI和智能体

AI Function

AI Function

更新时间：

复制 MD 格式

产品详情 我的收藏

云原生数据库PolarDB分布式版AI Function 提供包括大语言模型（Large Language Model，LLM）文本生成、向量化（Embedding）、语义相似度、交叉注意力精排、零样本分类、结构化抽取、文档解析、多模态向量化等一系列内置 SQL 函数。无需引入任何 AI SDK 或搭建外部推理服务，使用标准 SQL 调用即可完成企业级知识库检索、文本理解、推理生成等 AI 场景。

适用范围

已开通PolarDB-X实例，且实例版本满足以下要求：

企业版实例：V2.6.0.5.4.21-20260629及之后。

标准版实例：polardb-2.6.0_standard_xcluster8.4.21-20260709及之后。

说明

实例版本的规则说明，请参见版本说明。

实例版本的查看方式，请参见查看实例版本。

已创建 AI 网关节点。AI 网关会自动注册模型并配置各 AI Function 的默认模型，提供开箱即用能力。
AI Function汇总表 当前PolarDB-X支持的 AI Function 如下表所示。

AI 网关会自动为每个 AI Function 绑定最佳默认模型，调用 Function 时无需指定模型名，系统会自动使用对应的默认模型。

如需切换为其他可用模型，可通过各 Function 语法中定义的 model 参数显式传入模型名。不同 Function 的 model 参数位置不同，具体以对应函数说明为准。

模型名称由 AI 网关注册决定。企业版可通过 SHOW AI MODEL 查看当前实例可用的模型，通过 SHOW AI FUNCTION 查看各 Function 当前绑定的默认模型；标准版请使用 dbms_ai 系列存储过程。

Function 名称 描述 默认模型

AI_PROMPT 通过提示词调用大语言模型对文本进行推理生成。支持系统提示词、温度控制、思维链推理等参数。
AI 网关配置的默认 LLM 模型。

AI_EMBEDDING 对给定的文本计算一个固定维度的连续向量。
AI 网关配置的默认 EMBEDDING 模型。

AI_SIMILARITY 计算文本或向量之间的余弦相似度、欧氏距离或点积。仅当两个输入均为向量时不调用 Embedding API。
与 AI_EMBEDDING 一致。

AI_RANK 对给定的查询和候选文档进行交叉编码器（Cross-Encoder）精排打分。
AI 网关配置的默认 RERANK 模型。

AI_CLASSIFY 根据提供的分类标签对输入文本进行零样本分类，支持单标签和多标签模式。
AI 网关配置的默认 LLM 模型。

AI_EXTRACT 根据字段描述对象从输入文本中提取结构化字段。
AI 网关配置的默认 LLM 模型。

AI_SUMMARIZE 生成一段文本的摘要，支持指定最大字符数、输出语言和摘要风格。
AI 网关配置的默认 LLM 模型。

AI_PARSE_DOCUMENT 将公网 PDF、图片等非结构化文件解析成纯文本。
AI 网关配置的默认 DOCUMENT_PARSE 模型。

AI_VL_EMBEDDING 对图片 URL、视频 URL 或纯文本生成多模态向量，支持图文混合检索。
AI 网关配置的默认 VL_EMBEDDING 模型。

AI_TEXT2SQL 将自然语言描述转换为 SQL 语句，自动识别当前数据库的表结构生成可执行 SQL。

说明 仅企业版实例支持。
AI 网关配置的默认 LLM 模型。
使用AI Function AI_PROMPT 通过提示词调用大语言模型对文本进行推理并输出结果。支持系统提示词设定角色、温度控制生成多样性、思维链推理（Qwen3 系列）等高级能力。
语法 --基础调用，自动使用默认 LLM 模型 SELECT AI_PROMPT(prompt)

--指定模型 SELECT AI_PROMPT(prompt, model)

--指定模型与生成参数 SELECT AI_PROMPT(prompt, model, options) 参数说明

prompt：必填，待输入的提示词，支持字符类型（CHAR、VARCHAR、TEXT）。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 LLM 模型。显式指定时，模型名称必须来自 SHOW AI MODEL 的返回结果。

options：可选，JSON 字符串，控制 LLM 生成行为。各字段说明如下：

字段 类型 说明

temperature DOUBLE 温度参数（0~2），越高越随机。

max_tokens INT 最大生成 Token 数。

top_p DOUBLE 核采样（Nucleus Sampling）参数。

stop STRING / ARRAY 停止生成的标记。

system_prompt STRING 系统提示词，设定 AI 角色。

enable_thinking BOOLEAN 启用思维链推理模式（Qwen3 系列），默认FALSE。
返回值说明

返回大模型对该问题的回答，类型为TEXT。

企业版：prompt参数为 NULL 或空字符串（""）时返回报错。标准版：prompt为 NULL 时返回 NULL，为空字符串（""）时返回报错。
使用示例

基础推理 SELECT AI_PROMPT('什么是 PolarDB-X？请用一句话回答。');
返回结果如下。
AI_PROMPT
---------
PolarDB-X 是阿里巴巴自主研发的云原生分布式数据库，兼容 MySQL 协议，支持海量数据的高并发实时处理与分析。

指定模型。请先通过 SHOW AI MODEL 获取当前实例实际可用的模型名称。
SHOW AI MODEL;

--将  替换为 SHOW AI MODEL 返回的可用 LLM 模型名称 SELECT AI_PROMPT('用一句话解释什么是分布式数据库', '');

设定 AI 角色 SELECT AI_PROMPT( '请帮我优化这条 SQL: SELECT * FROM orders WHERE status = 1', '', --空字符串表示使用默认模型 '{"system_prompt": "你是一个资深的数据库 DBA，专注于 SQL 性能优化。"}' );

启用思维链推理 SELECT AI_PROMPT( '请分析这段代码的时间复杂度并给出优化建议: for(int i=0;i<n;i++) for(int j=i;j<n;j++) sum+=a[j];', '', --空字符串表示使用默认模型 '{"enable_thinking": true}' );

结合表数据为每行数据生成描述 SELECT name, AI_PROMPT(CONCAT('请用一句话描述这个城市: ', name)) AS description FROM city LIMIT 3;
AI_EMBEDDING 将输入的文本转换为一个固定维度的连续向量（JSON 数组），用于语义检索、聚类、推荐等场景。
语法 --基础调用，自动使用默认 EMBEDDING 模型 SELECT AI_EMBEDDING(text)

--指定模型 SELECT AI_EMBEDDING(text, model)

--指定模型与向量维度 SELECT AI_EMBEDDING(text, model, options) 参数说明

text：必填，输入文本，支持字符类型（CHAR、VARCHAR、TEXT）。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 EMBEDDING 模型。显式指定时，模型名称必须来自 SHOW AI MODEL 的返回结果。

options：可选，JSON 字符串，可指定向量维度。

字段 类型 说明

dimension INT 向量维度（默认由模型决定）。
返回值说明

返回 JSON 数组格式的字符串，内容为浮点数数组，长度由模型或 dimension 参数决定。

企业版：text参数为 NULL 或空字符串（""）时返回报错。标准版：text为 NULL 或空字符串（""）时返回 NULL。
使用示例

基础向量化 SELECT AI_EMBEDDING('PolarDB-X 是一款分布式数据库');
返回结果是 JSON 数组，例如： AI_EMBEDDING
------------
[0.123, -0.456, 0.789, ...]

指定向量维度 SELECT AI_EMBEDDING( 'PolarDB-X 是一款分布式数据库', '', --空字符串表示使用默认模型 '{"dimension": 512}' );

持久化存储向量（一次计算，永久复用） --以下示例以 1024 维为例，实际维度必须与 AI_EMBEDDING 的输出维度一致 CREATE TABLE documents ( id BIGINT PRIMARY KEY AUTO_INCREMENT, content TEXT, embedding VECTOR(1024), VECTOR INDEX idx_embedding(embedding) DISTANCE=COSINE ) PARTITION BY KEY(id) PARTITIONS 4;

--批量生成并存储向量 UPDATE documents SET embedding = VEC_FROMTEXT(AI_EMBEDDING(content)) WHERE embedding IS NULL;

说明 使用向量列和向量索引前，需先开启向量索引功能：将系统变量 vidx_disabled 修改为 OFF（该变量为反向开关，默认值 ON 表示功能关闭）。详情请参见原生向量索引（Vector）文档。
AI_SIMILARITY 计算两个文本、两个向量或文本与向量之间的余弦相似度、欧氏距离或点积。只有两个输入均为向量时才会直接在本地计算，不调用 Embedding API；任一输入为文本时，文本仍需先调用 Embedding API 转换为向量。
语法 SELECT AI_SIMILARITY(query, text_or_vector [, similarity_type [, model]]) 参数说明

参数 类型 是否必需 说明

query STRING / JSON 是 查询文本或 JSON 数组形式的查询向量。

text_or_vector STRING / JSON 是 候选文本或 JSON 数组形式的预存向量。

similarity_type STRING 否 相似度算法：

cosine（默认）：余弦

euclidean：欧氏距离

dot：点积

model STRING 否 指定 EMBEDDING 模型名，不指定时使用默认模型。
返回值说明

cosine：返回余弦相似度，取值区间为 [-1, 1]，值越大越相似，检索时按降序排列。

euclidean：返回欧氏距离，取值区间为 [0, +∞)，值越小越相似，检索时按升序排列。

dot：返回向量点积，取值可以是任意实数。通常值越大越相关，但结果受向量模长影响。

企业版：若输入为空、向量格式非法或两个向量维度不一致，语句将报错。标准版：输入为 NULL 时返回 NULL。
使用示例

文本对文本相似度 SELECT AI_SIMILARITY('云原生数据库', 'PolarDB-X 是一款分布式云原生数据库') AS score;
返回结果如下。
score
-----
0.87

使用预存向量计算相似度 --查询向量只生成一次，避免在逐行计算时重复调用 Embedding API SET @query_embedding = AI_EMBEDDING('分布式事务专家');

SELECT id, name, AI_SIMILARITY(@query_embedding, VEC_TOTEXT(embedding), 'cosine') AS score FROM resumes WHERE status = 'processed' AND embedding IS NOT NULL ORDER BY score DESC LIMIT 10;

说明 性能建议：AI_SIMILARITY适合文本比较或小规模向量计算。大规模在线检索应将向量存储在 VECTOR 列中、创建 HNSW 向量索引，并使用向量距离函数执行 Top-K 召回。
AI_RANK 使用 Cross-Encoder 精排模型对查询和候选文档进行深度语义匹配打分，精度高于向量余弦相似度，常用作召回结果的二次精排。
语法 SELECT AI_RANK(query, candidate [, model [, options]]) 参数说明

query：必填，查询文本，支持字符类型（CHAR、VARCHAR、TEXT）。

candidate：必填，候选文本，与 query 进行相关性比较，支持字符类型（CHAR、VARCHAR、TEXT）。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 RERANK 模型。显式指定时，模型名称必须来自 SHOW AI MODEL 的返回结果。

options：可选，JSON 字符串，控制精排参数。
返回值说明

返回 DOUBLE 类型的相关性 Score，取值区间：[0, 1]，值越大相关性越高。

企业版：query或candidate任一参数为 NULL 时返回报错。标准版：任一参数为 NULL 时返回 NULL。

说明 性能建议：AI_RANK调用Cross-Encoder模型，单次耗时较高，应仅对召回结果（Top-20 以内）做精排，避免对全表数据直接精排。
使用示例

基础打分 SELECT AI_RANK( '如何优化数据库查询性能', '数据库索引设计与查询优化的 10 个最佳实践' ) AS score;
返回结果如下。
score
-----
0.91

对文档列表精排 SELECT id, title, AI_RANK('PolarDB-X 分布式事务', content) AS relevance FROM articles WHERE category = 'database' ORDER BY relevance DESC LIMIT 10;

推荐用法：两阶段检索（先向量召回，再精排） SELECT id, name, summary, similarity_score, AI_RANK('Java 后端高级工程师', summary) AS rank_score FROM ( SELECT id, name, summary, AI_SIMILARITY('Java 后端高级工程师', embedding) AS similarity_score FROM resumes WHERE embedding IS NOT NULL AND summary IS NOT NULL ORDER BY similarity_score DESC LIMIT 20 ) recalled ORDER BY rank_score DESC;
AI_CLASSIFY 将文本零样本归类到您指定的候选标签中。无需训练，只需提供候选标签列表即可。支持单标签（默认）和多标签两种模式。
语法 SELECT AI_CLASSIFY(text, labels_json [, model [, options]]) 参数说明

text：必填，需要分类的文本，支持字符类型（CHAR、VARCHAR、TEXT）。

labels_json：必填，JSON 数组形式的分类标签列表，支持 ARRAY 类型，标签数量建议在 2~20 之间。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 LLM 模型。

options：可选，JSON 字符串。

字段 类型 说明

multi_label BOOLEAN 启用多标签分类模式，返回多个匹配标签的 JSON 数组。默认FALSE（单标签）。
返回值说明

单标签模式下返回匹配的标签字符串。

多标签模式下返回 JSON 数组形式的多个标签。

企业版：text参数为 NULL 或空字符串（""）时返回报错。标准版：text为 NULL 时返回 NULL，为空字符串（""）时返回报错。
使用示例

单标签分类（情感分析） SELECT AI_CLASSIFY( '这款产品用了一周，质量很棒，非常推荐！', '["positive", "negative", "neutral"]' ) AS sentiment;
返回结果如下。
sentiment
---------
positive

多标签分类 SELECT AI_CLASSIFY( '本文介绍了使用 Kubernetes 部署分布式数据库的最佳实践', '["数据库", "云原生", "运维", "开发"]', '', '{"multi_label": true}' ) AS tags;
返回结果如下。
tags
----
["数据库", "云原生", "运维"]

批量分类写回 UPDATE resumes SET category = AI_CLASSIFY( raw_text, '["前端", "后端", "算法", "数据", "运维", "其他"]' ) WHERE category IS NULL AND status = 'processed';
AI_EXTRACT 根据字段描述对象从非结构化文本中提取结构化字段，返回 JSON 对象格式的字符串，可直接使用 JSON_EXTRACT 等函数展开为列。这里的字段描述对象不是标准 JSON Schema。
语法 SELECT AI_EXTRACT(text, fields_json [, model [, options]]) 参数说明

text：必填，输入文本，支持字符类型（CHAR、VARCHAR、TEXT）。

fields_json：必填，JSON 对象格式的字符串，键为待提取字段名，值为该字段的含义，例如 {"name":"姓名","skills":"技能列表"}。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 LLM 模型。

options：可选，JSON 字符串，支持 temperature、max_tokens、system_prompt。
返回值说明

返回 JSON 对象格式的字符串，包含每个字段对应的提取结果，可供 JSON 函数解析。

企业版：text参数为 NULL 或空字符串（""）时返回报错。标准版：text为 NULL 时返回 NULL，为空字符串（""）时返回报错。
使用示例

提取简历信息 SELECT AI_EXTRACT( '张三，8 年 Java 开发经验，毕业于上海交通大学计算机系，曾就职于阿里巴巴，熟悉 Spring Boot、Kafka、MySQL。', '{"name": "姓名", "experience_years": "工作年限", "university": "毕业院校", "skills": "技能列表", "company": "前雇主"}' ) AS info;
返回结果如下。
{ "name": "张三", "experience_years": "8 年", "university": "上海交通大学", "skills": "Java, Spring Boot, Kafka, MySQL", "company": "阿里巴巴" }

提取后展开为列 SELECT id, JSON_UNQUOTE(JSON_EXTRACT(info, '$.name'))       AS name, JSON_UNQUOTE(JSON_EXTRACT(info, '$.university')) AS university, JSON_UNQUOTE(JSON_EXTRACT(info, '$.skills'))     AS skills FROM ( SELECT id, AI_EXTRACT(raw_text, '{"name":"姓名","university":"学校","skills":"技能"}') AS info FROM resumes ) t;
AI_SUMMARIZE 将长文本压缩为指定最大字符数以内的摘要，保留核心信息。支持指定输出语言和摘要风格。
语法 SELECT AI_SUMMARIZE(text [, max_length [, model [, options]]]) 参数说明

text：必填，输入文本，支持字符类型（CHAR、VARCHAR、TEXT）。

max_length：可选，摘要最大字符数，默认值为 200。取值为 0 或负数时使用默认值，不表示取消长度限制。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 LLM 模型。

options：可选，JSON 字符串。

字段 类型 说明

language STRING 指定摘要输出语言（如 "Chinese"、"English"）。

style STRING 摘要风格。设置范围：

（默认）连贯段落

bullet_points：要点列表 返回值说明

返回 TEXT 类型的摘要内容。

企业版：text参数为 NULL 或空字符串（""）时返回报错。标准版：text为 NULL 时返回 NULL，为空字符串（""）时返回报错。

max_length取值为 0 或负数时使用默认值。
使用示例

基础摘要 SELECT AI_SUMMARIZE(raw_text, 200) AS summary FROM resumes WHERE id = 1;

指定输出语言（即使原文是英文，也输出中文摘要） SELECT AI_SUMMARIZE(raw_text, 200, '', '{"language": "Chinese"}') AS summary FROM resumes WHERE id = 1;

要点列表风格 SELECT AI_SUMMARIZE(raw_text, 300, '', '{"style": "bullet_points"}') AS summary FROM resumes WHERE id = 1;

批量生成摘要并存储 UPDATE resumes SET summary = AI_SUMMARIZE(raw_text, 200) WHERE summary IS NULL AND status = 'processed';
AI_PARSE_DOCUMENT 解析公网 PDF、Word、PPT、TXT、Markdown、HTML、图片等非结构化文件，将其内容转换为纯文本，支持自动识别文件类型。
语法 SELECT AI_PARSE_DOCUMENT(url [, input_format [, model [, options]]]) 参数说明

参数 类型 是否必需 说明

url STRING 是 文件的公网 URL。

input_format STRING 否 解析策略，默认 auto。支持 auto、text_only、text_and_images；也接受 pdf、word、doc、docx、ppt、pptx、txt、image、markdown、md、html 等格式别名，格式别名均按自动检测处理。

model STRING 否 指定 DOCUMENT_PARSE 模型名，省略时使用 AI 网关配置的默认模型。

options STRING 否 额外选项（JSON 格式）。
返回值说明

返回 TEXT 类型，是从文件中解析出的纯文本内容。

URL 无效、文件无法访问、文件内容不受支持或解析失败时，语句将抛出 SQL 异常。调用方需要捕获并处理异常。
使用示例

解析公网 PDF SELECT AI_PARSE_DOCUMENT('https://example.com/resume.pdf') AS content;

指定文件格式 SELECT AI_PARSE_DOCUMENT('https://example.com/resume.pdf', 'pdf') AS content;

解析图片（如扫描件简历） SELECT AI_PARSE_DOCUMENT('https://example.com/resume_scan.jpg') AS content;

解析后接入处理流水线（解析 → 抽取 → 摘要） SELECT AI_PARSE_DOCUMENT('https://example.com/cv.pdf') AS raw_text, AI_EXTRACT( AI_PARSE_DOCUMENT('https://example.com/cv.pdf'), '{"name":"姓名","skills":"技能"}' ) AS structured, AI_SUMMARIZE( AI_PARSE_DOCUMENT('https://example.com/cv.pdf'), 200 ) AS summary;

说明 优化提示：上述写法对每个 Function 都重复调用了AI_PARSE_DOCUMENT，建议使用临时表或子查询缓存解析结果，避免重复 API 调用。
AI_VL_EMBEDDING 对图片 URL、视频 URL 或纯文本生成多模态向量，支持图文混合语义检索。函数会自动检测输入类型，以 http:// 或 https:// 开头的输入按图片/视频处理，其他输入按文本处理。也可通过 options 显式指定。
支持的内容类型

文本：任意非 URL 字符串，自动识别为文本。

图片：jpg、jpeg、png、webp、bmp、tiff、tif、ico、dib、icns、sgi。

视频：mp4、avi、mov。

Base64 Data URI：data:image/... 或 data:video/...。
语法 SELECT AI_VL_EMBEDDING(content [, model [, options]]) 参数说明

content：必填，文本字符串、图片/视频 URL 或 Base64 Data URI。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 VL_EMBEDDING 模型。显式指定时，模型名称必须来自 SHOW AI MODEL 的返回结果。

options：可选，JSON 字符串。

字段 类型 说明

content_type STRING 显式指定内容类型："text"、"image" 或 "video"。不指定时自动检测。

dimension INT 向量维度（默认由模型决定）。

fps DOUBLE 视频帧采样率（仅对视频有效）。
返回值说明 返回 JSON 类型的浮点数数组。

说明 AI_VL_EMBEDDING生成的文本向量与图片/视频向量位于同一多模态语义空间，可直接互相计算相似度。这与AI_EMBEDDING生成的纯文本向量空间不同，两者不可混用。
使用示例

生成图片向量 SELECT AI_VL_EMBEDDING('https://example.com/product.jpg') AS vec;

生成文本向量（多模态空间） SELECT AI_VL_EMBEDDING('红色连衣裙') AS vec;

生成视频向量并显式指定参数 SELECT AI_VL_EMBEDDING( 'https://example.com/clip.mp4', '', '{"content_type": "video", "dimension": 1024, "fps": 2.0}' ) AS vec;

以图搜图 SELECT id, product_name, AI_SIMILARITY( AI_VL_EMBEDDING('https://example.com/query.jpg'), image_embedding ) AS similarity FROM products WHERE image_embedding IS NOT NULL ORDER BY similarity DESC LIMIT 10;

图文混合检索 --同时计算文本相似度与图片相似度，加权求和 SELECT id, product_name, (AI_SIMILARITY('红色连衣裙', text_embedding) * 0.4 + AI_SIMILARITY(AI_VL_EMBEDDING('https://example.com/red_dress.jpg'), image_embedding) * 0.6 ) AS combined_score FROM products ORDER BY combined_score DESC LIMIT 20;
AI_TEXT2SQL

说明 仅企业版实例支持。
将自然语言查询转换为可执行 SQL 语句。函数自动识别当前数据库（USE database 选择的库）下的表结构，并将其与您的自然语言描述一同提交给大语言模型生成 SQL。当库中表数量较多时，会先让模型筛选相关表，再据此生成最终 SQL。
--基础调用 SELECT AI_TEXT2SQL(prompt);

--指定模型 SELECT AI_TEXT2SQL(prompt, model);

--指定模型与生成参数 SELECT AI_TEXT2SQL(prompt, model, options);
参数说明

prompt：必填，自然语言查询描述，支持字符类型（CHAR、VARCHAR、TEXT）。

model：可选，AI Function 使用的模型名称。省略时使用 AI 网关配置的默认 LLM 模型。显式指定时，模型名称必须来自 SHOW AI MODEL 的返回结果。

options：可选，JSON 字符串，控制 LLM 生成行为（temperature、max_tokens 等，与 AI_PROMPT 一致）。
返回值说明

返回 TEXT 类型，是模型生成的 SQL 语句。

prompt参数为 NULL 或空字符串（""）时返回报错。
使用示例

基础查询生成 --切换到目标数据库后调用 USE my_database;

SELECT AI_TEXT2SQL('查询所有年龄大于 30 的用户');
返回类似： AI_TEXT2SQL
-----------
SELECT * FROM users WHERE age > 30;

跨表聚合查询 SELECT AI_TEXT2SQL('统计每个部门的员工数量和平均工资');

中英文混合 SELECT AI_TEXT2SQL('Find the top 10 best-selling products in the last 7 days');

指定模型与温度 SELECT AI_TEXT2SQL( '查询销售额最高的5个商品', '', --空字符串表示使用默认模型 '{"temperature": 0.1, "max_tokens": 500}' );

说明

AI_TEXT2SQL 仅生成 SQL 字符串，不会自动执行。生成的 SQL 应在执行前由您/应用进行评审（Review）。

函数依赖当前数据库的表结构信息，调用前请确保已通过 USE  切换到目标数据库。

当库中表数量超过 10 时，模型会先识别相关表再生成 SQL，可能产生两次模型调用。
AI Function 与模型 模型管理 PolarDB-XAI Function 的模型完全由 AI 网关统一管理。AI 网关启动后会自动注册以下类型的模型，并为每个 AI Function 配置最佳默认模型：

模型类型 默认模型名 适用 Function 说明

LLM 以 SHOW AI FUNCTION 返回结果为准。
AI_PROMPT、AI_CLASSIFY、AI_EXTRACT、AI_SUMMARIZE、AI_TEXT2SQL（仅企业版） 大语言模型，用于文本生成、分类、抽取等。

EMBEDDING 以 SHOW AI FUNCTION 返回结果为准。
AI_EMBEDDING、AI_SIMILARITY 文本向量化模型。

RERANK 以 SHOW AI FUNCTION 返回结果为准。
AI_RANK 交叉注意力精排模型。

DOCUMENT_PARSE 以 SHOW AI FUNCTION 返回结果为准。
AI_PARSE_DOCUMENT 文档解析模型。

VL_EMBEDDING 以 SHOW AI FUNCTION 返回结果为准。
AI_VL_EMBEDDING 多模态向量化模型。

说明 模型的注册、更新和管理由 AI 网关自动完成，您无需手动操作。AI Function 仅使用当前实例 AI 网关已注册并可用的模型。
查看可用模型 企业版（SHOW AI MODEL）

使用SHOW AI MODEL语句查看当前可用的 AI 模型列表。
SHOW AI MODEL;
返回字段说明

列名 说明

NAME 模型名称。

MODEL 底层模型标识（实际调用 API 时使用的模型名）。

PROVIDER 模型提供方。

ENDPOINT API 调用端点。

STATUS 模型状态：ACTIVE（可用）、INACTIVE（已禁用）。

DESCRIPTION 模型描述信息。

说明 模型名称和底层模型映射由 AI 网关决定，不同实例或版本的返回结果可能不同。后续示例中需要显式指定模型时，请使用 SHOW AI MODEL 返回的 NAME，不要使用固定名称。
查看模型详情 企业版（SHOW AI MODEL FROM）

使用 SHOW AI MODEL FROM 查看指定模型的详细配置信息。
SHOW AI MODEL FROM ;
返回 JSON 格式的模型详情，包含模型名称、底层模型标识、Provider、状态等信息。
返回字段说明

字段 说明

name 模型配置名称（唯一标识）。

provider 模型提供方。

endpoint API 调用端点 URL。

model 底层模型标识。

api_key 模型级 API Key，展示时会脱敏（如 sk-f****8jTh）。

description
模型描述信息。

gmt_created 模型注册时间。

gmt_modified 模型最后修改时间。

status 模型状态：ACTIVE（可用）、INACTIVE（已禁用）。
查看 AI 函数配置 企业版（SHOW AI FUNCTION） 使用SHOW AI FUNCTION语句查看所有 AI 函数及其当前配置的默认模型。
--查看所有 AI 函数 SHOW AI FUNCTION;

--查看指定函数 SHOW AI FUNCTION FROM AI_PROMPT;
返回列说明

列名 说明

FUNCTION AI 函数名称。

DEFAULT_MODEL 当前配置的默认模型名。

ACTUAL_MODEL 默认模型对应的实际底层模型标识。

DESCRIPTION 函数描述。
实际模型名称和底层模型标识以当前实例的返回结果为准。
修改 AI 函数默认模型 AI 网关会为每个 AI Function 配置推荐的默认模型。如需切换某个 Function 使用的默认模型（例如希望 AI_PROMPT 使用更强的模型），可通过以下方式修改。
企业版（AI_UPDATE_FUNCTION） 使用 AI_UPDATE_FUNCTION 函数修改指定 AI 函数的默认模型。
语法 SELECT AI_UPDATE_FUNCTION(function_name, model_name);
参数说明

参数 类型 是否必需 说明

function_name STRING 是 AI 函数名称（大小写不敏感），如 AI_PROMPT、AI_EMBEDDING。

model_name STRING 是 已注册的模型名称（需在 SHOW AI MODEL 中存在）。
返回值说明

成功返回字符串 "OK"。

若函数名无效，报错 Unknown AI function。

若模型名不存在，报错 Model not found。
使用示例

将 AI_PROMPT 的默认模型切换为其他可用 LLM 模型。
--查看当前可用模型 SHOW AI MODEL;

--将 AI_PROMPT 的默认模型切换为其他可用 LLM 模型 SELECT AI_UPDATE_FUNCTION('AI_PROMPT', '');
-- 返回: OK

验证修改生效 SHOW AI FUNCTION FROM AI_PROMPT;

说明 该操作需要管理员或超级用户权限。修改后立即在集群所有 CN 节点生效，无需重启。请确保模型类型与函数匹配，例如 AI_EMBEDDING 应绑定 EMBEDDING 类型模型。
指定 AI Function 调用的模型 每个 AI Function 都已由 AI 网关绑定了最佳默认模型，调用时无需指定模型名。如需使用其他可用模型，可通过对应 Function 的 model 参数显式传入 SHOW AI MODEL 返回的模型名称。不同 Function 的 model 参数位置可能不同。

说明 不同 AI Function 需要适配特定类型的模型，例如 AI_EMBEDDING 需要 EMBEDDING 类型模型，AI_RANK 需要 RERANK 类型模型，AI_PARSE_DOCUMENT 需要 DOCUMENT_PARSE 类型模型。请勿将不匹配类型的模型传入对应 Function。
--使用默认模型（推荐，开箱即用） SELECT AI_PROMPT('用一句话解释什么是分布式数据库');

--显式指定其他可用模型 SELECT AI_PROMPT('用一句话解释什么是分布式数据库', '');
最佳实践 了解了 AI Function 的基础用法后，您可以通过以下典型场景将它们组合应用，解决复杂的业务问题。
两阶段语义检索（向量召回 + Cross-Encoder 精排） 构建企业级语义检索时，单一向量相似度的召回精度有限。推荐采用「向量索引召回 + 精排」两阶段方案：先使用 HNSW 向量索引召回 Top-N 候选，再用 AI_RANK 对候选做高精度打分，最终输出最相关结果。
--1. 离线建库：批量计算并存储向量 UPDATE resumes SET embedding = VEC_FROMTEXT(AI_EMBEDDING(raw_text)) WHERE embedding IS NULL;

--2. 在线检索：查询向量只生成一次 SET @query_embedding = AI_EMBEDDING('Java 后端高级工程师');

--3. 向量索引召回 Top-20，再调用 AI_RANK 精排 SELECT id, name, summary, vector_distance, AI_RANK('Java 后端高级工程师', summary) AS rank_score FROM ( SELECT id, name, summary, VEC_DISTANCE_COSINE(embedding, VEC_FROMTEXT(@query_embedding)) AS vector_distance FROM resumes WHERE embedding IS NOT NULL AND summary IS NOT NULL ORDER BY vector_distance ASC LIMIT 20 ) recalled ORDER BY rank_score DESC;
关键要点

embedding 应使用与模型输出维度一致的 VECTOR 列，并创建 HNSW 向量索引。

查询向量只生成一次。召回阶段不调用 Embedding API，AI_RANK 仅对 Top-20 候选精排，整体延迟可控。
非结构化文档转结构化数据流水线 将解析、抽取、摘要、分类、向量化等多个 AI Function 串联，可将 PDF/图片等非结构化数据转化为可分析的结构化数据并落库。文档解析属于远程模型调用，应确保同一文档只解析一次，避免重复调用。
--在子查询中只解析一次文档，外层对解析结果执行抽取、摘要、分类和向量化 INSERT INTO resumes (raw_text, structured_info, summary, category, embedding) SELECT raw_text, AI_EXTRACT( raw_text, '{"name":"姓名","skills":"技能","experience_years":"工作年限"}' ) AS structured_info, AI_SUMMARIZE(raw_text, 200) AS summary, AI_CLASSIFY( raw_text, '["前端", "后端", "算法", "数据", "运维", "其他"]' ) AS category, VEC_FROMTEXT(AI_EMBEDDING(raw_text)) AS embedding FROM ( SELECT AI_PARSE_DOCUMENT(file_url) AS raw_text FROM file_inbox WHERE status = 'pending' ) parsed;
多模态商品检索（以图搜图 + 图文混合检索） 借助 AI_VL_EMBEDDING，可在统一的多模态语义空间中同时表达图片与文本，构建图文一体的商品检索系统。

商品入库：同时存储多模态向量与纯文本向量 INSERT INTO products (name, image_url, text_embedding, image_embedding) VALUES ( ?, ?, AI_EMBEDDING(?),                       --纯文本向量，用于文本-文本检索 AI_VL_EMBEDDING(?)                     --多模态向量，用于图文混合检索 );

以图搜图 SET @query_image_embedding = AI_VL_EMBEDDING('https://example.com/query.jpg');

SELECT id, product_name, AI_SIMILARITY( @query_image_embedding, image_embedding ) AS similarity FROM products WHERE image_embedding IS NOT NULL ORDER BY similarity DESC LIMIT 10;

图文混合检索：文本相似度与图片相似度加权融合 SET @query_text_embedding = AI_EMBEDDING('红色连衣裙');
SET @query_image_embedding = AI_VL_EMBEDDING('https://example.com/red_dress.jpg');

SELECT id, product_name, (AI_SIMILARITY(@query_text_embedding, text_embedding) * 0.4 + AI_SIMILARITY(@query_image_embedding, image_embedding) * 0.6 ) AS combined_score FROM products ORDER BY combined_score DESC LIMIT 20;
关键要点

AI_VL_EMBEDDING 与 AI_EMBEDDING 输出的向量位于不同语义空间，不可跨函数混用，建议在表中分别存储 text_embedding 与 image_embedding。

加权系数可结合业务效果调整，例如重图片场景设 image 权重 0.7+，重文本场景设 text 权重 0.7+。
批量数据治理（分类、脱敏、清洗） 利用 AI Function 的批量调用能力，可在 SQL 中直接对存量数据做语义级治理，无需写额外的 ETL 程序。

批量分类 UPDATE feedback SET sentiment = AI_CLASSIFY(content, '["positive", "negative", "neutral"]') WHERE sentiment IS NULL;

批量结构化抽取 UPDATE orders SET parsed_info = AI_EXTRACT( order_notes, '{"customer_name":"客户姓名","delivery_address":"配送地址","special_requirements":"特殊要求"}' ) WHERE order_notes IS NOT NULL AND parsed_info IS NULL;

批量摘要 UPDATE articles SET summary = AI_SUMMARIZE(content, 200) WHERE summary IS NULL;
关键要点

推荐分批 UPDATE（如按主键范围），避免一次性扫描超大表导致单条 SQL 长时间占用资源。

对延迟敏感的在线场景，建议将向量、摘要等结果预计算并落库，查询时直接复用。

上一篇：长记忆服务mem0下一篇：AI节点

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
