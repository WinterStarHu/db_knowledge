# PG\_Extension_DATA\_SOURCE

PG\_Extension_DATA\_SOURCE系统表存储外部数据源对象的信息。一个外部数据源对象（Data Source）包含了外部数据库的一些口令编码等信息，主要配合Extension Connector使用。

**表 1**  PG\_Extension_DATA\_SOURCE字段

oid oid 行标识符（隐含属性，必须明确选择）。
srcname name 外部数据源对象的名称。
srcowner oid PG_AUTHID.oid 外部数据源对象的所有者。
srctype text 外部数据源对象的类型，缺省为空。
srcversion text 外部数据源对象的版本，缺省为空。
srcacl aclitem[] 访问权限。
srcoptions text[] 外部数据源对象的指定选项，使用“keyword=value”格式的字符串。
