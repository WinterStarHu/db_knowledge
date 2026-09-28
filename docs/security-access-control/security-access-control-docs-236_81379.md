# Billing for Storage Space Overusage

> 来源: https://www.tencentcloud.com/document/product/236/81379

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Billing Billing for Storage Space Overusage Billing for Storage Space Overusage Download Focus Mode Font Size Last updated: 2026-08-03 17:44:43 AI-Translated This document introduces the billing details for TencentDB for MySQL storage overusage.
Overview TencentDB for MySQL is categorized into local disk instances and cloud disk instances based on the type of storage. Local disk instances adopt a compute-storage integrated architecture, where computing and storage resources are deployed on the same physical node. Under this architecture, the disk capacity of a node is limited by the physical hardware specifications, resulting in a definite capacity ceiling. Once overusage reaches the host's limit, overall service quality and stability will be affected.
Note:
Users with high storage demands are recommended to use the cloud disk edition. Currently, the cloud disk edition supports up to 32 TB of storage. The console provides a one-click migration capability to migrate local disk instances to cloud disk edition instances.
Effective Time The billing for storage overusage takes effect starting from 00:00:00, August 1, 2026, Beijing Time.
Target Audience This document applies to local disk instances.
In the early stage, to lower the user adoption barrier, local disk instances were not immediately locked or had writes restricted after data files exceeded the purchased specifications. This resulted in the actual disk usage of some existing instances remaining above the purchased specifications for an extended period. The current policy is as follows:
New instances: For instances that newly exceed their purchased specifications after the effective date, a disk pre-lock event will be triggered (read/write operations are allowed at this stage). After 24 hours, a lock event will be triggered (only read operations are allowed). Storage overusage billing will be incurred for the portion of the instance's total used storage space that exceeds the purchased storage space.
Existing instances: For existing instances that have already exceeded their purchased specifications before the effective date, Tencent Cloud will continue to allow read and write operations. However, storage overusage billing will be incurred for the portion that exceeds the purchased specifications. Please note that when an existing overusage instance reaches the host's storage space risk threshold, a disk pre-lock event will be triggered (read/write operations are allowed at this stage). After 24 hours, a lock event will be triggered (only read operations are allowed).
Note:
If an instance remains in the scaling-out task execution state after exceeding the disk pre-lock event's time window (24 hours), the system will not perform a read-only operation on that instance. Instead, it will evaluate the lock event only after the task execution is completed.
Billing Rules Billing Objects This billing applies to instances that simultaneously meet all of the following conditions:
1.
The instance's disk type is local disk (Local SSD).
2.
The instance's current actual total usage exceeds the purchased storage space specification.
Billing Formula Overusage cost = (Actual total usage - Purchased storage space) × Overusage unit price × Usage duration.
Overage Unit Price Three-Node General/Dedicated Local Disks Two-Node General/Dedicated Local Disks General/Dedicated Local Disk Read-Only Instances Region

Price (USD/GB/Hour)

Shanghai, Nanjing, Chongqing, Chengdu, Beijing, Guangzhou

0.000662

Hong Kong (China), Singapore, Tokyo, Osaka, Jakarta, Bangkok, and Seoul

0.000882

Virginia, Silicon Valley, Frankfurt, Sao Paulo, and Riyadh

0.001103
Billing method The overusage portion is settled in the pay-as-you-go (postpaid) mode. It is billed hourly based on the actual overusage amount and usage duration. For usage periods shorter than one hour, billing is based on the actual storage overusage time. Bills are generated daily.
Overusage fees will be displayed as an independent billing item in the cost bill for easy identification and management.
Recommended Actions To avoid incurring additional charges, you are advised to take the following measures as soon as possible:
1. Scaling Out Storage Specifications
In the console, scale out the instance's storage specification to a level above the current actual usage to eliminate the overusage state. For the operation, see Adjusting Database Instance Specifications.
2. Cleaning Up Redundant Data
Check and clean up unused big tables, historical archive data, redundant indexes, and other items to reduce data file occupancy.
3. Migrating to a Cloud Disk Instance
If your business is expected to grow continuously, you are advised to migrate to a cloud disk edition instance. The cloud disk supports elastic scaling out and has no physical node capacity restrictions. For the operation, see One-Click Migration.
4. Setting Up Disk Alarms
Configure a disk utilization alarm (recommended threshold: 85%) to promptly detect capacity changes. For the operation, see the alarm policy.
Viewing Overusage Path: TencentDB for MySQL console > Instance List > Instance Details > Resource Usage.
Method for Determination: Check the Used Space and Storage Specification of each instance. If the used space exceeds the storage specification, the instance is in an overusage state.
Previous Topic: Instance Adjustment Fee Next Topic: Backup Space Billing Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Effective Time Target Audience Billing Rules Billing Objects Billing Formula Overage Unit Price Billing method Recommended Actions
1. Scaling Out Storage Specifications
2. Cleaning Up Redundant Data
3. Migrating to a Cloud Disk Instance
4. Setting Up Disk Alarms
Viewing Overusage Search AllCurrent Product Search titles only Enter keywords to search documentation
