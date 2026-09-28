# Viewing Audit Instance List

> 来源: https://www.tencentcloud.com/document/product/236/56106

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL SQL Insight (Database Audit) Viewing Audit Instance List Viewing Audit Instance List Download Focus Mode Font Size Last updated: 2026-04-29 17:45:36 AI-Translated This document describes how to view the instance list of SQL Insight (Database Audit), and explains the field information and relevant operations accessible on the Database Audit instance list page.
Audit instance list tab ﻿ Viewing the audit instance list
1.
Log in to the TencentDB for MySQL console.
2.
On the left sidebar, click SQL Insight (Database Audit).
3.
You will be redirected to the Database Audit > Audit Instance tab by default.
4.
On the Audit Instance tab, you can view the list of tools (for quickly filtering instances, refreshing the tab, and downloading the list information), feature operations, and instance list fields.
Tool list Tool

Description

Filter

You can select resource attributes such as instance ID/name, tag key, and tag in the search box above the audit instance list to filter resources. Separate multiple keywords by vertical bar.

Refresh

You can click ﻿ to refresh the data in the audit instance list.

Download

You can click ﻿ to download the information of the filtered audit instances as a .csv file.
Relevant feature operations Audit Status

Feature

Description

The audit service is enabled.

Disable Audit Service

You can (batch) disable the audit service as instructed in Disabling Audit Service.

Modify Audit Rule

You can (batch) modify audit rules as instructed in Modifying Audit Rule.

Modify Audit Service

You can (batch) modify the audit service items such as audit log retention period and frequent/infrequent access storage periods as instructed in Modifying Audit Service.

View Audit Log

You can query historical audit logs as instructed in Viewing Audit Log.

Configure Log Shipping

You can configure audit log shipping to Cloud Log Service (CLS), TDMQ for Ckafka (CKafka), or Cloud Object Storage (COS). For details, see Log Shipping.

The audit service is disabled

Enabe Database Audit

You can (batch) enable the audit service as instructed in Enabling Audit Service.
Fields in the audit instance list Field

Description

Instance ID/Name

ID/Name information of all instances in a region.

Audit Log Storage Status

Enabling status of audit log storage. You can filter and display instances with audit log storage enabled or disabled at the top of the list.

Audit Mode

The audit rule (full audit or rule-based audit) configured for audit-enabled instances. You can use the drop-down list to filter instances by a specific rule.

Log Retention Period

Total storage period and frequent/infrequent access storage periods in days for audit-enabled instances.

Stored Log Size

Total storage size and frequent/infrequent access storage sizes in MB for audit-enabled clusters/instances.

Audit Rule

The display enumerates the quantity of audit rule templates associated with the instance. When the cursor hovers over the audit rule field of the corresponding instance, you can view the ID and name of each rule template. By clicking on a specific rule template, you can delve into the detailed rule information of that template, which includes basic information, parameter configurations, and modification history.

Log Shipping

Log shipping status of instances.
Disabled: Log shipping is not configured.
CKafka: Log shipping to CKafka is configured.
CLS: Log shipping to CLS is configured.
COS: Log shipping to COS is configured.

Project

Projects of instances to help you categorize and manage resources easily. You can use the drop-down list to filter instances by a specific project.

Tag (key:value)

Tag information of instances

Enablement Time

The time accurate down to the second when the audit service is enabled for instances.

Operation

Available operations when the audit service is enabled:
View Audit Log.
More (Modify Audit Rule, Modify Audit Service, Configure Log Shipping, and Disable Audit Service).
Available operations when the audit service is disabled:
Enable Database Audit.
Previous Topic: SQL Insight (Database Audit) Introduction Next Topic: Enabling Audit Service Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Audit instance list tab Viewing the audit instance list Search AllCurrent Product Search titles only Enter keywords to search documentation
