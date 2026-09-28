# Purchase Methods

> 来源: https://www.tencentcloud.com/document/product/236/5160

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Billing Purchase Methods Purchase Methods Download Focus Mode Font Size Last updated: 2026-03-20 17:18:55 AI-Translated Prerequisites A Tencent Cloud account is registered and identity verification is completed.
To register for a Tencent Cloud account, click Register for a Tencent Cloud account.
To complete identity verification, click to complete Identity Verification.
Note： The updated purchase page now supports a one-click Import Existing Configuration feature. When logged in to an account with already created MySQL cloud database instances, this feature allows for a swift selection of configurations identical to those of existing instances. This facilitates quick adjustments based on existing configurations or direct purchases. The operational guide is as follows.
1.
On the purchase page, click Import Existing Configuration in the upper right corner.
﻿
2.
In the pop-up window, select the corresponding regional existing target instances and click OK.
﻿ Purchasing in the console Purchasing a two-node/three-node instance
1.
Log in to the TencentDB for MySQL Purchase. Complete the Basic Configuration and Instance Configuration according to actual requirements, then click Next: Set up Network and Database.
Basic Configuration Billing Mode: Yearly/monthly subscription and pay-as-you-go billing are supported.
If your business has a stable long-term demand, we recommend you select a yearly/monthly subscription.
If the request volume of your business fluctuates greatly and instantaneously, we recommend you select pay-as-you-go billing.
Region: Select the region where you want to deploy your TencentDB for MySQL instance. We recommend you use the same region as the CVM instance to be connected to. Tencent Cloud services in different regions cannot communicate with each other over the private network. The region cannot be modified after purchase.
Database Version: Currently, TencentDB for MySQL supports MySQL 8.0, 5.7 and 5.6. For more information on the features of each version, see MySQL 5.7 Reference Manual.
Note： It is recommended to use the more recent database versions of MySQL 8.0 and 5.7.
The cluster edition architecture only supports the selection of MySQL versions 8.0 and 5.7.
Engine: Select InnoDB or RocksDB.
InnoDB: The most commonly used OLTP storage engine, with complete transaction support and powerful capability of highly concurrent reading and writing.
RocksDB: A key-value storage engine, with efficient writing and high compression. If it is selected, the architecture will be two-node.
Architecture: Single-node, two-node,  three-node or cluster edition architectures are supported. For more information, see Overview.
Disk Type: The disk, essential for storing files required for MySQL operation, is supported in two types by Tencent Cloud's MySQL database: local disk and cloud disk.
The disk type for both two-node and three-node configurations is local SSD disk.
The disk type for a single node is a cloud disk.
Availability Zone: Dual-node, triple-node, and cluster architectures allow for the selection of a primary availability zone and a secondary availability zone. Opting for different primary and secondary zones (i.e.multi-AZ deployment) enhances database protection against failures or disruptions within an availability zone.
For two-node and three-node architectures, it is necessary to select a source availability zone and a replica availability zone.
For cluster edition architecture, you must choose the number of read-only nodes, as well as the availability zones for both read-write and read-only nodes.
Number of Read-Only Nodes: By default, there are two read-only nodes, supporting manual selection of one to five nodes.
Read-Write Node Availability Zone: Select the availability zone for the read-write nodes.
Read-Only Node Availability Zone: Depending on the number of read-only nodes, sequentially select the availability zones for these nodes. The specific range of availability zones is subject to the actual purchase page. If the availability zones for the read-only nodes are not actively selected, the system will automatically allocate them.
Note:
If the primary and replica are in different AZs, the network sync delay may increase by 2–3 ms.
When you purchase Tencent Cloud services, we recommend you select the closest region to minimize access latency and improve download speed.
Instance Configuration Filtering: Swiftly select the required instances of CPU and memory, with all CPUs and memory selected by default.
Type: By default, single-node is of the Basic instance type. Two-node and three-node provide General and Dedicated instance types. Cluster edition provides Standard and Enhanced instance types. For more details, see Isolation Policy.
Instance Specifications: Select specifications as needed.
Hard Drive: Utilized for storing the essential files required for MySQL operation, select the size of the hard drive space.
For hard disks with single-node and cluster edition architectures, the disk type is cloud disk. After the disk capacity is selected and the instances are created, users can only expand the disk capacity; scale-in is not currently supported. For information on disk types, see Disk Types.
Single-node supports SSD and Enhanced SSD Cloud Disks. The selectable disk capacities range from 20 to 30,000 GB.
The Cluster Edition architecture supports Cloud SSD, Premium Disk, and Enhanced SSD. Available disk capacity: 20 GB to 32,000 GB.
Data Protection Space: To ensure the recoverability of the database instances, cluster edition instances must allocate a designated amount of space specifically for data protection within the instances. This reserved space is not used for data storage and is categorized as system protection space, designed to prevent potential instance malfunctions resulting from data overflow. The setting range is 1 - 10 GB, with the default of 1GB.
2.
After completing the Network and Others, and Database Configuration Settings, proceed by clicking Next Step: Confirm Configuration Information.
Network and Others Network: You can select the network and subnet for the instance. VPC is supported. If the existing networks do not meet your requirements, you can create a VPC or Subnet.
Note:
A subnet is a logical network space in a VPC. You can create subnets in different AZs in the same VPC, which communicate with each other over the private network by default.
After you select a network, the subnet IPs in the AZ of the selected instance are displayed by default. You can also select subnet IPs in other AZs in the region of the instance. Business connections adopt nearby access, so the network latency will not be increased.
We recommend you select the same VPC in the same region as the CVM instance to be connected to. Otherwise, the MySQL instance cannot connect to the CVM instance over the private network. If your region is absent in the setting, then set it as Default-VPC (by default).
Custom Port: The database access port, which is 3306 by default.
Security Group: For more information on security group creation and management, see TencentDB Security Group Management.
Note:
Port 3306 must be opened for the TencentDB for MySQL instance through the inbound rule of the security group. The instance uses private network port 3306 by default and supports a custom port. If the default port is changed, the MySQL new port information should be opened in the security group.
Project: Select a project to which the TencentDB instance belongs. The default project is used.
Tag: Categorize and manage resources with tags. For more information, see Tag Overview.
Alarm Policy: You can create an alarm policy to trigger alarms and send messages when the Tencent Cloud resource state changes. For more information, see Alarm Policies (Cloud Monitor).
Database Configuration Instance Name: Name the instance now or later.
Data Replication Mode: For selecting a replication method for Non-single-node instances, see Database Instance Replication.
The semi-synchronous replication method is selected for two-node instances by default. Both asynchronous and semi-synchronous replication methods are provided.
The semi-synchronous replication method is selected for three-node instances by default. Asynchronous, semi-synchronous, and strong synchronous replication methods are provided.
By default, cluster edition instances are configured for semi-synchronous replication. Two methods of replication (asynchronous and semi-synchronous) are provided for cluster edition instances.
Parameter Template: Besides the system parameter template provided by TencentDB, you can create a custom parameter template. For more information, see Managing Parameter Template.
Character Set: LATIN1, GBK, UTF8, and UTF8MB4 character sets are supported. The default value is UTF8. After purchasing the instance, you can change the character set on the instance details page in the console. For more information, see Use Limits.
Sorting Rules: The instance character set serves as the sorting rules provided by the system data, distinguishing between case-sensitive attributes and accent attributes.
Case Sensitivity of Table Names: Whether the table name is case sensitive or not, once the case setting for table names is specified in MySQL 8.0, it cannot be altered. Please proceed with caution.
Password Complexity: Only two-node, three-node, and cluster edition instances support setting of password complexity to enhance database security. It is disabled by default.For more information, see Setting Password Complexity.
Root Password: Set the password of the root account (the default user name for a new MySQL database is root). If you select Set After Creation, you can reset the password after creating the instance. For more information, see Resetting Password.
3.
Confirm the selected configuration. If you want to make changes, click Edit to return to the corresponding procedure for adjustment. Then, choose whether to check Instance Termination Protection, read and select Terms of Service, and click Buy Now after confirming the purchase duration and quantity.
Note:
Instance Termination Protection is unchecked by default, which means it is disabled by default. You can enable this feature based on your needs. Once enabled, you cannot terminate instances through the console or an API. For more information about instance termination protection, see Setting Instance Termination Protection.
4.
You will be returned to the instance list after you purchase the instance. The instance will be in the Delivering status. You can use the instance after around 3–5 minutes when its status changes to Running.
﻿ Related APIs API

Description

﻿CreateDBInstance﻿

This API is used to create a yearly/monthly subscription TencentDB for MySQL instance.

﻿CreateDBInstanceHour﻿

This API is used to create a pay-as-you-go TencentDB for MySQL instance.

﻿DescribeCdbZoneConfig﻿

This API is used to query the saleable specification configurations of TencentDB for MySQL instances across different regions.

﻿DescribeDBPrice﻿

This API is used to query the price for purchasing or renewing a TencentDB for MySQL instance.
Subsequent operations Connecting to MySQL Instance ﻿

Previous Topic: Selection Guide Next Topic: Renewal Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Purchasing in the console Purchasing a two-node/three-node instance Related APIs Subsequent operations Search AllCurrent Product Search titles only Enter keywords to search documentation
