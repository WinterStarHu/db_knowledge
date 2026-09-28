# Error Codes

> 来源: https://www.tencentcloud.com/document/product/238/32136

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Error Codes Error Codes Download Focus Mode Font Size Last updated: 2026-06-30 11:29:36

Feature Description

If there is an Error field in the response, it means that the API call failed. For example:

{ "Response": { "Error": { "Code": "AuthFailure.SignatureFailure", "Message": "The provided credentials could not be validated. Please check your signature is correct." }, "RequestId": "ed93f3cb-f35e-473f-b9f3-0d451b8b79c6" } }

Code in Error indicates the error code, and Message indicates the specific information of the error.

Error Code List

Common Error Codes Error Code	Description ActionOffline	This API has been deprecated.
AuthFailure.InvalidAuthorization	Authorization in the request header is invalid.
AuthFailure.InvalidSecretId	Invalid key (not a TencentCloud API key type).
AuthFailure.MFAFailure	MFA failed.
AuthFailure.SecretIdNotFound	Key does not exist. Check if the key has been deleted or disabled in the console, and if not, check if the key is correctly entered. Note that whitespaces should not exist before or after the key.
AuthFailure.SignatureExpire	Signature expired. Timestamp and server time cannot differ by more than five minutes. Please ensure your current local time matches the standard time.
AuthFailure.SignatureFailure	Invalid signature. Signature calculation error. Please ensure you’ve followed the signature calculation process described in the Signature API documentation.
AuthFailure.TokenFailure	Token error.
AuthFailure.UnauthorizedOperation	The request is not authorized. For more information, see the CAM documentation.
DryRunOperation	DryRun Operation. It means that the request would have succeeded, but the DryRun parameter was used.
FailedOperation	Operation failed.
InternalError	Internal error.
InvalidAction	The API does not exist.
InvalidParameter	Incorrect parameter.
InvalidParameterValue	Invalid parameter value.
InvalidRequest	The multipart format of the request body is incorrect.
IpInBlacklist	Your IP is in uin IP blacklist.
IpNotInWhitelist	Your IP is not in uin IP whitelist.
LimitExceeded	Quota limit exceeded.
MissingParameter	A parameter is missing.
NoSuchProduct	The product does not exist.
NoSuchVersion	The API version does not exist.
RequestLimitExceeded	The number of requests exceeds the frequency limit.
RequestLimitExceeded.GlobalRegionUinLimitExceeded	Uin exceeds the frequency limit.
RequestLimitExceeded.IPLimitExceeded	The number of ip requests exceeds the frequency limit.
RequestLimitExceeded.UinLimitExceeded	The number of uin requests exceeds the frequency limit.
RequestSizeLimitExceeded	The request size exceeds the upper limit.
ResourceInUse	Resource is in use.
ResourceInsufficient	Insufficient resource.
ResourceNotFound	The resource does not exist.
ResourceUnavailable	Resource is unavailable.
ResponseSizeLimitExceeded	The response size exceeds the upper limit.
ServiceUnavailable	Service is unavailable now.
UnauthorizedOperation	Unauthorized operation.
UnknownParameter	Unknown parameter.
UnsupportedOperation	Unsupported operation.
UnsupportedProtocol	HTTP(S) request protocol error; only GET and POST requests are supported.
UnsupportedRegion	API does not support the requested region.

Service Error Codes Error Code	Description AuthFailure	CAM signature/authentication error FailedOperation.CosError	Failed to access COS.
FailedOperation.CosPropertiesError	Errors occurred while acquiring uploaded configuration information.
FailedOperation.CreateOrderFailed	Failed to create order.
FailedOperation.DBError	Database error.
FailedOperation.DomainOperationFailed	Public network operation failed.
FailedOperation.GcsError	The operation failed or the network timed out.
FailedOperation.GetVpcFailed	Failed to get VPC information.
FailedOperation.MigrationLockError	Locking the backup import task failed.
FailedOperation.NotSupport	The operation is not supported.
FailedOperation.QueryOrderFailed	Failed to query order.
FailedOperation.QueryPriceFailed	Billing error. Failed to query price.
FailedOperation.SecurityGroupOperationError	Security group operation failed.
FailedOperation.VPCError	Failed to operate the network or the session timed out.
InternalError.CamAuthFailed	CAM authentication request failed.
InternalError.CosError	COS API error.
InternalError.CreateFlowFailed	Failed to create flow.
InternalError.DBConnectError	Database connection error.
InternalError.DBError	Database error InternalError.DataError	A data error occurs.
InternalError.GcsError	GCS API error.
InternalError.StsError	Errors occurred while acquiring temporary keys.
InternalError.SystemError	System error.
InternalError.UnknownError	Unknown error.
InternalError.VPCError	VPC error InvalidParameter.InputIllegal	Input error.
InvalidParameter.InterfaceNameNotFound	The API does not exist.
InvalidParameter.NotSupportPubSubInstance	Instances with publish-subscribe relationships are not supported.
InvalidParameter.NotSupportReadOnlyMasterInstance	Primary instances with read-only replicas are not supported.
InvalidParameter.NotSupportSingleInstance	Single-node edition (basic edition or RO replica) instances are not supported.
InvalidParameter.ParamsAssertFailed	An error occurred while converting parameter assertion.
InvalidParameter.PayOrderFailed	Failed to make order payment.
InvalidParameterValue.AccountExist	Account already exists.
InvalidParameterValue.AccountNameIsIllegal	The account name is invalid.
InvalidParameterValue.AccountNameIsKeyWords	The account name includes restricted contents.
InvalidParameterValue.AccountRemarkIsIllegal	The account remarks are invalid.
InvalidParameterValue.AdminAccountNotUnique	You can only apply for one admin account.
InvalidParameterValue.BackupNameIsIllegal	The backup name contains invalid characters.
InvalidParameterValue.BadGoodsNum	Invalid number of purchased instances.
InvalidParameterValue.CharsetIsIllegal	The database character set is incorrectly set.
InvalidParameterValue.CosPathError	Wrong upload path.
InvalidParameterValue.CostTypeNotSupported	Billing type error.
InvalidParameterValue.DBCharIllegal	The database name contains invalid characters.
InvalidParameterValue.DBExist	The database already exists.
InvalidParameterValue.DBNameIsKeyWrods	The database name cannot contain reserved words.
InvalidParameterValue.DBNameNotNull	The database name is required.
InvalidParameterValue.DBNameSame	The new database name is the same as the old one.
InvalidParameterValue.DataBaseRemarkIsIllegal	The database remarks are invalid.
InvalidParameterValue.GrantIsIllegal	Invalid parameter. The value of GRANT is invalid.
InvalidParameterValue.IllegalRegion	Invalid region.
InvalidParameterValue.IllegalSpec	Incorrect instance specification information.
InvalidParameterValue.IllegalZone	Incorrect AZ ID.
InvalidParameterValue.InstanceExpandVolumeLow	The expansion capacity of the instance is lower than the current capacity.
InvalidParameterValue.InstanceNameIsIllegal	The instance name contains invalid characters.
InvalidParameterValue.MigrationNameIsIllegal	The migration name contains invalid characters.
InvalidParameterValue.ModifyTypeValueInvalid	Only enable and disable are valid values.
InvalidParameterValue.OnCvmTypeNotSupported	Basic edition instances are not supported.
InvalidParameterValue.ParameterTypeError	Incorrect parameter type.
InvalidParameterValue.PasswordIsIllegal	The account and password are invalid.
InvalidParameterValue.PrivilegeIsIllegal	Incorrect database permission settings.
InvalidParameterValue.PubSubNameIsIllegal	The publish/subscribe name does not meet the requirements.
InvalidParameterValue.RoGroupNameIsIllegal	Read-only group name contains invalid characters.
InvalidParameterValue.RoGroupStatusIsIllegal	The read-only group status is abnormal.
InvalidParameterValue.SecurityGroupIdIsIllegal	Invalid security group ID.
LimitExceeded.TooManyDB	The database limit is exceeded.
ResourceInUse.IncrementalMigrationExist	An incremental backup import task to be started already exists.
ResourceNotFound.AccountNotExist	The account does not exist.
ResourceNotFound.BackupNotFound	The backup does not exist.
ResourceNotFound.DBNotExit	The database does not exist.
ResourceNotFound.DBNotFound	The database does not exist.
ResourceNotFound.FullBackupMigrationNotExist	The full backup import task does not exist.
ResourceNotFound.IncreBackupMigrationNotExist	The incremental backup import task does not exist.
ResourceNotFound.InstanceNotFound	The instance does not exist.
ResourceNotFound.ParamsNotFound	Parameter not found.
ResourceNotFound.VpcNotExist	The VPC does not exist.
ResourceUnavailable.AccountInvalidStatus	Invalid account status.
ResourceUnavailable.BackupMigrationRecoveryTypeErr	The restoration type does not support incremental backup import.
ResourceUnavailable.CosStatusErr	A wrong status of offline restoration tasks.
ResourceUnavailable.DBInvalidStatus	Invalid database status.
ResourceUnavailable.InstanceMigrateRegionIllegal	Invalid instance migration region.
ResourceUnavailable.InstanceMigrateStatusInvalid	Invalid instance migration status.
ResourceUnavailable.InstanceStatusInvalid	Invalid instance status.
ResourceUnavailable.NotSupportRoInstance	Read-Only instances are not supported.
ResourceUnavailable.VpcNotExist	VPC not found.
UnauthorizedOperation.PermissionDenied	CAM authentication error.
UnsupportedOperation.NotSupportRepeat	Repeated operations are not supported.
UnsupportedOperation.UploadTypeError	A wrong upload type.
Previous Topic: Data Types Next Topic: FAQ Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feature Description Error Code List Common Error Codes Service Error Codes Search AllCurrent Product Search titles only Enter keywords to search documentation
