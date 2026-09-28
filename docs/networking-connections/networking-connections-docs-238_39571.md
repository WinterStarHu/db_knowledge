# ModifyDBInstanceNetwork

> 来源: https://www.tencentcloud.com/document/product/238/39571

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs ModifyDBInstanceNetwork ModifyOpenWanIp ModifyCloseWanIp Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Network management related APIs ModifyDBInstanceNetwork ModifyDBInstanceNetwork Download Focus Mode Font Size Last updated: 2026-06-29 21:45:07

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to switch a running instance from a VPC to another.

A maximum of 20 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: ModifyDBInstanceNetwork.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product. This API only supports: ap-bangkok, ap-beijing, ap-chengdu, ap-chongqing, ap-guangzhou, ap-hongkong, ap-jakarta, ap-nanjing, ap-seoul, ap-shanghai, ap-shanghai-fsi, ap-shenzhen-fsi, ap-singapore, ap-tokyo, eu-frankfurt, na-ashburn, na-siliconvalley, sa-saopaulo.
InstanceId	Yes	String	Instance ID.
NewVpcId	Yes	String	ID of the new VPC.
NewSubnetId	Yes	String	ID of the new subnet.
OldIpRetainTime	No	Integer	Retention period (in hours) of the original VIP. Value range: 0-168. Default value: 0, indicating the original VIP is released immediately.
Vip	No	String	New VIP.
DRNetwork	No	Integer	Target node. 0 - modify the primary node network; 1 - modify the secondary node network. The default value is 0.

DrInstanceId	No	String	Secondary server resource ID. It is required when DRNetwork = 1.

3. Output Parameters
Parameter Name	Type	Description FlowId	Integer	ID of the instance network changing task. You can use the DescribeFlowStatus API to query the task status.
RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 Network Change

Input Example POST / HTTP/1.1 Host: sqlserver.intl.tencentcloudapi.com Content-Type: application/json X-TC-Action: ModifyDBInstanceNetwork

{ "InstanceId": "mssql-e720ieef", "NewVpcId": "vpc-kw88teud", "NewSubnetId": "subnet-8z5n8tcg", "OldIpRetainTime": "0" }

Output Example { "Response": { "FlowId": 1011581, "RequestId": "bdac237c-b9b7-4050-9284-97898cca5883" } }

Example2 Instance Network Modification

Input Example https://sqlserver.intl.tencentcloudapi.com/?Action=ModifyDBInstanceNetwork &InstanceId=mssql-p2yli7gv &NewVpcId=vpc-ilki4qdp &NewSubnetId=subnet-lru6dhh8 &Vip=127.0.0.1 &OldIpRetainTime=12 &

Output Example { "Response": { "RequestId": "20db6661-2a85-49d9-8a37-976b931649fb", "FlowId": 100125 } }

5. Developer Resources

SDK

TencentCloud API 3.0 integrates SDKs that support various programming languages to make it easier for you to call APIs.

Tencent Cloud SDK 3.0 for Python Tencent Cloud SDK 3.0 for Java Tencent Cloud SDK 3.0 for PHP Tencent Cloud SDK 3.0 for Go Tencent Cloud SDK 3.0 for Node.js Tencent Cloud SDK 3.0 for .NET Tencent Cloud SDK 3.0 for C++

Command Line Interface Tencent Cloud CLI 3.0

6. Error Code

The following only lists the error codes related to the API business logic. For other error codes, see Common Error Codes.

Error Code	Description AuthFailure	CAM signature/authentication error FailedOperation.DBError	Database error.
FailedOperation.GcsError	The operation failed or the network timed out.
FailedOperation.GetVpcFailed	Failed to get VPC information.
FailedOperation.VPCError	Failed to operate the network or the session timed out.
InternalError.CamAuthFailed	CAM authentication request failed.
InternalError.CreateFlowFailed	Failed to create flow.
InternalError.DBConnectError	Database connection error.
InternalError.SystemError	System error.
InternalError.UnknownError	Unknown error.
InternalError.VPCError	VPC error InvalidParameter	Invalid parameter.
InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
InvalidParameterValue	The parameter value is invalid.
ResourceNotFound	Resource not found.
ResourceNotFound.InstanceNotFound	The instance does not exist.
ResourceNotFound.VpcNotExist	The VPC does not exist.
ResourceUnavailable.InstanceStatusInvalid	Invalid instance status.
ResourceUnavailable.VpcNotExist	VPC not found.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
UnknownParameter	Unknown parameter error UnsupportedOperation.NotSupportRepeat	Repeated operations are not supported.
Previous Topic: ModifyMaintenanceSpan Next Topic: ModifyOpenWanIp Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 Network Change Example2 Instance Network Modification
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
