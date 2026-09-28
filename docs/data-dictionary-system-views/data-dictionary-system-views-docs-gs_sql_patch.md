# GS\_SQL\_PATCH

GS\_SQL\_PATCH系统表存储所有SQL\_PATCH的状态信息。

**表 1**  GS\_SQL\_PATCH字段

patch_name name PATCH名称。
unique_sql_id bigint 查询全局唯一ID。
owner oid PATCH的创建用户ID。
enable bool PATCH是否生效。
status "char" PATCH的状态（预留字段）。
abort bool 是否是AbortHint。
hint_string text Hint文本。
hint_node pg_node_tree Hint解析&amp;序列化的结果。
original_query text 原始语句（预留字段）。
patched_query text PATCH之后的语句（预留字段）。
original_query_tree pg_node_tree 原始语句的解析结果（预留字段）。
patched_query_tree pg_node_tree PATCH之后语句的解析结果（预留字段）。
Description text PATCH的备注。
