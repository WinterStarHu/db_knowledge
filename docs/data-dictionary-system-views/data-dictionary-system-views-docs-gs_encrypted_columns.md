# GS\_ENCRYPTED\_COLUMNS

GS\_ENCRYPTED\_COLUMNS系统表记录密态等值特性中表的加密列相关信息，每条记录对应一条加密列信息。

**表 1**  GS\_ENCRYPTED\_COLUMNS字段

oid oid 行标识符（隐含字段）。
rel_id oid 表的OID。
column_name name 加密列的名称。
column_key_id oid 外键，列加密密钥的OID。
encryption_type int1 加密类型，取值为2（DETERMINISTIC）或者1（RANDOMIZED）。
data_type_original_oid oid 加密列的原始数据类型id，参考系统表PG_TYPE中的oid。
data_type_original_mod int4 加密列的原始数据类型修饰符，参考系统表PG_ATTRIBUTE中的atttypmod。其值对那些不需要的类型data_type_original_mod通常为-1。
create_date timestamp 创建加密列的时间。
