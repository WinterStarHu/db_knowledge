# CreateBasicDBInstances

> 来源: https://www.tencentcloud.com/document/product/238/66344

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs CreateBasicDBInstances DescribeRegions DescribeZones DescribeProductConfig DescribeSpecSellStatus InquiryPriceCreateDBInstances DescribeInstanceTradeParameter DescribeOrders DescribeInstanceByOrders InquiryPriceUpgradeDBInstance CreateDBInstances CreateCloudDBInstances Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Sales and fee related APIs CreateBasicDBInstances CreateBasicDBInstances Download Focus Mode Font Size Last updated: 2026-06-29 21:44:41

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to create basic edition instances (cloud disk).

A maximum of 20 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: CreateBasicDBInstances.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product. This API only supports: ap-bangkok, ap-beijing, ap-chengdu, ap-chongqing, ap-guangzhou, ap-hongkong, ap-jakarta, ap-nanjing, ap-seoul, ap-shanghai, ap-shanghai-fsi, ap-shenzhen-fsi, ap-singapore, ap-tokyo, eu-frankfurt, na-ashburn, na-siliconvalley, sa-saopaulo.
Zone	Yes	String	Instance AZ, such as ap-guangzhou-1 (Guangzhou Zone 1). Purchasable AZs for an instance can be obtained through the DescribeZones API.
Cpu	Yes	Integer	Number of CPU cores.
Memory	Yes	Integer	Instance memory size in GB.
Storage	Yes	Integer	Instance storage capacity in GB.
SubnetId	Yes	String	VPC subnet ID in the format of subnet-bdoe83fa.
VpcId	Yes	String	VPC ID in the format of vpc-dsp338hz.
MachineType	Yes	String	Host type of purchased instances. CLOUD_PREMIUM: Premium Disk for virtual machines; CLOUD_SSD: Cloud SSD for virtual machines; CLOUD_HSSD: Enhanced SSD for virtual machines; CLOUD_BSSD: Balanced SSD for virtual machines.
InstanceChargeType	No	String	Billing mode. Valid value: POSTPAID (pay-as-you-go).
ProjectId	No	Integer	Project ID.
GoodsNum	No	Integer	Number of instances purchased this time. Default value: 1. Maximum value: 10.
DBVersion	No	String	SQL Server version. Valid values: 2008R2 (SQL Server 2008 R2 Enterprise), 2012SP3 (SQL Server 2012 Enterprise), 201202 (SQL Server 2012 Standard), 2014SP2 (SQL Server 2014 Enterprise), 201402 (SQL Server 2014 Standard), 2016SP1 (SQL Server 2016 Enterprise), 201602 (SQL Server 2016 Standard), 2017 (SQL Server 2017 Enterprise), 201702 (SQL Server 2017 Standard), 2019 (SQL Server 2019 Enterprise), 201902 (SQL Server 2019 Standard). Default value: 2008R2. The available version varies by region, and you can pull the version information by calling the DescribeProductConfig API.
Period	No	Integer	Length of purchase of instance. The default value is 1, indicating one month. The value cannot exceed 48.
SecurityGroupList.N	No	Array of String	Security group list, which contains security group IDs in the format of sg-xxx.
AutoRenewFlag	No	Integer	Auto-renewal flag. 0: normal renewal, 1: auto-renewal. Default value: 1.
AutoVoucher	No	Integer	Whether to automatically use voucher. 0: no, 1: yes. Default value: no.
VoucherIds.N	No	Array of String	Array of voucher IDs (currently, only one voucher can be used per order).
Weekly.N	No	Array of Integer	Configuration of the maintenance window, which specifies the day of the week when maintenance can be performed. Valid values: 1 (Monday), 2 (Tuesday), 3 (Wednesday), 4 (Thursday), 5 (Friday), 6 (Saturday), 7 (Sunday).
StartTime	No	String	Configuration of the maintenance window, which specifies the start time of daily maintenance.
Span	No	Integer	Configuration of the maintenance window, which specifies the maintenance duration in hours.
ResourceTags.N	No	Array of ResourceTag	Tags associated with the instances to be created.
Collation	No	String	Collation of system character sets. Default value: Chinese_PRC_CI_AS.
TimeZone	No	String	System time zone. Default value: China Standard Time.
DiskEncryptFlag	No	Integer	Disk encryption identifier, 0-unencrypted, 1-encrypted.

3. Output Parameters
Parameter Name	Type	Description DealName	String	Order name.
RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 Create a Basic Edition instance

Create a Basic Edition instance

Input Example POST / HTTP/1.1 Host: sqlserver.intl.tencentcloudapi.com Content-Type: application/json X-TC-Action: CreateBasicDBInstances

{ "VpcId": "vpc-huew581t", "AutoRenewFlag": "0", "Zone": "ap-guangzhou-3", "GoodsNum": "1", "TimeZone": "China Standard Time", "DBVersion": "2008R2", "Storage": "20", "Period": "1", "MachineType": "CLOUD_PREMIUM", "Collation": "Chinese_PRC_CI_AS", "InstanceChargeType": "PREPAID", "StartTime": "00:00", "Memory": "2", "SubnetId": "subnet-pudyecyk", "Span": "6", "Cpu": "1", "Weekly": [ "1" ] }

Output Example { "Response": { "DealName": "20200713383000001111250", "RequestId": "d84adfca-3ff0-46d2-b400-b5527446df72" } }

5. Developer Resources

SDK

TencentCloud API 3.0 integrates SDKs that support various programming languages to make it easier for you to call APIs.

Tencent Cloud SDK 3.0 for Python Tencent Cloud SDK 3.0 for Java Tencent Cloud SDK 3.0 for PHP Tencent Cloud SDK 3.0 for Go Tencent Cloud SDK 3.0 for Node.js Tencent Cloud SDK 3.0 for .NET Tencent Cloud SDK 3.0 for C++

Command Line Interface Tencent Cloud CLI 3.0

6. Error Code

The following only lists the error codes related to the API business logic. For other error codes, see Common Error Codes.

Error Code	Description FailedOperation.CreateOrderFailed	Failed to create order.
FailedOperation.DBError	Database error.
FailedOperation.GetVpcFailed	Failed to get VPC information.
InternalError.DBError	Database error InternalError.VPCError	VPC error InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
InvalidParameter.PayOrderFailed	Failed to make order payment.
InvalidParameterValue.IllegalSpec	Incorrect instance specification information.
InvalidParameterValue.ParameterTypeError	Incorrect parameter type.
InvalidParameterValue.SecurityGroupIdIsIllegal	Invalid security group ID.
ResourceNotFound.VpcNotExist	The VPC does not exist.
ResourceUnavailable.VpcNotExist	VPC not found.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
Previous Topic: Responses Next Topic: DescribeRegions Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 Create a Basic Edition instance
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
