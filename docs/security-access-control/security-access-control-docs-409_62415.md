# Test Methods

> 来源: https://www.tencentcloud.com/document/product/409/62415

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Performance White Paper Test Methods Test Methods Download Focus Mode Font Size Last updated: 2024-08-09 15:23:48 Test Tool Sysbench is an open-source, modular, cross-platform multi-threaded benchmark test tool tailored for online transaction processing (OLTP) scenarios. Sysbench can evaluate and test the performance of database core parameters under high load conditions.
In a standard OLTP read-write scenario of SysBench, a transaction contains 18 read-write SQL statements.
In a standard OLTP read-only scenario of SysBench, a transaction contains 14 read SQL statements (10 primary key point queries, 4 range queries).
In a standard OLTP write-only scenario of SysBench, a transaction contains 4 write SQL statements (2 UPDATE statements, 1 DELETE statement, 1 INSERT statement).
SysBench version 1.1.0 is used for this stress test. For more information, see the official document for Sysbench.
Test Environment This document describes the environment used for the performance test of TencentDB for PostgreSQL.
Region/AZ: Beijing - Beijing Zone 7 Client: CVM Standard S6 (16 cores, 32GB, SSD cloud disk) 5Mbps Client OS: 64-bit TencentOS Server 2.6 (Final) Network: Both the CVM and TencentDB for PostgreSQL instances use the Virtual Private Cloud (VPC) and are in the same subnet The information on the TencentDB for PostgreSQL instances tested is as follows:
Storage type: General - local high-performance SSD disk Instance architecture: Dual-machine high availability (one primary and one secondary) - read-write instance Instance version: V14.2 Primary-replica replication mode: Asynchronous replication Test Metrics This document describes test metrics for the performance test of TencentDB for PostgreSQL.
Metrics

Definition

TPS (Transactions Per Second)

The number of transactions executed per second by the database, based on the number of successful COMMITs.

QPS (Queries Per Second)

The number of SQL statements executed per second by the database, including INSERT, SELECT, UPDATE, DELETE, and COMMIT.

Concurrency

The number of concurrent requests initiated by the client during performance test.
Description of SysBench Parameters pgsql-host: The private network address of the TencentDB for PostgreSQL instance pgsql-port: The port number of the TencentDB for PostgreSQL instance pgsql-user: The username of the TencentDB for PostgreSQL instance pgsql-password: The password of the above username pgsql-db: The database name table-size: The data size of a single table tables: The total number of tables threads: The number of concurrent threads time: Running time Test Method Note:
Replace XXX in the following command with the private network address, port number, username, user password, database name of the TencentDB for PostgreSQL test instance, as well as the single-table data size and total number of tables for the corresponding test scenario. For a detailed description of parameters, refer to the Description of SysBench Parameters.
The steps to test the oltp_write_only scenario using Sysbench are as follows. To test oltp_read_only and oltp_read_write, simply replace the corresponding Lua model scenario file:
1.
Prepare data sysbench /usr/local/share/sysbench/oltp_write_only.lua --db-driver=pgsql  --pgsql-host=XXX  --pgsql-port=XXX --pgsql-user=XXX  --pgsql-password=XXX  --pgsql-db=XXX --table-size=XXX --tables=XXX   prepare
2.
Run the command to perform stress test sysbench /usr/local/shareping sysbench/oltp_write_only.lua --db-driver=pgsql --pgsql-host=XXX  --pgsql-port=XXX --pgsql-user=XXX  --pgsql-password=XXX  --pgsql-db=XXX --table-size=XXX --tables=XXX --threads=XXX --time=XXX --report-interval=1 run
3.
Clear the data sysbench /usr/local/share/sysbench/oltp_write_only.lua --db-driver=pgsql  --pgsql-host=XXX  --pgsql-port=XXX --pgsql-user=XXX  --pgsql-password=XXX  --pgsql-db=XXX --table-size=XXX --tables=XXX cleanup Previous Topic: Long transaction check Next Topic: Test Results Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Test Tool Test Environment Test Metrics Description of SysBench Parameters Test Method Search AllCurrent Product Search titles only Enter keywords to search documentation
