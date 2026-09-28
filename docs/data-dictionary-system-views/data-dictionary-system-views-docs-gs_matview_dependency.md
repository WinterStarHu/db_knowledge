# GS\_MATVIEW\_DEPENDENCY

GS\_MATVIEW\_DEPENDENCY系统表提供了关于数据库中每一个增量物化视图、基表和mlog表的关联信息。全量物化视图不存在与基表对应的mlog表，不会写入记录。

**表 1**  GS\_MATVIEW\_DEPENDENCY字段

oid oid 行标识符（隐含属性，必须明确选择）。
matviewid oid 物化视图的oid。
relid oid 物化视图基表的oid。
mlogid oid 物化视图mlog表的oid，mlog表为物化视图日志表，与基表一一对应。
mxmin int4 保留字段。
