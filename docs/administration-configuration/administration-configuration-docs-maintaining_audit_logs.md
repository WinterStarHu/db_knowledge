# 维护审计日志

## 前提条件

用户必须拥有审计权限。

## 背景信息

- 与审计日志相关的配置参数及其含义请参见[表1](#zh-cn_topic_0237121114_zh-cn_topic_0059778793_t611ff04302e6463c8850c39d3e1d78fb)。

**表 1**  审计日志相关配置参数

配置项 默认值 audit_directory 审计文件的存储目录。
/var/log/gaussdb/用户名/pg_audit audit_resource_policy 审计日志的保存策略。
on（表示使用空间配置策略） audit_space_limit 审计文件占用的磁盘空间总量。
1GB audit_file_remain_time 审计日志文件的最小保存时间。
audit_file_remain_threshold 审计目录下审计文件的最大数量。
1048576

>[!NOTE]说明
>如果使用gs\_om工具部署openGauss，则审计日志路径为 “/var/log/gaussdb/用户名/pg\_audit”。

- 审计日志删除命令为数据库提供的sql函数pg\_delete\_audit，其原型为：

    ```
    pg_delete_audit(timestamp startime,timestamp endtime)
    ```

其中参数startime和endtime分别表示审计记录的开始时间和结束时间。

- 目前常用的记录审计内容的方式有两种：记录到数据库的表中、记录到OS文件中。这两种方式的优缺点比较如[表2](#zh-cn_topic_0237121114_zh-cn_topic_0059778793_t078fedc6256143429079733b91e11d22)所示。

**表 2**  审计日志保存方式比较

记录到表中 不需要用户维护审计日志。
由于表是数据库的对象，如果一个数据库用户具有一定的权限，就能够访问到审计表。如果该用户非法操作审计表，审计记录的准确性难以得到保证。
记录到OS文件中 比较安全，即使一个帐户可以访问数据库，但不一定有访问OS这个文件的权限。
需要用户维护审计日志。

从数据库安全角度出发，openGauss采用记录到OS文件的方式来保存审计结果，保证了审计结果的可靠性。

## 操作步骤

1. 以操作系统用户omm登录数据库主节点。
2. 使用如下命令连接数据库。

    ```
    gsql -d postgres -p 8000
    ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

    ```
    gsql ((openGauss 1.0 build 290d125f) compiled at 2020-05-08 02:59:43 commit 2143 last mr 131
    Non-SSL connection (SSL connection is recommended when requiring high-security)
    Type "help" for help.

    openGauss=#
    ```

3. 选择日志维护方式进行维护。
  - 设置自动删除审计日志

审计文件占用的磁盘空间或者审计文件的个数超过指定的最大值时，系统将删除最早的审计文件，并记录审计文件删除信息到审计日志中。

>[!NOTE]说明
>审计文件占用的磁盘空间大小默认值为1024MB，用户可以根据磁盘空间大小重新设置参数。

配置审计文件占用磁盘空间的大小（audit\_space\_limit）。

  1. 查看已配置的参数。

        ```
        openGauss=# SHOW audit_space_limit;
        audit_space_limit
        -------------------
        1GB
        (1 row)
        ```

如果显示结果不为1GB（1024MB），执行“\\q”命令退出数据库。

  2. 建议执行如下命令设置成默认值1024MB。

        ```
        gs_guc reload -N all -I all -c "audit_space_limit=1024MB"
        ```

配置审计文件个数的最大值（audit\_file\_remain\_threshold）。

  1. 查看已配置的参数。

        ```
        openGauss=# SHOW audit_file_remain_threshold;
        audit_file_remain_threshold
        -----------------------------
        1048576
        (1 row)
        ```

如果显示结果不为1048576，执行“\\q”命令退出数据库。

  2. 建议执行如下命令设置成默认值1048576。

        ```
        gs_guc reload -N all -I all -c "audit_file_remain_threshold=1048576"
        ```

  - 手动备份审计文件

当审计文件占用的磁盘空间或者审计文件的个数超过配置文件指定的值时，系统将会自动删除较早的审计文件，因此建议用户周期性地对比较重要的审计日志进行保存。

  1. 使用show命令获得审计文件所在目录（audit\_directory）。

        ```
        SHOW audit_directory;
        ```

  2. 将审计目录整个拷贝出来进行保存。

  - 手动删除审计日志

当不再需要某时段的审计记录时，可以使用审计接口命令pg\_delete\_audit进行手动删除。

以删除2012/9/20到2012/9/21之间的审计记录为例：

       ```
       SELECT pg_delete_audit('2012-09-20 00:00:00','2012-09-21 23:59:59');
       ```
