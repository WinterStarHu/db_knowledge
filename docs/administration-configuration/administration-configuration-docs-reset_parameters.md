# 重设参数

## 背景信息

openGauss提供了多种修改GUC参数的方法，用户可以方便的针对数据库、用户、会话进行设置。

- 参数名称不区分大小写。
- 参数取值有整型、浮点型、字符串、布尔型和枚举型五类。
  - 布尔值可以是（on，off）、（true，false）、（yes，no）或者（1，0），且不区分大小写。
  - 枚举类型的取值是在系统表pg\_settings的enumvals字段取值定义的。
- 对于有单位的参数，在设置时请指定单位，否则将使用默认的单位。
  - 参数的默认单位在系统表pg\_settings的unit字段定义的。
  - 内存单位有：kB（千字节）、MB（兆字节）和GB（吉字节）。
  - 时间单位：ms（毫秒）、s（秒）、min（分钟）、h（小时）和d（天）。

具体参数说明请参见[GUC参数说明](../database_reference/guc_parameter_usage.md)。

## GUC参数设置

openGauss提供了六类GUC参数，具体分类和设置方式请参考[表1](#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)：

**表 1**  GUC参数分类

参数类型 设置方式 INTERNAL 固定参数，在创建数据库的时候确定，用户无法修改，只能通过show语法或者pg_settings视图进行查看。
POSTMASTER 数据库服务端参数，在数据库启动时确定，可以通过配置文件指定。
支持表2中的方式一、方式四。
SIGHUP 数据库全局参数，可在数据库启动时设置或者在数据库启动后，发送指令重新加载。
支持表2中的方式一、方式二、方式四。
BACKEND 会话连接参数。在创建会话连接时指定，连接建立后无法修改。连接断掉后参数失效。内部使用参数，不推荐用户设置。
支持表2中的方式一、方式二、方式四。
SUSET 数据库管理员参数。可在数据库启动时、数据库启动后或者数据库管理员通过SQL进行设置。
支持表2中的方式一、方式二或由数据库管理员通过方式三设置。
USERSET 普通用户参数。可被任何用户在任何时刻设置。
支持表2中的方式一、方式二或方式三设置。

openGauss提供了四种方式来修改GUC参数，具体操作请参考[表2](#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t290c8f15953843db8d8e53d867cd893d)：

**表 2**  GUC参数设置方式

设置方法 方式一 使用如下命令修改参数。gs_guc set -D datadir -c "paraname=value" 重启数据库使参数生效。
gs_om -t stop &amp;&amp; gs_om -t start 方式二 gs_guc reload -D datadir -c "paraname=value" 方式三 修改指定数据库、用户、会话级别的参数。
设置数据库级别的参数openGauss=# ALTER DATABASE dbname SET paraname TO value;
在下次会话中生效。
设置用户级别的参数openGauss=# ALTER USER username SET paraname TO value;
在下次会话中生效。
设置会话级别的参数openGauss=# SET paraname TO value;
修改本次会话中的取值。退出会话后，设置将失效。
方式四 使用ALTER SYSTEM SET修改数据库参数。
设置POSTMASERT级别的参数openGauss=# ALTER SYSTEM SET paraname TO value;
重启后生效。
设置SIGHUP级别的参数openGauss=# ALTER SYSTEM SET paraname TO value;
立刻生效(实际等待线程重新加载参数略有延迟)。
设置BACKEND级别的参数openGauss=# ALTER SYSTEM SET paraname TO value;
在下次会话中生效。

>[!WARNING]注意
>使用方式一和方式二设置参数时，若所设参数不属于当前环境，数据库会提示参数不在支持范围内的相关信息。

## 操作步骤

使用方式一设置数据库参数，以在数据库主节点设置archive\_mode参数为例。

1. 以操作系统用户omm登录数据库主节点。
2. 查看archive\_mode参数。

    ```
    cat /gaussdb/data/dbnode/postgresql.conf | grep archive_mode
    ```

    ```
    archive_mode = on
    ```

on表示日志要进行归档操作。

3. 设置archive\_mode参数为off，关闭日志的归档操作。

    ```
    gs_guc set -D /gaussdb/data/dbnode -c "archive_mode=off"
    ```

>[!NOTE]说明
>
>可以使用以下命令在数据库节点上设置archive\_mode参数为off。
>
>```
>gs_guc set -N all -I all -c "archive_mode=off"
>```

4. 重启数据库使参数生效。

    ```
    gs_om -t stop && gs_om -t start
    ```

5. 使用如下命令连接数据库。

    ```
    gsql -d postgres -p 8000
    ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

    ```
    gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
    Non-SSL connection (SSL connection is recommended when requiring high-security)
    Type "help" for help.

    openGauss=#
    ```

6. 检查参数设置的正确性。

    ```
    openGauss=# SHOW archive_mode;
     archive_mode
    --------------
     off
    (1 row)
    ```

使用方式二设置参数，以在数据库主节点设置authentication\_timeout参数为例。

1. 以操作系统用户omm登录数据库主节点。
2. 查看authentication\_timeout参数。

    ```
    cat /gaussdb/data/dbnode/postgresql.conf | grep authentication_timeout
    ```

    ```
    authentication_timeout = 1min
    ```

3. 设置authentication\_timeout参数为59s。

    ```
    gs_guc reload -N all -I all -c "authentication_timeout = 59s"

    Total instances: 2. Failed instances: 0.
    Success to perform gs_guc!
    ```

>[!NOTE]说明
>
>可以使用以下命令在数据库节点上设置authentication\_timeout参数为59s。
>
>```
>gs_guc reload -N all -I all -c "authentication_timeout = 59s"
>```

4. 使用如下命令连接数据库。

    ```
    gsql -d postgres -p 8000
    ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

    ```
    gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
    Non-SSL connection (SSL connection is recommended when requiring high-security)
    Type "help" for help.

    openGauss=#
    ```

5. 检查参数设置的正确性。

    ```
    openGauss=# SHOW authentication_timeout;
     authentication_timeout
    ------------------------
     59s
    (1 row)
    ```

使用方式三设置参数，以设置explain\_perf\_mode参数为例。

1. 以操作系统用户omm登录数据库主节点。
2. 使用如下命令连接数据库。

    ```
    gsql -d postgres -p 8000
    ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

    ```
    gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
    Non-SSL connection (SSL connection is recommended when requiring high-security)
    Type "help" for help.

    openGauss=#
    ```

3. 查看explain\_perf\_mode参数。

    ```
    openGauss=# SHOW explain_perf_mode;
     explain_perf_mode
    -------------------
     normal
    (1 row)
    ```

4. 设置explain\_perf\_mode参数。

使用以下任意方式进行设置：

  - 设置数据库级别的参数

        ```
        openGauss=# ALTER DATABASE postgres SET explain_perf_mode TO pretty;
        ```

当结果显示为如下信息，则表示设置成功。

        ```
        ALTER DATABASE
        ```

在下次会话中生效。

  - 设置用户级别的参数

        ```
        openGauss=# ALTER USER omm SET explain_perf_mode TO pretty;
        ```

当结果显示为如下信息，则表示设置成功。

        ```
        ALTER ROLE
        ```

在下次会话中生效。

  - 设置会话级别的参数

        ```
        openGauss=# SET explain_perf_mode TO pretty;
        ```

当结果显示为如下信息，则表示设置成功。

        ```
        SET
        ```

5. 检查参数设置的正确性。

    ```
    openGauss=# SHOW explain_perf_mode;
     explain_perf_mode
    --------------
     pretty
    (1 row)
    ```

## 示例

- 示例1：使用方式一修改openGauss数据库主节点的最大连接数。
  1. 以操作系统用户omm登录数据库主节点。
  2. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  3. 查看最大连接数。

        ```
        openGauss=# SHOW max_connections;
         max_connections
        -----------------
         200
        (1 row)
        ```

  4. 使用如下命令退出数据库。

        ```
        openGauss=# \q
        ```

  5. 修改openGauss数据库主节点的最大连接数。

        ```
        gs_guc set -N all -I all -c "max_connections = 800"
        ```

  6. 重启openGauss。

        ```
        gs_om -t stop && gs_om -t start
        ```

  7. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  8. 查看最大连接数。

        ```
        openGauss=# SHOW max_connections;
         max_connections
        -----------------
         800
        (1 row)
        ```

- 示例2：使用方式二设置数据库主节点的客户端认证最长时间参数“authentication\_timeout”
  1. 以操作系统用户omm登录数据库主节点。
  2. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  3. 查看客户端认证的最长时间。

        ```
        openGauss=# SHOW authentication_timeout;
         authentication_timeout
        ------------------------
         1min
        (1 row)
        ```

  4. 使用如下命令退出数据库。

        ```
        openGauss=# \q
        ```

  5. 修改数据库主节点的客户端认证最长时间。

        ```
        gs_guc reload -N all -I all -c "authentication_timeout = 59s"
        ```

  6. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  7. 查看客户端认证的最长时间。

        ```
        openGauss=# SHOW authentication_timeout;
         authentication_timeout
        ------------------------
         59s
        (1 row)
        ```

- 示例3：修改openGauss数据库节点的最大连接数。
  1. 以操作系统用户omm登录数据库主节点。
  2. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  3. 查看最大连接数。

        ```
        openGauss=# SHOW max_connections;
         max_connections
        -----------------
         200
        (1 row)
        ```

  4. 使用如下命令退出数据库。

        ```
        openGauss=# \q
        ```

  5. 修改openGauss数据库节点的最大连接数。

        ```
        gs_guc set -N all -I all -c "max_connections = 500"
        ```

  6. 重启openGauss。

        ```
        gs_om -t stop
        gs_om -t start
        ```

  7. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  8. 查看最大连接数。

        ```
        openGauss=# SHOW max_connections;
         max_connections
        -----------------
         500
        (1 row)
        ```

- 示例4：设置数据库节点的客户端认证最长时间参数“authentication\_timeout”
  1. 以操作系统用户omm登录数据库主节点。
  2. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  3. 查看客户端认证的最长时间。

        ```
        openGauss=# SHOW authentication_timeout;
         authentication_timeout
        ------------------------
         1min
        (1 row)
        ```

  4. 使用如下命令退出数据库。

        ```
        openGauss=# \q
        ```

  5. 修改openGauss数据库节点的客户端认证最长时间。

        ```
        gs_guc reload -N all -I all -c "authentication_timeout = 30s"
        ```

  6. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql((openGauss x.x.x build f521c606) compiled at 2021-09-16 14:55:22 commit 2935 last mr 6385 release)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  7. 查看客户端认证的最长时间。

        ```
        openGauss=# SHOW authentication_timeout;
         authentication_timeout
        ------------------------
         30s
        (1 row)
        ```
