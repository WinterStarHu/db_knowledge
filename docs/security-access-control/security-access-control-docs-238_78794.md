# Viewing Audit Instance List

> 来源: https://www.tencentcloud.com/document/product/238/78794

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Database Audit Viewing Audit Instance List Viewing Audit Instance List Download Focus Mode Font Size Last updated: 2026-04-21 15:06:48 AI-Translated This article introduces how to view the Database Audit instance list, and on the Database Audit instance list page, the field information you can view and the relevant operations you can perform.
Database Audit Instance List Page Display ﻿ View Database Audit instance list
1.
Log in to the TencentDB for SQL Server console.
2.
Click Database Audit in the left sidebar.
3.
The redirect page defaults to Database Audit > Audit Instance.
4.
On the audit instances page, you can: view the tool list (quickly filter instances, refresh the audit instances page, download audit instance list information), view related feature operations, and view instance list field information.
Tool List Tool

Description

Filter

You can select resource attributes (Instance ID, Instance Name, Tag Key, Tag) in the search box above the audit instances list to filter, with multiple keywords separated by vertical bars and multiple filter tags separated by pressing Enter.

Refreshing

Click ﻿ to refresh the audit instance list data.

Download

Click ﻿ to download the filtered audit instance list information locally in ".csv" format.
Related Feature Operations Audit Status

Feature

Description

Audit service is enabled

Disable Database Audit

You can perform the operation to disable the audit service, and batch disable is supported. For details, see Disabling Audit Service.

Modifying Audit Service

You can modify the audit service settings (audit retention period, high-frequency and low-frequency storage duration), and batch modification is supported. For details, see Modifying Audit Service.

View Audit Log

You can query historical audit log records. For details, see Viewing Audit Log.

Audit service is not enabled

Enable Database Audit

You can perform the operation to enable the audit service, and batch enablement is supported. For details, see Enabling the Audit Service.
Audited Instances List Field Information Field

Description

Instance ID / Name

Displays the instance ID/name information for all instances in a specific region.

Audit Log Storage Status

Displays the status of audit log storage (enabled or disabled). You can filter and display instances in the corresponding status by selecting the enabled or disabled options above the list.

Audit Mode

Displays the currently configured audit rule for the corresponding instance when the audit service is enabled: Full Auditing.

Log Retention Period

Displays the total storage duration (days), high-frequency storage duration (days), and low-frequency storage duration (days) for the corresponding instance when the audit service is enabled.

Stored Log Size

Displays the total storage volume (MB), high-frequency storage volume (MB), and low-frequency storage volume (MB) for the corresponding instance when the audit service is enabled.

Log Shipping

Displays the log shipping status of instances.

Project

Displays the associated project of the corresponding instance, allowing effortless resource categorization and management. Supports filtering instances in the desired projects by selecting from the dropdown.

Tag (key: value)

Displays the tag information of the instance.

Enablement Time

Displays the time when the audit service is enabled for the corresponding instance, accurate to the second.

Operation

Enabled audit service operation items:
View Audit Log.
More (Modify Audit Service, Disable Audit Service).
Operation items with audit service not enabled:
Enable Database Audit.
Previous Topic: Overview Next Topic: Enabling Audit Service Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Database Audit Instance List Page Display View Database Audit instance list Search AllCurrent Product Search titles only Enter keywords to search documentation
