# PG\_DEFAULT\_ACL

PG\_DEFAULT\_ACL系统表存储为新建对象设置的初始权限。

**表 1**  PG\_DEFAULT\_ACL字段

oid oid 行标识符（隐含属性，必须明确选择）。
defaclrole oid 与此权限相关的角色ID。
defaclnamespace oid 与此权限相关的名称空间，如果没有，则为0。
defaclobjtype "char" 此权限的对象类型。
r表示表或视图。S表示序列。f表示函数。T表示类型。K表示客户端主密钥。k表示列加密密钥。
defaclacl aclitem[] 创建该类型时所拥有的访问权限。
