# PG\_EVENT\_TRIGGER

PG\_EVENT\_TRIGGER系统表存储每个事件触发器的信息。

**表 1**  PG\_EVENT\_TRIGGER字段

evtname name 触发器名（必须唯一）。
evtevent name 此触发器触发的事件的标识符。
evtowner oid pg_authid.oid 事件触发器的拥有者。
evtfoid oid pg_proc.oid 将被调用的函数。
evtenabled char 控制事件触发器触发的会话复制角色模式。 O = 触发器在“origin”和“local”模式触发， D = 触发器被禁用， R = 触发器在“replica”模式触发， A = 触发器总是触发。
evttags text[] 此触发器将触发的命令标签。如果为空，此触发器的触发不受命令标签的限制。
