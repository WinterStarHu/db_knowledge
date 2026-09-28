# Error Codes

> 来源: https://www.tencentcloud.com/document/product/236/34489

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL ​​API Reference Error Codes Error Codes Download Focus Mode Font Size Last updated: 2026-08-06 16:09:11 Feature Description

If there is an Error field in the response, it means that the API call failed. For example:

{ "Response": { "Error": { "Code": "AuthFailure.SignatureFailure", "Message": "The provided credentials could not be validated. Please check your signature is correct." }, "RequestId": "ed93f3cb-f35e-473f-b9f3-0d451b8b79c6" } }

Code in Error indicates the error code, and Message indicates the specific information of the error.

Error Code List Common Error Codes Error Code	Description ActionOffline	This API has been deprecated.
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
Service Error Codes Error Code	Description AuthFailure	CAM signature/authentication error.
AuthFailure.SubAccountDenied	The sub-account has no permissions.
CdbError	Backend or process error.
CdbError.BackupError	Backup error.
CdbError.DatabaseError	Backend database error.
CdbError.ImportError	Import task error.
CdbError.TaskError	Backend task error.
FailedOperation.AsyncTaskStatusError	Async task exception.
FailedOperation.AuditConfigNotExist	Audit not found.
FailedOperation.CdbInstanceLockFailError	Failed to lock the instance while performing exclusive operations. Please try again later.
FailedOperation.CreateAccountError	Creation failed. Please check whether the user already exists.
FailedOperation.CreateAuditFailError	Failed to create the audit rule.
FailedOperation.CreateAuditLogFileError	Failed to create an audit log file.
FailedOperation.CreateRoVipError	Failed to assign an exclusive VIP to the read-only replica.
FailedOperation.DBOperationActionError	Database operation failed.
FailedOperation.DescribeProxyGroupError	Failed to query database proxy.
FailedOperation.FailedOperationError	Unsupported operation FailedOperation.GetPrivilegeError	An error occurred while obtaining permissions.
FailedOperation.InstanceQueryError	Query failed.
FailedOperation.InstanceTaskConflictError	An error occurred due to instance task conflict.
FailedOperation.JsonUnmarshalError	Failed to deserialize JSON.
FailedOperation.LogContentOverLimit	Data volume is too large. Reduce the data query range.
FailedOperation.NotChangeStrategy	No policy modification detected FailedOperation.NotDelayRo	It is not a read-only instance with delayed replication enabled.
FailedOperation.OperationInConflictError	The instance is busy with other operations. Please try again later.
FailedOperation.PrivilegeDataIllegal	The executed operation to modify permissions is invalid. You can refer to product documentation for more information about permissions that can be modified for this instance. If you have any questions, please contact customer service.
FailedOperation.ProxyGroupStatusError	Database proxy in an exceptional status.
FailedOperation.QueryAuditTaskFailError	Failed to query the audit task FailedOperation.QueryLogError	Log query failed.
FailedOperation.RemoteCallUnmarshalError	Cross-region deserialization failed for the high-availability service.
FailedOperation.RepeatCreateProxyError	The proxy is being created or already exists. You cannot create it again.
FailedOperation.ResponseValueError	Exception with the backend request for the service. Please contact customer service.
FailedOperation.ResultSetOverLimit	The result set size of queried logs exceeds the limit. Please select a shorter time range.
FailedOperation.ServiceAccessError	Log query failed. Please retry later or narrow down the query scope. If it continues to be unsuccessful, contact our customer service for handling.
FailedOperation.StartFlowError	Failed to initiate the operation. Please try again later. If the operation remains unsuccessful, please contact customer service.
FailedOperation.StatusConflict	Task status conflict.
FailedOperation.SubmitAsyncTaskError	Failed to submit the task. Please try again later. If the submission remains unsuccessful, please contact customer service.
FailedOperation.TaskConflictError	A same task already exists FailedOperation.TimeoutError	The query timed out.
FailedOperation.TypeInConflict	This type of operations cannot be performed.
FailedOperation.VpcIpInUseError	The IP has been occupied.
FailedOperation.VpcIpInvalidError	Invalid IP address FailedOperation.VpcIpNotInSubnetError	The IP doesn’t exist in the subnet.
InternalError.AsyncRequestError	An error occurred while querying async tasks.
InternalError.AuditCreateLogFileError	Error creating an audit log file.
InternalError.AuditDeleteLogFileError	Error deleting the audit log.
InternalError.AuditDeletePolicyError	Internal audit service error.
InternalError.AuditDescribeLogError	Failed to query the audit log InternalError.AuditError	An error occurred in the internal service of the audit service.
InternalError.AuditModifyStatusError	Failed to modify audit status.
InternalError.AuditOssLogicError	Internal exception of the audit service.
InternalError.AuthError	Authentication failed.
InternalError.CauthError	Authentication failed.
InternalError.CdbCgwError	Internal system error.
InternalError.CdbError	System error.
InternalError.CosError	Failed to obtain file information.
InternalError.DBError	Database exception InternalError.DBOperationError	Database operation failed.
InternalError.DBRecordNotExistError	The database instance does not exist.
InternalError.DatabaseAccessError	Internal database error.
InternalError.DesError	Internal system error.
InternalError.DfwError	Security group operation error.
InternalError.ExeSqlError	SQL statement error InternalError.ExecHttpRequestError	Failed to execute the HTTP request InternalError.ExecuteSQLError	Failed to execute SQL statement InternalError.FtpError	File transfer exception InternalError.HttpError	Exceptional HTTP request InternalError.HttpRequestError	Request failed.
InternalError.ImportError	Import failed InternalError.InnerCommonError	Internal service error InternalError.InternalAssertError	Internal service error. Please contact customer service.
InternalError.InternalHttpServerError	An exception occurred while executing the request.
InternalError.InternalInnerServiceError	Internal service exception. Try again later.
InternalError.InternalRequestError	The backend failed to request the service. Please contact customer service.
InternalError.InternalServiceErrorErr	An error occurred while accessing internal service.
InternalError.JSONError	Failed to parse JSON.
InternalError.KmsError	Failed to enable encryption InternalError.NetworkError	Network error InternalError.OssError	An error occurred in TencentDB for MySQL High-Availability Edition database service.
InternalError.ParamError	Parameter error InternalError.RegexpCompileError	Regular expression compilation error.
InternalError.ResourceNotMatch	The resource does not match.
InternalError.ResourceNotUnique	The resource is not unique.
InternalError.SecurityGroupError	Security group error InternalError.ServerError	Internal error of the system.
InternalError.ServiceError	An exception occurred in the internal service.
InternalError.TagError	Failed to modify the tag. Please try again later.
InternalError.TaskError	Task exception InternalError.TaskFrameError	Async task error.
InternalError.TimeWindowError	Time window error InternalError.TradeError	Transaction system error.
InternalError.TransactioBeginError	Failed to start the transaction.
InternalError.TransactionBeginError	Operation failed InternalError.UndefinedError	Unknown error InternalError.UnknownError	Unknown error InternalError.VpcError	VPC or subnet error.
InvalidParameter.ControllerNotFoundError	This API was not found.
InvalidParameter.DeployGroupNotEmpty	There are resources in the placement group.
InvalidParameter.ExceptionParam	Parameter exception.
InvalidParameter.InstanceNameNotFound	The instance is not found.
InvalidParameter.InstanceNotFound	The instance does not exist.
InvalidParameter.InvalidAsyncRequestId	The async task does not exist.
InvalidParameter.InvalidName	Invalid name.
InvalidParameter.InvalidParameterError	Invalid parameter value InvalidParameter.JsonUnmarshalError	Failed to deserialize JSON.
InvalidParameter.OverDeployGroupQuota	The quota of placement group resources has been exceeded.
InvalidParameter.ResourceExists	The resource already exists.
InvalidParameter.ResourceNotExists	The resource does not exist.
InvalidParameter.ResourceNotFound	The resource is not found.
InvalidParameterValue.AccountDescriptionCharacterError	The account description contains special characters.
InvalidParameterValue.AccountDescriptionLengthError	The account description should not exceed 255 characters.
InvalidParameterValue.AccountHostRuleError	Incorrect format of the host parameter in the account.
InvalidParameterValue.AccountPasswordCharacterError	The account password contains invalid characters.
InvalidParameterValue.AccountPasswordLengthError	The account password is too long or too short.
InvalidParameterValue.AccountPasswordRuleError	The password format is incorrect. It should contain 8 to 64 characters and must contain at least two character sets of the following: letters, digits, and special symbols (_+-&=!@#$%^*()).
InvalidParameterValue.DataConvertError	Data conversion failed.
InvalidParameterValue.InvalidParameterValueError	Invalid parameter value InvalidParameterValue.UserNameRuleError	Incorrect format of the account username.
InvalidParameterValue.UserNotExistError	The account does not exist.
InvalidParameterValue.VerifyAccountNoRootError	No root account found.
InvalidParameterValue.VerifyAccountPasswordError	Invalid account password.
InvalidParameterValue.VerifyAccountPrivError	The account does not have the GRANT permission.
MissingParameter.AccountMissingParameterError	Account-related parameters are missing.
MissingParameter.MissingParamError	Required parameters are missing.
OperationDenied	Operation denied.
OperationDenied.AccountOperationDenied	The Tencent Cloud account is not allowed to perform the operation due to insufficient permissions.
OperationDenied.ActionInProcess	The instance is performing another task.
OperationDenied.ActionNotSupport	Unsupported operation.
OperationDenied.AtLeastAllRuleAuditPolicyError	Security audit is enabled. At least one full audit policy must be retained.
OperationDenied.AtLeastAuditPolicyError	At least one audit policy must be retained.
OperationDenied.AuditFileOverQuotaError	Number of audit log files exceeds the maximum limit.
OperationDenied.AuditPolicyConflictError	The audit policies conflict.
OperationDenied.AuditPolicyExistError	The audit policy already exists.
OperationDenied.AuditPolicyNotExistError	Audit policy not found.
OperationDenied.AuditPolicyOverQuotaError	The number of audit policies exceeds the limit.
OperationDenied.AuditRuleHasBind	The audit rule has been associated.
OperationDenied.AuditRuleNotExistError	The audit rule does not exist.
OperationDenied.AuditStatusError	Exceptional audit status.
OperationDenied.AuditTaskConflictError	The audit tasks conflict.
OperationDenied.ConflictRoStatus	The operation is not allowed as the RO group contains an invalid read-only instance.
OperationDenied.ConflictStatus	The configuration of read-only group is being modified. Please do not make repeated requests.
OperationDenied.DBBrainPolicyConflict	You have enabled the compliance audit feature of DBbrain, so you cannot enable the rule-based audit.
OperationDenied.DelayReplicationRunning	The operation is not allowed during the delayed replication.
OperationDenied.DeleteRootAccountError	The root account cannot be deleted.
OperationDenied.FlowConflict	Process conflict, try again later.
OperationDenied.FunctionDenied	This instance needs permissions to use this feature.
OperationDenied.InstTypeNotSupport	The current instance type does not support this operation.
OperationDenied.InstanceLockerConflict	Instance locks are in conflict. Please try again later.
OperationDenied.InstanceStatusError	Exceptional instance status OperationDenied.InstanceTaskRunning	Delayed replication is not allowed because the instance is executing another task.
OperationDenied.InstanceTaskStatusError	Abnormal instance task status.
OperationDenied.InstanceUnsupportedOperateError	The instance does not support this operation.
OperationDenied.ModifyAuditStatusError	Failed to modify audit status.
OperationDenied.NotSupportBasic	Basic instances do not support this operation (feature).
OperationDenied.NotSupportModifyLocalRootHostError	The host information of the local root account cannot be modified.
OperationDenied.OperationDeniedError	Operation denied OperationDenied.OtherOderInProcess	There are other orders being submitted. Please try again later.
OperationDenied.OverQuota	Resource quota exceeded.
OperationDenied.ProxyAddressLimitError	The number of the proxy addresses exceeds the limit.
OperationDenied.ProxyAddressNotFund	Proxy address is not found.
OperationDenied.ProxyNodeCountLimitError	The number of the proxy nodes exceeds the limit.
OperationDenied.ProxyUpgradeTaskStatusError	This operation is not allowed during database proxy upgrade task.
OperationDenied.QueryAuditLogsError	Failed to query the audit log OperationDenied.ResourceNotFoundError	The resource was not found.
OperationDenied.ResourceNotFundError	The resource was not found.
OperationDenied.ResultOverLimit	The maximum number of results has been reached. Please narrow down your query.
OperationDenied.SubAccountOperationDenied	The Tencent Cloud sub-account is not allowed to perform the operation due to insufficient permissions.
OperationDenied.UnSupportRefundError	This instance is not refundable.
OperationDenied.UnsupportCreateAddressError	Creating a proxy address is not supported.
OperationDenied.UnsupportOpenAuditError	The audit feature cannot be enabled.
OperationDenied.UserHasNoStrategy	This account is not authorized to access the requested resource.
OperationDenied.WrongPassword	Incorrect password or verification failed.
OperationDenied.WrongStatus	The backend task status is invalid.
OverQuota	Limit exceeded.
ResourceNotFound.CdbInstanceNotFoundError	The instance cannot be found. Please check whether your instance status is normal.
ResourceNotFound.InstanceNotFoundError	The instance does not exist.
ResourceNotFound.InstanceNotFundError	The instance does not exist.
UnauthorizedOperation.NotEnoughPrivileges	Verification failed. Insufficient permissions.
UnsupportedOperation.NotSupportNormalInstance	The current operation is not supported for instances with no resource usage limit.
UnsupportedOperation.PrivilegesUnsupportedError	Unsupported permission.
Previous Topic: Data Types Next Topic: Selection Related Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feature Description Error Code List Common Error Codes Service Error Codes Search AllCurrent Product Search titles only Enter keywords to search documentation
