# CreateBusinessDBInstances

> 来源: https://www.tencentcloud.com/document/product/238/50610

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs CreateBusinessDBInstances OpenInterCommunication CreateBusinessIntelligenceFile DescribeBusinessIntelligenceFile DeleteBusinessIntelligenceFile CloseInterCommunication DescribeDBInstanceInter Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation SQL Server Integration Services (SSIS) related APIs CreateBusinessDBInstances CreateBusinessDBInstances Download Focus Mode Font Size Last updated: 2026-06-29 21:44:46

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to create business intelligence service instances (cloud disk).

A maximum of 20 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: CreateBusinessDBInstances.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product.
Zone	Yes	String	Instance AZ, such as ap-guangzhou-1 (Guangzhou Zone 1). Purchasable AZs for an instance can be obtained through theDescribeZones API.
Memory	Yes	Integer	Instance memory size in GB Storage	Yes	Integer	Instance disk size in GB Cpu	Yes	Integer	The number of CPU cores of the instance you want to purchase.
MachineType	Yes	String	The host type of purchased instance. Valid values: CLOUD_PREMIUM (virtual machine with premium cloud disk), CLOUD_SSD (virtual machine with SSD).
ProjectId	No	Integer	Project ID GoodsNum	No	Integer	Number of instances purchased this time. Default value: 1.
SubnetId	No	String	VPC subnet ID in the format of subnet-bdoe83fa. Both SubnetId and VpcId need to be set or unset at the same time.
VpcId	No	String	VPC ID in the format of vpc-dsp338hz. Both SubnetId and VpcId need to be set or unset at the same time.
DBVersion	No	String	- Supported versions of business intelligence server. Valid values: 201603 (SQL Server 2016 Integration Services), 201703 (SQL Server 2017 Integration Services), 201903 (SQL Server 2019 Integration Services). Default value: 201903. As the purchasable versions are region-specific, you can use the DescribeProductConfig API to query the information of purchasable versions in each region.
SecurityGroupList.N	No	Array of String	Security group list, which contains security group IDs in the format of sg-xxx.
Weekly.N	No	Array of Integer	Configuration of the maintenance window, which specifies the day of the week when maintenance can be performed. Valid values: 1 (Monday), 2 (Tuesday), 3 (Wednesday), 4 (Thursday), 5 (Friday), 6 (Saturday), 7 (Sunday).
StartTime	No	String	Configuration of the maintenance window, which specifies the start time of daily maintenance.
Span	No	Integer	Configuration of the maintenance window, which specifies the maintenance duration in hours.
ResourceTags.N	No	Array of ResourceTag	Tags associated with the instances to be created

3. Output Parameters
Parameter Name	Type	Description DealName	String	Order name FlowId	Integer	Process ID Note: This field may return null, indicating that no valid values can be obtained.
InstanceIdSet	Array of String	IDs of instances Note: This field may return null, indicating that no valid values can be obtained.
RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 Creating a business intelligence service instance

This example shows you how to create a business intelligence service instance.

Input Example POST / HTTP/1.1Host: sqlserver.intl.tencentcloudapi.comContent-Type: application/jsonX-TC-Action: CreateBusinessDBInstances{    "Storage": 50,    "Cpu": 1,    "Zone": "ap-guangzhou-1",    "Memory": 2,    "ProjectId": 1,    "GoodsNum": 1,    "SubnetId": "subnet-xxxx",    "VpcId": "vpc-xxxxxx",    "DBVersion": "201703",    "StartTime": "01:34",    "Span": 4,    "MachineType": "CLOUD_PREMIUM",    "Weekly": [        1,        5    ]}

Output Example { "Response": { "DealName": "20200318114212", "RequestId": "2b6f7e2a-e909-4753-84b7-0db3e6099877", "FlowId": 100439, "InstanceIdSet": [ "mssqlbi-sdjiej23" ] } }

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
InternalError.DBError	Database error InternalError.UnknownError	Unknown error.
InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
InvalidParameter.PayOrderFailed	Failed to make order payment.
InvalidParameterValue.IllegalRegion	Invalid region.
InvalidParameterValue.IllegalSpec	Incorrect instance specification information.
InvalidParameterValue.IllegalZone	Incorrect AZ ID.
InvalidParameterValue.SecurityGroupIdIsIllegal	Invalid security group ID.
ResourceNotFound.VpcNotExist	The VPC does not exist.
ResourceUnavailable.VpcNotExist	VPC not found.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
Previous Topic: DescribeUploadIncrementalInfo Next Topic: OpenInterCommunication Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 Creating a business intelligence service instance
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
