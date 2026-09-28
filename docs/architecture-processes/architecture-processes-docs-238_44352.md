# Overview

> 来源: https://www.tencentcloud.com/document/product/238/44352

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Overview Upgrading the Instance Version Adjusting Instance Specifications Adjusting the Number of Replica Nodes Setting Disk Additional I/O Performance Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Adjusting Instance Configuration Overview Overview Download Focus Mode Font Size Last updated: 2025-10-11 10:33:52 AI-Translated TencentDB for SQL Server supports flexible scaling that allows you to quickly adjust instance architecture, version, and specification in the console. You can do so at any time (at the start, during rapid development, or during peak/off-peak hours), so you can get the most out of your resources and reduce unnecessary costs in real time.
Prerequisites You can adjust the configuration of a TencentDB for SQL Server instance and its associated instances only when they are in running status and are not executing any tasks.
Adjustment item Adjustment Item

Description

Architecture

Single-node (formerly Basic Edition) instances cannot be upgraded to two-node (formerly High Availability/Cluster Edition) instances. If needed, you can purchase new two-node instances and migrate the data with DTS.
The two-node edition (formerly HA/Cluster Edition) does not support upgrading to the multi-node edition. This feature will be supported in the future. You can upgrade in the console when the feature is supported.

Version

Version upgrade is supported for the single-node edition (formerly Basic Edition), two-node edition (formerly HA/Cluster Edition), and multi-node edition.
To upgrade the version of a two-node (formerly High Availability/Cluster Edition) instance associated with a read-only instance, disassociate the read-only instance first before upgrading or submit a ticket for assistance.

Instance specification

All instance types support specification upgrade and downgrade.
The upper limit of disk capacity under the corresponding specification is as displayed on the Adjust Configuration page in the console.

Disk capacity

Single-node (formerly Basic Edition) instances support disk capacity expansion but not reduction.
Two-node (formerly High Availability/Cluster Edition) instances of local disk edition support disk capacity expansion and reduction.
Two-node (formerly High Availability/Cluster Edition) instances of cloud disk edition support disk capacity expansion but not reduction.
The multi-node edition supports expanding the disk capacity but not shrinking the disk capacity.
Note:
If you need to horizontally scale the read capability of your database, use read-only instances to mitigate the pressure on the primary instance as instructed in Managing Read-Only Instance.
Restrictions on upgrade/downgrade Instance Type

Disk Type

Version Upgrade

Architecture Upgrade

Specification Upgrade

Disk Capacity Expansion

Version Downgrade

Architecture Downgrade

Specification Downgrade

Disk Capacity Reduction

Single-node (formerly Basic Edition) instance

Cloud disk

✓

X

✓

✓

X

X

✓

X

Two-node (formerly High Availability/Cluster Edition) instance

Local disk

✓

✓

✓

✓

X

X

✓

✓

Cloud disk

✓

✓

✓

✓

X

X

✓

X

Multi-node

Cloud disk

✓

X

✓

✓

X

X

✓

X

Read-only instance

Local disk

X

X

✓

✓

X

X

✓

✓

Cloud disk

X

X

✓

✓

X

X

✓

X Instance disk space description Single-node (formerly Basic Edition) instance - cloud disk When the size of the data stored in an instance exceeds its storage space, the database will become read-only. We recommend that you check the disk monitoring metrics of the instance in time as instructed in Viewing Monitoring Charts, set the alarm policy for the disk in CM, and expand the storage space or delete tables in the console promptly, so as to prevent the read-only status from affecting your business operations. The instance will become readable/writable after your expand or free up the storage space.
Two-node (formerly High Availability/Cluster Edition) instance - local disk When the size of the data stored in an instance exceeds its storage space, features such as database import and rollback will become unavailable. You will need to expand its capacity or delete some database tables in the console to release the storage space. We recommend that you check the disk monitoring metrics of the instance in time as instructed in Viewing Monitoring Charts and set the alarm policy for the disk in CM, so as to prevent disk overruns from affecting your business operations.
Two-node (formerly High Availability/Cluster Edition) instance - cloud disk When the size of the data stored in an instance exceeds its storage space, the database will become read-only. We recommend that you check the disk monitoring metrics of the instance in time as instructed in Viewing Monitoring Charts, set the alarm policy for the disk in CM, and expand the storage space or delete tables in the console promptly, so as to prevent the read-only status from affecting your business operations. The instance will become readable/writable after your expand or free up the storage space.
Multi-node instance - cloud disk After the volume of data stored in the instance exceeds the storage space purchased for the instance, the instance will become read-only. (Data can only be read but not written.) It is recommended that you view the disk monitoring data of the instance in time through monitoring charts and set an alarm policy for disks on Tencent Cloud Observability Platform (TCOP). If an alarm is triggered, you can scale out the instance or delete some database tables via the console to release storage space to prevent the instance from becoming read-only and ensure normal business operation. Data read/write becomes normal immediately after the instance is scaled out or storage space is released.
Configuration adjustment rules You cannot cancel a configuration adjustment operation in progress.
The name, access IP, and access port of an instance will remain the same after configuration adjustment.
Data migration may be involved in configuration adjustment. During data migration, the TencentDB for SQL Server instance can be accessed normally and the business will not be affected.
Note:
Due to business security and risk control requirements, the system may prompt you to restart the instance to lift the feature limitations when you perform the configuration adjustment operation on instances and data migration is involved. At this point, follow the prompt in the console to complete the instance restart before you perform the configuration adjustment operation.
Instance switchover may be needed after configuration adjustment is completed (i.e., the TencentDB for SQL Server instance may be disconnected for seconds). We recommend that you use applications configured with automatic reconnection feature and conduct the switch during the instance maintenance time. For more information, see Setting Instance Maintenance Information.
Limits Instances of the single-node edition (formerly Basic Edition) have only one database node but no replica node for hot backup. Therefore, instance services become unavailable for a long time if the node goes down or a configuration change or version upgrade task is executed. If the business has relatively high availability requirements for the database, the single-node edition (formerly Basic Edition) is not recommended. You can choose the two-node edition (formerly HA/Cluster Edition) or the multi-node edition.
Billing For more information, see Instance Adjustment Fees Description.
Directions Adjusting Instance Architecture Adjusting Instance Version Adjusting Instance Specification Previous Topic: Recycle Bin Next Topic: Upgrading the Instance Version Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Adjustment item Restrictions on upgrade/downgrade Instance disk space description Configuration adjustment rules Limits Billing Directions Search AllCurrent Product Search titles only Enter keywords to search documentation
