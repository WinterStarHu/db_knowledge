# 附录

以下为智能问答模块与知识库管理模块中相关表的详细结构设计。其中，历史问答表（qa\_record）存放用户提出问题的详细信息，知识片段表（gauss\_kb\_zh）存放文档片段的详细信息，知识库管理表（knowledge\_base）存放当前创建的所有知识库的详细信息，数据源管理表（data\_source）存放当前数据源的详细信息。

**表 1**  历史问答表（qa\_record）

question_id 问题id text question text answer_id 回答id text answer 完整回答（包括步骤等） text user_id 用户id text session_id 会话id text switch 是否开启搜索 text vector_topk 向量检索返回的结果数 text text_topk 文本检索返回的结果数 text rerank_topk 重排序后返回的结果数 text kb_id 知识库，查询的搜索空间 text version 版本，进行版本过滤 text model_name 用于生成结果的大模型名称 text model_config 大模型超参 text lang text task_type 任务类型 text like text hate text feedback_info 反馈信息 text report_type 举报类型 text report_info 举报信息 text create_time 数据源创建时间 text update_time 数据源更新时间 text

**表 2**  知识片段表（gauss\_kb\_zh）

uuid 知识片段唯一标识 text text 知识片段文本内容 text field 知识片段所属领域 text sub_field 子领域 text source 文档来源 text version 知识片段对应版本信息 text product_format 产品形态 text doc_location 文档名 text
title
来源文档中的具体信息 text visualize 格式化信息 text link text context uuid列表 text keyword 关键词 text confidence 置信度 text ds_id 数据源id text prev_uuid 上一个知识片段uuid text next_uuid 下一个知识片段uuid text text_vector 知识向量 floatvector(1024)

**表 3**  知识库管理表（knowledge\_base）

kb_id 知识库id integer name 知识库名称 text user_id 知识库用户 text kb_type 知识库类型 text
description
知识库描述 text context 知识库参数 text create_time 知识库创建时间 text update_time 知识库更新时间 text

**表 4**  数据源管理表（data\_source）

ds_id 数据源id integer name 数据源名称 text related_kb_id 数据源对应的知识库 integer
description
数据源描述 text file_name 数据源对应文档名 text create_time 数据源创建时间 text update_time 数据源更新时间 text

以下为智能运维模块中相关表的详细结构设计。

1. 短期记忆表（tb\_interaction\_memory）记录智能运维模块工具交互时的对话内容；
2. 集群管理表（tb\_managed\_cluster）记录GaussMaster服务已支持诊断的集群信息。

**表 5**  短期记忆表（tb\_interaction\_memory）

属性名 nullable qa_record_id 主键，QA对ID String False user_id 用户ID String False session_id 会话ID String False question 用户问题 TEXT False answer TEXT True llm_name 大语言模型名字 String True function_call 工具调用结果 TEXT True created_at 对话发生时间 BigInteger False

**表 6**  集群管理表（tb\_managed\_cluster）

属性名 nullbale cluster_id 集群ID INT cluster_name 集群名称 STRING host 集群IP地址 STRING port 集群端口号 INT username 用户名 TEXT password 加密后的密码 TEXT
