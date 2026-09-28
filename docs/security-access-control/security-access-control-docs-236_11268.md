# Features

> 来源: https://www.tencentcloud.com/document/product/236/11268

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL FAQs Features Features Download Focus Mode Font Size Last updated: 2026-03-20 16:23:17 AI-Translated What preparations do I need to use TencentDB for MySQL?
Before using TencentDB for MySQL, you need to consider the two questions:
Is a database a good choice for your application? For example, if your business scenario involves frequent access to a small amount of key-value data, you should consider .
Is your database appropriately designed? For example, you should consider splitting a table with obvious query hotspots or high data volume into multiple tables.
How does TencentDB for MySQL manage MySQL?
You don't need to worry about the daily maintenance and adjustment of MySQL, which is taken care of by the Ops system of TencentDB.
In case of an exception with MySQL, the Ops system can immediately identify the issue and notify the Ops team. Developers will not need to make any changes.
Is TencentDB for MySQL based on physical machines?
Yes.
Can TencentDB for MySQL help me split databases and tables?
No, because the standards for splitting databases and tables are subject to your specific business logic.
What is the difference between used capacity and occupied capacity in TencentDB for MySQL?
Used capacity: Includes only MySQL's data directories but not logs such as binlog, relaylog, undolog, errorlog, and slowlog.
Occupied capacity: Includes MySQL's data directories and logs such as binlog, relaylog, undolog, errorlog, and slowlog.
Does TencentDB for MySQL have any buffer during task execution?
Question:
If multiple SQL statements are sent to TencentDB for execution within a very short period of time, will TencentDB for MySQL run them one by one or crash? What is the maximum number of allowed concurrent connections?
Answer:
A TencentDB for MySQL instance works in the same way as a self-built MySQL instance. Whether concurrently executed statements will cause a crash depends on system resources and SQL statements themselves.
When the number of connections reaches the limit (max_connections), the instance will not provide services normally. This happens generally for the following reasons:
There are too many null sessions caused by bugs in the business application;
Frontend access goes far beyond the instance's processing capability;
A long-running connection takes up MySQL resources exclusively, resulting in a large number of blocked access requests.
What are the precautions for using TencentDB for MySQL?
For more information, see Use Limits.
How do I enable or disable the read-only permission to the default replica of a TencentDB for MySQL instance?
The default replica cannot be read from or written to. It is primarily used for high-availability switchover.
Which monitoring metrics of the instance should I pay attention to?
CPU utilization, memory utilization, and disk space utilization. You can configure alarms as needed, and when you receive alarms, you can take corresponding measures to resolve them. For more information, see Alarm Policies (Cloud Monitor) Does TencentDB for MySQL support replica access?
For database security purposes, TencentDB for MySQL doesn't allow you to read from or write to the replica. This allows you to, for example, quickly switch to the replica when the source fails.
If you need greater read/write capability, consider upgrading the instance configuration or purchasing a read-only instance.
Does TencentDB for MySQL support cross-region access?
Cross-region access is unavailable for instances in VPCs by default, as VPCs in different regions are isolated from each other. We recommend that you purchase TencentDB for MySQL instances in the same region as your CVM instances to enable local data access, which guarantees high service speed and stability.
Why can't I grant a user the "file" permission?
The "shutdown" and "file" permissions are unavailable to root users now, so a root user cannot create users with all permissions. Refer to the following commands for authorization:
grant SELECT,INSERT, UPDATE, DELETE, CREATE, DROP, ALTER on *.* to 'myuser'@'%' identified by 'mypasswd';
How do I change the TencentDB for MySQL region?
Region change is not supported for the time being. You can use DTS to migrate data between instances in different regions. DTS supports real-time data sync. After data migration is completed, the source instance can be returned in a self-service manner.
What takes up the instance capacity?
User data (excluding backup data), the data needed for the instance to run (including the system database, database logs, indexes, etc.), and the binlogs generated by MySQL databases.
How many databases can I run in an instance?
The maximum number of databases and tables you can create in a TencentDB for MySQL instance depends on MySQL. For more information, see MySQL's official documentation.
Can single-node instances be upgraded to two-node or three-node instances?
No. Currently, only two-node instances can be upgraded to three-node instances.
Does the pay-as-you-go to yearly/monthly subscription billing mode change affect the database service?
No. The change only involves billing modes.
Is there a limit to the number of real-only groups I can create?
By default, up to 5 read-only groups can be created for a source instance.
Can I use Canal to pull binlogs from TencentDB for MySQL?
Yes. Pay attention to the following when using Canal:
The CVM instance where Canal is deployed and the TencentDB for MySQL instance must be in the same VPC.
You need to create a TencentDB for MySQL database account used for data sync and grant permissions correctly.
You need to set the following TencentDB for MySQL database parameters: binlog_row_image=FULL and binlog_format=ROW.
Are TencentDB for MySQL instances deployed on physical machines or CVMs?
TencentDB for MySQL instances are deployed in physical clusters with the virtualization technology. Different from physical clusters, CVM instances are mainly used to provide a scalable cloud computing service.
Does cloning have any impact on the original instance?
No, because TencentDB clones an instance by pulling the backup data. After cloning is completed, the original instance can be used normally, or terminated if you don't need it any more.
Previous Topic: Data Migration Next Topic: Console Operations Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page What preparations do I need to use TencentDB for MySQL?
How does TencentDB for MySQL manage MySQL?
Is TencentDB for MySQL based on physical machines?
Can TencentDB for MySQL help me split databases and tables?
What is the difference between used capacity and occupied capacity in TencentDB for MySQL?
Does TencentDB for MySQL have any buffer during task execution?
What are the precautions for using TencentDB for MySQL?
How do I enable or disable the read-only permission to the default replica of a TencentDB for MySQL instance?
Which monitoring metrics of the instance should I pay attention to?
Does TencentDB for MySQL support replica access?
Does TencentDB for MySQL support cross-region access?
Why can't I grant a user the "file" permission?
How do I change the TencentDB for MySQL region?
What takes up the instance capacity?
How many databases can I run in an instance?
Can single-node instances be upgraded to two-node or three-node instances?
Does the pay-as-you-go to yearly/monthly subscription billing mode change affect the database service?
Is there a limit to the number of real-only groups I can create?
Can I use Canal to pull binlogs from TencentDB for MySQL?
Are TencentDB for MySQL instances deployed on physical machines or CVMs?
Does cloning have any impact on the original instance?
Search AllCurrent Product Search titles only Enter keywords to search documentation
