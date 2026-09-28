# Data Types

> 来源: https://www.tencentcloud.com/document/product/409/16778

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL ​​API Reference Data Types Data Types Download Focus Mode Font Size Last updated: 2026-06-11 16:01:34

AccountInfo

Account information

Used by actions: DescribeAccounts.

Name	Type	Description DBInstanceId	String	Instance ID in the format of postgres-lnp6j617 UserName	String	Account Remark	String	Specifies the account remark.
Status	Integer	Account status. valid values: 1-creating, 2-normal, 3-modifying, 4-resetting password, 5-locked, -1-deleting.
CreateTime	Timestamp	Creation time.
UpdateTime	Timestamp	Last update time of the account.
PasswordUpdateTime	String	Specifies the last modified time of the account.

This field will only take effect after 2025-10-31. No matter whether the password is modified before, the value will be the default value: 0000-00-00 00:00:00 Indicates that this field is updated only when the password is modified via the cloud API or the console.
UserType	String	Account type. valid values: normal, tencentDBSuper. normal references a general user, tencentDBSuper possesses the pg_tencentdb_superuser user role.
OpenCam	Boolean	Specifies whether CAM verification is enabled for the user account.

AnalysisItems

Detailed analysis of a slow query statement with abstract parameter values, which is returned by the DescribeSlowQueryAnalysis API

Used by actions: DescribeSlowQueryAnalysis.

Name	Type	Description DatabaseName	String	The name of the database queried by the slow query statement UserName	String	The name of the user who executes the slow query statement NormalQuery	String	The slow query statement whose parameter values are abstracted ClientAddr	String	The address of the client that executes the slow query statement CallNum	Integer	The number of executions of the slow query statement during the specified period of time CallPercent	Float	Number of slow SQL statement executions within the specified time range as a percentage of all slow SQL.
CostTime	Float	The total execution time of the slow query statement during the specified period of time CostPercent	Float	The ratio (in decimal form) of the total execution time of the slow query statement to that of all slow query statements during the specified period of time MinCostTime	Float	The shortest execution time (in ms) of the slow query statement during the specified period of time MaxCostTime	Float	The longest execution time (in ms) of the slow query statement during the specified period of time AvgCostTime	Float	The average execution time (in ms) of the slow query statement during the specified period of time FirstTime	String	Start execution time of the first slow SQL within the specified time range.
LastTime	String	Start execution time of the last slow SQL within the specified time range.

AuditInstanceInfo

Audit instance info

Used by actions: DescribeAuditInstanceList.

Name	Type	Description InstanceId	String

Instance ID

AuditStatus	String

Enabled

Enumeration value:

OFF: Off ON: On

LogExpireDay	Integer

Log storage validity period

Unit: day

HotLogExpireDay	Integer

Hot storage period

Unit: day

ColdLogExpireDay	Integer

Cold storage period

Unit: day

HotLogSize	Float

Hot storage size

Unit: MB

ColdLogSize	Float

Cold storage size

Unit: MB

CreateTime	String

Start time

Deliver	String

Delivery status

DeliverSummary	Array of DeliverSummary

Shipping information

Note: This field may return null, indicating that no valid values can be obtained.
InstanceInfo	LogInstanceInfo

Instance information

AuditLog

Audit log details

Used by actions: DescribeAuditLogs.

Name	Type	Description Timestamp	String

Log time

Note: This field may return null, indicating that no valid values can be obtained.
AffectRows	Integer

Number of affected rows

Note: This field may return null, indicating that no valid values can be obtained.
DBName	String

Database

Note: This field may return null, indicating that no valid values can be obtained.
ErrCode	String

Error code

Note: This field may return null, indicating that no valid values can be obtained.
ErrorMessage	String

Error message

Note: This field may return null, indicating that no valid values can be obtained.
ExecTime	Integer

Execution time

Note: This field may return null, indicating that no valid values can be obtained.
Host	String

Origin

Note: This field may return null, indicating that no valid values can be obtained.
InstanceId	String

Instance Id

Note: This field may return null, indicating that no valid values can be obtained.
ObjectName	String

Object name

Note: This field may return null, indicating that no valid values can be obtained.
ObjectType	String

Object type

Note: This field may return null, indicating that no valid values can be obtained.
Sql	String

sql

Note: This field may return null, indicating that no valid values can be obtained.
SqlType	String

sql type

Note: This field may return null, indicating that no valid values can be obtained.
ThreadId	String

thread ID

Note: This field may return null, indicating that no valid values can be obtained.
User	String

User

Note: This field may return null, indicating that no valid values can be obtained.

AuditLogFile

Database Audit log file

Used by actions: DescribeAuditLogFiles.

Name	Type	Description FileName	String

File name

Status	String

Task status.

Enumeration values:

success: Success, running: Creating, failed: Failure.

FileSize	Integer

File size

Unit: MB

CreateTime	String

Creation time.

DownloadUrl	String

Download link

ErrMsg	String

Error message

Progress	Integer

Download progress

FinishTime	String

Completion time.

AuditLogFilter

Audit log filter criteria

Used by actions: CreateAuditLogFile, DescribeAuditLogs.

Name	Type	Required	Description AffectRows	Integer	No

Impact function

DBName	Array of String	No

Database name

ExecTime	Integer	No

Execution time

Host	Array of String	No

Host

Sql	String	No

sql statement

User	Array of String	No

Login name

SqlType	Array of String	No

Audit type

BackupDownloadRestriction

Restriction information for downloading a backup

Used by actions: DescribeBackupDownloadURL.

Name	Type	Required	Description RestrictionType	String	No	Backup file download limit type. valid values: NONE (unlimited, allows download from both private and public networks), INTRANET (only allows private network download), CUSTOMIZE (custom limits for download by vpc or ip). when the parameter value is CUSTOMIZE, at least one item must be filled in for vpc or ip information.
VpcRestrictionEffect	String	No	Whether VPC is allowed. Valid values: ALLOW (allow), DENY (deny).
VpcIdSet	Array of String	No	Whether it is allowed to download the VPC ID list of the backup files.
IpRestrictionEffect	String	No	Whether IP is allowed. Valid values: ALLOW (allow), DENY (deny).
IpSet	Array of String	No	Whether it is allowed to download IP list of the backup files.

BackupPlan

Backup plan

Used by actions: DescribeBackupPlans.

Name	Type	Description BackupPeriod	String	Backup cycle BaseBackupRetentionPeriod	Integer	Specifies the data backup retention duration in days.
MinBackupStartTime	String	The earliest time to start a backup MaxBackupStartTime	String	The latest time to start a backup PlanId	String	Backup plan ID.
PlanName	String	Specifies the custom name of the backup plan.
LogBackupRetentionPeriod	Integer	Specifies the log backup retention period in days.
CreatedTime	String	Creation time.
UpdatedTime	String	Last modification time.
PlanType	String	Backup plan type. valid values: default (created by system), custom.
BackupPeriodType	String	Backup cycle type. valid values: week, month.

BackupSummary

Instance backup statistics

Used by actions: DescribeBackupSummaries.

Name	Type	Description DBInstanceId	String	Instance ID LogBackupCount	Integer	Number of log backups of an instance LogBackupSize	Integer	Size of log backups of an instance ManualBaseBackupCount	Integer	Number of manually created instance data backups.
ManualBaseBackupSize	Integer	Size of manually created instance data backups.
AutoBaseBackupCount	Integer	Number of automatically created instance data backups.
AutoBaseBackupSize	Integer	Size of automatically created instance data backups.
TotalBackupCount	Integer	Total number of backups TotalBackupSize	Integer	Total backup size

BaseBackup

Database data backup information

Used by actions: DescribeBaseBackups.

Name	Type	Description DBInstanceId	String	Instance ID Id	String	Unique ID of a backup file Name	String	Backup file name.
BackupMethod	String	Specifies the backup method: physical - physical backup, logical - logical backup.
BackupMode	String	Backup mode: automatic - automatic backup, manual - manual backup.
State	String	Backup task status. valid values: init, running, finished, failed, canceled.
Size	Integer	Backup set size in bytes StartTime	String	Backup start time FinishTime	String	Backup end time ExpireTime	String	Backup expiration time

ClassInfo

Database instance specification

Used by actions: DescribeClasses.

Name	Type	Description SpecCode	String

Specification ID.

CPU	Integer

CPU cores.

Memory	Integer

Memory size, in MB.

MaxStorage	Integer

Maximum storage capacity supported by this specification, in GB.

MinStorage	Integer

Minimum storage capacity supported by this specification, in GB.

QPS	Integer

Estimated QPS of the specification.

DBBackup

Database backup information

Used by actions: DescribeDBBackups.

Name	Type	Description Id	Integer	Unique backup file ID StartTime	String	File generation start time EndTime	String	File generation end time Size	Integer	File size in KB Strategy	Integer	Policy (0: instance backup, 1: multi-database backup) Way	Integer	Type (0: scheduled) Type	Integer	Backup mode (1: full) Status	Integer	Status (1: creating, 2: success, 3: failure) DbList	Array of String	DB list InternalAddr	String	Download address on private network ExternalAddr	String	Download address on public network SetId	String	Backup set ID.

DBInstance

Instance details

Used by actions: DescribeDBInstanceAttribute, DescribeDBInstances, DescribeReadOnlyGroups.

Name	Type	Description Region	String

Region of the instance, for example: ap-guangzhou, corresponds to the region field in RegionSet.

Zone	String

Availability zone to which the instance belongs, for example: ap-guangzhou-3, corresponds to the Zone field in ZoneSet.

VpcId	String

VPC ID, such as vpc-e6w23k31. A valid VPC ID can be obtained by logging in to the console to query or by calling the API DescribeVpcs and acquiring the unVpcId field in API return.

SubnetId	String

VPC subnet ID, such as subnet-51lcif9y. An effective VPC subnet ID can be obtained by logging in to the console to query. You can also call API DescribeSubnets and get it from the unSubnetId field in API return.

DBInstanceId	String

Instance ID.

DBInstanceName	String

Instance name.

DBInstanceStatus	String

Instance status, including: applying (applying), init (to be initialized), initing (initializing), running (running), limited run (restricted operation), isolating (isolating), isolated (isolated), disisolating (de-isolating), recycling (recycling), recycled (recycled), job running (task executing), offline (offline), migrating (migrating), expanding (scaling out), waitSwitch (waiting to switch), switching (switching), readonly (readonly), restarting (restarting), network changing (network modification in progress), upgrading (kernel version upgrading), audit-switching (audit status changing), primary-switching (primary-secondary switching), offlining (offline), deployment changing (modify AZ), cloning (recovering data), parameter modifying (parameter modification in progress), log-switching (log status change), restoring (recovering), and expanding (scaling out)

DBInstanceMemory	Integer

Memory size allocated to the instance, measurement unit: GB

DBInstanceStorage	Integer

Storage space size allocated to the instance, measurement unit: GB

DBInstanceCpu	Integer

Number of CPUs allocated to the instance, unit: piece

DBInstanceClass	String

Purchasable specification ID.

DBMajorVersion	String

PostgreSQL major version number. Version information can be obtained from DescribeDBVersions. Currently supports major versions 10, 11, 12, 13, 14, and 15.

DBVersion	String

PostgreSQL community major version + minor version number, such as 12.4. Version information can be obtained from DescribeDBVersions.

DBKernelVersion	String

PostgreSQL Kernel Version, for example v12.7_r1.8. Version information can be obtained from DescribeDBVersions.

DBInstanceType	String

Instance types:

primary: Primary instance readonly: Read-only instance guard: Disaster recovery instance temp: Temporary instance

DBInstanceVersion	String

Instance version currently only supports standard (dual-server high-availability edition, one master and one slave).

DBCharset	String

Instance character set, which currently supports only:

UTF8 LATIN1

CreateTime	Timestamp

Instance creation time.

UpdateTime	Timestamp

The time when the instance executed the last update.

ExpireTime	Timestamp

Instance expiration time.

IsolatedTime	Timestamp

Instance isolation time.

PayType	String

Billing mode:

prepaid: Yearly/monthly subscription, prepayment postpaid: Pay-as-you-go, postpaid

AutoRenew	Integer

Auto-renewal or not:

0: Manual renewal 1: Auto renewal Default value: 0 DBInstanceNetInfo	Array of DBInstanceNetInfo

Instance network connection information.

Type	String

Machine type.

AppId	Integer

User's app id.

Uid	Integer

Uid of the instance.

ProjectId	Integer

Project ID.

TagList	Array of Tag

Tag information associated with the instance.

MasterDBInstanceId	String

Primary instance information. Returned only when the instance is a read-only instance.

ReadOnlyInstanceNum	Integer

Number of read-only instances.

StatusInReadonlyGroup	String

State of the read-only instance in the read-only group.

OfflineTime	String

Offline time.

DBNodeSet	Array of DBNode

Instance node information.

Note: This field may return null, indicating that no valid values can be obtained.
IsSupportTDE	Integer

Whether the instance supports TDE data encryption:

0: Not supported 1: Supported Default value: 0. For TDE data encryption, see Overview of Data Transparent Encryption.
DBEngine	String

Database engine, support:

postgresql: TencentDB for PostgreSQL mssql_compatible: MSSQL compatible - TencentDB for PostgreSQL Default value: postgresql DBEngineConfig	String

Configuration information for the database engine. The configuration format is as follows:
{"$key1":"$value1", "$key2":"$value2"} Supported engines:
mssql_compatible engine:

migrationMode: Database schema, optional parameter. Valid values: single-db (single-database mode), multi-db (multi-database mode). Default is single-db.
defaultLocale: Sorting area rule, optional parameter, cannot be modified after initialization. Default is en_US. Valid values include: "af_ZA", "sq_AL", "ar_DZ", "ar_BH", "ar_EG", "ar_IQ", "ar_JO", "ar_KW", "ar_LB", "ar_LY", "ar_MA", "ar_OM", "ar_QA", "ar_SA", "ar_SY", "ar_TN", "ar_AE", "ar_YE", "hy_AM", "az_Cyrl_AZ", "az_Latn_AZ", "eu_ES", "be_BY", "bg_BG", "ca_ES", "zh_HK", "zh_MO", "zh_CN", "zh_SG", "zh_TW", "hr_HR", "cs_CZ", "da_DK", "nl_BE", "nl_NL", "en_AU", "en_BZ", "en_CA", "en_IE", "en_JM", "en_NZ", "en_PH", "en_ZA", "en_TT", "en_GB", "en_US", "en_ZW", "et_EE", "fo_FO", "fa_IR", "fi_FI", "fr_BE", "fr_CA", "fr_FR", "fr_LU", "fr_MC", "fr_CH", "mk_MK", "ka_GE", "de_AT", "de_DE", "de_LI", "de_LU", "de_CH", "el_GR", "gu_IN", "he_IL", "hi_IN", "hu_HU", "is_IS", "id_ID", "it_IT", "it_CH", "ja_JP", "kn_IN", "kok_IN", "ko_KR", "ky_KG", "lv_LV", "lt_LT", "ms_BN", "ms_MY", "mr_IN", "mn_MN", "nb_NO", "nn_NO", "pl_PL", "pt_BR", "pt_PT", "pa_IN", "ro_RO", "ru_RU", "sa_IN", "sr_Cyrl_RS", "sr_Latn_RS", "sk_SK", "sl_SI", "es_AR", "es_BO", "es_CL", "es_CO", "es_CR", "es_DO", "es_EC", "es_SV", "es_GT", "es_HN", "es_MX", "es_NI", "es_PA", "es_PY","es_PE", "es_PR", "es_ES", "es_TRADITIONAL", "es_UY", "es_VE", "sw_KE", "sv_FI", "sv_SE", "tt_RU", "te_IN", "th_TH", "tr_TR", "uk_UA", "ur_IN", "ur_PK", "uz_Cyrl_UZ", "uz_Latn_UZ", "vi_VN".
serverCollationName: Collation name, optional parameter, cannot be modified after initialization. Default is sql_latin1_general_cp1_ci_as. Valid values include: "bbf_unicode_general_ci_as", "bbf_unicode_cp1_ci_as", "bbf_unicode_CP1250_ci_as", "bbf_unicode_CP1251_ci_as", "bbf_unicode_cp1253_ci_as", "bbf_unicode_cp1254_ci_as", "bbf_unicode_cp1255_ci_as", "bbf_unicode_cp1256_ci_as", "bbf_unicode_cp1257_ci_as", "bbf_unicode_cp1258_ci_as", "bbf_unicode_cp874_ci_as", "sql_latin1_general_cp1250_ci_as", "sql_latin1_general_cp1251_ci_as", "sql_latin1_general_cp1_ci_as", "sql_latin1_general_cp1253_ci_as", "sql_latin1_general_cp1254_ci_as", "sql_latin1_general_cp1255_ci_as","sql_latin1_general_cp1256_ci_as", "sql_latin1_general_cp1257_ci_as", "sql_latin1_general_cp1258_ci_as", "chinese_prc_ci_as", "cyrillic_general_ci_as", "finnish_swedish_ci_as", "french_ci_as", "japanese_ci_as", "korean_wansung_ci_as", "latin1_general_ci_as", "modern_spanish_ci_as", "polish_ci_as", "thai_ci_as", "traditional_spanish_ci_as", "turkish_ci_as", "ukrainian_ci_as", "vietnamese_ci_as".

NetworkAccessList	Array of NetworkAccess

Instance network information list (deprecated)

Note: This field may return null, indicating that no valid values can be obtained.
SupportIpv6	Integer

Whether the instance supports Ipv6:

0: No 1: Yes Default value: 0 ExpandedCpu	Integer

Number of cpu cores that have been elastically scaled out for the instance

DeletionProtection	Boolean

Whether to enable deletion protection for the instance, values as follows:

true: enable deletion protection false: disable deletion protection

DBInstanceStorageType	String

Instance storage type. Available values: PHYSICAL_LOCAL_SSD: LOCAL SSD hard disk of PHYSICAL machine; CLOUD_PREMIUM: high-performance CLOUD block storage; CLOUD_SSD: SSD CLOUD disk; CLOUD_HSSD: enhanced SSD CLOUD disk.

DBInstanceNetInfo

Instance network connection information

Used by actions: DescribeDBInstanceAttribute, DescribeDBInstances, DescribeReadOnlyGroups.

Name	Type	Description Address	String	DNS domain name Ip	String	Ip Port	Integer	Connection port address NetType	String	Network type. 1: inner (private network address), 2: public (public network address) Status	String	Network connection status. Valid values: initing (never enabled before), opened (enabled), closed (disabled), opening (enabling), closing (disabling) VpcId	String	VPC ID. specifies the ID of the virtual private cloud.
SubnetId	String	Subnet ID.
ProtocolType	String	Specifies the protocol type to connect to the database. currently supported: postgresql, mssql (mssql compatible syntax).

DBNode

Describes the instance node information, including the node type, availability zone where the node is located, and dedicated cluster where the node resides.

Used by actions: CloneDBInstance, CreateInstances, DescribeDBInstanceAttribute, DescribeDBInstances, ModifyDBInstanceDeployment.

Name	Type	Required	Description Role	String	Yes	Node type. Valid values:
Primary;
Standby.
Zone	String	Yes	AZ where the node resides, such as ap-guangzhou-1.
DedicatedClusterId	String	No	CDC ID.

Database

Describes the database detailed information, including owner and character encoding.

Used by actions: DescribeDatabases.

Name	Type	Description DatabaseName	String	Database name DatabaseOwner	String	Specifies the database owner.
Encoding	String	Specifies the database character encoding.
Collate	String	Specifies the database sorting rule.
Ctype	String	Specifies the character category of the database.
AllowConn	Boolean	Specifies whether the database allows connections.
ConnLimit	Integer	Maximum number of connections for the database. -1 indicates unlimited.
Privileges	String	Specifies the database permission list.

DatabaseObject

Describes the type of a certain object in the database, and the database, mode, and table of the object.

Used by actions: DescribeAccountPrivileges.

Name	Type	Required	Description ObjectType	String	Yes	Specifies the supported object types in the database: account, database, schema, sequence, procedure, type, function, table, view, matview, column.
ObjectName	String	Yes	Specifies the database object name.
DatabaseName	String	No	Describes the database object and the database name it belongs to. this parameter is required when the description object type is not database.
SchemaName	String	No	Specifies the schema name of the database object to describe. this parameter is required when the description object is not database or schema.
TableName	String	No	Specifies the database object to describe and the table name it belongs to. this parameter is required when the object type is column.

DatabasePrivilege

Specifies the permission list of the specified account for the database object.

Used by actions: DescribeAccountPrivileges, ModifyAccountPrivileges.

Name	Type	Required	Description Object	DatabaseObject	No	The database object. when ObjectType is database, DatabaseName/SchemaName/TableName can be empty. when ObjectType is schema, SchemaName/TableName can be empty. when ObjectType is column, TableName cannot be empty. other cases can be empty.
Note: This field may return null, indicating that no valid values can be obtained.
PrivilegeSet	Array of String	No	Specifies the permission list of the specified account for the database object.
Note: This field may return null, indicating that no valid values can be obtained.

DedicatedCluster

Exclusive cluster-related information, used for querying the user's exclusive cluster list.

Used by actions: DescribeDedicatedClusters.

Name	Type	Required	Description DedicatedClusterId	String	No	CDC ID.
Name	String	No	Dedicated cluster name.
Zone	String	No	Specifies the AZ of the exclusive cluster.
StandbyDedicatedClusterSet	Array of String	No	Disaster recovery cluster.
InstanceCount	Integer	No	Specifies the instance count.
CpuTotal	Integer	No	Total number of cpus.
CpuAvailable	Integer	No	Specifies the available amount of Cpu.
MemTotal	Integer	No	Total memory capacity in GB.
MemAvailable	Integer	No	Available memory in GB.
DiskTotal	Integer	No	Total disk capacity (unit: GB).
DiskAvailable	Integer	No	Disk availability (unit: GB).

DeliverSummary

Log shipping information.

Used by actions: DescribeAuditInstanceList.

Name	Type	Required	Description DeliverConsumer	String	No

Delivery consumers currently only support CLS

DeliverConsumerName	String	No

Consumer name submission, currently only support CLS

DeliverType	String	No

Currently only support mq for the delivery type

DeliverSubType	String	No

Delivery subtype, currently only support CLS

DeliverError	String	No

Delivery error

Detail

Details returned by the DescribeSlowQueryAnalysis API

Used by actions: DescribeSlowQueryAnalysis.

Name	Type	Description TotalTime	Float	The total execution time (in ms) of all slow query statements during the specified period of time TotalCallNum	Integer	The total number of all slow query statements during the specified period of time AnalysisItems	Array of AnalysisItems	List of slow SQL statistical analysis.

DurationAnalysis

Analyze the execution time of slow query statements by classifying them to different time ranges

Used by actions: DescribeSlowQueryList.

Name	Type	Description TimeSegment	String	Time range Count	Integer	The number of slow query statements whose execution time falls within the time range

EncryptionKey

KMS key information

Used by actions: DescribeEncryptionKeys.

Name	Type	Description KeyId	String	Specifies the KeyId for KMS instance encryption.
KeyAlias	String	Alias name of the KMS instance encryption Key.
DEKCipherTextBlob	String	Specifies the ciphertext of the instance encryption key DEK.
IsEnabled	Integer	Whether the key is enabled. valid values: 1 (enabled), 0 (disabled).
KeyRegion	String	Specifies the region of the KMS key.
CreateTime	String	Creation time of the DEK key.
KMSClusterId	String	Specifies the Id of the KMS service cluster where the key resides. being empty indicates the key is in the default KMS cluster. a non-empty value indicates the key is in the specified KMS service cluster.

ErrLogDetail

Error log details

Used by actions: DescribeDBErrlogs.

Name	Type	Description UserName	String

userName

Database	String

Database name

ErrTime	String

Error occurrence time

ErrMsg	String

Error message

ProcessId	Integer

Process ID

Note: This field may return null, indicating that no valid values can be obtained.
ClientAddr	String

client address

Note: This field may return null, indicating that no valid values can be obtained.
SessionId	String

Session ID

Note: This field may return null, indicating that no valid values can be obtained.
SessionStartTime	String

Session start time

Note: This field may return null, indicating that no valid values can be obtained.
VirtualTransactionId	String

Virtual transaction ID

Note: This field may return null, indicating that no valid values can be obtained.
SqlStateCode	String

SQLSTATE error code

Note: This field may return null, indicating that no valid values can be obtained.
ApplicationName	String

client application name

Note: This field may return null, indicating that no valid values can be obtained.

EventInfo

Parameter modification event information

Used by actions: DescribeParamsEvent.

Name	Type	Description ParamName	String	Parameter name.
OldValue	String	Original parameter value.
NewValue	String	This modification specifies the expected parameter value.
ModifyTime	String	Specifies the start time for backend parameter modification.
EffectiveTime	String	Specifies the start of effective time for the backend parameter.
State	String	Modification status. valid values: in progress, success, paused.
Operator	String	Operator (normal: user sub UIN).
EventLog	String	Time log.

EventItem

Modification details of one parameter

Used by actions: DescribeParamsEvent.

Name	Type	Description ParamName	String	Parameter name.
EventCount	Integer	Number of modified events.
EventDetail	Array of EventInfo	Last modification time.

Filter

Key-value pair filter for conditional filtering queries, such as filter ID and name

If more than one filter exists, the logical relationship between these filters is AND.
If multiple values exist in one filter, the logical relationship between these values is OR.

Used by actions: DescribeAuditInstanceList, DescribeBackupSummaries, DescribeBaseBackups, DescribeDBInstances, DescribeDatabases, DescribeDedicatedClusters, DescribeLogBackups, DescribeParameterTemplates, DescribeReadOnlyGroups.

Name	Type	Required	Description Name	String	No	Filter name.
Values	Array of String	No	One or more filter values.

LogBackup

Log backup information of a database

Used by actions: DescribeLogBackups.

Name	Type	Description DBInstanceId	String	Instance ID Id	String	Unique ID of a backup file Name	String	Backup file name BackupMethod	String	Specifies the backup method. valid values: physical - physical backup, logical - logical backup.
BackupMode	String	Backup mode. enumeration value, manual - manual backup; automatic - automatic backup.
State	String	Backup task status. valid values: init, running, finished, failed, canceled.
Size	Integer	Backup set size in bytes StartTime	String	Backup start time FinishTime	String	Backup end time ExpireTime	String	Backup expiration time

LogFilter

log filter criteria

Used by actions: DescribeDBErrlogs.

Name	Type	Required	Description Type	String	Yes

Filter criterion name.

For example: sql - SQL command details

host – client IP;
user – database account.

Compare	String	Yes

Filter condition match type. Supported values:
INC – Including (multiple values are in a

Value	Array of String	Yes

Matching value of the filter condition. When Compare=RG, for example: ["1-100","200-300"]

LogInstanceInfo

Log instance info

Used by actions: DescribeAuditInstanceList.

Name	Type	Description InstanceName	String

Instance name

Note: This field may return null, indicating that no valid values can be obtained.
ProjectId	Integer

Project ID

Note: This field may return null, indicating that no valid values can be obtained.
TagList	Array of Tag

Instance Tag

Note: This field may return null, indicating that no valid values can be obtained.
Engine	String

Engine

Note: This field may return null, indicating that no valid values can be obtained.
EngineVersion	String

Engine version

Note: This field may return null, indicating that no valid values can be obtained.
InstanceStatus	String

Instance status

Note: This field may return null, indicating that no valid values can be obtained.
IsSupportAudit	Integer

Whether audit is supported. 1 means support, 0 means not supported.

Note: This field may return null, indicating that no valid values can be obtained.
InstanceId	String

Instance ID

AuditType	String

Log type

Enumeration value:

complex: Granular audit simple: Fast Audit

ModifyPrivilege

Specifies the permissions for modifying a database object, including the data structure of the database object description, the list of permissions required for modification, and the modification type.

Used by actions: ModifyAccountPrivileges.

Name	Type	Required	Description DatabasePrivilege	DatabasePrivilege	No	Specifies the database object and permission list to be modified.
ModifyType	String	No	Modifies via grantObject, revokeObject, or alterRole. grantObject represents authorization, revokeObject represents withdraw, alterRole represents modify account type.
IsCascade	Boolean	No	This parameter is required only when ModifyType is revokeObject. when set to true, the permission will be revoked with cascading effect. default false.

NetworkAccess

Network information. (This parameter structure has been deprecated. Please use DBInstanceNetInfo to query network information.)

Used by actions: DescribeDBInstanceAttribute, DescribeDBInstances, DescribeReadOnlyGroups.

Name	Type	Description ResourceId	String	Network resource id, instance id, or RO group id.
ResourceType	Integer	Resource type. valid values: 1 (instance), 2 (RO group).
VpcId	String	VPC ID. specifies the ID of the virtual private cloud.
Vip	String	IPv4 Address Vip6	String	IPv6 Address Vport	Integer	Specifies the access port.
SubnetId	String	Subnet ID.
VpcStatus	Integer	Network status. valid values: 1-applying, 2-active, 3-deleting, 4-deleted.

ParamEntry

Parameters to be modified in batches

Used by actions: ModifyDBInstanceParameters, ModifyParameterTemplate.

Name	Type	Required	Description Name	String	Yes	Parameter name ExpectedValue	String	Yes	The new value to which the parameter will be modified. When this parameter is used as an input parameter, its value must be a string, such as 0.1 (decimal), 1000 (integer), and replica (enum).

ParamInfo

Parameter details

Used by actions: DescribeDBInstanceParameters, DescribeDefaultParameters, DescribeParameterTemplateAttributes.

Name	Type	Description ID	Integer	Parameter ID Name	String	Parameter name.
ParamValueType	String	Parameter value type: integer, real, bool, enum, mutil_enum.
When the parameter type is integer or real (floating-point), the value range is determined based on the Max and Min of the return value.
When the parameter type is boolean, the valid values are true or false.
When the parameter type is enum (enumeration type) or mutil_enum (multi-enum type), the valid values are determined by EnumValue in the return value.
Unit	String	Parameter value unit. returns null if the parameter has no units.
DefaultValue	String	Default parameter value. returns in string form.
CurrentValue	String	Specifies the current value in string form.
Max	Float	Specifies the numerical type (integer, real) parameter and its lower bound.
EnumValue	Array of String	Value range of the enum parameter Note: this field may return null, indicating that no valid values can be obtained.
Min	Float	Numerical type (integer, real) parameter specifies the upper bound.
ParamDescriptionCH	String	Chinese description.
ParamDescriptionEN	String	Specifies the english description of the parameter.
NeedReboot	Boolean	Specifies whether a restart is required for parameter modification (true indicates required, false indicates not required).
ClassificationCN	String	Parameter chinese category.
ClassificationEN	String	Parameter english category.
SpecRelated	Boolean	Specifies whether it is related to the specification (true for related, false for unrelated).
Advanced	Boolean	Indicates whether it is a key parameter (true means it is a key parameter, modification requires special attention and may affect instance performance).
LastModifyTime	String	Specifies the last modified time.
StandbyRelated	Integer	Parameter primary-secondary constraints. 0: no constraint between primary and standby. 1: standby parameter value > primary machine parameter value. 2: primary parameter value must be greater than that of the standby machine.
VersionRelationSet	Array of ParamVersionRelation	Parameter version association information, containing detailed parameter information for the respective kernel version Note: This field may return null, indicating that no valid values can be obtained.
SpecRelationSet	Array of ParamSpecRelation	Parameter specification association information, containing detailed parameter information for the respective specification Note: This field may return null, indicating that no valid values can be obtained.

ParamSpecRelation

Parameter information for each specification

Used by actions: DescribeDBInstanceParameters, DescribeDefaultParameters, DescribeParameterTemplateAttributes.

Name	Type	Description Name	String	Parameter name.
Memory	String	Parameter information belonging to specification.
Value	String	Default value of the parameter for this specification.
Unit	String	Parameter value unit. returns null if the parameter has no units.
Max	Float	Numerical type (integer, real) parameter specifies the upper bound.
Min	Float	Specifies the numerical type (integer, real) parameter and its lower bound.
EnumValue	Array of String	Value range of the enum parameter Note: This field may return null, indicating that no valid values can be obtained.

ParamVersionRelation

Parameter information for each version

Used by actions: DescribeDBInstanceParameters, DescribeDefaultParameters, DescribeParameterTemplateAttributes.

Name	Type	Description Name	String	Parameter name.
DBKernelVersion	String	Parameter information belonging to kernel version.
Value	String	Default value of the parameter for this version and specification.
Unit	String	Parameter value unit. returns null if the parameter has no units.
Max	Float	Numerical type (integer, real) parameter specifies the upper bound.
Min	Float	Specifies the numerical type (integer, real) parameter and its lower bound.
EnumValue	Array of String	Value range of the enum parameter Note: This field may return null, indicating that no valid values can be obtained.

ParameterTemplate

Basic information of a parameter template

Used by actions: DescribeParameterTemplates.

Name	Type	Description TemplateId	String	Parameter template ID TemplateName	String	Parameter template name DBMajorVersion	String	Database version applicable to a parameter template DBEngine	String	Database engine applicable to a parameter template TemplateDescription	String	Parameter template description

PgDeal

Order details

Used by actions: DescribeOrders.

Name	Type	Description DealName	String	Order name OwnerUin	String	User Count	Integer	Number of instances involved in order PayMode	Integer	Billing mode. 0: pay-as-you-go FlowId	Integer	Async task flow ID DBInstanceIdSet	Array of String	Instance ID array

PolicyRule

Rule information for security group

Used by actions: DescribeDBInstanceSecurityGroups.

Name	Type	Description Action	String	Policy, Valid values: ACCEPT, DROP.
CidrIp	String	Source or destination IP or IP range, such as 172.16.0.0/12.
PortRange	String	Port IpProtocol	String	Network protocol. UDP and TCP are supported.
Description	String	The rule description

RawSlowQuery

The list of slow query details returned by the DescribeSlowQueryList API

Used by actions: DescribeSlowQueryList.

Name	Type	Description RawQuery	String

Slow SQL statement

DatabaseName	String

Database for slow SQL queries

Duration	Float

Slow SQL execution duration

ClientAddr	String

Client that executes Slow SQL

UserName	String

userName that executes slow SQL

SessionStartTime	String

Start time of Slow SQL execution

ProcessId	Integer

Process ID of the slow SQL being executed

Note: This field may return null, indicating that no valid values can be obtained.
SessionId	String

Session ID that executes slow SQL.

Note: This field may return null, indicating that no valid values can be obtained.
VirtualTransactionId	String

Transaction ID of the executed slow SQL

Note: This field may return null, indicating that no valid values can be obtained.
SqlStateCode	String

Status code for executing slow SQL

Note: This field may return null, indicating that no valid values can be obtained.
ApplicationName	String

client name that executes slow SQL

Note: This field may return null, indicating that no valid values can be obtained.

ReadOnlyGroup

RO group information

Used by actions: DescribeReadOnlyGroups.

Name	Type	Description ReadOnlyGroupId	String	RO group identifier.
ReadOnlyGroupName	String	Specifies the read-only group name.
ProjectId	Integer	Project ID.
MasterDBInstanceId	String	Primary instance id.
MinDelayEliminateReserve	Integer	Specifies the minimum number of instances to retain.
MaxReplayLatency	Integer	Specifies the delay threshold for space size in MB.
ReplayLatencyEliminate	Integer	Specifies the delay size switch. valid values: 0 - turn off; 1 - turn on.
MaxReplayLag	Float	Delay time size threshold, in seconds.
ReplayLagEliminate	Integer	Delay time switch. 0 - turn off. 1 - turn on.
VpcId	String	VPC ID SubnetId	String	Subnet ID Region	String	Region ID Zone	String	Availability zone ID Status	String	Status. valid values: creating, ok, modifying, deleting, deleted.
ReadOnlyDBInstanceList	Array of DBInstance	Instance details Rebalance	Integer	Whether to enable automatic load balancing DBInstanceNetInfo	Array of DBInstanceNetInfo	Network information NetworkAccessList	Array of NetworkAccess	Network access list of the RO group (this field has been deprecated) Note: this field may return null, indicating that no valid values can be obtained.

RegionInfo

Region information such as number and status

Used by actions: DescribeRegions.

Name	Type	Description Region	String	Region abbreviation RegionName	String	Region name RegionId	Integer	Region number RegionState	String	Availability status. UNAVAILABLE: unavailable, AVAILABLE: available SupportInternational	Integer	Whether the international site is supported in this region. valid values: 0 (no support), 1 (support).

SecurityGroup

Security group information

Used by actions: DescribeDBInstanceSecurityGroups.

Name	Type	Description ProjectId	Integer	Project ID CreateTime	String	Creation time Inbound	Array of PolicyRule	Inbound rule Outbound	Array of PolicyRule	Outbound rule SecurityGroupId	String	Security group ID SecurityGroupName	String	Security group name SecurityGroupDescription	String	Security group remarks

SpecInfo

Purchasable specification details in an AZ in a region.

Used by actions: DescribeProductConfig.

Name	Type	Description Region	String	Region abbreviation, which corresponds to the Region field of RegionSet Zone	String	AZ abbreviate, which corresponds to the Zone field of ZoneSet SpecItemInfoList	Array of SpecItemInfo	Specification details list SupportKMSRegions	Array of String	Specifies the region that supports KMS.

SpecItemInfo

Specification description

Used by actions: DescribeProductConfig.

Name	Type	Description SpecCode	String

Specification ID.

Version	String

PostgreSQL version number.

VersionName	String

Full version name of the kernel number.

Cpu	Integer

CPU cores.

Memory	Integer

Memory size, in MB.

MaxStorage	Integer

Maximum storage capacity supported by this specification, in GB.

MinStorage	Integer

Minimum storage capacity supported by this specification, in GB.

Qps	Integer

Estimated QPS of the specification.

Pid	Integer

[Deprecated field].

Type	String

Machine type.

MajorVersion	String

PostgreSQL major version number.

KernelVersion	String

PostgreSQL kernel version number.

IsSupportTDE	Integer

Indicates whether the TDE data encryption feature is supported. 0 - not supported. 1 - supported.

Tag

The information of tags associated with instances, including TagKey and TagValue

Used by actions: CloneDBInstance, CreateInstances, CreateReadOnlyDBInstance, DescribeAuditInstanceList, DescribeDBInstanceAttribute, DescribeDBInstances.

Name	Type	Required	Description TagKey	String	Yes	Tag key TagValue	String	Yes	Tag value

TaskDetail

Task details.

Used by actions: DescribeTasks.

Name	Type	Required	Description CurrentStep	String	No	Current task step name.
AllSteps	String	No	Describes the step description of the current task you own.
Input	String	No	Input of the task.
Output	String	No	Output parameter of the task.
SwitchTag	Integer	No	Specifies the switch time after instance configurations are modified. default value: 0.
This task does not require switching.
Switch immediately.
2: switch at specified time.
3: switch during maintenance time window.
SwitchTime	String	No	Specifies the switch time.
Message	String	No	Note of the task.

TaskSet

Task list information

Used by actions: DescribeTasks.

Name	Type	Required	Description TaskId	Integer	No	Task ID.
TaskType	String	No	Specifies the task type.
DBInstanceId	String	No	Specifies the instance ID of the task instance.
StartTime	String	No	Start time of the task.
EndTime	String	No	Task end time.
Status	String	No	Specifies the task Running status, including Running, Success, WaitSwitch, Fail, Pause.
Progress	Integer	No	Indicates the progress of task execution, with a value range of 0-100.
TaskDetail	TaskDetail	No	Specifies the task details.

Version

Database version information

Used by actions: DescribeDBVersions.

Name	Type	Description DBEngine	String	Database engines. Valid values:
1. postgresql (TencentDB for PostgreSQL)
2. mssql_compatible (MSSQL compatible-TencentDB for PostgreSQL)
DBVersion	String	Database version, such as 12.4.
DBMajorVersion	String	Database major version, such as 12.
DBKernelVersion	String	Database kernel version, such as v12.4_r1.3.
SupportedFeatureNames	Array of String	List of features supported by the database kernel, such as:
TDE: Supports data encryption.
Status	String	Database version status, including:.
AVAILABLE: available.
UPGRADE_ONLY: specifies that creation is not allowed. this version is only available for upgrade to a higher version.
DEPRECATED.
AvailableUpgradeTarget	Array of String	List of versions to which this database version (DBKernelVersion) can be upgraded, including minor and major version numbers available for upgrade (complete kernel version format example: v15.1_v1.6).

Xlog

Database Xlog information

Used by actions: DescribeDBXlogs.

Name	Type	Description Id	Integer	Unique backup file ID StartTime	Timestamp	File generation start time EndTime	Timestamp	File generation end time InternalAddr	String	Download address on private network ExternalAddr	String	Download address on public network Size	Integer	Backup file size

ZoneInfo

AZ information such as number and status

Used by actions: DescribeZones.

Name	Type	Description Zone	String	AZ abbreviation ZoneName	String	AZ name ZoneId	Integer	AZ number ZoneState	String	Availability status. Valid values:
UNAVAILABLE.
AVAILABLE.
SELLOUT.
SUPPORTMODIFYONLY (supports configuration adjustment).
ZoneSupportIpv6	Integer	Whether the AZ supports IPv6 address access StandbyZoneSet	Array of String	AZs that can be used as standby when this AZ is primary Note: this field may return null, indicating that no valid values can be obtained.
Previous Topic: DeleteReadOnlyGroupNetworkAccess Next Topic: Error Codes Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page AccountInfo AnalysisItems AuditInstanceInfo AuditLog AuditLogFile AuditLogFilter BackupDownloadRestriction BackupPlan BackupSummary BaseBackup ClassInfo DBBackup DBInstance DBInstanceNetInfo DBNode Database DatabaseObject DatabasePrivilege DedicatedCluster DeliverSummary Detail DurationAnalysis EncryptionKey ErrLogDetail EventInfo EventItem Filter LogBackup LogFilter LogInstanceInfo ModifyPrivilege NetworkAccess ParamEntry ParamInfo ParamSpecRelation ParamVersionRelation ParameterTemplate PgDeal PolicyRule RawSlowQuery ReadOnlyGroup RegionInfo SecurityGroup SpecInfo SpecItemInfo Tag TaskDetail TaskSet Version Xlog ZoneInfo Search AllCurrent Product Search titles only Enter keywords to search documentation
