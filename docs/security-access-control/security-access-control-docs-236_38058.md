# Account Permissions

> 来源: https://www.tencentcloud.com/document/product/236/38058

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL FAQs Account Permissions Account Permissions Download Focus Mode Font Size Last updated: 2023-02-22 16:15:00 How do I authorize a MySQL client installed on a server to access TencentDB for MySQL instances?
You can go to the TencentDB for MySQL console to modify the address of the server where your MySQL client is installed to control its access.
For more information, see Modifying Host Addresses with Access Permissions.
What should I do if I cannot log in to DMC?
1.
You might be using the wrong database account. Log in to the TencentDB for MySQL console, click the instance name and go to Database Management > Manage Account, locate the account, and click More > Modify Host in the Operation column. Set New Host to "%" or the address of the server where your MySQL client is installed to grant the account access permissions.

﻿

For more information, see Modifying Host Addresses with Access Permissions.
You can also use root account to log in to DMC.
2.
If you are using the right account, your password may be incorrect. Enter a correct password or reset your password.
What should I do if I cannot create any database or table?
You might be using a database account that is not authorized to create databases or tables. Log in to the TencentDB for MySQL console, click the instance name and go to Database Management > Manage Account, locate the account, and click Modify Permissions in the Operation column to grant permissions as shown below.
﻿ What should I do if I have no permissions to modify database parameters such as sql_mode?
You might be using a sub-account without parameter modification permissions. You can use the root account or grant the sub-account permissions as instructed in Overview.
How do I grant a sub-account permissions to modify TencentDB for MySQL instances?
To grant a user permissions to create and manage TencentDB instances, you can implement the QcloudCDBFullAccess policy for the user. For more information, see Console Examples > Full Access Policy for TencentDB.
Previous Topic: Kernel Upgrade Next Topic: Performance Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How do I authorize a MySQL client installed on a server to access TencentDB for MySQL instances?
What should I do if I cannot log in to DMC?
What should I do if I cannot create any database or table?
What should I do if I have no permissions to modify database parameters such as sql_mode?
How do I grant a sub-account permissions to modify TencentDB for MySQL instances?
Search AllCurrent Product Search titles only Enter keywords to search documentation
