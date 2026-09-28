# Billing

> 来源: https://www.tencentcloud.com/document/product/236/38057

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL FAQs Billing Billing Download Focus Mode Font Size Last updated: 2026-08-24 15:17:19 AI-Translated & Reviewed How Do I Get a Refund for an Unwanted Purchased Instance?
If you want a refund, handle it according to your instance situation:
Pay-as-you-go instances: For TencentDB for MySQL, you can directly release resources, but you cannot apply for a refund.
Yearly/monthly subscription instances: You can perform a normal self-service return for up to 199 yearly/monthly subscription cloud database instances per account each year from the console at any time.
For details, see Refund Instructions.
What Is the Business Impact of Switching from Pay-as-You-Go to Yearly/Monthly Subscription and How Is It Billed?
Converting from pay-as-you-go to yearly/monthly subscription does not affect your business access. You can use it without any concerns.
For billing details, see Billing Overview.
Why Are There Additional Charges for My Yearly/Monthly Subscription Instance?
Confirm whether your backup space exceeds the free tier. Backup space exceeding the free tier will be charged.
You can view backup space usage on the database backup page in the MySQL console. For backup space billing details, see Backup Space Billing Instructions.
Are Pay-as-You-Go Instances Charged When Not in Use?
Pay-as-you-go instances are billed continuously. Terminate them promptly when they are no longer in use to avoid further charges.
How Is Backup Space Billed?
TencentDB for MySQL provides a certain amount of free backup space by region. The free backup space is equal to the total storage space of all two-node and three-node instances (including primary instances and disaster recovery instances) in the corresponding region.
The actual space used by a single-node cloud disk instance and the free space granted are displayed separately. You can view them on the backup and restoration page of the single-node cloud disk instance.
﻿ For backup space that exceeds the free tier, see Backup Space Billing Instructions for billing details.
To reduce backup costs, see Suggestions for Reducing Backup Costs.
Previous Topic: Selection Related Next Topic: Backup FAQs Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How Do I Get a Refund for an Unwanted Purchased Instance?
What Is the Business Impact of Switching from Pay-as-You-Go to Yearly/Monthly Subscription and How Is It Billed?
Why Are There Additional Charges for My Yearly/Monthly Subscription Instance?
Are Pay-as-You-Go Instances Charged When Not in Use?
How Is Backup Space Billed?
Search AllCurrent Product Search titles only Enter keywords to search documentation
