# Switching from Classic Network to VPC

> 来源: https://www.tencentcloud.com/document/product/238/46498

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Switching from Classic Network to VPC Changing Network Enabling/Disabling Public Network Address Enabling Public Network Access Through CLB CAM Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Network and Security Switching from Classic Network to VPC Switching from Classic Network to VPC Download Focus Mode Font Size Last updated: 2024-11-12 17:55:01 This document describes how to switch the instance network from classic network to VPC in the TencentDB for SQL Server console.
Network types There are two types of TencentDB network environments: classic network and VPC.
Classic network: It is the public network resource pool for all Tencent Cloud users. All your Tencent Cloud resources will be centrally managed by Tencent Cloud.
VPC: It is a logically isolated network space that can be customized in Tencent Cloud. Even in the same region, different VPCs cannot communicate with each other by default. Similar to the traditional network in an IDC, a VPC is where your Tencent Cloud service resources are managed.
Overview Tencent Cloud supports classic network and VPC, which are capable of offering a diversity of smooth services. On this basis, we provide the classic network to VPC switch feature to help you manage network connectivity with ease.
Supported instance types Primary and read-only instances on all versions.
Notes Currently, you can only switch from classic network to VPC but not vice versa.
After the switch, VPC access will take effect immediately. The original classic network access will be retained for 24 hours; therefore, other instances associated to the instance should be migrated to VPC within 24 hours so as to guarantee uninterrupted access.
If Valid Hours of Old IP is set to 0, the IP will be released immediately after the network is changed. Then, you can only access the instance over the VPC.
After you switch the primary instance's network, the networks of read-only instances associated with the primary instance won't be automatically switched, that is, you need to manually switch them.
Subnet description A subnet is a logical network space in a VPC. You can create subnets in different AZs in the same VPC, which communicate with each other over the private network by default. Even if you select a subnet in another AZ in the same region, the network latency will not be increased because the actual business connection adopts nearby access.
Directions
1.
Log in to the TencentDB for SQL Server console, select the region, and click Instance ID/Name of the target instance.

﻿ ﻿
2.
In the Instance Info on the right side of the Instance Details page, click Switch to VPC next to the Network.
3.
In the pop-up window, select a VPC, set Valid Hours of Old IP, select Auto-Assign IP or Specify IP, and click OK.
Select Network: After a VPC is selected, only servers in it can access the database.
Valid Hours of Old IP: You can select 0–168 hours. If it is set to 0, the old IP will be repossessed immediately.
Auto-Assign IP: The system automatically assigns the new IP address.
Specify IP: You can customize the subnet IP address.
4.
The classic network is successfully switched to VPC when the instance status becomes Running.
Previous Topic: Replica Node Read-Only Next Topic: Changing Network Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Network types Overview Supported instance types Notes Subnet description Directions Search AllCurrent Product Search titles only Enter keywords to search documentation
