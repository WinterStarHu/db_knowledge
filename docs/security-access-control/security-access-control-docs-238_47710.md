# Disk Space and Specification Adjustment

> 来源: https://www.tencentcloud.com/document/product/238/47710

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Disk Space and Specification Adjustment Disk Space and Specification Adjustment Download Focus Mode Font Size Last updated: 2025-05-30 10:12:37 AI-Translated Which configuration items can I adjust in TencentDB for SQL Server?
TencentDB for SQL Server supports quick adjustment of the instance architecture, version, and specification and allows flexible scaling operations in the console. You can elastically adjust the configurations of SQL Server instances according to your actual business conditions (at the initial stage, at the rapid development stage, during peak hours, or during off-peak hours), so as to better meet your needs such as full utilization of resources and real-time cost optimization. For more information, see Overview.
Can I expand/reduce the disk space of a TencentDB for SQL Server instance?
TencentDB for SQL Server two-node (formerly high-availability/cluster edition) local disk instance: The disk space can be expanded and reduced.
For the dual-node (formerly HA Edition/Cluster Edition) cloud disk instances and multi-node cloud disk instances of TencentDB for SQL Server: The disk can only be scaled out and cannot be scaled in.
TencentDB for SQL Server single-node (formerly basic edition) instance: The disk space can only be expanded.
Can I upgrade/downgrade the CPU/memory specifications of a TencentDB for SQL Server instance?
Yes. For more information, see Adjusting Instance Specification.
Is the service still available when the specification of a TencentDB for SQL Server single-node (formerly basic edition) instance is changed?
When the configuration of a single-node (formerly basic edition) instance is adjusted (CPU/memory specification upgrade/downgrade as well as disk space expansion), the instance will be restarted and remain unavailable for about three minutes. Therefore, perform this operation during off-peak hours.
Will the service be interrupted when the specification of a TencentDB for SQL Server two-node (formerly high-availability/cluster edition) is changed?
During specification upgrade or disk space expansion of a two-node (formerly high-availability edition) instance, if in-place update conditions are met, the service will not experience any momentary disconnections, and the configuration will take effect immediately after the request is submitted without causing any impact on the business. If migration update conditions are met, the configuration will be upgraded by migrating data. The more the data, the longer the migration. During the migration, the instance can still be accessed. After the migration is completed, a switch will occur, causing a momentary database disconnection. Therefore, your business should have a reconnection mechanism. During the disconnection, most database, account, and network operations cannot be performed. Switch during off-peak hours.
During disk space reduction in a two-node (formerly high-availability/cluster edition) instance, the service will not experience any momentary disconnections. The adjustment will take effect immediately after you submit the request. There is no impact on your business.
During specification downgrade in a two-node (formerly high-availability/cluster edition) instance, the instance will be restarted and remain unavailable for about one minute. Therefore, perform this operation during off-peak hours.
For more information on configuration adjustment scenarios and impacts, see Adjusting Instance Specification.
How do I perform disk space expansion/reduction and specification upgrade/downgrade in TencentDB for SQL Server?
Disk space expansion/reduction and specification upgrade/downgrade refer to changing the current TencentDB for SQL Server instance from specification A to specification B. In the TencentDB for SQL Server console, select the target instance and click Adjust Configuration in the Operation column. In the Adjust Configuration pop-up window, select the target specification and time to take effect as needed and make the payment. Then, the system will automatically change the instance specification. For more information, see Adjusting Instance Specification.
How are TencentDB for SQL Server disk space expansion/reduction and specification upgrade/downgrade fees calculated?
For a pay-as-you-go instance:
Upgrade fees: After upgrade, the instance will be billed based on the new instance specifications starting from the next billing cycle.
Downgrade fees: After downgrade, the instance will be billed based on the new instance specifications starting from the next billing cycle.
For more information, see Instance Adjustment Fees Description.
Will the read-only instance configuration be upgraded automatically when the primary instance configuration is upgraded?
Read-only instances can only be upgraded manually.
Previous Topic: Version and Architecture Upgrade Next Topic: Monitoring and Alarms Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Which configuration items can I adjust in TencentDB for SQL Server?
Can I expand/reduce the disk space of a TencentDB for SQL Server instance?
Can I upgrade/downgrade the CPU/memory specifications of a TencentDB for SQL Server instance?
Is the service still available when the specification of a TencentDB for SQL Server single-node (formerly basic edition) instance is changed?
Will the service be interrupted when the specification of a TencentDB for SQL Server two-node (formerly high-availability/cluster edition) is changed?
How do I perform disk space expansion/reduction and specification upgrade/downgrade in TencentDB for SQL Server?
How are TencentDB for SQL Server disk space expansion/reduction and specification upgrade/downgrade fees calculated?
Will the read-only instance configuration be upgraded automatically when the primary instance configuration is upgraded?
Search AllCurrent Product Search titles only Enter keywords to search documentation
