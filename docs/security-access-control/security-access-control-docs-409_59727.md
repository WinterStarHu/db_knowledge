# View Audit Logs

> 来源: https://www.tencentcloud.com/document/product/409/59727

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Database Audit View Audit Logs View Audit Logs Download Focus Mode Font Size Last updated: 2025-03-31 15:58:05 This document describes how to view database audit logs and related fields in the audit log list.
Viewing Audit Logs
1.
Log in to the TencentDB for PostgreSQL Console .
2.
On the left sidebar, select Database Audit.
3.
Select region at the top, then on the Audit Instance page, click Audit Status and select the Enabled option to filter instances with audit enabled.
﻿
4.
In the Audit Instance list, find the Target Instance (you can also quickly search by resource attributes in the search box), click View Audit Log in its action column to jump to the Audit Log page to view the corresponding log. For the difference between Rapid Audit and Detailed Audit logs, please see Audit service description.
﻿ Search Tool Description In the Audit Instance Filter, you can select to switch between other audit instances with the audit service enabled.
In the time box, select a time period (log retention period) to peek at the relevant audit logs within the selected period.
Note:
You can select any time period with data for search. Up to the first 60,000 eligible records can be displayed.
In the search box, select search items (SQL Details, Client IP, User Account, Database Name, SQL Type, Execution Time (ms), Affected Rows) to look up relevant audit results. Multiple search items are separated by carriage return keys .
All search  items are in "include" search mode.
Search Item

Description

Command

Enter SQL Details. Multiple keywords are separated by line breaks.
SQL command details search is case-insensitive.
When the match type is either "include" or "exclude", it only supports fuzzy search at the token level, instead of wildcard fuzzy search.

Client IP

Enter Client IP. Multiple keywords are separated by line breaks. IP addresses can be filtered using * as a condition.

Database Account

Enter user account name. Multiple keywords are separated by line breaks.

Database Name

Enter the database name. Multiple keywords are separated by line breaks.

SQL Type

Select one or more SQL types from the drop-down list (ALTER, ANALYZE, BEGIN, CALL, CHECKPOINT, CLOSE, COMMENT, COMMIT, COPY, CREATE, DEALLOCATE, DECLARE, DISCARD, DO, DROP, EXECUTE, EXPLAIN, FETCH, GRANT, IMPORT, LISTEN, LOAD, LOCK, MOVE, NOTIFY, PREPARE, REASSIGN, REFRESH, REINDEX, RELEASE, RESET, REVOKE, ROLLBACK, SAVEPOINT, SECURITY, SELECT, SET, SHOW, START TRANSACTION, TRUNCATE, UNLISTEN, UPDATE, VACUUM). Multiple selections are supported.

Execution Time (us)

Enter execution time in the format of number N. Support filtering for matches above N milliseconds.

Affected Rows

Enter the number of affected rows in the format of number N. Support filtering for matches above N rows. The number of affected rows refers to the actual count of rows impacted when performing modification operations (such as INSERT, UPDATE, DELETE) on a data table. This figure can assist you in comprehending the extent of the operation's impact.
Downloading a Log You can generate an audit log file first and then download it. The steps are as follows:
1.
On the audit log page, click ﻿ on the right to generate an audit log file.
﻿ ﻿
2.
After the audit log file is generated, you can download it from the file list.
Note:
An audit log file can save up to the first 6,000,000 records of the search results.
Currently, you can download log files only at the Tencent Cloud private network addresses. Please download them through the Tencent cloud service servers in the same region (for example, to download the audit logs of TencentDB for PostgreSQL instances in the Beijing region, please download them with a CVM instance in the Beijing region).
Log files are valid for 24 hours, so please download them in a timely manner.
The wget command format is wget -c '<log file download URL>' -O <custom file name>.tar.gz.
Each database instance contains no more than 30 log files. Please download files and delete them promptly to clear space.
Previous Topic: Enabling the Audit Service Next Topic: Modify audit services Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Viewing Audit Logs Search Tool Description Downloading a Log Search AllCurrent Product Search titles only Enter keywords to search documentation
