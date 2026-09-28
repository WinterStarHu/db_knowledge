# DB4AI.CREATE\_SNAPSHOT

CREATE\_SNAPSHOT是DB4AI特性用于创建快照的接口函数。通过语法CREATE SNAPSHOT调用。

**表 1**  DB4AI.CREATE\_SNAPSHOT入参和返回值列表

i_schema IN NAME 快照存储的模式名字，默认值是当前用户或者PUBLIC。
i_name IN NAME 快照名称。
i_commands IN TEXT[] 定义数据获取的SQL命令。
i_vers IN NAME 版本后缀。
i_comment IN TEXT 快照描述。
res OUT db4ai.snapshot_name 结果。
