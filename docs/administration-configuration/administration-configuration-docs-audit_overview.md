# 审计概述

## 背景信息

数据库安全对数据库系统来说至关重要。openGauss将用户对数据库的所有操作写入审计日志。数据库安全管理员可以利用这些日志信息，重现导致数据库现状的一系列事件，找出非法操作的用户、时间和内容等。

关于审计功能，用户需要了解以下几点内容：

- 审计总开关[audit\_enabled](../database_reference/audit_switch.md#zh-cn_topic_0237124745_zh-cn_topic_0059777744_sb3d1b703f24c49f096b36087a60fdfcd)支持动态加载。在数据库运行期间修改该配置项的值会立即生效，无需重启数据库。默认值为on，表示开启审计功能。
- 除了审计总开关，各个审计项也有对应的开关。只有开关开启，对应的审计功能才能生效。
- 各审计项的开关支持动态加载。在数据库运行期间修改audit_switch的值，不需要重启数据库便可生效。

目前，openGauss支持以下审计项如[表1](#zh-cn_topic_0283137487_zh-cn_topic_0237121112_zh-cn_topic_0059778562_t126500e4696c4a9fadb15d0437679eb0)所示。

**表 1**  配置审计项

配置项 用户登录、注销审计 参数：audit_login_logout 默认值为7，表示开启用户登录、退出的审计功能。设置为0表示关闭用户登录、退出的审计功能。不推荐设置除0和7之外的值。
数据库启动、停止、恢复和切换审计 参数：audit_database_process 默认值为1，表示开启数据库启动、停止、恢复和切换的审计功能。
用户锁定和解锁审计 参数：audit_user_locked 默认值为1，表示开启审计用户锁定和解锁功能。
用户访问越权审计 参数：audit_user_violation 默认值为0，表示关闭用户越权操作审计功能。
授权和回收权限审计 参数：audit_grant_revoke 默认值为1，表示开启审计用户权限授予和回收功能。
对用户操作进行全量审计 参数：full_audit_users 默认值为空字符串，表示采用默认配置，未配置全量审计用户。
不需要审计的客户端名称及IP地址 参数：no_audit_client 默认值为空字符串，表示采用默认配置，未将客户端及IP加入审计黑名单。
数据库对象的CREATE，ALTER，DROP操作审计 参数：audit_system_object 默认值为67121159，表示只对DATABASE、SCHEMA、USER、DATA SOURCE、SQL PATCH这五类数据库对象的CREATE、ALTER、DROP操作进行审计。
具体表的INSERT、UPDATE和DELETE操作审计 参数：audit_dml_state 默认值为0，表示关闭具体表的DML操作（SELECT除外）审计功能。
SELECT操作审计 参数：audit_dml_state_select 默认值为0，表示关闭SELECT操作审计功能。
COPY审计 参数：audit_copy_exec 默认值为1，表示开启copy操作审计功能。
存储过程和自定义函数的执行审计 参数：audit_function_exec 默认值为0，表示不记录存储过程和自定义函数的执行审计日志。
执行白名单内的系统函数审计 参数：audit_system_function_exec 默认值为0，表示不记录执行系统函数的审计日志。
SET审计 参数：audit_set_parameter 默认值为0，表示关闭SET审计功能。
事务ID记录 参数：audit_xid_info 默认值为0，表示关闭审计日志记录事务ID功能。

安全相关参数及说明请参见[表2](#zh-cn_topic_0283137487_zh-cn_topic_0237121112_zh-cn_topic_0059778562_t62477343f6ff4b3592c6ae8d040bc607)。

**表 2**  安全相关参数及说明

参数名 ssl 指定是否启用SSL连接。
require_ssl 指定服务器端是否强制要求SSL连接。
ssl_ciphers 指定SSL支持的加密算法列表。
ssl_cert_file 指定包含SSL服务器证书的文件的名称。
ssl_key_file 指定包含SSL私钥的文件名称。
ssl_ca_file 指定包含CA信息的文件的名称。
ssl_crl_file 指定包含CRL信息的文件的名称。
password_policy 指定是否进行密码复杂度检查。
password_reuse_time 指定是否对新密码进行可重用天数检查。
password_reuse_max 指定是否对新密码进行可重用次数检查。
password_lock_time 指定帐户被锁定后自动解锁的时间。
failed_login_attempts 如果输入密码错误的次数达到此参数值时，当前帐户被锁定。
password_encryption_type 指定采用何种加密方式对用户密码进行加密存储。
password_min_uppercase 密码中至少需要包含大写字母的个数。
password_min_lowercase 密码中至少需要包含小写字母的个数。
password_min_digital 密码中至少需要包含数字的个数。
password_min_special 密码中至少需要包含特殊字符的个数。
password_min_length 密码的最小长度。
password_max_length 密码的最大长度。
password_effect_time 密码的有效期限。
password_notify_time 密码到期提醒的天数。
audit_enabled 控制审计进程的开启和关闭。
audit_directory 审计文件的存储目录。
audit_data_format 审计日志文件的格式，当前仅支持二进制格式（binary）。
audit_rotation_interval 指定创建一个新审计日志文件的时间间隔。当现在的时间减去上次创建一个审计日志的时间超过了此参数值时，服务器将生成一个新的审计日志文件。
audit_rotation_size 指定审计日志文件的最大容量。当审计日志消息的总量超过此参数值时，服务器将生成一个新的审计日志文件。
audit_resource_policy 控制审计日志的保存策略，以空间还是时间限制为优先策略，on表示以空间为优先策略。
audit_file_remain_time 表示需记录审计日志的最短时间要求，该参数在audit_resource_policy为off时生效。
audit_space_limit 审计文件占用磁盘空间的最大值。
audit_file_remain_threshold 审计目录下审计文件的最大数量。
audit_login_logout 指定是否审计数据库用户的登录（包括登录成功和登录失败）、注销。
audit_database_process 指定是否审计数据库启动、停止、切换和恢复的操作。
audit_user_locked 指定是否审计数据库用户的锁定和解锁。
audit_user_violation 指定是否审计数据库用户的越权访问操作。
audit_grant_revoke 指定是否审计数据库用户权限授予和回收的操作。
full_audit_users 指定全量审计用户列表，对列表中的用户执行的所有可被审计的操作记录审计日志。
no_audit_client 指定不需要审计的客户端名称及IP地址列表。
audit_system_object 指定是否审计数据库对象的CREATE、DROP、ALTER操作。
audit_dml_state 指定是否审计具体表的INSERT、UPDATE、DELETE操作。
audit_dml_state_select 指定是否审计SELECT操作。
audit_copy_exec 指定是否审计COPY操作。
audit_function_exec 指定在执行存储过程、匿名块或自定义函数（不包括系统自带函数）时是否记录审计信息。
audit_system_function_exec 指定是否开启对执行白名单内的系统函数记录审计日志。
audit_set_parameter 指定是否审计SET操作。
enableSeparationOfDuty 指定是否开启三权分立。
session_timeout 建立连接会话后，如果超过此参数的设置时间，则会自动断开连接。
auth_iteration_count 认证加密信息生成过程中使用的迭代次数。

## 操作步骤

1. 以操作系统用户omm登录数据库主节点。

2. 连接数据库。

数据库安装完成后，默认生成名称为postgres的数据库。第一次连接数据库时可以连接到此数据库。

执行如下命令连接数据库。

   ```
   gsql -d postgres -p 8000
   ```

其中postgres为需要连接的数据库名称，8000为数据库主节点的端口号。请根据实际情况替换。另外，也可以使用如下任一命令连接数据库。

   ```
   gsql postgres://omm:******@127.0.0.1:8000/postgres -r
   gsql -d "host=127.0.0.1 port=8000 dbname=postgres user=omm password=******"
   ```

连接成功后，系统显示类似如下信息：

   ```
   gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
   Non-SSL connection (SSL connection is recommended when requiring high-security)
   Type "help" for help.

   openGauss=#
   ```

omm用户是管理员用户，因此系统显示“DBNAME=\#”。若使用普通用户身份登录和连接数据库，系统显示“DBNAME=\>”。

“Non-SSL connection”表示未使用SSL方式连接数据库。如果需要高安全性时，请使用SSL连接。

>[!NOTE]说明
>
>gsql是本产品提供的命令行方式的数据库连接工具。更多的数据库连接办法可参考[使用gsql访问openGauss](../getting_started/gsql_connection_and_usage.md)。

3. 检查审计总开关状态。

  1. 用show命令显示审计总开关audit\_enabled的值。

       ```
       openGauss=# SHOW audit_enabled;
       ```

如果显示为off，执行‘\q’命令退出数据库，继续执行后续步骤。如果显示为on，则无需执行后续步骤。

  2. 执行如下命令开启审计功能，参数设置立即生效。

       ```
       gs_guc set -N all -I all -c "audit_enabled=on"
       ```

4. 配置具体的审计项。

>[!NOTE]说明
>
>- 只有开启审计功能，用户的操作才会被记录到审计文件中。
>- 各审计项的默认参数都符合安全标准，用户可以根据需要开启其他审计功能，但会对性能有一定影响。

以开启对数据库所有对象的增删改操作的audit_switch为例，其他配置项的修改方法与此相同，修改配置项的方法如下所示：

   ```
   gs_guc reload -N all -I all -c "audit_system_object=12295"
   ```

其中audit\_system\_object代表审计项开关，12295为该audit_switch的值。
