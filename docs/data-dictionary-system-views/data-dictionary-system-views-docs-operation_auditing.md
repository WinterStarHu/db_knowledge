# 操作审计

## audit\_system\_object

**参数说明**： 该参数决定是否对openGauss数据库对象的CREATE、DROP、ALTER操作进行审计。openGauss数据库对象包括DATABASE、USER、schema、TABLE等。通过修改该配置参数的值，可以只审计需要的数据库对象的操作。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0～268435455

- 0代表关闭openGauss数据库对象的CREATE、DROP、ALTER操作审计功能。
- 非0代表只审计openGauss的某类或者某些数据库对象的CREATE、DROP、ALTER操作。

**取值说明**：

该参数的值由28个二进制位的组合求出，这28个二进制位分别代表openGauss的26类数据库对象（包含两个保留位）。如果对应的二进制位取值为0，表示不审计对应的数据库对象的CREATE、DROP、ALTER操作；取值为1，表示审计对应的数据库对象的CREATE、DROP、ALTER操作。这26个二进制位代表的具体审计内容请参见[表1](#zh-cn_topic_0283136929_zh-cn_topic_0237124747_zh-cn_topic_0059777487_zh-cn_topic_0058967566_table53712060)。

**默认值**： 67121195

**表 1**  audit\_system\_object取值含义说明

二进制位 取值说明 第0位 是否审计DATABASE对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第1位 是否审计SCHEMA对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第2位 是否审计USER对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第3位 是否审计TABLE对象的CREATE、DROP、ALTER、TRUNCATE操作。
0表示不审计该对象的CREATE、DROP、ALTER、TRUNCATE操作；1表示审计该对象的CREATE、DROP、ALTER、TRUNCATE操作。
第4位 是否审计INDEX对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第5位 是否审计VIEW/MATVIEW对象的CREATE、DROP操作。
0表示不审计该对象的CREATE、DROP操作；1表示审计该对象的CREATE、DROP操作。
第6位 是否审计TRIGGER对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第7位 是否审计PROCEDURE/FUNCTION对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第8位 是否审计TABLESPACE对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第9位 是否审计RESOURCE POOL对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作 第10位 是否审计WORKLOAD对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作 第11位 第12位 是否审计DATA SOURCE对象的CRAETE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；
1表示审计该对象的CREATE、DROP、ALTER操作。
第13位 第14位 是否审计ROW LEVEL SECURITY对象的CREATE、DROP、ALTER操作。
0表示不审计该对象的CREATE、DROP、ALTER操作；1表示审计该对象的CREATE、DROP、ALTER操作。
第15位 是否审计TYPE对象的CREATE、DROP、ALTER操作。
0表示不审计TYPE对象的CREATE、DROP、ALTER操作；1表示审计TYPE对象的CREATE、DROP、ALTER操作。
第16位 是否审计TEXT SEARCH对象（CONFIGURATION和DICTIONARY）的CREATE、DROP、ALTER操作。
0表示不审计TEXT SEARCH对象的CREATE、DROP、ALTER操作；1表示审计TEXT SEARCH对象的CREATE、DROP、ALTER操作。
第17位 是否审计DIRECTORY对象的CREATE、DROP、ALTER操作。
0表示不审计DIRECTORY对象的CREATE、DROP、ALTER操作；1表示审计DIRECTORY对象的CREATE、DROP、ALTER操作。
第18位 是否审计SYNONYM对象的CREATE、DROP、ALTER操作。
0表示不审计SYNONYM对象的CREATE、DROP、ALTER操作；1表示审计SYNONYM对象的CREATE、DROP、ALTER操作。
第19位 是否审计SEQUENCE对象的CREATE、DROP、ALTER操作。
0表示不审计SEQUENCE对象的CREATE、DROP、ALTER操作；1表示审计SEQUENCE对象的CREATE、DROP、ALTER操作。
第20位 是否审计CMK、CEK对象的CREATE、DROP操作。
0表示不审计CMK、CEK对象的CREATE、DROP操作；1表示审计CMK、CEK对象的CREATE、DROP操作。
第21位 是否审计PACKAGE对象的CREATE、DROP、ALTER操作。
0表示不审计PACKAGE对象的CREATE、DROP、ALTER操作；1表示审计PACKAGE对象的CREATE、DROP、ALTER操作。
第22位 是否审计MODEL对象的CREATE、DROP操作。
0表示不审计MODEL对象的CREATE、ALTER操作；1表示审计MODEL对象的CREATE、DROP操作。
第23位 是否审计PUBLICATION和SUBSCRIPTION对象的CREATE、DROP、ALTER操作。
0表示不审计PUBLICATION和SUBSCRIPTION对象的CREATE、DROP、ALTER操作；
1表示审计PUBLICATION和SUBSCRIPTION对象的CREATE、DROP、ALTER操作。
第24位 是否审计对gs_global_config全局对象的ALTER、DROP操作。
0表示不审计对系统表gs_global_config全局对象的ALTER、DROP操作；1表示审计对系统表gs_global_config全局对象的ALTER、DROP操作。
第25位 是否审计FOREIGN DATA WRAPPER对象的CREATE、DROP、ALTER操作。
0表示不审计FOREIGN DATA WRAPPER对象的CREATE、DROP、ALTER操作；1表示审计FOREIGN DATA WRAPPER对象的CREATE、DROP、ALTER操作。
第26位 是否审计SQL PATCH对象的CREATE、ENABLE、DISABLE、DROP操作。
0表示不审计SQL PATCH对象的CREATE、ENABLE、DISABLE、DROP操作；1表示审计SQL PATCH对象的CREATE、ENABLE、DISABLE、DROP操作。
第27位 是否审计EVENT对象的CREATE、ALTER、DROP操作。
0表示不审计EVENT对象的CREATE、ENABLE、DISABLE、DROP操作。1表示审计EVENT对象的CREATE、ENABLE、DISABLE、DROP操作。

## audit\_dml\_state

**参数说明**： 这个参数决定是否对具体表的INSERT、UPDATE、DELETE操作进行审计。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0、1。

- 0表示关闭具体表的DML操作（SELECT除外）审计功能。
- 1表示开启具体表的DML操作（SELECT除外）审计功能。

**默认值**： 0

## audit\_dml\_state\_select

**参数说明**： 这个参数决定是否对SELECT操作进行审计。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0、1。

- 0表示关闭SELECT操作审计功能。
- 1表示开启SELECT审计操作功能。

**默认值**： 0

## audit\_function\_exec

参数说明：这个参数决定在执行存储过程、匿名块或自定义函数（不包括系统自带函数）时是否记录审计信息。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0、1。

- 0表示关闭过程或函数执行的审计功能。
- 1表示开启过程或函数执行的审计功能。

**默认值**： 0

## audit\_system\_function\_exec

**参数说明**： 这个参数决定在执行白名单内的系统函数时是否记录审计日志。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0、1。

- 0表示关闭对系统函数执行的审计功能。
- 1表示开启对系统函数执行的审计功能。

**默认值**： 0

支持记录审计的系统函数白名单如下表所示：

set_working_grand_version_num_manually set_config pg_cancel_backend pg_cancel_session pg_reload_conf pg_rotate_logfile pg_terminate_session pg_terminate_backend pg_create_restore_point pg_start_backup pg_stop_backup pg_switch_xlog pg_cbm_rotate_file pg_cbm_get_merged_file pg_cbm_recycle_file pg_enable_delay_ddl_recycle pg_disable_delay_ddl_recycle gs_roach_stop_backup gs_roach_enable_delay_ddl_recycle gs_roach_disable_delay_ddl_recycle gs_roach_switch_xlog pg_last_xlog_receive_location pg_xlog_replay_pause pg_xlog_replay_resume gs_pitr_clean_history_global_barriers gs_pitr_archive_slot_force_advance pg_create_physical_replication_slot_extern gs_set_obs_delete_location gs_hadr_do_switchover(已废除) gs_set_obs_delete_location_with_slotname gs_streaming_dr_in_switchover gs_upload_obs_file(已废除) gs_download_obs_file(已废除) gs_set_obs_file_context(已废除) gs_get_hadr_key_cn(已废除) pg_advisory_lock pg_advisory_lock_shared pg_advisory_unlock pg_advisory_unlock_shared pg_advisory_unlock_all pg_advisory_xact_lock pg_advisory_xact_lock_shared pg_try_advisory_lock pg_try_advisory_lock_shared pg_try_advisory_xact_lock pg_try_advisory_xact_lock_shared pg_create_logical_replication_slot pg_drop_replication_slot pg_logical_slot_peek_changes pg_logical_slot_get_changes pg_logical_slot_get_binary_changes pg_replication_slot_advance pg_replication_origin_create pg_replication_origin_drop pg_replication_origin_session_setup pg_replication_origin_session_reset pg_replication_origin_session_progress pg_replication_origin_xact_setup pg_replication_origin_xact_reset pg_replication_origin_advance local_space_shrink gs_space_shrink pg_free_remain_segment gs_fault_inject gs_repair_file local_clear_bad_block_info gs_repair_page &nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;

## audit\_copy\_exec

**参数说明**： 这个参数决定是否对COPY操作进行审计。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0、1。

- 0表示关闭COPY审计功能。
- 1表示开启COPY审计功能。

**默认值**： 1

## audit\_set\_parameter

**参数说明**： 这个参数决定是否对SET操作进行审计。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0、1。

- 0表示关闭SET审计功能。
- 1表示开启SET审计功能。

**默认值**： 0

## audit\_xid\_info

**参数说明**： 这个参数决定是否在审计日志字段detail\_info中记录SQL语句的事务ID。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，0、1。

- 0表示关闭审计日志记录事务ID功能。
- 1表示开启审计日志记录事务ID功能。

**默认值**： 0

## audit\_async\_notify

**参数说明**：这个参数决定是否开启对NOTIFY/LISTEN/UNLISTEN操作的审计功能。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：整型，0、1。

- 0表示关闭对NOTIFY/LISTEN/UNLISTEN操作的审计功能。
- 1表示开启对NOTIFY/LISTEN/UNLISTEN操作的审计功能。

**默认值**： 0

>[!TIP]须知
>如果开启此开关，审计日志中detail\_info信息则以xid开始，例如：
>
>```
>detail_info: xid=14619 , create table t1(id int);
>```
>
>对于不存在事务ID的审计行为，记录xid=NA。

## enableSeparationOfDuty

**参数说明**： 是否开启三权分立选项。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示开启三权分立。
- off表示不开启三权分立。

**默认值**： off

## enable\_nonsysadmin\_execute\_direct

**参数说明**： 是否允许非系统管理员和非监控管理员执行EXECUTE DIRECT ON语句。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示允许任意用户执行EXECUTE DIRECT ON语句。
- off表示只允许系统管理员和监控管理员执行EXECUTE DIRECT ON语句。

**默认值**： off

## enable\_access\_server\_directory

**参数说明**： 是否开启非初始用户创建、修改和删除DIRECTORY的权限。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示开启非初始用户创建、修改和删除DIRECTORY的权限。
- off表示不开启非初始用户创建、修改和删除DIRECTORY的权限。

**默认值**： off

>[!TIP]须知
>
>- 出于安全考虑，默认情况下，只有初始用户才能够创建、修改和删除DIRECTORY对象。
>- 如果开启了enable\_access\_server\_directory，具有SYSADMIN权限的用户和继承了内置角色gs\_role\_directory\_create权限的用户可以创建directory对象；具有SYSADMIN权限的用户、directory对象的属主、被授予了该directory的DROP权限的用户或者继承了内置角色gs\_role\_directory\_drop权限的用户可以删除directory对象；具有SYSADMIN权限的用户和directory对象的属主可以修改directory对象的所有者，且要求该用户是新属主的成员。
>- 当修改directory属主时，若新属主与原属主相同，视为未修改属主。即使用户没有修改DIERECTORY的权限，也不会报错。
