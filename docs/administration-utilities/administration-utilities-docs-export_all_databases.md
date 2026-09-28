# 导出所有数据库

openGauss支持使用gs\_dumpall工具导出所有数据库的全量信息，包含openGauss中每个数据库信息和公共的全局对象信息。可根据需要自定义导出如下信息：

- 导出所有数据库全量信息，包含openGauss中每个数据库信息和公共的全局对象信息（包含角色和表空间信息）。

使用导出的全量信息可以创建与当前主机相同的一个主机环境，拥有相同数据库和公共全局对象，且库中数据也与当前各库相同。

- 仅导出数据，即导出每个数据库中的数据，且不包含所有对象定义和公共的全局对象信息。
- 仅导出所有对象定义，包括：表空间、库定义、函数定义、模式定义、表定义、索引定义和存储过程定义等。

使用导出的对象定义，可以快速创建与当前主机相同的一个主机环境，拥有相同的数据库和表空间，但是库中并无原数据库的数据。

## 操作步骤

1. 以操作系统用户omm登录数据库主节点。

2. 使用gs\_dumpall一次导出所有数据库信息。

    ```
    gs_dumpall  -U omm -f /home/omm/backup/MPPDB_backup.sql -p 8000
    ```

常用参数说明请见下表，其他参数说明请参见《工具与命令参考》中“服务端工具 \> gs\_dumpall”章节。

**表 1**  常用参数说明

参数说明 连接数据库的用户名，需要是openGauss管理员用户。
-U omm 指定用户连接的密码。
如果主机的认证策略是trust，则不会对数据库管理员进行密码验证，即无需输入-W选项；如果没有-W选项，并且不是数据库管理员，会提示用户输入密码。
-W abcd@123 将导出文件发送至指定目录文件夹。如果这里省略，则使用标准输出。
-f /home/omm/backup/MPPDB_backup.sql 指定服务器所监听的TCP端口或本地Unix域套接字后缀，以确保连接。
-p 8000

## 示例

示例一：执行gs\_dumpall，导出所有数据库全量信息（omm用户为管理员用户），导出文件为文本格式。执行命令后，会有很长的打印信息，最终出现total time即代表执行成功。示例中将不体现中间的打印信息。

```
gs_dumpall -U omm -f /home/omm/backup/MPPDB_backup.sql -p 8000
Password:
gs_dumpall[port='8000'][2017-07-21 15:57:31]: dumpall operation successful
gs_dumpall[port='8000'][2017-07-21 15:57:31]: total time: 9627  ms
```

示例二：执行gs\_dumpall，仅导出所有数据库定义（omm用户为管理员用户），导出文件为文本格式。执行命令后，会有很长的打印信息，最终出现total time即代表执行成功。示例中将不体现中间的打印信息。

```
gs_dumpall  -U omm -f /home/omm/backup/MPPDB_backup.sql -p 8000 -s
Password:
gs_dumpall[port='8000'][2018-11-14 11:28:14]: dumpall operation successful
gs_dumpall[port='8000'][2018-11-14 11:28:14]: total time: 4147  ms
```

示例三：执行gs\_dumpall，仅导出所有数据库中数据，并对导出文件进行加密，导出文件为文本格式。执行命令后，会有很长的打印信息，最终出现total time即代表执行成功。示例中将不体现中间的打印信息。

```
gs_dumpall -f /home/omm/backup/MPPDB_backup.sql -p 8000 -a --with-encryption AES128 --with-key abcdefg_?1234567
gs_dumpall[port='8000'][2018-11-14 11:32:26]: dumpall operation successful
gs_dumpall[port='8000'][2018-11-14 11:23:26]: total time: 4147  ms
```

## 导出全局对象

openGauss支持使用gs\_dumpall工具导出所有数据库公共的全局对象，包含数据库用户和组、表空间及属性（例如：适用于数据库整体的访问权限）信息。

### 操作步骤

1. 以操作系统用户omm登录数据库主节点。
2. 使用gs\_dumpall导出表空间对象信息。

    ```
    gs_dumpall -U omm -f /home/omm/backup/MPPDB_tablespace.sql -p 8000 -t
    Password:
    ```

**表 1**  常用参数说明

参数说明 连接数据库的用户名，需要是openGauss管理员用户。
-U omm 指定用户连接的密码。
如果主机的认证策略是trust，则不会对数据库管理员进行密码验证，即无需输入-W选项；如果没有-W选项，并且不是数据库管理员，会提示用户输入密码。
-W abcd@123 将导出文件发送至指定目录文件夹。如果这里省略，则使用标准输出。
-f /home/omm/backup/MPPDB_tablespace.sql 指定服务器所侦听的TCP端口或本地Unix域套接字后缀，以确保连接。
-p 8000 或者--tablespaces-only，只转储表空间，不转储数据库或角色。

其他参数说明请参见《工具与命令参考》中“服务端工具 > gs_dumpall”章节。

### 示例

示例一：执行gs\_dumpall，导出所有数据库的公共全局表空间信息和用户信息（omm用户为管理员用户），导出文件为文本格式。

```
gs_dumpall -U omm -f /home/omm/backup/MPPDB_globals.sql -p 8000 -g
Password:
gs_dumpall[port='8000'][2018-11-14 19:06:24]: dumpall operation successful
gs_dumpall[port='8000'][2018-11-14 19:06:24]: total time: 1150  ms
```

示例二： 执行gs\_dumpall，导出所有数据库的公共全局表空间信息（omm用户为管理员用户），并对导出文件进行加密，导出文件为文本格式。

```
gs_dumpall -U omm -f /home/omm/backup/MPPDB_tablespace.sql -p 8000 -t --with-encryption AES128 --with-key abcdefg_?1234567
Password:
gs_dumpall[port='8000'][2018-11-14 19:00:58]: dumpall operation successful
gs_dumpall[port='8000'][2018-11-14 19:00:58]: total time: 186  ms
```

示例三：执行gs\_dumpall，导出所有数据库的公共全局用户信息（omm用户为管理员用户），导出文件为文本格式。

```
gs_dumpall -U omm -f /home/omm/backup/MPPDB_user.sql -p 8000 -r
Password:
gs_dumpall[port='8000'][2018-11-14 19:03:18]: dumpall operation successful
gs_dumpall[port='8000'][2018-11-14 19:03:18]: total time: 162  ms
```
