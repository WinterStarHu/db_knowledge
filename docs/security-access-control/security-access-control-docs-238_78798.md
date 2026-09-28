# Disabling Audit Service

> 来源: https://www.tencentcloud.com/document/product/238/78798

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Database Audit Disabling Audit Service Disabling Audit Service Download Focus Mode Font Size Last updated: 2026-04-21 15:06:49 AI-Translated This article describes how to disable the audit service via the console.
Note:
After the audit service is disabled, it will stop auditing instances and historical audit logs will be purged.
Prerequisites Audit Service Enabled.
Operation Steps
1.
Log in to the Tencent for SQL Server console.
2.
In the left sidebar, select Database Audit.
3.
After the Region above is selected, on the Audit Instance page, click Audit Log Stroage Status and select the Enabled option to filter out instances with audit enabled.
4.
In the Audit Instance list, locate the target instance (you can also quickly find it by filtering through resource attributes in the search box), then in its Operation column, choose More > Disable Database Audit.
﻿ Note:
Supports batch disabling of the audit service. On the audit instances list page, select multiple target instances, then click the above Disable Database Audit.
5.
In the Disable Database Audit window, after confirming everything is correct, click OK.
Previous Topic: Modifying Audit Services Next Topic: Authorizing Sub-User to Use Database Audit Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Operation Steps Search AllCurrent Product Search titles only Enter keywords to search documentation
