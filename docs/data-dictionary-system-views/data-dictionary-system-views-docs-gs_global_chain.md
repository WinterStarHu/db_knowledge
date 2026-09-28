# GS\_GLOBAL\_CHAIN

GS\_GLOBAL\_CHAIN系统表记录用户对防篡改用户表的修改操作信息，每条记录对应一次表级修改操作。具有审计管理员权限的用户可以查询此系统表，所有用户均不允许修改此系统表。

**表 1**  GS\_GLOBAL\_CHAIN字段

blocknum bigint 区块号，当前用户操作在账本中记录的序号。
dbname name 数据库名称。被修改的防篡改用户表所属的database。
username name 用户名，执行用户表修改操作的用户名。
starttime timestamp with time zone 用户操作执行的最新时间戳。
relid oid 用户表Oid，被修改的防篡改用户表Oid。
relnsp name 模式Oid，被修改的防篡改用户表所属的namesapce oid。
relname name 用户表名，被修改的防篡改用户表名。
relhash hash16 当前操作产生的表级别hash变化量。
globalhash hash32 全局摘要，由当前行信息与前一行globalhash计算而来，将整个表串联起来，用于验证GS_GLOBAL_CHAIN数据完整性。
txcommand text 被记录操作的SQL语句。
