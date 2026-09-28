# Instructions

> 来源: https://www.tencentcloud.com/document/product/409/64828

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Instructions Operation Guide Verification Failure Handling Creating a Data Consistency Check Task Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Migration Guide DTS-Based Logical Migration Instructions Instructions Download Focus Mode Font Size Last updated: 2024-11-04 09:51:40 Category

Description

Supported versions

1.
Source database Self-built databases PostgreSQL 10-16 Third-party cloud vendors 10-16 Alibaba Cloud RDS PostgreSQL AWS RDS PostgreSQL Huawei Cloud RDS for PostgreSQL TencentDB for PostgreSQL 10-16 (Migration within the same root account/Migration between different root accounts)
2.
Target database TencentDB for PostgreSQL 10-16

Impact on the source database

1.
During full data migration, Data Transfer Service (DTS) consumes certain source instance resources, which may increase the load and pressure of the source database. If your database configuration is low, we recommend you perform the migration during off-peak hours.
2.
During the actual migration process, the rate can be influenced by factors such as the read performance of the source instance, network bandwidth between the source and target instances, and the specifications and performance of the target instance. The migration concurrency is determined by the number of cores of the target instance. For example, if the target instance has 2 cores, the concurrency will be 2.

Migration object

Interrelated data objects need to be migrated together; otherwise, the migration will fail. Common association relationships include: views referencing tables, views referencing views, storage procedures/functions/triggers referencing views/tables, and table association through primary and foreign keys.

Source database requirements

When Full + Incremental Migration is selected as the migration type, the tables in the source database must have primary keys; otherwise, data inconsistency between the source and target databases may occur. For tables without primary keys, it is recommended to select Full Migration.

Target database requirements

If the entire instance is to be migrated, the target database must not contain users and roles with the same names as those in the source database.

Network description

1.
When a migration task is configured, the source database address must use the IP address and port that can directly connect to the PostgreSQL instance. Do not use the IP address and port of proxies like pgpool.
2.
To ensure migration efficiency, cross-region migration is not supported for self-built instances on Cloud Virtual Machine (CVM). If cross-region migration is needed, choose the public network access method.

Operation limits

1.
During the structural migration, full migration, and incremental migration, do not perform DDL operations or Large Object operations; otherwise, data inconsistency will occur.
2.
Do not modify or delete user information (including the username, password, and permissions) and port numbers in the source and target databases during migration.
Previous Topic: Fix Table Bloat Next Topic: Operation Guide Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now Search AllCurrent Product Search titles only Enter keywords to search documentation
