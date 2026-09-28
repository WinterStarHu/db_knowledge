# Console Operations

> 来源: https://www.tencentcloud.com/document/product/236/11274

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL FAQs Console Operations Console Operations Download Focus Mode Font Size Last updated: 2026-09-10 14:42:02 How long does it take to create a TencentDB for MySQL instance?
It generally takes less than 10 minutes to create a TencentDB instance. The time it takes to create read-only replicas is subject to the data volume of the source instance. The larger the data volume, the longer the time.
If it takes longer to create an instance, there may be something wrong. Please contact us.
How do I return a database?
You can log in to the TencentDB for MySQL console and select More > Terminate/Return or Terminate/Return & Refund in the Operation column in the instance list to return an instance. For more information, please see Terminating Instance.
What if a TencentDB for MySQL instance is terminated?
When an instance is returned, it will be retained in the recycle bin for a period of time. A pay-as-you-go instance will be retained for 1 day. During this period, you can go to the recycle bin and restore the instance.
What if I accidentally delete an account or forget the password?
If you delete an account accidentally, you can log in to the TencentDB for MySQL console, click an Instance ID to enter the instance management page, and create an account by clicking Database Management > Account Management > Create or by using an SQL statement. For more information, please see Creating an Account.
If you forget the root password, find the corresponding account in Database Management > Account Management and click More > Reset Password in the Operation column. For more information, please see Resetting Password.
The above operations can also be performed through the ModifyAccountPassword API.
What is the maximum number of connections to TencentDB for MySQL? How do I modify it?
You can view the maximum number of connections to TencentDB for MySQL in the console. If the number of connections gets too high, you are recommended to locate the cause and solve the problem first instead of directly increasing the maximum value.
Log in to the TencentDB for MySQL console, click an Instance ID to enter the instance management page, select Database Management > Parameter Settings, and modify the max_connections parameter.
Why is the value of max_connections always displayed as 1,000 rather than the actual number of current maximum connections in MySQL instance monitoring?
max_connections represents the allowed maximum connections (1-100,000) in instance monitoring. Number of open connections means the number of connections available at the current moment, a value that changes in real time.
How can I get to know that the disk capacity is insufficient?
The monitoring center oversees the disk capacity of a TencentDB instance. When the disk utilization is over 90%, SMS and email alarms will be triggered. You can configure alarm recipients in Cloud Monitor to receive such alarms. (For more information on how to configure, see Alarm Policies (Cloud Monitor)).
How do I modify the case sensitivity of table name after a TencentDB for MySQL instance is initialized?
You need to adjust the lower_case_table_names parameter of the database.
Log in to the TencentDB for MySQL console, click the Instance ID to enter the instance management page, select Database Management > Parameter Settings, and modify the lower_case_table_names parameter (0: case-sensitive, 1: case-insensitive).
Previous Topic: Features Next Topic: Logs Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How long does it take to create a TencentDB for MySQL instance?
How do I return a database?
What if a TencentDB for MySQL instance is terminated?
What if I accidentally delete an account or forget the password?
What is the maximum number of connections to TencentDB for MySQL? How do I modify it?
Why is the value of max_connections always displayed as 1,000 rather than the actual number of current maximum connections in MySQL instance monitoring?
How can I get to know that the disk capacity is insufficient?
How do I modify the case sensitivity of table name after a TencentDB for MySQL instance is initialized?
Search AllCurrent Product Search titles only Enter keywords to search documentation
