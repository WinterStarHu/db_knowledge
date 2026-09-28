# gs_preupgradechk

## 背景信息

gs_preupgradechk工具用来检查集群中cpu、内存、磁盘、网络、进程等资源情况。

## 前提条件

- 各主机间普通用户正常。

- 普通用户执行gs_preupgradechk命令。

[!NOTE]说明

若为环境变量分离的模式安装的数据库，普通用户需要source环境变量分离文件ENVFILE。
若为环境变量不分离的模式安装的数据库，普通用户需要source ~/.bashrc。

## 语法

- 检查操作系统信息

    ```
    gs_preupgradechk -i ITEM [-l LOGFILE]
    ```

- 显示帮助信息

    ```
    gs_preupgradechk -? | --help
    ```

- 显示版本号信息

    ```
    gs_preupgradechk -V | --version
    ```

## 参数说明

- -i

列表编号。格式：-i A或-i A1,A2。

取值范围：A1...A7。

详细的检查项请参见[表1](#zh-cn_topic_0237152331_zh-cn_topic_0059778883_t5348bfc47f50450687012eacb1a1ba4e)。

- -l

指定日志文件及存放路径。

默认值：$GAUSSLOG/om/gs\_preupgradechk-YYYY-MM-DD\_hhmmss.log。

- -?, --help

显示帮助信息。

- -V, --version

显示版本号信息。

**表 1**  操作系统检查项

检查项 检查项详细说明 cpu使用率（cpu used status） 检查cpu的使用率，大于95%报错；大于85报warning；其他正常。
内存使用率 （mem used status） 检查内存的使用率，大于95%报错；大于85报warning；其他正常。
磁盘空间 （disk used status） 磁盘空间设置检查：保证/tmp目录、/home目录有50M的空间；资源池化data和log的使用率不超过datastorage_threshold_value_check设置的值。
进程状态 （process status） 保证集群的状态正常。
网络状态（network status） 保证各个节点的网络可以互通。
数据库参数 （database status） process_used_memory的值达到了max_process_memory的90%，报Warning，否则正常；活跃连接数大于20，报Warning，否则正常。
备机回放延迟（replay status） 传统主备：备机需要回放的数据量超过1G，报Error，超过300MB，报Warning，其他Normal；资源池化不校验。

## 示例

```
gs_preupgradechk -i A
Checking all item
Successfully checked all item, result is
[openGaussxxx]
    Memory usage is at 18.0%                                [Normal]
    All disk space is enough.                               [Normal]
    process is normal                                       [Normal]
    successfully checked network                            [Normal]
    CPU usage is at 1.8%                                    [Normal]
    max_process_memory is greater than process_used_memory  [Normal]
    The number of active connections is 1                   [Normal]
    Do not check replay.                                    [Normal]

[openGaussxxx]
    Memory usage is at 23.4%                                [Normal]
    All disk space is enough.                               [Normal]
    process is normal                                       [Normal]
    successfully checked network                            [Normal]
    CPU usage is at 18.0%                                   [Normal]
    max_process_memory is greater than process_used_memory  [Normal]
    The number of active connections is 1                   [Normal]
    Do not check replay.                                    [Normal]

[openGaussxxx]
    Memory usage is at 31.7%                                [Normal]
    All disk space is enough.                               [Normal]
    process is normal                                       [Normal]
    successfully checked network                            [Normal]
    CPU usage is at 20.0%                                   [Normal]
    max_process_memory is greater than process_used_memory  [Normal]
    The number of active connections is 1                   [Normal]
    The replay lag is 0 bytes.                              [Normal]
```
