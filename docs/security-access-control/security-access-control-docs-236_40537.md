# Instance Data Sync Delay

> 来源: https://www.tencentcloud.com/document/product/236/40537

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Troubleshooting Instance Data Sync Delay Instance Data Sync Delay Download Focus Mode Font Size Last updated: 2024-07-23 17:49:28 Issue Description TencentDB for MySQL utilizes open-source MySQL's native binlog replication technology for default replicas, disaster recovery instances, and read-only instances. Therefore, there may be a delay during async or semi-sync data replication.
Impact If a replica node has a delay, the source-replica switch cannot be completed promptly. In this case, the business may take some time to return to normal.
If a disaster recovery instance has a delay, it cannot be promoted to a master instance before the heaped binlogs run out. During this period, business continuity will be affected.
If the read business has a high requirement for data consistency, you can set a read-only instance removal policy to automatically remove a read-only instance from the read-only instance group (RO group) when its delay with the source instance exceeds the specified threshold. However, once the read-only instance is removed, the business cannot access it through the RO group.
Common Causes No primary key or secondary index When DML operations (e.g., DELETE, UPDATE, and INSERT) are performed on big tables, the rows to be modified will be retrieved based on the primary key or secondary index when the replica node applies the binlog. If the binlog is in the row format and the corresponding table has no primary key or secondary index, a large number of full-table scans will be caused, slowing down the binlog application and leading to data delays.
For detailed solutions, see No primary key or secondary index.
Large transactions A large transaction refers to a transaction performing INSERT, UPDATE, DELETE, REPLACE operations on millions of rows of data, or a single SQL statement modifying millions of rows of data, whose execution time exceeds 30 seconds.
When the source instance executes DML operations involving massive volumes of data, a large number of binlogs will be transferred to the replica instance, which needs the same time consumed by the source instance to complete corresponding transactions, leading to data delays in the replica instance. For detailed solutions, see Large transactions DDL operations As users' queries are run at the read-only node, if the read-only node is running a very time-consuming query, the query will block the DDL operations from the source node until the query completes, resulting in data delays at the read-only node. For detailed solutions, see DDL operations.
Lower instance specifications For read-only and disaster recovery instances, lower specifications than that of the master instance and higher loads will result in data delays.
For detailed solutions, see Lower instance specifications.
The "Waiting for table metadata lock" error A running large transaction or an uncommitted transaction blocks DDL operations, resulting in blocking all operations on this table.
For detailed solutions, see The "Waiting for table metadata lock" error.
Troubleshooting No primary key or secondary index
1.
Log in to the DBbrain console and select Performance Optimization on the left sidebar. On the displayed page, select a database type and an instance at the top, and select the Space Analysis tab.
2.
On the Table Without Primary Key tab, click a table to view its fields and indexes.

﻿ Note:
The list of tables without a primary key is automatically refreshed once a day and can be manually refreshed.
3.
Create a primary key for the table without a primary key listed in Step 2. If the primary key cannot be created, we recommend that you create a secondary index on a column with a high cardinality.
Large transactions
1.
Log in to the DBbrain console and select Monitoring & Alarm > Exception Alarm on the left sidebar. On the displayed page, select a database type and region at the top, and select Replication delay by transaction from the drop-down list of the Diagnosis items column to filter large transaction alarms.

﻿
2.
Split a large transaction into smaller ones by using the WHERE clause to restrict the amount of data processed by each SQL statement.
Note:
After the large transactions are located in DBbrain and split into smaller ones, the read-only nodes can run the smaller transactions quickly to avoid data delays.
DDL operations
1.
Log in to the DBbrain console and select Monitoring & Alarm > Exception Alarm on the left sidebar. On the displayed page, select a database type and region at the top, and select Replication delay by DDL from the drop-down list of the Diagnosis items column to filter DDL alarms.

﻿
2.
Click Details in the Operation column to enter the event details page for troubleshooting.
Event Details: Include the Diagnosis Items, Time Range, Risk Level, Duration, and Overview.
Description: Includes problem snapshots and performance trends of the exception or health inspection event.
Intelligent Analysis: Analyzes the root cause of the performance exception to help you locate the specific operation.
Optimization Advice: provides optimization advice, including but not limited to SQL optimization (index and rewrite), resource configuration optimization, and parameter fine-tuning.
Lower instance specifications
1.
We recommend that the specification of a read-only or disaster recovery instance be larger than that of the source instance. You can view the instance specification in the instance list in the TencentDB for MySQL console.
2.
If the load of a read-only instance is too high due to a large number of analytical businesses, you can upgrade its configurations or optimize inefficient SQL statements.
For more information about SQL statement optimization, see SQL Optimization.
For more information about instance configuration upgrade, see Adjusting Database Instance Specification.
The "Waiting for table metadata lock" error We recommend that you use DBbrain to diagnose your business and instances to locate large transactions based on monitoring metrics such as the slow query metric.
1.
Log in to the DBbrain console and select Monitoring & Alarm > Exception Alarm on the left sidebar. On the displayed page, select a database type and region at the top, and select the following items from the drop-down list of the Diagnosis Items column to filter large transaction alarms.

﻿
2.
Take the solutions below to solve different issues:
If a running large transaction blocks DDL operations, resulting in blocking all operations on this table, you can kill the transaction according to its ID provided in the DBbrain exception diagnosis result.
If an uncommitted transaction blocks DDL operations, resulting in blocking all operations on this table, you can kill the transaction according to its ID provided in the DBbrain exception diagnosis result, check your program, and commit transactions in a timely manner.
In an explicit transaction, a failed operation (e.g., querying a non-existing field) was performed on the table; at this moment, the transaction does not begin but the lock obtained by the failed statement is still held. You can kill the session according to its ID provided in the DBbrain exception diagnosis result.
Previous Topic: foreign_key_checks Causing Secondary Database Exception and Backup Failure Next Topic: Failure to Enable Case Insensitivity Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Issue Description Impact Common Causes Troubleshooting No primary key or secondary index Large transactions DDL operations Lower instance specifications The "Waiting for table metadata lock" error Search AllCurrent Product Search titles only Enter keywords to search documentation
