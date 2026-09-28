# PG\_FOREIGN\_DATA\_WRAPPER

PG\_FOREIGN\_DATA\_WRAPPER系统表存储外部数据封装器定义。一个外部数据封装器是在外部服务器上驻留外部数据的机制，是可以访问的。

**表 1**  PG\_FOREIGN\_DATA\_WRAPPER字段

oid oid 行标识符（隐含属性，必须明确选择）。
fdwname name 外部数据封装器名。
fdwowner oid PG_AUTHID.oid 外部数据封装器的所有者。
fdwhandler oid PG_PROC.oid 引用一个负责为外部数据封装器提供扩展例程的处理函数。如果没有提供处理函数则为零。
fdwvalidator oid PG_PROC.oid 引用一个验证器函数，这个验证器函数负责验证给予外部数据封装器的选项、外部服务器选项和使用外部数据封装器的用户映射的有效性。如果没有提供验证器函数则为零。
fdwacl aclitem[] 访问权限。
fdwoptions text[] 外部数据封装器指定选项，使用“keyword=value”格式的字符串。
