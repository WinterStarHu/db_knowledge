# CreateMigration

> 来源: https://www.tencentcloud.com/document/product/238/32129

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs CreateMigration RunMigration DeleteMigration DescribeMigrationDetail ModifyMigration StartMigrationCheck StopMigration CompleteMigration DescribeMigrations DescribeMigrationDatabases QueryMigrationCheckProcess Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Data migration (DTS old version) related APIs CreateMigration CreateMigration Download Focus Mode Font Size Last updated: 2026-06-29 21:45:55

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to create a migration task.

A maximum of 20 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: CreateMigration.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product.
MigrateName	Yes	String	Migration task name MigrateType	Yes	Integer	Migration type (1: structure migration, 2: data migration, 3: incremental sync) SourceType	Yes	Integer	Migration source type. 1: TencentDB for SQL Server, 2: CVM-based self-created SQL Server database; 3: SQL Server backup restoration, 4: SQL Server backup restoration (in COS mode) Source	Yes	MigrateSource	Migration source Target	Yes	MigrateTarget	Migration target MigrateDBSet.N	No	Array of MigrateDB	Database objects to be migrated. This parameter is not used for offline migration (SourceType=4 or SourceType=5) RenameRestore.N	No	Array of RenameRestoreDatabase	Restore and rename the databases listed in ReNameRestoreDatabase. If this parameter is left empty, all restored databases will be renamed in the default format. This parameter takes effect only when SourceType=5.

3. Output Parameters
Parameter Name	Type	Description MigrateId	Integer	Migration task ID RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 Creating a migration task

Input Example https://sqlserver.intl.tencentcloudapi.com/?Action=CreateMigration &MigrateName=Test API &MigrateType=2 &SourceType=5 &Source.Url.0=http://gz-oncvm-1254065710.cosgz.myqcloud.com/testdb.bak &Target.InstanceId=mssql-si2823jyl &

Output Example { "Response": { "RequestId": "4be5990d-a4b5-49dc-b2b4-e713b6aa7ba3", "MigrateId": 2728 } }

5. Developer Resources

SDK

TencentCloud API 3.0 integrates SDKs that support various programming languages to make it easier for you to call APIs.

Tencent Cloud SDK 3.0 for Python Tencent Cloud SDK 3.0 for Java Tencent Cloud SDK 3.0 for PHP Tencent Cloud SDK 3.0 for Go Tencent Cloud SDK 3.0 for Node.js Tencent Cloud SDK 3.0 for .NET Tencent Cloud SDK 3.0 for C++

Command Line Interface Tencent Cloud CLI 3.0

6. Error Code

The following only lists the error codes related to the API business logic. For other error codes, see Common Error Codes.

Error Code	Description FailedOperation.DBError	Database error.
FailedOperation.GcsError	The operation failed or the network timed out.
InternalError	Internal error.
InternalError.CreateFlowFailed	Failed to create flow.
InternalError.DBConnectError	Database connection error.
InternalError.SystemError	System error.
InternalError.UnknownError	Unknown error.
InvalidParameter	Invalid parameter.
InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
InvalidParameterValue.DBCharIllegal	The database name contains invalid characters.
InvalidParameterValue.DBExist	The database already exists.
InvalidParameterValue.MigrationNameIsIllegal	The migration name contains invalid characters.
InvalidParameterValue.OnCvmTypeNotSupported	Basic edition instances are not supported.
ResourceNotFound.InstanceNotFound	The instance does not exist.
ResourceUnavailable.InstanceMigrateRegionIllegal	Invalid instance migration region.
ResourceUnavailable.InstanceMigrateStatusInvalid	Invalid instance migration status.
ResourceUnavailable.InstanceStatusInvalid	Invalid instance status.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
Previous Topic: DescribeDBInstanceInter Next Topic: RunMigration Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 Creating a migration task
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
