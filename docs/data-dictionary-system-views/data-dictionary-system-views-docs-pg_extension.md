# PG\_Extension

PG\_Extension系统表存储关于所安装扩展的信息。openGauss默认扩展是PLPGSQL和MOT\_FDW。

**表 1**  PG\_Extension

oid oid 数据库对象id。
extname name 扩展名。
extowner oid 扩展的所有者。
extnamespace oid 扩展导出对象的名称空间。
extrelocatable Boolean 标识此扩展是否可迁移到其他名称空间，true表示允许。
extversion text 扩展的版本号。
extconfig oid[] 扩展的配置信息。
extcondition text[] 扩展配置信息的过滤条件。
