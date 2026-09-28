# Publish/Subscribe

> 来源: https://www.tencentcloud.com/document/product/238/47713

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Publish/Subscribe Publish/Subscribe Download Focus Mode Font Size Last updated: 2025-05-30 10:10:20 AI-Translated Does TencentDB for SQL Server support publish/subscribe?
The publish/subscription feature of TencentDB for SQL Server is only supported in scenarios where instances are published and subscribed in TencentDB for SQL Server. Only the TencentDB for SQL Server dual-node (formerly HA Edition/Cluster Edition) instances support publish/subscription. Single-node (formerly Basic Edition) and multi-node instances do not support it.
Does a TencentDB for SQL Server single-node (formerly Basic Edition) instance support publish/subscribe?
No.
Does the TencentDB for SQL Server multi-node support publish/subscription?
The TencentDB for SQL Server multi-node does not support publish/subscription.
How do I implement publish/subscribe between a self-built SQL Server database in my local IDC and a TencentDB for SQL Server instance?
The publish/subscribe feature is not supported between a self-built SQL Server database in a local IDC and a TencentDB for SQL Server instance. It is available only when both the publishing and subscribing instances are TencentDB for SQL Server instances.
What are the use cases of the publish/subscribe feature of TencentDB for SQL Server?
TencentDB for SQL Server supports the native publish/subscribe-based replication feature of Microsoft SQL Server. You can create, change, and delete publishing and subscribing servers in the TencentDB for SQL Server console for data replication and sync in your business.
What are the prerequisites for using the publish/subscribe feature of TencentDB for SQL Server?
This feature is available only when both the publishing and subscribing instances are TencentDB for SQL Server instances.
Only TencentDB for SQL Server dual-node (formerly HA Edition/Cluster Edition) instances are supported.
The publishing and subscribing instances must be on the same edition, such as 2017 Enterprise Edition.
The publishing and subscribing instances must be in the same region (but they can be in different AZs). For example, if the publishing instance is in Beijing Zone 5, the subscribing instance can be in Beijing Zone 7.
A read-only instance cannot be used as a publishing or subscribing server.
If the publishing and subscribing instances have a database with the same name, the database cannot be subscribed to.
Data tables without a primary key cannot be subscribed to. You can use the following code to check whether the database to be published contains this type of tables:
use dbname select name from sys.sysobjects where xtype='U' and id not in(select parent_obj from sys.sysobjects where xtype='PK') After a publish/subscribe linkage is created, if a database in the linkage is deleted, the linkage will also be deleted.
If either the publishing or subscribing instance is terminated, the publish/subscribe linkage will also be deleted.
You can configure up to 80 databases to be published/subscribed to in each publish/subscribe task.
How do I create a publish/subscribe task in TencentDB for SQL Server?
Log in to the SQL Server console, click the ID of the target instance in the instance list to enter the instance management page, select the Publish/Subscribe tab, and click Create to create a publish/subscribe task.
How do I delete the publish/subscribe relationship between two TencentDB for SQL Server instances?
Log in to the TencentDB for SQL Server console, click the ID of the target instance in the instance list to enter the instance management page, select the Publish/Subscribe tab, select the task to be deleted, and click Delete. You can also batch delete multiple tasks.
Previous Topic: Data Migration Next Topic: Read-Only Instance Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Does TencentDB for SQL Server support publish/subscribe?
Does a TencentDB for SQL Server single-node (formerly Basic Edition) instance support publish/subscribe?
Does the TencentDB for SQL Server multi-node support publish/subscription?
How do I implement publish/subscribe between a self-built SQL Server database in my local IDC and a TencentDB for SQL Server instance?
What are the use cases of the publish/subscribe feature of TencentDB for SQL Server?
What are the prerequisites for using the publish/subscribe feature of TencentDB for SQL Server?
How do I create a publish/subscribe task in TencentDB for SQL Server?
How do I delete the publish/subscribe relationship between two TencentDB for SQL Server instances?
Search AllCurrent Product Search titles only Enter keywords to search documentation
