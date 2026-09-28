# 对比：磁盘与MOT

下表简要对比了基于openGauss磁盘的存储引擎和MOT存储引擎的各种特性。

对比：基于磁盘与MOT

openGauss 磁盘存储 openGauss MOT引擎 英特尔x86+鲲鹏ARM SQL和功能集覆盖率 100% 98% 纵向扩容（多核，NUMA） 吞吐量 分布式 隔离级别 RC+SIRR RC+SIRR 并发控制策略 悲观+MVCC 乐观+MVCC 数据容量（数据+索引） 不受限制 受限于DRAM 本地编译 YesQuery (by PREPARE command)存储过程（使用PREPARE命令） 复制、恢复 复制选项 2（同步，异步） 3（同步、异步、组提交）

**其中，**

- RR=可重复读取
- RC=读已提交
- SI=快照隔离
