# FAQ Overview

> 来源: https://www.tencentcloud.com/document/product/238/47719

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs FAQ Overview FAQ Overview Download Focus Mode Font Size Last updated: 2026-06-09 17:53:15 AI-Translated This document lists common issues you may encounter when TencentDB for SQL Server is used, helping you quickly find and obtain solutions.
Note:
This document covers a wide range of issues. You can search for relevant documentation using the search box or press Ctrl + F on this page to search for keywords. If the content does not address the issue you need to resolve, please submit a ticket to contact customer service for assistance.
Purchase Consultation How to choose an architecture for TencentDB for SQL Server How to choose an architecture and edition for TencentDB for SQL Server if your business requires read-only operations What is the performance of TencentDB for SQL Server What specifications does TencentDB for SQL Server support How to choose a specification for TencentDB for SQL Server In which regions is TencentDB for SQL Server supported What versions does TencentDB for SQL Server support What is the version compatibility of TencentDB for SQL Server What features does TencentDB for SQL Server support What are the differences in features supported by different versions of TencentDB for SQL Server Is there a limit on the number of databases for a TencentDB for SQL Server instance? What is the maximum number of databases that can be created Does TencentDB for SQL Server support real-time hot standby What application scenarios is TencentDB for SQL Server suitable for What high availability and disaster recovery capabilities does TencentDB for SQL Server have What are the product advantages of TencentDB for SQL Server Compared to a self-built SQL Server database, what advantages does TencentDB for SQL Server have How to migrate data to TencentDB for SQL Server Billing and Purchase What is the pricing for TencentDB for SQL Server How to purchase TencentDB for SQL Server Do I need to purchase a SQL Server license myself Does TencentDB for SQL Server have genuine Microsoft licensing What is the renewal process for TencentDB for SQL Server How to request a refund for a TencentDB for SQL Server instance purchased in the wrong region What happens when a TencentDB for SQL Server instance expires and enters arrears What is the difference between the yearly/monthly subscription and pay-as-you-go billing methods Can the yearly/monthly subscription and pay-as-you-go billing methods be converted to each other What is the impact on your business when you convert a TencentDB for SQL Server instance from pay-as-you-go to yearly/monthly subscription, and how is it billed Are there any differences in the features supported by the yearly/monthly subscription and pay-as-you-go billing methods Are pay-as-you-go TencentDB for SQL Server instances charged when they are not in use What should I do if the inventory of TencentDB for SQL Server instances in an AZ is insufficient How do I view the billing details for TencentDB for SQL Server How to terminate a TencentDB for SQL Server instance Can a terminated TencentDB for SQL Server instance be recovered Can TencentDB for SQL Server instances in the same region but different AZs communicate with each other via the private network If a CVM and a TencentDB for SQL Server instance are in different AZs within the same region, can they communicate with each other? What is the latency Can the region of a TencentDB for SQL Server instance be modified Can the AZ of a TencentDB for SQL Server instance be modified Should I deploy a TencentDB for SQL Server High Availability instance in a single AZ or across multiple AZs How to purchase a multi-AZ TencentDB for SQL Server instance.
How to upgrade a single-AZ TencentDB for SQL Server instance to multi-AZ.
How to restart a TencentDB for SQL Server instance.
How to view and manage a TencentDB for SQL Server instance.
What tags can be used to facilitate the classification and management of TencentDB for SQL Server resources What is the purpose of a TencentDB for SQL Server instance name, and how to modify it.
What is the purpose of remarks for a TencentDB for SQL Server instance, and how to set them.
What is the purpose of Tags for a TencentDB for SQL Server instance, and how to set them.
What is the purpose of the project for a TencentDB for SQL Server instance, and how to set the project to which the instance belongs.
Connectivity and Networking How to create a TencentDB for SQL Server instance and connect to the database How to connect to TencentDB for SQL Server How to access TencentDB for SQL Server from a CVM via the private network What should be noted when a CVM and TencentDB for SQL Server are interconnected via the private network How to view the private network address of a TencentDB for SQL Server instance How to access a TencentDB for SQL Server instance under another Tencent Cloud root account from a CVM How to achieve private network interconnection between a CVM and a TencentDB for SQL Server instance that belong to the same Tencent Cloud root account but are located in different regions How to achieve private network interconnection between a CVM and a TencentDB for SQL Server instance that belong to the same Tencent Cloud root account and are located in the same region but reside in different VPCs How to achieve private network interconnection between a CVM and a TencentDB for SQL Server instance that belong to the same Tencent Cloud root account and are located in the same region but have different network types How to achieve private network interconnection between a CVM and a TencentDB for SQL Server instance that belong to the same Tencent Cloud root account and are located in different AZs within the same region Can a CVM and a TencentDB for SQL Server instance that belong to the same Tencent Cloud root account and are located in different AZs within the same VPC be connected via the private network How to access TencentDB for SQL Server from a local server How to connect to TencentDB for SQL Server without a Tencent Cloud CVM How to change the VPC network for a TencentDB for SQL Server instance, that is, switch from VPC A to VPC B How to switch a TencentDB for SQL Server instance between the basic network and a VPC How to migrate a TencentDB for SQL Server instance from the basic network to a VPC.
How to use SSH2 port mapping to manage a TencentDB for SQL Server instance over the public network.
Does the application need to support automatic reconnection to TencentDB for SQL Server Can the standby instance of TencentDB for SQL Server be accessed Does switching between primary and secondary affect the connection address How to configure the security group for TencentDB for SQL Server.
Does the security group for TencentDB for SQL Server support network control for the basic network When an inbound rule is added to a security group, is the SQL Server (1433) port supported as a type How to set the maintenance window for a TencentDB for SQL Server instance.
Will the network be disconnected during TencentDB for SQL Server maintenance How to diagnose connection failures to TencentDB for SQL Server.
How to handle connection failures to TencentDB for SQL Server.
Account and Permission How to manage accounts for a TencentDB for SQL Server instance.
How to manage databases in TencentDB for SQL Server.
How to create an account in TencentDB for SQL Server.
How to delete an account in TencentDB for SQL Server.
How to modify account permissions in TencentDB for SQL Server.
How to create a database in TencentDB for SQL Server.
How to delete a database in TencentDB for SQL Server.
How to modify database permissions in TencentDB for SQL Server.
Why does the system display the message "Login failed. The login is from an untrusted domain and cannot be used with Windows authentication" when databases are managed via Microsoft SQL Server Management Studio?
Does TencentDB for SQL Server support granting the sysadmin role to users?
How to create an account with SA permissions in TencentDB for SQL Server.
Can Windows system accounts be used to connect to TencentDB for SQL Server?
What to do if you forget the login password for TencentDB for SQL Server.
How to reset the password for TencentDB for SQL Server.
Why is database/table creation failing?
Why do I lack the permission to modify database parameters, such as blocked process threshold(s)?
Can the server hosting TencentDB for SQL Server be granted permissions to access and create folders?
Can connection details be viewed in TencentDB for SQL Server?
Can slow SQL tables be viewed in TencentDB for SQL Server?
Can SQL Trace tracking permissions be enabled in TencentDB for SQL Server?
Why is there no permission to enable Profiler in TencentDB for SQL Server?
Can accounts created on the primary instance be used on read-only instances?
After an account on the primary instance is deleted and recreated, are its permissions automatically synchronized to the standby and read-only instances?
How are account permissions from primary/replica instances of the High Availability and Cluster Editions synchronized to read-only instances?
Can database accounts enable more granular management, such as restricting source addresses and table access?
What account permissions are enabled by default in TencentDB for SQL Server?
Backup and Restore How to back up TencentDB for SQL Server.
How to set up automatic backup.
How to create a manual backup.
How to view and modify the backup policy.
How long can TencentDB for SQL Server retain backups?
Can backups be deleted manually?
Can data and log backups be disabled?
Why can't I initiate a manual backup task?
How to cancel a backup task.
Is the database available during the backup window?
How to back up a single database in TencentDB for SQL Server.
How to configure backup tasks to run on the read-only instance for TencentDB for SQL Server.
How to download backup files for TencentDB for SQL Server.
Can TencentDB for SQL Server be backed up using third-party tools?
Can backups that have exceeded the retention period still be downloaded or restored?
Can backups for isolated instances still be downloaded?
Are backup files retained after a TencentDB for SQL Server instance is deleted?
How is backup storage billed for TencentDB for SQL Server?
What should I do if the free backup storage quota is exceeded?
How to reduce backup storage costs for TencentDB for SQL Server.
How to view backup storage usage for TencentDB for SQL Server.
How to roll back a TencentDB for SQL Server instance.
How to clone a database on a TencentDB for SQL Server instance.
What are downloaded data backups and log backups used for?
Can a downloaded backup be restored to another TencentDB for SQL Server instance?
How to restore a backup from a local self-built database to TencentDB for SQL Server.
Does TencentDB for SQL Server support restoring to a self-built database after a full backup?
What is the difference between directly uploading a backup and downloading a backup from COS during cold backup migration?
During cold backup migration, if I upload a backup file directly, will the uploaded backup file occupy my own backup storage space?
Data Migration How to migrate data to TencentDB for SQL Server.
How to migrate a self-built SQL Server from a local IDC to TencentDB for SQL Server.
How to restore a backup from a local self-built database to TencentDB for SQL Server.
I have purchased a Tencent Cloud SQL Server database. How do I restore my local .bak backup to the cloud?
How to migrate a self-built SQL Server on a Tencent Cloud CVM to TencentDB for SQL Server.
How to migrate a self-built SQL Server on another cloud provider's CVM to TencentDB for SQL Server.
How to migrate a cloud database for SQL Server instance from another cloud provider to TencentDB for SQL Server.
How to migrate a TencentDB for SQL Server dual-node (formerly HA Edition/Basic Edition) instance to a TencentDB for SQL Server single-node (formerly Basic Edition) instance.
How to migrate a TencentDB for SQL Server single-node (formerly Basic Edition) instance to a TencentDB for SQL Server dual-node (formerly HA Edition/Basic Edition) instance.
How to migrate a TencentDB for SQL Server dual-node (formerly HA Edition/Basic Edition) instance to another edition of TencentDB for SQL Server dual-node (formerly HA Edition/Basic Edition) instance.
Does TencentDB for SQL Server support cross-account migration?
Does TencentDB for SQL Server support heterogeneous migration?
Does TencentDB for SQL Server support data synchronization between self-built databases and the cloud?
How to connect Kingdee K/3 WISE to TencentDB for SQL Server.
What are the considerations before migrating to the cloud using DTS?
What are the considerations during the migration to the cloud using DTS?
What are the considerations after the migration to the cloud using DTS is completed?
Publishing/subscription Does TencentDB for SQL Server support publish/subscription?
Does TencentDB for SQL Server Single-node (formerly Basic Edition) support publish/subscription?
How to set up publish/subscription between a self-built SQL Server in a local IDC and TencentDB for SQL Server?
What are the use cases for the TencentDB for SQL Server publish/subscription feature?
What are the prerequisites for using the TencentDB for SQL Server publish/subscription feature?
How to create a publish/subscription in TencentDB for SQL Server.
How to delete the publish/subscribe relationship between two SQL Server databases?
Read-only instances How to view read-only instances in TencentDB for SQL Server.
Does TencentDB for SQL Server support read/write separation?
How to create a read-only instance in TencentDB for SQL Server.
How to create a read-only instance RO group in TencentDB for SQL Server.
What is the replication latency from the primary database to read-only instances in TencentDB for SQL Server?
Are there differences between read-only instances of different editions? How to choose an edition for TencentDB for SQL Server if your business requires read-only operations?
Can accounts created on the primary instance be used on read-only instances?
What is the maximum number of read-only instances that can be created for a single primary instance in TencentDB for SQL Server?
Does TencentDB for SQL Server support migrating data to read-only instances?
Does a TencentDB for SQL Server read-only instance support creating/deleting databases?
Does a TencentDB for SQL Server read-only instance support creating/deleting accounts?
Does a TencentDB for SQL Server read-only instance support backup and rollback?
Do I need to re-enable load balancing after customizing weights for TencentDB for SQL Server?
Version/Architecture Upgrade Does TencentDB for SQL Server support changing from dual-node (formerly HA Edition/Cluster Edition) to single-node (formerly Basic Edition)?
Does TencentDB for SQL Server support version upgrades?
Does TencentDB for SQL Server support version downgrades?
Disk Scaling and Specification Adjustment What configuration adjustments does TencentDB for SQL Server support?
Is disk scaling supported for TencentDB for SQL Server?
Are CPU/memory specifications for TencentDB for SQL Server upgradeable/downgradeable?
Is the service continuously available during a specification change for a TencentDB for SQL Server single-node (formerly Basic Edition) instance?
Will the service be interrupted during a specification change for a TencentDB for SQL Server dual-node (formerly HA Edition/Cluster Edition) instance?
What is the process for disk scaling and specification upgrade/downgrade for TencentDB for SQL Server?
How are fees calculated for disk scaling and specification upgrade/downgrade for TencentDB for SQL Server?
When upgrading the primary instance configuration, are read-only instance configurations upgraded automatically?
Monitoring and Alarms33 How to view monitoring for a TencentDB for SQL Server instance Where can I view monitoring charts for TencentDB for SQL Server?
What monitoring metrics does TencentDB for SQL Server support?
How to set an alarm policy for TencentDB for SQL Server How to associate alarm objects with a TencentDB for SQL Server alarm policy How to set alarm notifications for TencentDB for SQL Server How to view alarm history for TencentDB for SQL Server What is the minimum monitoring granularity for TencentDB for SQL Server?
Which monitoring metrics should users typically focus on for TencentDB for SQL Server instances?
Logs What is the slow query collection threshold for TencentDB for SQL Server?
Is the slow query collection threshold for TencentDB for SQL Server modifiable?
Does the slow query log for TencentDB for SQL Server occupy user space?
Can slow SQL tables be viewed in TencentDB for SQL Server?
How to analyze slow SQL for TencentDB for SQL Server Are transaction logs for TencentDB for SQL Server automatically cleaned up?
Does TencentDB for SQL Server support viewing audit logs?
Does TencentDB for SQL Server support viewing error logs?
How to obtain error logs for TencentDB for SQL Server via commands?
Parameter Modification How to modify the time zone for TencentDB for SQL Server How to modify the character set collation rule for TencentDB for SQL Server How to modify configuration parameters for TencentDB for SQL Server Which parameters can be quickly modified via the TencentDB for SQL Server console?
How to view the parameter modification history for TencentDB for SQL Server Feature-Related FAQs Does TencentDB for SQL Server support manual switch between primary and secondary?
Can TencentDB for SQL Server currently access other heterogeneous databases?
Does TencentDB for SQL Server support data import operations such as BULK INSERT?
Does TencentDB for SQL Server support msdtc?
Does TencentDB for SQL Server support audit configuration?
Encryption methods for TencentDB for SQL Server Can TencentDB for SQL Server scan security system vulnerabilities on the Server where it resides?
Can maintenance plans be used with TencentDB for SQL Server?
Can folders be created within the server using TencentDB for SQL Server?
How to enable or disable Change Data Capture (CDC) for TencentDB for SQL Server How to enable or disable Change Tracking (CT) for TencentDB for SQL Server How to shrink a database in TencentDB for SQL Server.
How many databases can be created on a single instance of each TencentDB for SQL Server edition?
Is there a limit on the number of tables for a single TencentDB for SQL Server instance?
What is the storage path for databases created on TencentDB for SQL Server?
Does TencentDB for SQL Server support the reporting services feature?
What are the constraints and limitations on feature usage for TencentDB for SQL Server?
Performance/Space/Memory How long does it take to create a TencentDB for SQL Server instance?
Is there a limit on the number of databases for a TencentDB for SQL Server instance? What is the maximum number of databases that can be created Is there an upper limit on the IOPS for TencentDB for SQL Server Why is there a monitor database in TencentDB for SQL Server by default?
How to track deadlocks in TencentDB for SQL Server How to view memory usage for a TencentDB for SQL Server instance How to view memory usage for each database in a TencentDB for SQL Server instance Why is memory usage consistently high in the TencentDB for SQL Server monitoring metrics?
How to view storage space usage for a TencentDB for SQL Server instance After a SQL Server database is created, why does the storage space monitoring show that 500 MB of data is already occupied, even though no or very little data has been written?
Why does storage space not decrease after data is deleted in TencentDB for SQL Server?
What happens if the data volume exceeds the maximum storage capacity of a TencentDB for SQL Server instance?
What are the common causes of disk overuse for a TencentDB for SQL Server instance?
What to do if the data volume exceeds the maximum storage capacity of a TencentDB for SQL Server instance?
Can SQL Server storage space be scaled out directly? Is data migration required? What are the impacts of scaling out?
Is disk scaling in supported for TencentDB for SQL Server?
What are the components of the disk space for the purchased TencentDB for SQL Server?
What are the disk space requirements for DDL operations?
How to view the data file size of a business database in TencentDB for SQL Server How to view the size and status of the log files for a business database in TencentDB for SQL Server How to view the size of tables in a TencentDB for SQL Server database How to reclaim table space in TencentDB for SQL Server How to avoid a sudden surge in data disk space caused by a large volume of data being pushed into a TencentDB for SQL Server instance within a short period?
How to resolve slow query performance in TencentDB for SQL Server How to troubleshoot high CPU utilization issues in TencentDB for SQL Server How to view current connections and their executing SQL in TencentDB for SQL Server How to analyze and handle blocking issues in TencentDB for SQL Server Previous Topic: Error Codes Next Topic: Purchase Consultation Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Purchase Consultation Billing and Purchase Connectivity and Networking Account and Permission Backup and Restore Data Migration Publishing/subscription Read-only instances Version/Architecture Upgrade Disk Scaling and Specification Adjustment Monitoring and Alarms33 Logs Parameter Modification Feature-Related FAQs Performance/Space/Memory Search AllCurrent Product Search titles only Enter keywords to search documentation
