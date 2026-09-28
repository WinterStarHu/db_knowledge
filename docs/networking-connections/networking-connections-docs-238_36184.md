# Creating VPC for TencentDB for SQL Server

> 来源: https://www.tencentcloud.com/document/product/238/36184

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial Creating VPC for TencentDB for SQL Server Creating VPC for TencentDB for SQL Server Download Focus Mode Font Size Last updated: 2024-01-18 17:25:32 Tencent Cloud provides Virtual Private Cloud (VPC), a platform for hosting TencentDB instances. You can launch Tencent Cloud resources in a VPC, such as TencentDB instances.
A common scheme is to share data between a TencentDB instance and a web server running in the same VPC. This document uses this scheme to create a VPC and add a TencentDB instance to it.
This document describes how to add CVM and TencentDB for SQL Server instances in the same VPC for interconnection between Tencent Cloud resources over the private network in the VPC.
Step 1. Create a VPC A VPC has at least one subnet, and Tencent Cloud service resources can only be added in a subnet.
1.
Log in to the VPC Console.
2.
Select the region of the VPC at the top of the list and click +Create.
3.
Enter the VPC information and initial subnet information and click Create. The CIDRs of the VPC and subnet cannot be modified after creation.
The VPC CIDR can be any of the following IP ranges. If you want two VPCs to communicate with each other over the private network, their CIDRs should not overlap:
10.0.0.0 - 10.255.255.255 (mask range required to be between 16 and 28)
172.16.0.0 - 172.31.255.255 (mask range required to be between 16 and 28)
192.168.0.0 - 192.168.255.255 (mask range required to be between 16 and 28)
The subnet CIDR must be within or the same as the VPC CIDR.
For example, if the IP range of a VPC is 192.168.0.0/16, then the IP ranges of subnets in it can be 192.168.0.0/16 or 192.168.0.0/17 for example.
Step 2. Create a subnet You can create one or more subnets at the same time.
1.
Log in to the VPC Console.
2.
Click Subnet on the left sidebar to enter the management page.
3.
Select the region and VPC of the subnet to be created and click +Create.
4.
Enter the subnet's name, CIDR, availability zone, and associated route table.
5.
(Optional) Click +New Line to create multiple subnets at a time.
6.
Click Create.
Step 3. Create a route table and associate it with a subnet You can create a custom route table, edit its routing policy, and associate it with a specified subnet. The routing table associated with the subnet is used to specify outbound routes for the subnet.
1.
Log in to the VPC Console and select Route Tables on the left sidebar.
2.
Select the region and VPC at the top of the list and click +Create.
3.
In the dialog box that pops up, enter the name, network, and new routing policy and click Create. Return to the route table list and you can see the created routing table.
4.
Select Subnet on the left sidebar in the console, select the subnet to be associated with the routing table, and click Change Route Table in the Operation column to associate it.
Step 4. Add a CVM instance
1.
Log in to the VPC Console.
2.
Click Subnet on the left sidebar to enter the management page.
3.
Click the "Add CVM" icon in the row of the subnet where the CVM is to be added.
4.
Complete the purchase of a CVM instance as prompted on the page. For more information, please see Purchase Methods in the CVM documentation.
Step 5. Add a TencentDB instance
1.
Log in to the TencentDB for SQL Server Console and click Create Instance to enter the purchase page.
2.
In the Network Type section on the purchase page, select VPC, choose the previously created VPC and the corresponding subnet, and add the newly purchased TencentDB instance to the VPC.
Previous Topic: Cross-Account Backup Restoration Next Topic: Connecting Kingdee K/3 WISE to TencentDB for SQL Server Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Step 1. Create a VPC Step 2. Create a subnet Step 3. Create a route table and associate it with a subnet Step 4. Add a CVM instance Step 5. Add a TencentDB instance Search AllCurrent Product Search titles only Enter keywords to search documentation
