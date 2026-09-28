# Data Migration

> 来源: https://www.tencentcloud.com/document/product/236/11275

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL FAQs Data Migration Data Migration Download Focus Mode Font Size Last updated: 2025-06-10 10:31:29 AI-Translated SQL File Import and Export How do I import a local SQL file into a TencentDB for MySQL instance?
Note:
Only two-node and three-node TencentDB for MySQL instances support importing SQL files.
1.
Log in to the TencentDB for MySQL console and click an Instance ID to enter the management page.
2.
Select Database Management > Database List > Import Data. Select the file to be imported and the target database and click OK to import the data.
Note:
To avoid database unavailability caused by corruption of system tables, do not import data from system tables such as the mysql.user table.
Only incremental data import is supported. If there is obsolete data in the database, clear the data first before the import operation.
A single file does not exceed 10 GB. The file name only allows letters, digits, and underscores.
For more information, see Importing SQL Files.
How do I export data from a database?
To export backup data, click an Instance ID in the console to enter the management page and select the Backup and Restoration tab for download.
To export real-time data, you can purchase a read-only instance, connect to it, and then use mysqldump to get real-time data.
Migration with DTS What is the fastest way to migrate a 7 GB database to a TencentDB for MySQL instance?
We recommend you connect the database to be migrated by using DTS for data sync.
Intra-Region Instance Data Sync How do I sync real-time data in two instances with an intra-city active-active solution?
You can purchase disaster recovery instances in the console.
Previous Topic: Ops Next Topic: Features Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page SQL File Import and Export How do I import a local SQL file into a TencentDB for MySQL instance?
How do I export data from a database?
Migration with DTS What is the fastest way to migrate a 7 GB database to a TencentDB for MySQL instance?
Intra-Region Instance Data Sync How do I sync real-time data in two instances with an intra-city active-active solution?
Search AllCurrent Product Search titles only Enter keywords to search documentation
