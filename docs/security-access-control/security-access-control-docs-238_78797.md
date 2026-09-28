# Modifying Audit Services

> 来源: https://www.tencentcloud.com/document/product/238/78797

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Database Audit Modifying Audit Services Modifying Audit Services Download Focus Mode Font Size Last updated: 2026-04-21 15:06:49 AI-Translated This document describes how to modify the Audit Service through the console.
Note:
If you choose to extend the log retention period, the change will take effect immediately. If you choose to shorten the log retention period, logs that have exceeded the retention period will be purged immediately.
If you set the recent n days of data to be stored in high-frequency storage, data beyond the recent n days will be automatically moved to low-frequency storage. After the high-frequency storage period is extended, audit data meeting the retention period will be automatically migrated from low-frequency storage to high-frequency storage.
Prerequisites Audit Service Enabled.
Modify Audit Service for a Single Instance
1.
Log in to the TencentDB for SQL Server console.
2.
In the left sidebar, select Database Audit.
3.
Select a region at the top. On the Audit Instance page, click Audit Log Storage Status and select the Enabled option to filter for instances with the audit service enabled.
4.
Locate the target instance in the Audit Instance list (or quickly find it by filtering with resource attributes in the search box), and in its Operation column, choose More > Modify Audit Service.
﻿
5.
On the Modify Audit Service page, after the Log Retention Period or Frequent Access Storage Period are modified, click OK.
﻿ Batch modify the audit service
1.
Log in to the TencentDB for SQL Server console.
2.
In the left sidebar, select Database Audit.
3.
Select a region at the top. On the Audit Instance page, click Audit Log Storage Status and select the Enabled option to filter for instances with the audit service enabled.
4.
Locate the target instance in the Audit Instance list (or quickly find it by filtering with resource attributes in the search box). On the Audit Instance list page, select multiple target instances and click Modify Audit Service at the top.
5.
On the Modify Audit Service page, after modifying the Log Retention Period or Frequent Access Storage Period, click OK.
Note:
For easy comparison, the batch modification audit service page displays the log retention period before and after modification. After the modification is performed, the selected instances will uniformly start adjusting according to the new log retention period. Please confirm that everything is correct before proceeding with the modification.
Previous Topic: Log Shipping Next Topic: Disabling Audit Service Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Modify Audit Service for a Single Instance Batch modify the audit service Search AllCurrent Product Search titles only Enter keywords to search documentation
