# Audit Performance Description

> 来源: https://www.tencentcloud.com/document/product/409/59729

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Database Audit Audit Performance Description Audit Performance Description Download Focus Mode Font Size Last updated: 2024-04-19 21:58:54 Testing Tool Sysbench is an open-source, modular, and cross-platform multi-threaded benchmark tool tailored for Online Transaction Processing (OLTP) scenarios. It allows you to evaluate and test the performance of database core parameters under high loads.
In a standard OLTP read/write scenario of SysBench, a transaction contains 18 read/write SQL statements.
In a standard OLTP read-only scenario of SysBench, a transaction contains 14 read SQL statements (ten primary key point queries and four range queries).
In a standard OLTP write-only scenario of SysBench, a transaction contains four write SQL statements (two UPDATE, one DELETE, and one INSERT).
This stress test uses SysBench version 1.1.0. For more information, please see Sysbench official documentation.
Testing Environment This document describes the environment used for the TencentDB for PostgreSQL performance test.
Region/AZ: Beijing - Beijing Zone 7.
Client: Standard cloud server S6 (16-core 32 GB, SSD volume) 5Mbps.
Client OS: TencentOS Server 2.6 (Final) 64-bit.
Network: Both the CVM and TencentDB for PostgreSQL instances use the Virtual Private Cloud (VPC) network and are in the same subnet.
The information on the TencentDB for PostgreSQL instances tested is as follows:
Storage type: General purpose - local high-performance SSD disk, 8-core 32GB.
Instance architecture: Dual-machine high availability (one primary and one standby) - read/write instance.
Instance version: V14.2.
Primary-standby replication mode: Asynchronous replication.
Test Metrics This document describes the metrics of the TencentDB for PostgreSQL performance test.
Metrics

Definition

Queries Per Second (QPS)

Number of SQL statements executed per second by the database, including INSERT, SELECT, UPDATE, DELETE, COMMIT, etc.

Concurrency

Number of concurrent requests initiated by the client during performance test.
Parameter Description pgsql-host: private network address of the TencentDB for PostgreSQL instance.
pgsql-port: port number of the TencentDB for PostgreSQL instance.
pgsql-user: username of the TencentDB for PostgreSQL instance.
pgsql-password: password of the above username.
pgsql-db: database name.
table-size: data volume in a single table.
tables: total number of tables.
threads: number of concurrent threads.
time: running time.
Test Method Note:
Please replace XXX in the following commands with the actual private network address, port number, username, user password, and database name of the TencentDB for PostgreSQL instance, and the single table data volume and total number of tables in the corresponding test scenario.
1.
Prepare the data.
sysbench /usr/local/share/sysbench/oltp_write_only.lua --db-driver=pgsql  --pgsql-host=XXX  --pgsql-port=XXX --pgsql-user=XXX  --pgsql-password=XXX  --pgsql-db=XXX --table-size=XXX --tables=XXX   prepare
2.
Run the command to conduct stress testing.
sysbench /usr/local/shareping sysbench/oltp_read_write.lua --db-driver=pgsql --pgsql-host=XXX  --pgsql-port=XXX --pgsql-user=XXX  --pgsql-password=XXX  --pgsql-db=XXX --table-size=XXX --tables=XXX --threads=XXX --time=XXX --report-interval=1 run
3.
Clear the data.
sysbench /usr/local/share/sysbench/oltp_write_only.lua --db-driver=pgsql  --pgsql-host=XXX  --pgsql-port=XXX --pgsql-user=XXX  --pgsql-password=XXX  --pgsql-db=XXX --table-size=XXX --tables=XXX cleanup Test Results The table below compares the QPS performance in different scenarios under the test conditions with a single table data volume (table_size) of 25,000 and a total of 64 tables.
Concurrency

Audit not enabled

Audit Express Edition

Audit Detailed Edition

Set log_statement=all

8

64435.35

63150.59

60371.58

59686.77

16

114649.43

110425.06

107427.92

99278.01

32

118850.71

108233.97

106368.01

87540.78

64

97012.02

88828.3

85892.76

23017.53

128

76381.21

70592.04

69241.45

11799.92
As shown below.
﻿ ﻿

Previous Topic: Modify audit services Next Topic: Instance Lifecycle Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Testing Tool Testing Environment Test Metrics Parameter Description Test Method Test Results Search AllCurrent Product Search titles only Enter keywords to search documentation
