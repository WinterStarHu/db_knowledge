# Economical Instance

> 来源: https://www.tencentcloud.com/document/product/236/69313

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction Economical Instance Economical Instance Download Focus Mode Font Size Last updated: 2026-03-20 17:41:48 AI-Translated TencentDB for MySQL supports creating economical instances to provide database services that can better meet the business needs of small and medium-sized enterprises and individual developers. This document describes economical instances of TencentDB for MySQL.
Overview Economical instance is a cloud database service product of TencentDB for MySQL designed for lightweight application scenarios. The instance architecture is two-node, and a high availability mode with one primary and one replica node is adopted. Economical instances are sold in the form of fixed packages with high cost-effectiveness. Such instances are usually used in lightweight and low-load application scenarios such as small websites, web applications, blogs, and forums. They are also applicable for cloud development, testing, and learning environments. In these scenarios, economical instances can provide stable services and meet the computing and storage needs of the business. The specifications of economical instances are fixed. You can select a proper specification according to your actual needs for optimal resource utilization. They can ensure service quality and greatly reduce the operation costs of enterprises. They are applicable for small and medium-sized enterprises and individual developers.
Note:
Compared with two-node general instances of TencentDB for MySQL with the same specifications, economical instances are more cost-effective.
The specifications of economical instances are fixed. If you expect more instance specifications to support more complex business scenarios, you can use TencentDB for MySQL Cluster Edition or general/exclusive two-node/three-node TencentDB for MySQL instances.
Supported Database Versions and Engines Supported database versions: MySQL 5.7 and MySQL 8.0.
Supported engines: InnoDB and RocksDB.
Supported Regions and AZs The supported regions and AZs are listed in the table below and may be updated. Please refer to the supported regions and AZs on the purchase page.
Region

AZ

Beijing

Beijing Zone 3 and Beijing Zone 6

Shanghai

Shanghai Zone 2

Guangzhou

Guangzhou Zone 3 and Guangzhou Zone 4

Chengdu

Chengdu Zone 1 and Chengdu Zone 2 Billing Mode Economical instances only support the yearly/monthly subscription mode.
Product Specifications Currently, economical instances have four fixed specifications. For all instance specifications supported by TencentDB for MySQL, see Database Instance Specification.
Type

CPU and Memory

Disk

Economical

1-core 2,000 MB

50GB

2-core 4,000 MB

100GB

4-core 8,000 MB

150GB

8-core 16,000 MB

200GB Quota Limitation Note:
The quota limit refers to the maximum quantity of economical instances of each fixed specification that an account (UIN) can own at the same time in a single region.
If the current quota cannot meet your needs, you can submit a ticket to apply for more quotas. Tencent Cloud will assess and process your application based on the application reason.
Instance Type

Quota Limitation

Primary instance

You can purchase up to 5 economical primary instances of any specification in each region.

Read-only instances

One economical primary instance can be mounted with up to 2 economical read-only instances. Note: Economical read-only instances can only be mounted to economical primary instances instead of general/exclusive primary instances.
Disk (Storage Space) Usage Warning:
Economical instances are sold with fixed specifications (disk package mode). If the disk (storage space) is about to be used up, you need to upgrade the configuration promptly. If the storage space of an instance is fully occupied, the instance will become read-only and be locked 24 hours later. In this case, the instance cannot be written. After you upgrade the configuration, the instance recovers and allows writing.
To prevent instances from becoming read-only and being locked when you fail to pay attention to disk (storage space) usage, you can subscribe to the instance read-only (disk usage exceeding limit) event in the event bus. For operations, see Setting Event Alarms. You can also set disk utilization alarms. For operations, see Alarm Policies (TCOP).
Features The features supported by economical instances are similar to those of TencentDB for MySQL. For details about the supported and restricted features, see Feature List.
Comparison The comparison between economical instances and two-node general instances of TencentDB for MySQL is as follows.
Comparison Item

Two-Node General TencentDB for MySQL Instance

Two-Node Economical TencentDB for MySQL Instance

Applicable user

Medium and large-sized enterprises.

Small and medium-sized enterprises and individual developers.

Business Scenario

Complex business scenarios, such as games, Internet, IoT, retail e-commerce, logistics, insurance, and securities.

Lightweight business scenarios, such as small websites, web applications, blogs, forums, cloud development, cloud testing, and cloud learning.

Sales mode

Flexible selection of computing/storage resources. More instance specifications are available.

Fixed specifications with higher cost-effectiveness.

Billing Mode

Yearly/monthly subscription and pay-as-you-go.

Yearly/monthly subscription only.
Purchasing Economical Instances
1.
Log in to the TencentDB for MySQL purchase page.
2.
Select Two-node as the architecture.
3.
Select Economical for Type in the Instance Configuration area.
﻿
4.
Select the instance specification, complete other configurations, and click Buy Now.
Note:
For details of other configurations and the complete purchase process, see Purchase Methods.
Previous Topic: Resource Isolation Policy Next Topic: Feature List Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Supported Database Versions and Engines Supported Regions and AZs Billing Mode Product Specifications Quota Limitation Disk (Storage Space) Usage Features Comparison Purchasing Economical Instances Search AllCurrent Product Search titles only Enter keywords to search documentation
