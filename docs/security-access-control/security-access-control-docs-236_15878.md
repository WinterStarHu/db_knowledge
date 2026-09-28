# Data Types

> 来源: https://www.tencentcloud.com/document/product/236/15878

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL ​​API Reference Data Types Data Types Download Focus Mode Font Size Last updated: 2026-08-06 16:09:10 Account

TencentDB account information

Used by actions: CreateAccounts, CreateRotationPassword, DeleteAccounts, ModifyAccountDescription, ModifyAccountMaxUserConnections, ModifyAccountPassword, ModifyAccountPrivileges.

Name	Type	Required	Description User	String	Yes	Account name, enter 1-32 characters.
Host	String	Yes	Account's host.
Note:
1. IP format. You can specify a percent sign (%).
2. Multiple hosts are separated by a separator, which supports ;, |, line break, and space.
AccountInfo

Account details

Used by actions: DescribeAccounts.

Name	Type	Description Notes	String	Account remarks Host	String	Account domain name User	String	Account name ModifyTime	Timestamp	Account information modification time ModifyPasswordTime	Timestamp	Password modification time MaxUserConnections	Integer	The maximum number of instance connections supported by an account OpenCam	Boolean	Is password rotation enabled for the user account?
AddressInfo

Instance address information.

Used by actions: DescribeClusterInfo.

Name	Type	Description ResourceId	String	Resource ID identifier of the address.
UniqVpcId	String	The vpc where the address resides.
UniqSubnetId	String	The subnet where the address resides.
Vip	String	vip address.
VPort	Integer	The port of the address.
WanDomain	String	Public network address domain name.
WanPort	Integer	Public network address port.
AggregationCondition

Aggregation condition for an audit log

Used by actions: AnalyzeAuditLogs.

Name	Type	Required	Description AggregationField	String	Yes	Aggregation field. Valid values: host (source IP), user （username), dbName (database name), sqlType (SQL type).
Offset	Integer	No	Offset Limit	Integer	No	Number of buckets returned under this field. Maximum value: 100.
AnalysisNodeInfo

Analysis engine node information.

Used by actions: DescribeDBInstances.

Name	Type	Description NodeId	String	Node ID.
Status	String	Node status.
DataStatus	String	Data loading status.
Cpu	Integer	Number of CPU cores, in cores.
Memory	Integer	Memory size, in MB.
Storage	Integer	Disk size, in GB.
Zone	String	Node AZ.
Message	String	Data synchronization error message.
AuditFilter

Audit rule filters

Used by actions: DescribeAuditRules.

Name	Type	Required	Description Type	String	Yes	Filter parameter names. Valid values:
SrcIp: Client IP;
User: Database account;
DB: Database name.
Compare	String	Yes	Filter match type. Valid value:
INC: Include;
EXC: Exclude;
EQ: Equal to;
NEQ: Not equal to.
Value	String	Yes	Filter match value AuditInstanceFilters

Filter conditions for querying audit instances.

Used by actions: DescribeAuditInstanceList.

Name	Type	Required	Description Name	String	Yes	Filter condition name. Valid values: InstanceId - Instance ID, InstanceName - Instance name, ProjectId - Project ID, TagKey - Tag key, Tag - Tag (using a vertical bar as separator, for example: TagKey|Tagvalue).
ExactMatch	Boolean	Yes	true indicates exact matching; false indicates fuzzy matching.
Values	Array of String	Yes	Filter value.
AuditInstanceInfo

Audit instance details.

Used by actions: DescribeAuditInstanceList.

Name	Type	Description ProjectId	Integer	Project ID.
TagList	Array of TagInfoUnit	Tag information.
DbType	String	Database kernel type.
DbVersion	String	Database kernel version.
AuditLog

Audit log details

Used by actions: DescribeAuditLogs.

Name	Type	Description AffectRows	Integer	Number of affected rows ErrCode	Integer	The error code SqlType	String PolicyName	String	Audit policy name, which will be unavailable soon.
DBName	String Sql	String Host	String	Client address User	String	Username ExecTime	Integer	Execution time (μs) Timestamp	String	Time SentRows	Integer	Number of returned rows ThreadId	Integer	Thread ID CheckRows	Integer	Number of scanned rows.
CpuTime	Float	cpu execution time, µs.
IoWaitTime	Integer	IO wait time, µs.
LockWaitTime	Integer	Lock waiting time (unit: microsecond).
NsTime	Integer	Start time, which combines with timestamp to form a time accurate to nanoseconds.
TrxLivingTime	Integer	Transaction duration, µs.
TemplateInfo	Array of LogRuleTemplateInfo	Basic info of the log hit rule template TrxId	Integer	Transaction ID ClientPort	Integer	Port.
Note: This field may return null, indicating that no valid values can be obtained.
AuditLogAggregationResult

Analysis result of an audit log

Used by actions: AnalyzeAuditLogs.

Name	Type	Description AggregationField	String	Aggregation dimension Buckets	Array of Bucket	Aggregate bucket result set AuditLogFile

Audit log file.

Used by actions: DescribeAuditLogFiles.

Name	Type	Description FileName	String	Audit log file name.
CreateTime	String	Creation time of the audit log file, in the format: "2019-03-20 17:09:13".
Status	String	File status. Possible return values:"creating" - Generating;"failed" - Creation failed;"success" - Generated.
FileSize	Integer	File size in KB.
DownloadUrl	String	Download URL for the audit log.
ErrMsg	String	Error message.
AuditPolicy

Audit Policy

Used by actions: DescribeAuditPolicies.

Name	Type	Description PolicyId	String	Audit policy ID.
Status	String	Audit policy status. Valid values:
creating;
running, paused;
failed.
InstanceId	String	Database instance ID CreateTime	String	Creation time of audit policy in the format of 2019-03-20 17:09:13 ModifyTime	String	Last modified time of audit policy in the format of 2019-03-20 17:09:13 PolicyName	String	Audit policy name RuleId	String	Audit rule ID RuleName	String	Audit rule name.
InstanceName	String	Database instance name AuditRule

Audit rule

Used by actions: DescribeAuditRules.

Name	Type	Description RuleId	String	Audit rule ID CreateTime	String	Creation time of audit rule in the format of 2019-03-20 17:09:13 ModifyTime	String	Last modified time of audit rule in the format of 2019-03-20 17:09:13 RuleName	String	Audit rule name Note: This field may return null, indicating that no valid value was found.
Description	String	Audit rule description Note: This field may return null, indicating that no valid value was found.
RuleFilters	Array of AuditFilter	Audit rule filters Note: This field may return null, indicating that no valid value was found.
AuditAll	Boolean	Whether to enable full audit AuditRuleTemplateInfo

Details of an audit rule template.

Used by actions: DescribeAuditRuleTemplates.

Name	Type	Description RuleTemplateId	String	Rule template ID.
RuleTemplateName	String	Rule template name.
RuleFilters	Array of RuleFilters	Filter conditions of the rule template.
Description	String	Rule template description.
CreateAt	String	Rule template creation time.
AlarmLevel	Integer	Alarm level. Valid values: 1 - Low risk, 2 - Medium risk, 3 - High risk.
AlarmPolicy	Integer	Alarm policy. Valid values: 0 - Alarm disabled, 1 - Alarm enabled.
AffectedInstances	Array of String	Instances to which this rule template is applied.
Status	Integer	Template status. Valid values: 0 - No task, 1 - modifying.
UpdateAt	String	Template update time.
AutoStrategy

CPU Elastic Scaling auto scale-out policy.

Used by actions: DescribeCPUExpandStrategyInfo, StartCpuExpand.

Name	Type	Required	Description ExpandThreshold	Integer	Yes	Auto scaling threshold. Available values: 40, 50, 60, 70, 80, 90. Represents the CPU utilization reaches 40%, 50%, 60%, 70%, 80%, or 90% to trigger auto scaling in the background.
ShrinkThreshold	Integer	Yes	CPU utilization threshold (percent value). Valid values: 10, 20, and 30. Automatic scale-in will be triggered when CPU utilization reaches the set threshold.
ExpandSecondPeriod	Integer	No	Elastic scaling observation period (in seconds). Value is 15, 30, 45, 60, 180, 300, 600, 900, or 1800.
ShrinkSecondPeriod	Integer	No	Scale-down observation period (in seconds). Valid values: 300, 600, 900, 1800.
BackupConfig

Configuration information of ECDB secondary database 2. This field is only applicable to ECDB instances

Used by actions: DescribeDBInstanceConfig.

Name	Type	Description ReplicationMode	String	Replication mode of secondary database 2. Value range: async, semi-sync Zone	String	The canonical name of the second secondary availability zone, for example ap-shanghai-2 Vip	String	Private IP address of secondary database 2 Vport	Integer	Access port of secondary database 2 BackupInfo

Backup details

Used by actions: DescribeBackups.

Name	Type	Description Name	String

Backup file name

Size	Integer

Backup file size, unit: Byte

Date	String

Backup snapshot time. Time format: 2016-03-17 02:10:37

IntranetUrl	String

Download link

InternetUrl	String

Download link

Type	String

Specific type of logs. Possible values: "logical": logical cold backup, "physical": physical cold backup.

BackupId	Integer

ID of the backup subtask, used when deleting backup files

Status	String

Backup task status. Possible values: "SUCCESS": backup successful, "FAILED": backup FAILED, "RUNNING": backup in progress.

FinishTime	String

Backup task completion time

Creator	String

(This value will be deprecated and is not recommended for use) Creator of the backup. Valid values: SYSTEM - generated by the system, Uin - Uin value of the initiator.

StartTime	String

Start time of the backup task

Method	String

Backup method. Possible values are "full": full backup, "partial": partial backup.

Way	String

Backup method. Possible values are "manual": manual backup, "automatic": automatic backup.

ManualBackupName	String

Manual backup alias

SaveMode	String

Backup retention type, save_mode_regular - Regular backup saving, save_mode_period - Periodic backup

Region	String

Local backup region

RemoteInfo	Array of RemoteBackupInfo

Detailed information of offsite backup

CosStorageType	Integer

Storage method: 0 - regular storage, 1 - archive storage, 2 - standard storage, defaults to 0.

InstanceId	String

Instance ID, in the format such as cdb-c1nl9rpv. This matches the instance ID displayed on the TencentDB console.

Progress	Integer

Backup completion progress

EncryptionFlag	String

Whether the backup file is encrypted, on-encrypted, off-unencrypted

ExecutedGTIDSet	String

Backup GTID position

MD5	String

MD5 value of the backup file

BackupItem

When creating a backup, you need to specify the information of the table to be backed up.

Used by actions: CreateBackup.

Name	Type	Required	Description Db	String	Yes	Name of the database to be backed up Table	String	No	Name of the table to be backed up. If this parameter is passed in, the specified table in the database will be backed up; otherwise, the database will be backed up.
BackupLimitVpcItem

VPCs used to restrict backup download

Used by actions: DescribeBackupDownloadRestriction, ModifyBackupDownloadRestriction.

Name	Type	Required	Description Region	String	Yes	The region where the backup download restrictions take effect. It must be the same as the common request parameter Region of the API.
VpcList	Array of String	Yes	The list of VPCs used to restrict backup download BackupSummaryItem

Statistical items of instance backup

Used by actions: DescribeBackupSummaries.

Name	Type	Description InstanceId	String	Instance ID.
AutoBackupCount	Integer	Number of automatic data backups of an instance.
AutoBackupVolume	Integer	Capacity of automatic data backups of an instance.
ManualBackupCount	Integer	Number of manual data backups of an instance.
ManualBackupVolume	Integer	Capacity of manual data backups of an instance.
DataBackupCount	Integer	Total number of data backups of an instance (including automatic backups and manual backups).
DataBackupVolume	Integer	Total capacity of data backups of an instance.
BinlogBackupCount	Integer	Number of log backups of an instance.
BinlogBackupVolume	Integer	Capacity of log backups of an instance.
BackupVolume	Integer	Total capacity of backups of an instance (including data backups and log backups).
BinlogInfo

Binlog information

Used by actions: DescribeBinlogs.

Name	Type	Description Name	String

binlog backup file name

Size	Integer

Backup file size, unit: Byte

Date	Timestamp

File storage time. Time format: 2016-03-17 02:10:37

IntranetUrl	String

Download link Description: This download link is the same as the download address of the parameter InternetUrl.

InternetUrl	String

Download address Description: This download address is the same as the IntranetUrl download address.

Type	String

Log specific type. Possible values: binlog - binary log

BinlogStartTime	String

binlog file start time

BinlogFinishTime	String

binlog file expiration time

Region	String

Region where local binlog files are located

Status	String

Backup task status. Possible values: "SUCCESS": backup successful, "FAILED": backup FAILED, "RUNNING": backup in progress.

RemoteInfo	Array of RemoteBackupInfo

Detailed information of binlog offsite backup

CosStorageType	Integer

Storage method: 0 - regular storage, 1 - archive storage, 2 - standard storage, defaults to 0.

Progress	Integer

Backup completion progress

Bucket

Information of an aggregation bucket

Used by actions: AnalyzeAuditLogs.

Name	Type	Description Key	String	None Count	Integer	Number of occurrences of the key value CdbRegionSellConf

The purchasable configuration in a region

Used by actions: DescribeCdbZoneConfig.

Name	Type	Description RegionName	String	Region name Area	String	Area IsDefaultRegion	Integer	Whether it is a default region Region	String	Region name RegionConfig	Array of CdbZoneSellConf	The purchasable configuration in an AZ in a region CdbSellConfig

The details of purchasable configuration

Used by actions: DescribeCdbZoneConfig.

Name	Type	Description Memory	Integer	Memory size in MB Cpu	Integer	CPU core count VolumeMin	Integer	Minimum disk size in GB VolumeMax	Integer	Maximum disk size in GB VolumeStep	Integer	Disk capacity increment in GB Iops	Integer	IO operations per second Info	String	Application scenario description Status	Integer	Status. The value 0 indicates that this specification is available.
DeviceType	String	Instance type, possible value ranges from UNIVERSAL (universal type), EXCLUSIVE (exclusive), BASIC (basic), to BASIC_V2 (basic v2).
EngineType	String	Engine type description. Valid values: Innodb, RocksDB.
Id	Integer	Purchasable specifications ID CdbSellType

Purchasable instance type

Used by actions: DescribeCdbZoneConfig.

Name	Type	Description TypeName	String	Purchasable instance name.
Z3: High-availability, corresponds to the specified specification DeviceType, including UNIVERSAL and EXCLUSIVE.
CVM: It is a basic edition type, and the DeviceType in the corresponding specifications is BASIC (Offline).
TKE: It is the basic version v2 type, and the DeviceType in the corresponding specifications is BASIC_V2.
CLOUD_NATIVE_CLUSTER: Represents the standard type of cloud disk edition.
CLOUD_NATIVE_CLUSTER_EXCLUSIVE: Indicates the enhanced cloud disk edition.
ECONOMICAL: Means economical.
EngineVersion	Array of String	Engine version number ConfigIds	Array of Integer	Purchasable specifications ID CdbZoneDataResult

The purchasable specifications in a region

Used by actions: DescribeCdbZoneConfig.

Name	Type	Description Configs	Array of CdbSellConfig	List of purchasable specifications Regions	Array of CdbRegionSellConf	List of AZs in purchasable regions CdbZoneSellConf

Purchasable specifications in an AZ

Used by actions: DescribeCdbZoneConfig.

Name	Type	Description Status	Integer	AZ status, which is used to indicate whether instances are purchasable. Valid values: 1 (purchasable), 3 (not purchasable), 4 (AZ not displayed) ZoneName	String	AZ name IsCustom	Boolean	Whether it is a custom instance type IsSupportDr	Boolean	Whether disaster recovery is supported IsSupportVpc	Boolean	Whether VPC is supported HourInstanceSaleMaxNum	Integer	Maximum purchasable quantity of hourly billed instances IsDefaultZone	Boolean	Whether it is a default AZ IsBm	Boolean	Whether it is a BM zone PayType	Array of String	Supported billing method. Valid values: 0 (yearly/monthly subscribed), 1 (hourly billed), 2 (pay-as-you-go) ProtectMode	Array of String	Data replication type. Valid values: 0 (async), 1 (semi-sync), 2 (strong sync) Zone	String	AZ name ZoneConf	ZoneConf	Multi-AZ information DrZone	Array of String	Information of supported disaster recovery AZs IsSupportRemoteRo	Boolean	Whether cross-AZ read-only access is supported RemoteRoZone	Array of String	Information of supported cross-AZ read-only zone ExClusterStatus	Integer	AZ status, which is used to indicate whether dedicated instances are purchasable. Valid values: 1 (purchasable),3(not purchasable),4` (AZ not displayed) ExClusterRemoteRoZone	Array of String	Information of cross-AZ read-only zones supported by a dedicated instance ExClusterZoneConf	ZoneConf	AZ information of a multi-AZ deployed dedicated instance.
SellType	Array of CdbSellType	Array of purchasable instance types. The value of configIds and configs have a one-to-one correspondence.
ZoneId	Integer	AZ ID IsSupportIpv6	Boolean	Whether IPv6 is supported EngineType	Array of String	Supported engine types for purchasable database CloudNativeClusterStatus	Integer	Sales status of the cloud disk edition instance in the current availability zone. Possible returned values: 1-launched; 3-not available for sale; 4-not displayed.
DiskTypeConf	Array of DiskTypeConfigItem	Cloud disk edition or single-node basic edition supported disk type.
CloneItem

Clone task information.

Used by actions: DescribeCloneList.

Name	Type	Description SrcInstanceId	String	ID of the original instance in a clone task DstInstanceId	String	ID of the cloned instance in a clone task CloneJobId	Integer	Clone task ID RollbackStrategy	String	The policy used in a clone task. Valid values: timepoint (roll back to a specific point in time), backupset (roll back by using a specific backup file).
RollbackTargetTime	String	The point in time to which the cloned instance will be rolled back StartTime	String	Task start time EndTime	String	Task end time TaskStatus	String	Task status. Valid values: initial, running, wait_complete, success, failed.
NewRegionId	Integer	Clone instance region ID SrcRegionId	Integer	Source instance region ID ClusterInfo

Cluster Edition node information.

Used by actions: DescribeDBInstances.

Name	Type	Required	Description NodeId	String	No	Node ID.
Role	String	No	Node type: primary node and secondary node.
Zone	String	No	Region.
ClusterNodeInfo

Cluster Edition instance node information.

Used by actions: DescribeClusterInfo.

Name	Type	Required	Description NodeId	String	No	node id.
Role	String	No	Node role.
Zone	String	No	Node AZ.
Weight	Integer	No	Weight of the node Status	String	No	Node status.
ClusterTopology

Topology configuration of nodes for cloud disk edition.

Used by actions: CreateCloneInstance, CreateDBInstance, CreateDBInstanceHour, DescribeInstanceUpgradeType, UpgradeDBInstance.

Name	Type	Required	Description ReadWriteNode	ReadWriteNode	No	RW node topology.
Description: NodeId can be obtained through DescribeDBInstances.
ReadOnlyNodes	Array of ReadonlyNode	No	RO node topology.
Description: NodeId can be obtained through DescribeDBInstances.
ColumnPrivilege

Column permission information

Used by actions: DescribeAccountPrivileges, ModifyAccountPrivileges.

Name	Type	Required	Description Database	String	Yes	Database name Table	String	Yes	Table name Column	String	Yes	Column name Privileges	Array of String	Yes	Permission information CommonTimeWindow

Common time window

Used by actions: DescribeBackupConfig, ModifyBackupConfig.

Name	Type	Required	Description Monday	String	No	Time window on Monday in the format of 02:00-06:00 Tuesday	String	No	Time window on Tuesday in the format of 02:00-06:00 Wednesday	String	No	Time window on Wednesday in the format of 02:00-06:00 Thursday	String	No	Time window on Thursday in the format of 02:00-06:00 Friday	String	No	Time window on Friday in the format of 02:00-06:00 Saturday	String	No	Time window on Saturday in the format of 02:00-06:00 Sunday	String	No	Time window on Sunday in the format of 02:00-06:00 BackupPeriodStrategy	String	No	Non-archive backup retention policy. Valid values: weekly (back up by week), monthly (back up by month), default value: weekly.
Days	Array of Integer	No	If BackupPeriodStrategy is monthly, you need to pass in the specific backup dates. The time interval between any two adjacent dates cannot exceed 2 days, for example, [1,4,7,9,11,14,17,19,22,25,28,30,31].
BackupPeriodTime	String	No	Backup time by month in the format of 02:00–06:00, which is required when BackupPeriodStrategy is monthly.
CustomConfig

Proxy configuration

Used by actions: DescribeProxyCustomConf.

Name	Type	Description Device	String	device Type	String	Type.
DeviceType	String	Device type Memory	Integer	Memory, measured in MB Cpu	Integer	Number of cores DBSwitchInfo

TencentDB instance switch records

Used by actions: DescribeDBSwitchRecords.

Name	Type	Description SwitchTime	Timestamp	Switch time in the format of yyyy-MM-dd HH:mm:ss, such as 2017-09-03 01:34:31 SwitchType	String	Switch type. Value range: TRANSFER (data migration), MASTER2SLAVE (primary/secondary switch), RECOVERY (primary/secondary recovery) DatabasePrivilege

Database permission

Used by actions: DescribeAccountPrivileges, ModifyAccountPrivileges.

Name	Type	Required	Description Privileges	Array of String	Yes	Permission information Database	String	Yes	Database name DatabasesWithCharacterLists

Database name and character set

Used by actions: DescribeDatabases.

Name	Type	Description DatabaseName	String	Database name CharacterSet	String	Character set DeviceCpuInfo

CPU load

Used by actions: DescribeDeviceMonitorInfo.

Name	Type	Description Rate	Array of DeviceCpuRateInfo	Average instance CPU utilization Load	Array of Integer	CPU monitoring data of the instance DeviceCpuRateInfo

Average instance CPU utilization

Used by actions: DescribeDeviceMonitorInfo.

Name	Type	Description CpuCore	Integer	CPU core number Rate	Array of Integer	CPU utilization DeviceDiskInfo

Disk monitoring data of the instance

Used by actions: DescribeDeviceMonitorInfo.

Name	Type	Description IoRatioPerSec	Array of Integer	Time percentage of IO operations per second IoWaitTime	Array of Integer	Average wait time of device I/O operations * 100 in milliseconds. For example, if the value is 201, the average wait time of I/O operations is 201/100 = 2.1 milliseconds.
Read	Array of Integer	Average number of read operations completed by the disk per second * 100. For example, if the value is 2,002, the average number of read operations completed by the disk per second is 2,002/100=20.2.
Write	Array of Integer	Average number of write operations completed by the disk per second * 100. For example, if the value is 30,001, the average number of write operations completed by the disk per second is 30,001/100=300.01.
CapacityRatio	Array of Integer	Disk capacity. Each value is comprised of two data, with the first data representing the used capacity and the second one representing the total disk capacity.
DeviceMemInfo

Memory monitoring information of the physical server where the instance is located

Used by actions: DescribeDeviceMonitorInfo.

Name	Type	Description Total	Array of Integer	Total memory size in KB, which is the value of total in the Mem: in the free command Used	Array of Integer	Used memory size in KB, which is the value of used in the Mem: row in the free command DeviceNetInfo

Network monitoring information of the physical server where the instance is located

Used by actions: DescribeDeviceMonitorInfo.

Name	Type	Description Conn	Array of Integer	Number of TCP connections PackageIn	Array of Integer	ENI inbound packets per second PackageOut	Array of Integer	ENI outbound packets per second FlowIn	Array of Integer	Inbound traffic in Kbps FlowOut	Array of Integer	Outbound traffic in Kbps DiskTypeConfigItem

Disk sale type

Used by actions: DescribeCdbZoneConfig.

Name	Type	Required	Description DeviceType	String	No	Type of instance corresponding to the disk. Only support single node (cloud disk) and cloud disk edition.
DiskType	Array of String	No	List of disk types to choose.
DrInfo

Disaster recovery instance information

Used by actions: DescribeDBInstances.

Name	Type	Description Status	Integer	Disaster recovery instance status Zone	String	AZ information InstanceId	String	Instance ID Region	String	Region information SyncStatus	Integer	Instance sync status. Possible returned values include:
0 - disaster recovery not synced;
1 - disaster recovery syncing;
2 - disaster recovery synced successfully;
3 - disaster recovery sync failed;
4 - repairing disaster recovery sync;
InstanceName	String	Instance name InstanceType	Integer	Instance type ErrlogItem

Structured error log details

Used by actions: DescribeErrorLogData.

Name	Type	Description Timestamp	Integer	Error occurrence time. Timestamp in seconds.
Content	String	Error details ImportRecord

Import task records

Used by actions: DescribeDBImportRecords.

Name	Type	Description Status	Integer	Status value. 0 - Initializing, 1 - Running, 2 - Operation successful, 3 - Operation failure.
Code	Integer	Status value. Task exception when the value is negative.
CostTime	Integer	Execution time, unit: seconds.
InstanceId	String	Instance ID WorkId	String	Backend task ID FileName	String	Name of the file to be imported Process	Integer	Execution progress, measurement unit: percentage.
CreateTime	Timestamp	Task creation time FileSize	String	File size, unit: byte.
Message	String	Task execution information JobId	Integer	Task ID DbName	String	Name of the table to be imported AsyncRequestId	String	Async task request ID Inbound

Security group inbound rule

Used by actions: DescribeDBSecurityGroups, DescribeProjectSecurityGroups.

Name	Type	Description Action	String	Policy, which can be ACCEPT or DROP CidrIp	String	Source IP or IP range, such as 192.168.0.0/16 PortRange	String	Port IpProtocol	String	Network protocol. UDP and TCP are supported.
Dir	String	The direction of the rule, which is INPUT for inbound rules AddressModule	String	Address module Id	String	Rule ID, rule ID of the nested security group Desc	String	Rule description InstEventInfo

Instance event information.

Used by actions: DescribeInstanceAlarmEvents.

Name	Type	Description EventName	String	Event name.
EventStatus	String	Event status.
OccurTime	String	Event occurrence time.
InstanceId	String	Instance ID.
NodeId	String	Node ID.
InstanceAuditLogFilters

Search filter for audit log

Used by actions: AnalyzeAuditLogs, CreateAuditLogFile, DescribeAuditLogs.

Name	Type	Required	Description Type	String	No	Filter condition. The search conditions are supported as follows:

Include/Exclude, and Include/Exclude (segment dimension) can be used to search for:
sql - SQL details.

Equal to, Not equal to, Include, and Exclude can be used to search for:
host - Client IP, user - Username, DBName - Database name.

Equal to and Not equal to can be used to search for:
sqlType - SQL type, errCode - Error code, threadId - Thread ID.

Range search is supported for:
execTime- Execution time (μs), lockWaitTime - Lock wait time (μs), ioWaitTime - IO wait time (μs), trxLivingTime - Transaction duration (μs), cpuTime - CPU time (μs), checkRows - Number of scanned rows, affectRows - Number of affected rows, sentRows - Number of returned rows.
Compare	String	No	Filter. Valid values:
WINC - Include (segment dimension) WEXC - Exclude (segment dimension) INC - Include, EXC - Exclude, EQS - Equal to, NEQ - Not equal to.
RA - Range Value	Array of String	No	The filter value. In a reverse query, multiple values are in an "AND" relationship; while in a forward query, multiple values are in an "OR" relationship.
InstanceDbAuditStatus

Instance audit details.

Used by actions: DescribeAuditInstanceList.

Name	Type	Description InstanceId	String	Instance ID.
AuditStatus	String	Audit status. ON - Audit is enabled, OFF - Audit is disabled.
AuditTask	Integer	Task status. Valid values: 0 - No task; 1 - Enabling audit; 2 - Disabling audit.
LogExpireDay	Integer	Log retention period. Valid values:7 - One week;30 - One month;90 - Three months;180 - Six months;365 - One year;1095 - Three years;1825 - Five years.
HighLogExpireDay	Integer	High-frequency storage period. Valid values:3 - 3 days;7 - One week;30 - One month;90 - Three months;180 - Six months;365 - One year;1095 - Three years;1825 - Five years.
LowLogExpireDay	Integer	Low-frequency storage period (in days). This equals the log retention period minus the high-frequency storage period.
BillingAmount	Float	Log storage volume (in GB).
HighRealStorage	Float	High-frequency storage volume (in GB).
LowRealStorage	Float	Low-frequency storage volume (in GB).
AuditAll	Boolean	Whether full audit is enabled. true - Full audit.
CreateAt	String	Time when the audit service was activated.
InstanceInfo	AuditInstanceInfo	Related information about the instance.
RealStorage	Float	Total storage volume (in GB).
OldRule	Boolean	Whether an audit policy is configured.
RuleTemplateIds	Array of String	Rule template applied to the instance.
TrialStatus	String	Trial status.
TrialStartTime	Integer	Trial start time.
TrialDuration	Integer	Trial duration.
TrialCloseTime	Integer	Trial end time.
TrialDescribeLogHours	Integer	Log query time limit during the trial period.
InstanceInfo

Instance details

Used by actions: DescribeDBInstances.

Name	Type	Description WanStatus	Integer

Public network status. Possible returned values: 0 - External network not enabled; 1 - Public network enabled; 2 - Public network disabled

Zone	String

AZ information

InitFlag	Integer

Initialization flag. Possible returned values: 0 - uninitialized; 1 - initialized.

RoVipInfo	RoVipInfo

Read-only vip information. This field is available only for read-only instances with separate instance access enabled.

Memory	Integer

Memory capacity, in MB.

Status	Integer

Instance status. Valid values: 0: creating; 1: running; 4: isolation operation in progress; 5: isolated.

VpcId	Integer

VPC ID, for example: 51102

SlaveInfo	SlaveInfo

Secondary server information

InstanceId	String

Instance ID

Volume	Integer

Disk capacity, in GB.

AutoRenew	Integer

Auto-renewal flag. Possible returned values: 0 - auto-renewal is not enabled; 1 - auto-renewal is enabled; 2 - automatic renewal is disabled.

ProtectMode	Integer

Data replication mode. 0 - async replication; 1 - semi-sync replication; 2 - strong sync replication

RoGroups	Array of RoGroup

Read-only group detailed information

SubnetId	Integer

Subnet ID, for example: 2333

InstanceType	Integer

Instance type. Possible returned values: 1 - Primary instance; 2 - Disaster recovery instance; 3 - Read-only instance.

ProjectId	Integer

Project ID

Region	String

Regional information

DeadlineTime	Timestamp

Instance expiration time

DeployMode	Integer

Availability Zone Deployment method. Valid values: 0 - single availability zone; 1 - multi-availability zone.

TaskStatus	Integer

Instance task status. 0 - No tasks, 1 - Upgrading, 2 - Data import, 3 - Opening Slave, 4 - Public network access enabling, 5 - Batch operation executing, 6 - Rolling back, 7 - Public network access disabling, 8 - Password modification, 9 - Renaming instance, 10 - Restarting, 12 - Self-built migration, 13 - Database deletion, 14 - Disaster recovery instance creation sync, 15 - Upgrade pending switch, 16 - Upgrade and switch, 17 - Upgrade and switch completed

MasterInfo	MasterInfo

Detailed information about the primary instance.

DeviceType	String

Instance type

EngineVersion	String

Kernel version

InstanceName	String

Instance name

DrInfo	Array of DrInfo

Disaster recovery instance details

WanDomain	String

public network domain name

WanPort	Integer

Public network port number

PayType	Integer	Billing type CreateTime	String

Instance creation time

Vip	String

Instance IP

Vport	Integer

Port number

CdbError	Integer

Whether disk write is locked (data write volume of the instance exceeds disk quota). 0 - Unlocked 1 - Locked

UniqVpcId	String

Private network descriptor, for example: "vpc-5v8wn9mg"

UniqSubnetId	String

Subnet descriptor, such as "subnet-1typ0s7d"

PhysicalId	String

Physical ID

Cpu	Integer

Core count

Qps	Integer

Queries per second.

ZoneName	String

Chinese Name of Availability Zone

DeviceClass	String

Physical machine model

DeployGroupId	String

Placement group ID

ZoneId	Integer

Availability zone ID

InstanceNodes	Integer

Number of nodes

TagList	Array of TagInfoItem

Tag list

EngineType	String

Engine type

MaxDelayTime	Integer

Maximum delay threshold

DiskType	String

Instance disk type. Only CLOUD disk edition and single-node (CLOUD disk) instances will return a valid value.
Description:

If "DiskType": "CLOUD_HSSD" is returned, it indicates that the instance disk type is enhanced SSD CLOUD disk.
If "DiskType": "CLOUD_SSD" is returned, it indicates that the instance disk type is SSD CLOUD Block Storage.
If "DiskType": "" is returned and the DeviceType parameter value is UNIVERSAL or EXCLUSIVE, it means that the instance uses local SSD.

ExpandCpu	Integer

Current number of CPU cores for scale-out.

ClusterInfo	Array of ClusterInfo

Cloud Disk Edition instance node information

AnalysisNodeInfos	Array of AnalysisNodeInfo

Analysis engine node list

DeviceBandwidth	Integer

Device bandwidth, in G. This parameter is valid only when DeviceClass is not empty. For example, 25 means the current device bandwidth is 25G; 10 means the current device bandwidth is 10G.

DestroyProtect	String

Instance termination protection status. on indicates enabled; otherwise, the protection is disabled.

CpuModel	String

TDSQL engine parameters

AnalysisUpgradeVersionInfo	UpgradeAnalysisInstanceVersionInfo

Analysis engine instance version upgrade information

Note: This field may return null, indicating that no valid values can be obtained.
InstanceRebootTime

Estimated time of instance restart

Used by actions: DescribeDBInstanceRebootTime.

Name	Type	Description InstanceId	String	Instance ID, in the format such as cdb-c1nl9rpv. This matches the instance ID displayed on the TencentDB console.
TimeInSeconds	Integer	Expected restart time, unit: second.
InstanceRollbackRangeTime

Time range available for instance rollback

Used by actions: DescribeRollbackRangeTime.

Name	Type	Description Code	Integer	Query database error codes. 0 - Normal, 1600001 - Internal error, 1600003 - Input parameter exception, 1600009 - Instance does not exist, 1624001 - DB access exception.
Message	String	Queries database error message InstanceId	String	List of instance IDs. An instance ID is in the format of cdb-c1nl9rpv, which is the same as the instance ID displayed on the TencentDB Console page.
Times	Array of RollbackTimeRange	Time range available for rollback LocalBinlogConfig

Local binlog retention configuration

Used by actions: DescribeLocalBinlogConfig.

Name	Type	Description SaveHours	Integer	Local binlog retention duration. Valid values: [6,168].
MaxUsage	Integer	Local binlog space utilization. Valid values: [30,50].
LocalBinlogConfigDefault

Default configuration of local binlog retention policy

Used by actions: DescribeLocalBinlogConfig.

Name	Type	Description SaveHours	Integer	Local binlog retention duration. Valid values: [6,168].
MaxUsage	Integer	Local binlog space utilization. Valid values: [30,50].
LogRuleTemplateInfo

Basic information on the rule template hit by the audit log.

Used by actions: DescribeAuditLogs.

Name	Type	Description RuleTemplateId	String	Template ID.
RuleTemplateName	String	Rule template name AlarmLevel	String	Alarm level. Valid values: 1 - Low risk, 2 - Medium risk, 3 - High risk.
RuleTemplateStatus	Integer	Rule template change status. Valid values: 0 - Not changed, 1 - changed, 2 - deleted.
LogToCLSConfig

Configurations of sending slow and error logs of a CDB instance to CLS.

Used by actions: DescribeDBInstanceLogToCLS.

Name	Type	Description Status	String	Delivery status on or turn off LogSetId	String	CLS Logset ID LogTopicId	String	Log topic ID ClsRegion	String	Region of the CLS service MasterInfo

Master instance information

Used by actions: DescribeDBInstances.

Name	Type	Description Region	String

Regional information

RegionId	Integer

Region ID

ZoneId	Integer

Availability zone ID.

Zone	String

AZ information

InstanceId	String

Instance ID.

ResourceId	String

Instance long ID

Status	Integer

Instance status

InstanceName	String

Instance name

InstanceType	Integer

Instance type

TaskStatus	Integer

Task status.

Memory	Integer

Memory capacity

Volume	Integer

Disk capacity

DeviceType	String

Instance model

Qps	Integer

Queries per second.

VpcId	Integer

VPC ID

SubnetId	Integer

subnet ID

ExClusterId	String

Dedicated cluster ID

ExClusterName	String

Dedicated cluster name

NodeDistribution

Node distribution of the dedicated cluster CDB instance

Used by actions: DescribeInstanceUpgradeType.

Name	Type	Required	Description Node	String	Yes	Host ID of the Master node of the primary instance or host ID of the read-only instance SlaveNodeOne	String	Yes	Host ID where the first Slave node of the primary instance resides SlaveNodeTwo	String	Yes	Host ID where the second Slave node of the primary instance resides Outbound

Security group outbound rule

Used by actions: DescribeDBSecurityGroups, DescribeProjectSecurityGroups.

Name	Type	Description Action	String	Policy, which can be ACCEPT or DROP CidrIp	String	Destination IP or IP range, such as 172.16.0.0/12 PortRange	String	Port or port range IpProtocol	String	Network protocol. UDP and TCP are supported Dir	String	The direction of the rule, which is OUTPUT for inbound rules AddressModule	String	Address module Desc	String	Rule description ParamInfo

Instance parameter information

Used by actions: CreateDBInstance, CreateDBInstanceHour.

Name	Type	Required	Description Name	String	Yes	Parameter name Value	String	Yes	Parameter value ParamRecord

Parameter modification records

Used by actions: DescribeInstanceParamRecords.

Name	Type	Description InstanceId	String	Instance ID ParamName	String	Parameter name OldValue	String	Parameter value before modification NewValue	String	Parameter value after modification ModifyTime	String	Modification time IsSuccess	Boolean	Indicates whether the parameter is modified successfully.
ParamTemplateInfo

Parameter template information

Used by actions: DescribeParamTemplates.

Name	Type	Description TemplateId	Integer	parameter template ID Name	String	Parameter template name Description	String	Parameter template description EngineVersion	String	Instance engine version. Values: 5.5, 5.6, 5.7, and 8.0.
TemplateType	String	Parameter template type. Valid values: HIGH_STABILITY, HIGH_PERFORMANCE.
EngineType	String	Parameter template engine, values: InnoDB, RocksDB.
Parameter

Database instance parameter

Used by actions: CreateParamTemplate, ModifyInstanceParam, ModifyInstancePasswordComplexity, ModifyParamTemplate.

Name	Type	Required	Description Name	String	No	Parameter name CurrentValue	String	No	Parameter value ParameterDetail

Instance parameter details

Used by actions: DescribeDefaultParams, DescribeInstanceParams, DescribeInstancePasswordComplexity, DescribeParamTemplateInfo.

Name	Type	Description Name	String	Parameter name ParamType	String	Parameter type. Valid values: integer, enum, float, string, func Default	String	Default value of the parameter Description	String	Parameter description CurrentValue	String	Current value of the parameter NeedReboot	Integer	Whether the database needs to be restarted for the modified parameter to take effect. Value range: 0 (no); 1 (yes) Max	Integer	Maximum value of the parameter Min	Integer	Minimum value of the parameter EnumValue	Array of String	Enumerated values of the parameter. It is null if the parameter is non-enumerated MaxFunc	String	Maximum parameter value, which is valid only when ParamType is set to func MinFunc	String	Minimum parameter value, which is valid only when ParamType is set to func IsNotSupportEdit	Boolean	Whether the parameter cannot be modified PeriodStrategy

Scale by the selected period in the scaling policy

Used by actions: DescribeCPUExpandStrategyInfo, StartCpuExpand.

Name	Type	Required	Description TimeCycle	TImeCycle	No	Scale-out period TimeInterval	TimeInterval	No	Time interval ProxyAddress

Information of the database proxy address

Used by actions: DescribeCdbProxyInfo.

Name	Type	Description ProxyAddressId	String	Address ID of the proxy group UniqVpcId	String	VPC ID UniqSubnetId	String	VPC subnet ID Vip	String	IP address VPort	Integer	Port WeightMode	String	Weight allocation mode.
System Auto-Assignment: "system", Custom: "custom" IsKickOut	Boolean	Whether to enable delay removal. Parameter value: "true" | "false" MinCount	Integer	Minimum retention quantity, minimum value: 0.
MaxDelay	Integer	Delay removal threshold, minimum value: 0 AutoAddRo	Boolean	Automatically add RO. Value: "true" | "false" ReadOnly	Boolean	Whether it is read-only. Value: "true" | "false".
TransSplit	Boolean	Whether transaction splitting is enabled FailOver	Boolean	Whether fault migration is enabled ConnectionPool	Boolean	Whether to enable connection pool Desc	String	Description ProxyAllocation	Array of ProxyAllocation	Read weight distribution of an instance AccessMode	String	Access mode AutoLoadBalance	Boolean	Whether automatic CLB is enabled ApNodeAsRoNode	Boolean	Whether to treat libra as a read-only node ApQueryToOtherNode	Boolean	libra node fault, whether to forward to other nodes ProxyAllocation

Weight allocation for a proxy node

Used by actions: AdjustCdbProxyAddress, CreateCdbProxyAddress, DescribeCdbProxyInfo.

Name	Type	Required	Description Region	String	Yes	Proxy node region Zone	String	Yes	AZ of proxy node region ProxyInstance	Array of ProxyInst	Yes	Proxy instance allocation ProxyGroupInfo

Details of proxy group

Used by actions: DescribeCdbProxyInfo.

Name	Type	Description ProxyGroupId	String	Proxy group ID ProxyVersion	String	proxy version SupportUpgradeProxyVersion	String	Proxy supports edition upgrade Status	String	Agent status. 0 - Initializing, 1 - Online, 2 - Online - Read-write separation, 3 - Offline, 4 - Terminated.
TaskStatus	String	Agent task status, Upgrading - upgrading, UpgradeTo - upgrade pending switch, UpgradeSwitching - upgrade and switch in progress, ProxyCreateAddress - configuring address, ProxyModifyAddress - changing address, ProxyCloseAddress - closing address.
ProxyNode	Array of ProxyNode	Proxy group node information ProxyAddress	Array of ProxyAddress	Proxy group address information ConnectionPoolLimit	Integer	Connection pool threshold SupportCreateProxyAddress	Boolean	Support creating an address SupportUpgradeProxyMysqlVersion	String	cdb version required for proxy version upgrade ProxyInst

Proxy instance

Used by actions: AdjustCdbProxyAddress, CreateCdbProxyAddress.

Name	Type	Required	Description InstanceId	String	No	Instance ID.
InstanceName	String	No	Instance name.
InstanceType	Integer	No	Instance type: 1 master primary instance; 2 read-only instance; 3 dr disaster recovery instance; 4 sdr (small disaster recovery) instance Status	Integer	No	Instance status. Valid values: 0: creating; 1: running; 4: isolation; 5: isolated.
Weight	Integer	No	Read-only weight. If the weight is automatically assigned by the system, this value does not take effect and only indicates whether the instance is enabled or not.
Region	String	No	Instance region Zone	String	No	Availability zone to which the instance belongs InstNodeId	String	No	Instance Node ID InstNodeRole	String	No	Node role ProxyNode

Proxy node

Used by actions: DescribeCdbProxyInfo.

Name	Type	Description ProxyId	String	Proxy node ID Cpu	Integer	Number of CPU cores.
Mem	Integer	Memory size, measured in MB.
Status	String	Node status: 0 - Initializing, 1 - Online, 2 - Offline, 3 - Being destroyed, 4 - Recovering, 5 - Node fault, 6 - Switching.
Zone	String	Proxy node availability zone Region	String	Proxy Node Region Connection	Integer	Number of connections ProxyNodeCustom

The specification configuration of a node

Used by actions: AdjustCdbProxy, CreateCdbProxy.

Name	Type	Required	Description NodeCount	Integer	Yes	Number of nodes Cpu	Integer	Yes	Number of CPU cores Mem	Integer	Yes	Memory size Region	String	Yes	Region Zone	String	Yes	AZ ReadWriteNode

Configuration of the cloud disk edition RW node.

Used by actions: CreateCloneInstance, CreateDBInstance, CreateDBInstanceHour, DescribeInstanceUpgradeType, UpgradeDBInstance.

Name	Type	Required	Description Zone	String	Yes	Availability zone where the RW node is located.
NodeId	String	No	When upgrading a cloud disk edition instance, if you need to adjust the Availability Zone of Read-Only Nodes, you must specify the node ID.
ReadonlyNode

RO node configuration for cloud disk edition.

Used by actions: CreateCloneInstance, CreateDBInstance, CreateDBInstanceHour, DescribeInstanceUpgradeType, UpgradeDBInstance.

Name	Type	Required	Description IsRandomZone	String	No	Whether distributed in a random availability Zone. Import YES means random availability Zone. Otherwise used specified availability Zone.
Zone	String	No	Specify the availability zone for node distribution.
NodeId	String	No	When upgrading a cloud disk edition instance, if you need to adjust the Availability Zone of Read-Only Nodes, you must specify the node ID.
ReleaseResult

Deisolation task result

Used by actions: ReleaseIsolatedDBInstances.

Name	Type	Description InstanceId	String	Instance ID.
Code	Integer	Result value of instance deisolation. A returned value of 0 indicates success.
Message	String	Error message for instance deisolation.
RemoteBackupInfo

Information of the remote backup

Used by actions: DescribeBackups, DescribeBinlogs.

Name	Type	Description SubBackupId	Integer	ID of the remote backup subtask Region	String	The region where the remote backup resides Status	String	Backup task status. Valid values: SUCCESS (backup succeeded), FAILED (backup failed), RUNNING (backup is in progress).
StartTime	String	The start time of remote backup FinishTime	String	The end time of remote backup Url	String	The download address RoGroup

Read-only group parameter

Used by actions: CreateDBInstance, CreateDBInstanceHour, DescribeDBInstances, DescribeRoGroups.

Name	Type	Required	Description RoGroupMode	String	Yes

Read-only group mode. Available values are: alone-automatic allocation by the system; allinone-create a read-only group; join-use an existing read-only group.

RoGroupId	String	No

Read-only group ID.
Note: If the data structure is used during instance purchase, this item is required only when the read-only group mode is set to join.

RoGroupName	String	No

Read-only group name.

RoOfflineDelay	Integer	No

Whether to enable the feature to isolate an instance that exceeds the latency threshold. After enabling this feature, if the delay between a read-only instance and the primary instance exceeds the delay threshold, the read-only instance will be isolated. Available values: 1-enable; 0-disable.

RoMaxDelayTime	Integer	No

Delay threshold, in seconds. Value range: 1–10000. The value is an integer.

MinRoInGroup	Integer	No

Minimum number of instances to retain. If the number of read-only instances purchased is less than the set number, removal will not occur.

WeightMode	String	No

Read-write weight allocation mode. Available values: system-automatic allocation by the system; custom-customization.

Weight	Integer	No

This field is deprecated and meaningless. To view the weight of a read-only instance, check the Weight value in the RoInstances field.

RoInstances	Array of RoInstanceInfo	No

Details of read-only instances in the read-only group.

Vip	String	No

Private IP address of the read-only group.

Vport	Integer	No

Private network port number of the read-only group.

UniqVpcId	String	No

VPC ID.

UniqSubnetId	String	No

Subnet ID.

RoGroupRegion	String	No

Region of the read-only group.

RoGroupZone	String	No

AZ of the read-only group.

DelayReplicationTime	Integer	No

Replication delay time, in seconds. Value range: 1–259200. The value is an integer.

RoGroupAttr

RO group configuration information.

Used by actions: ModifyRoGroupInfo.

Name	Type	Required	Description RoGroupName	String	No	RO group name.
RoMaxDelayTime	Integer	No	Maximum delay threshold for the RO instance. Unit: seconds, minimum value is 1. Range: [1,10000], integer.
Note: The RO group must have enabled the instance latency removal policy for this value to be valid.
RoOfflineDelay	Integer	No	Whether to enable instance removal. Valid values: 1 (enabled), 0 (not enabled). Please note that if instance removal is enabled, the delay threshold parameter (RoMaxDelayTime) must be set.
MinRoInGroup	Integer	No	Minimum reserved instances. Can be set to any value ≤ the number of instances in the RO group. Default value: 1.
Note: If the set value is larger than the RO instance count, do not remove. If set to 0, all instances with delay above the limit will be excluded.
WeightMode	String	No	Weighting mode. Supported values include system (automatically assigned by the system) and custom (defined by user). Please note that if the custom mode is selected, the RO instance weight configuration parameter (RoWeightValues) must be set.
ReplicationDelayTime	Integer	No	Delayed replication time. Unit: second, range: 1 - 259200 seconds, not required to enable delayed replication for the instance.
RoInstanceInfo

RO instance details

Used by actions: CreateDBInstance, CreateDBInstanceHour, DescribeDBInstances, DescribeRoGroups.

Name	Type	Required	Description MasterInstanceId	String	No	Master instance ID corresponding to the RO group RoStatus	String	No	RO instance status in the RO group. Value range: online, offline OfflineTime	String	No	Last deactivation time of a RO instance in the RO group Weight	Integer	No	RO instance weight in the RO group Region	String	No	RO instance region name, such as ap-shanghai Zone	String	No	Canonical name of the RO Availability Zone, for example ap-shanghai-2 InstanceId	String	No	RO instance ID in the format of cdbro-c1nl9rpv Status	Integer	No	RO instance status. Valid values: 0 (creating), 1 (running), 3 (remote RO), 4 (deleting). When the DescribeDBInstances API is used to query the information of the source instance, if the source instance is associated with a remote read-only instance, the returned status value of the remote read-only instance always shows 3.
InstanceType	Integer	No	Instance type. Value range: 1 (primary), 2 (disaster recovery), 3 (read-only) InstanceName	String	No	RO instance name HourFeeStatus	Integer	No	Pay-as-you-go status. Valid values: 1 - normal; 2 - in arrears.
TaskStatus	Integer	No	RO instance task status. Value range:
0 - no task 1 - upgrading 2 - importing data 3 - activating secondary 4 - public network access enabled 5 - batch operation in progress 6 - rolling back 7 - public network access not enabled 8 - modifying password 9 - renaming instance 10 - restarting 12 - migrating self-built instance 13 - dropping table 14 - creating and syncing disaster recovery instance Memory	Integer	No	RO instance memory size in MB Volume	Integer	No	RO instance disk size in GB Qps	Integer	No	Queries per second Vip	String	No	Private IP address of the RO instance Vport	Integer	No	Access port of the RO instance VpcId	Integer	No	VPC ID of the RO instance SubnetId	Integer	No	VPC subnet ID of the RO instance DeviceType	String	No	RO instance specification description. Value range: CUSTOM EngineVersion	String	No	Database engine version of the read-only replica. Valid values: 5.1, 5.5, 5.6, 5.7, 8.0 DeadlineTime	String	No	RO instance expiration time in the format of yyyy-mm-dd hh:mm:ss. If it is a pay-as-you-go instance, the value of this field is 0000-00-00 00:00:00 PayType	Integer	No	Billing type of the RO instance. Valid values: 0 - yearly/monthly subscription; 1 - pay-as-you-go; 2-postpaid by month.
ReplicationStatus	String	No	RO replication delay status.
RoVipInfo

VIP information of the read-only instance

Used by actions: DescribeDBInstances.

Name	Type	Description RoVipStatus	Integer	VIP status of the read-only instance RoSubnetId	Integer	VPC subnet of the read-only instance RoVpcId	Integer	VPC of the read-only instance RoVport	Integer	VIP port number of the read-only instance RoVip	String	VIP of the read-only instance RoWeightValue

RO instance weight value

Used by actions: ModifyRoGroupInfo.

Name	Type	Required	Description InstanceId	String	Yes	RO instance ID.
Weight	Integer	Yes	Weight value. Value range: [0, 100].
RollbackDBName

Name of the database for rollback

Used by actions: StartBatchRollback.

Name	Type	Required	Description DatabaseName	String	Yes	Original database name before rollback NewDatabaseName	String	Yes	Name of the rolled back database RollbackInstancesInfo

Details of the instance for rollback

Used by actions: DescribeRollbackTaskDetail, StartBatchRollback.

Name	Type	Required	Description InstanceId	String	Yes	Cloud database instance ID.
Strategy	String	Yes	Rollback strategy. Optional values: table, db, full. table - Ultra-fast rollback mode, only imports selected table-level backups and binlog. If there are cross-table operations and the associated table hasn't been selected, it will cause rollback failure. In this mode, parameter Databases must be empty. db - Quick mode, only imports selected database-level backups and binlog. If there are cross-database operations and the associated database hasn't been selected, it will cause rollback failure. full - Standard rollback mode, imports backups and binlog of the entire instance, speed is not as fast.
RollbackTime	String	Yes	Database rollback time in the format of yyyy-mm-dd hh:mm:ss.
Databases	Array of RollbackDBName	No	Database information to be rolled back, which means database rollback.
Tables	Array of RollbackTables	No	Database table information to be rolled back, which means rollback by table.
RollbackTableName

Name of the table for rollback

Used by actions: StartBatchRollback.

Name	Type	Required	Description TableName	String	Yes	Original database table name before rollback NewTableName	String	Yes	Rolled back database table name RollbackTables

Details of the table for rollback

Used by actions: StartBatchRollback.

Name	Type	Required	Description Database	String	Yes	Database name Table	Array of RollbackTableName	Yes	Database table details RollbackTask

Rollback task details

Used by actions: DescribeRollbackTaskDetail.

Name	Type	Description Info	String	Task execution information.
Status	String	Task execution result. Valid values: INITIAL: initializing, RUNNING: running, SUCCESS: succeeded, FAILED: failed, KILLED: terminated, REMOVED: deleted, PAUSED: paused.
Progress	Integer	Task execution progress. Value range: [0,100].
StartTime	String	Task start time.
EndTime	String	Task end time.
Detail	Array of RollbackInstancesInfo	Rollback task detail.
RollbackTimeRange

Time range available for rollback

Used by actions: DescribeRollbackRangeTime.

Name	Type	Description Begin	String	Start time available for rollback in the format of yyyy-MM-dd HH:mm:ss, such as 2016-10-29 01:06:04 End	String	End time available for rollback in the format of yyyy-MM-dd HH:mm:ss, such as 2016-11-02 11:44:47 Rule

Weight rule

Used by actions: DescribeProxyCustomConf.

Name	Type	Description LessThan	Integer	Division ceiling Weight	Integer	Weight RuleFilters

Filter of the audit rule

Used by actions: CreateAuditRuleTemplate, DescribeAuditRuleTemplateModifyHistory, DescribeAuditRuleTemplates, ModifyAuditRuleTemplates.

Name	Type	Required	Description Type	String	Yes	Parameter name of the audit rule filter. Valid values: host (client IP), user (database account), dbName (database name), sqlType (SQL type), sql (SQL statement), affectRows (affected rows), sentRows (returned rows), checkRows (scanned rows), execTime (execution rows).
Compare	String	Yes	Filter match value of the audit rule Valid values: INC (including), EXC (excluding), EQS (equal to), NEQ (not equal to), REG (regex), GT (greater than), LT (less than).
Value	Array of String	Yes	Filter match value of the audit rule Valid values for sqlType: alter, changeuser, create, delete, drop, execute, insert, login, logout, other, replace, select, set,update`.
RuleTemplateInfo

Rule template content.

Used by actions: DescribeAuditRuleTemplateModifyHistory.

Name	Type	Description RuleTemplateId	String	Rule template ID.
RuleTemplateName	String	Rule template name.
RuleFilters	Array of RuleFilters	Rule content.
AlarmLevel	Integer	Alarm level. Valid values: 1 - Low risk, 2 - Medium risk, 3 - High risk.
AlarmPolicy	Integer	Alarm policy. Valid values: 0 - Alarm disabled, 1 - Alarm enabled.
Description	String	Rule description.
RuleTemplateRecordInfo

Rule template change history.

Used by actions: DescribeAuditRuleTemplateModifyHistory.

Name	Type	Description TaskId	Integer	Task ID.
ModifyBeforeInfo	RuleTemplateInfo	Details of the original rule template.
ModifyAfterInfo	RuleTemplateInfo	Details of the modified rule template.
AffectedInstances	Array of String	Affected instances.
Operator	String	Operator (account UIN).
UpdateTime	String	Time of the change.
SecurityGroup

Security group details

Used by actions: DescribeDBSecurityGroups, DescribeProjectSecurityGroups.

Name	Type	Description ProjectId	Integer	Project ID CreateTime	String	Creation time in the format of yyyy-mm-dd hh:mm:ss Inbound	Array of Inbound	Inbound rule Outbound	Array of Outbound	Outbound rule SecurityGroupId	String	Security group ID SecurityGroupName	String	Security group name SecurityGroupRemark	String	Security group remarks SlaveConfig

Configuration information of the salve database

Used by actions: DescribeDBInstanceConfig.

Name	Type	Description ReplicationMode	String	Replication mode of the secondary database. Value range: async, semi-sync Zone	String	Canonical name of the read-only availability zone, for example ap-shanghai-2 SlaveInfo

Slave server information

Used by actions: DescribeDBInstances.

Name	Type	Description First	SlaveInstanceInfo

Secondary server information of the top spot

Second	SlaveInstanceInfo

Second standby machine information

SlaveInstanceInfo

Slave server information

Used by actions: DescribeDBInstances.

Name	Type	Description Vport	Integer	Port number Region	String	Region information Vip	String	Virtual IP information Zone	String	AZ information SlowLogInfo

Slow log details

Used by actions: DescribeSlowLogs.

Name	Type	Description Name	String	Backup filename Size	Integer	Backup file size in bytes Date	String	Backup snapshot time. Time format: 2016-03-17.
IntranetUrl	String	Download address on the private network InternetUrl	String	Download address on the public network Type	String	Log type. Value range: slowlog (slow log) SlowLogItem

Structured slow log details

Used by actions: DescribeSlowLogData.

Name	Type	Description Timestamp	Integer	Sql execution time. Unix second-level timestamp.
QueryTime	Float	Execution duration of Sql (seconds).
SqlText	String	Sql statement.
UserHost	String	Client IP address.
UserName	String	Username.
Database	String	Database name.
LockTime	Float	Lock duration (unit: second).
RowsExamined	Integer	Number of scanned rows.
RowsSent	Integer	Result set row count.
SqlTemplate	String	Sql Template.
Md5	String	md5 of the Sql statement.
SqlFileInfo

SQL file information

Used by actions: DescribeUploadedFiles.

Name	Type	Description UploadTime	Timestamp	Upload time UploadInfo	UploadInfo	Upload progress FileName	String	Filename FileSize	Integer	File size in bytes IsUploadFinished	Integer	Whether upload is finished. Valid values: 0 (not completed), 1 (completed) FileId	String	File ID TImeCycle

Scale-out period

Used by actions: DescribeCPUExpandStrategyInfo, StartCpuExpand.

Name	Type	Required	Description Monday	Boolean	No	Whether to choose Monday for scaling during the period.
Description: Value "true" means select, value "false" means not select.
Tuesday	Boolean	No	During scaling, whether to choose Tuesday for expansion.
Description: Value "true" means select, value "false" means not select.
Wednesday	Boolean	No	Whether to choose Wednesday for scaling during the period.
Description: Value "true" means select, value "false" means not select.
Thursday	Boolean	No	Whether to choose Thursday for scaling during the period.
Description: Value "true" means select, value "false" means not select.
Friday	Boolean	No	Whether to choose Friday for scaling during the period.
Description: Value "true" means select, value "false" means not select.
Saturday	Boolean	No	Whether to choose Saturday for scaling during the period.
Description: Value "true" means select, value "false" means not select.
Sunday	Boolean	No	Whether to choose Sunday for scaling during the period.
Description: Value "true" means select, value "false" means not select.
TablePrivilege

Table permission

Used by actions: DescribeAccountPrivileges, ModifyAccountPrivileges.

Name	Type	Required	Description Database	String	Yes	Database name Table	String	Yes	Table name Privileges	Array of String	Yes	Permission information Tag

Tag structure

Used by actions: DescribeDBInstances.

Name	Type	Required	Description Key	String	Yes	Tag key Value	String	Yes	Tag value TagInfo

Tag information

Used by actions: CreateCloneInstance, CreateDBInstance, CreateDBInstanceHour, ModifyInstanceTag.

Name	Type	Required	Description TagKey	String	Yes	Tag key TagValue	Array of String	Yes	Tag value TagInfoItem

Tag information

Used by actions: DescribeDBInstances, ModifyDBInstanceLogToCLS.

Name	Type	Required	Description TagKey	String	Yes	Tag key.
TagValue	String	Yes	Tag value.
TagInfoUnit

Tag information unit

Used by actions: DescribeAuditInstanceList, DescribeTagsOfInstanceIds.

Name	Type	Description TagKey	String	Tag key TagValue	String	Tag value TagsInfoOfInstance

Instance tag information

Used by actions: DescribeTagsOfInstanceIds.

Name	Type	Description InstanceId	String	Instance ID Tags	Array of TagInfoUnit	Tag information TaskAttachInfo

Some tasks in the task list support specific additional information

Used by actions: DescribeTasks.

Name	Type	Description AttachKey	String	Upgrade task "FastUpgradeStatus": Indicates the upgrade type. 1 - in-place upgrade; 0 - normal upgrade.
AttachValue	String	Upgrade task "FastUpgradeStatus": Indicates the upgrade type. 1 - In-place upgrade; 0 - Normal upgrade.
TaskDetail

Details of an instance task

Used by actions: DescribeTasks.

Name	Type	Description Code	Integer	Error code. 0 indicates success. Other values correspond to different error scenarios.
Message	String	Error message.
JobId	Integer	ID of an instance task.
Progress	Integer	Instance task progress.
TaskStatus	String	Instance task status. Valid values:
"UNDEFINED" - undefined;
"INITIAL" - initializing;
"RUNNING" - running;
"SUCCEED" - succeeded;
"FAILED" - failed;
"KILLED" - terminated;
"REMOVED" - deleted;
"PAUSED" - paused.
"WAITING" - waiting (which can be canceled) TaskType	String	Instance task type. Valid values:
"ROLLBACK" - rolling back a database;
"SQL OPERATION" - performing an SQL operation;
"IMPORT DATA" - importing data;
"MODIFY PARAM" - setting a parameter;
"INITIAL" - initializing a TencentDB instance;
"REBOOT" - restarting a TencentDB instance;
"OPEN GTID" - enabling GTID of a TencentDB instance;
"UPGRADE RO" - upgrading a read-only instance;
"BATCH ROLLBACK" - rolling back databases in batches;
"UPGRADE MASTER" - upgrading a primary instance;
"DROP TABLES" - dropping a TencentDB table;
"SWITCH DR TO MASTER" - promoting a disaster recovery instance.
StartTime	String	Instance task start time.
EndTime	String	Instance task end time.
InstanceIds	Array of String	ID of the associated instance.
AsyncRequestId	String	Async task request ID.
TaskAttachInfo	Array of TaskAttachInfo	Additional information of the task.
TimeInterval

Time period.

Used by actions: DescribeCPUExpandStrategyInfo, StartCpuExpand.

Name	Type	Required	Description StartTime	String	No	Start time.
EndTime	String	No	End time.
TimeIntervalStrategy

Scaling policy by time period

Used by actions: DescribeCPUExpandStrategyInfo, StartCpuExpand.

Name	Type	Required	Description StartTime	Integer	No	Expansion time started.
Description: This value is a timestamp in seconds in Integer format.
EndTime	Integer	No	Expansion time ended.
Description: This value is a timestamp in seconds in Integer format.
UpgradeAnalysisInstanceVersionInfo

Analysis engine instance version upgrade info

Used by actions: DescribeDBInstances.

Name	Type	Description Vip	String

Grayscale ip for version upgrade

Vport	Integer

Grayscale port for version upgrade

EngineVersion	String

Upgrade to a later version

ExpireTime	Integer

Grayscale event for instance upgrade

Unit: day

UpgradeEngineVersionParams

Structure of specified parameters for upgrade from 5.7 to 8.0

Used by actions: UpgradeDBInstanceEngineVersion.

Name	Type	Required	Description Name	String	No	Parameter name.
Value	String	No	Parameter value.
UploadInfo

File upload description

Used by actions: DescribeUploadedFiles.

Name	Type	Description AllSliceNum	Integer	Number of parts of file CompleteNum	Integer	Number of completed parts ZoneConf

Multi-AZ information

Used by actions: DescribeCdbZoneConfig.

Name	Type	Required	Description DeployMode	Array of Integer	Yes	AZ deployment mode. Value range: 0 (single-AZ), 1 (multi-AZ) MasterZone	Array of String	Yes	AZ where the primary instance is located SlaveZone	Array of String	Yes	AZ where salve database 1 is located when the instance is deployed in multi-AZ mode BackupZone	Array of String	Yes	AZ where salve database 2 is located when the instance is deployed in multi-AZ mode Previous Topic: DescribeDeviceMonitorInfo Next Topic: Error Codes Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Account AccountInfo AddressInfo AggregationCondition AnalysisNodeInfo AuditFilter AuditInstanceFilters AuditInstanceInfo AuditLog AuditLogAggregationResult AuditLogFile AuditPolicy AuditRule AuditRuleTemplateInfo AutoStrategy BackupConfig BackupInfo BackupItem BackupLimitVpcItem BackupSummaryItem BinlogInfo Bucket CdbRegionSellConf CdbSellConfig CdbSellType CdbZoneDataResult CdbZoneSellConf CloneItem ClusterInfo ClusterNodeInfo ClusterTopology ColumnPrivilege CommonTimeWindow CustomConfig DBSwitchInfo DatabasePrivilege DatabasesWithCharacterLists DeviceCpuInfo DeviceCpuRateInfo DeviceDiskInfo DeviceMemInfo DeviceNetInfo DiskTypeConfigItem DrInfo ErrlogItem ImportRecord Inbound InstEventInfo InstanceAuditLogFilters InstanceDbAuditStatus InstanceInfo InstanceRebootTime InstanceRollbackRangeTime LocalBinlogConfig LocalBinlogConfigDefault LogRuleTemplateInfo LogToCLSConfig MasterInfo NodeDistribution Outbound ParamInfo ParamRecord ParamTemplateInfo Parameter ParameterDetail PeriodStrategy ProxyAddress ProxyAllocation ProxyGroupInfo ProxyInst ProxyNode ProxyNodeCustom ReadWriteNode ReadonlyNode ReleaseResult RemoteBackupInfo RoGroup RoGroupAttr RoInstanceInfo RoVipInfo RoWeightValue RollbackDBName RollbackInstancesInfo RollbackTableName RollbackTables RollbackTask RollbackTimeRange Rule RuleFilters RuleTemplateInfo RuleTemplateRecordInfo SecurityGroup SlaveConfig SlaveInfo SlaveInstanceInfo SlowLogInfo SlowLogItem SqlFileInfo TImeCycle TablePrivilege Tag TagInfo TagInfoItem TagInfoUnit TagsInfoOfInstance TaskAttachInfo TaskDetail TimeInterval TimeIntervalStrategy UpgradeAnalysisInstanceVersionInfo UpgradeEngineVersionParams UploadInfo ZoneConf Search AllCurrent Product Search titles only Enter keywords to search documentation
