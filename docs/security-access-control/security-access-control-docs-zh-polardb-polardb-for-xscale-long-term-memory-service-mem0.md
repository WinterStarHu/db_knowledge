# 长记忆服务mem0-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/long-term-memory-service-mem0

长记忆服务mem0-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

长记忆服务mem0

长记忆服务mem0

更新时间：

复制 MD 格式

产品详情 我的收藏

云原生数据库PolarDB分布式版 Mem0 是基于 PolarDB-X 构建的 AI Agent 长期记忆托管服务，100% 兼容开源 Mem0 框架及 Mem0 云服务 SDK。通过在多次交互中高效地抽取、存储与调用记忆，帮助您打造真正智能和个性化的 AI 应用。

功能优势

双通道记忆，一站式管理：在同一个 PolarDB-X 实例中，同时提供 Mem0 语义记忆 API 和 MySQL 直连的结构化记忆存储能力。无需额外购买独立数据库，即可同时管理语义记忆（用户偏好、习惯等）和结构化记忆（用户画像、会话日志、工具调用记录等）。

全面兼容，无缝迁移：同时兼容开源 Mem0 框架和 Mem0 云服务 SDK（MemoryClient）的数据库托管方案。已有 Agent 应用无论使用社区版本还是云端 SDK，均可零改动直接接入。

分布式高性能：底层基于 PolarDB-X 原生向量能力，结合多进程 + 异步事件循环 + 线程池桥接 + 实例池的四层并发架构，在同等硬件下实现 10~50 倍于开源 Server 的吞吐量提升。

全托管服务，成本更优：提供可视化的 Web 管理界面，无需投入硬件成本，无需关心系统的部署、运维和故障处理。通过记忆精炼技术，可显著降低大模型的 Token 消耗，进一步节约资源成本。

弹性水平扩展：基于 PolarDB-X 分布式架构，支持海量记忆数据的存储与检索。通过水平分片自动扩容，从容应对百万至千万级记忆规模。
应用场景

智能客服系统：感知跨会话上下文，避免重复询问，提供连贯的问题解决方案，提升服务效率与满意度。

个性化教育：构建学员能力画像，动态调整教学内容，提供个性化学习路径，实现因材施教。

医疗健康管理：持续记录患者病史、治疗方案与生理指标，建立完整健康档案，提供连续性个体化医疗服务。

情感陪伴与心理健康：深度理解用户情绪、性格和生活事件，识别压力源并提供共情式持续支持。

智能推荐系统：基于用户的长期兴趣和即时反馈，提供更精准、动态的推荐内容。

多 Agent 协同：为多个 Agent 提供共享或隔离的记忆空间（通过 agent_id 区分），支持团队协作场景下的知识积累与传递。
适用范围

企业版：需为2.6.0_5.4.21-20260610_xcluster8.4.21-20260605及以上版本。

标准版：需为2.5.0_standard_xcluster8.4.21-20260605及以上版本。

说明

实例版本的规则说明，请参见版本说明。

实例版本的查看方式，请参见查看实例版本。
快速体验 步骤一：创建 Mem0 实例

登录 PolarDB-X 控制台。

在左侧导航栏，单击AI能力 > 记忆引擎。

单击免费开通记忆引擎。

在弹出的确认对话框中，单击确定。

说明 系统需要3～5分钟创建应用，请耐心等待。创建完成后，页面将显示 Mem0 实例的详细信息。
步骤二：获取连接地址与访问凭证

获取 Mem0 连接地址 在 Mem0 实例详情页，单击基本信息页签，在连接地址区域查看 VPC 地址（私网地址）和公网地址。

说明

公网地址需单独申请。在基本信息页签的连接地址区域，单击申请外网地址进行申请。

建议优先使用 VPC 地址（私网地址）以获得更低延迟和更高安全性。

获取 API Key 单击配置与管理页签，在参数列表中查看API Key。参数值默认隐藏，单击眼睛图标可查看完整内容，单击复制可复制参数值。
步骤三：配置白名单

在 Mem0 实例详情页，单击白名单页签。

单击新增IP白名单分组，或单击已有分组的配置按钮。

在弹出的对话框中，输入分组名称和允许访问的 IP 地址，单击确定。

说明

如果您的 ECS 实例与 Mem0 实例位于同一 VPC 内，填写 ECS 的私网 IP 地址或其所在 VPC 网段。

如果您的 ECS 实例与 Mem0 实例不在同一 VPC 内，填写 ECS 的公网 IP 地址。

如果您本地的服务器或电脑需要访问 Mem0 实例，请将其公网 IP 地址添加到白名单中。
步骤四：操作示例 添加记忆 向 Mem0 添加一段对话，服务会自动从对话内容中提取语义记忆。
curl -X POST http://:3306/v1/memories/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "messages": [ { "role": "user", "content": "我叫张三，在杭州工作，最爱吃川菜里的水煮鱼。" }, { "role": "assistant", "content": "好的，已经记下您的信息和口味偏好。" } ], "user_id": "user_001", "run_id": "session_001", "metadata": { "source": "chat" } }' 返回示例： { "results": [ { "id": "70db3ad0-xxxx-xxxx-xxxx-66b3d24656ed", "memory": "名字是张三", "event": "ADD" }, { "id": "769e6f22-xxxx-xxxx-xxxx-bfad6ade692c", "memory": "在杭州工作", "event": "ADD" }, { "id": "30966d63-xxxx-xxxx-xxxx-d68d1048bc31", "memory": "最爱吃川菜里的水煮鱼", "event": "ADD" } ] }

说明 当前实例存在已知限制：当 messages 内容为中文且同时携带 agent_id 字段时，LLM 抽取会返回空 {"results":[]}（HTTP 200 但无记忆写入）。建议在中文场景下不传 agent_id；如需多智能体隔离，可在写入后通过 metadata 字段或独立 user_id 实现。英文 messages 不受此限制影响。
搜索记忆 根据查询语句进行语义搜索，返回最相关的记忆。
curl -X POST http://:3306/v2/memories/search/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "query": "我喜欢吃什么", "user_id": "user_001", "top_k": 5 }' 返回示例： { "results": [ { "id": "30966d63-xxxx-xxxx-xxxx-d68d1048bc31", "memory": "最爱吃川菜里的水煮鱼", "hash": "ec3a1bec939942045e2c90ac2acd93e7", "metadata": {"source": "chat"}, "score": 0.5295314589229717, "created_at": "2026-06-24T16:00:00.000000+08:00", "updated_at": null, "user_id": "user_001" }, { "id": "769e6f22-xxxx-xxxx-xxxx-bfad6ade692c", "memory": "在杭州工作", "hash": "1b3f2e1f5d70920d8a1cac47cf365a31", "metadata": {"source": "chat"}, "score": 0.2815325178698094, "created_at": "2026-06-24T16:00:00.000000+08:00", "updated_at": null, "user_id": "user_001" } ] } 获取全部记忆 获取指定用户或智能体下的所有记忆条目。
curl -X POST http://:3306/v2/memories/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "user_id": "user_001" }' 返回示例： { "results": [ { "id": "70db3ad0-xxxx-xxxx-xxxx-66b3d24656ed", "memory": "名字是张三", "hash": "7d0a10343e179826a9cbb01e5d4f6e71", "metadata": {"source": "chat"}, "created_at": "2026-06-24T16:00:00.000000+08:00", "updated_at": null, "user_id": "user_001" }, { "id": "769e6f22-xxxx-xxxx-xxxx-bfad6ade692c", "memory": "在杭州工作", "hash": "1b3f2e1f5d70920d8a1cac47cf365a31", "metadata": {"source": "chat"}, "created_at": "2026-06-24T16:00:00.000000+08:00", "updated_at": null, "user_id": "user_001" }, { "id": "30966d63-xxxx-xxxx-xxxx-d68d1048bc31", "memory": "最爱吃川菜里的水煮鱼", "hash": "ec3a1bec939942045e2c90ac2acd93e7", "metadata": {"source": "chat"}, "created_at": "2026-06-24T16:00:00.000000+08:00", "updated_at": null, "user_id": "user_001" } ] } 释放 Mem0 实例

登录 PolarDB-X 控制台。

在左侧导航栏，单击AI能力 > 记忆引擎。

单击关闭记忆引擎。

在弹出的确认对话框中，单击确定。

警告 关闭记忆引擎后，相关功能将无法使用，已存储的记忆数据将被清除。请谨慎操作。
API 参考 PolarDB-X Mem0 基于开源框架 mem0 提供托管服务，同时兼容 Mem0 云服务 SDK 和开源服务端两套 API 路径。您可以通过访问 http://:3306/docs 查看实时更新的 API 文档。
请求头 所有 API 请求都需要在 HTTP Header 中包含认证信息： Authorization: Token Content-Type: application/json API 端点总览

功能 云服务兼容路径 开源兼容路径 方法 说明

健康检查 /v1/ping/ / GET SDK初始化验证

添加记忆 /v1/memories/ /memories POST 从对话中提取记忆

获取全部记忆 /v2/memories/ /memories（GET） POST/GET 按条件获取记忆列表

搜索记忆 /v2/memories/search/ /memories/search POST 语义相似度搜索

获取单条记忆 /v1/memories/{id}/ /memories/{id} GET 按 ID 获取记忆详情

更新记忆 /v1/memories/{id}/ /memories/{id} PUT 修改记忆内容

删除单条记忆 /v1/memories/{id}/ /memories/{id} DELETE 按 ID 删除记忆

删除全部记忆 /v1/memories/ /memories DELETE 按条件批量删除

记忆历史 /v1/memories/{id}/history/ /memories/{id}/history GET 获取记忆变更历史

批量更新 /v1/batch/ — PUT 批量更新多条记忆

批量删除 /v1/batch/ — DELETE 批量删除多条记忆

获取实体 /v1/entities/ /entities GET 获取所有实体

删除实体 /v2/entities/{type}/{id}/ — DELETE 删除实体下所有记忆

重置 /v1/memories/reset/ /reset POST 重置全部记忆

创建导出 /v1/exports/ — POST 创建记忆导出任务

获取导出 /v1/exports/get/ — POST 获取导出结果

摘要 /v1/summary/ — POST 获取记忆摘要

反馈 /v1/feedback/ — POST 提交记忆反馈 创建记忆 存储新的记忆。服务会自动对 messages 内容进行分析，生成语义记忆。

请求地址：POST /v1/memories/

请求参数：

参数 类型 必选 说明

messages Array 是 对话消息列表，每条消息包含 role（user/assistant/system）和 content 字段。

user_id String 是 用户的唯一标识符。

agent_id String 否 智能体的唯一标识符，用于在同一用户下隔离不同应用的记忆。

run_id String 否 单次执行或会话的唯一标识符。

metadata Object 否 附加的元数据，会与记忆一同存储。

filters Object 否 过滤条件。

prompt String 否 自定义提取策略 Prompt，覆盖系统默认模板。

请求示例： curl -X POST http://:3306/v1/memories/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "messages": [ {"role": "user", "content": "我叫张三，在杭州工作，最爱吃川菜里的水煮鱼。"}, {"role": "assistant", "content": "好的，已经记下您的信息和口味偏好。"} ], "user_id": "user_001", "run_id": "session_001", "metadata": {"source": "chat"} }' 搜索记忆 根据查询字符串，搜索最相关的记忆。

请求地址：POST /v2/memories/search/

请求参数：

参数 类型 必选 说明

query String 是 用于搜索的查询文本。

user_id String 否 限定在指定用户下搜索。

agent_id String 否 限定在指定智能体下搜索。

run_id String 否 限定在指定会话下搜索。

filters Object 否 基于元数据的过滤条件。

top_k Integer 否 返回结果数量上限，默认 5。

请求示例： curl -X POST http://:3306/v2/memories/search/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "query": "我喜欢吃什么", "user_id": "user_001", "top_k": 5 }' 获取全部记忆 获取指定范围内的所有记忆。

请求地址：POST /v2/memories/

请求参数：

参数 类型 必选 说明

user_id String 否 用户的唯一标识符。

agent_id String 否 限定获取指定智能体的记忆。

run_id String 否 限定获取指定会话的记忆。

filters Object 否 基于元数据的过滤条件。
查询参数（可选）：page、page_size 用于分页。

请求示例： curl -X POST http://:3306/v2/memories/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "user_id": "user_001" }' 更新记忆 更新指定记忆的内容。

请求地址：PUT /v1/memories/{memory_id}/

请求参数：

参数 类型 必选 说明

data String 是 更新后的记忆内容。

text String 是 更新后的记忆内容（SDK 兼容别名，与 data 二选一）。

请求示例： curl -X PUT http://:3306/v1/memories// \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{"data": "更新后的记忆内容"}' 返回示例： {"message": "Memory updated successfully!"} 删除记忆 删除指定范围内的记忆。

删除单条：DELETE /v1/memories/{memory_id}/

按条件删除全部：DELETE /v1/memories/

参数 类型 必选 说明

user_id String 是 用户的唯一标识符（query 参数或 JSON body）。

agent_id String 否 如果提供，则仅删除该智能体的记忆。

run_id String 否 如果提供，则仅删除该会话的记忆。

请求示例：
# 删除单条
curl -X DELETE http://:3306/v1/memories// \ -H "Authorization: Token "

# 按条件删除全部
curl -X DELETE 'http://:3306/v1/memories/?user_id=user_001' \ -H "Authorization: Token " 返回示例： // 删除单条 {"message": "Memory deleted successfully!"}

// 按条件批量删除 {"message": "Memories deleted successfully!"} 批量操作 对多条记忆进行批量更新或删除。

批量更新：PUT /v1/batch/
# 批量更新多条记忆（每条用 memory_id + data 指定）
curl -X PUT http://:3306/v1/batch/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "memories": [ {"memory_id": "", "data": "更新内容1"}, {"memory_id": "", "data": "更新内容2"} ] }'

批量删除：DELETE /v1/batch/
# 批量删除多条记忆（每条只需 memory_id）
curl -X DELETE http://:3306/v1/batch/ \ -H "Content-Type: application/json" \ -H "Authorization: Token " \ -d '{ "memories": [ {"memory_id": ""}, {"memory_id": ""} ] }' 实体管理 管理系统中注册的用户、智能体、会话等实体。

获取实体列表：GET /v1/entities/

删除实体下所有记忆：DELETE /v2/entities/{entity_type}/{entity_id}/，其中entity_type 支持：user、agent、app、run。

请求示例：
# 获取所有实体列表
curl -X GET http://:3306/v1/entities/ \ -H "Authorization: Token "

# 删除指定实体下所有记忆（示例：删除用户 user_001 的全部记忆）
curl -X DELETE http://:3306/v2/entities/user/user_001/ \ -H "Authorization: Token " 获取实体列表返回示例： { "results": { "users": ["user_001"], "agents": [], "apps": [], "runs": [] } } 记忆历史 获取指定记忆的变更历史记录。

请求地址：GET /v1/memories/{memory_id}/history/

请求示例： curl -X GET http://:3306/v1/memories//history/ \ -H "Authorization: Token " 返回示例： [ { "id": "0421a406-xxxx-xxxx-xxxx-7a0e886ead99", "memory_id": "d6b4fac6-xxxx-xxxx-xxxx-3289a763b6dc", "old_memory": null, "new_memory": "最爱吃川菜里的水煮鱼", "event": "ADD", "created_at": "2026-06-24T00:27:19.772241-07:00", "updated_at": null, "is_deleted": false, "actor_id": null, "role": null }, { "id": "085674b6-xxxx-xxxx-xxxx-5392c72dc5b8", "memory_id": "d6b4fac6-xxxx-xxxx-xxxx-3289a763b6dc", "old_memory": "最爱吃川菜里的水煮鱼", "new_memory": "最爱吃川菜里的水煮鱼和麻婆豆腐", "event": "UPDATE", "created_at": "2026-06-24T00:27:19.772241-07:00", "updated_at": "2026-06-24T00:27:47.207790-07:00", "is_deleted": false, "actor_id": null, "role": null } ]

上一篇：使用原生向量索引进行相似性检索下一篇：AI Function

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
