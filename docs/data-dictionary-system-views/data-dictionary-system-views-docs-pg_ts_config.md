# PG\_TS\_CONFIG

PG\_TS\_CONFIG系统表包含表示文本搜索配置的记录。一个配置指定一个特定的文本搜索解析器和一个为了每个解析器的输出类型使用的字典的列表。

解析器在PG\_TS\_CONFIG记录中显示，但是字典映射的标记是由[PG\_TS\_CONFIG\_MAP](pg_ts_config_map.md)里面的辅助记录定义的。

**表 1**  PG\_TS\_CONFIG字段

oid oid 行标识符（隐含属性，必须明确选择）。
cfgname name 文本搜索配置名。
cfgnamespace oid PG_NAMESPACE.oid 包含这个配置的名称空间的OID。
cfgowner oid PG_AUTHID.oid 配置的所有者。
cfgparser oid PG_TS_PARSER.oid 这个配置的文本搜索解析器的OID。
cfoptions text[] 分词相关配置选项。
