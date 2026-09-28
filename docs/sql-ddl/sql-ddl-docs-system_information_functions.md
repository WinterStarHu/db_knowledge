# 系统信息函数

## 会话信息函数

- current\_catalog

描述：当前数据库的名称（在标准SQL中称“catalog”）。

返回值类型：name

示例：

    ```
    openGauss=# SELECT current_catalog;
     current_database
    ------------------
     openGauss
    (1 row)
    ```

- current\_database\(\)

描述：当前数据库的名称。

返回值类型：name

示例：

    ```
    openGauss=# SELECT current_database();
     current_database
    ------------------
     openGauss
    (1 row)
    ```

- current\_query\(\)

描述：由客户端提交的当前执行语句（可能包含多个声明）。

返回值类型：text

示例：

    ```
    openGauss=# SELECT current_query();
          current_query
    -------------------------
     SELECT current_query();
    (1 row)
    ```

- current\_schema\[\(\)\]

描述：当前模式的名称。

返回值类型：name

示例：

    ```
    openGauss=# SELECT current_schema();
     current_schema
    ----------------
     public
    (1 row)
    ```

备注：current\_schema返回在搜索路径中第一个顺位有效的模式名。（如果搜索路径为空则返回NULL，没有有效的模式名也返回NULL）。如果创建表或者其他命名对象时没有声明目标模式，则将使用这些对象的模式。

- schema

描述：当前模式的名称。

返回值类型：name

示例：

    ```
    openGauss=# SELECT schema();
     schema
    --------
     public
    (1 row)
    ```

备注：与current\_schema同义

- current\_schemas\(Boolean\)

描述：搜索路径中的模式名称。

返回值类型：name\[\]

示例：

    ```
    openGauss=# SELECT current_schemas(true);
       current_schemas
    ---------------------
     {pg_catalog,public}
    (1 row)
    ```

备注：

current\_schemas\(Boolean\)返回搜索路径中所有模式名称的数组。布尔选项决定像pg\_catalog这样隐含包含的系统模式是否包含在返回的搜索路径中。

>[!NOTE]说明
>搜索路径可以通过运行时设置更改。命令是：
>
>```
>SET search_path TO schema [, schema, ...]
>```

- current\_user

描述：当前执行环境下的用户名。

返回值类型：name

示例：

    ```
    openGauss=# SELECT current_user;
     current_user
    --------------
     omm
    (1 row)
    ```

备注：current\_user是用于权限检查的用户标识。通常，他表示会话用户，但是可以通过[SET ROLE](set_role.md)改变他。在函数执行的过程中随着属性SECURITY DEFINER的改变，其值也会改变。

- definer\_current\_user

描述：当前执行环境下的用户名。

返回值类型：name

示例：

    ```
    openGauss=# SELECT definer_current_user();
     definer_current_user
    ----------------------
     omm
    (1 row)
    ```

- pg\_current\_sessionid\(\)

描述：当前执行环境下的会话ID。

返回值类型：text

示例：

    ```
    openGauss=# SELECT pg_current_sessionid();
        pg_current_sessionid
    ----------------------------
     1579228402.140190434944768
    (1 row)
    ```

备注：pg\_current\_sessionid\(\)是用于获取当前执行环境下的会话ID。其组成结构为：时间戳.会话ID，当线程池模式开启（enable\_thread\_pool=on）时，会话ID为SessionID；而线程池模式关闭时，会话ID为ThreadID。

- pg\_current\_sessid

描述：当前执行环境下的会话ID。

返回值类型：text

示例：

    ```
    openGauss=# select pg_current_sessid();
    pg_current_sessid
    -------------------
    140308875015936
    (1 row)
    ```

备注：在线程池模式下获得当前会话的会话ID，非线程池模式下获得当前会话对应的后台线程ID。

- pg\_current\_userid

描述：当前用户ID。

返回值类型：text

    ```
    openGauss=# SELECT pg_current_userid();
    pg_current_userid
    -------------------
    10
    (1 row)
    ```

- working\_version\_num\(\)

描述：版本序号信息。返回一个系统兼容性有关的版本序号。

返回值类型：int

示例：

    ```
    openGauss=# SELECT working_version_num();
     working_version_num
    ---------------------
                   92231
    (1 row)

    ```

- tablespace\_oid\_name\(\)

描述: 根据表空间oid，查找表空间名称。

返回值类型：text

示例：

    ```
    openGauss=# select tablespace_oid_name(1663);
     tablespace_oid_name
    ---------------------
     pg_default
    (1 row)
    ```

- inet\_client\_addr\(\)

描述：连接的远端地址。inet\_client\_addr返回当前客户端的IP地址。

>[!NOTE]说明
>此函数只有在远程连接模式下有效。

返回值类型：inet

示例：

    ```
    openGauss=# SELECT inet_client_addr();
     inet_client_addr
    ------------------
     10.10.0.50
    (1 row)
    ```

- inet\_client\_port\(\)

描述：连接的远端端口。inet\_client\_port返回当前客户端的端口号。

>[!NOTE]说明
>此函数只有在远程连接模式下有效。

返回值类型：int

示例：

    ```
    openGauss=# SELECT inet_client_port();
     inet_client_port
    ------------------
                33143
    (1 row)
    ```

- inet\_server\_addr\(\)

描述：连接的本地地址。inet\_server\_addr返回服务器接收当前连接用的IP地址。

>[!NOTE]说明
>此函数只有在远程连接模式下有效。

返回值类型：inet

示例：

    ```
    openGauss=# SELECT inet_server_addr();
     inet_server_addr
    ------------------
     10.10.0.13
    (1 row)
    ```

- inet\_server\_port\(\)

描述：连接的本地端口。inet\_server\_port返回接收当前连接的端口号。如果是通过Unix-domain socket连接的，则所有这些函数都返回NULL。

>[!NOTE]说明
>此函数只有在远程连接模式下有效。

返回值类型：int

示例：

    ```
    openGauss=# SELECT inet_server_port();
     inet_server_port
    ------------------
                 8000
    (1 row)
    ```

- pg\_backend\_pid\(\)

描述：当前会话连接的服务线程的线程ID。

返回值类型：bigint

示例：

    ```
    openGauss=# SELECT pg_backend_pid();
     pg_backend_pid
    -----------------
     140229352617744
    (1 row)
    ```

- pg\_conf\_load\_time\(\)

描述：配置加载时间。pg\_conf\_load\_time返回最后加载服务器配置文件的时间戳。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# SELECT pg_conf_load_time();
          pg_conf_load_time
    ------------------------------
     2017-09-01 16:05:23.89868+08
    (1 row)
    ```

- pg\_my\_temp\_schema\(\)

描述：会话的临时模式的OID，不存在则为0。

返回值类型：oid

示例：

    ```
    openGauss=# SELECT pg_my_temp_schema();
     pg_my_temp_schema
    -------------------
                     0
    (1 row)
    ```

备注：pg\_my\_temp\_schema返回当前会话中临时模式的OID，如果不存在（没有创建临时表）的话则返回0。如果给定的OID是其它会话中临时模式的OID，pg\_is\_other\_temp\_schema则返回true。

- pg\_is\_other\_temp\_schema\(oid\)

描述：是否为另一个会话的临时模式。

返回值类型：Boolean

示例：

    ```
    openGauss=# SELECT pg_is_other_temp_schema(25356);
     pg_is_other_temp_schema
    -------------------------
     f
    (1 row)
    ```

- pg\_listening\_channels\(\)

描述：会话正在侦听的信道名称。

返回值类型：setof text

示例：

    ```
    openGauss=# SELECT pg_listening_channels();
     pg_listening_channels
    -----------------------
    (0 rows)
    ```

备注：pg\_listening\_channels返回当前会话正在侦听的一组信道名称。

- pg\_postmaster\_start\_time\(\)

描述：服务器启动时间。pg\_postmaster\_start\_time返回服务器启动时的timestamp with time zone。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# SELECT pg_postmaster_start_time();
       pg_postmaster_start_time
    ------------------------------
     2017-08-30 16:02:54.99854+08
    (1 row)
    ```

- pg\_get\_ruledef\(rule\_oid\)

描述：获取规则的CREATE RULE命令。

返回值类型：text

示例：

    ```
    openGauss=# select * from pg_get_ruledef(24828);
                                    pg_get_ruledef
    -------------------------------------------------------------------
     CREATE RULE t1_ins AS ON INSERT TO t1 DO INSTEAD INSERT INTO t2 (id) VALUES (new.id);
    (1 row)
    ```

- sessionid2pid\(\)

描述: 从sessionid中得到pid信息（例如，gs\_session\_stat中sessid列）。

返回值类型: int8

示例：

    ```
    openGauss=# select sessionid2pid(sessid::cstring) from gs_session_stat limit 2;
      sessionid2pid
    -----------------
     139973107902208
     139973107902208
    (2 rows)
    ```

- pg\_trigger\_depth\(\)

描述：触发器的嵌套层次。

返回值类型：int

示例：

    ```
    openGauss=# SELECT pg_trigger_depth();
     pg_trigger_depth
    ------------------
                    0
    (1 row)
    ```

- session\_user\[\(\)\]

描述：会话用户名。

返回值类型：name

示例：

    ```
    openGauss=# SELECT session_user();
     session_user
    --------------
     omm
    (1 row)
    ```

备注：session\_user通常是连接当前数据库的初始用户，不过系统管理员可以用[SET SESSION AUTHORIZATION](set_session_authorization.md)修改这个设置。

- user\[\(\)\]

描述：等价于current\_user\[\(\)\]。

返回值类型：name

示例：

    ```
    openGauss=# SELECT user();
     current_user
    --------------
     omm
    (1 row)
    ```

- system\_user\(\)

描述：等价于current\_user\[\(\)\]。

返回值类型：name

示例：

    ```
    openGauss=# SELECT system_user();
     system_user
    -------------
     omm
    (1 row)
    ```

- connection\_id\(\)

描述：返回所连接线程的ID。

返回结果和SHOW PROCESSLIST输出的ID列一样。

返回值类型：int

示例：

    ```
    openGauss=# SELECT CONNECTION_ID();
      connection_id
    -----------------
    140065528485632
    (1 row)
    ```

- getpgusername\(\)

描述：获取数据库用户名。

返回值类型：name

示例：

    ```
    openGauss=# select getpgusername();
     getpgusername
    ---------------
     GaussDB_userna
    (1 row)
    ```

- getdatabaseencoding\(\)

描述：获取数据库编码方式。

返回值类型：name

示例：

    ```
    openGauss=# select getdatabaseencoding();
     getdatabaseencoding
    ---------------------
     SQL_ASCII
    (1 row)
    ```

- version\(\)

描述：版本信息。version返回一个描述服务器版本信息的字符串。

返回值类型：text

示例：

    ```
    openGauss=# select version();
    version
    -------------------------------------------------------------------------------------------------------------------------------------------------------------
    (openGauss x.x.x build fab4f5ea) compiled at 2021-10-24 11:58:22 commit 3086 last mr 6592 release
    (1 row)
    ```

- opengauss\_version\(\)

描述：openGauss版本信息。

返回值类型：text

示例：

    ```
    openGauss=# select opengauss_version();
     opengauss_version
    -------------------
     2.0.0
    (1 row)
    ```

- gs\_deployment\(\)

描述：当前系统的部署形态信息。

返回值类型：text

示例：

    ```
    openGauss=# select gs_deployment();
         gs_deployment
    -----------------------
     OpenSourceCentralized
    (1 row)
    ```

- get\_hostname\(\)

描述：返回当前节点的hostname。

返回值类型：text

示例：

    ```
    openGauss=# SELECT get_hostname();
     get_hostname
    --------------
     linux-user
    (1 row)
    ```

- get\_nodename\(\)

描述：返回当前节点的名字。

返回值类型：text

示例：

    ```
    openGauss=# SELECT get_nodename();
     get_nodename
    --------------
     datanode1
    (1 row)
    ```

- get\_schema\_oid\(cstring\)

描述：返回查询schema的oid。

返回值类型：oid

示例：

    ```
    openGauss=# SELECT get_schema_oid('public');
     get_schema_oid
    ----------------
               2200
    (1 row)
    ```

- get_client_info()

描述：返回客户端信息。

返回值类型：record

## 访问权限查询函数

DDL类权限ALTER、DROP、COMMENT、INDEX、VACUUM属于所有者固有的权限，隐式拥有。

- has\_any\_column\_privilege\(user, table, privilege\)

描述：指定用户是否有访问表任何列的权限。

**表 1**  参数类型说明

参数名 合法入参类型 user name, oid table text, oid privilege text

返回类型：Boolean

- has\_any\_column\_privilege\(table, privilege\)

描述：当前用户是否有访问表任何列的权限，合法参数类型见[表1](#zh-cn_topic_0283136950_table933075917538)。

返回类型：Boolean

备注：has\_any\_column\_privilege检查用户是否以特定方式访问表的任何列。其参数可能与has\_table\_privilege类似，除了访问权限类型必须是SELECT、INSERT、UPDATE、COMMENT或REFERENCES的一些组合。

>[!NOTE]说明
>拥有表的表级别权限则隐含的拥有该表每列的列级权限，因此如果与has\_table\_privilege参数相同，has\_any\_column\_privilege总是返回true。但是如果授予至少一列的列级权限也返回成功。

- has\_column\_privilege\(user, table, column, privilege\)

描述：指定用户是否有访问列的权限。

**表 2**  参数类型说明

参数名 合法入参类型 user name, oid table text, oid column text, smallint privilege text

返回类型：Boolean

- has\_column\_privilege\(table, column, privilege\)

描述：当前用户是否有访问列的权限，合法参数类型见[表2](#zh-cn_topic_0283136950_table9581157145120)。

返回类型：Boolean

备注：has\_column\_privilege检查用户是否以特定方式访问一列。其参数类似于has\_table\_privilege，可以通过列名或属性号添加列。想要的访问权限类型必须是SELECT、INSERT、UPDATE、COMMENT或REFERENCES的一些组合。

>[!NOTE]说明
>拥有表的表级别权限则隐含的拥有该表每列的列级权限。

- has\_cek\_privilege\(user, cek, privilege\)

描述：指定用户是否有访问列加密密钥CEK的权限。参数说明如下。

**表 3**  参数类型说明

参数名 合法入参类型 取值范围 user name，oid 用户名字或id。
cek text，oid 列加密密钥 列加密密钥名称或id。
privilege text USAGE：允许使用指定列加密密钥。DROP：允许删除指定列加密密钥。

返回类型：Boolean

- has\_cmk\_privilege\(user, cmk, privilege\)

描述：指定用户是否有访问客户端加密主密钥CMK的权限。参数说明如下。

**表 4**  参数类型说明

参数名 合法入参类型 取值范围 user name，oid 用户名字或id。
cmk text，oid 客户端加密主密钥 客户端加密主密钥名称或id。
privilege text USAGE：允许使用指定客户端加密主密钥。DROP：允许删除指定客户端加密主密钥。

返回类型：Boolean

- has\_database\_privilege\(user, database, privilege\)

描述：指定用户是否有访问数据库的权限。参数说明如下。

**表 5**  参数类型说明

参数名 合法入参类型 user name, oid database text, oid privilege text

返回类型：Boolean

- has\_database\_privilege\(database, privilege\)

描述：当前用户是否有访问数据库的权限，合法参数类型请参见[表5](#zh-cn_topic_0283136950_table111152337017)。

返回类型：Boolean

备注：has\_database\_privilege检查用户是否能以在特定方式访问数据库。其参数类似has\_table\_privilege。访问权限类型必须是CREATE、CONNECT、TEMPORARY、ALTER、DROP、COMMENT或TEMP（等价于TEMPORARY）的一些组合。

- has\_directory\_privilege\(user, directory, privilege\)

描述：指定用户是否有访问directory的权限。

**表 6**  参数类型说明

参数名 合法入参类型 user name, oid directory text, oid privilege text

返回类型：Boolean

- has\_directory\_privilege\(directory, privilege\)

描述：当前用户是否有访问directory的权限，合法参数类型请参见[表6](#zh-cn_topic_0283136950_table111483362025)。

返回类型：Boolean

- has\_foreign\_data\_wrapper\_privilege\(user, fdw, privilege\)

描述：指定用户是否有访问外部数据封装器的权限。

**表 7**  参数类型说明

参数名 合法入参类型 user name, oid fdw text, oid privilege text

返回类型：Boolean

- has\_foreign\_data\_wrapper\_privilege\(fdw, privilege\)

描述：当前用户是否有访问外部数据封装器的权限。合法参数类型请参见[表7](#zh-cn_topic_0283136950_table3176631131)。

返回类型：Boolean

备注：has\_foreign\_data\_wrapper\_privilege检查用户是否能以特定方式访问外部数据封装器。其参数类似has\_table\_privilege。访问权限类型必须是USAGE。

- has\_function\_privilege\(user, function, privilege\)

描述：指定用户是否有访问函数的权限。

**表 8**  参数类型说明

参数名 合法入参类型 user name, oid function text, oid privilege text

返回类型：Boolean

- has\_function\_privilege\(function, privilege\)

描述：当前用户是否有访问函数的权限。合法参数类型请参见[表8](#zh-cn_topic_0283136950_table169651367619)。

返回类型：Boolean

备注：has\_function\_privilege检查一个用户是否能以指定方式访问一个函数。其参数类似has\_table\_privilege。使用文本字符而不是OID声明一个函数时，允许输入的类型和regprocedure数据类型一样（请参考[对象标识符类型](oid_types.md)）。访问权限类型必须是EXECUTE、ALTER、DROP或COMMENT。

- has\_language\_privilege\(user, language, privilege\)

描述：指定用户是否有访问语言的权限。

**表 9**  参数类型说明

参数名 合法入参类型 user name, oid language text, oid privilege text

返回类型：Boolean

- has\_language\_privilege\(language, privilege\)

描述：当前用户是否有访问语言的权限。合法参数类型请参见[表9](#zh-cn_topic_0283136950_table7622265910)。

返回类型：Boolean

备注：has\_language\_privilege检查用户是否能以特定方式访问一个过程语言。其参数类似has\_table\_privilege。访问权限类型必须是USAGE。

- has\_nodegroup\_privilege\(user, nodegroup, privilege\)

描述：检查用户是否有数据库节点访问权限。

返回类型：Boolean

**表 10**  参数类型说明

参数名 合法入参类型 user name, oid nodegroup text, oid privilege text

- has\_nodegroup\_privilege\(nodegroup, privilege\)

描述：检查用户是否有数据库节点访问权限。参数与has\_table\_privilege类似。访问权限类型必须是USAGE、CREATE、COMPUTE、ALTER或CROP。

返回类型：Boolean

- has\_schema\_privilege\(user, schema, privilege\)

描述：指定用户是否有访问模式的权限。

返回类型：Boolean

- has\_schema\_privilege\(schema, privilege\)

描述：当前用户是否有访问模式的权限。

返回类型：Boolean

备注：has\_schema\_privilege检查用户是否能以特定方式访问一个模式。其参数类似has\_table\_privilege。访问权限类型必须是CREATE、USAGE、ALTER、DROP或COMMENT的一些组合。

- has\_server\_privilege\(user, server, privilege\)

描述：指定用户是否有访问外部服务的权限。

返回类型：Boolean

- has\_server\_privilege\(server, privilege\)

描述：当前用户是否有访问外部服务的权限。

返回类型：Boolean

备注：has\_server\_privilege检查用户是否能以指定方式访问一个外部服务器。其参数类似has\_table\_privilege。访问权限类型必须是USAGE、ALTER、DROP或COMMENT之一的值。

- has\_table\_privilege\(user, table, privilege\)

描述：指定用户是否有访问表的权限。

返回类型：Boolean

- has\_table\_privilege\(table, privilege\)

描述：当前用户是否有访问表的权限。

返回类型：Boolean

备注：has\_table\_privilege检查用户是否以特定方式访问表。用户可以通过名称或OID（pg\_authid.oid）来指定，public表明PUBLIC伪角色，或如果缺省该参数，则使用current\_user。该表可以通过名称或者OID声明。如果用名称声明，则在必要时可以用模式进行修饰。如果使用文本字符串来声明所希望的权限类型，这个文本字符串必须是SELECT、INSERT、UPDATE、DELETE、TRUNCATE、REFERENCES、TRIGGER、ALTER、DROP、COMMENT、INDEX或VACUUM之一的值。可以给权限类型添加WITH GRANT OPTION，用来测试权限是否拥有授权选项。也可以用逗号分隔列出的多个权限类型，如果拥有任何所列出的权限，则结果便为true。

示例：

    ```
    openGauss=# SELECT has_table_privilege('tpcds.web_site', 'select');
     has_table_privilege
    ---------------------
     t
    (1 row)

    openGauss=# SELECT has_table_privilege('omm', 'tpcds.web_site', 'select,INSERT WITH GRANT OPTION ');
     has_table_privilege
    ---------------------
     t
    (1 row)
    ```

- has\_tablespace\_privilege\(user, tablespace, privilege\)

描述：指定用户是否有访问表空间的权限。

返回类型：Boolean

- has\_tablespace\_privilege\(tablespace, privilege\)

描述：当前用户是否有访问表空间的权限。

返回类型：Boolean

备注：has\_tablespace\_privilege检查用户是否能以特定方式访问一个表空间。其参数类似has\_table\_privilege。访问权限类型必须是CREATE、ALTER、DROP或COMMENT之一的值。

- pg\_has\_role\(user, role, privilege\)

描述：指定用户是否有角色的权限。

返回类型：Boolean

- pg\_has\_role\(role, privilege\)

描述：当前用户是否有角色的权限。

返回类型：Boolean

备注：pg\_has\_role检查用户是否能以特定方式访问一个角色。其参数类似has\_table\_privilege，除了public不能用做用户名。访问权限类型必须是MEMBER或USAGE的一些组合。 MEMBER表示的是角色中的直接或间接成员关系（也就是SET ROLE的权限），而USAGE表示无需通过SET ROLE也直接拥有角色的使用权限。

- has\_any\_privilege\(user, privilege\)

描述：指定用户是否有某项ANY权限，若同时查询多个权限，只要具有其中一个则返回true。

返回类型：Boolean

**表 11**  参数类型说明

参数名 合法入参类型 取值范围 user name 已存在的用户名。
privilege text ANY权限 可选取值： CREATE ANY TABLE [WITH ADMIN OPTION] ALTER ANY TABLE [WITH ADMIN OPTION] DROP ANY TABLE [WITH ADMIN OPTION] SELECT ANY TABLE [WITH ADMIN OPTION] INSERT ANY TABLE [WITH ADMIN OPTION] UPDATE ANY TABLE [WITH ADMIN OPTION] DELETE ANY TABLE [WITH ADMIN OPTION] CREATE ANY SEQUENCE [WITH ADMIN OPTION] CREATE ANY INDEX [WITH ADMIN OPTION] CREATE ANY FUNCTION [WITH ADMIN OPTION] EXECUTE ANY FUNCTION [WITH ADMIN OPTION] CREATE ANY PACKAGE [WITH ADMIN OPTION] EXECUTE ANY PACKAGE [WITH ADMIN OPTION] CREATE ANY TYPE [WITH ADMIN OPTION]

## 模式可见性查询函数

每个函数执行检查数据库对象类型的可见性。对于函数和操作符，如果在前面的搜索路径中没有相同的对象名称和参数的数据类型，则此对象是可见的。对于操作符类，则要同时考虑名称和相关索引的访问方法。

所有这些函数都需要使用OID来标识要需要检查的对象。如果用户想通过名称测试对象，则使用OID别名类型（regclass、regtype、regprocedure、regoperator、regconfig或regdictionary）将会很方便。

比如，如果一个表所在的模式在搜索路径中，并且在前面的搜索路径中没有同名的表，则这个表是可见的。它等效于表可以不带明确模式修饰进行引用。比如，要列出所有可见表的名称：

```
openGauss=# SELECT relname FROM pg_class WHERE pg_table_is_visible(oid);
```

- pg\_collation\_is\_visible\(collation\_oid\)

描述：该排序是否在搜索路径中可见。

返回类型：Boolean

- pg\_conversion\_is\_visible\(conversion\_oid\)

描述：该转换是否在搜索路径中可见。

返回类型：Boolean

- pg\_function\_is\_visible\(function\_oid\)

描述：该函数是否在搜索路径中可见。

返回类型：Boolean

- pg\_opclass\_is\_visible\(opclass\_oid\)

描述：该操作符类是否在搜索路径中可见。

返回类型：Boolean

- pg\_operator\_is\_visible\(operator\_oid\)

描述：该操作符是否在搜索路径中可见。

返回类型：Boolean

- pg\_opfamily\_is\_visible\(opclass\_oid\)

描述：该操作符族是否在搜索路径中可见。

返回类型：Boolean

- pg\_table\_is\_visible\(table\_oid\)

描述：该表是否在搜索路径中可见。

返回类型：Boolean

- pg\_ts\_config\_is\_visible\(config\_oid\)

描述：该文本检索配置是否在搜索路径中可见。

返回类型：Boolean

- pg\_ts\_dict\_is\_visible\(dict\_oid\)

描述：该文本检索词典是否在搜索路径中可见。

返回类型：Boolean

- pg\_ts\_parser\_is\_visible\(parser\_oid\)

描述：该文本搜索解析是否在搜索路径中可见。

返回类型：Boolean

- pg\_ts\_template\_is\_visible\(template\_oid\)

描述：该文本检索模板是否在搜索路径中可见。

返回类型：Boolean

- pg\_type\_is\_visible\(type\_oid\)

描述：该类型（或域）是否在搜索路径中可见。

返回类型：Boolean

## 系统表信息函数

- format\_type\(type\_oid, typemod\)

描述：获取数据类型的SQL名称。

返回类型：text

备注：format\_type通过某个数据类型的类型OID以及可能的类型修饰词，返回其SQL名称。如果不知道具体的修饰词，则在类型修饰词的位置传入NULL。类型修饰词一般只对有长度限制的数据类型有意义。format\_type所返回的SQL名称中包含数据类型的长度值，其大小是：实际存储长度len - sizeof\(int32\)，单位字节。原因是数据存储时需要32位的空间来存储用户对数据类型的自定义长度信息，即实际存储长度要比用户定义长度多4个字节。在下例中，format\_type返回的SQL名称为“character varying\(6\)”，6表示varchar类型的长度值是6字节，因此该类型的实际存储长度为10字节。

    ```
    openGauss=# SELECT format_type((SELECT oid FROM pg_type WHERE typname='varchar'), 10);
         format_type
    ----------------------
     character varying(6)
    (1 row)
    ```

- getdistributekey\(table\_name\)

描述：获取一个hash表的分布列。单机环境下不支持分布，该函数返回为空。

- pg\_check\_authid\(role\_oid\)

描述：检查是否存在给定oid的角色名。

返回类型：bool

示例：

    ```
    openGauss=# select pg_check_authid(1);
    pg_check_authid
    -----------------
    f
    (1 row)
    ```

- pg\_describe\_object\(catalog\_id, object\_id, object\_sub\_id\)

描述：获取数据库对象的描述。

返回类型：text

备注：pg\_describe\_object返回由目录OID，对象OID和一个（或许0个）子对象ID指定的数据库对象的描述。这有助于确认存储在pg\_depend系统表中对象的身份。

- pg\_get\_constraintdef\(constraint\_oid\)

描述：获取约束的定义。

返回类型：text

- pg\_get\_constraintdef\(constraint\_oid, pretty\_bool\)

描述：获取约束的定义。

返回类型：text

备注：pg\_get\_constraintdef和pg\_get\_indexdef分别从约束或索引上使用创建命令进行重构。

- pg\_get\_expr\(pg\_node\_tree, relation\_oid\)

描述：反编译表达式的内部形式，假设其中的任何Vars都引用第二个参数指定的关系。

返回类型：text

- pg\_get\_expr\(pg\_node\_tree, relation\_oid, pretty\_bool\)

描述：反编译表达式的内部形式，假设其中的任何Vars都引用第二个参数指定的关系。

返回类型：text

备注：pg\_get\_expr反编译一个独立表达式的内部形式，比如一个字段的缺省值。在检查系统表的内容的时候很有用。如果表达式可能包含关键字，则指定他们引用相关的OID作为第二个参数；如果没有关键字，零就足够了。

- pg\_get\_functiondef\(func\_oid\)

描述：获取函数的定义。

返回类型：text

示例：

    ```
    openGauss=# select * from pg_get_functiondef(598);
     headerlines |                     definition
    -------------+----------------------------------------------------
               4 | CREATE OR REPLACE FUNCTION pg_catalog.abbrev(inet)+
                 |  RETURNS text                                     +
                 |  LANGUAGE internal                                +
                 |  IMMUTABLE STRICT NOT FENCED NOT SHIPPABLE        +
                 | AS $function$inet_abbrev$function$                +
                 |
    (1 row)
    ```

备注：pg\_get\_functiondef为函数返回一个完整的CREATE OR REPLACE FUNCTION语句。

- pg\_get\_function\_arguments\(func\_oid\)

描述：获取函数定义的参数列表（带默认值）。

返回类型：text

备注：pg\_get\_function\_arguments返回一个函数的参数列表，需要在CREATE FUNCTION中使用这种格式。

- pg\_get\_function\_identity\_arguments\(func\_oid\)

描述：获取参数列表来确定一个函数（不带默认值）。

返回类型：text

备注：pg\_get\_function\_identity\_arguments返回需要的参数列表用来标识函数，这种形式需要在ALTER FUNCTION中使用，并且这种形式省略了默认值。

- pg\_get\_function\_result\(func\_oid\)

描述：获取函数的RETURNS子句。

返回类型：text

备注：pg\_get\_function\_result为函数返回适当的RETURNS子句。

- pg\_get\_indexdef\(index\_oid\)

描述：获取索引的CREATE INDEX命令。

返回类型：text

示例：

    ```
    openGauss=# select * from pg_get_indexdef(16416);
                                 pg_get_indexdef
    -------------------------------------------------------------------------
     CREATE INDEX test3_b_idx ON test3 USING btree (b) TABLESPACE pg_default
    (1 row)
    ```

- pg\_get\_indexdef\(index\_oid, dump\_schema\_only\)

描述：获取索引的CREATE INDEX命令，仅用于dump场景。对于包含local索引的间隔分区表，当dump\_schema\_only为true时，返回的创建索引语句中不包含自动创建的分区的local索引信息；当dump\_schema\_only为false时，返回的创建索引语句中包含自动创建的分区的local索引信息。对于非间隔分区表或者不包含local索引的间隔分区分区表，dump\_schema\_only参数取值不影响函数返回结果。

返回类型：text

示例：

    ```
    openGauss=# CREATE TABLE sales
    openGauss-# (prod_id NUMBER(6),
    openGauss(#  cust_id NUMBER,
    openGauss(#  time_id DATE,
    openGauss(#  channel_id CHAR(1),
    openGauss(#  promo_id NUMBER(6),
    openGauss(#  quantity_sold NUMBER(3),
    openGauss(#  amount_sold NUMBER(10,2)
    openGauss(# )
    PARTITION BY RANGE( time_id) INTERVAL('1 day')
    openGauss-# openGauss-# (
    openGauss(#  partition p1 VALUES LESS THAN ('2019-02-01 00:00:00'),
    openGauss(#  partition p2 VALUES LESS THAN ('2019-02-02 00:00:00')
    openGauss(# );
    CREATE TABLE
    openGauss=# create index index_sales on sales(prod_id) local (PARTITION idx_p1 ,PARTITION idx_p2);
    CREATE INDEX
    openGauss=# -- 插入数据没有匹配的分区，新创建一个分区，并将数据插入该分区
    openGauss=# INSERT INTO sales VALUES(1, 12, '2019-02-05 00:00:00', 'a', 1, 1, 1);
    INSERT 0 1
    openGauss=# select oid from pg_class where relname = 'index_sales';
      oid
    -------
     24632
    (1 row)
    openGauss=# select * from pg_get_indexdef(24632, true);
                                                         pg_get_indexdef
    --------------------------------------------------------------------------------------------------------------------------
     CREATE INDEX index_sales ON sales USING btree (prod_id) LOCAL(PARTITION idx_p1, PARTITION idx_p2)  TABLESPACE pg_default
    (1 row)
    openGauss=# select * from pg_get_indexdef(24632, false);
                                                                        pg_get_indexdef

    ------------------------------------------------------------------------------------------------------------------------------------
    --------------------
     CREATE INDEX index_sales ON sales USING btree (prod_id) LOCAL(PARTITION idx_p1, PARTITION idx_p2, PARTITION sys_p1_prod_id_idx)  TA
    BLESPACE pg_default
    (1 row
    ```

- pg\_get\_indexdef\(index\_oid, column\_no, pretty\_bool\)

描述：获取索引的CREATE INDEX命令，或者如果column\_no不为零，则只获取一个索引字段的定义。

示例：

    ```
    openGauss=# select * from pg_get_indexdef(16416, 0, false);
                                 pg_get_indexdef
    -------------------------------------------------------------------------
     CREATE INDEX test3_b_idx ON test3 USING btree (b) TABLESPACE pg_default
    (1 row)
    openGauss=# select * from pg_get_indexdef(16416, 1, false);
     pg_get_indexdef
    -----------------
     b
    (1 row)
    ```

返回类型：text

- pg\_get\_keywords\(\)

描述：获取SQL关键字和类别列表。

返回类型：setof record

备注：pg\_get\_keywords返回一组关于描述服务器识别SQL关键字的记录。word列包含关键字。catcode列包含一个分类代码：U表示通用的，C表示列名，T表示类型或函数名，或R表示保留。catdesc列包含了一个可能本地化描述分类的字符串。

- pg\_get\_userbyid\(role\_oid\)

描述：获取给定OID的角色名。

返回类型：name

备注：pg\_get\_userbyid通过角色的OID抽取对应的用户名。

- pg\_check\_authid\(role\_id\)

描述：通过role\_id检查用户是否存在。

返回类型：text

示例：

    ```
    openGauss=# select pg_check_authid(20);
    pg_check_authid
    -----------------
    f
    (1 row)
    ```

- pg\_get\_viewdef\(view\_name\)

描述：为视图获取底层的SELECT命令。

返回类型：text

- pg\_get\_viewdef\(view\_name, pretty\_bool\)

描述：为视图获取底层的SELECT命令，如果pretty\_bool为true，行字段可以包含80列。

返回类型：text

备注：pg\_get\_viewdef重构出定义视图的SELECT查询。这些函数大多数都有两种形式，其中带有pretty\_bool参数，且参数为true时，是"适合打印"的结果，这种格式更容易读。另一种是缺省的格式，更有可能被将来的不同版本用同样的方法解释。如果是用于转储，那么尽可能避免使用适合打印的格式。给pretty-print参数传递false生成的结果和没有这个参数的变种生成的结果是完全一样。

- pg\_get\_viewdef\(view\_oid\)

描述：为视图获取底层的SELECT命令。

返回类型：text

- pg\_get\_viewdef\(view\_oid, pretty\_bool\)

描述：为视图获取底层的SELECT命令，如果pretty\_bool为true，行字段可以包含80列。

返回类型：text

- pg\_get\_viewdef\(view\_oid, wrap\_column\_int\)

描述：为视图获取底层的SELECT命令；行字段被换到指定的列数，打印是隐含的。

返回类型：text

- pg\_get\_tabledef\(table\_oid\)

描述：根据table\_oid获取表定义

示例：

    ```
    openGauss=# select * from pg_get_tabledef(16384);
                        pg_get_tabledef
    -------------------------------------------------------
     SET search_path = public;                            +
     CREATE  TABLE t1 (                                   +
             c1 bigint DEFAULT nextval('serial'::regclass)+
     )                                                    +
     WITH (orientation=row, compression=no)               +
     TO GROUP group1;
    (1 row)
    ```

返回类型：text

- pg\_get\_tabledef\(table\_name\)

描述：根据table\_name获取表定义。

示例：

    ```
    openGauss=# select * from pg_get_tabledef('t1');
                        pg_get_tabledef
    -------------------------------------------------------
     SET search_path = public;                            +
     CREATE  TABLE t1 (                                   +
             c1 bigint DEFAULT nextval('serial'::regclass)+
     )                                                    +
     WITH (orientation=row, compression=no)               +
     TO GROUP group1;
    (1 row)
    ```

返回类型：text

备注：pg\_get\_tabledef重构出表定义的CREATE语句，包含了表定义本身、索引信息、comments信息。对于表对象依赖的group、schema、tablespace、server等信息，需要用户自己去创建，表定义里不会有这些对象的创建语句。

- pg\_options\_to\_table\(reloptions\)

描述：获取存储选项名称/值对的集合。

返回类型：setof record

备注：pg\_options\_to\_table当通过pg\_class.reloptions或pg\_attribute.attoptions时返回存储选项名称/值对（option\_name/option\_value）的集合。

- pg\_tablespace\_databases\(tablespace\_oid\)

描述：获取在指定的表空间中有对象的数据库OID集合。

返回类型：setof oid

备注：pg\_tablespace\_databases允许检查表空间的状况，返回在该表空间中保存了对象的数据库OID集合。如果这个函数返回数据行，则该表空间就是非空的，因此不能删除。要显示该表空间中的特定对象，用户需要连接pg\_tablespace\_databases标识的数据库与查询pg\_class系统表。

- pg\_tablespace\_location\(tablespace\_oid\)

描述：获取表空间所在的文件系统的路径。

返回类型：text

- pg\_typeof\(any\)

描述：获取任何值的数据类型。

返回类型：regtype

备注：pg\_typeof返回传递给他的值的数据类型OID。这可能有助于故障排除或动态构造SQL查询。声明此函数返回regtype，这是一个OID别名类型（请参考[对象标识符类型](oid_types.md)）；这意味着它是一个为了比较而显示类型名称的OID。

示例：

    ```
    openGauss=# SELECT pg_typeof(33);
     pg_typeof
    -----------
     integer
    (1 row)

    openGauss=# SELECT typlen FROM pg_type WHERE oid = pg_typeof(33);
     typlen
    --------
          4
    (1 row)
    ```

- collation for \(any\)

描述：获取参数的排序。

返回类型：text

备注：表达式collation for返回传递给他的值的排序。

示例：

    ```
    openGauss=# SELECT collation for (Description) FROM pg_Description LIMIT 1;
     pg_collation_for
    ------------------
     "default"
    (1 row)
    ```

值可能是引号括起来的并且模式限制的。如果没有为参数表达式排序，则返回一个null值。如果参数不是排序的类型，则抛出一个错误。

- pg\_Extension\_update\_paths\(name\)

描述：返回指定扩展的版本更新路径。

返回类型：text\(source text\), text\(path text\), text\(target text\)

- pg\_get\_serial\_sequence\(tablename, colname\)

描述：获取对应表名和列名上的序列。

返回类型：text

示例：

    ```
    openGauss=# select * from pg_get_serial_sequence('t1', 'c1');
     pg_get_serial_sequence
    ------------------------
     public.serial
    (1 row)
    ```

- pg\_sequence\_parameters\(sequence\_oid\)

描述：获取指定sequence的参数，包含起始值，最小值和最大值，递增值等。

返回类型：int16, int16,int16, bigint, Boolean

示例：

    ```
    openGauss=# select * from pg_sequence_parameters(16420);
     start_value | minimum_value |    maximum_value    | increment | cycle_option
    -------------+---------------+---------------------+-----------+--------------
             101 |             1 | 9223372036854775807 |         1 | f
    (1 row)
    ```

- pg\_sequence\_all\_parameters\(sequence\_name\)

描述：获取指定sequence的参数，包含起始值，最小值，最大值，递增值，是否为循环序列，缓存值，当前值，是否被调用，日志计数，uuid，上一个已使用的值，序列值是否已用完。

返回类型：int16, int16, int16, int16, boolean, int16, int16, boolean, bigint, bigint, int16, boolean

示例：

    ```
    openGauss=# create sequence seq1 increment by 2 start with 15 minvalue 10 maxvalue 100 cycle;
    CREATE SEQUENCE
    openGauss=# select * from pg_sequence_all_parameters('seq1');
     start_value | minimum_value | maximum_value | increment | cycle_option | cache_size | last_value |
    is_called | log_cnt | uuid | last_used_value | is_exhausted
    -------------+---------------+---------------+-----------+--------------+------------+------------+
    -----------+---------+------+-----------------+--------------
              15 |            10 |           100 |         2 | t            |          1 |         15 |
    f         |       0 |    0 |                 | f
    (1 row)

    openGauss=# select nextval('seq1');
     nextval
    ---------
        15
    (1 row)

    openGauss=# select * from pg_sequence_all_parameters('seq1');
     start_value | minimum_value | maximum_value | increment | cycle_option | cache_size | last_value |
    is_called | log_cnt | uuid | last_used_value | is_exhausted
    -------------+---------------+---------------+-----------+--------------+------------+------------+
    -----------+---------+------+-----------------+--------------
              15 |            10 |           100 |         2 | t            |          1 |         15 |
    t         |      32 |    0 |              15 | f
    (1 row)

    ```

- pg\_relation\_is\_updatable(reloid, include\_triggers)

描述：获取对象支持修改时间的类型，update为4，insert为8，delete为16。include\_triggers如果为true，表示需要考虑对象上的触发器。

返回类型： int

- pg\_column\_is\_updatable(reloid, attnum, include\_triggers)

描述：获取对象某一列是否可更新删除。

返回类型： bool

## 注释信息函数

- col\_description\(table\_oid, column\_number\)

描述：获取一个表字段的注释

返回类型：text

备注：col\_description返回一个表中字段的注释，通过表OID和字段号来声明。

- obj\_description\(object\_oid, catalog\_name\)

描述：获取一个数据库对象的注释

返回类型：text

备注：带有两个参数的obj\_description返回一个数据库对象的注释，该对象是通过其OID和其所属的系统表名称声明。比如，obj\_description\(123456,'pg\_class'\)将返回OID为123456的表的注释。只带一个参数的obj\_description只要求对象OID。

obj\_description不能用于表字段，因为字段没有自己的OID。

- obj\_description\(object\_oid\)

描述：获取一个数据库对象的注释

返回类型：text

- shobj\_description\(object\_oid, catalog\_name\)

描述：获取一个共享数据库对象的注释

返回类型：text

备注：shobj\_description和obj\_description差不多，不同之处仅在于前者用于共享对象。一些系统表是通用于openGauss中所有数据库的全局表，因此这些表的注释也是全局存储的。

## 事务ID和快照

内部事务ID类型（xid）是64位。这些函数使用的数据类型txid\_snapshot，存储在特定时刻事务ID可见性的信息。其组件描述在[表11](#zh-cn_topic_0059777618_t537e765e3f164cdeb9ca75f865e3aa0d)。

**表 12**  快照组件

xmin 最早的事务ID（txid）仍然活动。所有较早事务将是已经提交可见的，或者是直接回滚。
xmax 作为尚未分配的txid。所有大于或等于此txids的都是尚未开始的快照时间，因此不可见。
xip_list 当前快照中活动的txids。这个列表只包含在xmin和xmax之间活动的txids；有可能活动的txids高于xmax。介于大于等于xmin、小于xmax，并且不在这个列表中的txid，在这个时间快照已经完成的，因此按照提交状态查看他是可见还是回滚。这个列表不包含子事务的txids。

txid\_snapshot的文本表示为：xmin:xmax:xip\_list。

示例：10:20:10,14,15意思为：xmin=10, xmax=20, xip\_list=10, 14, 15。

以下的函数在一个输出形式中提供服务器事务信息。这些函数的主要用途是为了确定在两个快照之间有哪个事务提交。

- txid\_current\(\)

描述：获取当前事务ID。

返回类型：bigint

- gs\_txid\_oldestxmin\(\)

描述：获取当前最小事务id的值oldesxmin。

返回类型：bigint

- txid\_current\_snapshot\(\)

描述：获取当前快照。

返回类型：txid\_snapshot

- txid\_snapshot\_xip\(txid\_snapshot\)

描述：在快照中获取正在进行的事务ID。

返回类型：setof bigint

- txid\_snapshot\_xmax\(txid\_snapshot\)

描述：获取快照的xmax。

返回类型：bigint

- txid\_snapshot\_xmin\(txid\_snapshot\)

描述：获取快照的xmin。

返回类型：bigint

- txid\_visible\_in\_snapshot\(bigint, txid\_snapshot\)

描述：在快照中事务ID是否可见（不使用子事务ID）。

返回类型：Boolean

- get\_local\_prepared\_xact\(\)

描述：获取当前节点两阶段残留事务信息，包括事务id，两阶段gid名称，prepared的时间，owner的oid，database的oid及当前节点的node\_name。

返回类型：xid, text, timestamptz, oid, oid，text

- get\_remote\_prepared\_xacts\(\)

描述：获取所有远程节点两阶段残留事务信息，包括事务id，两阶段gid名称，prepared的时间，owner的名称，database的名称及node\_name。

返回类型：xid, text, timestamptz, name, name，text

- global\_clean\_prepared\_xacts\(text, text\)

描述：并发清理两阶段残留事务，仅分布式场景下gs\_clean工具可以调用清理，其他用户调用均返回false。

返回类型：Boolean

- gs\_get\_next\_xid\_csn\(\)

描述：返回全局所有节点上的next\_xid和next\_csn值。

返回值如下：

**表 13**  gs\_get\_next\_xid\_csn返回参数说明

字段名 nodename 节点名称。
next_xid 当前节点下一个事务id号。
next_csn 当前节点下一个csn号。

- slice\(hstore, text\[\]\)

描述： 提取hstore的子集。

返回值： hstore

示例：

    ```
    openGauss=# select slice('a=>1,b=>2,c=>3'::hstore, ARRAY['b','c','x']);
           slice
    --------------------
     "b"=>"2", "c"=>"3"
    (1 row)
    ```

- slice\_array\(hstore, text\[\]\)

描述：提取hstore的值的集合。

返回值：值数组

示例：

    ```
    openGauss=# select slice_array('a=>1,b=>2,c=>3'::hstore, ARRAY['b','c','x']);
     slice_array
    -------------
     {2,3,NULL}
    (1 row)
    ```

- skeys\(hstore\)

描述：返回hstore的所有键构成的集合。

返回值：键的集合。

示例：

    ```
    openGauss=# select skeys('a=>1,b=>2');
     skeys
    -------
     a
     b
    (2 rows)
    ```

- pg\_control\_system\(\)

描述：返回系统控制文件状态。

返回类型：SETOF record

- pg\_control\_checkpoint\(\)

描述：返回系统检查点状态。

返回类型：SETOF record

- pv\_builtin\_functions

描述：查看所有内置系统函数信息。

参数：nan

返回值类型：proname name, pronamespace oid, proowner oid, prolang oid, procost real, prorows real, provariadic oid, protransform regproc, proisagg boolean, proiswindow boolean, prosecdef boolean, proleakproof boolean, proisstrict boolean, proretset boolean, provolatile "char", pronargs smallint, pronargdefaults smallint, prorettype oid, proargtypes oidvector, proallargtypes integer\[\], proargmodes "char"\[\], proargnames text\[\], proargdefaults pg\_node\_tree, prosrc text, probin text, proconfig text\[\], proacl aclitem\[\], prodefaultargpos int2vector, fencedmode boolean, proshippable boolean, propackage boolean, oid oid

- pv\_thread\_memory\_detail

描述：返回各线程的内存信息。

参数：nan

返回值类型：threadid text, tid bigint, thrdtype text, contextname text, level smallint, parent text, totalsize bigint, freesize bigint, usedsize bigint

- pg\_relation\_compression\_ratio

描述：查询表压缩率，默认返回1.0。

参数：text

返回值类型：real

- pg\_relation\_with\_compression

描述：查询表是否压缩。

参数：text

返回值类型：boolean

- pg\_stat\_file\_recursive

描述：列出路径下所有文件。

参数：location text

- pg\_shared\_memory\_detail

描述：返回所有已产生的共享内存上下文的使用信息，各列描述请参考[GS\_SHARED\_MEMORY\_DETAIL](../database_reference/gs_shared_memory_detail.md)。

参数：nan

返回值类型：contextname text, level smallint, parent text, totalsize bigint, freesize bigint, usedsize bigint

- get\_gtm\_lite\_status

描述：返回GTM上的backupXid和csn号，用来支持问题定位，GTM-FREE模式下不支持使用本系统函数。

- gs\_stat\_get\_wlm\_plan\_operator\_info（废弃）

描述：从内部哈希表中获取算子计划信息。

参数：oid

返回值类型：datname text, queryid int8, plan\_node\_id int4, startup\_time int8, total\_time int8, actual\_rows int8, max\_peak\_memory int4, query\_dop int4, parent\_node\_id int4, left\_child\_id int4, right\_child\_id int4, operation text, orientation text, strategy text, options text, condition text, projection text

- pg\_stat\_get\_partition\_tuples\_hot\_updated

描述：返回给定分区id的分区热更新元组数的统计。

参数：oid

返回值类型：bigint

- gs\_session\_memory\_detail\_tp

描述：返回会话的内存使用情况，参考gs\_session\_memory\_detail。

参数：nan

返回值类型：sessid text, sesstype text, contextname text, level smallint, parent text, totalsize bigint, freesize bigint, usedsize bigint

- gs\_thread\_memory\_detail

描述：返回各线程的内存信息。

参数：nan

返回值类型：threadid text, tid bigint, thrdtype text, contextname text, level smallint, parent text, totalsize bigint, freesize bigint, usedsize bigint

- pg\_stat\_get\_wlm\_realtime\_operator\_info（废弃）

描述：从内部哈希表中获取实时执行计划算子信息。

参数：nan

返回值类型：queryid bigint, pid bigint, plan\_node\_id integer, plan\_node\_name text, start\_time timestamp with time zone, duration bigint, status text, query\_dop integer, estimated\_rows bigint, tuple\_processed bigint, min\_peak\_memory integer, max\_peak\_memory integer, average\_peak\_memory integer, memory\_skew\_percent integer, min\_spill\_size integer, max\_spill\_size integer, average\_spill\_size integer, spill\_skew\_percent integer, min\_cpu\_time bigint, max\_cpu\_time bigint, total\_cpu\_time bigint, cpu\_skew\_percent integer, warning text

- pg\_stat\_get\_wlm\_realtime\_ec\_operator\_info（废弃）

描述：从内部哈希表中获取EC执行计划算子信息。

参数：nan

返回值类型：queryid bigint, plan\_node\_id integer, plan\_node\_name text, start\_time timestamp with time zone, ec\_operator integer, ec\_status text, ec\_execute\_datanode text, ec\_dsn text, ec\_username text, ec\_query text, ec\_libodbc\_type text, ec\_fetch\_count bigint

- pg\_stat\_get\_wlm\_operator\_info（废弃）

描述：从内部哈希表中获取执行计划算子信息。

参数：nan

返回值类型：queryid bigint, pid bigint, plan\_node\_id integer, plan\_node\_name text, start\_time timestamp with time zone, duration bigint, query\_dop integer, estimated\_rows bigint, tuple\_processed bigint, min\_peak\_memory integer, max\_peak\_memory integer, average\_peak\_memory integer, memory\_skew\_percent integer, min\_spill\_size integer, max\_spill\_size integer, average\_spill\_size integer, spill\_skew\_percent integer, min\_cpu\_time bigint, max\_cpu\_time bigint, total\_cpu\_time bigint, cpu\_skew\_percent integer, warning text

- pg\_stat\_get\_wlm\_node\_resource\_info

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_session\_wlmstat

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_wlm\_ec\_operator\_info（废弃）

描述：从内部哈希表中获取EC执行计划算子信息。

参数：nan

返回值类型：queryid bigint, plan\_node\_id integer, plan\_node\_name text, start\_time timestamp with time zone, duration bigint, tuple\_processed bigint, min\_peak\_memory integer, max\_peak\_memory integer, average\_peak\_memory integer, ec\_operator integer, ec\_status text, ec\_execute\_datanode text, ec\_dsn text, ec\_username text, ec\_query text, ec\_libodbc\_type text, ec\_fetch\_count bigint

- pg\_stat\_get\_wlm\_instance\_info

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_wlm\_instance\_info\_with\_cleanup

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_wlm\_realtime\_session\_info

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_wlm\_session\_iostat\_info

描述：返回会话负载IO信息。

参数：nan

返回值类型：threadid bigint, maxcurr\_iops integer, mincurr\_iops integer, maxpeak\_iops integer, minpeak\_iops integer, iops\_limits integer, io\_priority integer, curr\_io\_limits integer

- pg\_stat\_get\_wlm\_statistics

Description: This API has been discarded and is unavailable currently.
