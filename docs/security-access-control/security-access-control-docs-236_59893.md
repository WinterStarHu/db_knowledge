# Adjusting Instance Configuration

> 来源: https://www.tencentcloud.com/document/product/236/59893

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL MySQL Cluster Edition Adjusting Instance Configuration Adjusting Instance Configuration Download Focus Mode Font Size Last updated: 2026-05-12 19:16:50 AI-Translated The TencentDB for MySQL supports swift adjustment of instance specification, addition and removal of nodes, and flexible scale-out operation through the console. According to the varying stages of your business (whether in its early phase, a period of rapid growth, peak usage times, or troughs), you can adaptively fine-tune the specifications of MySQL instances to optimally use resources and realize real-time cost optimization more effectively.
For changes in adjustment fee, see Instance Adjustment Fee.
For operations on adjusting the configurations of single-node, two-node and three-node instances, see Adjusting Database Instance Specifications.
Prerequisites For instances of the TencentDB for MySQL Cluster Edition, see Purchase Methods for creation.
The instance is running.
Directions
1.
Log in to the TencentDB for MySQL Console. In the instance list, click Instance ID or Manage in the Operation column to enter the Instance Details page.
2.
Choose Specification Configurations > Instance Specification, and click Adjust Configurations.
﻿
3.
After completing the following configurations on the redirected page, click Submit.
Parameter

Description

Instance Type

Instance type modification (isolation policy) is supported. The instance types supported by the Cluster Edition are: Standard, Enhanced.

Specification

Select the instance specifications you wish to modify. For specifications specifically supported by the Cluster Edition, see Database Instance Specification.

Disk

The disk type for the cluster edition architecture is cloud disk, which only allows expansion of the disk capacity; currently, it does not support scale-in.

Data Replication Mode

The data replication mode of the instance can be modified. Cluster Edition instances support asynchronous replication and semi-synchronous replication. For the modification method, see Modifying the Data Replication Mode.

Node Availability Zone

This option can be used to add, and delete read-only nodes, and change node availability zones (subject to actual resource availability).

Switch Time

During Maintenance Time: Configuration adjustment occurs during the maintenance period. For modifying the instance maintenance time, see Setting Instance Maintenance Time.
Upon Upgrade Completion: The switch will be performed immediately after the configuration adjustment is completed.

Restart

Whether the adjusted configuration will restart the instance should be based on the actual configuration adjustment operation page. Some operations, such as modifying the replication mode and adding a read-only node, do not involve a restart.
Previous Topic: Viewing Instance Monitoring Next Topic: Operations for Other Features Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Directions Search AllCurrent Product Search titles only Enter keywords to search documentation
