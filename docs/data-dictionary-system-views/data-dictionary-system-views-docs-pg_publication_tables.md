# PG\_PUBLICATION\_TABLES

视图PG\_PUBLICATION\_TABLES提供publication与其所发布的表之间的映射信息。和底层的系统表pg\_publication\_rel不同，这个视图展开了定义为FOR ALL TABLES的publication，这样对这类publication来说，每一个合格的表都有一行。

**表 1**  PG\_PUBLICATION\_TABLES字段

pubname name 发布的名称。
schemaname name 包含表的模式名称。
tablename name 表的名称。
