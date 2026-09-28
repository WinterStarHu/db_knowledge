# GS\_CLIENT\_GLOBAL\_KEYS

GS\_CLIENT\_GLOBAL\_KEYS系统表记录密态等值特性中客户端加密主密钥相关信息，每条记录对应一个客户端加密主密钥。

**表 1**  GS\_CLIENT\_GLOBAL\_KEYS字段

oid oid 行标识符（隐含字段）。
global_key_name name 客户端加密主密钥（cmk）名称。
key_namespace oid 包含此客户端加密主密钥（cmk）的命名空间oid。
key_owner oid 客户端加密主密钥（cmk）的所有者。
key_acl aclitem[] 创建该密钥时所拥有的访问权限。
create_date timestamp 创建密钥的时间。
