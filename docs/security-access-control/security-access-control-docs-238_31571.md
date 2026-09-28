# Creating TencentDB for SQL Server Instance

> 来源: https://www.tencentcloud.com/document/product/238/31571

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Getting Started Creating TencentDB for SQL Server Instance Creating TencentDB for SQL Server Instance Download Focus Mode Font Size Last updated: 2026-08-18 14:46:53 AI-Translated Scenarios This document describes how to create an instance through the TencentDB for SQL Server console.
Prerequisites You have registered a Tencent Cloud account and completed identity verification.
Operation Steps Instance creation
1.
Log in to the TencentDB for SQL Server purchase page. Complete the following steps in order: Select a basic configuration, Set network and database, and Confirm the configuration info. Read and agree to the service terms. After verifying that everything is correct, click Buy Now.
Step 1. Select a basic configuration In this step, you can configure the basic and specification settings for the instance. The specific configurable items are as follows:
Basic Configuration Billing Mode: pay-as-you-go.
Region: Select the region for instance deployment. To reduce access latency and improve download speed, we recommend that you choose the region closest to your customers.
AZ: Select an AZ within the chosen region. You can also choose a random AZ, in which case the system will assign one randomly.
Instance Architecture: Support single-node, two-node, and multi-node.
Storage Type:
When you select the single-node architecture, the following storage types are supported: Premium Cloud Disk, SSD, General Purpose SSD, Enhanced SSD, and UlTra SSD.
Note:
For single-node instances in Mainland China regions that require SSD CBS, please submit a ticket to apply.
When you select the two-node architecture, the following storage types are supported: Enhanced SSD, General Purpose SSD, High-Performance Local, and UlTra SSD.
When you select the multi-node architecture, the following storage types are supported: Enhanced SSD, General Purpose SSD, and UlTra SSD.
The storage types available for different regions and AZs may vary. For details, refer to the actual purchase page. To learn more about the descriptions and applicable scenarios of each storage type, see Storage Type.
Database Versions: SQL Server 2012, SQL Server 2014, SQL Server 2016, SQL Server 2017, SQL Server 2019 Enterprise/Standard, SQL Server 2022 Enterprise, and SQL Server 2025 Enterprise are supported. For the database versions supported by different instance architectures, refer to the purchase page.
Disk Encryption: For instances in the Shanghai region with CBS as the storage type and SQL Server 2019/2022/2025 Enterprise as the database version, the disk encryption feature can be used after applying for whitelisting. Disk encryption is not currently supported in other regions or for other versions. To request support, please submit a ticket. The Disk Encryption field is displayed only after the disk encryption feature is applied for.
Key Source: This item is displayed when disk encryption is enabled. Currently, the default key source is provided by Tencent Cloud.
Number of Replica Nodes: If the multi-node architecture is selected, you need to specify the number of replica nodes with the number range from 2 to 5. The settings are not required for single-node or two-node architecture.
Multi-AZ Deployment: This option is available when a two-node or multi-node architecture is selected. For multi-node architecture, it can only be set to enabled.
Yes: Multi-AZ deployment is enabled, requiring the selection of secondary AZs in the next step. Each secondary node can be assigned a secondary AZ. Note: If all secondary nodes are deployed in the same AZ, the AZ-level disaster recovery is not supported. Please choose different secondary AZs.
No: Multi-AZ deployment is not enabled. Currently, only Shanghai, Beijing, Guangzhou, and Hong Kong (China) support multi-AZ deployment. Multi-AZ is a physical zone that combines multiple single AZs in the same region, which is used to protect databases in case of instance faults or AZ interruptions.
Replica AZ: If multi-AZ deployment is enabled, select the secondary AZs based on the available resources.
Specs Configuration Type: Dedicated.
Filter: Quickly filter the CPU and memory of the required instances. All CPUs and all memory are selected by default.
Selected instances: Displays the specifications of the selected instances, including the specification type and details.
Instance specifications: Displays the instance's specification type, CPU, memory, maximum IOPS, supported AZs, and rule-based reference fees.
Disk: Select the required disk capacity.
Additional Performance: Additional I/O performance can be configured on top of the baseline disk performance to meet the demands of high-throughput and high-IOPS business scenarios. To configure additional performance, the instance must meet the following requirements: it must be a single-node, two-node, or multi-node Cloud Disk Edition architecture, with storage type as Enhanced SSD/UlTra SSD, and the disk capacity must be greater than or equal to 460 GB. You can also configure it after creating the instance. For details, see Configure Additional Disk I/O Performance.
Note:
Baseline disk performance is automatically provisioned based on disk capacity and incurs no additional charges. Additional I/O performance is an optional enhancement and will be billed separately. For details, see Additional Disk I/O Performance Billing.
Step 2. Set network and database Network: Supports VPC. For connectivity testing, see Network Environment. Both VPC networks and subnets support fuzzy search.
Note:
It is recommended that the CVM and the cloud database reside under the same account and within the same VPC (to ensure they are in the same region, with no restriction on AZs).
A subnet is a network space within a VPC and is a logical concept. You can create subnets in different AZs under the same VPC. Subnets in different AZs under the same VPC can communicate over the private network by default. Even if you select a subnet in another AZ within the same region, the actual service connection follows a proximity-based logic and does not increase network latency.
Security group: A stateful virtual firewall with filtering capabilities, used to configure network access control for single or multiple cloud databases. It is an important network security isolation mechanism provided by Tencent Cloud.
Note:
It supports creating new security groups or selecting existing ones, and it also supports multi-selection and fuzzy search.
Instance Name: You can name the instance immediately or after creation.
System Time Zone: China Standard Time (Beijing Time) is supported by default.
If you purchase a two-node local disk instance, you must first submit a ticket to apply for system time zone modifications.
If you purchase a single-node cloud disk, a two-node cloud disk, or a multi-node cloud disk instance, you can directly modify the system time zone on the purchase page with no need for an application.
Character Set Collation: The instance character set provides collation rules for system data, which define case-sensitivity and accent-sensitivity attributes. Chinese_PRC_CI_AS is supported by default.
If you purchase a two-node local disk instance, you must first submit a ticket to apply for character set rule modifications.
If you purchase a single-node cloud disk, a two-node cloud disk, or a multi-node cloud disk instance, you can directly modify the system time zone on the purchase page with no need for an application.
Transmission Mode: Configure the transmission mode between the primary and standby databases of the instance. This setting is supported only for two-node Cloud Disk Edition architecture instances of SQL Server 2017, SQL Server 2019, SQL Server 2022, and SQL Server 2025 Enterprise. Options include: Async (availability precedence) and Sync (reliability precedence). The default value is Async (availability precedence).
Async (availability precedence): This is a high-performance mode that prioritizes availability. It is recommended for systems with high uptime requirements. During a switch between primary and secondary, it strives to prioritize database availability, though the actual outcome depends on the specific failure scenario and the switch result.
Sync (reliability priority): This is a high-reliability mode that prioritizes reliability. It is recommended for systems with high data consistency requirements. During a switch between primary and secondary, it strives to prioritize data consistency, though the actual outcome depends on the specific failure scenario and the switch result.
Project: TencentDB for SQL Server supports assigning instances to different projects for management. It also supports fuzzy search of project names for faster project selection.
Tag: It facilitates the categorized management of instance resources. It also supports adding multiple tags.
Maintenance window and Maintenance Time: To ensure the stability of TencentDB for SQL Server instances, the backend system performs maintenance operations on instances irregularly within the maintenance window. It is recommended that you configure an acceptable maintenance time for your business instances, typically during off-peak hours, to minimize the impact on your business. Up to 7 maintenance cycles can be selected.
Step 3. Confirm the configuration info Display the configuration details of instances in step one and step two. If modifications are needed, click Edit. After all settings are confirmed, enable auto-renewal, read and agree to terms of the service, and click Buy Now.
Auto-Renewal (for monthly subscription billing mode): If auto-renewal is enabled and the account balance is sufficient, the instance will be automatically renewed upon expiration based on the selected purchase duration: monthly or annually.
Purchase duration of 1 to 11 months: The auto-renewal period is one month, and the instance will be automatically renewed on a monthly basis upon expiration.
Purchase duration of 1 to 5 years: The auto-renewal period is one year, and the instance will be automatically renewed on a yearly basis upon expiration, with an auto-renewal discount applied.
resource inspection: The system performs a resource pre-check to determine whether the selected specification configuration has sufficient resources. If resources are sufficient, the check passes, and you can proceed to the next step. If resources are insufficient, change the configuration and perform the resource pre-check again. You can proceed to the next step only after the pre-check passes.
Terms of service: Cloud database service terms, Service level agreement, and Refund instruction.
2. After purchase, return to the Instance List to view the created instance. When the running status is displayed as Running, it indicates that the instance has been created successfully.
Creating an Account
1.
On the Instance List page, click the Instance ID or Manage in the Operation column to go to the instance management page.
2.
On the instance management page, select Account Management > Create Account, enter relevant information in the pop-up dialog box, and then click OK after confirmation.
Note:
This account name and password are used to connect to the SQL Server cloud database. Please keep them secure.
Creating a Database
1.
On the Instance List page, click the Instance ID or Manage in the Operation column to go to the instance management page.
2.
On the instance management page, choose Database Management > Create Database, enter relevant information in the pop-up dialog box, and then click OK after confirmation.
Database name: It must consist of letters, digits, and underscores, start with a letter, and be at most 32 characters long.
Supported character set: Select the character set used by the database. Most native character sets are currently supported.
Authorize account: You can grant permissions to existing accounts for this database. If no account has been created, see Account Creation.
Remarks: Enter remarks, which can be up to 256 characters.
Related APIs API

Description

Creating an Instance

This API is used to create a highly available instance (local disk).

Creating a Basic Edition Instance

This API is used to create a Basic Edition instance (cloud disk).

Creating a High-Availability Instance

This API is used to create a highly available instance (cloud disk).

Querying Available Regions

This API (DescribeRegions) is used to query region information for sale.

Querying Available AZs

This API (DescribeZones) is used to query currently available AZ information for sale.

Querying Available Specifications

This API (DescribeProductConfig) is used to query product configuration for sale.

Querying Specification Status Information

This API (DescribeSpecSellStatus) is used to query the status information of specifications for sale, including the sales status and reference price. (The actual price is subject to the result returned by price querying APIs.)

Querying Instance Creation Price

This API (InquiryPriceCreateDBInstances) is used to query the price for applying for an instance.

Querying Order Information

This API (DescribeOrders) is used to query order information.

Querying the Corresponding Instance ID by Order Number

This API (DescribeInstanceByOrders) is used to query the resource ID based on the order number.
Previous Topic: Viewing Bill Details Next Topic: Instance Connection Scenarios Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Scenarios Prerequisites Operation Steps Instance creation Creating an Account Creating a Database Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
