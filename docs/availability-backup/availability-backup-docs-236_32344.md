# Backup Space Billing

> 来源: https://www.tencentcloud.com/document/product/236/32344

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Billing Backup Space Billing Backup Space Billing Download Focus Mode Font Size Last updated: 2026-08-03 15:20:25 AI-Translated Overview Backup space stores backup files for all TencentDB for MySQL instances in a region. These backup files consist of automatic data backups, manual data backups, and log backups. TencentDB for MySQL supports cold backup tiering. Therefore, automatic data backups include regular data backups, standard storage backups, and archive storage backups, while log backups include regular log backups, standard storage log backups, and archive storage log backups.
For local disk-based two-node and three-node instances, TencentDB for MySQL provides a certain amount of free backup space per region. The free backup space capacity equals the aggregate storage capacity of all two-node and three-node instances (including primary instances and disaster recovery instances) in the corresponding region. For calculation examples, see Calculation Formula.
Note:
Purchasing read-only instances (RO) does not grant free backup space allocation; only purchasing primary instances and disaster recovery instances will receive this complimentary allocation.
The backup space capacity for local disk-based instances can be viewed on the Database Backup page in the MySQL console.
Cold backup tiering cannot use the complimentary free space allocation.
For single-node (cloud disk) instances and cluster edition (cloud disk) instances, TencentDB for MySQL provides a certain amount of free backup space on a per-instance basis. For a single-node (cloud disk) instance, the free backup space capacity is 200% of the instance's storage capacity.
Note:
The backup space capacity for cloud disk edition instances can be viewed on the instance backup and recovery page.
﻿ Cloud Disk vs. Local Disk Free Allowance Comparison Storage Type

Free Quota Description

Free Dimensions Description

Cloud disk

200% of the storage capacity

On a per-instance basis. For example, if a single-node cloud disk edition instance or a cloud disk edition instance has 50GB of storage space, then that instance receives 100GB of free backup space.

Local Disk

100% of the storage capacity

By region. For example, if A Tencent Cloud account has two dual-node instances in the Beijing region with storage capacities of 50GB and 80GB respectively, then the account receives 130GB of free backup space in the Beijing region.
Note:
When you use TencentDB for MySQL, if your data backup exceeds the free tier, additional fees will be incurred for the excess backup. The resource ID displayed in the Billing Center of the console appears in the format: backup_mysql_ap-shanghai_1312****46. You can use this resource ID to view detailed billing information for backup-related charges.
Single-Node (Cloud Disk) Backup Pricing For backup space exceeding the free tier, in the Chinese mainland region, it is billed at USD 0.00003676 / GB / hour, and in other regions, it is billed at USD 0.00004118 / GB / hour.
The regions currently supported for single-node cloud disk edition instances are: Shanghai, Beijing, Guangzhou, Chengdu, Hong Kong (China), Singapore, Frankfurt. Other cities will be opened gradually.
Backup Price for Cluster Edition (Cloud Disk) For backup space exceeding the free tier, in the Chinese mainland region, it is billed at USD 0.00003676 / GB / hour, and in other regions, it is billed at USD 0.00004118 / GB / hour.
The regions currently supported for cluster edition (cloud disk) instances are: Shanghai, Beijing, Guangzhou, Chengdu, Hong Kong (China), Singapore, Frankfurt. Other cities will be opened gradually.
Local Disk Backup Pricing For backup space exceeding the free tier, in the Chinese mainland region, it is billed at USD 0.00000003 / GB / second, and in other regions, it is billed at USD 0.00000004 / GB / second.
No actual charges will be incurred for storage space under 1GB. Usage under 1 hour will be billed as 1 hour. TencentDB for MySQL offers a generous free tier, meaning most instances will not incur backup storage charges.
Cross-Region Backup and Billing Notes TencentDB for MySQL supports cross-region backups for compliance or disaster recovery purposes. You can enable cross-region backup via the console. See Cross-Region Backup. After cross-region backup is enabled, it coexists with default backups without affecting them. Cross-region backup is triggered upon completion of automatic backups, replicating them to cross-region backup storage. Cross-region backup files have their own retention period, independent of the default backup retention period.
Note:
Backup files and log files generated by cross-region backups do not occupy the free storage space quota. The space occupied by these files is counted towards the backup region of the primary instance to which they belong.
For cross-region backup files, the space occupied is billed at USD 0.000113 / GB / hour in the Chinese mainland region and USD 0.000127 / GB / hour in other regions.
The cross-region backup feature currently supports the following regions: Beijing, Shanghai, Guangzhou, Chengdu, Nanjing, Chongqing, Hong Kong (China), Singapore, Jakarta, Bangkok, Seoul, Tokyo, Silicon Valley, Virginia, Frankfurt, Sao Paulo, Riyadh.
Pricing for Backups of Terminated Instances TencentDB for MySQL provides the backup retention setup feature. Users can configure the backup retention policy of an instance before or when it is terminated. Retained backups are referred to as backups of terminated instances. This feature ensures that users still possess the backups of this instance for a specified period after the instance is terminated. For the backup retention setup method, see Backup Retention Settings.
Note:
Backups of terminated instances do not occupy free backup space. They are billed independently.
Instance Architecture Supporting Backups of Terminated Instances

Region

Price (USD/GB/Hour)

Two-node (local disk) instances and three-node (local disk) instances

Beijing, Nanjing, Shanghai, and Guangzhou

0.00002651

Chengdu and Chongqing

0.00002224

Virginia

0.00002808

Silicon Valley

0.00002921

Tokyo and Frankfurt

0.00003325

Singapore

0.00003775

Hong Kong (China), Seoul, Bangkok, São Paulo, and Jakarta

0.00003505

Shenzhen Finance and Shanghai Finance

0.0000674
Backup Cold Billing Instructions TencentDB for MySQL supports archiving backup files to reduce storage costs. You can configure backup cold storage via the console. For details, see Setting Backup Cold Storage. Backup cold storage enables moving backup files to standard storage and then to archive storage. The following describes the billing prices for both storage types.
Note:
Cold backup tiering cannot use the complimentary free space allocation.
The Archive Storage feature is not yet available. Stay tuned for updates.
Standard Storage Backup Pricing Standard storage costs are calculated based on the storage price of the region. The billing method is pay-as-you-go, postpaid, and its price is:
Region

Price (USD/GB/Hour)

Beijing, Nanjing, Shanghai, and Guangzhou

0.00002651

Chengdu and Chongqing

0.00002224

Virginia

0.00002808

Silicon Valley

0.00002921

Tokyo and Frankfurt

0.00003325

Singapore

0.00003775

Hong Kong (China), Seoul, Bangkok, São Paulo, and Jakarta

0.00003505

Shenzhen Finance and Shanghai Finance

0.0000674
Archive Storage Backup Price Archive storage costs are calculated based on the storage price of the region. The billing method is pay-as-you-go, postpaid, and its price is:
Region

Price (USD/GB/Hour)

Beijing, Nanjing, Shanghai, and Guangzhou

0.00000741

Chengdu, Chongqing, Silicon Valley, and Virginia

0.00000674

Frankfurt

0.00000696

Hong Kong (China), Tokyo, Seoul, Bangkok, Sao Paulo, and Singapore

0.00000764

Shenzhen Finance

0.00002247
Backup Billing Period Starting from 00:00 on December 2, 2019, Hong Kong/Macao/Taiwan (China) and other overseas regions will officially start charging.
Starting from 00:00 on December 2, 2019, Southwest China (Chengdu, Chongqing), South China (Shenzhen Finance), East China (Shanghai Finance), and North China (Beijing Finance) will officially start charging.
Starting from 00:00 on December 5, 2019, South China (Guangzhou) will officially start charging.
Starting from 00:00 on December 9, 2019, North China (Beijing) will officially start charging.
Starting from 00:00 on December 10, 2019, East China (Shanghai) will officially start charging.
Backup for regions added after 00:00 on December 10, 2019 will also be subject to charges.
Calculation Formula Local Disk Backup Space Calculation Formula:
Free Backup Space (Single Region) = Sum of the storage space of purchased MySQL two-node and three-node instances in that region.
Billed Portion (Single Region) = Data Backup Volume (that region) + Log Backup Volume (that region) - Free Backup Space (that region).
Cloud Disk Backup Space Calculation Formula:
Free Backup Space (Single Instance) = 200% of the storage space purchased for that instance Billed Portion (Single Instance) = Data Backup Volume (that instance) + Log Backup Volume (that instance) - Free Backup Space (that instance).
Note:
Backups of TencentDB for MySQL instances in the recycle bin are still counted in the backup space and included in the total space size calculation.
Calculation Example For example, if you have a running MySQL two-node instance in Guangzhou Zone 3 (with purchased database storage space of 500 GB per month) and a MySQL two-node instance in Guangzhou Zone 4 (with purchased database storage space of 200 GB per month), then the Guangzhou region will have 700 GB of free backup space per month.
Once the total backup storage space in the Guangzhou region exceeds 700 GB-for example, if data backup reaches 800 GB and log backup reaches 100 GB-the billable space would be 800 + 100 - 700 = 200 GB. For the current hour, you will be charged for this additional 200 GB of over-backup space, with subsequent overages billed accordingly.
Backup Lifecycle Yearly/Monthly Subscription Instances Backups change accordingly with the lifecycle of the instance.
Within 7 days after the instance expires, backups will proceed normally, and backups exceeding the free backup space during this period will still be charged.
After the 8th day following instance expiration, the instance is isolated and goes to the recycle bin. At this point, automatic backups are stopped, and rollback and manual backups are prohibited. However, backup downloads remain available (downloadable on the Backup List page). Backups exceeding the free allocated space for this instance will still be billed until the instance is decommissioned. You may renew the instance in the console recycle bin to restore both the instance and backups.
After being isolated in the recycle bin for 7 days, the instance will be officially decommissioned. At this point, the instance will be permanently destroyed, and the relevant data backups will also be destroyed. Please promptly save any required backups.
Pay-As-You-Go Instances Backups change accordingly with the lifecycle of the instance.
Backups can be performed normally within 24 hours when the instance is in arrears.
After the instance has been in arrears for 24 hours, it is isolated and goes to the recycle bin. At this point, automatic backups are stopped, and rollback and manual backups are prohibited. However, backup downloads remain available (downloadable on the Backup List page). Backups exceeding the free allocated space for this instance will still be billed until the instance is decommissioned. You may renew the instance in the console recycle bin to restore both the instance and backups.
After being isolated in the recycle bin for 3 days, the instance will be officially decommissioned. At this point, the instance will be permanently destroyed, and the relevant data backups will also be destroyed. Please save any required backups promptly.
Account in Arrears Notice Yearly/Monthly Subscription Instances Once the account is in arrears but the instance has not expired, backup-related services will be degraded. Rollback, manual backups, and backup downloads are forbidden. During this period, automatic backups will continue, and backups exceeding the free allocated space will still be charged.
To use services such as rollback, manual backups, and backup downloads, please recharge your account to a positive balance.
Pay-As-You-Go Instances After the account is in arrears, backups vary with the lifecycle of user instances. For details, see the pay-as-you-go backup lifecycle description above.
Backup Commercial Service Tier Note:
The values listed in the following table represent the maximum supported limits for each item within the same region under a single Tencent Cloud account.
Enhancement Points

Before Upgrade

After Upgrade

Data Backup Retention Period

30 days

1830 days

Log Backup Retention Period

5 days

3650 days

Backup Compression Ratio

General Compression Ratio

Extremely High Compression Ratio

binlog centralization

Local Storage

Centralized Storage Suggestions for Reducing Backup Costs Delete unused manual backup data. Manual backups can be deleted in the Instance Management page > backup recovery page of the MySQL console (accessible by clicking the target instance ID or Manage in its Operations column). Automatic backups are deleted upon expiration and cannot be manually deleted in the console.
Reduce the automatic backup frequency for non-core businesses (you can adjust the backup cycle and backup retention period in the console, with backups performed at least twice per week).
Note:
Rollback feature relies on data backups within the backup cycle and retention period + log backups (binlog). Reducing automatic backup frequency and retention days will limit the rollback time range for instance data since these settings affect available backups. Please weigh your backup configuration carefully.
Reduce the retention period for data backups and log backups of non-core businesses (a backup retention period of 7 days suffices for most scenarios).
Set backup cooling, customize the backup cooling policy, convert the storage class of backup files, and reduce storage costs.
Business Scenario

Backup Retention Period

Core businesses

Recommended: 7 - 3650 days. We recommend enabling regular backups to achieve long-term preservation of backups.

Non-core and non-data businesses

Recommended: 7 days

Archiving businesses

It is recommended to set the data backup retention period to 7 days. Manually back up data according to actual business needs and delete backups promptly after use.

Testing businesses

It is recommended to set the data backup retention period to 7 days. Manually back up data according to actual business needs and delete backups promptly after use.
Previous Topic: Billing for Storage Space Overusage Next Topic: Database Audit Billing Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Cloud Disk vs. Local Disk Free Allowance Comparison Single-Node (Cloud Disk) Backup Pricing Backup Price for Cluster Edition (Cloud Disk) Local Disk Backup Pricing Cross-Region Backup and Billing Notes Pricing for Backups of Terminated Instances Backup Cold Billing Instructions Standard Storage Backup Pricing Archive Storage Backup Price Backup Billing Period Calculation Formula Backup Lifecycle Yearly/Monthly Subscription Instances Pay-As-You-Go Instances Account in Arrears Notice Yearly/Monthly Subscription Instances Pay-As-You-Go Instances Backup Commercial Service Tier Suggestions for Reducing Backup Costs Search AllCurrent Product Search titles only Enter keywords to search documentation
