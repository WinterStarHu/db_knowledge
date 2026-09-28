# Using pglogical for Logical Replication

> 来源: https://www.tencentcloud.com/document/product/409/64755

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Use Cases Using pglogical for Logical Replication Using pglogical for Logical Replication Download Focus Mode Font Size Last updated: 2025-06-09 10:25:49 AI-Translated pglogical is a logical replication extension plugin for PostgreSQL. It uses the "publish/subscribe" data model for data replication. This model includes a "publisher" and a "subscriber". The publisher is used to define and publish designated data, and the subscriber can choose to subscribe, thereby receiving and using data changes. pglogical allows users to replicate only specific data content, reducing unnecessary data transmission and processing, making selective replication more efficient.
The replication of pglogical is applicable to various scenarios, including:
database major version upgrade Complete database replication.
Leverage the replica set to selectively filter tables, rows, and columns.
Can be obtained from multiple upstream servers for data aggregation and merging.
Prerequisites Note:
If you need to use the pglogical plugin, please submit a ticket and contact us to add the shared_preload_libraries parameter. Modifying the shared_preload_libraries parameter will restart the instance. Ensure the business has a reconnection mechanism.
TencentDB for PostgreSQL supports configuring pglogical logical replication between the same instance or different instances in the same region.
Note: Currently, only TencentDB for PostgreSQL instances with Linux kernel versions v11.22_r1.21, v12.20_r1.24, v13.16_r1.19, v14.13_r1.26, v15.6_r1.13, v16.4_r1.7 or higher and major versions from 11 to 16 support the pglogical plugin.
Please ensure the shared_preload_libraries parameter includes pglogical, as shown below:
postgres=> show shared_preload_libraries;
shared_preload_libraries

-------------------------------------------------------------------------------------------------------------------------
-------------
pg_stat_statements,pg_stat_log,wal2json,decoderbufs,decoder_raw,pg_hint_plan,rds_server_handler,tencentdb_pwdcheck,pgaud it,pglogical (1 row) The value of the wal_level parameter is logical, as shown below.
postgres=> show wal_level;
wal_level
-----------
logical (1 row) If you need to modify the wal_level parameter, please enter the Parameter Settings page of the TencentDB for PostgreSQL console to modify the parameter.
﻿ Directions Check whether the pglogical plugin can be installed in instances at the publishing end and subscription end.
postgres=> select * from pg_available_extensions where name='pglogical';
name    | default_version | installed_version |            comment
-----------+-----------------+-------------------+--------------------------------
pglogical | 2.4.4           |                   | PostgreSQL Logical Replication (1 row) Installing Plugin Create a database named am and switch to am.
postgres=> create database am;
CREATE DATABASE postgres=> \\c am You are now connected to database "am" as user "dbadmin".
am=> Create table t and insert data am=> create table t(a int primary key, b int);
CREATE TABLE am=> insert into t(a,b)values(1,1),(2,2),(3,3);
INSERT 0 3 am=> select * from t;
a | b
---+---
1 | 1 2 | 2 3 | 3 (3 rows) Execute the following commands on both the publisher and subscriber instances to create the pglogical plugin.
am=> create extension pglogical;
CREATE EXTENSION Use the following command to check whether it is installed successfully.
am=>  select * from pg_extension where extname='pglogical';
oid  |  extname  | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
-------+-----------+----------+--------------+----------------+------------+-----------+--------------
16424 | pglogical |    16387 |        16423 | f              | 2.4.4      |           | (1 row) Create a Publishing Node on the Publisher Create a publishing node. For parameters in dns, refer to Cross-database Access. The parameters here should be filled with the instance information where the Publisher is located.
am=> SELECT pglogical.create_node(node_name := 'provider1',dsn := 'host=10.*.*.* port=5432 dbname=am user=**** password=**** instanceid=postgres-****** uin=********');
create_node
-------------
2976894835 (1 row) Configure a Replica Set The following example shows one way to configure a Replica Set. Use the pglogical_republication_set_add_all_tables function to add all tables under the specified schema to the designated Replica Set. 'default' refers to the name of the Replica Set, which can be customized; here, the default Replica Set name is used. 'public' refers to the schema name where the tables to be published are located, which is 'public' in this case.
For more parameters, see the pglogical official documentation.
am=> SELECT pglogical.replication_set_add_all_tables('default', ARRAY['public']);
replication_set_add_all_tables
--------------------------------
t (1 row) Create a Subscription Node on the Subscriber Create a table in the corresponding database on the subscriber side.
postgres=> \\c am psql (14.11, server 15.6) WARNING: psql major version 14, server major version 15.
Some psql features might not work.
You are now connected to database "am" as user "dbadmin".
am=> create table t(a int primary key, b int);
CREATE TABLE Create a node on the subscriber side. For parameters in dns, refer to Cross-database Access. The parameters here should be filled with the instance information where the subscriber is located.
am=> SELECT pglogical.create_node(node_name := 'subscriber1',dsn := 'host=10.*.*.* port=5432 dbname=am user=**** password=**** instanceid=postgres-***** uin=*******');
create_node
-------------
330520249 (1 row) Create a Subscription on the Subscriber Side Create a node on the subscriber side. For parameters in dns, refer to Cross-database Access. The parameters here should be filled with the instance information where the publisher is located.
am=> SELECT pglogical.create_subscription(subscription_name := 'subscription1',provider_dsn := 'host=10.*.*.* port=5432 dbname=am user=**** password=**** instanceid=postgres-**** uin=*******');
create_subscription
---------------------
1763399739 (1 row) Query the table at the subscription end. Verify the target data. If the query result is consistent with the publisher's data, logical replication is successful.
am=> select * from t;
a | b
---+---
1 | 1 2 | 2 3 | 3 (3 rows) Previous Topic: Implementing Slow SQL Analysis Using the Auto_explain Plugin Next Topic: Using Debezium to Collect PostgreSQL Data Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Directions Installing Plugin Create a Publishing Node on the Publisher Configure a Replica Set Create a Subscription Node on the Subscriber Create a Subscription on the Subscriber Side Search AllCurrent Product Search titles only Enter keywords to search documentation
