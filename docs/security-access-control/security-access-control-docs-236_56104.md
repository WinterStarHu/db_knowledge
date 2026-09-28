# Modifying Audit Services

> 来源: https://www.tencentcloud.com/document/product/236/56104

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL SQL Insight (Database Audit) Modifying Audit Services Modifying Audit Services Download Focus Mode Font Size Last updated: 2026-05-11 19:35:59 AI-Translated This document introduces how to modify the audit service through the console.
Note If you choose to extend the log retention period, the change will take effect immediately. If you choose to shorten the log retention period, historical logs that exceed the new storage duration will be purged immediately.
If you set data from the last n days to be stored in high-frequency storage, data older than the last n days will automatically be moved to low-frequency storage. After the high-frequency storage duration is extended, audit data that meets the retention period will automatically be migrated from low-frequency storage to high-frequency storage.
SQL Analysis Option Description: DBbrain leverages the comprehensive problem identification and analysis capabilities provided by SQL Insight (formerly Database Audit) to support abnormal SQL identification, SQL template aggregation statistics, and multi-dimensional performance comparison. This option is enabled by default, supports manual disabling, and indicates that the SQL analysis capability is not enabled.
Prerequisites Already enabling the audit service.
Modify Audit Service For Single Instance
1.
Log in to the TencentDB for MySQL console.
2.
Select SQL Insight (Database Audit) in the left sidebar.
3.
Select a region at the top, click the Audit Log Storage Status field on the Audit Instance page, and select Enabled to filter instances with the audit service enabled.
4.
Locate the target instance in the Audit Instance list (you can also quickly find it by filtering with resource attributes in the search box), then choose More > Modify Audit Service in its Operation column.
﻿
5.
On the Modify Audit Service page, after the Log Retention Period or Frequent Access Storage Period are modified, click OK.
﻿ Batch Modification of Audit Service
1.
Log in to the TencentDB for MySQL console.
2.
Select SQL Insight (Database Audit) in the left sidebar.
3.
After selecting a region at the top, on the Audit Instance page, click Audit Log Storage Status and select the Enabled option to filter out instances that do not have audit enabled.
4.
Locate the target instance in the Audit Instance list (you can also quickly find it by filtering with resource attributes in the search box). On the Audit Instance list page, select multiple target instances, then click Modify Audit Service at the top.
﻿
5.
On the Modify Audit Service page, after the Log Retention Period or Frequent Access Storage Period is modified, click OK.
Note:
For easy comparison, the batch modification audit service page displays the log retention period before and after modification. After modification, the selected instances will uniformly start adjusting to the new log retention period. Please confirm everything is correct before proceeding with the modification.
﻿ Previous Topic: Modifying Audit Rule Next Topic: Disabling Audit Service Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Modify Audit Service For Single Instance Batch Modification of Audit Service Search AllCurrent Product Search titles only Enter keywords to search documentation
