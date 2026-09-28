# DB4AI.SNAPSHOT

SNAPSHOT表记录当前用户通过特性DB4AI.SNAPSHOT存储的快照。

**表 1**  db4ai.snapshot表属性

bigint 当前快照的ID。
parent_id bigint 父快照的ID。
matrix_id bigint CSS模式下快照的矩阵ID，否则为NULL。
root_id bigint 初始快照的ID，通过db4ai.create_snapshot()从操作数据构建。
schema name 导出快照视图的模式。
public name name 快照的名称，包括版本后缀。
example0@1.1.0 owner name 创建此快照的用户的名称。
commands text[] 记录如何从其根快照生成到此快照的SQL语句的完整列表。
{DELETE,"WHERE id &gt; 7"} comment text 快照说明。
inherits from @1.0.0 published boolean TRUE，当且仅当快照当前已发布。
archived boolean TRUE，当且仅当快照当前已存档。
created timestamp without time zone 快照创建日期的时间戳。
2021-08-25 10:59:52.955604 row_count bigint 此快照中的数据行数。
