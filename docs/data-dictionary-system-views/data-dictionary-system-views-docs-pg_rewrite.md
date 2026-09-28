# PG\_REWRITE

PG\_REWRITE系统表存储为表和视图定义的重写规则。

**表 1**  PG\_REWRITE字段

oid oid 行标识符（隐含属性，必须明确选择）。
rulename name 规则名称。
ev_class oid 使用这条规则的表名称。
ev_attr smallint 这条规则适用的字段（目前总是为零，表示整个表）。
ev_type "char" ev_enabled "char" is_instead boolean 如果该规则是INSTEAD规则，则为真。
ev_qual pg_node_tree 规则的资格条件的表达式树（以nodeToString()形式存在）。
ev_action pg_node_tree 规则动作的查询树（以nodeToString()形式存在）。
