# Backup Overview

> 来源: https://www.tencentcloud.com/document/product/238/77189

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Backup (New Edition) Backup Overview Setting Automatic Backup Creating a Manual Backup Configure Backup Task Cross-region backup Viewing the Backup List Downloading Backup Files Conversion from regular backups to scheduled backups Delete Manual Backup View Backup Overview (Instance Dimension) View Backup Overview (Region Dimension) Backup Rolling back Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Backup and Restoration Backup (New Edition) Backup Overview Backup Overview Download Focus Mode Font Size Last updated: 2026-01-27 16:16:42 AI-Translated The backup feature can help protect your data from accidental loss in case of system hardware or instance failures. To safeguard your interests, TencentDB for SQL Server provides backup and recovery features, facilitating archiving and enabling restoration to local databases.
This document introduces you to the related information about backups.
Note:
If your sub-account only has permissions for part of the backup APIs, you need to re-authorize the sub-account with your root account after the new backup version is switched to. If your sub-account has permissions for all backup APIs, the sub-account does not require re-authorization.
The new backup feature is being gradually released. The platform will proceed in batches grouped by Tencent Cloud account (UIN). Only users included in the gradual release will be able to see the new feature page. If you do not see the new feature page, please wait for the release process to complete. We will work to release it for all users as soon as possible. If you have multiple Tencent Cloud accounts, the time you see the new feature may vary across accounts due to the gradual release policy. If you have any questions, you can submit a ticket for feedback.
Backup Purpose In the event of malicious or accidental deletion of databases or tables, data can be recovered through Backup/recovery, ensuring data security and preventing data loss or corruption.
Backup Billing TencentDB for SQL Server new backup version only changes the console architecture and operations, with no change in fees. For specific backup fee details, see Backup Fees.
Automatic Backup TencentDB for SQL Server supports automatic backup settings, which include regular backups and periodic backups. Periodic backups provide a more flexible backup policy based on regular automatic backups without requiring additional retention of new backup files. You can configure corresponding automatic backup retention policies according to your business needs, enabling easy management of backup retention duration and cycles. By flexibly setting the number of backups retained for specific cycles, long-term preservation can be achieved. Additionally, reducing the retention duration of regular backups helps reduce backup costs.
Regular backups: The data backup retention period defaults to 7 days and can be customized to 3 - 7300 days. The log backup retention period defaults to the same as the data backup retention period. You can set the automatic backup frequency, and it is recommended to configure backups at least twice a week. For details, see Set Regular Backup Retention.
Periodic backups: The periodic backup retention period defaults to 365 days and can be customized to 90 - 7300 days. The periodic backup retention period must be greater than the retention period set for regular backups. You can configure the periodic backup retention frequency and start time. For details, see Set Periodic Backup Retention.
Manual backup Manual backups for both instances and multiple databases are supported. You can manually create backup files at any time. Before performing a manual backup, ensure that existing databases have been created. The time required for manual backups increases gradually with the backup file size, typically taking approximately 5 minutes - 120 minutes. When performing manual backups, you can configure the retention period policy for manual backup files. For details, see Create Manual Backup.
Cross-region backup You can store backup files in another region to enhance compliance and disaster recovery capabilities while improving data reliability. After this feature is enabled, cross-region backups are triggered upon completion of the default local automatic backups. This process dumps the default automatic backups to cross-region backup storage devices, with a default retention period of 3 days. The retention period is customizable, with a minimum of 3 days and a maximum of 7300 days. For details, see Cross-Region Backup.
Data backup Manual backups allow you to back up individual databases, multiple databases, or all databases within an instance. Automatic backups cover the entire instance. For manual backup files, you can choose to follow either the automatic backup retention period policy or the instance lifecycle policy. Automatic backup files have a default retention period of 7 days, with customizable data backup retention (ranging from 3 to 7300 days). Expired backups are automatically deleted. Please download any backup files requiring long-term retention to your local storage promptly.
Log backup The system automatically generates log backups (log files) and uploads them to cloud storage. You can customize the log backup frequency, range: 10 minutes - 60 minutes. It is recommended to set it to 10 minutes, as the higher the frequency, the lower the risk. Log files can be downloaded, and the log backup retention period aligns with the data backup retention period (3-7300 days). Backup sets are automatically deleted upon expiration.
Backup Target Backup objects are categorized into instance backups and multi-database backups. Instance backups allow you to back up all databases within an entire instance, while multi-database backups enable you to select specific databases for backup.
Configure Backup Task Used to configure whether backup files are in single-database backup format or archived backup files, and to set whether backups are performed on primary or secondary instances. By default, backup tasks run on primary instances. For details, see Configure Backup Tasks.
View and Download Backups To facilitate user access, management, and analysis of backup information, you can View Backups and Download Backups through the console. This supports filtering backups by time dimensions including: past 24 hours, past 7 days, past 15 days, past 30 days, and custom time ranges.
Deleting a Backup During database usage, backup files are continuously generated to preserve data and enable disaster recovery. These files accumulate over time and require periodic management based on actual needs. You can delete database backups to reduce backup storage costs. Note:
- Automatically generated backup files cannot be deleted manually and will be automatically removed upon expiration.
- For manual backups, you can set retention periods to align with automatic backups or the instance lifecycle. Manually created backup files support manual deletion. For details, see Delete Manual Backups.
Conversion from regular backups to scheduled backups Regular backups under the same instance have a shorter retention period than periodic backups. Therefore, TencentDB for SQL Server supports converting regular backups under the same instance to periodic backups. This enhances management capabilities for historical regular backup files and changes their backup type and retention policy. For details, see Convert Regular Backups to Periodic Backups.
View Backup Overview (Instance Dimension) You can view the backup space and usage trends for a specific instance in a region, gaining an intuitive understanding of its current local and cross-region backup sizes. This also provides a clear overview of backup space consumption across various backup methods (for example: automatic backups - regular backups, automatic backups - periodic backups, manual backups). For details, see View Backup Overview (Instance Dimension).
View Backup Overview (Region Dimension) The backup space occupied by TencentDB for SQL Server instance backup files is allocated per region. This backup space represents the total storage space for all SQL Server database backups within a region, including automatic data backups, manual data backups, and log backups.
Extending backup retention periods or increasing manual backup frequency will increase database backup storage space. You can View Backup Overview (Region Dimension) to see backup space statistics and trends for all instances under each region in your account, as well as real-time backup space statistics for individual instances.
Related APIs API

Description

CreateBackup

This API is used to create backups.

Set Backup Policy

This API (ModifyBackupStrategy) is used to modify backup policies.

Rename Backup

This API (ModifyBackupName) is used to modify backup task names.

Query Backup List

This API (DescribeBackups) is used to query the backup list.

Query Instance Regular Backup Retention Plan

This API (DescribeRegularBackupPlan) is used to query the instance's regular backup retention plan.

Delete Manual Backup

This API (RemoveBackups) is used to delete manually created backup files.

Query Backup Information Based on Process ID

This API (DescribeBackupByFlowId) is used to query the details of created backups by the ID of the backup creation process, which can be obtained from the CreateBackup API.

Query single-database backup file details

This API (DescribeBackupFiles) is used to query single-database backup details.

Query Backup Space Usage Details

This API (DescribeBackupMonitor) is used to query backup space usage details.

Query Backup Real-time Statistics List

This API (DescribeBackupStatistical) is used to query the real-time backup statistics list.

Query Database Backup Overview

This API (DescribeBackupSummary) is used to query database backup overview information.

Enable or Disable Cross-Region Backup Policy

This API (ModifyCrossBackupStrategy) is used to enable or disable cross-region backup policies.

Query Cross-Region Backup Target Regions

This API (DescribeCrossRegions) is used to query the target regions for cross-region backups.

Query Cross-Region Backup Real-time Statistics List

This API (DescribeCrossBackupStatistical) is used to query the cross-region backup real-time statistics list.
Previous Topic: Setting Event Alarms Next Topic: Configure Regular Backups Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Backup Purpose Backup Billing Automatic Backup Manual backup Cross-region backup Data backup Log backup Backup Target Configure Backup Task View and Download Backups Deleting a Backup Conversion from regular backups to scheduled backups View Backup Overview (Instance Dimension) View Backup Overview (Region Dimension) Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
