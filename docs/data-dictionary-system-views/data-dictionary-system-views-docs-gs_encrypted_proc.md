# GS\_ENCRYPTED\_PROC

GS\_ENCRYPTED\_PROC系统表提供了密态函数/存储过程函数参数、返回值的原始数据类型，加密列等信息。

**表 1**  GS\_ENCRYPTED\_PROC字段

oid oid 行标识符（隐含字段）。
func_id oid function的oid，对应pg_proc系统表中的oid行标识符。
prorettype_orig int4 返回值的原始数据类型。
proargcachedcol oidvector 函数INPUT参数对应的加密列的oid，对应gs_encrypted_columns系统表中的oid行标识符。
proallargtypes_orig oid[] 所有函数参数的原始数据类型。
