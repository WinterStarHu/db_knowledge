# Constraints and Limits

> 来源: https://www.tencentcloud.com/document/product/238/2021

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Constraints and Limits Constraints and Limits Download Focus Mode Font Size Last updated: 2026-07-30 17:20:56 AI-Translated TencentDB for SQL Server provides only license-included instances. This means that after an instance is created, it is licensed for the corresponding version of Microsoft SQL Server software. Bring-your-own-license (BYOL) is not supported.
To ensure instance stability and security, TencentDB for SQL Server imposes certain usage constraints. For details, see the table below.
TencentDB for SQL Server instances are available in three editions: single-node (formerly Basic Edition), two-node (formerly HA/Cluster Edition), and multi-node. Each edition has different features. For details, see Features and Differences.
Note:
TencentDB for SQL Server does not support accessing external applications from a database instance. Database instances can only be accessed by external applications.
If you have other usage restriction questions, you can submit a ticket for consultation.
Instance Feature Limitations Feature

Single-Node (Formerly Basic Edition)

Two-Node (Formerly HA/Cluster Edition)

Multi-Node

Database Version

2008 R2 Enterprise 2012 Enterprise 2014 Enterprise 2016 Enterprise 2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise

2008 R2 Enterprise 2012 Enterprise 2014 Enterprise 2016 Enterprise 2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise

2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise

Maximum number of databases (subject to the number of instance CPU cores)

400

2008 R2 version: 300 2012, 2014, and 2016 versions: 300 2017, 2019, 2022, and 2025 versions: 100

100

Maximum number of database accounts

No limit

No limit

No limit

Database creation

Supported.

Supported.

Supported.

User/Login account creation and deletion

Supported.

Supported.

Supported.

SA account creation

Supported (requires submitting a ticket to apply for creating an account with SA permissions)

Not supported

Not supported

Database authorization

Supported.

Supported.

Supported.

Database-level DDL trigger

Supported.

Supported.

Supported.

Thread killing permission

Supported.

Supported.

Supported.

SQL profiler

Supported.

Supported.

Supported.

Publishing/subscription

Not supported

Supported.

Not supported

Optimization advisor

Supported.

Not supported

Not supported

Link server

For details, see Link server limitations

Not supported

Distributed Transaction

Not supported

Not supported

Not supported

Change data capture (CDC)

Supported.

Supported.

Supported.

Change tracking (CT)

Supported.

Supported.

Supported.

Windows domain account login

Not supported

Not supported

Not supported

Email

Not supported

Not supported

Not supported

SQL Server Integration Services (SSIS)

Supported.

Supported.

Not supported

SQL Server Analysis Services (SSAS)

Not supported

Not supported

Not supported

SQL Server Reporting Services (SSRS)

Not supported

Not supported

Not supported

R language service

Not supported

Not supported

Not supported

Common Language Runtime (CLR) integration

Not supported

Not supported

Not supported

Async messaging

Not supported

Not supported

Not supported

Policy management

Not supported

Not supported

Not supported Number of databases Note:
To ensure instance stability, do not increase the database limit when the instance has only 1 CPU core. Keep the limit at 70.
The maximum number of databases you can create for an instance of any specification depends on the value of the `max worker threads` parameter. If this parameter uses the default value of 0, the maximum number of databases is 80 for instances of any edition and specification. If you set this parameter to a value greater than or equal to 20000, the maximum number of databases depends on the number of CPU cores of the instance. You can refer to the calculation formula below. For how to set the parameter, see Setting Instance Parameters.
The SQL Server 2008 R2 Enterprise edition does not support increasing the database limit. Its maximum number of databases is 70. For other SQL Server instances, the maximum number of databases is limited by the number of CPU cores. The detailed calculation formula is as follows:
Multi-node 2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise The maximum number of databases is related to the instance CPUs. For instances with 4 or fewer CPU cores, the maximum number of databases is 80. For instances with 8 or more CPU cores, the maximum number of databases is 100.
Two-node (formerly HA/Cluster Edition) 2012 Standard/Enterprise 2014 Standard/Enterprise 2016 Standard/Enterprise Maximum number of databases:

﻿

The maximum number of databases is the smaller value between X and 300, where X is calculated as follows: take the square root of the number of CPU cores, round the result to one decimal place, multiply by 40, and then add 80. For example, an SQL Server 2014 Enterprise instance (4 cores, 16 GB) supports a maximum of 160 databases.
Two-node (formerly Cluster Edition) 2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise The maximum number of databases is related to the instance CPUs. For instances with fewer than 8 CPU cores, the maximum number of databases is 80. For instances with 8 or more CPU cores, the maximum number of databases is 100.
Single-node (formerly Basic Edition) 2008 R2 Enterprise 2012 Enterprise 2014 Enterprise 2016 Enterprise 2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise Maximum number of databases:
﻿ ﻿

The maximum number of databases is the minimum value between N and 400, where N is calculated as follows: take the square root of the number of CPU cores, round down the result, and then multiply by 100. For example, an SQL Server 2017 Enterprise instance (4 cores, 16 GB) supports a maximum of 200 databases.
Maximum Number of Databases by Instance CPU Cores and Edition Maximum Number of Databases for Single-node (formerly Basic Edition) Maximum Number of Databases for Dual-node (formerly HA Edition/Cluster Edition) Maximum number of databases in multi-node edition Number of CPU Cores

Single-Node Windows Server 2008 R2 Enterprise Edition

Single-Node Windows Server 2012/2014/2016/2017/2019/2022/2025 Enterprise Edition

2

80

100

4

80

200

8

80

200

12

80

300

16

80

400

24

80

400

32

80

400

48

80

400

64

80

400 Link server Limitations Link server is not supported between other clouds/self-built environments and Tencent Cloud. It is supported only within the Tencent Cloud private network. However, the following restrictions apply to TencentDB for SQL Server instance architectures:
1.
Cross-Architecture Scenarios Cross-Architecture Direction

Description

Changing from a two-node instance to a single-node instance

Not supported.

Changing from a single-node instance to a dual-node instance

Not supported.

Changing from a local disk instance to a cloud disk instance

Not supported.

Changing from a cloud disk instance to a local disk instance

Not supported.
2.
Between Two-Node Instances Cross-Architecture Direction

Description

Two-node local disk instance → Two-node local disk instance

Regions within the Chinese mainland can communicate with each other, regions outside the Chinese mainland can communicate with each other, but regions within the Chinese mainland and regions outside the Chinese mainland cannot communicate with each other.

Two-node cloud disk instance → Two-node cloud disk instance

Communication is supported only within the same region.
3.
Between Single-Node Instances It is supported only when the source and target are the same instance.
Previous Topic: Authorizing Sub-User to Use Database Audit Next Topic: Usage Specifications and Suggestions Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance Feature Limitations Number of databases Link server Limitations Search AllCurrent Product Search titles only Enter keywords to search documentation
