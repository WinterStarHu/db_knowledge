# DescribeXEvents

> 来源: https://www.tencentcloud.com/document/product/238/54814

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs DescribeXEvents StartInstanceXEvent Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Extended Event related APIs DescribeXEvents DescribeXEvents Download Focus Mode Font Size Last updated: 2026-06-29 21:45:24

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to query the list of extended events.

A maximum of 20 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: DescribeXEvents.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product.
InstanceId	Yes	String	Instance ID EventType	Yes	String	Event type. Valid values: slow (Slow SQL event), blocked (blocking event), deadlock` (deadlock event).
StartTime	Yes	String	Generation start time of an extended file in the format of yyyy-MM-dd HH:mm:ss.
EndTime	Yes	String	Generation end time of an extended file in the format of yyyy-MM-dd HH:mm:ss.
Offset	No	Integer	Page number. Default value: 0 Limit	No	Integer	Number of entries to be returned per page. Value range: 1-100. Default value: 20

3. Output Parameters
Parameter Name	Type	Description Events	Array of Events	List of extended events TotalCount	Integer	Total number of extended events RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 DescribeXEvents

This example shows you how to query the record of an extended event for an instance, including slow SQL, blocking, and deadlock.

Input Example POST / HTTP/1.1 Host: sqlserver.intl.tencentcloudapi.com Content-Type: application/json X-TC-Action: DescribeXEvents

{ "Offset": 0, "Limit": 2, "StartTime": "2023-03-05 11:49:08", "EndTime": "2023-03-13 11:49:08", "EventType": "slow", "InstanceId": "mssql-qp7gu6ch" }

Output Example { "Response": { "RequestId": "023a2da2-c152-11ed-b1aa-525400853186", "TotalCount": 10, "Events": [ { "EndTime": "2023-03-10 15:45:05", "EventType": "slow", "ExternalAddr": "https://***", "FileName": "autoed_instance_58001_20230220110419.xel", "Id": 1004, "InternalAddr": "https:***", "Size": 10240, "StartTime": "2023-03-10 15:44:15", "Status": 1 } ] } }

5. Developer Resources

SDK

TencentCloud API 3.0 integrates SDKs that support various programming languages to make it easier for you to call APIs.

Tencent Cloud SDK 3.0 for Python Tencent Cloud SDK 3.0 for Java Tencent Cloud SDK 3.0 for PHP Tencent Cloud SDK 3.0 for Go Tencent Cloud SDK 3.0 for Node.js Tencent Cloud SDK 3.0 for .NET Tencent Cloud SDK 3.0 for C++

Command Line Interface Tencent Cloud CLI 3.0

6. Error Code

The following only lists the error codes related to the API business logic. For other error codes, see Common Error Codes.

Error Code	Description FailedOperation.CosError	Failed to access COS.
FailedOperation.DBError	Database error.
FailedOperation.GcsError	The operation failed or the network timed out.
InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
ResourceNotFound.InstanceNotFound	The instance does not exist.
ResourceNotFound.ParamsNotFound	Parameter not found.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
Previous Topic: DescribeInstanceParamRecords Next Topic: StartInstanceXEvent Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 DescribeXEvents
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
