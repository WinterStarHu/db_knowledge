# PG\_TS\_TEMPLATE

PG\_TS\_TEMPLATE系统表包含定义文本搜索模板的记录。模板是文本搜索字典的类的实现框架。因为模板必须通过C语言级别的函数实现，索引新模板的创建必须由数据库系统管理员创建。

**表 1**  PG\_TS\_TEMPLATE字段

oid oid 行标识符（隐含属性，必须明确选择）。
tmplname name 文本搜索模板名。
tmplnamespace oid PG_NAMESPACE.oid 包含这个模板的名称空间的OID。
tmplinit regproc PG_PROC.proname 模板的初始化函数名。
tmpllexize regproc PG_PROC.proname 模板的lexize函数名。
