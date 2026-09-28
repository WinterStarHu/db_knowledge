# 实战案例 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/ops/actual-combat-cases.html

实战案例 | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

数据库规范化部署

安装前准备工作 单机安装部署 数据守护集群安装部署 读写分离集群安装部署 共享存储集群安装部署 新一代分布式集群安装部署

数据库运维监控

系统资源监控 实例状态监控 运维监控工具

数据库健康检查

系统健康检查 实例健康检查 集群健康检查

数据库备份还原

物理备份还原 逻辑备份还原 实战案例

性能诊断与优化

性能诊断 性能优化

故障诊断与排除

SQL 类故障 实例故障 人为操作故障

实战案例

一、前言

本文根据数据备份还原的经典场景，总结以下例子以作说明示范。主要针对以下场景进行说明：

全库 + 增量备份集还原数据库。

全库 + 增量备份集 + 归档还原数据库。

二、全库 + 增量备份集还原数据库

2.1 还原原理

增量还原指通过增量备份集进行数据还原操作。在使用增量备份集进行数据库还原的前提是已对数据库进行全库备份。因为增量还原过程中隐含一个完全还原操作。选择增量备份还原时，直接选择最后一个增量备份集进行还原即可，数据库会自动从最早一个全库备份寻找开始还原。如果增量备份集的基备份集被删除了，那么单独使用这个增量备份集是无法进行还原操作的。

例如，数据库在使用全库 + 增量备份集进行数据库还原时，会先对数据库进行全库备份（在备份之前需要设置好归档）产生完全备份集 A，当对数据库进行相关操作（增删改）之后，依次进行增量备份并产生增量备份集 B、C、D。当使用增量备份集进行数据库还原时，可以直接使用最后一个增量备份集 D 进行还原操作，最终完成整个数据库还原过程。

注意

1.使用增量备份集进行还原时，增量备份集的基备份集不能被删除。

2.进行增量备份还原，需要将该增量备份之前完整的全库备份及增量备份都进行拷贝。

2.2 准备工作

数据准备，执行以下命令：

--创建表并插入数据 create table test (a int );
insert into test values (1);
commit;

第一次全库备份。

backup database full backupset '/dm8/data/DAMENG/bak/DB_DAMENG_FULL_2021_09_28_22_37_43' compressed level 1;

第二次备份为增量备份。

##插入数据2
insert into test values(2);
commit;

##执行增量备份
backup database increment WITH BACKUPDIR '/dm8/data/DAMENG/bak' backupset '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_40_46' compressed level 1;

第三次备份为增量备份。

##插入数据3
insert into test values(3);
commit;

##执行增量备份
backup database increment WITH BACKUPDIR '/dm8/data/DAMENG/bak' backupset '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_43_20' compressed level 1;

查看备份集

##检查生成的备份集
[dmdba@localhost bak]$ ls DB_DAMENG_FULL_2021_09_28_22_37_43 DB_DAMENG_INCRE_2021_09_28_22_40_46 DB_DAMENG_INCRE_2021_09_28_22_43_20 [dmdba@localhost bak]$ pwd /dm8/data/DBOA/bak

注意

如果两个增量备份期间未产生新数据，则无法进行增量备份。

2.3 具体步骤

停止数据库服务，还原步骤如下：

##检验备份集是否正确
RMAN>CHECK BACKUPSET '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_43_20';

##还原
RESTORE DATABASE '/dm8/data/DAMENG/dm.ini' FROM BACKUPSET   '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_43_20';

##恢复
RECOVER DATABASE '/dm8/data/DAMENG/dm.ini' FROM BACKUPSET   '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_43_20';

##更新数据库魔数
RECOVER DATABASE '/dm8/data/DAMENG/dm.ini'  UPDATE DB_MAGIC;

注意

当备份集为脱机备份即备份过程中无日志生成，那么此时还原后的数据库中数据与备份时数据状态一致。在不需要重做归档日志恢复数据的情况下，可以直接更新 DB_MAGIC 完成数据库恢复操作。

还原成功后，启动数据库并开始检查数据。

--查看表数据 SQL> select * from test;
行号     A
---------- -----------
1          1 2          2 3          3

三、全库 + 增量备份集 + 归档还原数据库

3.1 还原原理

归档日志是保证数据一致性和完整性的重要保障。配有归档日志的数据库系统在出现故障时丢失数据的可能性更小，这是因为一旦出现介质故障如磁盘损坏时，利用归档日志，系统可被恢复至故障发生的前一刻，也可以还原到指定的时间点。当利用归档恢复到指定时间点时，需调用 UNTIL TIME 字段指定备份的截止时间点，即可以实现恢复数据库到指定时间点。

3.2 准备工作

数据准备，执行以下命令：

create table test (a int );
insert into test values (1);
commit;

第一次全库备份。

backup database full backupset '/dm8/data/DAMENG/bak/DB_DAMENG_FULL_2021_09_28_22_37_43' compressed level 1;

第二次备份为增量备份。

##插入数据2
insert into test values(2);
commit;

##执行增量备份
backup database increment WITH BACKUPDIR '/dm8/data/DAMENG/bak' backupset '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_40_46' compressed level 1;

第三次备份为增量备份。

##插入数据3
insert into test values(3);
commit;

##执行增量备份
backup database increment WITH BACKUPDIR '/dm8/data/DAMENG/bak' backupset '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_43_20' compressed level 1;

插入数据 4 并提交，产生新数据归档。

##插入数据4
insert into test values(4);
commit;

插入数据 5 并提交，产生新数据归档。

##插入数据5
insert into test values(5);
commit;

查看备份集。

[dmdba@localhost bak]$ ls DB_DAMENG_FULL_2021_09_28_22_37_43 DB_DAMENG_INCRE_2021_09_28_22_40_46 DB_DAMENG_INCRE_2021_09_28_22_43_20 [dmdba@localhost bak]$ pwd /dm8/data/DBOA/bak

注意

如果两个增量备份期间未产生新数据，则无法进行增量备份。

3.3 具体步骤

3.3.1 还原到当前最新数据时刻

停止数据库服务，还原步骤如下：

##检验备份集是否正确
RMAN>CHECK BACKUPSET  '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_43_20';

##还原
RESTORE DATABASE '/dm8/data/DAMENG/dm.ini'  FROM  BACKUPSET  '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_28_22_43_20';

##恢复
RECOVER DATABASE '/dm8/data/DAMENG/dm.ini'  WITH ARCHIVEDIR '/dm8/dmarch';

##更新数据库魔数
RECOVER DATABASE '/dm8/data/DAMENG/dm.ini'  UPDATE DB_MAGIC;

还原成功后，启动数据库，并检验数据库里最新记录值。

##结果显示恢复到归档数据5
##查看表数据
SQL> select * from test;
行号     A
---------- -----------
1          1 2          2 3          3 4          4 5          5

3.3.2 恢复到指定时间点

停止数据库服务，还原步骤如下：

##检验备份集是否正确
RMAN>CHECK BACKUPSET  '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_29_13_24_28';

##还原
RESTORE DATABASE '/dm8/data/DAMENG/dm.ini'  FROM  BACKUPSET  '/dm8/data/DAMENG/bak/DB_DAMENG_INCRE_2021_09_29_13_24_28';

##恢复
RECOVER DATABASE '/dm8/data/DAMENG/dm.ini'  WITH ARCHIVEDIR '/dm8/dmarch'  UNTIL TIME '2021-12-17 15:21:00 ';

##更新数据库魔数
RECOVER DATABASE '/dm8/data/DAMENG/dm.ini'  UPDATE DB_MAGIC;

还原成功后，启动数据库，并检验数据库里最新记录值。

##结果显示恢复到归档数据4
##查看表数据
SQL> select * from test;
行号     A
---------- -----------
1          1 2          2 3          3 4          4

上次更新：2026-09-26 上一篇下一篇

实战案例

一、前言 二、全库 + 增量备份集还原数据库
2.1 还原原理
2.2 准备工作
2.3 具体步骤
三、全库 + 增量备份集 + 归档还原数据库
3.1 还原原理
3.2 准备工作
3.3 具体步骤
3.3.1 还原到当前最新数据时刻
3.3.2 恢复到指定时间点

微信扫码 分享文档

扫一扫 联系客服

关于我们

合作伙伴

招贤纳士

英文站

达梦官网

达梦技术

蜀天梦图

微信公众号

24小时热线

400 991 6599

商务咨询转 1 号线

技术咨询转 2 号线

技术支持

dmtech@dameng.com

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

数据库规范化部署

安装前准备工作 单机安装部署 数据守护集群安装部署 读写分离集群安装部署 共享存储集群安装部署 新一代分布式集群安装部署

数据库运维监控

系统资源监控 实例状态监控 运维监控工具

数据库健康检查

系统健康检查 实例健康检查 集群健康检查

数据库备份还原

物理备份还原 逻辑备份还原 实战案例

性能诊断与优化

性能诊断 性能优化

故障诊断与排除

SQL 类故障 实例故障 人为操作故障

简体中文

简体中文
