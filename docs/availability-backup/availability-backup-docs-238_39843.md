# CreateBackupMigration

> 来源: https://www.tencentcloud.com/document/product/238/39843

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs CreateBackupMigration ModifyBackupMigration StartBackupMigration DescribeBackupMigration DeleteBackupMigration DescribeUploadBackupInfo CreateIncrementalMigration ModifyIncrementalMigration StartIncrementalMigration DescribeIncrementalMigration DescribeBackupCommand DescribeBackupUploadSize DeleteIncrementalMigration DescribeUploadIncrementalInfo SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Data migration (cold standby migration) related APIs CreateBackupMigration CreateBackupMigration Download Focus Mode Font Size Last updated: 2026-06-29 21:45:48

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to create a backup import task.

A maximum of 20 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: CreateBackupMigration.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product.
InstanceId	Yes	String	ID of imported target instance RecoveryType	Yes	String	Migration task restoration type. FULL: full backup restoration, FULL_LOG: full backup and transaction log restoration, FULL_DIFF: full backup and differential backup restoration UploadType	Yes	String	Backup upload type. COS_URL: the backup is stored in user's Cloud Object Storage, with URL provided. COS_UPLOAD: the backup is stored in the application's Cloud Object Storage and needs to be uploaded by the user.
MigrationName	Yes	String	Task name BackupFiles.N	No	Array of String	If the UploadType is COS_URL, fill in the URL here. If the UploadType is COS_UPLOAD, fill in the name of the backup file here. Only 1 backup file is supported, but a backup file can involve multiple databases.

3. Output Parameters
Parameter Name	Type	Description BackupMigrationId	String	Backup import task ID RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 Creating a backup file import task

Input Example https://sqlserver.intl.tencentcloudapi.com/?Action=CreateBackupMigration &InstanceId=mssql-rdc0gajn &RecoveryType=FULL &UploadType=COS_UPLOAD &MigrationName=character string &BackupFiles.0=db1.bak &

Output Example { "Response": { "BackupMigrationId": "mssql-backup-migration-cg0ffgqt", "RequestId": "4e2f2093-9cde-44ec-b64b-edfcc2f911d4" } }

5. Developer Resources

SDK

TencentCloud API 3.0 integrates SDKs that support various programming languages to make it easier for you to call APIs.

Tencent Cloud SDK 3.0 for Python Tencent Cloud SDK 3.0 for Java Tencent Cloud SDK 3.0 for PHP Tencent Cloud SDK 3.0 for Go Tencent Cloud SDK 3.0 for Node.js Tencent Cloud SDK 3.0 for .NET Tencent Cloud SDK 3.0 for C++

Command Line Interface Tencent Cloud CLI 3.0

6. Error Code

The following only lists the error codes related to the API business logic. For other error codes, see Common Error Codes.

Error Code	Description InternalError.DBError	Database error InternalError.SystemError	System error.
InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
InvalidParameterValue.BackupNameIsIllegal	The backup name contains invalid characters.
InvalidParameterValue.MigrationNameIsIllegal	The migration name contains invalid characters.
ResourceNotFound.InstanceNotFound	The instance does not exist.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
Previous Topic: DeleteRestoreTask Next Topic: ModifyBackupMigration Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 Creating a backup file import task
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
