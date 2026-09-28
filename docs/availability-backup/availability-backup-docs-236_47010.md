# Setting up 2-Region-3-DC Disaster Recovery Architecture

> 来源: https://www.tencentcloud.com/document/product/236/47010

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Practical Tutorial Setting up 2-Region-3-DC Disaster Recovery Architecture Setting up 2-Region-3-DC Disaster Recovery Architecture Download Focus Mode Font Size Last updated: 2025-11-24 20:55:29 AI-Translated This document describes how to set up a 2-region-3-DC architecture by deploying instances across AZs and creating a remote disaster recovery instance.
2-Region-3-DC Deployment Architecture ﻿ 1-region-2-DC:
Zones 3 and 5 in region A form a 1-region-2-DC architecture. If zone 3 fails, you can switch to zone 5 to protect the database.
Cross-region disaster recovery:
Regions A and B form a cross-region disaster recovery architecture. Even if all data centers in zones 3 and 5 in region A fail, the business can continue after being switched to a data center in region B.
Multi-AZ Deployment TencentDB for MySQL supports multi-AZ deployment. Compared with a single-AZ deployment scheme, a multi-AZ one has better disaster recovery capabilities and can protect your database from being affected by database instance failures, AZ outages, and even IDC-level failures.
In TencentDB for MySQL, multiple AZs are combined into a single multi-AZ to ensure high availability and failover capability of database instances.
﻿ Prerequisites The instance is running.
The region where your instance resides should have at least two AZs.
The target AZs have sufficient computing resources.
Supported regions and AZs Currently, multi-AZ deployment of TencentDB for MySQL is supported in Guangzhou, Shanghai, Nanjing, Beijing, Chengdu, Hong Kong (China), Singapore, Jakarta, Bangkok, Seoul, Tokyo, Virginia, and Frankfurt regions. Available source and replica AZs in different regions are as displayed on the TencentDB for MySQL purchase page.
This feature will gradually support more regions and AZs.
If you want to deploy an instance in other regions or AZs to meet your business needs, submit a ticket for application.
Billing description This feature is free of charge. There is no charge for migrating an instance from a single AZ to multiple AZs.
Cross-Region Disaster Recovery Instance For applications with high requirements of service continuity, data reliability, and compliance, TencentDB for MySQL provides cross-region disaster recovery instances to help enhance your capability to deliver continued services at low costs and improve data reliability.
With a separate database connection address, a cross-region disaster recovery instance can offer read access capability for various scenarios such as nearby access and data analysis at a lower cost of device redundancy. Its highly available source/replica architecture helps avoid single points of failure for databases.
﻿ Billing description A disaster recovery instance costs the same as the source instance associated with it.
Setting up 2-Region-3-DC Architecture Step 1. Set multi-AZ deployment Selecting multi-AZ deployment during instance purchase
1.
Log in to the TencentDB for MySQL console and click Create in the instance list to enter the purchase page.
2.
On the purchase page, select a supported region and then select an AZ different from the source AZ for Replica AZ.
Note:
If the source and replica are in different AZs, the network sync delay may increase by 2–3 ms.
﻿
3.
After confirming that everything is correct, click Buy Now. After making the payment, you can view the instance's source and replica AZs in Availability Info on the Instance Details page.
Changing single-AZ deployment to multi-AZ deployment for existing instance
1.
Log in to the TencentDB for MySQL console.
2.
In the instance list, click the ID or Manage in the Operation column of the target instance to enter the Instance Details page.
3.
In Availability Info > Deployment Mode on the Instance Details page, click Modify Replica AZ.

﻿ ﻿
4.
In the pop-up window, select Yes for Multi-AZ Deployment, select a replica AZ, and click Submit.
﻿ Step 2. Set a cross-region disaster recovery instance Note:
Disaster recovery instances can be purchased only for high available GTID-enabled source instances on MySQL 5.6 or later with the InnoDB engine at a specification of 1 GB memory and 50 GB disk capacity or later. If your source instance is below this specification, upgrade it first.
2.1 Create a disaster recovery instance
1.
Log in to the TencentDB for MySQL console. In the instance list, click an instance ID or Manage in the Operation column to access the details page.
2.
Make sure that the GTID feature is enabled by viewing the basic information of the instance on the Instance Details page. Click Add Disaster Recovery Instance in the instance architecture diagram to enter the disaster recovery instance purchase page.

﻿ ﻿
3.
On the purchase page, configure the basic information of the disaster recovery instance, such as Billing Mode, Region.
Note:
The time required to complete the creation depends on the amount of data, and no operations can be performed on the source instance in the console during the creation. We recommend you do so at an appropriate time.
Only the entire instance data can be synced. Make sure that the disk space is sufficient.
You need to ensure that the source instance is in the running state and none of configuration adjustment tasks, restart tasks, and other modification tasks are executed. Otherwise, the sync task may fail.
4.
After confirming that everything is correct, click Buy Now and wait for disaster recovery instance delivery.
5.
Return to the instance list. After the status of the instance changes to Running, it can be used normally.
Viewing 2-Region-3-DC Architecture After the configuration is completed, the database is deployed in 2-region-3-DC architecture as shown below:
﻿ Previous Topic: Enhancing Business Load Capacity with TencentDB for MySQL Next Topic: Improving TencentDB for MySQL Performance with Read/Write Separation Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page 2-Region-3-DC Deployment Architecture Multi-AZ Deployment Prerequisites Supported regions and AZs Billing description Cross-Region Disaster Recovery Instance Billing description Setting up 2-Region-3-DC Architecture Step 1. Set multi-AZ deployment Step 2. Set a cross-region disaster recovery instance Viewing 2-Region-3-DC Architecture Search AllCurrent Product Search titles only Enter keywords to search documentation
