# Secondary Partition

> 来源: https://www.tencentcloud.com/document/product/236/74155

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Secondary Partition Killing Idle Transactions Automatically Parallel replication Dynamic Thread Pool NOWAIT RETURNING Column compression Flashback Query Recycle Bin Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Kernel Features Functionality Features Secondary Partition Secondary Partition Download Focus Mode Font Size Last updated: 2025-11-14 10:59:24 AI-Translated Feature Description In the MySQL database, partitioning is a technology that allows you to divide a table or index data into multiple logical sections, which can improve query efficiency and reduce maintenance costs. The secondary partition allows for a more fine-grained division of data, enabling the creation of multiple sub-partitions within a single partition, improving data management and query efficiency. TencentDB for MySQL supports the creation of secondary partitions of range or list type.
Supported Versions MySQL 8.0 kernel version 20230630 and later versions.
Applicable Scenario For more fine-grained data management and queries, the secondary partition can be used to improve query efficiency, such as partitioning a large table.
Must-Knows A new syntax for the template, SUBPARTITION TEMPLATE, has been added, ensuring that each sub-partition is defined consistently.
The name format of each sub-partition is: first-level partition name $$ secondary partition name template.
The secondary partition does not support column_list.
It is not supported to truncate all partitions using "truncate ... with global index" currently. To truncate all partitions, you can run "truncate table".
In partitioned tables that contain global indexes, the process of performing the truncate partition operation is consistent with that of the official MySQL, and online DDL is not supported. However, when the truncate partition operation is performed for partitioned tables that contain global indexes, it is required to maintain global indexes, resulting in longer running times. It is recommended to use the delete syntax method instead of truncate.
The $$ character cannot exist in the secondary partition name template.
The drop partition operation requires the rebuilding of the global index. It is recommended to combine multiple drop partition statements into a single statement for execution to reduce the cost associated with maintaining the global index.
It is not recommended to perform operations by running truncate partition, which will block DML.
Use Instructions
1.
Create a table with secondary partitions.
CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name (create_definition,...) [table_options] [partition_options] ﻿

partition_options:
PARTITION BY { [LINEAR] HASH(expr)
| [LINEAR] KEY [ALGORITHM={1 | 2}] (column_list)
| RANGE{(expr) | COLUMNS(column_list)}
| LIST{(expr) | COLUMNS(column_list)} }
[PARTITIONS num] [SUBPARTITION BY { [LINEAR] HASH(expr)
| [LINEAR] KEY [ALGORITHM={1 | 2}] (column_list) }
[SUBPARTITIONS num] ] [SUBPARTITION BY {   RANGE{(expr)}    -- Range-type secondary partition template.
| LIST{(expr)}       -- List-type secondary partition template.
SUBPARTITION TEMPLATE [(subpartition_definition [, subpartition_definition] ...)]} -- Sub-partition template.
] [(partition_definition [, partition_definition] ...)] ﻿

subpartition_definition:
SUBPARTITION logical_name [VALUES { LESS THAN {(expr | value_list) | MAXVALUE} --Range-type sub-partition range.
| IN (value_list)}]  --List-type sub-partition range.
[[STORAGE] ENGINE [=] engine_name] [COMMENT [=] 'string' ] [DATA DIRECTORY [=] 'data_dir'] [INDEX DIRECTORY [=] 'index_dir'] [MAX_ROWS [=] max_number_of_rows] [MIN_ROWS [=] min_number_of_rows] [TABLESPACE [=] tablespace_name] Example:
CREATE TABLE `t1` ( `id` int DEFAULT NULL, `purchased` int DEFAULT NULL, KEY `idx` (`id`,`purchased`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci /*!50100 PARTITION BY RANGE (`id`) SUBPARTITION BY RANGE (`purchased`) SUBPARTITION TEMPLATE (SUBPARTITION s0 VALUES LESS THAN (10) ENGINE = InnoDB, SUBPARTITION s1 VALUES LESS THAN (20) ENGINE = InnoDB) (PARTITION p0 VALUES LESS THAN (10) ENGINE = InnoDB, PARTITION p1 VALUES LESS THAN (20) ENGINE = InnoDB, PARTITION p2 VALUES LESS THAN (30) ENGINE = InnoDB) */;
2.
ALTER TABLE syntax.
-- Secondary partition DDL.
ALTER TABLE tbl_name [alter_option [, alter_option] ...] [partition_options] [subpartition_options] -- Add new subpartition_options.
﻿

subpartition_options:
subpartition_option [subpartition_option] ...
﻿

subpartition_options: { MODIFY PARTITION partition_name TRUNCATE SUBPARTITION TEMPLATE subpartition_template_name; -- Truncate the partitions with the template named subpartition_template_nam in the partition_name.
  | TRUNCATE SUBPARTITION TEMPLATE subpartition_template_name -- Truncate secondary partitions of the subpartition_template_name.
  | ADD SUBPARTITION TEMPLATE subpartition_definitions -- Add a template for subpartition_definitions.
  | DROP SUBPARTITION TEMPLATE subpartition_template_name -- Drop secondary partitions of subpartition_template_name.
} ﻿

-- First-level partition DDL.
ALTER TABLE t1 TRUNCATE p0 WITH GLOBAL INDEX; -- Truncate partition p1. (If sub-partitions exist, truncate all the following sub-partitions.) Example:
-- Secondary partition DDL.
ALTER TABLE t1 MODIFY PARTITION p0 TRUNCATE SUBPARTITION TEMPLATE s1;    -- Truncate secondary partition p0_s1 (first-level partition p0, secondary partition template name s1).
ALTER TABLE t1 TRUNCATE SUBPARTITION TEMPLATE s1; --  Sub-partitions with the suffix of _s1 under all partitions will be truncated.
ALTER TABLE t1 ADD SUBPARTITION TEMPLATE （SUBPARTITION s2 values in (1,2,3,4)); -- Sub-partitions with the suffix of _s2 will be added for all partitions.
ALTER TABLE t1 DROP SUBPARTITION TEMPLATE s2;  -- Sub-partitions with the suffix of _s2 will be deleted for all partitions.
﻿

-- First-level partition DDL.
ALTER TABLE t1 ADD PARTITION (PARTITION p2 VALUES LESS THAN (20));  -- Add a partition. If t1 is a secondary partition table, the template will be used to generate sub-partitions by default.
ALTER TABLE t1 DROP PARTITION p1;
ALTER TABLE t1 TRUNCATE p0 WITH GLOBAL INDEX; -- Truncate partition p1. (If sub-partitions exist, truncate all the following sub-partitions.)
3.
Support new time functions.
tdsql_year, tdsql_month, and tdsql_day will convert time to the formats of YYYY, YYYYMM, and YYYYMMDD. The supported types include DATE/DATETIME/TINYINT/SMALLINT/MEDIUMINT/BIGINT/CHAR/VARCHAR/VARBINARY/timestamp/binary.
When tdsql_year, tdsql_month, and tdsql_day are used as functions in the partition keys, the binary and timestamp types are not supported.
Previous Topic: Version Lifecycle Plan Next Topic: Killing Idle Transactions Automatically Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feature Description Supported Versions Applicable Scenario Must-Knows Use Instructions Search AllCurrent Product Search titles only Enter keywords to search documentation
