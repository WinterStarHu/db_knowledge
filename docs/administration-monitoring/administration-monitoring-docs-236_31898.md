# Operation Overview

> 来源: https://www.tencentcloud.com/document/product/236/31898

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL User Guide Operation Overview Operation Overview Download Focus Mode Font Size Last updated: 2026-05-19 11:04:21 AI-Translated This document introduces the operations on the instance list page and management page of the TencentDB for MySQL console, guiding you to easily manage MySQL databases.
Instance List Page On the instance list page of the TencentDB for MySQL console, you can view instance-related information and manage instances.
﻿ Function

Description

Log In

Click Log In in the operation column to log in to the database using the new-generation database tool. For operations, see DMC Overview.

Manage

Click Manage in the operation column to go to the instance management page.

Set Instance Termination Protection

In the operation column, click More > Set Instance Termination Protection to enable or disable instance termination protection. When enabled, it prevents accidental deletion. For operations, see Setting Instance Termination Protection.

Adjust Configurations

Choose More > Adjust Configurations in the operation column to adjust the configuration (scale up or down) of the database instance, including upgrading or downgrading the instance. For detailed operations, see Adjusting Database Instance Specifications. For Cluster Edition instances, you can also quickly add or delete read-only nodes through configuration adjustment. For detailed operations, see Adjusting Instance Configurations.

Upgrade/Migrate

After selecting an instance, click One-Click Upgrade at the top of the instance list, or choose More > Upgrade/Migrate in the operation column. In the pop-up window, you can choose to upgrade the current instance to the Cluster Edition architecture or migrate it to TDSQL-C for MySQL. This operation is supported only for primary instances with the two-node or three-node architecture.

Accelerate in One Click

Choose More > Accelerate in One Click in the operation column. In the pop-up window, you can choose to go to the purchase page for the analysis engine LibraDB or the analysis cluster. This operation is supported only for primary instances with the two-node or three-node architecture.

Upgrade Database Version

For two-node and three-node instances: Click More > Upgrade Version in the operation column to upgrade the database version. For operations, see Upgrading Database Engine Version.
Single-node, cloud disk edition instances: Database engine version upgrades are currently not supported.

Purchase Same Configuration

After the target instance is selected, click More > Purchase same configuration in the operation column to quickly create a new instance with the same configuration as the selected one on the purchase page.

Pay-as-You-go to Yearly/Monthly Subscription

In the operation column, click More > Pay-as-You-Go to Yearly/Monthly Subscription to modify the billing mode of pay-as-you-go instances. For operations, see Pay-as-You-Go to Yearly/Monthly Subscription.

Edit Tag

In the operation column, click More > Edit Tag to edit tags for instance resources. For operations, see Editing Tags.

Terminate Instance

In the operation column, click More > Terminate Instance to self-service terminate the instance. For operations, see Terminating Instances.

Configure Security Group

In the operation column, click More > Configure Security Group to configure security groups for the instance or modify its security groups. For operations, see Managing Cloud Database Security Groups.

Create Instance

Above the instance list, select Create Instance to be redirected to the purchase page for creating an instance. For operations, see Creating a MySQL Instance.

Renew

After selecting the target instance, click Renew at the top of the instance list to manually renew the instance. Click the three dots next to renewal to Enable Auto-Renewal or Disable Auto-Renewal. For detailed operations, see Renewal Instructions.

Restart

After selecting the target instance(s), at the top of the instance list, click Restart to restart the instance(s). Batch restart is supported (select multiple instances).
During the restart, the instance will be inaccessible and existing connections may be interrupted. Please make preparations in advance to prevent any impact.
During the restart, if the write traffic is high and excessive dirty pages accumulate, the restart may fail. Upon failure, the instance reverts to its pre-restart state and remains accessible.
Ensure to restart during off-peak hours to guarantee a successful restart and minimize the impact on your business.

Roll Back

After the target instance is selected, choose More > Roll Back at the top of the instance list to restore the database to a specific point in time using backups. For operations, see Database Roll Back.

Parameter Settings

After selecting the target instance(s), choose More > Parameter Settings at the top of the instance list to modify the parameter values of the instance(s). Batch configuration is supported (select multiple instances). For operations, see Setting Instance Parameters.

Assign to Project

After selecting the target instance, choose More > Assign to Project at the top of the instance list to assign instances to different projects for management. For detailed operations, see Assigning Instances to Projects.

Quick Check

At the top of the instance list, select Quick Check to navigate to the DBbrain console. Here you can view the health status of instances under your account and perform diagnostic optimization. For details, see MySQL Diagnosis and Optimization.

Comparative Monitoring

At the top of the instance list, after selecting 2 to 6 target instances, choose Comparative Monitoring to view and compare the monitoring status of multiple instances in the pop-up window on the right side of the console.
Instance Management Page Log in to the TencentDB for MySQL console. On the instance list page, click an Instance ID or Manage in the Operation column to go to the instance management page. You can switch between tabs to view instance details, instance monitoring, account management, database management, security groups, backup and recovery, log center, read-only instances, database proxies, data security, and connection check.
﻿ Feature Page

Feature Item

Description

Instance Details

Viewing instance health status

On the right side of the page, you can view the health status of the instance. Click Quick Check to jump to the DBbrain diagnosis and optimization page for diagnostic analysis. You can also view the alarms of the instance. Click the number of an alarm to view the abnormal events of the current instance in the sidebar.

Setting instance maintenance time

The system performs maintenance on instances during the maintenance window at irregular intervals. For operations, see Setting Instance Maintenance Time.

Assigning instances to projects

Assign instances to different projects for management. For operations, see Assigning Instances to Projects.

SQL Insight

SQL Insight is the original Database Audit service. After it is enabled, the system will record database access and SQL statement execution. For details, see Introduction to SQL Insight (Original Database Audit).

Adjusting Database Instance Specifications

Quickly adjust instance specifications through the console for flexible scaling.
For operations on single-node, dual-node, and triple-node instances, see Adjusting Database Instance Specifications.
For operations on Cloud Disk Edition instances, see Adjusting Instance Configurations.

Modifying the port number

Supports modifying the port number of the instance's private network address.
For operations on single-node, dual-node, and triple-node instances, see Modifying the Port Number.
For operations on Cloud Disk Edition instances, see Read-Write Address Management and Read-Only Address Management.

Migrate to New AZ

Migrate the TencentDB for MySQL instance to other AZs within the same region. For operations, see Migrating Instances to Other AZs.

Source/Replica Switch

Switching between the primary and secondary databases of an instance.
For operations on dual-node and triple-node instances, see Primary-Secondary Switch.
For operations on Cloud Disk Edition instances, see Primary-Secondary Switch.

Elastic CPU Expansion

It supports automatic and custom scale-out of the CPU upper limit of the current instance. For detailed operations, see CPU Elastic Scale-out. This feature is supported only for general edition two-node, general edition three-node, and single-node local disk (read-only instance) architecture instances. Single-node (cloud disk), two-node economical, and Cluster Edition architecture instances do not support this feature.

Managing disaster recovery instances

Dual-node and triple-node instances support creating disaster recovery instances. For operations, see Managing Disaster Recovery Instances. Single-node and Cloud Disk Edition instances do not support creating disaster recovery instances.

Network switch

Modifying the private network of an instance.
For operations on single-node, dual-node, and triple-node instances, see Switching Networks.
For operations on Cloud Disk Edition instances, see Read-Write Address Management and Read-Only Address Management.

Upgrading the database version

To upgrade the database major version, see Upgrading the Database Version of MySQL 5.5 and MySQL 5.6 and Upgrading from MySQL 5.7 to MySQL 8.0. To upgrade the database kernel minor version, see Upgrading the Kernel Minor Version.

Upgrading the architecture

A two-node instance can be upgraded to a three-node instance. For details, see Upgrading Two-Node Instances to Three-Node Instances.

One-click upgrade

Click One-Click Upgrade at the top of the page. In the pop-up window, you can choose to upgrade the current instance to the Cluster Edition architecture or migrate it to TDSQL-C for MySQL. This operation is supported only for primary instances with the two-node or three-node architecture.

Accelerate in One Click

Click One-Click Acceleration at the top of the page. In the pop-up window, you can choose to go to the purchase page for the analysis engine LibraDB or analysis cluster. This operation is supported only for primary instances with the two-node or three-node architecture.

Enabling public network connection address

For operations, see Enable public network connection address.

Methods to Modify Data Replication

Set the data replication mode of the instance according to the business characteristics to improve TencentDB availability. For operations, see Modifying the Data Replication Mode.

Instance Monitoring

You can view the monitoring of numerous core metrics for the current database operation, categorized by dimensions such as access, load, query cache, tables, InnoDB, and MyISAM. For details, see Monitoring feature and Alarm feature. The Cloud Disk Edition instance supports switching nodes on the instance monitoring page to view monitoring status. For operations, see Viewing instance monitoring.

Database Management

Database List

The DMC console can create new databases and tables, manage databases, import/export data, and support SQL Window, among other features. For operations, see DMC Management.

Parameter Settings

You can view and modify some parameters through the console, and you can also query the parameter modification history in the console.
Set instance parameters.
Use parameter template.
Compare different template parameters.
For operations on 4-core and above single-node, dual-node, and three-node instances, refer to Intelligent parameter tuning. The Cloud Disk Edition instances currently do not support intelligent parameter tuning.

Account Management

You can manage the system-default root account and create and manage new accounts.
Create account.
Set password complexity.
Reset password.
Modify account permissions.
Modify the host address for authorized access.
Delete account.

Security Group

You can configure security groups for your database. For the operation, see Manage Cloud Database Security Group.

Backup and recovery

Back up a database

You can back up your database using automatic or manual backup. For the operation, see Back Up Databases.

Configuring transition-to-cold storage

Support transitioning backup files to cold storage to reduce backup storage costs.
For operations on dual-node and three-node instances, see Configuring Transition-to-Cold Storage.
Single-node and cloud disk edition instances do not currently support setting transition-to-cold storage.

Cross-Region Backup

Supports storing backup files in another region.
For operations on dual-node, three-node, and cloud disk edition instances, see Cross-Region Backup.
Single-node instances do not currently support cross-region backup.

Backup Encryption

Supports encrypting physical backups and log backups (binlog).
For operations on dual-node and three-node instances, see Backup Encryption.
Single-node and cloud disk edition instances do not currently support backup encryption.

Setting backup download rules

Configuring download restrictions for backups.
For operations on dual-node and three-node instances, see Setting Backup Download Rules.
Single-node and cloud disk edition instances do not currently support setting backup download rules.

Viewing backup space

To view the backup space and free tier of an instance, see Viewing Backup Space.

Setting local Binlog retention

To set the binlog retention period for an instance, see Setting Local binlog Retention. Note that single-node instances do not support setting local binlog retention.

Restoring a database using physical backup

Dual-node and three-node instances support using the XtraBackup tool to restore MySQL physical backup files to self-built databases on other hosts. For operations, see Restoring the Database Using Physical Backup.

Restoring a database using logical backup

Dual-node and three-node instances support manually restoring data using logical backup files. For operations, see Restoring a Database Using Logical Backup.

Downloading a backup

Dual-node and three-node instances support downloading logical backups and physical backups. For operations, see Downloading Backup Files. Snapshot backups for single-node and cloud disk edition instances are not downloadable.

Rolling back a database

Data corruption can be repaired by rolling back the database. For operations, see Rolling Back a Database.

Deleting a backup

Manual backups for dual-node and three-node instances can be deleted. For operations, see Deleting Backups.

Cloning an instance

Users can be assisted to quickly roll back an instance to a newly purchased MySQL instance. For operations, see Instance Cloning.

Log Center

Cloud disk edition instances can view slow logs, error logs, audit logs, and rollback logs, and can perform log shipping. For operations, see Operations Logs and Log Shipping.
Dual-node, three-node, and read-only instances allow you to view slow logs, error logs, audit logs, SQL analysis, rollback logs, and scaling-out history, and to perform log shipping. For operations, see Operations Logs, Audit Logs and SQL Analysis, and Log Shipping.
Single-node instances can view slow logs and error logs. For operations, see Operations Logs.

Read-Only Instance

Read-only instaCreating a read-only instancence creation

Create one or multiple read-only instances to support read-write separation and use cases with one primary node and multiple secondary nodes.
For dual-node and three-node instances, see Read-only Instance Creation.
Cloud disk edition instances can create 1-5 read-only nodes. For operations, see Adding Instance Nodes.
Cloud disk edition instances can also create 1-15 independent read-only instances. For operations, see Read-only Instance Creation.

Managing the RO group of read-only instance

Dual-node and three-node instances support managing RO groups of read-only instances. For operations, see Managing RO Groups of Read-Only Instances.

Managing delayed replication of read-only instance

Dual-node and three-node instances support managing delayed replication for read-only instances. For operations, see Managing Delayed Replication for Read-only Instances.

Database Proxy

Used to proxy requests from application servers to access databases, providing advanced features such as automatic read-write separation, connection pooling, and connection keep-alive. Single-node and cloud disk edition instances do not support database proxies. For operations on dual-node and three-node instances, see Database Proxy Overview.

Data Security

Enabling Transparent Data Encryption (TDE)

Dual-node and three-node instances support enabling transparent data encryption. For operations, see Enabling Transparent Data Encryption.

Setting SSL encryption

Dual-node and three-node instances support SSL Encryption Settings. For operations, see SSL Encryption Settings.

Connection Check

The tool can detect potential connection access issues in cloud databases and resolve them based on the provided solutions to ensure normal access to your cloud database. For operations, see One-Click Connection Check Tool.
Previous Topic: Use Limits Next Topic: Viewing instance health status Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance List Page Instance Management Page Search AllCurrent Product Search titles only Enter keywords to search documentation
