# Account and Permission

> 来源: https://www.tencentcloud.com/document/product/238/47716

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Account and Permission Account and Permission Download Focus Mode Font Size Last updated: 2026-07-30 17:20:58 AI-Translated How to Manage TencentDB for SQL Server Instance Accounts?
Manage accounts in the SQL Server console. Click the Instance ID to go to the management page, and then perform operations such as Account Creation, account deletion, and account permission modification on the Account Management page. Do not directly operate the database in the SSMS client.
How to Manage TencentDB for SQL Server Databases?
Manage databases in the SQL Server console. Click the Instance ID to go to the management page, and then perform operations such as Database Creation, database deletion, and database permission configuration on the Database Management page. Do not directly operate databases in the SSMS client.
How to Create a TencentDB for SQL Server Account?
Create accounts in the SQL Server console. Do not directly operate databases in the SSMS client. For details, see account creation.
How to Delete a TencentDB for SQL Server Account?
Delete accounts in the SQL Server console. Do not directly operate databases in the SSMS client. For details, see account deletion.
How to Modify TencentDB for SQL Server Account Permissions?
Modify account permissions in the SQL Server console. Do not directly operate databases in the SSMS client. For details, see account permission modification.
How to Create a TencentDB for SQL Server Database?
Create databases in the SQL Server console. Do not directly operate databases in the SSMS client. For details, see database creation.
How to Delete a TencentDB for SQL Server Database?
Delete databases in the SQL Server console. Do not directly operate databases in the SSMS client. For details, see database deletion.
How to Modify TencentDB for SQL Server Database Permissions?
Modify database permissions in the SQL Server console. Do not directly operate databases in the SSMS client. For details, see database permission configuration.
Why Does the System Prompt "Login failed. The Login is from an untrusted domain and cannot be used with Windows authentication" When databases are managed via Microsoft SQL Server Management?
Change the authentication method to "SQL Server Authentication".
Does TencentDB for SQL Server Support Granting the sysadmin Role to Users?
Two-node (formerly HA Edition/Cluster Edition) and multi-node instances: The sysadmin role is not granted to users by default due to potential intrusion risks. If your business requires the sysadmin role, submit a ticket to obtain a solution. When you manage databases through Microsoft SQL Server Management Studio, the system may prompt the message "You must be a member of the sysadmin role to perform this operation." Single-node (formerly Basic Edition) instances: The sysadmin role can be provided for users. Submit a ticket to apply to create an admin account with the sysadmin permission for authorization. Note that the admin account has the highest sysadmin management permission and has owner permissions for all databases. After an admin account is created, the product will no longer guarantee the instance SLA.
How to Create an SA Account for TencentDB for SQL Server?
For TencentDB for SQL Server two-node (formerly HA Edition/Cluster Edition) and multi-node instances, if your business requires the sysadmin role, submit a ticket to obtain a solution. For single-node (formerly Basic Edition) instances, you can submit a ticket to apply to create an admin account with SA permissions for authorization. Note that the admin account has the highest sysadmin management permission and has owner permissions for all databases. After it is enabled, the product will no longer guarantee the instance SLA.
Can I Use a Windows System Account to Connect to TencentDB for SQL Server?
TencentDB for SQL Server instances other than single-node (formerly Basic Edition) do not currently support connecting to the cloud SQL Server using Windows system accounts. For single-node (formerly Basic Edition) instances, if you need to connect using a Windows system account, submit a ticket for assistance.
What to Do If I Forgot the TencentDB for SQL Server Login Password?
Log in to the SQL Server console, click the Instance ID to go to the management page, and choose More > Reset Password in the Operation column on the Account Management page to reset the password. For more information, see Reset Password.
How to Reset the TencentDB for SQL Server Password?
Log in to the SQL Server console, click the Instance ID to go to the management page, and choose More > Reset Password in the Operation column on the Account Management page to reset the password. For more information, see Reset Password.
Why Can't I Create a Database/Table?
The account you logged in with might be a business account that lacks permissions for database/table creation. Grant permissions to this account in the SQL Server console. For details, see database permission configuration.
Why Do I Have No Permission to Modify Database Parameters, Such as blocked process threshold(s)?
The sub-account used by the user may lack permissions to modify instance parameters. Use the root account to perform the operation, or use CAM to grant the sub-account the relevant operation permissions.
Does TencentDB for SQL Server Support Server Access to Folders and Folder Creation Permissions?
TencentDB for SQL Server currently does not support customers accessing or creating folders on the instance server.
Can I View Connection Details for TencentDB for SQL Server?
Users can connect to the instance using SSMS and check the information themselves. If permissions are insufficient, submit a ticket to request assistance in applying for elevated database account permissions.
Can I View the Slow SQL Table for TencentDB for SQL Server?
Log in to the SQL Server console, locate your instance in the instance list, click the Instance ID, and go to the Operation Log page to query and download the slow query log.
The TencentDB for SQL Server slow SQL table is not open to the public by default. You can connect to the instance using SSMS and view it yourself. If permissions are insufficient, submit a ticket to request assistance in applying for elevated database account permissions.
Can I Enable SQL trace Permissions for TencentDB for SQL Server?
Accounts created on the Account Management page in the SQL Server console have SQL trace permission enabled by default.
If you manually create an account by logging into the SSMS client, SQL trace is not supported by default. You can grant the permission yourself using an admin account. The authorization command is: GRANT ALTER TRACE TO [$account];.
Why Do I Have No Permission to Enable profiler for TencentDB for SQL Server?
Accounts created on the Account Management page in the SQL Server console have profiler permission by default. If you manually create an account using the SSMS tool, it does not have this permission. You can grant the permission using the following command: GRANT ALTER TRACE TO [$account];.
Can Accounts Created on the Primary Instance Be Used on Read-Only Instances?
Accounts created on the primary instance are synchronized to read-only instances. Read-only instances cannot manage accounts. On read-only instances, accounts can only perform read operations, not write operations.
Will Permissions Be Automatically Synchronized to Standby and Read-Only Instances After an account is deleted and recreated on the primary instance?
After an account is deleted and recreated on the primary instance in TencentDB for SQL Server, permissions and other modifications in the primary instance are automatically synchronized to the standby instance and read-only instances.
How Are Account Permissions for Two-Node (formerly HA Edition/Cluster Edition) Primary/Secondary Instances Synchronized to Read-Only Instances?
Accounts created on the primary instance of a two-node (formerly HA Edition/Cluster Edition) instance are automatically synchronized to read-only instances. Two-node instances with database editions SQL Server 2017/2019/2022/2025 Enterprise use Always On for synchronization, while those with editions SQL Server 2012/2014/2016 Enterprise use the publish/subscribe method. Accounts created on the primary instance via the console are synchronized to read-only instances in real time. After synchronization is complete, you can use the created login name or modify password permissions on the read-only instance.
Can database accounts be managed at a finer granularity (such as limiting source addresses)?
You can connect to the database and then use commands to grant more granular permissions.
What Account Permissions Are Enabled by Default for TencentDB for SQL Server?
The following account permissions are enabled by default for TencentDB for SQL Server:
Server-level role:
Processadmin manages SQL Server processes.
Dbcreator creates and modifies databases.
Database-level role:
db_owner owns the database and can perform all operations on it.
db_datareader is a user who can view data in user tables across all databases.
db_reader can perform read operations on databases.
db_writer can perform write operations on databases.
Table-level permissions:
Permission

Description

INSERT

Insert the data.

UPDATE

Update the data.

VIEW DEFINITION

View the definition.

VIEW CHANGE TRACKING

View change tracking records.

UNMASK

Remove the mask.

ALTER

Modify the table structure and attributes.

TAKE OWNERSHIP

Take over the ownership.

CONTROL

Full control permission for a table.

DELETE

Delete the data.

SELECT

Query the data.

REFERENCES

Reference permission. A table should be referenced when a foreign key is created.
Previous Topic: Connection and Network Next Topic: Backup and Rollback Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How to Manage TencentDB for SQL Server Instance Accounts?
How to Manage TencentDB for SQL Server Databases?
How to Create a TencentDB for SQL Server Account?
How to Delete a TencentDB for SQL Server Account?
How to Modify TencentDB for SQL Server Account Permissions?
How to Create a TencentDB for SQL Server Database?
How to Delete a TencentDB for SQL Server Database?
How to Modify TencentDB for SQL Server Database Permissions?
Why Does the System Prompt "Login failed. The Login is from an untrusted domain and cannot be used with Windows authentication" When databases are managed via Microsoft SQL Server Management?
Does TencentDB for SQL Server Support Granting the sysadmin Role to Users?
How to Create an SA Account for TencentDB for SQL Server?
Can I Use a Windows System Account to Connect to TencentDB for SQL Server?
What to Do If I Forgot the TencentDB for SQL Server Login Password?
How to Reset the TencentDB for SQL Server Password?
Why Can't I Create a Database/Table?
Why Do I Have No Permission to Modify Database Parameters, Such as blocked process threshold(s)?
Does TencentDB for SQL Server Support Server Access to Folders and Folder Creation Permissions?
Can I View Connection Details for TencentDB for SQL Server?
Can I View the Slow SQL Table for TencentDB for SQL Server?
Can I Enable SQL trace Permissions for TencentDB for SQL Server?
Why Do I Have No Permission to Enable profiler for TencentDB for SQL Server?
Can Accounts Created on the Primary Instance Be Used on Read-Only Instances?
Will Permissions Be Automatically Synchronized to Standby and Read-Only Instances After an account is deleted and recreated on the primary instance?
How Are Account Permissions for Two-Node (formerly HA Edition/Cluster Edition) Primary/Secondary Instances Synchronized to Read-Only Instances?
Can database accounts be managed at a finer granularity (such as limiting source addresses)?
What Account Permissions Are Enabled by Default for TencentDB for SQL Server?
Search AllCurrent Product Search titles only Enter keywords to search documentation
