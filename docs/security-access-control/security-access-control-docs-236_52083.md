# Database Audit Billing Overview

> 来源: https://www.tencentcloud.com/document/product/236/52083

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Billing Database Audit Billing Overview Database Audit Billing Overview Download Focus Mode Font Size Last updated: 2026-04-14 17:25:23 AI-Translated TencentDB for MySQL 5.6, 5.7, and 8.0 versions of dual-node and three-node architecture instances, as well as TencentDB for MySQL 5.7 and 8.0 versions of cloud disk edition architecture instances, support enabling Database Audit. Currently, enabling Database Audit is not supported for TencentDB for MySQL 5.5 version and single-node architecture instances. This document introduces the billing details for TencentDB for MySQL Database Audit.
Database Audit Billing Price You only need to pay for Database Audit when it is enabled. For how to enable Database Audit, see Enabling Database Audit.
Database Audit is charged in pay-as-you-go mode based on the audit log storage size. The billing cycle is one hour. If the duration is less than one hour, the fee will be charged by one hour.
Note:
The audit log storage size is reported in "real time", which may result in precision discrepancies when the audit log storage size is calculated on an "hourly" basis. For actual values, please refer to your bill.
Region

Price (USD/GB/Hour)

High-Frequency Storage

Low-Frequency Storage

China (including financial regions)

0.00147059

0.00018382

Regions Outside China

0.00220588

0.00027573
High and Low Frequency Storage Description High-Frequency Storage represents ultra-high-performance storage media with optimal query performance. You can configure the storage duration, within which audit data is stored in High-Frequency Storage. Data exceeding this duration is automatically transferred to Low-Frequency Storage. Both storage types support identical audit capabilities, differing only in performance.
When a database instance is configured with Low-Frequency Storage, data within the specified range is automatically tiered down to Low-Frequency Storage. The system automatically transitions data between hot and cold storage tiers based on access performance requirements, thereby reducing your storage costs.
High-Low Frequency Storage Architecture ﻿ As shown in the figure, if data from the most recent 7 days is stored in High-Frequency Storage, data older than 7 days will be automatically tiered down to Low-Frequency Storage. When the High-Frequency Storage duration is extended, audit data meeting the extended retention period will be automatically migrated from Low-Frequency Storage back to High-Frequency Storage.
High and Low Frequency Storage Performance Differences High-Frequency Storage Throughput

Low-Frequency Storage Throughput

110,000 SQL/second

25,000 SQL/second Pricing for the Shipping Database Audit Logs Feature TencentDB for MySQL's Database Audit provides the log shipping feature. If you enable this feature, it involves usage fees for third-party independently billed products and log shipping traffic fees, as detailed below.
The feature of shipping TencentDB for MySQL database audit logs to CLS involves CLS, which is a third-party independently billed cloud product. For billing details, see CLS > Billing Overview.
The feature of shipping TencentDB for MySQL database audit logs to CKafka involves the third-party independently billed cloud service CKafka. For billing details, see TDMQ for CKafka > Billing Overview.
The feature of shipping TencentDB for MySQL database audit logs to COS involves COS, which is an independently billed third-party cloud product. For pricing, see Billing Overview.
After the log shipping feature is enabled for database audit of TencentDB for MySQL, traffic fees will be incurred. The fees are charged based on the traffic of shipped logs. For details, see the table below.
Note:
After the log shipping feature is enabled, traffic fees are incurred. However, regardless of whether you enable one or more log shipping paths (CLS, CKafka, or COS), the system only charges traffic fees incurred by this feature as a whole.
Billable Item: Audit Log Traffic

Chinese Mainland (USD/GB)

Hong Kong (China), other countries and regions (USD/GB)

0.05882353

0.08823529
Release Notes After the audit feature is enabled for TencentDB for MySQL (pay-as-you-go/yearly/monthly subscription mode), if the user releases the cloud database instance or the instance expires and is released, the corresponding Database Audit service will be terminated. Audit logs will be automatically deleted and cannot be recovered.
Overdue Payment Instructions
1.
From the moment your account balance falls below zero:
Within 2 hours, Database Audit remains available and continues to incur charges.
After 2 hours, Database Audit will automatically stop and cease incurring charges.
2.
After the service is automatically stopped:
Within 24 hours after automatic stop, if the balance is recharged to 0 or above, Database Audit will resume and billing will continue; if your account balance is less than 0, Database Audit cannot be restored.
After 24 hours of automatic stop, if your account balance remains below zero, the logs will be deleted and cannot be recovered.
Previous Topic: Backup Space Billing Next Topic: Commercial Billing and Activity Description for Database Proxy Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Database Audit Billing Price High and Low Frequency Storage Description High-Low Frequency Storage Architecture High and Low Frequency Storage Performance Differences Pricing for the Shipping Database Audit Logs Feature Release Notes Overdue Payment Instructions Search AllCurrent Product Search titles only Enter keywords to search documentation
