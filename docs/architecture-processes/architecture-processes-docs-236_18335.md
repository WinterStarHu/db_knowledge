# Billing Overview

> 来源: https://www.tencentcloud.com/document/product/236/18335

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Billing Billing Overview Billing Overview Download Focus Mode Font Size Last updated: 2026-07-16 09:47:00 AI-Translated Billing Mode TencentDB for MySQL offers the following two billing modes:
Billing Mode

Payment Mode

Scenarios

Yearly/monthly subscription

Prepaid mode, which means paying fees when a new instance is created.

Suitable for long-term needs with relatively stable traffic volume. The fee is lower compared to pay-as-you-go mode, and the longer the purchase period, the more discounts you get.

Pay-as-you-go

Postpaid mode, which means applying for resources on demand first, and fees are charged based on your actual resource usage during settlement.

It is suitable for business senarios with large instantaneous fluctuations in business volume. The instance can be released immediately after use to save costs.
Instance Price Billing Formula Total cost = Memory and CPU cost + Storage space cost + Backup space cost + Traffic cost (currently free) Billable Item Billable Item

Description

Memory and CPU fees

The fee for the instance specifications (including memory and CPU) selected on the purchase page supports yearly/monthly subscription and pay-as-you-go tiered pricing. For pricing details, see Product Pricing. Pay-as-you-go adopts a three-tier pricing structure, offering greater discounts for longer use: Tier 1 T1, 0 hours < T1 ≤ 96 hours; Tier 2 T2, 96 hours < T2 ≤ 360 hours; Tier 3 T3, T3 > 360 hours.

Storage space fees

The cost of the disk size selected on the purchase page supports both yearly/monthly subscription and pay-as-you-go billing. For pricing details, see Product Pricing. The storage space is used for storing data files, shared tablespaces, error log files, REDO LOG, UNDO LOG, data dictionaries, binlog, and other files necessary for TencentDB for MySQL operation.
If the storage space you actually use exceeds the storage space selected at the time of purchase, the excess portion will continue to be charged on a pay-as-you-go basis. For detailed information on the billing rules and effective time for storage space overuse, see Storage Space Overuse Billing Description.

Backup space fees

TencentDB for MySQL provides a certain amount of free backup space per region.
For local disk instances, the free backup space size equals the sum of the storage space of all your two-node, three-node, and four-node instances (including primary or disaster recovery instances) in the corresponding region.
For cloud disk instances, the free backup space size is 200% of your instance's storage space.
For details about the fees for backup space exceeding the free quota, see Backup Space Billing.
If the free backup space is adjusted to a paid service in the future, TencentDB for MySQL will notify you in advance through announcements, internal messages, or console prompts. The specific details are subject to the official announcement and billing instructions at that time.

Traffic fees

Public network traffic fees are currently free.
You can directly use the Price Calculator to check the combined pricing for your required products to estimate resource costs. To ensure price accuracy, please log in to Tencent Cloud before checking.
Note:
The disk fee (storage space fee) of a read-only instance is consistent with that of the primary instance. You can see Product Pricing for details, as shown below.
﻿ Read-Only Analysis Engine Pricing Overview The billing formula for TencentDB for MySQL read-only analysis engines is as follows:
When a single node is selected: Total cost of the read-only analysis engine = cost of computing resources for a single node + unit price of storage space × purchased storage space When multiple nodes are selected: Total cost of the read-only analysis engine = total computing resource cost of multiple nodes (cost corresponding to total computing resources) + total storage space of all nodes × unit price of storage space Note:
When multiple nodes are selected, the number of nodes to purchase can be chosen as 2 or 3.
Compute Node Pricing of Read-Only Analysis Engine When creating a read-only analysis engine instance, you can select the number of nodes. For a single node, the default number of nodes is 1. For multiple nodes, you can choose 2 or 3 nodes. The unit price of computing resources differs between single-node and multi-node configurations. You can refer to the table below for details.
Unit price of computing resources for a single node Multi-node computing resources unit price Instance Type

Compute Node Specifications

Beijing, Shanghai, Guangzhou, Chengdu, and Nanjing

Hong Kong (China)

Singapore, Virginia, São Paulo, and Frankfurt

Yearly/Monthly Subscription Price (USD/Month)

Pay-as-You-Go Price (USD/Hour)

Yearly/Monthly Subscription Price (USD/Month)

Pay-as-You-Go Price (USD/Hour)

Yearly/Monthly Subscription Price (USD/Month)

Pay-as-You-Go Price (USD/Hour)

General

4-core 16 GB single-node

64.28571429

0.13392857

107.3571429

0.22366071

156.25

0.325

General

8-core 32 GB single-node

100

0.20833333

167

0.34791666

312.5

0.65

General

16-core 64 GB single-node

200

0.41666667

334

0.69583333

625

1.3

General

24-core 96 GB single-node

535.71428571

1.11607143

894.6428571

1.86383928

937.5

1.953125

General

32-core 128 GB single-node

714.28571429

1.48809524

1192.857143

2.48511905

1250

2.60416667

General

64-core 256 GB single-node

1428.57142857

2.97619048

2385.714286

4.9702381

2500

5.20833334

General

96-core 384 GB single-node

2142.85714286

4.46428571

3578.571429

7.45535713

3750

7.8125

General

128-core 512 GB single-node

2857.14285714

5.95238095

4771.428571

9.94047618

5000

10.41666666
Storage Space Pricing of Read-Only Analysis Engine Whether in single-node or multi-node mode, the unit price of storage space for the read-only analysis engine remains unchanged.
Beijing, Shanghai, Guangzhou, Chengdu, and Nanjing

Hong Kong (China)

Singapore, Virginia, São Paulo, and Frankfurt

Monthly Subscription (USD/GB/Month)

Pay-as-You-Go (USD/GB/Hour)

Monthly Subscription (USD/GB/Month)

Pay-as-You-Go (USD/GB/Hour)

Monthly Subscription (USD/GB/Month)

Pay-as-You-Go (USD/GB/Hour)

0.282

0.00039167

0.3384

0.000514

0.2286

0.000413
Value-Added Services Pricing Description SQL Insight (Database Audit) Price SQL Insight (Database Audit) records database access and SQL statement execution, helping enterprises implement risk control and enhance data security levels. You are charged for this feature only after enabling SQL Insight (Database Audit). The pricing is as shown in the table below. For more details, visit SQL Insight (Database Audit) Billing Instructions.
Region

Price (USD/GB/Hour)

Standard Storage

STANDARD_IA Storage

China (including financial regions)

0.00147059

0.00018382

Countries and Regions Outside China

0.00220588

0.00027573
Database Proxies Pricing Database proxies, positioned between the TencentDB service and application services, proxy all requests from application services to access the database. Database proxies are billed on a pay-as-you-go basis, with the billing unit being CU. The pricing for database proxies varies by region, as detailed in the table below. For more information, visit Database Proxy Commercial Billing and Activity Instructions.
Note:
CU refers to the minimum billing specification of a database proxy (that is, the price of a 2-core 4000MB memory proxy specification). Currently, database proxy nodes come in three specifications: 2-core 4000MB, 4-core 8000MB, and 8-core 16000MB, corresponding to 1 CU, 2 CU, and 4 CU respectively.
Region

Price (USD/CU/Hour)

Shanghai, Nanjing, Chongqing, Chengdu, Guangzhou, Beijing

0.06865672

Hong Kong (China)

0.11492537

Jakarta, Virginia, Bangkok, Tokyo, Singapore, Seoul, Frankfurt, Silicon Valley, Sao Paulo

0.11791045

Shenzhen Finance, Shanghai Finance, and Beijing Finance

0.11641791
Note:
The regions displayed above are all the regions where the current instance supports deployment. Some regions do not currently support enabling the database proxy feature. The regions that support enabling are: Beijing, Shanghai, Guangzhou, Shanghai Finance, Beijing Finance, Chengdu, Chongqing, Nanjing, Hong Kong (China), Tokyo, Bangkok, Virginia, Silicon Valley, Seoul, Singapore.
CPU Elastic Scale-out Price The elastic CPU expansion feature can better alleviate performance pressure caused by sudden requests, adapt to peak business traffic, and ensure the stability of online businesses. It also supports CPU scale-in during periods of decreased traffic to avoid resource waste. The specific billing formula and price are as follows. For more detailed information, visit Billing Instructions.
Billing Formula The CPU elastic scale-out feature is charged in pay-as-you-go mode. It is charged by the minute, and the fee is deducted once per hour.
Billing formula = (Single-core fee x Added CPU cores) x Scale-out duration (minutes)/60.
Single-Core Fee Single-Node Local Disk (Read-Only Instance) General Edition Two-Node Instance General Edition Three-Node Instance Region

Unit Price (USD/Core/Hour)

Chengdu and Chongqing

0.03

Guangzhou, Shanghai, Beijing, and Nanjing

0.04

Hong Kong (China), Tokyo, Seoul, and Bangkok

0.0495

Frankfurt and São Paulo

0.0365

Singapore, Jakarta, Silicon Valley, Virginia, and Riyadh

0.061
Billing Examples Note:
The following price cases are for reference only. Actual prices may vary by factors such as regions, promotion, and policies. See the official website for the latest price.
For example, if you are in the Guangzhou region:
Purchase of a yearly/monthly subscription TencentDB for MySQL (two-node) in Guangzhou Zone 3, with 4-core, 8000MB memory and 500GB disk, for a duration of 1 month.
Purchase one yearly/monthly subscription TencentDB for MySQL (two-node) in Guangzhou Zone 4, with 4-core, 8000MB memory and 200GB disk, for a duration of 1 month.
Total cost = Memory and CPU cost + Storage space cost + Backup space cost.
Memory specification fees The monthly price for a 4-core, 8000MB instance in the Guangzhou region is USD 120/month. Memory specification fee = 2 × USD 120/month × 1 month = USD 240.
Storage space fees In the Guangzhou region, the monthly price for instance disk is 0.10588 USD/GB/month. Storage space cost = (500GB + 200GB) × 0.10588 USD/GB/month × 1 month = 74.116 USD.
Backup space fees For High Availability Edition instances running in Guangzhou Zone 3, the purchased database storage space is 500GB per month; for those in Guangzhou Zone 4, it is 200GB per month. Then, the Guangzhou region will have 700GB of free backup space per month.
Once the total backup storage space in the Guangzhou region exceeds 700GB, for example, when data backup reaches 800GB and log backup reaches 100GB, the billable space would be 800 + 100 - 700 = 200GB. For the current hour, you will be charged for this additional 200GB of exceeding backup space, and subsequent exceeding backup space will be billed accordingly.
Backup space cost (hourly) = 200GB (exceeding backup space, which may vary in actual scenarios) × 0.000113 USD/GB/hour.
FAQs Why are there additional charges for my instance under the yearly/monthly subscription billing mode?
Please confirm whether your backup space exceeds the free quota. Backup space exceeding the free quota will be charged.
Backup space usage can be viewed on the database backup page in the MySQL console. For details about backup space billing, see Backup Space Billing.
Are Pay-as-you-go instances charged when not in use?
Pay-as-you-go instances will be billed continuously. Please terminate it promptly when the instance is no longer in use to avoid further charges.
What files are stored in the storage space?
Data files: the space occupied by data, including created tables, indexes, and so on.
System files: including shared tablespaces, error log files, REDO LOG, UNDO LOG, and data dictionary, which are essential for the system.
binlog files: record all DDL and DML statements (except data query statements such as select, show, and so on). The primary purpose of binlog is replication and recovery. The more data changes, the more binlog is generated. The generated binlog files will be uploaded to COS, thus freeing up local binlog storage space.
Documentation TencentDB for MySQL supports purchasing instances via the console and APIs. See Purchase Methods.
TencentDB for MySQL will send alert messages to users from before expiration until resource release. See Overdue Payments.
TencentDB for MySQL supports requesting refunds via the console. See Refund Instructions.
TencentDB for MySQL supports switching billing modes. See Switching from Pay-as-You-Go to Yearly/Monthly Subscription.
TencentDB for MySQL supports upgrading or downgrading instance specifications. See Instance Adjustment Fees.
Previous Topic: Incorrect Results When LEFT JOIN Queries Are Executed Using Hash Join Next Topic: Selection Guide Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Billing Mode Instance Price Billing Formula Billable Item Read-Only Analysis Engine Pricing Overview Compute Node Pricing of Read-Only Analysis Engine Storage Space Pricing of Read-Only Analysis Engine Value-Added Services Pricing Description SQL Insight (Database Audit) Price Database Proxies Pricing CPU Elastic Scale-out Price Billing Examples FAQs Documentation Search AllCurrent Product Search titles only Enter keywords to search documentation
