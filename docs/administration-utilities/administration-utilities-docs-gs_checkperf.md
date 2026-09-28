# gs\_checkperf

## 背景信息

openGauss提供了gs\_checkperf工具来帮助对openGauss级别（主机CPU占用率、Gauss CPU占用率、I/O使用情况等）、节点级别（CPU使用情况、内存使用情况、I/O使用情况）、会话/进程级别（CPU使用情况、内存使用情况、I/O使用情况）、SSD性能（写入、读取性能）进行定期检查，让用户了解openGauss的负载情况，采取对应的改进措施。

## 前提条件

- openGauss运行状态正常且不为只读模式。

- 运行在数据库之上的业务运行正常。

## 注意事项

- 使用流式容灾功能时，灾备集群不支持此工具。

- gs\_checkperf工具的监控信息依赖于pmk模式下的表的数据。如果pmk模式下的表未执行analyze操作，则可能导致gs\_checkperf工具执行失败。其报错示例信息如下。

    ```
    LOG:  Statistics in some tables or columns(pmk.pmk_snapshot.snapshot_id) are not collected.
    HINT:  Do analyze for them in order to generate optimized plan.
    ```

此时需要登录任一数据库主节点，连接postgres数据库执行如下SQL。

    ```
    analyze pmk.pmk_configuration;
    analyze pmk.pmk_meta_data;
    analyze pmk.pmk_snapshot;
    analyze pmk.pmk_snapshot_dbnode_stat;
    analyze pmk.pmk_snapshot_datanode_stat;
    ```

## 语法

- 检查SSD性能（root用户）

    ```
    gs_checkperf -U USER [-o OUTPUT] -i SSD [-l LOGFILE]
    ```

- 检查openGauss性能（openGauss安装用户）

    ```
    gs_checkperf [-U USER] [-o OUTPUT] [-i PMK] [--detail] [-l LOGFILE]
    ```

- 显示帮助信息

    ```
    gs_checkperf -? | --help
    ```

- 显示版本号信息

    ```
    gs_checkperf -V | --version
    ```

## 参数说明

- -U

运行openGauss的用户名称。

取值范围：运行openGauss的用户名称。

以root用户身份执行此命令必须指定该参数。

- -o

指定性能检查报告输出到指定的文件。

取值范围：指定的文件名称。

不指定则将检查结果输出到屏幕上。

- -i

指定检查项编号，-i参数值不区分大小写。格式：-i PMK、-i SSD。

取值范围：
  - PMK：Platter Magnetic Disk表示机械硬盘。
  - SSD：Solid State Drive表示固态硬盘。

只有openGauss用户才能检查PMK选项。

只有root用户才能检查SSD选项。

如果不指定该参数，以openGauss用户身份默认检查PMK，以root用户身份默认检查SSD。

- --detail

显示PMK检查结果详情。

- -l

指定日志文件的存储路径。

默认路径为：/var/log/gaussdb/omm/om/gs\_checkperf-YYYY-MM-DD\_hhmmss.log

- -?, --help

显示帮助信息。

- -V, --version

显示版本号信息。

**表 1**  性能检查项

性能参数项 openGauss级别 主机CPU占用率 主机CPU占用率。
Gauss CPU占用率 Gauss CPU占用率。
共享内存击中率 共享内存的击中率。
内存中排序比率 内存中完成的排序所占比率。
I/O使用情况 文件读写次数和时间。
磁盘使用情况 文件写次数和平均写时间、最大写时间等。
事务统计 当前SQL执行数和Session数。
节点级别 CPU使用情况 主机使用CPU情况，包括cpu busy time、cpu idle time等。
内存使用情况 主机使用内存情况，包括物理内存总量、已使用量等。
I/O使用情况 文件读写次数和时间。
会话/进程级别 CPU使用情况 会话使用CPU情况，包括cpu busy time、cpu idle time等。
内存使用情况 会话使用内存情况，包括物理内存总量、已使用量等。
I/O使用情况 会话共享缓冲区命中次数等。
SSD性能（只用root用户才能查看） 写入性能 使用dd命令（flag=direct bs=8M count=2560）向每个SSD写入内容，写入每个SSD时间应在10s左右。
读取性能 使用dd命令（flag=direct bs=8M count=2560）从每个SSD读取内容，读取每个SSD时间应在7s左右。

## 示例

示例一：以简要格式在屏幕上显示性能统计结果。

```
gs_checkperf -i pmk -U omm
Cluster statistics information:
    Host CPU busy time ratio                     :    1.43       %
    MPPDB CPU time % in busy time              :    1.88       %
    Shared Buffer Hit ratio                      :    99.96      %
    In-memory sort ratio                         :    100.00     %
    Physical Reads                               :    4
    Physical Writes                              :    25
    DB size                                      :    70         MB
    Total Physical writes                        :    25
    Active SQL count                             :    2
    Session count                                :    3
```

示例二：以详细格式在屏幕上显示性能统计结果。

```
gs_checkperf -i pmk -U omm --detail
Cluster statistics information:
Host CPU usage rate:
    Host total CPU time                          :    42386.667  Jiffies
    Host CPU busy time                           :    1873.333   Jiffies
    Host CPU iowait time                         :    20.000     Jiffies
    Host CPU busy time ratio                     :    4.42       %
    Host CPU iowait time ratio                   :    .05        %
MPPDB CPU usage rate:
    MPPDB CPU time % in busy time              :    19.04      %
    MPPDB CPU time % in total time             :    .84        %
Shared buffer hit rate:
    Shared Buffer Reads                          :    0
    Shared Buffer Hits                           :    24129
    Shared Buffer Hit ratio                      :    100.00     %
    In-memory sort ratio                         :    100.00     %
I/O usage:
    Number of files                              :    537
    Physical Reads                               :    0
    Physical Writes                              :    0
    Read Time                                    :    0          ms
    Write Time                                   :    0          ms
Disk usage:
    DB size                                      :    70         MB
    Total Physical writes                        :    0
    Average Physical write                       :    0
    Maximum Physical write                       :    0
Activity statistics:
    Active SQL count                             :    2
    Session count                                :    3
Node statistics information:
dn_6001_6002:
    MPPDB CPU Time                             :    200        Jiffies
    Host CPU Busy Time                           :    3490       Jiffies
    Host CPU Total Time                          :    42330      Jiffies
    MPPDB CPU Time % in Busy Time              :    5.73       %
    MPPDB CPU Time % in Total Time             :    .47        %
    Physical memory                              :    8231776256 Bytes
    DB Memory usage                              :    877236224  Bytes
    Shared buffer size                           :    33554432   Bytes
    Shared buffer hit ratio                      :    100.00     %
    Sorts in memory                              :    123
    Sorts in disk                                :    0
    In-memory sort ratio                         :    100.00     %
    Number of files                              :    149
    Physical Reads                               :    0
    Physical Writes                              :    0
    Read Time                                    :    0
    Write Time                                   :    0
dn_6003_6004:
    MPPDB CPU Time                             :    170
    Jiffies    Host CPU Busy Time                :    1030       Jiffies
    Host CPU Total Time                          :    42470      Jiffies
    MPPDB CPU Time % in Busy Time              :    16.50      %
    MPPDB CPU Time % in Total Time             :    .40        %
    Physical memory                              :    8231776256 Bytes
    DB Memory usage                              :    881434624  Bytes
    Shared buffer size                           :    33554432   Bytes
    Shared buffer hit ratio                      :    100.00     %
    Sorts in memory                              :    119
    Sorts in disk                                :    0
    In-memory sort ratio                         :    100.00     %
    Number of files                              :    165
    Physical Reads                               :    0
    Physical Writes                              :    0
    Read Time                                    :    0
    Write Time                                   :    0
dn_6005_6006:
    MPPDB CPU Time                             :    220        Jiffies
    Host CPU Busy Time                           :    1100       Jiffies
    Host CPU Total Time                          :    42360      Jiffies
    MPPDB CPU Time % in Busy Time              :    20.00      %
    MPPDB CPU Time % in Total Time             :    .52        %
    Physical memory                              :    8231776256 Bytes
    DB Memory usage                              :    881430528  Bytes
    Shared buffer size                           :    33554432   Bytes
    Shared buffer hit ratio                      :    100.00     %
    Sorts in memory                              :    122
    Sorts in disk                                :    0
    In-memory sort ratio                         :    100.00     %
    Number of files                              :    115
    Physical Reads                               :    0
    Physical Writes                              :    0
    Read Time                                    :    0
    Write Time                                   :    0
Session statistics information(Top 10):
Session CPU statistics:
1 dn_6003_6004-postgres-dbazt:
    Session CPU time                             :    1211
    Database CPU time                            :    37670
    Session CPU time %                           :    3.21       %
2 dn_6005_6006-postgres-dbazt:
    Session CPU time                             :    1204
    Database CPU time                            :    35730
    Session CPU time %                           :    3.37       %
3 dn_6001_6002-postgres-dbazt:
    Session CPU time                             :    1064
    Database CPU time                            :    34120
    Session CPU time %                           :    3.12       %

Session Memory statistics:
1 dn_6005_6006-postgres-dbazt:
    Buffer Reads                                 :    8989
    Shared Buffer Hit ratio                      :    96.97
    In Memory sorts                              :    136
    In Disk sorts                                :    0
    In Memory sorts ratio                        :    100.00
    Total Memory Size                            :    21593048
    Used Memory Size                             :    18496600
2 dn_6003_6004-postgres-dbazt:
    Buffer Reads                                 :    9030
    Shared Buffer Hit ratio                      :    96.94
    In Memory sorts                              :    133
    In Disk sorts                                :    0
    In Memory sorts ratio                        :    100.00
    Total Memory Size                            :    21576664
    Used Memory Size                             :    18495688
3 dn_6001_6002-postgres-dbazt:
    Buffer Reads                                 :    8668
    Shared Buffer Hit ratio                      :    96.97
    In Memory sorts                              :    138
    In Disk sorts                                :    0
    In Memory sorts ratio                        :    100.00
    Total Memory Size                            :    21258856
    Used Memory Size                             :    18159736

Session IO statistics:
1 dn_6003_6004-postgres-dbazt:
    Physical Reads                               :    285
    Read Time                                    :    5320
2 dn_6005_6006-postgres-dbazt:
    Physical Reads                               :    281
    Read Time                                    :    5811
3 dn_6001_6002-postgres-dbazt:
    Physical Reads                               :    271
    Read Time                                    :    4662
```

## 相关命令

[gs\_check](gs_check.md)，[gs\_checkos](gs_checkos.md)
