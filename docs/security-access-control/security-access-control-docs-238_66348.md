# CreateReadOnlyDBInstances

> 来源: https://www.tencentcloud.com/document/product/238/66348

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs CreateReadOnlyDBInstances CreateCloudReadOnlyDBInstances DescribeReadOnlyGroupDetails DescribeReadOnlyGroupList DescribeReadOnlyGroupByReadOnlyInstance ModifyReadOnlyGroupDetails DescribeReadOnlyGroupAutoWeight BalanceReadOnlyGroup RecycleReadOnlyGroup Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Read only instance management related APIs CreateReadOnlyDBInstances CreateReadOnlyDBInstances Download Focus Mode Font Size Last updated: 2026-06-29 21:44:56

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to create read-only instances (local disk).

A maximum of 20 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: CreateReadOnlyDBInstances.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product. This API only supports: ap-bangkok, ap-beijing, ap-chengdu, ap-chongqing, ap-guangzhou, ap-hongkong, ap-jakarta, ap-nanjing, ap-seoul, ap-shanghai, ap-shanghai-fsi, ap-shenzhen-fsi, ap-singapore, ap-tokyo, eu-frankfurt, na-ashburn, na-siliconvalley, sa-saopaulo.
InstanceId	Yes	String	Instance ID in the format of mssql-3l3fgqn7.
Zone	Yes	String	Instance AZ, such as ap-guangzhou-1 (Guangzhou Zone 1). Purchasable AZs for an instance can be obtained through theDescribeZones API.
ReadOnlyGroupType	Yes	Integer	Read-only group types. Valid values: 1 (each read-only replica is placed in one auto-created read-only group), 2 (all read-only replicas are placed in one auto-created read-only group), 3 (all read-only replicas are placed in one existing read-only group).
Memory	Yes	Integer	Instance memory size in GB.
Storage	Yes	Integer	Instance disk size in GB.
ReadOnlyGroupForcedUpgrade	No	Integer	Valid values: 0 (not upgrade the primary instance by default), 1 (upgrade the primary instance to complete the RO deployment). You need to pass in 1 for this parameter and upgrade the primary instance to cluster edition.
ReadOnlyGroupId	No	String	Existing read-only group ID, which is required when ReadOnlyGroupType is 3.
ReadOnlyGroupName	No	String	New read-only group ID, which is required when ReadOnlyGroupType is 2.
ReadOnlyGroupIsOfflineDelay	No	Integer	Whether delayed read-only instance removal is enabled in a new read-only group, which is required when ReadOnlyGroupType is 2. Valid values: 1 (enabled), 0 (disabled). The read-only replica will be automatically removed when the delay between it and the primary instance exceeds the threshold.
ReadOnlyGroupMaxDelayTime	No	Integer	The delay threshold for a new read-only group, which is required when ReadOnlyGroupType is 2 and ReadOnlyGroupIsOfflineDelay is 1.
ReadOnlyGroupMinInGroup	No	Integer	Minimum number of reserved read-only replicas when the delayed removal is enabled for the new read-only group, which is required when ReadOnlyGroupType is 2 and ReadOnlyGroupIsOfflineDelay is 1.
InstanceChargeType	No	String	Billing mode. Valid values: PREPAID (monthly subscription), POSTPAID (pay-as-you-go).
GoodsNum	No	Integer	Number of read-only instances to be purchased this time. Default value: 2.
SubnetId	No	String	VPC subnet ID in the format of subnet-bdoe83fa. Both SubnetId and VpcId need to be set or unset at the same time.
VpcId	No	String	VPC ID in the format of vpc-dsp338hz. Both SubnetId and VpcId need to be set or unset at the same time.
Period	No	Integer	The purchase period of an instance. Default value: 1 (one month). Maximum value: 48.
SecurityGroupList.N	No	Array of String	Security group list, which contains security group IDs in the format of sg-xxx.
AutoVoucher	No	Integer	Whether to automatically use voucher. Valid values: 0 (no, default), 1 (yes).
VoucherIds.N	No	Array of String	Array of voucher IDs (currently, only one voucher can be used per order).
ResourceTags.N	No	Array of ResourceTag	Tags associated with the instances to be created.
Collation	No	String	Collation of system character sets. Default value: Chinese_PRC_CI_AS.
TimeZone	No	String	System time zone. Default value: China Standard Time.

3. Output Parameters
Parameter Name	Type	Description DealNames	Array of String	Order name in array.
RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 Creating a read-only instance

This example shows you how to create a read-only instance.

Input Example POST / HTTP/1.1 Host: sqlserver.intl.tencentcloudapi.com Content-Type: application/json X-TC-Action: CreateReadOnlyDBInstances

{ "ReadOnlyGroupMaxDelayTime": "10", "VpcId": "vpc-3xq2t5al", "GoodsNum": "1", "Zone": "ap-guangzhou-3", "InstanceId": "mssql-6upluvd5", "Period": "1", "Storage": "10", "ReadOnlyGroupIsOfflineDelay": "1", "ReadOnlyGroupMinInGroup": "1", "ReadOnlyGroupName": "default_name", "Collation": "Chinese_PRC_CI_AS", "ReadOnlyGroupType": "2", "InstanceChargeType": "POSTPAID", "Memory": "2", "SubnetId": "subnet-gdy95gfs", "TimeZone": "China Standard Time", "ReadOnlyGroupForcedUpgrade": "1" }

Output Example { "Response": { "DealNames": [ "20200722117963" ], "RequestId": "0509b6b8-8906-479f-9489-10620ec6d4ce" } }

5. Developer Resources

SDK

TencentCloud API 3.0 integrates SDKs that support various programming languages to make it easier for you to call APIs.

Tencent Cloud SDK 3.0 for Python Tencent Cloud SDK 3.0 for Java Tencent Cloud SDK 3.0 for PHP Tencent Cloud SDK 3.0 for Go Tencent Cloud SDK 3.0 for Node.js Tencent Cloud SDK 3.0 for .NET Tencent Cloud SDK 3.0 for C++

Command Line Interface Tencent Cloud CLI 3.0

6. Error Code

The following only lists the error codes related to the API business logic. For other error codes, see Common Error Codes.

Error Code	Description FailedOperation.CreateOrderFailed	Failed to create order.
FailedOperation.GetVpcFailed	Failed to get VPC information.
InternalError.DBError	Database error InternalError.SystemError	System error.
InternalError.VPCError	VPC error InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
InvalidParameter.PayOrderFailed	Failed to make order payment.
InvalidParameterValue.IllegalSpec	Incorrect instance specification information.
InvalidParameterValue.ParameterTypeError	Incorrect parameter type.
InvalidParameterValue.RoGroupNameIsIllegal	Read-only group name contains invalid characters.
InvalidParameterValue.SecurityGroupIdIsIllegal	Invalid security group ID.
ResourceNotFound.InstanceNotFound	The instance does not exist.
ResourceNotFound.VpcNotExist	The VPC does not exist.
ResourceUnavailable.InstanceStatusInvalid	Invalid instance status.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
Previous Topic: DescribeHASwitchLog Next Topic: CreateCloudReadOnlyDBInstances Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 Creating a read-only instance
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
