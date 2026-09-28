# Connecting Kingdee K/3 WISE to TencentDB for SQL Server

> 来源: https://www.tencentcloud.com/document/product/238/36823

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial Connecting Kingdee K/3 WISE to TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Download Focus Mode Font Size Last updated: 2026-06-10 11:53:29 AI-Translated This document describes how to connect Kingdee K/3 WISE 15.0/15.1 to TencentDB for SQL Server, enabling the execution of distributed transactions between the SQL Server instance and the Windows CVM.
The solution is primarily divided into the following three steps:
1.
Migrate data to TencentDB for SQL Server by backing up and recovering the full data of the local Kingdee K/3 WISE account database to the cloud database.
2.
Enable distributed transactions by adjusting the access settings for TencentDB for SQL Server and the Windows CVM to ensure that the ports are open and distributed transactions can be executed.
3.
Replace the account management tool to ensure compatibility with TencentDB for SQL Server.
Note:
Configuring distributed transactions requires additional resources. Therefore, this feature is only supported on High Availability Edition instances with a specification of "1-core 8GB" or higher. Please upgrade your instance specification before enabling this feature.
To adjust the access settings for TencentDB for SQL Server and enable distributed transactions, you can submit a ticket for assistance from Tencent engineers. Before submitting the ticket, ensure that you have read this document in its entirety and have completed the "Migrate data to TencentDB for SQL Server" operation to improve processing efficiency.
Step 1: Migrating Data to TencentDB for SQL Server Prerequisite: You have backed up the full data of the local Kingdee K/3 WISE account database.
1.
Log in to the Windows CVM and install Kingdee K/3 WISE.
Note:
The CVM on which Kingdee is installed must reside in the same region and VPC as the TencentDB for SQL Server instance.
2.
Create a TencentDB for SQL Server instance.
3.
Upload the full backup file and complete data recovery. For detailed steps, see Upload Backup to COS and Migrate Data via COS Source File.
4.
Create and authorize a TencentDB for SQL Server account. For details, see Account Creation.
Step 2: Enabling Distributed Transactions Configuring TencentDB for SQL Server To adjust the access settings for TencentDB for SQL Server and enable distributed transactions, you can submit a ticket for assistance from Tencent engineers.
Configuring CVM Setting a security group
1.
Log in to the CVM console, select the region where your instance is located, click the instance ID, and go to the management page.
2.
Select the Security Group page, edit the rules, and configure them as follows:
You can obtain the "source" IP address information by submitting a ticket.
For the "Protocol & Port" of both inbound and outbound rules, ports 1433, 135, and 1024-65535 must be opened.
Configuring Windows
1.
Log in to the Windows CVM.
2.
Open the hosts file. Its path is C:\\Windows\\System32\\drivers\\etc\\hosts.
3.
Enter the VIP and host information provided by TencentDB for SQL Server (which you can obtain by submitting a ticket) at the end of the hosts file, and then save the file.
4.
Open Component Services from Control Panel > System and Security > Administrative Tools.
5.
Choose Component Services > Computer > My Computer > Distributed Transaction Coordinator.
6.
Right-click the local DTC on the right and select Properties.
7.
Select the Security tab, configure it as shown in the following figure, and click OK.
8.
In the MSDTC service dialog box that pops up, click Yes and wait for the MSDTC service to restart.
Step 3: Initializing Account Set Management
1.
Download the corresponding account set management tool: Kingdee K/3 WISE 15.1 and Kingdee K/3 WISE 15.0.
Note:
Different Kingdee K/3 WISE versions require different account set management tools.
2.
Extract and replace the files to the Kingdee installation directory K3ERP\\KDSYSTEM\\KDCOM.
3.
Open the Kingdee K/3 WISE software.
4.
On the Account Set Management Database Settings page that pops up, configure the relevant authentication information and data server.
Note:
Enter the private network address of the TencentDB for SQL Server instance in the data server. You can view the private network address in the console.
5.
In the "System" drop-down menu, click Preset Connection to set it up for convenient use.
6.
In the database drop-down menu, click Register Account Set.
7.
Select the corresponding database and click All.
Step 4: Logging In to Use Kingdee K/3 WISE After all configurations are completed, distributed transactions are supported between the CVM and TencentDB for SQL Server, and you can log in to and use Kingdee K/3 WISE normally.
If you encounter the following error message during login:
Transaction creation by the middle tier failed. Please contact the system administrator. Advanced display: Error code:5(5H) Previous Topic: Creating VPC for TencentDB for SQL Server Next Topic: Account Permissions and Permission Control Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Step 1: Migrating Data to TencentDB for SQL Server Step 2: Enabling Distributed Transactions Configuring TencentDB for SQL Server Configuring CVM Step 3: Initializing Account Set Management Step 4: Logging In to Use Kingdee K/3 WISE Search AllCurrent Product Search titles only Enter keywords to search documentation
