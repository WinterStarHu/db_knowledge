# 导出单个数据库

## 导出数据库

openGauss支持使用gs\_dump工具导出某个数据库级的内容，包含数据库的数据和所有对象定义。可根据需要自定义导出如下信息：

- 导出数据库全量信息，包含数据和所有对象定义。

使用导出的全量信息可以创建一个与当前库相同的数据库，且库中数据也与当前库相同。

- 仅导出所有对象定义，包括：库定义、函数定义、模式定义、表定义、索引定义和存储过程定义等。

使用导出的对象定义，可以快速创建一个相同的数据库，但是库中并无原数据库的数据。

- 仅导出数据，不包含所有对象定义。

### 操作步骤

1. 以操作系统用户omm登录数据库主节点。
2. 使用gs\_dump导出postgres数据库。

    ```
    gs_dump -U jack -f /home/omm/backup/userdatabase_backup.tar -p 8000 postgres -F t
    Password:
    ```

**表 1**  常用参数说明

参数说明 连接数据库的用户名。
-U jack 指定用户连接的密码。
如果主机的认证策略是trust，则不会对数据库管理员进行密码验证，即无需输入-W选项。如果没有-W选项，并且不是数据库管理员，会提示用户输入密码。
-W abcd@123 将导出文件发送至指定目录文件夹。如果这里省略，则使用标准输出。如果输出格式为(-F c/-F d/-F t)时，必须指定-f参数。
-f /home/omm/backup/postgres_backup.tar 指定服务器所侦听的TCP端口或本地Unix域套接字后缀，以确保连接。
-p 8000 dbname 需要导出的数据库名称。
postgres 选择导出文件格式。-F参数值如下： p：纯文本格式c：自定义归档d：目录归档格式t：tar归档格式 -F t

其他参数说明请参见《工具与命令参考》中“服务端工具 \> gs\_dump”章节。

### 示例

示例一：执行gs\_dump，导出postgres数据库全量信息，导出文件格式为sql文本格式。

```
gs_dump -U jack -f /home/omm/backup/postgres_backup.sql -p 8000 postgres -F p
Password:
gs_dump[port='8000'][postgres][2017-07-21 15:36:13]: dump database postgres successfully
gs_dump[port='8000'][postgres][2017-07-21 15:36:13]: total time: 3793  ms
```

示例二：执行gs\_dump，仅导出postgres数据库中的数据，不包含数据库对象定义，导出文件格式为自定义归档格式。

```
gs_dump -U jack -f /home/omm/backup/postgres_data_backup.dmp -p 8000 postgres -a -F c
Password:
gs_dump[port='8000'][postgres][2017-07-21 15:36:13]: dump database postgres successfully
gs_dump[port='8000'][postgres][2017-07-21 15:36:13]: total time: 3793  ms
```

示例三：执行gs\_dump，仅导出postgres数据库所有对象的定义，导出文件格式为sql文本格式。

```
gs_dump -f /home/omm/backup/postgres_def_backup.sql -p 8000 postgres -s -F p
Password:
gs_dump[port='8000'][postgres][2017-07-20 15:04:14]: dump database postgres successfully
gs_dump[port='8000'][postgres][2017-07-20 15:04:14]: total time: 472 ms
```

示例四：执行gs\_dump，仅导出postgres数据库的所有对象的定义，导出文件格式为文本格式，并对导出文件进行加密。

```
gs_dump -f /home/omm/backup/postgres_def_backup.sql -p 8000 postgres --with-encryption AES128 --with-key xxxxxx -s -F p
Password:
gs_dump[port='8000'][postgres][2018-11-14 11:25:18]: dump database postgres successfully
gs_dump[port='8000'][postgres][2018-11-14 11:25:18]: total time: 1161  ms
```

## 导出模式

openGauss目前支持使用gs\_dump工具导出模式级的内容，包含模式的数据和定义。用户可通过灵活的自定义方式导出模式内容，不仅支持选定一个模式或多个模式的导出，还支持排除一个模式或者多个模式的导出。可根据需要自定义导出如下信息：

- 导出模式全量信息，包含数据和对象定义。
- 仅导出数据，即模式包含表中的数据，不包含对象定义。
- 仅导出模式对象定义，包括：表定义、存储过程定义和索引定义等。

### 操作步骤

1. 以操作系统用户omm登录数据库主节点。
2. 使用gs\_dump同时导出hr和public模式。

    ```
    gs_dump -U jack -f /home/omm/backup/MPPDB_schema_backup -p 8000 human_resource -n hr -n public -F d
    Password:
    ```

**表 1**  常用参数说明

参数说明 连接数据库的用户名。
-U jack 指定用户连接的密码。
如果主机的认证策略是trust，则不会对数据库管理员进行密码验证，即无需输入-W选项。如果没有-W选项，并且不是数据库管理员，会提示用户输入密码。
-W abcd@123 将导出文件发送至指定目录文件夹。如果这里省略，则使用标准输出。
-f /home/omm/backup/MPPDB_schema_backup 指定服务器所侦听的TCP端口或本地Unix域套接字后缀，以确保连接。
-p 8000 dbname 需要导出的数据库名称。
human_resource 只导出与模式名称匹配的模式，此选项包括模式本身和所有它包含的对象。
单个模式：-n schemaname多个模式：多次输入-n schemaname 单个模式：-n hr多个模式：-n hr -n public 选择导出文件格式。-F参数值如下： p：纯文本格式c：自定义归档d：目录归档格式t：tar归档格式 -F d

其他参数说明请参见《工具与命令参考》中“服务端工具 \> gs\_dump”章节。

### 示例

示例一：执行gs\_dump，导出hr模式全量信息，导出文件格式为文本格式。

```
gs_dump -f /home/omm/backup/MPPDB_schema_backup.sql -p 8000 human_resource -n hr -F p
Password:
gs_dump[port='8000'][human_resource][2017-07-21 16:05:55]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 16:05:55]: total time: 2425  ms
```

示例二：执行gs\_dump，仅导出hr模式的数据，导出文件格式为tar归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_schema_data_backup.tar -p 8000 human_resource -n hr -a -F t
Password:
gs_dump[port='8000'][human_resource][2018-11-14 15:07:16]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2018-11-14 15:07:16]: total time: 1865  ms
```

示例三：执行gs\_dump，仅导出hr模式的定义，导出文件格式为目录归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_schema_def_backup -p 8000 human_resource -n hr -s -F d
Password:
gs_dump[port='8000'][human_resource][2018-11-14 15:11:34]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2018-11-14 15:11:34]: total time: 1652  ms
```

示例四：执行gs\_dump，导出human\_resource数据库时，排除hr模式，导出文件格式为自定义归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_schema_backup.dmp -p 8000 human_resource -N hr -F c
Password:
gs_dump[port='8000'][human_resource][2017-07-21 16:06:31]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 16:06:31]: total time: 2522  ms
```

示例五：执行gs\_dump，同时导出hr和public模式，且仅导出模式定义，导出文件格式为tar归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_schema_backup1.tar -p 8000 human_resource -n hr -n public -s -F t
gs_dump[port='8000'][human_resource][2017-07-21 16:07:16]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 16:07:16]: total time: 2132  ms
```

示例六：执行gs\_dump，导出human\_resource数据库时，排除hr和public模式，导出文件格式为自定义归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_schema_backup2.dmp -p 8000 human_resource -N hr -N public -F c
Password:
gs_dump[port='8000'][human_resource][2017-07-21 16:07:55]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 16:07:55]: total time: 2296  ms
```

示例七：执行gs\_dump，导出public模式下所有表（视图、序列和外表）和hr模式中staffs表，包含数据和表定义，导出文件格式为自定义归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_backup3.dmp -p 8000 human_resource -t public.* -t hr.staffs -F c
Password:
gs_dump[port='8000'][human_resource][2018-12-13 09:40:24]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2018-12-13 09:40:24]: total time: 896  ms
```

## 导出表

openGauss支持使用gs\_dump工具导出表级的内容，包含表定义和表数据。视图、序列和外表属于特殊的表。用户可通过灵活的自定义方式导出表内容，不仅支持选定一个表或多个表的导出，还支持排除一个表或者多个表的导出。可根据需要自定义导出如下信息：

- 导出表全量信息，包含表数据和表定义。
- 仅导出数据，不包含表定义。
- 仅导出表定义。

### 操作步骤

1. 以操作系统用户omm登录数据库主节点。
2. 使用gs\_dump同时导出指定表hr.staffs和hr.employments。

    ```
    gs_dump -U jack -f /home/omm/backup/MPPDB_table_backup -p 8000 human_resource -t hr.staffs -t hr.employments -F d
    Password:
    ```

**表 1**  常用参数说明

参数说明 连接数据库的用户名。
-U jack 指定用户连接的密码。
如果主机的认证策略是trust，则不会对数据库管理员进行密码验证，即无需输入-W选项。如果没有-W选项，并且不是数据库管理员，会提示用户输入密码。
-W abcd@123 将导出文件发送至指定目录文件夹。如果这里省略，则使用标准输出。
-f /home/omm/backup/MPPDB_table_backup 指定服务器所侦听的TCP端口或本地Unix域套接字后缀，以确保连接。
-p 8000 dbname 需要导出的数据库名称。
human_resource 指定导出的表（或视图、序列、外表），可以使用多个-t选项来选择多个表，也可以使用通配符指定多个表对象。当使用通配符指定多个表对象时，注意给pattern打引号，防止shell扩展通配符。
单个表：-t schema.table多个表：多次输入-t schema.table 单个表：-t hr.staffs多个表：-t hr.staffs -t hr.employments 选择导出文件格式。-F参数值如下： p：纯文本格式c：自定义归档d：目录归档格式t：tar归档格式 -F d 不转储的表（或视图、或序列、或外表）对象列表，可以使用多个-t选项来选择多个表，也可以使用通配符制定多个表对象。当同时输入-t和-T时，会转储在-t列表中，而不在-T列表中的表对象。
-T table1

其他参数说明请参见《工具与命令参考》中“服务端工具 \> gs\_dump”章节。

## 示例

>[!NOTE]说明
下方示例导出后，在导入恢复前，需要确保存在导出表所在的schema。

示例一：执行gs\_dump，导出表hr.staffs的定义和数据，导出文件格式为文本格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_backup.sql -p 8000 human_resource -t hr.staffs  -F p
Password:
gs_dump[port='8000'][human_resource][2017-07-21 17:05:10]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 17:05:10]: total time: 3116  ms
```

示例二：执行gs\_dump，只导出表hr.staffs的数据，导出文件格式为tar归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_data_backup.tar -p 8000 human_resource -t hr.staffs -a -F t
Password:
gs_dump[port='8000'][human_resource][2017-07-21 17:04:26]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 17:04:26]: total time: 2570  ms
```

示例三：执行gs\_dump，导出表hr.staffs的定义，导出文件格式为目录归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_def_backup -p 8000 human_resource -t hr.staffs -s -F d
Password:
gs_dump[port='8000'][human_resource][2017-07-21 17:03:09]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 17:03:09]: total time: 2297  ms
```

示例四：执行gs\_dump，不导出表hr.staffs，导出文件格式为自定义归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_backup4.dmp -p 8000 human_resource -T hr.staffs -F c
Password:
gs_dump[port='8000'][human_resource][2017-07-21 17:14:11]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 17:14:11]: total time: 2450  ms
```

示例五：执行gs\_dump，同时导出两个表hr.staffs和hr.employments，导出文件格式为文本格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_backup1.sql -p 8000 human_resource -t hr.staffs -t hr.employments -F p
Password:
gs_dump[port='8000'][human_resource][2017-07-21 17:19:42]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 17:19:42]: total time: 2414  ms
```

示例六：执行gs\_dump，导出时，排除两个表hr.staffs和hr.employments，导出文件格式为文本格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_backup2.sql -p 8000 human_resource -T hr.staffs -T hr.employments -F p
Password:
gs_dump[port='8000'][human_resource][2017-07-21 17:21:02]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 17:21:02]: total time: 3165  ms
```

示例七：执行gs\_dump，导出表hr.staffs的定义和数据，只导出表hr.employments的定义，导出文件格式为tar归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_backup3.tar -p 8000 human_resource -t hr.staffs -t hr.employments --exclude-table-data hr.employments -F t
Password:
gs_dump[port='8000'][human_resource][2018-11-14 11:32:02]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2018-11-14 11:32:02]: total time: 1645  ms
```

示例八：执行gs\_dump，导出表hr.staffs的定义和数据，并对导出文件进行加密，导出文件格式为文本格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_backup4.sql -p 8000 human_resource -t hr.staffs --with-encryption AES128 --with-key abcdefg_?1234567 -F p
Password:
gs_dump[port='8000'][human_resource][2018-11-14 11:35:30]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2018-11-14 11:35:30]: total time: 6708  ms
```

示例九：执行gs\_dump，导出public模式下所有表（包括视图、序列和外表）和hr模式中staffs表，包含数据和表定义，导出文件格式为自定义归档格式。

```
gs_dump -f /home/omm/backup/MPPDB_table_backup5.dmp -p 8000 human_resource -t public.* -t hr.staffs -F c
Password:
gs_dump[port='8000'][human_resource][2018-12-13 09:40:24]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2018-12-13 09:40:24]: total time: 896  ms
```

示例十： 执行gs\_dump，仅导出依赖于t1模式下的test1表对象的视图信息，导出文件格式为目录归档格式。

```
gs_dump -U jack -f /home/omm/backup/MPPDB_view_backup6 -p 8000 human_resource -t t1.test1 --include-depend-objs --exclude-self -F d
Password:
gs_dump[port='8000'][jack][2018-11-14 17:21:18]: dump database human_resource successfully
gs_dump[port='8000'][jack][2018-11-14 17:21:23]: total time: 4239  ms
```
