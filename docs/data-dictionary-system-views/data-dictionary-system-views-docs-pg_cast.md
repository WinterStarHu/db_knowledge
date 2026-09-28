# PG\_CAST

PG\_CAST系统表存储数据类型之间的转化关系。

**表 1**  PG\_CAST字段

oid oid 行标识符（隐含属性，必须明确选择）。
castsource oid 源数据类型的OID。
casttarget oid 目标数据类型的OID。
castfunc oid 转化函数的OID。如果为零表明不需要转化函数。
castcontext "char" castmethod "char" castowner oid 转换的属主。
