# Use Limits

> 来源: https://www.tencentcloud.com/document/product/236/7259

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL User Guide Use Limits Use Limits Download Focus Mode Font Size Last updated: 2025-10-30 17:35:43 AI-Translated Limits on the Data Volume TencentDB for MySQL imposes data volume restrictions on all types of MySQL instances to isolate performance issues due to limited resources. This document describes the technical impact of a single instance or table with a large data volume on MySQL.
Instance with a high data volume: The default storage engine for TencentDB is InnoDB. If the cache and buffer can cache all data and index pages in the MySQL instance, the instance can support a large number of concurrent access requests. If the instance contains too much data, the cache and buffer will frequently swap data in/out, quickly hitting an IO bottleneck and reducing throughput. For example, if a TencentDB instance is designed to sustain up to 8,000 access requests per second, it can only support 700 when the data volume is twice the size of the cache and buffer.
Table with a high data volume: If a table contains too much data, MySQL will find it more difficult to manage table resources (data, indexes, etc.), reducing table processing efficiency. For example, if the size of a transaction table (InnoDB) exceeds 10 GB, the latency in update operations will soar, increasing the response time for transactions. In this case, the problem can only be solved through sharding and migration.
Note:
If the number of tables in a single instance exceeds one million, backup, monitoring, and upgrade may fail and database monitoring may be affected. Make sure that the number of tables in a single instance is below one million.
Limit on the Number of Connections The maximum number of connections to a MySQL instance is specified with the MySQL system variable max_connections. When the actual number exceeds max_connections, no more connections can be established.
The default number of connections to TencentDB can be viewed by clicking the instance ID to enter the Database Management > Parameter Settings page in the TencentDB for MySQL console, which can be adjusted if necessary. However, more connections mean that more system resources will be consumed; if the number of connections goes beyond what the actual system load capacity allows, the system service quality will be definitely undermined.
For more information on max_connections, see MySQL official documentation.
Limits on the MySQL Client Version We recommend that you use the MySQL client and library that come with CVM to connect to TencentDB instances.
Notes on slow logs For Linux CVM instances, you can use TencentDB's export tool to get slow query logs. For more information, see Restoring Database from Physical Backup.
For Windows CVM instances, slow query logs cannot be obtained directly at present. If you need them, submit a ticket for assistance.
Notes on the TencentDB binlog retention duration TencentDB for MySQL binlogs can be retained for 7 (default value) to 1830 days (customizable by clicking the instance ID to enter the Backup and Restoration > Auto-Backup Settings page).
If binlogs are retained for an extended period of time or grow too fast, additional space will be required for backup, and fees will be incurred if the space exceeds the free tier of backup capacity.
Notes on the character set TencentDB for MySQL uses the UTF8 character set by default.
Even though TencentDB supports changing the default character set, we recommend that you explicitly specify the encoding format for a table when creating it and specify the connection encoding during connection establishment. In this way, your application will be more portable.
For more information on the resources of MySQL character set, see MySQL official documentation.
You can modify the character set through SQL or in the TencentDB for MySQL console.
Modifying the character set through SQL
1.
Run the following SQL statements to change the default character set for TencentDB instances:
SET @@global.character_set_client = utf8;
SET @@global.character_set_results = utf8;
SET @@global.character_set_connection = utf8;
SET @@global.character_set_server = utf8;
After the statements are executed, @@global.character_set_server will be automatically synced to a local file for persistence in approximately 10 minutes, while the other 3 variables will not. The configured value will stay unchanged even after migration or restart.
2.
Run the following statements to change the character set encoding for the current connection:
SET @@session.character_set_client = utf8;
SET @@session.character_set_results = utf8;
SET @@session.character_set_connection = utf8;
Or SET names utf8;
3.
For PHP programs, you can configure the character set encoding for the current connection by using the following function:
bool mysqli::set_charset(string charset);
Or bool mysqli_set_charset(mysqli link, string charset);
4.
For Java programs, you can configure the character set encoding for the current connection as shown below:
jdbc:mysql://localhost:3306/dbname?useUnicode=true&characterEncoding=UTF-8 Modifying the character set in the TencentDB for MySQL console
1.
Log in to the TencentDB for MySQL console and click an instance ID in the instance list to enter the instance details page.
2.
Find the character set/collation in Instance Info and click the modification icon.
﻿
3.
In the pop-up window, select a character set/collation and click OK.
﻿ Limits on operations
1.
Do not modify the information and permissions of the existing accounts for a MySQL instance; otherwise, some cluster services may become unavailable.
2.
InnoDB is recommended for creating databases and tables, so that the instances can better support a large number of concurrent access requests.
3.
Do not modify or terminate the source-replica relationship; otherwise, hot backup may fail.
Limits on the table name Chinese table names are not supported because they may result in failures of processes such as rollback and upgrade.
Database Account Permission TencentDB for MySQL no longer provides the super user permission. To modify parameters that require this permission, log in to the TencentDB for MySQL console, click the instance ID to enter the Database Management > Parameter Settings page, and modify them.
Network Selection We recommend that you use a Virtual Private Cloud(VPC). In the VPC, you can freely define IP range segmentation, IP addresses, and routing policies. Compared with the classic network, VPC is more suitable for scenarios where custom network configurations are required. For the comparison of VPC and classic network, see Overview.
Previous Topic: Migrate or upgrade to TencentDB for MySQL Cluster Edition Next Topic: Operation Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Limits on the Data Volume Limit on the Number of Connections Limits on the MySQL Client Version Notes on slow logs Notes on the TencentDB binlog retention duration Notes on the character set Limits on operations Limits on the table name Database Account Permission Network Selection Search AllCurrent Product Search titles only Enter keywords to search documentation
