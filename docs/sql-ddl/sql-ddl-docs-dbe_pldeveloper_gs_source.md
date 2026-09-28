# DBE\_PLDEVELOPER.gs\_source

用于记录PLPGSQL对象（存储过程、函数、包、包体）编译相关信息，具体内容见下列字段描述。

无论PLPGSQL对象编译成功或失败，均会把编译信息记录在此表中。

> [!WARNING]注意
>
> - gs_source表中只记录用户定义的原始对象语句，即使用户使用了ALTER改变了创建的SCHEMA或者名字，gs_source表中的信息也不会发生变化，如果用户更改了对象的SCHEMA或者名字，会导致用户在删除对象后，对象仍存在于gs_source表中。
>
> - gs_source表中的owner指创建的用户，不是用户创建存储过程或者package时指定的用户。
>
> - 数据库默认情况下没有对gs_source表中设置行级访问控制，如果用户想使用数据库隔离性特性，请参考以下语句，自行添加行级访问控制。
>
>   ```
>   ALTER TABLE dbe_pldeveloper.gs_source ENABLE ROW LEVEL SECURITY; CREATE ROW LEVEL SECURITY POLICY all_data_rls ON dbe_pldeveloper.gs_source USING(owner = (select oid from pg_roles where rolname=current_user));
>   ```

**表 1**  DBE\_PLDEVELOPER.gs\_source字段

oid 对象的ID。
owner bigint 对象创建用户ID。
nspid oid 对象的模式ID。
name name 对象名。
type text 对象类型（procedure/function/package/package body）。
status boolean 是否创建成功。
src text 对象创建的原始语句。
