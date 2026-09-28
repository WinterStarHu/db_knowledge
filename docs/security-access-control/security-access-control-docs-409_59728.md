# Modify audit services

> 来源: https://www.tencentcloud.com/document/product/409/59728

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Database Audit Modify audit services Modify audit services Download Focus Mode Font Size Last updated: 2024-04-09 10:26:14 This document describes how to modify the audit service in the console.
Setting the Audit Service For specific operations, refer to the following two methods for setting the audit service.
Method 1:
1.
Log in to the TencentDB for PostgreSQL Console .
2.
In the left sidebar, select Database Audit.
3.
Select Region at the top, then on the Audit Instance page, click Audit Status, and select the Enabled option to filter instances with audit enabled.
4.
You can modify the audit service for one or more instances in the audit instance list, as shown below:
﻿ ﻿ Method 2:
1.
Log in to the TencentDB for PostgreSQL Console .
2.
In the left sidebar, select Database Audit.
3.
Select region at the top, then on the Audit Instance page, click Audit Status, and select the Enabled option to filter instances with audit enabled.
4.
Click Instance ID to enter the audit log list of that instance, then click Service Settings to configure the audit service for the instance.
﻿ Disabling the Audit Service Note:
1.
After the audit service is disabled, audit for the instance will be stopped and historical audit logs will be cleared. Please proceed with caution.
2.
Switching between fast audit and detailed audit will not clear historical audit logs.
You can disable the audit service for one or more instances in the audit instance list, or set the audit service for one or more instances in the audit log list.
1.
Log in to the TencentDB for PostgreSQL Console .
2.
In the left sidebar, select Database Audit.
3.
Select Region at the top, then on the Audit Instance page, click Audit Status, and select the Enabled option to filter instances with audit enabled.
4.
You can modify the audit service for one or more instances in the audit instance list, as shown below:
﻿
5.
You can also click Instance ID to enter the audit log details, and then set or disable the audit service for an individual instance.
﻿ ﻿

Previous Topic: View Audit Logs Next Topic: Audit Performance Description Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Setting the Audit Service Method 1:
Method 2:
Disabling the Audit Service Search AllCurrent Product Search titles only Enter keywords to search documentation
