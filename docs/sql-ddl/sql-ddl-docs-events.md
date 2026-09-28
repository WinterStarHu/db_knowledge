# EVENTS

存储事件相关的信息。

**表 1**  EVENTS字段

event_catalog varchar(64) 事件所在的数据库名。
event_schema varchar(64) 事件所在schema名。
event_name varchar(64) 事件名。
definer varchar(288) 事件创建者。
time_zone varchar(64) 事件执行时区。
event_body varchar(3) 事件执行体类型。
event_definition text 事件执行体。
event_type varchar(9) 事件类型。
execute_at timestamp 事件执行时间。
interval_value varchar(256) 时间执行周期。
interval_field text 事件执行周期单位。
sql_mode text 当前dolphin.sql_mode的值。
starts timestamp 周期型事件的开始时间。
ends timestamp 周期型事件的结束时间。
status varchar(21) 事件状态。
on_completion varchar(12) 事件完成后的处理方式。
created timestamp 事件创建时间。
last_altered timestamp 事件最后修改时间。
last_executed timestamp 事件最后执行时间。
event_comment varchar(2048) 事件注释。
originator int 创建事件的服务器id。
character_set_client varchar(64) 客户端的字符集。
collation_connection varchar(64) 当前数据库的字符序。
database_collation varchar(64) 当前数据库的字符序。
