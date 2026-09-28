# Introduction

> 来源: https://www.tencentcloud.com/document/product/236/15829

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL ​​API Reference Introduction Introduction Download Focus Mode Font Size Last updated: 2026-08-06 16:09:04 Overview

TencentDB for MySQL is a high-performance enterprise-grade database service developed by Tencent Cloud based on the open-source MySQL database. It has 6 enterprise-grade features, including enterprise-grade custom kernel, enterprise-grade high availability, enterprise-grade high reliability, enterprise-grade security, enterprise-grade scaling, and enterprise-grade intelligent Ops. By using TencentDB for MySQL, you can achieve minute-level database deployment, elastic scaling, and fully automated Ops management. It features low cost, high stability, high reliability, and easy Ops. It enables you to set up, operate, and expand relational databases in the cloud more easily.
All TencentDB for MySQL APIs introduced in this chapter comply with the latest OpenAPI 3.0 specification.
You can call APIs to operate TencentDB for MySQL, such as creating TencentDB for MySQL instances (yearly/monthly subscription), querying the instance list, and refreshing the maintenance time window.
For information on all APIs supported by TencentDB for MySQL, see API Overview.

Glossary

For common terms of the TencentDB for MySQL APIs, see the table below.
| Term | Description |
|---------|---------|
| Parameter template | A parameter template is a predefined set of database engine configuration values. TencentDB for MySQL provides multiple system parameter templates for you to choose from, and you can also create custom parameter templates to customize settings according to your business scenarios. |
| Database proxy | A database proxy is a network proxy service between the cloud database service and the application service. It proxies all requests when the application service accesses the database. |
| Database Audit | Database Audit is an audit product that monitors database security in real time, recording cloud database activities and providing fine-grained compliance management for database operations. It also sends alarms for risk behaviors detected in the database. |
| RO group | An RO group is a collection of read-only instances sharing a single address. You can set the weights of read-only instances within the group for traffic load balancing and set the delayed read-only instance removal policy.

Use Limits

For API parameter limits, see the parameter description in each API documentation.

Getting Started with APIs

You can use the API Explorer tool to call APIs online.
Take updating the maintenance time window as an example to introduce the steps for calling an API through the API Explorer tool:

Go to the API Explorer tool page. For more information about API Explorer tool usage, see Using API Explorer.
Call ModifyTimeWindow to update the instance maintenance time window.
After the successful update, when the instance undergoes configuration changes or other operations that may impact it, the system will perform the switch during the configured instance maintenance window.
Previous Topic: History Next Topic: API Category Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Glossary Use Limits Getting Started with APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
