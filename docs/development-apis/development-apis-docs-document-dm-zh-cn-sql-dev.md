# SQL 开发指南 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/sql-dev/

SQL 开发指南 | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

SQL 基础实践

单表查询 查询结果排序 多表联合检索 数据操纵 如何使用字符串 如何使用数字 日期运算 日期操作 范围处理 触发器 闪回查询 物化视图 DBLINK 视图、同义词 存储过程 函数

SQL 进阶技巧

分区表 层次查询

DM_SQL

数据类型 异常处理 记录与集合 包和嵌套子程序

开发最佳实践

读写分离集群开发原则

SQL 开发指南

DM 数据库 SQL 开发指南围绕 SQL 优化这一核心主题，主要介绍 DM 数据库查询优化改写技巧及案例，多角度阐述了 SQL 语句优化的各个方面，总结大量的优化实战方法，可帮助读者深入学习与 SQL 优化相关的实战方法和技巧。

本指南主要包含以下内容

SQL 基础实践

SQL 进阶技巧

DM_SQL

开发最佳实践

数据准备 注意 本文档中所有示例均在 DM 示例库 `DMHR` 下完成。

图形化数据库安装过程中，请勾选创建 DMHR 示例库，作为数据库模拟环境，如下图所示：

Linux 安装环境，请下载并执行以下对应的 sh 脚本，完成示例库初始化。

使用数据库实例系统用户登录，可根据实际情况调整脚本。
注意 首先明确运行 `sh` 脚本的客户端使用的字符集，然后下载运行以下对应字符集的 `sh` 脚本，字符集不一致将导致数据存储显示乱码。

GBK 字符集请下载 CREATE_DMHR(GBK).sh，脚本如下所示：

#!/bin/bash

eg_dir=$DM_HOME/samples/instance_script/dmhr/GBK

disql sysdba/*****:10236 <<EOF START ${eg_dir}/CREATESCHEMA.sql START ${eg_dir}/REGION.sql START ${eg_dir}/CITY.sql START ${eg_dir}/LOCATION.sql START ${eg_dir}/JOB.sql START ${eg_dir}/JOB_HISTORY.sql START ${eg_dir}/DEPARTMENT.sql START ${eg_dir}/EMPLOYEE.sql exit EOF

UTF-8 字符集请下载 CREATE_DMHR(UTF-8).sh，脚本如下所示：

#!/bin/bash

eg_dir=$DM_HOME/samples/instance_script/dmhr/UTF-8

disql sysdba/*****:5236 <<EOF create tablespace dmhr datafile 'dmhr.dbf' size 128;
create user dmhr identified by 123456789 default tablespace dmhr;
grant dba to dmhr;
exit;
EOF

disql dmhr/123456789:5236 <<EOF START ${eg_dir}/REGION.sql START ${eg_dir}/CITY.sql START ${eg_dir}/LOCATION.sql START ${eg_dir}/JOB.sql START ${eg_dir}/JOB_HISTORY.sql START ${eg_dir}/DEPARTMENT.sql START ${eg_dir}/EMPLOYEE.sql exit;
EOF

上次更新：2026-09-26 下一篇

SQL 开发指南

本指南主要包含以下内容 数据准备

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

SQL 基础实践

单表查询 查询结果排序 多表联合检索 数据操纵 如何使用字符串 如何使用数字 日期运算 日期操作 范围处理 触发器 闪回查询 物化视图 DBLINK 视图、同义词 存储过程 函数

SQL 进阶技巧

分区表 层次查询

DM_SQL

数据类型 异常处理 记录与集合 包和嵌套子程序

开发最佳实践

读写分离集群开发原则

简体中文

简体中文
