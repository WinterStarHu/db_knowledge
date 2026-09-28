# Cross-Database Access

> 来源: https://www.tencentcloud.com/document/product/409/59356

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Use Cases Cross-Database Access Cross-Database Access Download Focus Mode Font Size Last updated: 2026-09-10 14:16:59 AI-Translated Cross-database access refers to the process of reading, writing, and jointly operating on data in other databases within the current instance, or data in other instances. The target objects of cross-database access are collectively referred to as external data sources.
TencentDB for PostgreSQL provides plugins for accessing external data sources to implement and enhance cross-database access capabilities. There are two types of external access plugins:
Type

Plugins

Plugin for homogeneous cross-database access

dblink,postgresql_fdw

Plugin for heterogeneous cross-database access

mysql_fdw,starrocks_fdw,cos_fdw,tds_fdw The steps for cross-database access are as follows:
1.
Install the plugin by using the "CREATE EXTENSION plugin_name;" statement.
2.
Create a foreign server object and a link mapping for each remote database to be connected.
3.
Use the corresponding command to access the foreign table to obtain data.
Additionally, the powerful access capabilities of cross-database access plugins may introduce certain security risks if not constrained. Therefore, TencentDB for PostgreSQL has optimized permission control by classifying and managing instances based on their environments. It has added auxiliary parameters on top of the open-source version to verify user identities and adjust network policies. For details, see Plugin Auxiliary Parameters.
Note:
Only TencentDB for PostgreSQL kernels of major version 10 or later support the dblink plugin. Please note this.
Plugin Auxiliary Parameters host Required for cross-instance access. The IP address of the target instance.
port Required for cross-instance access. The port number of the target instance.
instanceid Instance ID Required for cross-instance access between TencentDB for PostgreSQL instances. The format is similar to postgres-xxxxxx or pgro-xxxxxx, and can be viewed in the instance list in the console.
If the target instance is on a Tencent Cloud CVM, enter the instance ID of the CVM, which is similar to ins-xxxxx.
dbname Database name: Enter the name of the database on the remote PostgreSQL service to be accessed. If you are not performing cross-instance access but only cross-database access within the same instance, you only need to configure this parameter, and all other parameters can be left empty.
access_type Optional. The target instance types are as follows:
When the value is 1, the target instance is a TencentDB instance, including TencentDB for PostgreSQL and TencentDB for MySQL. If not explicitly specified, this option is used by default.
When the value is 2, the target instance is on a Tencent Cloud CVM.
When the value is 3, the target instance is self-built on the Tencent Cloud public network.
When the value is 4, the target instance is connected through Cloud VPN.
When the value is 5, the target instance is connected through a self-built VPN.
When the value is 6, the target instance is connected through Direct Connect.
uin Required. The account ID to which the instance belongs. This information is used to verify user permissions. For details, see Query uin.
own_uin Optional. The root account ID to which the instance belongs. This information is also required to verify user permissions.
vpcid Optional. VPC ID. If the target instance is in a Tencent Cloud CVM VPC network, you need to provide this parameter, which can be viewed in the VPC console.
subnetid Optional. VPC subnet ID. If the target instance is in a Tencent Cloud CVM VPC network, you need to provide this parameter, which can be viewed in the subnet section of the VPC console.
dcgid Optional. Direct Connect ID. If the target instance needs to connect through Direct Connect, you need to provide this parameter value.
vpngwid Optional. VPN gateway ID. If the target instance needs to connect over a VPN, you need to provide this parameter value.
region Optional. The region where the target instance resides, for example, "ap-guangzhou" represents Guangzhou. If you need to access data across regions, you need to provide this parameter value.
Examples of Using postgres_fdw You can use the postgres_fdw plugin to access data in other databases of the current instance or in other PostgreSQL instances.
Step 1: Prerequisites
1.
Create a test database in this instance.
postgres=>create role user1 with LOGIN  CREATEDB tencentdb_superuser  PASSWORD 'password1';
CREATE ROLE postgres=>create database testdb1;
CREATE DATABASE Note:
If an error occurs when the plugin is created, submit a ticket to contact Tencent Cloud after-sales support for assistance.
2.
Create test data in the target instance.
postgres=>create role user2 with LOGIN  CREATEDB PASSWORD 'password2';
postgres=> create database testdb2;
CREATE DATABASE postgres=# grant all on database testdb2 to user2;
GRANT postgres=> \c testdb2 user2 You are now connected to database "testdb2" as user "user2".
testdb2=> create schema test_schema;
CREATE SCHEMA testdb2=> create table test_schema.test_table2(id integer);
CREATE TABLE testdb2=> insert into test_schema.test_table2 values (1);
INSERT 0 1 Step 2: Creating the postgres_fdw Extension
#Perform the creation operation.
postgres=> \c testdb1 You are now connected to database "testdb1" as user "user1".
testdb1=> create extension postgres_fdw;
CREATE EXTENSION
#View
testdb1=> \dx List of installed extensions Name     | Version |   Schema   |                    Description
--------------+---------+------------+----------------------------------------------------
plpgsql      | 1.0     | pg_catalog | PL/pgSQL procedural language postgres_fdw | 1.1     | public     | foreign-data wrapper for remote PostgreSQL servers (2 rows) Step 3: Creating a SERVER Note:
Cross-instance access is supported only on kernel versions v10.17_r1.2, v11.12_r1.2, v12.7_r1.2, v13.3_r1.2, v14.2_r1.0, and later.
Cross-instance access.
#Access data in the target instance testdb2 from testdb1 in the current instance.
testdb1=>create server srv_test1 foreign data wrapper postgres_fdw options (host 'xxx.xxx.xxx.xxx',dbname 'testdb2', port '5432', instanceid 'postgres-xxxxx', uin '10000xxxx001');
CREATE SERVER For cross-database access within the same instance, you only need to configure the dbname parameter.
#Access data in testdb2 of the current instance from testdb1 of the current instance.
create server srv_test1 foreign data wrapper postgres_fdw options (dbname 'testdb2');
The target instance is on a Tencent Cloud CVM, and its network type is Basic Network.
testdb1=>create server srv_test foreign data wrapper postgres_fdw options (host 'xxx.xxx.xxx.xxx', dbname 'testdb2', port '5432', instanceid 'ins-xxxxx', access_type '2', region 'ap-guangzhou', uin 'xxxxxx', own_uin 'xxxxxx');
CREATE SERVER The target instance is on a Tencent Cloud CVM, and its network type is VPC.
testdb1=>create server srv_test1 foreign data wrapper postgres_fdw options (host 'xxx.xxx.xxx.xxx',dbname 'testdb2', port '5432', instanceid 'ins-xxxxx', access_type '2', region 'ap-guangzhou', uin 'xxxxxx', own_uin 'xxxxxx', vpcid 'vpc-xxxxxx', subnetid 'subnet-xxxxx');
CREATE SERVER The target instance is self-built on the Tencent Cloud public network.
testdb1=>create server srv_test1 foreign data wrapper postgres_fdw options (host 'xxx.xxx.xxx.xxx',dbname 'testdb2', port '5432', access_type '3', region 'ap-guangzhou', uin 'xxxxxx', own_uin 'xxxxxx');
CREATE SERVER The target instance is an instance connected through Tencent Cloud VPN.
testdb1=>create server srv_test1 foreign data wrapper postgres_fdw options (host 'xxx.xxx.xxx.xxx',dbname 'testdb2', port '5432', access_type '4', region 'ap-guangzhou', uin 'xxxxxx', own_uin 'xxxxxx', vpngwid 'xxxxxx');
The target instance is connected through a self-built VPN.
testdb1=>create server srv_test1 foreign data wrapper postgres_fdw options (host 'xxx.xxx.xxx.xxx',dbname 'testdb2', port '5432', access_type '5', region 'ap-guangzhou', uin 'xxxxxx', own_uin 'xxxxxx', vpngwid 'xxxxxx');
The target instance is connected through Tencent Cloud Direct Connect.
testdb1=>create server srv_test1 foreign data wrapper postgres_fdw options (host 'xxx.xxx.xxx.xxx',dbname 'testdb2', port '5432', access_type '6', region 'ap-guangzhou', uin 'xxxxxx', own_uin 'xxxxxx', dcgid 'xxxxxx');
CREATE SERVER Step 4: Creating a User Mapping testdb1=> create user mapping for user1 server srv_test1 options (user 'user2', password 'password2');
CREATE USER MAPPING Step 5: Example of Creating a Foreign Table for Cross-Instance Access testdb1=> create foreign table foreign_table1(id integer) server srv_test1 options (schema_name 'test_schema', table_name 'test_table2');
CREATE FOREIGN TABLE Note:
For cross-database access within the same instance, you only need to specify the target table name in the table_name parameter. The schema_name parameter is not required.
Step 6: Accessing Foreign Data testdb1=> select * from foreign_table1;
id
----
1 (1 row) Reference link Official Introduction to postgres_fdw Creating a SERVER in Version 9.3 Creating a SERVER in Version 9.5 Creating a SERVER in Version 10 Creating a SERVER in Version 11 Creating a SERVER in Version 12 Creating a SERVER in Version 13 Creating a SERVER in Version 14 Example of Using dblink Step 1: Creating the dblink Extension postgres=> create extension dblink;
postgres=> \dx List of installed extensions Name        | Version |   Schema   |                            Description
--------------------+---------+------------+-------------------------------------------------------------------
dblink             | 1.2     | public     | connect to other PostgreSQL databases from within a database pg_stat_log        | 1.0     | public     | track runtime execution statistics of all SQL statements executed pg_stat_statements | 1.6     | public     | track execution statistics of all SQL statements executed plpgsql            | 1.0     | pg_catalog | PL/pgSQL procedural language (4 rows) Step 2: Establishing a dblink Connection select dblink_connect('yunpg1','host=10.10.10.11 port=5432 instanceid=postgres-2123455r dbname=postgres access_type=1 user=dbadmin password=P302!');
dblink_connect
----------------
OK (1 row) Step 3: Accessing Foreign Data postgres=> select * from dblink('yunpg1','select catalog_name,schema_name,schema_owner from information_schema.schemata') as t(a varchar(50),b varchar(50),c varchar(50));
a     |         b          |    c
----------+--------------------+---------
postgres | pg_toast           | user_00 postgres | pg_temp_1          | user_00 postgres | pg_toast_temp_1    | user_00 postgres | pg_catalog         | user_00 postgres | public             | user_00 postgres | information_schema | user_00 (6 rows) Reference link ﻿Official Introduction to dblink﻿ Example of Using mysql_fdw Step 1: Creating the mysql_fdw Extension postgres=> create extension mysql_fdw;
CREATE EXTENSION postgres=> \dx;
List of installed extensions Name        | Version |   Schema   |                              Description
--------------------+---------+------------+------------------------------------------------------------------------
dblink             | 1.2     | public     | connect to other PostgreSQL databases from within a database mysql_fdw          | 1.1     | public     | Foreign data wrapper for querying a MySQL server pg_stat_log        | 1.0     | public     | track runtime execution statistics of all SQL statements executed pg_stat_statements | 1.9     | public     | track planning and execution statistics of all SQL statements executed plpgsql            | 1.0     | pg_catalog | PL/pgSQL procedural language (5 rows) Step 2: Creating a SERVER postgres=> CREATE SERVER mysql_svr  FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host '171.16.10.13',port '3306',instanceid 'cdb-l1d95grp',uin '100026380431');
CREATE SERVER Step 3: Creating a User Mapping for Foreign Tables postgres=> CREATE USER MAPPING FOR PUBLIC SERVER mysql_svr OPTIONS (username 'fdw_user',password 'Secret!123');
CREATE USER MAPPING Step 4: Accessing Foreign Data Note:
The MySQL database that this instance connects to must contain at least one table before you can import the table structure by using IMPORT FOREIGN SCHEMA.
postgres=> IMPORT FOREIGN SCHEMA hrdb FROM SERVER mysql_svr INTO public;
Reference link Official Introduction to mysql_fdw Example of Using cos_fdw For a usage example of cos_fdw, see Supporting Tiered Storage with the cos_fdw Extension.
Usage Notes For the target instance, note the following points:
1.
You need to relax the hba restriction of PostgreSQL to allow the created mapped user (for example, user2) to access using MD5. To modify hba, see the official PostgreSQL documentation.
2.
If the target instance is not a TencentDB instance and is configured in hot standby mode, you need to update the server connection address or recreate the server after a primary-standby switch.
Previous Topic: Migrating to Cloud Disk Edition Next Topic: Automatically Creating Partition in PostgreSQL Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Plugin Auxiliary Parameters Examples of Using postgres_fdw Step 1: Prerequisites Step 2: Creating the postgres_fdw Extension Step 3: Creating a SERVER Step 4: Creating a User Mapping Step 5: Example of Creating a Foreign Table for Cross-Instance Access Step 6: Accessing Foreign Data Reference link Example of Using dblink Step 1: Creating the dblink Extension Step 2: Establishing a dblink Connection Step 3: Accessing Foreign Data Reference link Example of Using mysql_fdw Step 1: Creating the mysql_fdw Extension Step 2: Creating a SERVER Step 3: Creating a User Mapping for Foreign Tables Step 4: Accessing Foreign Data Reference link Example of Using cos_fdw Usage Notes Search AllCurrent Product Search titles only Enter keywords to search documentation
