# PG\_CONSTRAINT

PG\_CONSTRAINT系统表存储表上的检查约束、主键和唯一约束。

**表 1**  PG\_CONSTRAINT字段

oid oid 行标识符（隐含属性，必须明确选择）。
conname name 约束名称（不一定是唯一的）。
connamespace oid 包含这个约束的名称空间的OID。
contype "char" c = 检查约束。p = 主键约束。u = 唯一约束。t =  触发器约束。
condeferrable boolean 这个约束是否可以推迟。
condeferred boolean 缺省时这个约束是否可以推迟。
convalidated boolean 约束是否有效。目前，只有外键和CHECK约束可将其设置为FALSE。
conrelid oid 这个约束所在的表；如果不是表约束则为0。
contypid oid 这个约束所在的域；如果不是一个域约束则为0。
conindid oid 与约束关联的索引ID。
confrelid oid 如果是外键，则为参考的表；否则为0。
confupdtype "char" confdeltype "char" confmatchtype "char" conislocal boolean 是否是为关系创建的本地约束。
coninhcount integer 约束直接继承父表的数目。继承父表数非零时，不能删除或重命名该约束。
connoinherit boolean 是否可以被继承。
consoft boolean 是否为信息约束（Informational Constraint）。
conopt boolean 是否使用信息约束优化执行计划。
conkey smallint[] 如果是表约束，则是约束控制的字段列表。
confkey smallint[] 如果是一个外键，是参考的字段的列表。
conpfeqop oid[] 如果是一个外键，是做PK=FK比较的相等操作符ID的列表。
conppeqop oid[] 如果是一个外键，是做PK=PK比较的相等操作符ID的列表。
conffeqop oid[] 如果是一个外键，是做FK=FK比较的相等操作符ID的列表。由于当前不支持外键，所以值为空。
conexclop oid[] 如果是一个排他约束，是列的排他操作符ID列表。
conbin pg_node_tree 如果是检查约束，那就是其表达式的内部形式。
consrc text 如果是检查约束，则是表达式的人类可读形式。
conincluding smallint[] 不用做约束，但是会包含在INDEX中的属性列。
condisable boolean 约束是否不使能。目前，只有PRIMARY KEY、UNIQUE和CHECK约束可将其设置为TRUE。

>[!TIP]须知
>
>- consrc在被引用的对象改变之后不会被更新，它不会跟踪字段的名称修改。与其依赖这个字段，最好还是使用pg\_get\_constraintdef\(\)来抽取一个检查约束的定义。
>- pg\_class.relchecks需要和在此表上为给定关系找到的检查约束的数目一致。
