# Creating an Account

> 来源: https://www.tencentcloud.com/document/product/236/31900

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Creating an Account Setting Password Complexity Resetting Password Modifying Account Permissions Modifying Host Addresses with Access Permissions Modifying the Number of Connections Deleting Account Modifying Remarks Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL User Guide Account Management Creating an Account Creating an Account Download Focus Mode Font Size Last updated: 2026-06-25 17:54:22 AI-Translated Scenarios In addition to the root account created by the system by default, you can create other business accounts via the TencentDB for MySQL console based on your business needs.
Note:
Only single-node (cloud disk) instances, two-node/three-node/four-node local disk instances, and cloud disk edition instances support account creation and management. Read-only instances, disaster recovery instances, and the read-only analysis engine do not support account creation or management.
After the read-only analysis engine is enabled, the system creates a database account named "txsqlPlugins_analytics_repl" by default. This account is used by the read-only analysis engine to pull data from the read-write instance for use. Do not delete this account.
Changing the password for the root account does not affect the features of the TencentDB for MySQL instance. It only impacts business access.
Operation Steps
1.
Log in to the TencentDB for MySQL console. In the instance list, click the instance ID or click Manage in the Operation column to go to the instance management page.
2.
On the instance management page, select the Account Management page and click Create Account.
3.
In the pop-up Create Account dialog box, enter information such as the account name, host, password, and confirm password, and then click OK to complete the creation.
﻿ Parameter

Description

Account Name

For MySQL versions 5.5 and 5.6, an account name must be 1 - 16 characters long and consist of letters, digits, and special characters. It must start with a letter and end with a letter or digit. The special character is _.
For MySQL versions 5.7 and 8.0, an account name must be 1 - 32 characters long and consist of letters, digits, and special characters. It must start with a letter and end with a letter or digit. The special character is _.

Host

Specify the host address to access the database. It supports IP addresses and the % sign (indicating no IP address range restriction). Multiple host addresses are separated by delimiters. Supported delimiters include line breaks, spaces, and  ; , |.
Example 1: Entering % indicates no restriction on the IP range, allowing clients from any IP address to access the database with this account.
Example 2: Entering 10.5.10.% allows clients within the IP range 10.5.10.% to access the database with this account.

Set Password

The minimum password length must be 8 - 64 characters. A length of 12 characters or more is recommended. The password must contain at least two types of characters from the following: English letters, digits, and symbols _+-,&=!@#$%^*().|. Setting password complexity is supported to enhance database security. For details, see Set Password Complexity.

Confirm Password

Re-enter the password.

Maximum Connections

The connection limit for this account must be less than or equal to 10240. If this field is left blank, no additional restriction is applied (it is still subject to the maximum connection limit). The root account is subject to the maximum connection limit of 10240 by default.

Remarks

Enter remarks for the account. Up to 255 characters can be entered.
4.
Once a database account has been created, you can manage it in the database account list of the current instance.
Related APIs API Name

Description

CreateAccounts

Create cloud database account.
Previous Topic: DMC Management Next Topic: Setting Password Complexity Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Scenarios Operation Steps Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
