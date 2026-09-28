# DescribeDBInstances

> 来源: https://www.tencentcloud.com/document/product/238/32115

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs DescribeDBInstances DescribeCrossRegionZone DescribeCollationTimeZone DescribeFlowStatus DescribeInstanceTasks ModifyDBInstanceName ModifyDBInstanceNote ModifyDBInstanceProject DescribeUpgradeInstanceCheck UpgradeDBInstance CompleteExpansion CutXEvents SwitchCloudInstanceHA RestartDBInstance TerminateDBInstance RenewPostpaidDBInstance DeleteDBInstance ModifyDReadable RecycleDBInstance DescribeDBInstancesAttribute Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Instance Management related APIs DescribeDBInstances DescribeDBInstances Download Focus Mode Font Size Last updated: 2026-06-29 21:45:20

1. API Description

Domain name for API request: sqlserver.intl.tencentcloudapi.com.

This API is used to query the list of instances.

A maximum of 70 requests can be initiated per second for this API.

We recommend you to use API Explorer Try it API Explorer provides a range of capabilities, including online call, signature authentication, SDK code generation, and API quick search. It enables you to view the request, response, and auto-generated examples.

2. Input Parameters

The following request parameter list only provides API request parameters and some common parameters. For the complete common parameter list, see Common Request Parameters.

Parameter Name	Required	Type	Description Action	Yes	String	Common Params. The value used for this API: DescribeDBInstances.
Version	Yes	String	Common Params. The value used for this API: 2018-03-28.
Region	Yes	String	Common Params. For more information, please see the list of regions supported by the product. This API only supports: ap-bangkok, ap-beijing, ap-chengdu, ap-chongqing, ap-guangzhou, ap-hongkong, ap-jakarta, ap-nanjing, ap-seoul, ap-shanghai, ap-shanghai-fsi, ap-shenzhen-fsi, ap-singapore, ap-tokyo, eu-frankfurt, na-ashburn, na-siliconvalley, sa-saopaulo.
ProjectId	No	Integer	Project ID Status	No	Integer	Instance status. Valid values:

1: applying 2: running 3: running restrictedly (primary/secondary switching) 4: isolated 5: repossessing 6: repossessed 7: executing task (e.g., backing up or rolling back instance) 8: deactivated 9: scaling out instance 10: migrating instance 11: read-only 12: restarting

Offset	No	Integer	Page number. Default value: 0 Limit	No	Integer	Number of results per page. Value range: 1-100. Default value: 100 InstanceIdSet.N	No	Array of String	One or more instance IDs in the format of mssql-si2823jyl PayMode	No	Integer	Retrieves billing type. 0: pay-as-you-go VpcId	No	String	Unique string-type ID of instance VPC in the format of vpc-xxx. If an empty string ("") is passed in, filtering will be made by basic network.
SubnetId	No	String	Unique string-type ID of instance subnet in the format of subnet-xxx. If an empty string ("") is passed in, filtering will be made by basic network.
VipSet.N	No	Array of String	The list of instance private IPs, such as 172.1.0.12 InstanceNameSet.N	No	Array of String	The list of instance names used for fuzzy match VersionSet.N	No	Array of String	The list of instance version numbers, such as 2008R2, 2012SP3 Zone	No	String	Instance availability zone, such as ap-guangzhou-3 TagKeys.N	No	Array of String	The list of instance tags SearchKey	No	String	Keyword used for fuzzy match, including instance ID, instance name, and instance private IP UidSet.N	No	Array of String	Unique Uid of an instance InstanceType	No	String	Instance type. HA: high-availability instance; RO: read-only instance; SI: basic edition instance; BI: business intelligence service instance; cvmHA: dual-server high-availability instance with cloud disk; cvmRO: read-only instance with cloud disk; MultiHA: multi-node instance; cvmMultiHA: multi-node instance with cloud disk.
PaginationType	No	String	Pagination query method. offset - pagination query by offset; pageNumber - pagination query by number of pages. The default value is pageNumber.

3. Output Parameters
Parameter Name	Type	Description TotalCount	Integer	Total number of eligible instances. If the results are returned in multiple pages, this value will be the number of all eligible instances but not the number of instances returned according to the current values of Limit and Offset DBInstances	Array of DBInstance	Instance list RequestId	String	The unique request ID, generated by the server, will be returned for every request (if the request fails to reach the server for other reasons, the request will not obtain a RequestId). RequestId is required for locating a problem.

4. Example

Example1 Querying the list of instances

Input Example POST / HTTP/1.1 Host: sqlserver.intl.tencentcloudapi.com Content-Type: application/json X-TC-Action: DescribeDBInstances

{ "Status": "2", "SearchKey": "172.17.0.12", "VpcId": "vpc-mknbt351", "Zone": "ap-guangzhou-3", "VersionSet": [ "2008R2" ], "ProjectId": "0", "Offset": "0", "PayMode": "1", "Limit": "3", "InstanceIdSet": [ "mssql-3l3fgqn7" ], "SubnetId": "subnet-f72hylo6", "TagKeys": [ "Test tag" ], "VipSet": [ "172.1.0.12" ], "InstanceNameSet": [ "Data warehouse" ] }

Output Example { "Response": { "DBInstances": [ { "BackupCycle": [ 1 ], "BackupCycleType": "daily", "BackupModel": "master_pkg", "BackupSaveDays": 7, "BackupTime": "07:03:00", "Collation": "Chinese_PRC_CI_AS", "Cpu": 4, "CreateTime": "2022-11-07 16:21:01", "CrossBackupEnabled": "disable", "CrossBackupSaveDays": 0, "CrossRegions": [], "DnsPodDomain": "", "EndTime": "0000-00-00 00:00:00", "HAFlag": "SINGLE", "InstanceId": "mssql-fz80u7u1", "InstanceNote": "", "InstanceType": "SI", "IsolateOperator": "", "IsolateTime": "0000-00-00 00:00:00", "Memory": 8, "Model": 2, "Name": "2008-2012-2016", "PayMode": 0, "Pid": 1003456, "ProjectId": 0, "ROFlag": "", "Region": "ap-guangzhou", "RegionId": 1, "RenewFlag": 0, "ResourceTags": null, "IsDrZone": false, "SlaveZones": { "SlaveZone": "", "SlaveZoneName": "" }, "StartTime": "2022-11-07 16:21:01", "Status": 2, "Storage": 40, "SubFlag": "", "SubnetId": 2118677, "TgwWanVPort": 0, "TimeZone": "China Standard Time", "Type": "CLOUD_PREMIUM", "Uid": "gamedb.gz1208.cdb.db", "UniqSubnetId": "subnet-ieianm0o", "UniqVpcId": "vpc-o739nubl", "UpdateTime": "2022-11-07 20:04:03", "UsedStorage": 0, "Version": "2019", "VersionName": "SQL Server 2019 Enterprise", "Vip": "10.24.12.28", "VpcId": 5350471, "Vport": 1433, "Zone": "ap-guangzhou-1" "ZoneId": 100003 } ], "RequestId": "de641788-0565-4617-a7f4-639de128772b", "TotalCount": 1 } }

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
InternalError.SystemError	System error.
InternalError.UnknownError	Unknown error.
InvalidParameter	Invalid parameter.
InvalidParameter.InputIllegal	Input error.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
ResourceNotFound.VpcNotExist	The VPC does not exist.
ResourceUnavailable.VpcNotExist	VPC not found.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
Previous Topic: CreateCloudDBInstances Next Topic: DescribeCrossRegionZone Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. API Description
2. Input Parameters
3. Output Parameters
4. Example
Example1 Querying the list of instances
5. Developer Resources
SDK Command Line Interface
6. Error Code
Search AllCurrent Product Search titles only Enter keywords to search documentation
