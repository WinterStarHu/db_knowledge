# Error Codes

> 来源: https://www.tencentcloud.com/document/product/409/34882

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL ​​API Reference Error Codes Error Codes Download Focus Mode Font Size Last updated: 2026-06-11 16:01:35

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

Service Error Codes Error Code	Description AccountNotExist	The current account does not exist.
AuthFailure	CAM signature/authentication error.
DBError	Backend database execution error.
FailedOperation.AllocateQuotasError	Failed to request a quota for resource tags.
FailedOperation.BaseNetworkAccessError	Failed to access classic network. Please try again later. If the problem persists, please contact customer service.
FailedOperation.CMQResponseError	Failed to access CMQ.
FailedOperation.CamAuthFailed	CAM authentication failed.
FailedOperation.CamCheckResourceError	Failed to get permissions. Please try again later. If the problem persists, please contact customer service.
FailedOperation.CamCheckResourceFailed	Failed to check resource permissions through CAM.
FailedOperation.CamSigAndAuthError	Authentication failed. Please try again later. If the problem persists, please contact customer service.
FailedOperation.CdbCgwConnectError	Failed to get project information. Please try again later. If the problem persists, please contact customer service.
FailedOperation.CheckAccountCAMCloseError	Checking database account status error: the account has enabled CAM verification. the current operation is not supported.
FailedOperation.CheckAccountCAMOpenError	Check database account status error: disabled for account CAM verification. the current operation is not supported.
FailedOperation.CreateBasicNetworkDeniedError	Classic network creation is unsupported.
FailedOperation.CreateOrderFailed	Failed to create the renewal order.
FailedOperation.DBError	Database access failed.
FailedOperation.DatabaseAccessError	Failed to access database management service. Please try again later. If the problem persists, please contact customer service.
FailedOperation.DatabaseAffectedError	Data operation failed. Please contact customer service.
FailedOperation.DeleteAllRoute	Failed to delete VPC routes.
FailedOperation.DeleteResourceProjectTagError	Failed to unbind resources from a project.
FailedOperation.DeleteResourcesToTagError	Failed to unbind the resource from the tag.
FailedOperation.ESConnectError	Failed to access ES. Please try again later. If the problem persists, please contact customer service.
FailedOperation.ESQueryError	Failed to query ES. Please try again later. If the problem persists, please contact customer service.
FailedOperation.FailedOperationError	Operation failed. Please try again later.
FailedOperation.FlowCreateError	Failed to create a task. Please try again later. If the problem persists, please contact customer service.
FailedOperation.GetInstanceByResourceIdError	Failed to query the instance information. Please try again later.
FailedOperation.GetPurchaseRecordFailed	Failed to get the purchase record.
FailedOperation.GetSubnetError	Failed to query VPC subnets.
FailedOperation.GetVpcInfoError	Failed to query VPC information. Please try again later. If the problem persists, please contact customer service.
FailedOperation.IllegalROInstanceNum	Invalid number of read-only replicas.
FailedOperation.InvalidAccountStatus	The account status is incorrect, so the operation is not allowed.
FailedOperation.InvalidTradeOperate	Billing error. Corresponding purchase/renewal/configuration change operations are not allowed for the current instance.
FailedOperation.LimitOperation	Operations are not allowed on the instance.
FailedOperation.MasterInstanceQueryError	Failed to query the primary instance information.
FailedOperation.ModifyROGroupError	Failed to modify RO group configuration.
FailedOperation.NetworkNumLimitError	The number of networks does not meet resource requirements.
FailedOperation.NoAvailableStandby	The instance has no available standby server.
FailedOperation.OperateFrequencyLimitedError	The operation frequency limit is exceeded. Try again later. If the problem persists, contact customer service.
FailedOperation.OssAccessError	Failed to access database management service. Please try again later. If the problem persists, please contact customer service.
FailedOperation.OssOperationFailed	Failed to request the backend API.
FailedOperation.PayOrderFailed	Failed to make order payment.
FailedOperation.PostPaidUnblockError	Failed to unfreeze the account of a pay-as-you-go instance. Please try again later. If the problem persists, please contact customer service.
FailedOperation.PreCheckError	Pre-check failed FailedOperation.PresignedURLGetError	An error occurred while getting the pre-signed authorization URL.
FailedOperation.QueryDealFailed	Failed to query the order information.
FailedOperation.QueryInstanceBatchError	Failed to query instance information in batches. Please try again later. If the problem persists, please contact customer service.
FailedOperation.QueryPriceFailed	Failed to query the price.
FailedOperation.QuerySpecBySpecCodeError	Failed to query specifications.
FailedOperation.QuerySpecError	Failed to query specifications. Please try again later. If the problem persists, please contact customer service.
FailedOperation.QueryTradeStatusError	Failed to query the order status.
FailedOperation.QueryVpcFailed	Failed to query VPC.
FailedOperation.QueryVpcFalied	Failed to get VPC details.
FailedOperation.ROGroupCannotBeDeletedError	This RO group has at least one read-only replica, so it cannot be deleted.
FailedOperation.ROGroupMasterInstanceNotRight	The primary instance information of the RO group is not matched.
FailedOperation.ROGroupNotFoundError	The RO group does not exist.
FailedOperation.ROGroupNumExceedError	The maximum number of RO groups has been reached.
FailedOperation.ROInstanceHasInROGroupError	This read-only replica already belongs to another RO group.
FailedOperation.ServerlessNotSupportedError	Serverless instances do not support the operation.
FailedOperation.ServiceAccessError	Failed to access internal service. Please try again later. If the problem persists, please contact customer service.
FailedOperation.SetAutoRenewFlagError	Failed to set the auto-renewal flag.
FailedOperation.StorageMemoryCheckError	The memory and storage capacity to which an instance is upgraded should be higher than its original memory and storage capacity.
FailedOperation.StorePathSplitError	Incorrect storage path format FailedOperation.TradeAccessError	Failed to access the billing platform. Please try again later. If the problem persists, please contact customer service.
FailedOperation.TradeCreateError	Failed to request the billing platform to create an order.
FailedOperation.TradePayOrdersError	Failed to request to pay for the order.
FailedOperation.TradeQueryOrderError	Failed to query order information. Please try again later. If the problem persists, please contact customer service.
FailedOperation.TradeQueryPriceError	Failed to query pricing information. Please try again later. If the problem persists, please contact customer service.
FailedOperation.UpdateResourceProjectTagValueError	Failed to modify the resource tag.
FailedOperation.VPCResetServiceError	Failed to configure the VPC.
FailedOperation.VPCUpdateRouteError	Failed to update VPC routes.
FailedOperation.WhitelistConnectError	Failed to query the allowlist. Try again later. If the problem persists, contact customer service.
FlowError	Failed to create the task.
InstanceNotExist	The current instance does not exist.
InterfaceNameNotFound	ACTION input error.
InternalError.CgwError	CGW error.
InternalError.CnsError	Basic network error.
InternalError.DBError	Backend database execution error.
InternalError.DfwError	DFW error.
InternalError.FlowError	Failed to create the flow.
InternalError.HttpError	Service exception. please retry later.
InternalError.InstanceDataError	Failed to access database management service. Please contact customer service.
InternalError.InternalHttpServerError	An exception occurred while executing the request.
InternalError.JsonParseError	Json data parsing failed. contact our customer service for assistance.
InternalError.ListInstancesError	Instance does not exist InternalError.MarshalError	Failed to parse background data. Please contact customer service.
InternalError.SystemError	System error. When this error occurs, please contact customer service for assistance.
InternalError.TransactioBeginError	Failed to enable transactions InternalError.UnknownError	Unknown error. When this error occurs, please contact customer service for assistance.
InternalError.VpcError	VPC error.
InvalidAccountPassword	Incorrect account password.
InvalidAccountStatus	The current account status is incorrect, so the operation is not allowed.
InvalidInstanceStatus	Incorrect instance status.
InvalidParameter.ExceptionParam	Parameter exception.
InvalidParameter.IllegalInputParameter	Invalid parameters.
InvalidParameter.InvalidParameterError	Invalid parameters.
InvalidParameter.ParameterCheckError	Failed to check the parameter.
InvalidParameter.ParametersNotSet	You can't left all parameters empty.You need to set at least one of the parameters.
InvalidParameter.TradeAccessDeniedError	Incorrect PID InvalidParameter.VpcNotFoundError	Failed to query VPC information.
InvalidParameterValue.AccountExist	The current account already exists.
InvalidParameterValue.AccountNotExist	The current account does not exist.
InvalidParameterValue.AccountNotExistError	The account does not exist.
InvalidParameterValue.BadSpec	The instance specification to upgrade to is not purchasable.
InvalidParameterValue.CharsetNotFoundError	Incorrect database character set InvalidParameterValue.DataConvertError	Failed to convert data format. Please contact customer service.
InvalidParameterValue.DecryptPasswordFailed	Decrypting the password failed. confirm whether the password encryption is correct.
InvalidParameterValue.IllegalChargeType	Unsupported billing type.
InvalidParameterValue.IllegalInstanceChargeType	Incorrect billing mode.
InvalidParameterValue.IllegalProjectId	Invalid ProjectId.
InvalidParameterValue.IllegalRegion	Invalid Region parameter.
InvalidParameterValue.IllegalZone	Invalid Zone parameter.
InvalidParameterValue.InstanceNotExist	The current instance does not exist.
InvalidParameterValue.InterfaceNameNotFound	Incorrect ACTION.
InvalidParameterValue.InvalidAccountError	Invalid account. The account name is case-insensitive, must contain 1-16 characters comprised of letters, digits, underscores, and should neither be "postgres" nor start with a digit or "pg_".
InvalidParameterValue.InvalidAccountFormat	Incorrect account format.
InvalidParameterValue.InvalidAccountName	The current account name cannot be a reserved character.
InvalidParameterValue.InvalidAccountNameError	The account setting is invalid. please follow the account naming rules: the account name must be 1-16 characters, can only consist of letters, digits, or underscores; cannot be postgres; cannot start with a digit, pg_, or tencentdb_; all rules are case-insensitive.
InvalidParameterValue.InvalidAccountNameFormatError	The account is invalid. follow the account naming rules: it must consist of letters (a-z, a-z), digits (0-9), and underscores (_), start with a letter or underscore (_), and be no more than 63 characters. system reserved keywords cannot be used, 'postgres' is not allowed, and it cannot start with 'pg_' or 'tencentdb_'.
InvalidParameterValue.InvalidCharset	Incorrect database character set. Currently, only UTF8 and LATIN1 are supported.
InvalidParameterValue.InvalidDatabaseNameFormatError	The database name is invalid. follow the naming rule: it must be made up of letters (a-z, a-z), digits (0-9), or underscores (_), start with a letter or underscore (_), and be no more than 63 characters. system reserved keywords cannot be used.
InvalidParameterValue.InvalidDatabaseObjectName	Currently only support database objects with operation names composed of english, underscore, digits, and special symbols []. functions and stored procedures additionally support three special symbols (,).
InvalidParameterValue.InvalidInstanceNum	The number of purchased instances exceeds the limit.
InvalidParameterValue.InvalidInstanceVolume	The instance specification to upgrade to cannot be lower than the current instance specification.
InvalidParameterValue.InvalidOrderNum	Billing error. Invalid order type ID.
InvalidParameterValue.InvalidParameterValueError	Incorrect parameter value InvalidParameterValue.InvalidPasswordFormat	Incorrect password format.
InvalidParameterValue.InvalidPasswordLengthError	Invalid password. The password length does not meet the requirements.
InvalidParameterValue.InvalidPasswordValueError	Invalid password. The password must contain uppercase letters, lowercase letters, digits, and symbols (()`~!@#$%^&*-+=_ InvalidParameterValue.InvalidPid	Incorrect PID parameter.
InvalidParameterValue.InvalidReadOnlyGroupStatus	RO group in incorrect status InvalidParameterValue.InvalidRegionIdError	Invalid region InvalidParameterValue.InvalidZoneIdError	Invalid availability zone.
InvalidParameterValue.NullDealNames	Empty order name.
InvalidParameterValue.ParameterCharacterError	Invalid parameter. The parameter can contain only letters, digits, underscores, and hyphens.
InvalidParameterValue.ParameterCharacterLimitError	The parameter is invalid. Please modify it and try again.
InvalidParameterValue.ParameterHandleError	Failed to process the parameter. Please check if the parameter value is valid.
InvalidParameterValue.ParameterLengthLimitError	The length of parameter exceeds the limit.
InvalidParameterValue.ParameterOutOfRange	Invalid parameter InvalidParameterValue.ParameterOutRangeError	Invalid parameter values.
InvalidParameterValue.ParameterValueExceedError	The maximum value of the parameter has been reached.
InvalidParameterValue.ReadOnlyGroupNotExist	The RO group does not exist.
InvalidParameterValue.RegionNotSupported	The current region is not supported.
InvalidParameterValue.SpecNotRecognizedError	Failed to identify the specification ({{1}}).
InvalidParameterValue.StructParseFailed	An error occurred while parsing parameters.
InvalidParameterValue.UnsupportedRegionError	The incoming region does not support this API feature.
InvalidPid	Incorrect PID parameter.
LimitOperation	Operations are not allowed on the instance.
OperationDenied.AccountOperationDenied	No user permissions.
OperationDenied.AuditFileOverQuotaError	Download task limit exceeded.
OperationDenied.CamDeniedError	This operation cannot be performed.
OperationDenied.DTSInstanceStatusError	The target instance failed the status check.
OperationDenied.DeleteRunningBackupTaskErr	In-progress backups cannot be deleted.
OperationDenied.InstanceAccessDeniedError	You do not have the permission to operate this resource.
OperationDenied.InstanceIpv6NotSupportedError	IPv6 is not supported.
OperationDenied.InstanceStatusDeniedError	This operation cannot be performed on an instance in this status.
OperationDenied.InstanceStatusLimitError	This operation cannot be performed on an instance in this status.
OperationDenied.InstanceStatusLimitOpError	This operation cannot be performed on an instance in this status.
OperationDenied.InstanceTypeDenied	Invalid instance type OperationDenied.InsufficientBalanceError	Insufficient account balance.
OperationDenied.InternalTradeErrorErr	Billing failure.
OperationDenied.KernelVersionError	The kernel version is too low, causing the instance to fail to create a tencentDBSuper account. if you want to use this feature, upgrade the kernel.
OperationDenied.PayModeError	Unsupported billing mode OperationDenied.PostPaidPayModeError	Pay-as-you-go instances cannot be renewed.
OperationDenied.ROGroupStatusError	This operation cannot be performed on an RO group in this status.
OperationDenied.ROInstanceIpv6NotSupportedError	Read-only instances do not support IPv6.
OperationDenied.ROInstanceStatusLimitOpError	This operation cannot be performed on a read-only instance in this status.
OperationDenied.ResourceNotFoundError	The instance does not exist.
OperationDenied.ResourceNotFundError	The instance does not exist.
OperationDenied.RoInstanceCountExeedError	The total number of read-only nodes should not exceed the upper limit.
OperationDenied.TradePermissionError	No payment permission. activation failed.
OperationDenied.UserNotAuthenticatedError	You need to verify your identity to make a purchase.
OperationDenied.UserNotInWhiteListError	User not in allowlist.
OperationDenied.VpcDeniedError	You do not have the permission to operate the VPC.
RegionNotSupported	The region is not supported.
ResourceInsufficient.ResourceNotEnough	There are not enough resources to purchase instances of this specification in the current region.
ResourceNotFound.InstanceNotFoundError	The instance does not exist.
ResourceUnavailable.InvalidInstanceStatus	Incorrect instance status.
ResourceUnavailable.ResourceNoPermission	No permission for the VPC.
ResourceUnavailable.VpcResourceNotFound	Failed to get the information of the VPC where the instance resides.
StructParseFailed	An error occurred while parsing parameters.
SystemError	System error. When this error occurs, please contact customer service for assistance.
UnauthorizedOperation.UserHasNoRealnameAuthentication	Unverified user.
UnknownError	Unknown error. When this error occurs, please contact customer service for assistance.
UnknownParameter.CreateAuditLogFileError	Error creating an audit log file.
UnknownParameter.HttpError	Service exception. please retry later.
UnknownParameter.InternalInnerServiceError	Internal service exception. Please retry later.
VpcError	VPC error Previous Topic: Data Types Next Topic: Information Security Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feature Description Error Code List Common Error Codes Service Error Codes Search AllCurrent Product Search titles only Enter keywords to search documentation
