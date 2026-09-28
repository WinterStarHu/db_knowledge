# Local Backup Space Billing

> 来源: https://www.tencentcloud.com/document/product/238/45849

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Purchase Guide Local Backup Space Billing Local Backup Space Billing Download Focus Mode Font Size Last updated: 2026-03-20 15:55:12 AI-Translated Overview Backup space is used to store the backup files of all TencentDB for SQL Server instances in a region, including automatic data backups, manual data backups, and log backups.
Backup space range The backup space refers to a resource pool used by an account to store backup files of all TencentDB for SQL Server instances with an architecture of single-node (formerly Basic Edition), two-node (formerly HA/Cluster Edition), and multi-node in a certain region. The backup space is calculated by region separately for each account. For example, backup files of all TencentDB for SQL Server instances in the Beijing region are stored in one resource pool, and backup files of all TencentDB for SQL Server instances in the Shanghai region are stored in another resource pool.
Total size of backup files Total size of backup files (a single region) = volume of data that has been backed up automatically and manually (same region) + volume of logs that have been backed up (same region).
Free backup space TencentDB for SQL Server provides you with a free tier of backup space for each region. The free backup space size equals the sum of the storage space of all your primary single-node (formerly Basic Edition), two-node (formerly HA/Cluster Edition), and multi-node instances in the region. For the calculation example, see Backup Space Calculation Formula.
Note:
Free backup space is only available when you purchase a primary instance.
The backup space can be viewed on the database backup page in the TencentDB for SQL Server console.
Backup Pricing Backups beyond the free tier (100% disk storage) are pay-as-you-go by region at 0.0001261 USD/GB/hour in the Chinese mainland and 0.0001418 USD/GB/hour outside the Chinese mainland.
Note:
Billable space of less than 1 GB is not billed, and a billable time period of less than one hour is counted as one hour.
Billing Schedule for Backup Space Billing will officially start at 00:00 on July 10, 2022 for backups beyond the free tier.
Backup Space Calculation Formula Free backup space (a single region) = sum of 100% disk space (billable space) of all purchased TencentDB for SQL Server instances in this region.
Billable backup space (a single region) = volume of data that has been backed up automatically and manually (same region) + volume of logs that have been backed up (same region) - free backup space (same region).
Note:
Backup fees are subject to the backup size but not the storage space usage, as backups do not occupy the storage space.
When analyzing the backup fees, you need to check the backup size rather than the storage space usage.
The backups of isolated instances will also be counted into the backup space.
Calculation example If you have a running TencentDB for SQL Server Cluster Edition instance with a purchased database storage space of 500 GB/month in Beijing Zone 5 and another such instance with 200 GB/month in Beijing Zone 3, you will get a free backup space of 700 GB/month in the Beijing region.
If your data backups reach 800 GB and log backups reach 100 GB in the current hour, your total backup space used in the Beijing region will exceed 700 GB, and you will be billed for the excess of 200 GB (800 + 100 - 700 = 200) for the current hour and so on.
Backup Lifecycle The backups of a running or isolated instance will be billed until it is deactivated.
Yearly/Monthly Subscription Instances Backups will evolve in accordance with the lifecycle of the instance.
Within 7 days after the instance expires, the backup function will operate normally. During this period, backups that exceed the complimentary backup space will still incur charges.
After 7 days after the instance expires, starting from the 8th day after the instance expires, the instance will be isolated and moved to the recycle bin. At this time, rollback and manual backups will be prohibited, while automatic backups will continue. Backup downloads are still permitted (Users can go to the instance list in the console, under the More operation column > Backup Download, and then download on the backup download page). Users may renew their subscription in the console's recycle bin to restore both the instance and its backups.
7 days after being isolated in the recycle bin, starting from the 15th day after the instance expires, the instance will be officially decommissioned. At this time, the instance will be permanently destroyed, along with all associated data backups. Ensure necessary backups are saved promptly.
Pay-as-you-go instance Backups are subject to change over the instance lifecycle.
The backup feature can be used normally within 24 hours after an instance expires, during which backups beyond the free tier will still be billed.
After 24 hours, the instance will be isolated into the recycle bin. At this point, rollback and manual backup will be prohibited, but automatic backup can still be performed, and you can still download backups (by clicking More > Backup Download in the Operation column of the instance in the console). You can renew the instance in the recycle bin in the console to recover it.
After three days of isolation in the recycle bin (i.e., on the fifth day after expiration), the instance will be deactivated and terminated, along with all data backups. Therefore, you need to save the required backup files promptly.
Payment Overdue Yearly/Monthly Subscription Instances If the instance has not yet expired but the account falls into arrears, backup-related services will be downgraded. Rollbacks, manual backups, and backup downloads will be prohibited. During this period, automatic backups will continue, and backups that exceed the complimentary backup space will still incur charges.
To perform services such as rollbacks, manual backups, and backup downloads, top up your account to a positive balance.
Pay-as-you-go instance After your account has overdue payments, the backup will change with the lifecycle of the instance. For more information, see the backup lifecycle of pay-as-you-go instances.
Upgraded Services Available After Backup Billing Starts Improvement

Before Upgrade

After Upgrade

Data backup retention period

Seven days by default.

Customizable between 3 and 1,830 days.

Data backup cycle

Once every 24 hours by default.

It is once every 24 hours by default if the data backup retention period is less than seven days. It is customizable if the data backup retention period is greater than or equal to seven days; however, to ensure the backup continuity, you need to set two or more backups every week.

Log backup

Log backups cannot be viewed or downloaded.

Log backups can be viewed and downloaded. The log backup retention period is the same as the configured data backup retention period, and the log backup frequency is once every 30 minutes.

All-instance-level backup statistics overview

Not supported.

It is supported and makes it easier for you to view the backup space statistics and trends of all instances in each region under your account, free tier usages, as well as the real-time backup space statistics of each instance, including:
Total backups: Displays the statistics and overview of all backups, data backups, and log backups.
Real-time backup statistics: Displays the real-time size statistics of the backup space of each instance in each dimension.

Isolated instance

Backups cannot be viewed or downloaded.

Backups can be viewed and downloaded.

Single-database backup optimization

/

Databases can be searched for by name.
Single-database backups can be sorted by size in ascending or descending order.
The size of single-database backup files can be displayed in an aggregated manner.

Backup list optimization

/

Backups can be filtered and viewed by time period, including all, today, last 7 days, last 15 days, last 30 days, and custom time period.
Backups can be displayed as and searched for by files.
Suggestions for Reducing Backup Costs Delete manual backups that are no longer used (on the Instance Management > Backup Management page in the TencentDB for SQL Server console).
Reduce the frequency of automatic data backup for non-core businesses (you can adjust the backup cycle and backup file retention period in the console, which should be at least twice a week).
Note:
The rollback feature relies on the backup cycle and retention period of data backups and log backups, but reducing the frequency and retention period of automatic backups will affect the rollback time range for instance data, you need to configure backup appropriately based on your actual needs.
Shorten the retention period of data and log backups for non-core businesses (a retention period of 7 days can meet the needs in most cases) Business Scenario

Recommended Backup Retention Period

Core businesses

7–1,830 days

Non-core, non-data businesses

Seven days

Archival businesses

Seven days. We recommend you manually back up data based on your actual business needs and delete the backups promptly after use

Testing businesses

Seven days. We recommend you manually back up data based on your actual business needs and delete the backups promptly after use References ﻿Configuring Automatic Backup﻿ ﻿Viewing Backup Space﻿ Previous Topic: Instance Adjustment Fees Description Next Topic: Cross-Region Backup Billing Description Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Backup Pricing Billing Schedule for Backup Space Backup Space Calculation Formula Backup Lifecycle Payment Overdue Upgraded Services Available After Backup Billing Starts Suggestions for Reducing Backup Costs References Search AllCurrent Product Search titles only Enter keywords to search documentation
