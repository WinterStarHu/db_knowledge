# PG\_PUBLICATION\_REL

系统表PG\_PUBLICATION\_REL包含当前数据库中的表和publication之间的映射，这是一种多对多映射。

**表 1**  PG\_PUBLICATION\_REL字段

oid oid &nbsp;
行标识符（隐含属性，必须明确选择）。
prpubid oid 对publication的引用。
prrelid oid 对表的引用。
