# Importing Data

> 来源: https://www.tencentcloud.com/document/product/409/7552

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Getting Started Importing Data Importing Data Download Focus Mode Font Size Last updated: 2025-06-09 10:23:44 AI-Translated This document describes how to use DTS or PostgreSQL logical backups to restore data backup files to a TencentDB for PostgreSQL instance.
DTS Detailed data migration plans can be found in Migrating Data Using DTS. Currently, multiple types of source PostgreSQL databases are supported for migration to TencentDB for PostgreSQL.
Data Import/Export Step 1. Prepare a TencentDB for PostgreSQL instance ﻿Purchase a TencentDB for PostgreSQL instance and get its connection address in the console.
Note:
Make sure that its character set is the same as that of the source instance.
Step 2. Make a logical backup of the source instance
1.
Connect to the local (source) PostgreSQL database using a PostgreSQL client.
2.
Run the following command to back up data:
pg_dump -U username -h hostname -p port -x databasename -f filename The parameters are described as follows:
username: Source database username.
hostname: Source database hostname. If logging in from a local database host, localhost can be used.
port: Source database port number.
databasename: Source database name to be exported.
filename: name of the generated backup file.
-x: export data without object permission information of the source database. Importing data with permission information is prone to error. We recommend that you grant permissions later in the target database as needed.
For example, if a database user named pgtest wants to back up a local PostgreSQL database, the user can log in to the PostgreSQL server and run the following command:
pg_dump -U pgtest -h localhost -p 4321 pg001 -f pg001.sql Step 3. Restore data to the target instance We recommend that you upload data to a CVM instance in a secure way (such as encryption and compression) and restore data to the target TencentDB for PostgreSQL instance over the private network.
1.
Log in to the CVM instance.
2.
On the PostgreSQL client, run the following command to import data to the target TencentDB for PostgreSQL instance:
psql -U username -h hostname -d databasename -p port -f filename The parameters are described as follows:
username: Target database username.
hostname: Target database address.
port: Target database port number.
databasename: Target database name.
filename: name of the local backup file For example:
psql -U pgtest -h 10.xxx.xxx.xxx -d pg001 -p 4321 -f pg001.sql Because the permission configuration of the source database may be different from that of the target database, permission-related warnings or errors may appear during the data import process, which can be ignored.
Previous Topic: Managing TencentDB for PostgreSQL Instance Next Topic: Migrating Data with DTS Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page DTS Data Import/Export Step 1. Prepare a TencentDB for PostgreSQL instance Step 2. Make a logical backup of the source instance Step 3. Restore data to the target instance Search AllCurrent Product Search titles only Enter keywords to search documentation
