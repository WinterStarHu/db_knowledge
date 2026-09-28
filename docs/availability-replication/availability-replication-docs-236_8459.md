# High Availability (Multi-AZ)

> 来源: https://www.tencentcloud.com/document/product/236/8459

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction High Availability (Multi-AZ) High Availability (Multi-AZ) Download Focus Mode Font Size Last updated: 2026-07-09 10:54:09 AI-Translated Multi-AZ deployment protects your databases against instance failures or AZ outages. For information about regions and supported AZs, see Regions and AZs.
TencentDB for MySQL multi-AZ deployment provides high availability and failover support for database instances. A multi-AZ is a physical area formed by combining multiple single AZs within the same region at the single-AZ level.
Note:
Two-Node, Three-Node, and Four-Node instances:
Regardless of whether the instances in a database cluster span multiple AZs, the high availability of each TencentDB for MySQL instance is ensured by its real-time hot standby secondary server.
In a multi-AZ deployment, TencentDB for MySQL automatically provisions and maintains a synchronous standby replica across different AZs.
The primary database instance is synchronously replicated to the standby replica across AZs to provide data redundancy, eliminate I/O freezes, and minimize latency spikes during system backups.
Cloud disk-based instances:
Replica nodes support read-only access. A cloud disk-based instance can contain only one primary node (read-write node) and up to five replica nodes (read-only nodes).
All read-only nodes in a cloud disk-based instance support AZ configuration, which must be in the same region as the read-write node.
Supported Region Multi-AZ deployment for TencentDB for MySQL is currently available in the following regions: Guangzhou, Shenzhen Finance, Shanghai, Shanghai Finance, Nanjing, Beijing, Chengdu, Hong Kong (China), Singapore, Jakarta, Bangkok, Seoul, Tokyo, Silicon Valley, Virginia, Frankfurt, and Riyadh.
Multi-AZ Deployment Operation Steps for Two-Node, Three-Node, and Four-Node Instances Operation Steps for Cluster Edition Instances
1.
Log in to the TencentDB for MySQL console. In the instance list, click Create to go to the purchase page.
2.
On the MySQL purchase page, select a supported region and choose either the two-node, three-node or four-node architecture. Then, select a corresponding secondary AZ in the Replica AZ option.
Note:
Only some AZs can be used as replica AZs. You can view available replica AZs on the purchase page.
﻿
3.
After confirming the information, click Buy Now. Once the payment is completed, you can return to the instance list to view the purchased multi-AZ instance.
Failover TencentDB for MySQL automatically handles failover, enabling you to quickly resume database operations without administrative intervention. If any of the following conditions occur, the primary database instance is automatically switched to the standby replica in the secondary AZ:
An AZ is interrupted.
The primary database instance fails.
Previous Topic: Database Storage Engines Next Topic: Regions and AZs Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Supported Region Multi-AZ Deployment Failover Search AllCurrent Product Search titles only Enter keywords to search documentation
