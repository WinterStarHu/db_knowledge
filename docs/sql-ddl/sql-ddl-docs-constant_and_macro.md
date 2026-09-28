# 常量与宏

openGauss支持的常量和宏请参见[表1](#zh-cn_topic_0283136888_zh-cn_topic_0237121963_zh-cn_topic_0059778360_zh-cn_topic_0058965862_table49126904)。

**表 1**  常量和宏

CURRENT_CATALOG 当前数据库 openGauss=# SELECT CURRENT_CATALOG;
current_database \------------------ openGauss (1 row) CURRENT_ROLE 当前用户 openGauss=# SELECT CURRENT_ROLE;
current_user \-------------- omm (1 row) CURRENT_SCHEMA 当前数据库模式 openGauss=# SELECT CURRENT_SCHEMA;
current_schema \---------------- public (1 row) CURRENT_USER 当前用户 openGauss=# SELECT CURRENT_USER;
current_user \-------------- omm (1 row) LOCALTIMESTAMP 当前会话时间（无时区） openGauss=# SELECT LOCALTIMESTAMP;
timestamp \---------------------------- 2015-10-10 15:37:30.968538 (1 row) NULL SESSION_USER 当前系统用户 openGauss=# SELECT SESSION_USER;
session_user \-------------- omm (1 row) SYSDATE 当前系统日期 openGauss=# SELECT SYSDATE;
sysdate \--------------------- 2015-10-10 15:48:53 (1 row) USER 当前用户，此用户为CURRENT_USER的别名 openGauss=# SELECT USER;
current_user \-------------- omm (1 row)
