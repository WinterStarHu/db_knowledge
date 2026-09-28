# 无权限角色导出数据

gs\_dump和gs\_dumpall通过-U指定执行导出的用户帐户。如果当前使用的帐户不具备导出所要求的权限时，会无法导出数据。此时，需先将具有权限的角色赋权给无权限角色，然后在导出命令中设置--role参数来指定具备权限的角色。在执行命令后，gs\_dump和gs\_dumpall会使用--role参数指定的角色，完成导出动作。

## 操作步骤

1. 以操作系统用户omm登录数据库主节点。
2. 使用gs\_dump导出human\_resource数据库数据。

用户jack不具备导出数据库human\_resource的权限，而角色role1具备该权限，要实现导出数据库human\_resource，需要将role1赋权给jack，然后可以在导出命令中设置--role角色为role1，使用role1的权限，完成导出目的。导出文件格式为tar归档格式。

    ```
    gs_dump -U jack -f /home/omm/backup/MPPDB_backup.tar -p 8000 human_resource --role role1 --rolepassword  xxxxxx -F t
    Password:
    ```

**表 1**  常用参数说明

参数说明 连接数据库的用户名。
-U jack 指定用户连接的密码。
如果主机的认证策略是trust，则不会对数据库管理员进行密码验证，即无需输入-W选项。如果没有-W选项，并且不是数据库管理员，会提示用户输入密码。
-W abcd@123 将导出文件发送至指定目录文件夹。如果这里省略，则使用标准输出。
-f /home/omm/backup/MPPDB_backup.tar 指定服务器所侦听的TCP端口或本地Unix域套接字后缀，以确保连接。
-p 8000 dbname 需要导出的数据库名称。
human_resource --role 指定导出使用的角色名。选择该选项，会使导出工具连接数据库后，发起一个SET ROLE角色名命令。当所授权用户（由-U指定）没有导出工具要求的权限时，该选项会起到作用，即切换到具备相应权限的角色。
-r role1 --rolepassword 指定具体角色用户的角色密码。
--rolepassword  xxxxxx 选择导出文件格式。-F参数值如下： p：纯文本格式c：自定义归档d：目录归档格式t：tar归档格式 -F t

其他参数说明请参见《工具与命令参考》中“服务端工具 \> gs\_dump”章节或“服务端工具 \> gs\_dumpall”章节。

## 示例

示例一：执行gs\_dump导出数据，用户jack不具备导出数据库human\_resource的权限，而角色role1具备该权限，要实现导出数据库human\_resource，可以在导出命令中设置--role角色为role1，使用role1的权限，完成导出目的。导出文件格式为tar归档格式。

```
human_resource=# CREATE USER jack IDENTIFIED BY "XXXXXXXX";
CREATE ROLE
human_resource=# GRANT role1 TO jack;
GRANT ROLE

gs_dump -U jack -f /home/omm/backup/MPPDB_backup11.tar -p 8000 human_resource --role role1 --rolepassword xxxxxx -F t
Password:
gs_dump[port='8000'][human_resource][2017-07-21 16:21:10]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 16:21:10]: total time: 4239  ms
```

示例二：执行gs\_dump导出数据，用户jack不具备导出模式public的权限，而角色role1具备该权限，要实现导出模式public，可以在导出命令中设置--role角色为role1，使用role1的权限，完成导出目的。导出文件格式为tar归档格式。

```
human_resource=# CREATE USER jack IDENTIFIED BY "XXXXXXXX";
CREATE ROLE
human_resource=# GRANT role1 TO jack;
GRANT ROLE

gs_dump -U jack -f /home/omm/backup/MPPDB_backup12.tar -p 8000 human_resource -n public --role role1 --rolepassword xxxxxx -F t
Password:
gs_dump[port='8000'][human_resource][2017-07-21 16:21:10]: dump database human_resource successfully
gs_dump[port='8000'][human_resource][2017-07-21 16:21:10]: total time: 3278  ms
```

示例三：执行gs\_dumpall导出数据，用户jack不具备导出所有数据库的权限，而角色role1（管理员）具备该权限，要实现导出所有数据库，可以在导出命令中设置--role角色为role1，使用role1的权限，完成导出目的。导出文件格式为文本归档格式。

```
human_resource=# CREATE USER jack IDENTIFIED BY "XXXXXXXX";
CREATE ROLE
human_resource=# GRANT role1 TO jack;
GRANT ROLE

gs_dumpall -U jack -f /home/omm/backup/MPPDB_backup.sql -p 8000 --role role1 --rolepassword xxxxxx
Password:
gs_dumpall[port='8000'][human_resource][2018-11-14 17:26:18]: dumpall operation successful
gs_dumpall[port='8000'][human_resource][2018-11-14 17:26:18]: total time: 6437  ms
```
