# Renaming Instance

> 来源: https://www.tencentcloud.com/document/product/238/46508

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Renaming Instance Setting Instance Remarks Setting Instance Tag Setting Instance Project Modifying Instance-Level Character Set Collation Modify System Time Zone Setting Instance Maintenance Information Multi-AZ Disaster Recovery Restarting Instance Instance termination Migrating Across AZs Setting the Transmission Method Manual Primary-Secondary Switching Recycle Bin Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Maintaining Instance Renaming Instance Renaming Instance Download Focus Mode Font Size Last updated: 2025-09-04 11:25:32 AI-Translated TencentDB for SQL Server instances are differentiated by name, which can be renamed in the console.
This document describes how to rename an instance in the console.
Instance ID/name description Both primary and read-only instances can be renamed.
An instance name can contain up to 60 Chinese characters, letters, digits, or underscores.
An instance ID supports quick copy.

﻿ ﻿ Renaming an instance in the instance list
1.
Log in to the TencentDB for SQL Server console.
2.
Select the region at the top, find the target instance, and click ﻿ after Instance Name.

﻿ ﻿
3.
In the pop-up window, enter a new name and click OK.
Renaming an instance on the instance details page
1.
Log in to the TencentDB for SQL Server console.
2.
Select the region at the top, find the target instance, and click the target instance ID or Manage in the Operation column to enter the instance management page.
3.
On the Instance Details page of the instance management page, hover the mouse over the corresponding instance name in the Instance Info on the right and then click ﻿ .
﻿
4.
In the pop-up window, enter a new name and click OK.
Related APIs API

Description

﻿ModifyDBInstanceName﻿

This API is used to rename an instance.
Previous Topic: Usage Specifications and Suggestions Next Topic: Setting Instance Remarks Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance ID/name description Renaming an instance in the instance list Renaming an instance on the instance details page Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
