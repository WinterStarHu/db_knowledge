# Enabling and Disabling the CDC Feature

> 来源: https://www.tencentcloud.com/document/product/238/72322

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial Enabling and Disabling the CDC Feature Enabling and Disabling the CDC Feature Download Focus Mode Font Size Last updated: 2025-08-06 16:12:42 AI-Translated Change data capture (CDC) is a native SQL Server feature that tracks data changes (insertion, update, and deletion). Currently, the TencentDB for SQL Server console has supported enabling and disabling the feature, but only at the database level. To enable table-level CDC, you can connect to the instance through SSMS and execute related commands after enabling database-level CDC in the console.
This document introduces operation practices for enabling and disabling the database-level and table-level CDC feature.
Enabling or Disabling the Database-Level CDC Feature
1.
Log in to the TencentDB for SQL Server console and click Instance ID or Manage in the Operation column in the instance list to enter the instance management page.
2.
On the instance management page, select the Database Management tab, locate the row where the target database is located, and select Others > Enable/Disable CDC in the Operation column.
﻿
3.
In the pop-up dialog box, select enable or close and then click OK.
﻿ Enabling or Disabling the Table-Level CDC Feature Note:
After the table-level CDC is enabled, it may generate a large volume of data occupying space.
During the operation of the table-level CDC, using Data Definition Language (DDL) to add or delete fields may lead to CDC exceptions.
CDC and publish-subscribe use the same logreader process, which may conflict.
Step 1: Enabling the Database-Level CDC Feature For detailed operations, see Enabling the Database-Level CDC Feature.
Step 2: Connecting to the SQL Server Instance Through SSMS For detailed operations, see the connection methods in Connecting to TencentDB for SQL Server Instance from Windows CVM Instance or Connecting to TencentDB for SQL Server Instance from Local System.
Step 3: Enabling or Disabling the Table-Level CDC Feature Through Commands Note:
When the following command is used, replace the variables with actual information:
[databasename]: Replace it with your target database name, for example, [MyDB].
N'table_name': Replace it with the table name for which CDC will be enabled or disabled, for example, N'Orders'.
N'dbo_table_name': Replace it with the actual table name, for example, N'dbo_Orders'.
Example: Enabling CDC for the Table use [databasename] go EXEC sys.sp_cdc_enable_table @source_schema = N'dbo', @source_name   = N'table_name', @role_name     = null, @filegroup_name = N'Primary', @supports_net_changes = 1 Example: Disabling CDC for the Table use [databasename] go EXECUTE sys.sp_cdc_disable_table @source_schema = N'dbo', @source_name   = N'table_name', @capture_instance = N'dbo_table_name';
Previous Topic: Account Permissions and Permission Control Next Topic: Shrinking a Database Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Enabling or Disabling the Database-Level CDC Feature Enabling or Disabling the Table-Level CDC Feature Step 1: Enabling the Database-Level CDC Feature Step 2: Connecting to the SQL Server Instance Through SSMS Step 3: Enabling or Disabling the Table-Level CDC Feature Through Commands Search AllCurrent Product Search titles only Enter keywords to search documentation
