# PG\_TS\_PARSER

PG\_TS\_PARSER系统表包含定义文本解析器的记录。解析器负责分裂输入文本为词位，并且为每个词位分配标记类型。新解析器必须由数据库系统管理员创建。

**表 1**  PG\_TS\_PARSER字段

oid oid 行标识符（隐含属性，必须明确选择）。
prsname name 文本搜索解析器名。
prsnamespace oid PG_NAMESPACE.oid 包含这个解析器的名称空间的OID。
prsstart regproc PG_PROC.proname 解析器的启动函数名。
prstoken regproc PG_PROC.proname 解析器的下一个标记函数名。
prsend regproc PG_PROC.proname 解析器的关闭函数名。
prsheadline regproc PG_PROC.proname 解析器的标题函数名。
prslextype regproc PG_PROC.proname 解析器的lextype函数名。
