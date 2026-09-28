# Enabling Audit Service

> 来源: https://www.tencentcloud.com/document/product/236/52086

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL SQL Insight (Database Audit) Enabling Audit Service Enabling Audit Service Download Focus Mode Font Size Last updated: 2026-04-29 17:42:25 AI-Translated Tencent Cloud provides SQL Insight (Database Audit) capability for TencentDB for MySQL, recording database access and SQL statement execution, helping enterprises perform risk control and improve data security levels.
Prerequisites You have created a MySQL instance.
Supported Versions and Architecture The feature currently supports database kernel versions MySQL 5.6 20180122 and later, MySQL 5.7 20190429 and later, and MySQL 8.0 20210330 and later.
The feature supports two-node, three-node, and cloud disk edition instance architectures, with read-only instances also supported.
Instances of MySQL 5.5, single-node (cloud disk) architecture, read-only analysis engines, and two-node economical editions do not support this feature.
Operation Steps
1.
Log in to the TencentDB for MySQL console.
2.
Select SQL Insight (Database Audit) in the left sidebar.
3.
Select a region at the top, click the Audit Log Storage Status field on the Audit Instance page, and select Disabled to filter instances with the audit service disabled.
4.
In the audit instance list, locate the target instance (you can also quickly find it by filtering resource attributes in the search box), and click Enable Database Audit in its Operation column.
Note:
Batch enabling of the audit service is supported. On the Audit Instance page, select multiple target instances and click Enable Database Audit at the top to go to the settings page.
﻿
5.
On the page for enabling the audit service, sequentially complete the audit instance selection, audit type settings, audit service settings, and advanced performance analysis settings. Read and check the Tencent Cloud Service Agreement, then click OK.
5.1
Select Audit Instance Under the audit instance selection item, the system automatically selects the instance chosen in Step 4 by default. It also supports modifying the target instance in this window (selecting other instances or multiple instances). You can also quickly locate the target instance in the search box by Instance ID/Name. After completing the instance selection, go to the audit rule settings.
﻿
5.2
Audit Rule Settings In the audit type settings, you need to select either Full Audit or Rule-Based Audit. A detailed comparison between the two is provided in the following table.
Parameter

Description

Full Audit

Comprehensively records all access to the database and SQL statement execution.

Rule-Based Audit

Rule audit records access to the database and SQL statement execution based on customized audit rules.
When the audit type is set to Full Audit, the actual operations on the console fall into the following two scenarios. You can refer to the corresponding operations accordingly.
You can select an existing template from the rule templates or choose to create a new rule template. For detailed steps on creating a new template, refer to Create New Rule Template.
After the rule template settings are completed, proceed to the audit service settings step.
Note:
You can apply up to 5 rule templates, and different rule templates are in an "OR" relationship.
Rule templates are applied to instances with the audit type set to "Full Audit". They are only used to set the risk level and alarm policy for audit logs that match the rules in the template. Audit logs that do not match the rules are still retained.
When the audit type is set to Rule Audit, you can select an existing rule from rule templates or create a new rule template. If you select an existing rule from the templates, you can directly go to the audit service settings. If no suitable rule exists in the templates, you can create a new rule template and refresh to select it. For detailed steps, refer to Create New Rule Template.
Note:
You can apply up to 5 rule templates, and different rule templates are in an "OR" relationship.
Rule templates are applied to instances with the audit type set to "Rule Audit". They are used to retain audit logs that match the rules in the template, set risk levels, and configure alarm policies. Audit logs that do not match the rules will not be retained.
5.3
﻿Configure Audit Under the audit service settings, you need to configure the audit log retention period and high/low-frequency storage duration, read and select the Tencent Cloud Service Agreement, then click OK to enable the audit service.
﻿ Parameter

Description

Log Retention Period

Set the retention period for audit logs. Unit: days. Supported values are 7, 30, 90, 180, 365, 1095, and 1825 days.

Frequent Access Storage Period

Frequent Access Storage Period represents ultra-high-performance storage medium with excellent query performance. Unit: days. After the storage duration is set, audit data within the specified period will be stored in high-frequency storage. Data beyond this duration will automatically move to low-frequency storage. Both storage types support identical audit capabilities, differing only in performance. For example: if the log retention period is set to 30 days and high-frequency storage duration to 7 days, the low-frequency storage duration defaults to 23 days.
5.4
Advanced Performance Analysis SQL Analysis: DBbrain provides comprehensive problem identification and analysis capabilities based on SQL Insight (Database Audit), supporting abnormal SQL identification, SQL template aggregation statistics, and multi-dimensional performance comparison. This option is enabled by default but can be manually disabled, indicating that the SQL analysis capability is not enabled.
Note:
The SQL analysis feature is currently in open beta and is available for a free trial. Once the beta phase concludes, TencentDB for DBbrain will officially introduce a commercial billing plan. You can refer to the official announcement for specific pricing details at that time. For more details about SQL analysis, see SQL Analysis (MySQL).
Previous Topic: Viewing Audit Instance List Next Topic: Viewing Audit Log Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Supported Versions and Architecture Operation Steps Search AllCurrent Product Search titles only Enter keywords to search documentation
