# Single-Node (Formerly Basic Edition)

> 来源: https://www.tencentcloud.com/document/product/238/53976

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Single-Node (Formerly Basic Edition) Two-Node (Formerly High Availability and Cluster Edition) Multi-Node Differences Between Local Disk Architecture and Cloud Disk Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Product Introduction Product Architecture Single-Node (Formerly Basic Edition) Single-Node (Formerly Basic Edition) Download Focus Mode Font Size Last updated: 2026-07-31 15:31:34 AI-Translated TencentDB for SQL Server supports three deployment architectures: single-node, two-node, and multi-node. This document introduces the single-node architecture.
Supported Versions SQL Server 2012,2014,2016,2017,2019,2022,2025 Enterprise.
Architecture The architecture of a single-node primary instance displayed in the console is shown in the following figure.
﻿ The single-node architecture uses a single-node deployment and has a relatively low usage cost. Its features are as follows:
It features a decoupled compute and storage architecture. If a compute node fails, you can quickly recover by replacing the node. The underlying data is stored on cloud disks using a triple-replica mechanism, which helps improve data reliability. In case of a disk failure, you can quickly recover using the disk snapshot mode.
The single-node architecture provides over 20 multi-dimensional monitoring metrics for database connections, access, resources, and more. Corresponding alarm policies can be configured. Compared with self-built databases on CVMs, it reduces Ops management tasks for database connections, access, and resources. It also offers a price advantage, saving cost expenditures compared to self-built databases on CVMs.
The underlying storage medium of the single-node architecture uses high-performance cloud disks. It is suitable for 90% of I/O scenarios, offering high quality, low cost, and stable performance.
Note:
The single-node architecture is suitable for personal learning, ISV software for small and medium-sized enterprises (such as finance, CRM, and ERP software), Web applications, non-core small systems of enterprises, and testing environments.
Because the single-node architecture has only one node, the recovery time after a node failure is slightly longer than that for a CVM failure (involving instance startup and data recovery).
For services that require high availability, we recommend using the two-node architecture (formerly HA Edition and Cluster Edition).
﻿ AZs Supported by the Single-Node Architecture China Asia Pacific Europe and Americas Middle East Region

AZ

Single-Node Cluster Edition

Read-only Cluster Edition

Read-only (Local Disk)

Guangzhou ap-guangzhou

Guangzhou Zone 3 ap-guangzhou-3

✓

×

✓

Guangzhou Zone 6 ap-guangzhou-6

✓

✓

×

Guangzhou Zone 7 ap-guangzhou-7

✓

✓

×

Shanghai ap-shanghai

Shanghai Zone 2 ap-shanghai-2

✓

✓

✓

Shanghai Zone 3 ap-shanghai-3

✓

×

✓

Shanghai Zone 4 ap-shanghai-4

✓

✓

✓

Shanghai Zone 5 ap-shanghai-4

✓

✓

×

Shanghai Finance ap-shanghai-fsi

Shanghai Finance Zone 3 ap-shanghai-fsi-3

✓

✓

×

Shanghai Finance Zone 4 ap-shanghai-fsi-4

✓

✓

×

Nanjing ap-nanjing

Nanjing Zone 1 ap-nanjing-1

✓

✓

✓

Nanjing Zone 2 ap-nanjing-2

✓

✓

✓

Beijing ap-beijing

Beijing Zone 1 ap-beijing-1

×

×

✓

Beijing Zone 3 ap-beijing-3

✓

✓

✓

Beijing Zone 4 ap-beijing-4

✓

×

×

Beijing Zone 5 ap-beijing-5

✓

×

✓

Beijing Zone 6 ap-beijing-6

✓

✓

×

Beijing Zone 7 ap-beijing-7

✓

✓

×

Beijing Finance ap-beijing-fsi

Beijing Finance Zone 1 ap-beijing-fsi-1

✓

✓

×

Beijing Finance Zone 2 ap-beijing-fsi-2

✓

✓

×

Chengdu ap-chengdu

Chengdu Zone 1 ap-chengdu-1

✓

✓

×

Chengdu Zone 2 ap-chengdu-2

✓

✓

×

Chongqing ap-chongqing

Chongqing Zone 1 ap-chongqing-1

✓

✓

×

Hong Kong (China) ap-hongkong

Hong Kong (China) Zone 1 ap-hongkong-1

×

×

✓

Hong Kong (China) Zone 2 ap-hongkong-2

✓

✓

✓

Hong Kong (China) Zone 3 ap-hongkong-3

×

✓

× Previous Topic: Product Overview Next Topic: Two-Node (Formerly High Availability and Cluster Edition) Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Supported Versions Architecture AZs Supported by the Single-Node Architecture Search AllCurrent Product Search titles only Enter keywords to search documentation
