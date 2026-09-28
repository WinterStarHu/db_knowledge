# PG\_TRIGGER

PG\_TRIGGER系统表存储触发器信息。

**表 1**  PG\_TRIGGER字段

oid oid 行标识符（隐含属性，必须明确选择）。
tgrelid oid 触发器所在表的OID。
tgname name 触发器名。
tgfoid oid 要被触发器调用的函数。
tgtype smallint 触发器类型。
tgenabled "char" O =触发器在“origin”和“local”模式下触发。
D =触发器被禁用。
R =触发器在“replica”模式下触发。
A =触发器始终触发。
tgisinternal boolean 内部触发器标识，如果为true表示内部触发器。
tgconstrrelid oid 完整性约束引用的表。
tgconstrindid oid 完整性约束的索引。
tgconstraint oid 约束触发器在pg_constraint中的OID。
tgdeferrable boolean 约束触发器是为DEFERRABLE类型。
tginitdeferred boolean 约束触发器是否为INITIALLY DEFERRED类型。
tgnargs smallint 触发器函数入参个数。
tgattr int2vector 当触发器指定列时的列号，未指定则为空数组。
tgargs bytea 传递给触发器的参数。
tgqual pg_node_tree 表示触发器的WHEN条件，如果没有则为null。
tgowner oid 触发器的所有者。
tgordername name 原始触发器名称。
tgorder name 触发器是否控制触发先后顺序。
tgtime name 触发器创建的时间点。
