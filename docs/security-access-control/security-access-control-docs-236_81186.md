# Handling Primary Key-Related Error Hiding

> 来源: https://www.tencentcloud.com/document/product/236/81186

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Troubleshooting Handling Primary Key-Related Error Hiding Handling Primary Key-Related Error Hiding Download Focus Mode Font Size Last updated: 2026-06-30 16:20:02 AI-Translated This document describes the errors you may encounter when creating tables or modifying primary keys after enabling the hidden primary key feature in TencentDB for MySQL, and the methods for correctly viewing, replacing/removing the hidden primary key, or disabling this feature.
Background TencentDB for MySQL 8.0 kernel minor version 20221215 (Community Edition 8.0.30) and later support the GIPK (Generated Invisible Primary Keys) feature, while TencentDB for MySQL 5.7 does not. If you do not explicitly define a primary key when creating a table, the system automatically adds a hidden primary key named `my_row_id`. After the hidden primary key is added, you may encounter errors if you attempt to define a new primary key using DDL.
Error Message When you define a new primary key in an ALTER TABLE statement, you may encounter the following error:
Error Scenario 1:
Error 1068: Multiple primary key defined.
Error Explanation: The custom primary key conflicts with the hidden primary key.
Error Scenario 2:
Error 1075: Incorrect table definition; there can be only one auto column and it must be defined as a key.
Error Explanation: A conflict occurs between the new auto-increment column and the hidden primary key.
When you define a new primary key in a CREATE TABLE statement, you may encounter the following error:
Error Scenario 3:
Error 4109: Failed to generate invisible primary key. Auto-increment column already exists.
Error Explanation: When GIPK is enabled, the auto-increment column is not defined as the primary key index.
Viewing GIPK Because GIPK has the "hidden column" attribute, you cannot directly view it using show create table. Please use the following method to view the GIPK.
1.
Set the parameter `sql_generate_invisible_primary_key` to ON.
﻿
2.
After the configuration is complete, you can view the hidden primary key `my_row_id` in show create table.
mysql> show create table tb1;
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                                                  |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tb1   | CREATE TABLE `tb1` (
`my_row_id` bigint unsigned NOT NULL AUTO_INCREMENT /*!80023 INVISIBLE */, `id` int DEFAULT NULL, `c` varchar(16) DEFAULT NULL, PRIMARY KEY (`my_row_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ 1 row in set (0.01 sec)
3.
You do not need to disable GIPK when replacing the primary key; simply keep it enabled.
mysql> select @@sql_generate_invisible_primary_key;
+--------------------------------------+
| @@sql_generate_invisible_primary_key |
+--------------------------------------+
|                                    1 |
+--------------------------------------+ 1 row in set (0.00 sec) Replacing GIPK with a Custom Primary Key Upgrading an Existing Column to a Primary Key Operation Description: Designate a field that already exists in the original table as the primary key.
Error SQL Example:
alter table table_name add primary key(id);
Error Details: Error 1068: Multiple primary key defined.
Example of the Table Structure Before Modification: It contains the hidden primary key column `my_row_id`.
mysql> show create table tb1;
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                                                  |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tb1   | CREATE TABLE `tb1` (
`my_row_id` bigint unsigned NOT NULL AUTO_INCREMENT /*!80023 INVISIBLE */, `id` int DEFAULT NULL, `c` varchar(16) DEFAULT NULL, PRIMARY KEY (`my_row_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ 1 row in set (0.01 sec) Modification SQL:
alter table tb1 drop column my_row_id, add primary key(id);
Table Structure After Modification: The hidden primary key `my_row_id` is removed, and `id` becomes the new primary key.
mysql> show create table tb1;
+-------+--------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                         |
+-------+--------------------------------------------------------------------------------------------------------------------------------------+
| tb1   | CREATE TABLE `tb1` (
`id` int NOT NULL, `c` varchar(16) DEFAULT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+--------------------------------------------------------------------------------------------------------------------------------------+ 1 row in set (0.00 sec) Adding a New Primary Key Column Operation Description: Add a new column and designate it as the primary key.
Error SQL Example:
alter table table_name add column new_id bigint primary key;
Related Error: Error 1068: Multiple primary key defined.
Example of the Table Structure Before Modification: It contains the hidden primary key column `my_row_id`.
mysql> show create table tb2;
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                                                  |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tb2   | CREATE TABLE `tb2` (
`my_row_id` bigint unsigned NOT NULL AUTO_INCREMENT /*!80023 INVISIBLE */, `i` int DEFAULT NULL, `c` varchar(16) DEFAULT NULL, PRIMARY KEY (`my_row_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ Modification SQL:
Add a column to replace the GIPK. The new column has no additional requirements. Here, we demonstrate adding a new column named `new_id` with the BIGINT attribute.
alter table table_name drop column my_row_id, add column new_id bigint primary key;
Table Structure After Modification: The hidden primary key `my_row_id` is removed, and `new_id` becomes the new primary key.
mysql> show create table tb2;
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                      |
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tb2   | CREATE TABLE `tb2` (
`i` int DEFAULT NULL, `c` varchar(16) DEFAULT NULL, `new_id` bigint unsigned NOT NULL AUTO_INCREMENT, PRIMARY KEY (`new_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ Adding an Auto-Increment Column Operation Description: Add a new auto-increment column.
Error SQL Example:
alter table table_name add column new_id bigint unsigned not null auto_increment key;
Error Details: Error 1075: Incorrect table definition; there can be only one auto column and it must be defined as a key.
Example of the Table Structure Before Modification: It contains the hidden primary key column `my_row_id`.
mysql> show create table tb3;
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                                                  |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tb3   | CREATE TABLE `tb3` (
`my_row_id` bigint unsigned NOT NULL AUTO_INCREMENT /*!80023 INVISIBLE */, `i` int DEFAULT NULL, `c` varchar(16) DEFAULT NULL, PRIMARY KEY (`my_row_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ Modification SQL: Add an auto-increment column named `new_id` and replace the GIPK.
alter table table_name drop column my_row_id, add column new_id bigint unsigned not null auto_increment key;
Table Structure After Modification: The hidden primary key `my_row_id` is removed, and `new_id` becomes the new primary key.
mysql> show create table tb3;
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                      |
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tb3   | CREATE TABLE `tb3` (
`i` int DEFAULT NULL, `c` varchar(16) DEFAULT NULL, `new_id` bigint unsigned NOT NULL AUTO_INCREMENT, PRIMARY KEY (`new_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ Creating a Table with an Auto-Increment Column Operation Description: Create a table that contains an auto-increment column.
Error SQL Example:
create table table_name ( id bigint unsigned NOT NULL AUTO_INCREMENT UNIQUE KEY, c varchar(16));
Error Details: Error 4109: Failed to generate invisible primary key. Auto-increment column already exists.
Modification SQL: Use the PRIMARY KEY or KEY keyword.
create table table_name  ( id bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY, c varchar(16));
Table Structure After Modification: `id` is the new primary key.
mysql> show create table tb4;
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                      |
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tb4   | CREATE TABLE `tb4` (
`id` bigint unsigned NOT NULL AUTO_INCREMENT, `c` varchar(16) DEFAULT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci | +-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ Creating a Partitioned Table with GIPK Enabled Operation Description: Create a partitioned table without a primary key.
Error SQL Example:
CREATE TABLE tb5 (f1 INT, f2 DATE) PARTITION BY KEY(f2) PARTITIONS 2;
Error Details: Error 1235: This version of MySQL doesn't yet support 'generating invisible primary key for the partitioned tables.
Modification Operation: Set the value of the parameter `sql_generate_invisible_primary_key` to OFF.
References Setting Instance Parameters Previous Topic: Failure to Obtain slow_query_log_file via a Command Next Topic: History Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Background Error Message Viewing GIPK Replacing GIPK with a Custom Primary Key Upgrading an Existing Column to a Primary Key Adding a New Primary Key Column Adding an Auto-Increment Column Creating a Table with an Auto-Increment Column Creating a Partitioned Table with GIPK Enabled References Search AllCurrent Product Search titles only Enter keywords to search documentation
