# Features

> 来源: https://www.tencentcloud.com/document/product/238/19126

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Features Features Download Focus Mode Font Size Last updated: 2025-05-30 10:14:44 AI-Translated Does TencentDB for SQL Server support manual primary-replica switchover?
The dual-node cloud disk/multi-node cloud disk architecture of TencentDB for SQL Server supports manual primary/secondary switch. For detailed operations, see Manual Primary/Secondary Switching. The dual-node local disk architecture does not support manual primary/secondary switch via the console. If a manual primary/secondary switch is needed, submit a ticket for assistance.
Can TencentDB for SQL Server currently access other heterogeneous databases?
Currently, TencentDB for SQL Server doesn't support accessing other heterogeneous databases from a cloud SQL Server.
Does TencentDB for SQL Server support BULK INSERT and other data import methods?
TencentDB for SQL Server currently does not support BULK INSERT and other data import methods.
Does TencentDB for SQL Server support MSDTC?
TencentDB for SQL Server does not support MSDTC.
What is the encryption method for TencentDB for SQL Server?
TencentDB for SQL Server supports SQL Server's native encryption key method. Users can create database-level encryption keys themselves.
Can TencentDB for SQL Server scan the security system vulnerabilities of its servers on its own?
TencentDB for SQL Server currently does not support self-scanning for security system vulnerabilities on its servers.
Can TencentDB for SQL Server use a maintenance plan?
TencentDB for SQL Server currently does not support using a maintenance plan. A maintenance plan generates additional packages and JOBs. You can execute this process by directly creating JOBs to execute SQL statements.
Can TencentDB for SQL Server create folders on the server?
TencentDB for SQL Server does not support creating folders on the database server.
How to enable or disable Change Data Capture (CDC) in TencentDB for SQL Server?
Change Data Capture (CDC) is used to capture insertions, updates, and deletions applied to SQL Server tables and provide details of these changes in a convenient relational format. To enable or disable CDC, see Change Data Capture CDC.
How to enable or disable Change Tracking (CT) in TencentDB for SQL Server?
Change Tracking (CT) can be applied to track a specific table or even a specific column in a database. When additions, modifications, or deletions are performed on a table with CT enabled, the system automatically generates a version number for the operation, recording the operation timestamp, operation type, and the primary key of the affected data. To enable or disable CT, see Change Tracking (CT).
How to shrink the database in TencentDB for SQL Server?
You can shrink the database directly through the console. For details, see Shrinking Databases.
How many databases can a single instance of TencentDB for SQL Server create?
From a performance perspective, having too many databases on TencentDB for SQL Server can lead to performance degradation, consuming resources such as worker threads. Exceeding the database creation limit can result in primary-replica synchronization exceptions. It is recommended to keep the number of databases in a single instance below the maximum limit, which is related to the number of CPU cores of the instance. For detailed formulas on the maximum number of databases for each version, see Number of Databases.
Is there a limit on the number of tables for a single instance of TencentDB for SQL Server?
Theoretically, there is no limit on the number of tables for a single instance of TencentDB for SQL Server. However, if the number of tables exceeds 1 million, it may affect database performance. Please regulate the number of tables to ensure it does not exceed 1 million per instance.
Where are the databases created on TencentDB for SQL Server stored?
Log in to the SQL Server SSMS client. After connecting to the instance, right-click Database Properties to view the database file location.
Does TencentDB for SQL Server support reporting services?
TencentDB for SQL Server currently does not support reporting services. If needed, you can use Tencent Cloud's Business Intelligence (BI) product to implement reporting services.
What are the constraints and limitations on the use of features in TencentDB for SQL Server?
To ensure the stability and security of instances, TencentDB for SQL Server imposes some usage constraints. For details, please refer to Constraints and Limitations.
Previous Topic: Parameter Modification Next Topic: Performance, Space, and Memory-Related FAQs Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Does TencentDB for SQL Server support manual primary-replica switchover?
Can TencentDB for SQL Server currently access other heterogeneous databases?
Does TencentDB for SQL Server support BULK INSERT and other data import methods?
Does TencentDB for SQL Server support MSDTC?
What is the encryption method for TencentDB for SQL Server?
Can TencentDB for SQL Server scan the security system vulnerabilities of its servers on its own?
Can TencentDB for SQL Server use a maintenance plan?
Can TencentDB for SQL Server create folders on the server?
How to enable or disable Change Data Capture (CDC) in TencentDB for SQL Server?
How to enable or disable Change Tracking (CT) in TencentDB for SQL Server?
How to shrink the database in TencentDB for SQL Server?
How many databases can a single instance of TencentDB for SQL Server create?
Is there a limit on the number of tables for a single instance of TencentDB for SQL Server?
Where are the databases created on TencentDB for SQL Server stored?
Does TencentDB for SQL Server support reporting services?
What are the constraints and limitations on the use of features in TencentDB for SQL Server?
Search AllCurrent Product Search titles only Enter keywords to search documentation
