# Enabling Audit Service

> 来源: https://www.tencentcloud.com/document/product/238/78795

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Database Audit Enabling Audit Service Enabling Audit Service Download Focus Mode Font Size Last updated: 2026-07-30 17:20:56 AI-Translated This document describes how to enable Database Audit for TencentDB for SQL Server instances.
Prerequisites A SQL Server instance is created.
Supported Versions and Architecture Database Audit currently supports the following database editions: 2012, 2014, 2016, 2017, 2019, 2022, and 2025 Enterprise.
Database Audit currently supports the following instance architectures: Dual-node (local disk), Read-Only instances (local disk), Single-node (cloud disk), Dual-node (cloud disk), Multi-node (cloud disk), and Read-Only instances (cloud disk).
Performance Impact Notes Kind reminder: After Database Audit is enabled for TencentDB for SQL Server instances, the CPU overhead is approximately 5%.
Operation Steps
1.
Log in to the TencentDB for SQL Server console.
2.
In the left sidebar, select Database Audit.
3.
After selecting a region above, on the Audit Instance page, click Audit Log Storage Status and select the Disabled option to filter out instances with audit not enabled.
﻿
4.
Locate the target instance in the audit instance list (or quickly find it by filtering with resource attributes in the search box), in its Operation column, click Enable Database Audit.
Note:
Batch enabling of audit services is supported. On the audit instance list page, select multiple target instances and click Enable Database Audit at the top to go to the setup page.
5.
On the Enable Audit Service page, complete the audit instance selection, configure the audit service settings, read and select the Tencent Cloud Service Agreement, and click OK.
5.1
Select Audit Instance Under the audit instance selection section, the system automatically selects the instances chosen in Step 4 by default. You can also modify target instances in this window (select other instances or multiple instances), or quickly locate target instances by searching with Instance ID/Name in the search box. After completing instance selection, go to the audit rule setup.
﻿
5.2
﻿Configure Audit﻿ In the audit service settings, you need to configure the log retention period and the duration for high-frequency and low-frequency storage, read and select the Tencent Cloud Service Agreement, and then click OK to enable the audit service.
﻿ Parameter

Description

Log Retention Period

Set the retention period for audit logs, unit: days. Supported options include 7, 30, 90, 180, 365, 1095, and 1825 days.

Frequent Access Storage Period

Frequent Access Storage represents ultra-high-performance storage media with excellent query performance. Unit: days. After the storage duration is set, audit data within the specified duration will be stored in Frequent Access Storage. Data exceeding the Frequent Access Storage duration will automatically transition to Infrequent Access Storage. Both storage types support identical audit capabilities and differ only in performance. For example: if the log retention period is set to 30 days and the Frequent Access Storage duration is set to 7 days, then the Infrequent Access Storage duration defaults to 23 days.
Previous Topic: Viewing Audit Instance List Next Topic: Viewing Audit Log Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Supported Versions and Architecture Performance Impact Notes Operation Steps Search AllCurrent Product Search titles only Enter keywords to search documentation
