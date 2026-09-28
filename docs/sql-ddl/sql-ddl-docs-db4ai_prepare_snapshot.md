# DB4AI.PREPARE\_SNAPSHOT

PREPARE\_SNAPSHOT是DB4AI特性中数据准备模型训练和解释快照进行协作。快照为所有应用更改的数据和文档提供了完整的序列。通过语法PREPARE SNAPSHOT调用。

**表 1**  DB4AI.PREPARE\_SNAPSHOT入参和返回值列表

i_schema IN  NAME 快照存储的模式名字，默认值是当前用户或者PUBLIC。
i_parent IN  NAME 父快照名称。
i_commands IN  TEXT[] 定义快照修改的DDL和DML命令。
i_vers IN  NAME 版本后缀。
i_comment IN  TEXT 此数据策展单元的说明。
res OUT  db4ai.snapshot_name 结果。
