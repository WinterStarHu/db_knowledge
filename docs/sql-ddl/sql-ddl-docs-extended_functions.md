# 扩展函数

下表列举了openGauss中支持的扩展函数，不作为商用特性交付，仅供参考。

函数名称 访问权限查询函数 has_sequence_privilege(user, sequence, privilege) 指定用户是否有访问序列的权限 has_sequence_privilege(sequence, privilege) 当前用户是否有访问序列的权限 触发器函数 pg_get_triggerdef(oid) 为触发器获取CREATE [ CONSTRAINT ] TRIGGER命令 pg_get_triggerdef(oid, boolean) 为触发器获取CREATE [ CONSTRAINT ] TRIGGER命令
