# Parameter Modification

> 来源: https://www.tencentcloud.com/document/product/238/19129

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Parameter Modification Parameter Modification Download Focus Mode Font Size Last updated: 2025-05-30 10:13:42 AI-Translated How do I modify the time zone in TencentDB for SQL Server?
The method for modifying the system time zone in TencentDB for SQL Server for different instance architectures is shown below.
For an introduction to the system time zone and the detailed modification method, see Modifying the System Timezone.
Dual-node local disk instance:
Since modifying the system time zone requires a separate configuration of machine resources, if modification is needed, submit a ticket before purchasing to obtain a solution and specify the system time zone to be adjusted. Modification is supported only when you purchase instances with the specification of 90-core 720 GB. If you need to modify the system time zone, it is recommended to directly purchase cloud disk dual-node instances, which can be directly modified on the purchase page without specification limits.
Single-node cloud disk/dual-node cloud disk/multi-node cloud disk instance:
When purchasing instances with a single-node cloud disk/dual-node cloud disk/multi-node cloud disk architecture, you can directly modify the system time zone on the purchase page.
Note:
For instances with adjusted system time zones, the actual data stored in the backend is the modified UTC time. After conversion, the time for backup and rollback, slow log file, and monitoring displayed in the console frontend is UTC+8.
For instances with adjusted system time zones, if subsequent scale-out involves data migration, submit a ticket to obtain a solution.
How do I modify a character set collation in TencentDB for SQL Server?
TencentDB for SQL Server provides character set collations at instance and database levels.
The character set collation at the instance dimension is Chinese_PRC_CI_AS by default. If modification is needed, you should submit a ticket before purchasing to obtain a solution and specify the target character set to be adjusted. For details about the character set, see Modifying the Instance-Level Character Set Collation.
Dual-node local disk instance:
Since modifying the instance-level collation requires a separate configuration of machine resources, if modification is needed, submit a ticket before purchasing to obtain a solution and specify the target character set to be adjusted.
For instances with adjusted character set collations, if subsequent scale-out involves data migration, submit a ticket to obtain a solution.
Single-node cloud disk/dual-node cloud disk/multi-node cloud disk instance:
You can directly modify the instance-level character set collation on the purchase page.
The character set collation for databases can be specified during database creation. For more information, see Creating Database. If it is not specified, Chinese_PRC_CI_AS will be used by default.
How do I modify the configuration parameters of TencentDB for SQL Server?
Log in to the TencentDB for SQL Server console, click the ID of the target instance in the instance list, select Parameter Configuration > Parameter Settings, and modify instance parameters. For more information, see Setting Instance Parameters.
Which parameters can I modify quickly in the TencentDB for SQL Server console?
Log in to the TencentDB for SQL Server console, click the ID of the target instance in the instance list, select Parameter Configuration > Parameter Settings, and you can modify the following instance parameters:
fill factor(%) max worker threads cost threshold for parallelism max degree of parallelism optimize for ad hoc workloads min server memory (MB) blocked process threshold (s) How do I view parameter modification logs in TencentDB for SQL Server?
Log in to the TencentDB for SQL Server console, click the ID of the target instance in the instance list, select Parameter Configuration > Modification Log, and view parameter modification logs. For more information, see Viewing Parameter Modification Log.
Previous Topic: Log-Related Next Topic: Features Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How do I modify the time zone in TencentDB for SQL Server?
How do I modify a character set collation in TencentDB for SQL Server?
How do I modify the configuration parameters of TencentDB for SQL Server?
Which parameters can I modify quickly in the TencentDB for SQL Server console?
How do I view parameter modification logs in TencentDB for SQL Server?
Search AllCurrent Product Search titles only Enter keywords to search documentation
