# 低成本上下文存储（外列）-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/external-column

低成本上下文存储（外列）-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

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

低成本上下文存储（外列）

低成本上下文存储（外列）

更新时间：

复制 MD 格式

产品详情 我的收藏

外列（External Column）是PolarDB-X提供的将表中大字段（如AI会话正文、JSON快照、图片或PDF等二进制附件）从主表卸载到OSS的能力。建表时只需在大字段后加上EXTERNALIZE关键字，业务SQL写法零改动，即可获得更低存储成本、更稳服务表现以及更优内存利用率。

背景说明 Agent / Copilot类应用正在成为OLTP数据库中增长最快、最“重”的负载。以一张典型的chat_messages表为例，结构化元数据（session_id / user_id / role / ts / token）每行不过百来字节，承担几乎所有过滤和聚合。而content / tool_calls / context_snapshot / attachments等JSON大字段，单条从数KB到数MB不等，一次RAG检索回灌的上下文、一段工具返回的长JSON、一张截图的base64，都会让单行轻松突破百KB。这部分Payload占总数据量95%以上，会带来较大存储成本、Buffer Pool争抢污染、备份体积膨胀等代价。
PolarDB-X的外列是一种将表中的大字段（例如AI会话的对话正文、思考链，或者图片、PDF等二进制附件）从主表拆到OSS的能力。拆出去之后，主表只保留一个地址指针，大字段的实体存储在OSS上。在PolarDB-X使用外列无需改动业务，建表时在大字段后面加一个EXTERNALIZE关键字即可，INSERT / UPDATE / DELETE / SELECT写法与普通表完全一样。
功能优势

更低的成本：大字段存入OSS，存储成本从SSD降为对象存储价格，同时基于OSS的备份采用重删等技术，备份成本更低。

更稳的服务：数据节点（DN）的Binlog体积从MB级降到KB级，同库其他业务的Commit不再受大列写入影响，尾部延迟更稳定。

更优的内存：原本Buffer Pool会因大文本挤占有限的内存空间，基于外列卸载，Buffer Pool只缓存高频访问的小元数据，相同内存下有更好的缓存效率。
典型场景 AI Agent的会话存储是外列的典型场景。一次会话里塞着多轮对话、代码片段、工具调用结果，单条消息从KB到MB都有，会话总量从百万膨胀到亿级。直接存InnoDB会让Binlog膨胀、Buffer Pool被挤占，且业务写MySQL + OSS双系统又要考虑事务一致性和垃圾回收（GC）。外列把两者结合：InnoDB的简单和事务语义 + OSS的低成本，复杂度由引擎承担。
CREATE TABLE chat_messages ( id         BIGINT PRIMARY KEY AUTO_INCREMENT, session_id BIGINT, user_id    BIGINT, role       ENUM('user','assistant','system'), token_count INT, created_at DATETIME, content    LONGTEXT EXTERNALIZE, KEY idx_session (session_id, created_at) ) PARTITION BY KEY(session_id);

-- 写入 INSERT INTO chat_messages(session_id, user_id, role, content, token_count, created_at) VALUES (10001, 42, 'user', '{...对话内容...}', 1200, NOW());

-- 拼接上下文 SELECT role, content FROM chat_messages WHERE session_id = 10001 ORDER BY created_at DESC LIMIT 20;

-- 更新 UPDATE chat_messages SET content = '{...新内容...}' WHERE id = 1;

-- 删除 DELETE FROM chat_messages WHERE session_id = 10001;
对 ORM（MyBatis/JPA）及 AI 框架（LangChain/LlamaIndex）完全透明，业务侧零代码改造，仅凭后端单张MySQL表即可实现会话数据的无感接入。
版本要求

仅支持企业版实例。

实例版本需为2.6.0_5.4.21-20260619及以上版本。

说明

实例版本的规则说明，请参见版本说明。

实例版本的查看方式，请参见查看实例版本。
语法 建表 在列定义末尾加上EXTERNALIZE关键字，表示这一列的数据要外置到OSS： CREATE TABLE chat_messages ( id         BIGINT PRIMARY KEY AUTO_INCREMENT, session_id BIGINT, user_id    BIGINT, role       ENUM('user','assistant','system'), token_count INT, created_at DATETIME, content    LONGTEXT EXTERNALIZE, KEY idx_session (session_id, created_at) ) PARTITION BY KEY(session_id);
加列 已有的表也可以通过ALTER TABLE加外列： ALTER TABLE chat_messages ADD COLUMN reasoning LONGTEXT EXTERNALIZE;
支持的类型

文本族：TEXT / TINYTEXT / MEDIUMTEXT / LONGTEXT

二进制族：BLOB / TINYBLOB / MEDIUMBLOB / LONGBLOB 字符集要求列字符集省略或属于utf8家族（utf8 / utf8mb3 / utf8mb4），其他字符集会在建表时直接报错。
查看建表语句 SHOW CREATE TABLE输出的是逻辑视图：您看到的仍然是content LONGTEXT EXTERNALIZE，而不是底层物理列名。对您来说，物理实现是完全透明的。

业务透明 建表之后，业务SQL的写法没有任何变化： INSERT INTO chat_messages(session_id, user_id, role, content, token_count, created_at) VALUES (10001, 42, 'assistant', '{...回复内容...}', 800, NOW());

UPDATE chat_messages SET content = '{...新内容...}' WHERE id = 1;

SELECT content FROM chat_messages WHERE session_id = 10001;
数据库在底层自动完成大字段到OSS的上传和拉取，应用层感知不到这个过程。如果一条SQL不涉及外列（比如只查ROLE），它走的是纯数据节点（DN）路径，性能与普通表完全无差异。
工作原理

引擎按列大小自动分流

百KB以上：写入时直接上传到OSS，主表只存一个地址指针。Commit前等OSS确认完成，事务语义完整。

KB级：先写入本地staging表（InnoDB），落表即返回，后台异步flush到OSS。写入延迟 = 直写InnoDB，长期存储仍是OSS价格。

读取走四级缓存

本地内存 → 本地SSD → RPC到其他计算节点（CN） → OSS回源。绝大多数热读在前两级命中，并不会流转至OSS。

删除由引擎自动管理

DELETE一行后，对应的OSS对象在所有活跃事务结束后被GC清理，应用层无需写对账脚本或手动删除。
核心收益

写入不变慢：KB级大列的写入延迟和直接写InnoDB一样，百KB以上大列在高并发下比InnoDB更快。

读取几乎无感：热读命中本地缓存，延迟与普通列查询相当。

运维零负担：无需对账脚本、无需手动清理OSS，引擎全自动。
使用示例 场景一：多模态消息的列拆分 一个AI assistant的回复可能包含：回答正文、附件、工具调用结果、思考链。这些字段读频率不同：content每次拼上下文都要读，reasoning通常只在审计时才被访问。
CREATE TABLE chat_messages_v2 ( id          BIGINT PRIMARY KEY AUTO_INCREMENT, session_id  BIGINT, role        ENUM('user','assistant','system'), token_count INT, created_at  DATETIME, content     LONGTEXT EXTERNALIZE, attachments LONGBLOB EXTERNALIZE, tool_calls  LONGTEXT EXTERNALIZE, reasoning   LONGTEXT EXTERNALIZE, KEY idx_session (session_id, created_at) ) PARTITION BY KEY(session_id);

-- 写入一条多模态消息 INSERT INTO chat_messages_v2(session_id, role, content, reasoning, token_count, created_at) VALUES (10001, 'assistant', '回答正文...', '思考链内容...', 3500, NOW());

-- 日常拼接只读 content SELECT content FROM chat_messages_v2 WHERE session_id = 10001 ORDER BY created_at;

-- 审计时才读 reasoning SELECT reasoning FROM chat_messages_v2 WHERE id = 12345;
缓存粒度按列走：每个外列对应独立的OSS对象和缓存条目。

content被反复SELECT，LRU一直把它留在本地缓存。

reasoning没人碰，自然被淡出到OSS。

审计时再SELECT reasoning，回源OSS几十毫秒拉回来，调试场景完全可接受。
场景二：和AI框架对接 外列对 ORM（MyBatis/JPA）及 AI 框架（LangChain/LlamaIndex）完全透明，以Spring AI和LangChain4j为例：两种契约、两种schema，都是纯SQL。
Spring AI（按条追加） “按条追加”语义跟前面的chat_messages表天然匹配，直接复用同一张表： -- 复用前面的 chat_messages 表 CREATE TABLE chat_messages ( id         BIGINT PRIMARY KEY AUTO_INCREMENT, session_id BIGINT, user_id    BIGINT, role       ENUM('user','assistant','system'), token_count INT, created_at DATETIME, content    LONGTEXT EXTERNALIZE, KEY idx_session (session_id, created_at) ) PARTITION BY KEY(session_id);
public class PolarDBXChatMemory implements ChatMemory { private final JdbcTemplate jdbc;

@Override public void add(String conversationId, Message message) { jdbc.update( "INSERT INTO chat_messages(session_id, role, content, created_at) " + "VALUES (?, ?, ?, NOW())", conversationId, message.getMessageType().name(), message.getText());
}

@Override public List get(String conversationId, int lastN) { return jdbc.query( "SELECT role, content FROM chat_messages WHERE session_id = ? " + "ORDER BY created_at DESC LIMIT ?", (rs, i) -> toMessage(rs.getString("role"), rs.getString("content")), conversationId, lastN);
}

@Override public void clear(String conversationId) { jdbc.update("DELETE FROM chat_messages WHERE session_id = ?", conversationId);
} } LangChain4j（全量替换） “全量替换”语义更适合一张KV表，整个session的消息序列化成JSON存进一个外列： CREATE TABLE chat_memory_store ( session_id BIGINT PRIMARY KEY, messages   LONGTEXT EXTERNALIZE );
public class PolarDBXChatMemoryStore implements ChatMemoryStore { private final JdbcTemplate jdbc;

@Override public List getMessages(Object sessionId) { String json = jdbc.query( "SELECT messages FROM chat_memory_store WHERE session_id = ?", rs -> rs.next() ? rs.getString(1) : null, sessionId);
return json == null ? List.of() : ChatMessageDeserializer.messagesFromJson(json);
}

@Override public void updateMessages(Object sessionId, List messages) { String json = ChatMessageSerializer.messagesToJson(messages);
jdbc.update( "INSERT INTO chat_memory_store(session_id, messages) VALUES (?, ?) " + "ON DUPLICATE KEY UPDATE messages = VALUES(messages)", sessionId, json);
}

@Override public void deleteMessages(Object sessionId) { jdbc.update("DELETE FROM chat_memory_store WHERE session_id = ?", sessionId);
} } 使用限制 DDL

操作 是否支持 说明

CREATE TABLE ... EXTERNALIZE 支持 表必须有主键。

ALTER TABLE ADD COLUMN ... EXTERNALIZE 支持 表必须有主键。

ALTER TABLE DROP COLUMN 支持 OSS对象异步清理。

ALTER TABLE MODIFY 外列

不支持 需先DROP再ADD。

ALTER TABLE CHANGE 外列

不支持 需先DROP再ADD。

DEFAULT 'xxx' 不支持 外列不能设默认值。

普通索引（INDEX / UNIQUE / FULLTEXT） 不支持 但可以出现在全局二级索引（GSI）的覆盖（covering）列里。

删除最后一个列存索引（CCI） 不支持 外列依赖列存索引（CCI）工作。

TRUNCATE TABLE 不支持 —

RENAME TABLE 不支持 —

CREATE TABLE AS SELECT（源表含外列） 不支持 —

ADD CHECK 约束 不支持 —

非utf8字符集 不支持 仅允许utf8 / utf8mb3 / utf8mb4。
DQL / DML 当WHERE条件或UPDATE SET涉及外列时，SQL不会下推到数据节点（DN）执行，而是在计算节点（CN）侧完成，执行代价和耗时可能会增加。实际使用中，大字段通常按主键定位，这个限制一般不会成为瓶颈。
性能参考 以下数据来自4个计算节点（CN） + 4个数据节点（DN）的公有云实例，简单Schema（主键 + 一个MEDIUMBLOB）。
小列写入（KB级） 小列走staging路径，写入就是一次数据节点（DN）本地的InnoDB INSERT。只要没有触发反压（staging表积压达到阈值），写入延迟和直接写InnoDB完全一致，对KB级大列的场景非常友好。
大列写入（百KB以上） 大字段直写OSS方案的写入性能受数据大小与并发度的双重驱动。测试表明，外列直写与传统 InnoDB之间存在一个明确的性能拐点（Crossover Point）：

性能拐点大幅提前：在单线程下，数据量达500 KB 时外列方案开始超越InnoDB；而在64并发下，该拐点提前至300 KB；至256并发时，拐点进一步降至140 KB。并发度越高，外列获得优势的起点越低。

突破I/O天花板：跨越拐点后，两者的差距呈指数级拉大。在大字段与高并发的双重压力下，InnoDB会迅速触及磁盘I/O瓶颈并陷入剧烈的锁竞争，导致吞吐量不增反降。而外列方案的主表仅写入数十字节的地址指针，绕过了这一物理限制。

场景对比：在“2 MB 数据 / 256 并发”的高负载场景下，InnoDB的平均延迟已飙升至5.5秒，P99 延迟突破16秒，实际已丧失生产可用性。而外列方案仍能稳定输出478 QPS的吞吐量，平均延迟控制在514毫秒，表现出极强的健壮性。
热读 热读路径上外列和InnoDB各有优劣，整体大致持平。实测16并发下，100 KB列上InnoDB更快，500 KB起外列更快。
但热读上外列有一个隐性优势：不挤占数据节点（DN）的Buffer Pool。InnoDB读大列时整个LOB页会塞进Buffer Pool，这些“读一次就不再热”的大页把索引页和热数据挤出去，同库TP业务跟着变慢。外列从计算节点（CN）本地缓存读取，不经过数据节点（DN）的Buffer Pool，索引页常驻不受影响。
代表性数据点

场景 列大小 并发 InnoDB QPS / Avg / P99 外列 QPS / Avg / P99

INSERT 100 KB 64 3994 / 16 ms / 37 ms 1961 / 33 ms / 64 ms

INSERT 500 KB 64 818 / 78 ms / 225 ms 1258 / 51 ms / 87 ms

INSERT 1 MB 64 317 / 201 ms / 1195 ms 793 / 81 ms / 162 ms

INSERT 2 MB 256 40 / 5561 ms / 48687 ms 478 / 514 ms / 1549 ms

UPDATE 1 MB 64 247 / 257 ms / 1507 ms 526 / 121 ms / 267 ms

Hot Read 100 KB 16 8120 / 2.0 ms / 8.2 ms 5279 / 3.0 ms / 5.9 ms

Hot Read 500 KB 16 3688 / 4.3 ms / 11.7 ms 4186 / 3.8 ms / 19.9 ms

Cold Read 100 KB 64 — 1538 / 28 ms / 48 ms

Cold Read 1 MB 64 — 250 / 95 ms / 190 ms 冷读（本地缓存MISS后从OSS回源）主要是一个OSS GET的固定开销 + 数据传输时间，100 KB约28 ms、1 MB约95 ms。业务对冷读延迟敏感的场景可考虑提前预热。
场景选型

适合外列的场景：按主键 / 会话ID写入和读取的大字段（消息正文、JSON快照、思考链）。也适合存储文件等二进制数据（图片、PDF、音视频）—原本需要业务自己写OSS + 元数据双系统的场景，现在可以直接存进外列，事务一致性和生命周期管理由引擎统一承担。访问模式是“整段存、整段取”，外列正好匹配。

不太合适的场景：

大量冷读回查：缓存MISS后回源OSS有20+ ms延迟。如果场景是频繁翻查历史冷数据且对延迟敏感，需要权衡。

需要对大字段做检索：外列不支持二级索引、全文检索、LIKE模糊查询。需要被检索的字段应留在主表普通列上。

上一篇：什么是PolarDB-X CodeMatrix下一篇：什么是低成本上下文存储（外列）

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
