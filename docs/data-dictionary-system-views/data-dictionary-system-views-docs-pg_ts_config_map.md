# PG\_TS\_CONFIG\_MAP

PG\_TS\_CONFIG\_MAP系统表包含为每个文本搜索配置的解析器的每个输出符号类型，显示哪个文本搜索字典应该被咨询、以什么顺序搜索的记录。

**表 1**  PG\_TS\_CONFIG\_MAP字段

mapcfg oid PG_TS_CONFIG.oid 拥有这个映射记录的PG_TS_CONFIG记录的OID。
maptokentype integer 由配置的解析器产生的一个符号类型值。
mapseqno integer 在相同mapcfg或maptokentype值的情况下，该符号类型的顺序号。
mapdict oid PG_TS_DICT.oid 要咨询的文本搜索字典的OID。
