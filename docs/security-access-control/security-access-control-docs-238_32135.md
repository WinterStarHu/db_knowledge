# Data Types

> 来源: https://www.tencentcloud.com/document/product/238/32135

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Data Types Data Types Download Focus Mode Font Size Last updated: 2026-06-30 11:29:35

AccountCreateInfo

Account creation information

Used by actions: CreateAccount.

Name	Type	Required	Description UserName	String	Yes	Instance username Password	String	No	Instance password DBPrivileges	Array of DBPrivilege	No	List of database permissions Remark	String	No	Account remarks IsAdmin	Boolean	No	Whether it is an admin account. Valid values: true (it is an admin account when the instance is a single-node type and AccountType is L0; when the instance is a two-node type and AccountType is L1), false (it is a standard account when AccountType is L3) Authentication	String	No	Valid values: win-windows authentication, sql-sqlserver authentication. Default value: sql-sqlserver authentication AccountType	String	No	Account type, which is an extension field of IsAdmin. Valid values: L0 (admin account, only for basic edition), L1 (privileged account), L2 (designated account), L3 (standard account, default) IsCam	Boolean	No	Whether CAM authentication is enabled.
EncryptedVersion	Integer	No	Encryption key version number. 0: disable encryption.

AccountDetail

Account information details

Used by actions: DescribeAccounts.

Name	Type	Description Name	String	Account name Remark	String	Account remarks CreateTime	Timestamp	Account creation time Status	Integer	Account status. 1: creating, 2: normal, 3: modifying, 4: resetting password, -1: deleting UpdateTime	Timestamp	Account update time PassTime	Timestamp	Password update time InternalStatus	String	Internal account status, which should be enable normally Dbs	Array of DBPrivilege	Information of read and write permissions of this account on relevant databases IsAdmin	Boolean	Whether it is an admin account IsCam	Boolean	Whether it is a CAM managed account Authentication	String	Valid values: win-windows authentication, sql-sqlserver authentication.
Host	String	The host required for win-windows authentication account AccountType	String	Account type. Valid values: L0 (admin account, only for basic edition), L1 (privileged account), L2 (designated account), L3 (standard account).

AccountPassword

Instance account password information

Used by actions: ResetAccountPassword.

Name	Type	Required	Description UserName	String	Yes	Username Password	String	Yes	Password

AccountPrivilege

Database account permission information, which is set when the database is created

Used by actions: CreateDB, DescribeAccountPrivilegeByDB, DescribeDBs, DescribeDatabases, ModifyDatabasePrivilege.

Name	Type	Required	Description UserName	String	Yes	Database username Privilege	String	Yes	Database permission. Valid values: ReadWrite (read-write), ReadOnly (read-only), Delete (delete the database permissions of this account), DBOwner (owner).
AccountType	String	No	Account name. Valid values: L0 (admin account, only for basic edition), L1 (privileged account), L2 (designated account), L3 (standard account).

AccountPrivilegeModifyInfo

Database account permission change information

Used by actions: ModifyAccountPrivilege.

Name	Type	Required	Description UserName	String	Yes	Database username DBPrivileges	Array of DBPrivilegeModifyInfo	Yes	Account permission change information IsAdmin	Boolean	No	Whether it is an instance admin account. Valid values: true (Yes. When the instance is single-node and AccountType is L0, it's an admin account; when the instance is two-node and AccountType is L1, it's a privileged account), false (No. It's a standard account and AccountType is L3).
AccountType	String	No	Account type, which is an extension field of IsAdmin. Valid values: L0 (admin account, only for basic edition), L1 (privileged account), L2 (designated account), L3 (standard account, default)

AccountRemark

Account remarks

Used by actions: ModifyAccountRemark.

Name	Type	Required	Description UserName	String	No	Account name Remark	String	No	New remarks of account

Backup

Backup file details

Used by actions: DescribeBackups.

Name	Type	Description FileName	String	File name. The name of an unarchived backup file is returned by the DescribeBackupFiles API instead of this parameter.
Size	Integer	File size in KB. The size of an unarchived backup file is returned by the DescribeBackupFiles API instead of this parameter.
StartTime	Timestamp	Backup start time EndTime	Timestamp	Backup end time InternalAddr	String	Private network download address. The download address of an unarchived backup file is returned by the DescribeBackupFiles API instead of this parameter.
ExternalAddr	String	Public network download address. The download address of an unarchived backup file is returned by the DescribeBackupFiles API instead of this parameter.
Id	Integer	Unique ID of a backup file, which is used by the RestoreInstance API. The unique ID of an unarchived backup file is returned by the DescribeBackupFiles API instead of this parameter.
Status	Integer	Backup file status (0: creating, 1: succeeded, 2: failed) DBs	Array of String	List of databases for multi-database backup Strategy	Integer	Backup policy (0: instance backup, 1: multi-database backup) BackupWay	Integer	Backup Mode. Valid values: 0 (scheduled backup); 1 (manual backup); 2 (archive backup).
BackupName	String	Backup task name (customizable) GroupId	String	Group ID of unarchived backup files, which can be used as a request parameter in the DescribeBackupFiles API to get details of unarchived backup files in the specified group. This parameter is invalid for archived backup files.
BackupFormat	String	Backup file format. Valid values:pkg (archive file), single (unarchived files).
Region	String	The code of current region where the instance resides CrossBackupAddr	Array of CrossBackupAddr	The download address of cross-region backup in target region CrossBackupStatus	Array of CrossRegionStatus	The target region and status of cross-region backup

BackupFile

If the backup files are unarchived, each database corresponds to one backup file.

Used by actions: DescribeBackupFiles.

Name	Type	Description Id	Integer	Unique ID of a backup file FileName	String	Backup file name Size	Integer	File size in KB DBs	Array of String	Name of the database corresponding to the backup file DownloadLink	String	Download address Region	String	The code of the region where current instance resides CrossBackupAddr	Array of CrossBackupAddr	The target region and download address of cross-region backup

BusinessIntelligenceFile

Business intelligence service file type

Used by actions: DescribeBusinessIntelligenceFile.

Name	Type	Description FileName	String	File name FileType	String	File type FileURL	String	File COS_URL FilePath	String	The file path on the server FileSize	Integer	File size in bytes FileMd5	String	File MD5 value Status	Integer	File deployment status. Valid values: 1(Initialize to be deployed), 2 (Deploying), 3 (Deployment successful), 4 (Deployment failed).
Remark	String	Remarks CreateTime	String	File creation time StartTime	String	Start time of file deployment EndTime	String	End time of file deployment Message	String	Returned error message InstanceId	String	Business intelligence instance ID Action	FileAction	Operation information

CheckItem

Instance Resizing Inspection Items

Used by actions: DescribeUpgradeInstanceCheck.

Name	Type	Description CheckName	String	Check item names: CK_CPU - Post-Resizing CPU Risk Check; CK_MASTER_STORAGE - During read-only replica resizing, verify that read-only replica storage space is not less than that of the primary instance; CK_MEMORY - Post-Resizing Memory Risk Check; CK_STORAGE - Post-Resizing Storage Space Risk Check; CK_UPGRATE - Resizing Migration Requirement Check;
CurrentValue	String	Check item return values: CK_CPU - Maximum CPU utilization (%) in the last 7 days; CK_MASTER_STORAGE - Disk space of the primary instance (GB); CK_MEMORY - Maximum memory usage (GB) in the last 7 days;

CK_STORAGE - Maximum disk usage (GB) in the last 7 days; CK_UPGRATE - Whether the current resizing check requires migration: MIGRATE indicates migration resizing is required, LOCAL indicates local resizing;
Passed	Integer	Check item pass status: 0 - Not passed, resizing not allowed; 1 - Passed, resizing allowed IsAffect	Integer	Whether this resizing item affects the instance: 0 - No impact; 1 - Impact exists Msg	String	Required description when impact exists or the check is not passed MsgCode	Integer	Describe the corresponding code

CosUploadBackupFile

Querying the size of uploaded backup files.

Used by actions: DescribeBackupUploadSize.

Name	Type	Description FileName	String	Backup name Size	Integer	Backup size

CrossBackupAddr

All Download addresses of cross-region backup

Used by actions: DescribeBackupFiles, DescribeBackups.

Name	Type	Description CrossRegion	String	The target region of cross-region backup CrossInternalAddr	String	The address used to download the cross-region backup over a private network CrossExternalAddr	String	The address used to download the cross-region backup over a public network

CrossRegionStatus

The target region and status of cross-region backup

Used by actions: DescribeBackups.

Name	Type	Description CrossRegion	String	The target region of cross-region backup CrossStatus	Integer	Synchronization status of cross-region backup. Valid values: 0 (creating), 1 (succeeded), 2: (failed), 4 (syncing)

CrossSummaryDetailRes

Cross-Region Backup Real-Time Statistics List Items

Used by actions: DescribeCrossBackupStatistical.

Name	Type	Description Status	Integer	Instance Status Region	String	Instance Region InstanceId	String	Instance ID Name	String	Instance Name CrossBackupEnabled	String	Cross-Region Backup Status: enable - Enabled, disable - Disabled CrossRegions	Array of String	Cross-Region Backup Target Region LastBackupStartTime	String	Latest Backup Start Time CrossBackupSaveDays	Integer	Cross-Region Backup Retention Days DataBackupSpace	Integer	Cross-Region Data Backup Total Space DataBackupCount	Integer	Cross-Region Data Backup Total File Count LogBackupSpace	Integer	Cross-Region Log Backup Total Space LogBackupCount	Integer	Cross-Region Log Backup Total File Count ActualUsedSpace	Integer	Cross-Region Backup Total Space ActualUsedCount	Integer	Cross-Region Backup Total Count

DBCreateInfo

Database creation information

Used by actions: CreateDB.

Name	Type	Required	Description DBName	String	Yes	Database name Charset	String	No	Character set, which can be queried by the DescribeDBCharsets API. Default value: Chinese_PRC_CI_AS.
Accounts	Array of AccountPrivilege	No	Database account permission information Remark	String	No	Remarks

DBDetail

Database information

Used by actions: DescribeDBs, DescribeDatabases.

Name	Type	Description Name	String	Database name Charset	String	Character set Remark	String	Remarks CreateTime	Timestamp	Database creation time Status	Integer	Database status. 1: creating, 2: running, 3: modifying, -1: dropping Accounts	Array of AccountPrivilege	Database account permission information InternalStatus	String	Internal status. ONLINE: running Encryption	String	TDE status. Valid values: enable (enabled), disable (disabled).

DBInstance

Instance details

Used by actions: DescribeDBInstances.

Name	Type	Description InstanceId	String	Instance ID Name	String	Instance name ProjectId	Integer	Project ID of instance RegionId	Integer	Instance region ID ZoneId	Integer	Instance AZ ID VpcId	Integer	Instance VPC ID, which will be 0 if the basic network is used SubnetId	Integer	Instance VPC subnet ID, which will be 0 if the basic network is used Status	Integer	Instance status. Valid values:
1: creating 2: running 3: instance operations restricted (due to the ongoing primary-replica switch) 4: isolated 5: repossessing 6: repossessed 7: running tasks (such as backup and rollback tasks) 8: eliminated 9: expanding capacity 10: migrating 11: read-only 12: restarting 13: modifying configuration and waiting for switch 14: implementing pub/sub 15: modifying pub/sub configuration 16: modifying configuration and switching 17: creating read-only instances

Vip	String	Instance access IP Vport	Integer	Instance access port CreateTime	Timestamp	Instance creation time UpdateTime	Timestamp	Instance update time StartTime	Timestamp	Instance billing start time EndTime	Timestamp	Instance billing end time IsolateTime	Timestamp	Instance isolation time Memory	Integer	Instance memory size in GB UsedStorage	Integer	Used storage capacity of instance in GB Storage	Integer	Instance storage capacity in GB VersionName	String	Instance version RenewFlag	Integer	Instance renewal flag Model	Integer	Instance disaster recovery type. 1: dual-server high availability; 2: single-node; 3: cross-AZ; 4: cross-AZ cluster; 5: cluster; 6: multi-node cluster; 7: multi-node cross-AZ cluster.
Region	String	Instance region name, such as ap-guangzhou Zone	String	Instance AZ name, such as ap-guangzhou-1 BackupTime	String	Backup time point PayMode	Integer	Instance billing mode. 0: pay-as-you-go Uid	String	Instance UID Cpu	Integer	Number of CPU cores of instance Version	String	Instance version code Type	String	Instance type. Valid values: TS85 (physical machine, local SSD), Z3 (early version of physical machine, local SSD), CLOUD_BASIC (virtual machine, HDD cloud disk), CLOUD_PREMIUM (virtual machine, premium cloud disk), CLOUD_SSD (virtual machine, SSD), CLOUD_HSSD (virtual machine, enhanced SSD), CLOUD_TSSD (virtual machine, ulTra SSD), CLOUD_BSSD virtual machine, balanced SSD).
Pid	Integer	Billing ID UniqVpcId	String	Unique string-type ID of instance VPC in the format of vpc-xxx, which is an empty string if the basic network is used UniqSubnetId	String	Unique string-type ID of instance subnet in the format of subnet-xxx, which is an empty string if the basic network is used IsolateOperator	String	Instance isolation operation.
SubFlag	String	Publishing/Subscription flag. SUB: subscription instance; PUB: publishing instance. If this parameter is left blank, the instance is an ordinary instance that does not involve publishing or subscription.
ROFlag	String	Read-only flag. RO: read-only instance; MASTER: primary instance bound to a read-only instance. If this parameter is left blank, the instance is not a read-only instance and is not in any read-only group.
HAFlag	String	Disaster recovery type. MIRROR: image; ALWAYSON: Always On; SINGLE: single instance.
ResourceTags	Array of ResourceTag	Note: This field may return null, indicating that no valid values can be obtained.
BackupModel	String	Backup mode. master_pkg: backup on the primary node (default value); master_no_pkg: no backup on the primary node; slave_pkg: backup on secondary nodes (valid for Always On clusters); slave_no_pkg: no backup on secondary nodes (valid for Always On clusters). This parameter is invalid for read-only instances.
InstanceNote	String	Instance backup information.
BackupCycle	Array of Integer	Backup cycle BackupCycleType	String	Backup cycle type. Valid values: daily, weekly, monthly.
BackupSaveDays	Integer	Data (log) backup retention period InstanceType	String	Instance type. HA: high-availability instance; RO: read-only instance; SI: basic edition instance; BI: business intelligence service instance; cvmHA: high-availability instance with cloud disk; cvmRO: read-only instance with cloud disk; MultiHA: multi-node instance; cvmMultiHA: multi-node instance with cloud disk.

CrossRegions	Array of String	The target region of cross-region backup. If this parameter left empty, it indicates that cross-region backup is disabled.
CrossBackupEnabled	String	Cross-region backup status. Valid values: enable (enabled), disable (disabed) CrossBackupSaveDays	Integer	The retention period of cross-region backup. Default value: 7 days DnsPodDomain	String	Domain name of the public network address TgwWanVPort	Integer	Port number of the public network Collation	String	Collation of system character sets. Default value: Chinese_PRC_CI_AS.
TimeZone	String	System time zone. Default value: China Standard Time.
IsDrZone	Boolean	Whether the instance is deployed across AZs SlaveZones	SlaveZones	Secondary AZ information on the two-node instance.
Architecture	String	Architecture flag. SINGLE: single-node; DOUBLE: two-node.
Style	String	Type flag. EXCLUSIVE: exclusive; SHARED: shared.
MultiSlaveZones	Array of SlaveZones	Multi-Node Instance Secondary AZ Information

DBPrivilege

Database permission information of account

Used by actions: CreateAccount, DescribeAccounts, DescribeDBPrivilegeByAccount.

Name	Type	Required	Description DBName	String	Yes	Database name Privilege	String	Yes	Database permissions. Valid values: ReadWrite (read-write), ReadOnly (read-only), DBOwner (owner)

DBPrivilegeModifyInfo

Database permission change information

Used by actions: ModifyAccountPrivilege.

Name	Type	Required	Description DBName	String	Yes	Database name Privilege	String	Yes	Permission modification information. Valid values: ReadWrite (read-write), ReadOnly (read-only), Delete (delete the account's permission to this database), DBOwner (owner).

DBRemark

Database remarks

Used by actions: ModifyDBRemark.

Name	Type	Required	Description Name	String	Yes	Database name Remark	String	Yes	Remarks

DBRenameRes

Database renaming response parameter

Used by actions: DescribeBackupMigration, DescribeDBRestoreTime, DescribeIncrementalMigration.

Name	Type	Description NewName	String	Name of the new database OldName	String	Name of the old database

DBTDEEncrypt

This example shows you how to enable or disable TDE of a database.

Used by actions: ModifyDBEncryptAttributes.

Name	Type	Required	Description DBName	String	No	Database Name Encryption	String	No	TDE status. Valid values: enable (enabled), disable (disabled).

DataBasePrivilegeModifyInfo

Database Account Permission Modification Information

Used by actions: ModifyDatabasePrivilege.

Name	Type	Required	Description DataBaseName	String	Yes	Database Name AccountPrivileges	Array of AccountPrivilege	Yes	Database Permission Modification Information

DatabaseTuple

This data structure represents two databases that have a publish-subscribe relationship.

Used by actions: CreatePublishSubscribe, DeletePublishSubscribe, ModifyPublishSubscribe.

Name	Type	Required	Description PublishDatabase	String	Yes	Publish Database Name SubscribeDatabase	String	Yes	Subscription Database Name

DatabaseTupleStatus

This data structure represents two databases with a publish-subscribe relationship, along with the status information of that relationship between them.

Used by actions: DescribePublishSubscribe.

Name	Type	Description PublishDatabase	String	Publish Database Name SubscribeDatabase	String	Subscription Database Name LastSyncTime	String	Latest Synchronization Time Status	String	Publish/Subscribe Status Between Databases: running, success, fail, unknow

DbNormalDetail

Database configurations

Used by actions: DescribeDBsNormal, DescribeDatabasesNormal.

Name	Type	Description IsSubscribed	String	Whether it is subscribed. Valid values: 0 (no), 1 (yes) CollationName	String	Database collation IsAutoCleanupOn	String	Whether the cleanup task is enabled to automatically remove old change tracking information when CT is enabled. Valid values: 0 (no), 1 (yes) IsBrokerEnabled	String	Whether SQL Server Service Broker is enabled. Valid values: 0 (no), 1 (yes) IsCdcEnabled	String	Whether CDC is enabled. Valid values: 0 (disabled), 1 (enabled) IsDbChainingOn	String	Whether CT is enabled. Valid values: 0 (disabled), 1 (enabled) IsEncrypted	String	Whether it is encrypted. Valid values: 0 (no), 1 (yes) IsMirroring	String	Whether it is a mirror database. Valid values: 0 (no), 1 (yes) IsPublished	String	Whether it is published. Valid values: 0 (no), 1 (yes) IsReadCommittedSnapshotOn	String	Whether snapshots are enabled. Valid values: 0 (no), 1 (yes) IsTrustworthyOn	String	Whether it is trustworthy. Valid values: 0 (no), 1 (yes) MirroringState	String	Mirroring state Name	String	Database name RecoveryModelDesc	String	Recovery model RetentionPeriod	String	Retention period (in days) of change tracking information StateDesc	String	Database status UserAccessDesc	String	User type CreateTime	String	Database creation time

DbRollbackTimeInfo

Information of time range available for database rollback

Used by actions: DescribeRollbackTime.

Name	Type	Description DBName	String	Database name StartTime	Timestamp	Start time of time range available for rollback EndTime	Timestamp	End time of time range available for rollback

DealInfo

Order information

Used by actions: DescribeOrders.

Name	Type	Description DealName	String	Order name Count	Integer	Number of items FlowId	Integer	ID of associated flow, which can be used to query the flow execution status InstanceIdSet	Array of String	This field is required only for an order that creates an instance, indicating the ID of the instance created by the order OwnerUin	String	Account InstanceChargeType	String	Instance billing type

DealInstance

List of the resource IDs corresponding to order number

Used by actions: DescribeInstanceByOrders.

Name	Type	Description InstanceId	Array of String	Instance ID DealName	String	Order ID

DrReadableInfo

Replica server read-only information

Used by actions: DescribeDBInstancesAttribute.

Name	Type	Description SlaveStatus	String	Replica server status. Valid values: enable - running; disable - unavailable Note: This field may return null, indicating that no valid values can be obtained.
ReadableStatus	String	Replica server readable status. Valid values: enable - enabled; disable - disabled Note: This field may return null, indicating that no valid values can be obtained.
Vip	String	Replica server read-only VIP Note: This field may return null, indicating that no valid values can be obtained.
VPort	Integer	Replica server read-only port Note: This field may return null, indicating that no valid values can be obtained.
UniqVpcId	String	Replica server VPC ID Note: This field may return null, indicating that no valid values can be obtained.
UniqSubnetId	String	Replica server VPC subnet ID Note: This field may return null, indicating that no valid values can be obtained.

DrZoneInfo

AZ information on the secondary node.

Used by actions: DescribeUpgradeInstanceCheck, UpgradeDBInstance.

Name	Type	Required	Description DrInstanceId	String	No	Resource ID of the secondary node.
Zone	String	No	AZ of the secondary node.

EventConfig

Threshold setting for an extended event

Used by actions: StartInstanceXEvent.

Name	Type	Required	Description EventType	String	Yes	Event type. Valid values: slow (set threshold for slow SQL ), blocked (set threshold for the blocking and deadlock).
Threshold	Integer	Yes	Threshold in milliseconds. Valid values: 0(disable), non-zero (enable)

Events

Details of an extended event

Used by actions: DescribeXEvents.

Name	Type	Description Id	Integer	ID FileName	String	File name of an extended event Size	Integer	File size of an extended event EventType	String	Event type. Valid values: slow (Slow SQL event), blocked (blocking event), deadlock (deadlock event).
Status	Integer	Event record status. Valid values: 1 (succeeded), 2 (failed).
StartTime	String	Generation start time of an extended file EndTime	String	Generation end time of an extended file InternalAddr	String	Download address on the private network ExternalAddr	String	Download address on the public network

FileAction

Information of allowed operation

Used by actions: DescribeBusinessIntelligenceFile.

Name	Type	Description AllAction	Array of String	Allowed operations. Valid values: view (view list), remark (modify remark), deploy (deploy files), delete (delete files).
AllowedAction	Array of String	Operation allowed in the current status. If the subset of AllAction is empty, no operations will be allowed.

InstanceDBDetail

Instance database information

Used by actions: DescribeDBs, DescribeDatabases.

Name	Type	Description InstanceId	String	Instance ID DBDetails	Array of DBDetail	Database information list

InstanceRenewInfo

Used by actions: ModifyDBInstanceRenewFlag.

Name	Type	Required	Description InstanceId	String	Yes RenewFlag	Integer	Yes

InstanceTask

Instance Asynchronous Task

Used by actions: DescribeInstanceTasks.

Name	Type	Description Id	Integer	Unique id Type	Integer	Job Type Status	Integer	Job Status Progress	Integer	Progress Percentage 0~100 StartTime	String	Start Time EndTime	String	End Time ErrorCode	Integer	Error Code Message	String	Error Message Description

InterInstance

Details of instances in the interwoking group

Used by actions: DescribeDBInstanceInter.

Name	Type	Description InstanceId	String	Instance ID InterVip	String	Instance interworking IP, which can be accessed after the instance is added to the interworking group.
InterPort	Integer	Instance interworking port, which can be accessed after the instance is added to the interworking group.
Status	Integer	Instance interworking status. Valid values: 1 (Enabling interworking IP), 2 (Enabled interworking IP), 3 (Adding to interworking group), 4 (Added to interworking group), 5 (Reclaiming interworking IP), 6(Reclaimed interworking IP), 7 (Removing from interworking group), 8 (Removed from interworking group).
Region	String	Instance region, such as ap-guangzhou.
Zone	String	Instance AZ name, such as ap-guangzhou-1.
Version	String	Instance version code VersionName	String	Instance version Name	String	Instance name Vip	String	Instance access IP Vport	Integer	Instance access port

InterInstanceFlow

Instance status after enabling or disabling the interworking group

Used by actions: CloseInterCommunication, OpenInterCommunication.

Name	Type	Description InstanceId	String	Instance ID, such as mssql-sdf32n1d.
FlowId	Integer	Instance task ID for enabling or disabling the interworking group. When FlowId is less than 0, the interworking group will be enabled or disabled successfully; otherwise, the operation failed.

MigrateDB

List of databases to be migrated

Used by actions: CreateMigration, DescribeMigrationDetail, ModifyMigration.

Name	Type	Required	Description DBName	String	No	Name of migrated database

MigrateDetail

Migration progress details

Used by actions: DescribeMigrations.

Name	Type	Description StepName	String	Name of current step Progress	Integer	Progress of current step in %

MigrateSource

Source type of migration task

Used by actions: CreateMigration, DescribeMigrationDetail, ModifyMigration.

Name	Type	Required	Description InstanceId	String	No	Source instance ID in the format of mssql-si2823jyl, which is used when MigrateType is 1 (TencentDB for SQL Server) CvmId	String	No	ID of source CVM instance, which is used when MigrateType is 2 (CVM-based self-created SQL Server database) VpcId	String	No	VPC ID of source CVM instance in the format of vpc-6ys9ont9, which is used when MigrateType is 2 (CVM-based self-created SQL Server database) SubnetId	String	No	VPC subnet ID of source CVM instance in the format of subnet-h9extioi, which is used when MigrateType is 2 (CVM-based self-created SQL Server database) UserName	String	No	Username, which is used when MigrateType is 1 or 2 Password	String	No	Password, which is used when MigrateType is 1 or 2 Ip	String	No	Private IP of source CVM database, which is used when MigrateType is 2 (CVM-based self-created SQL Server database) Port	Integer	No	Port number of source CVM database, which is used when MigrateType is 2 (CVM-based self-created SQL Server database) Url	Array of String	No	Source backup address for offline migration, which is used when MigrateType is 4 or 5 UrlPassword	String	No	Source backup password for offline migration, which is used when MigrateType is 4 or 5

MigrateTarget

Target type of migration task

Used by actions: CreateMigration, DescribeMigrationDetail, ModifyMigration.

Name	Type	Required	Description InstanceId	String	No	ID of target instance in the format of mssql-si2823jyl UserName	String	No	Username of migration target instance Password	String	No	Password of migration target instance

MigrateTask

Migration task type

Used by actions: DescribeMigrations.

Name	Type	Description MigrateId	Integer	Migration task ID MigrateName	String	Migration task name AppId	Integer	User ID of migration task Region	String	Migration task region SourceType	Integer	Migration source type. 1: TencentDB for SQL Server, 2: CVM-based self-created SQL Server database; 3: SQL Server backup restoration, 4: SQL Server backup restoration (in COS mode) CreateTime	Timestamp	Migration task creation time StartTime	Timestamp	Migration task start time EndTime	Timestamp	Migration task end time Status	Integer	Migration task status (1: initializing, 4: migrating, 5: migration failed, 6: migration succeeded, 7: suspended, 8: deleted, 9: suspending, 10: completing, 11: suspension failed, 12: completion failed) Message	String	Information CheckFlag	Integer	Whether migration task has been checked (0: not checked, 1: check succeeded, 2: check failed, 3: checking) Progress	Integer	Migration task progress in % MigrateDetail	MigrateDetail	Migration task progress details

Migration

Cold backup migration import

Used by actions: DescribeBackupMigration, DescribeIncrementalMigration.

Name	Type	Description MigrationId	String	Backup import task ID or incremental import task ID MigrationName	String	Backup import task name. For an incremental import task, this field will be left empty.
Note: this field may return ‘null’, indicating that no valid values can be obtained.
AppId	Integer	Application ID Region	String	Region InstanceId	String	ID of migrated target instance RecoveryType	String	Migration task restoration type UploadType	String	Backup user upload type. COS_URL: the backup is stored in user’s Cloud Object Storage, with URL provided. COS_UPLOAD: the backup is stored in the application’s Cloud Object Storage and needs to be uploaded by the user.
BackupFiles	Array of String	Backup file list, which is determined by UploadType. If the upload type is COS_URL, URL will be saved. If the upload type is COS_UPLOAD, the backup name will be saved.
Status	Integer	Migration task status. Valid values: 2 (Creation completed), 7 (Importing full backups), 8 (Waiting for incremental backups), 9 (Import success), 10 (Import failure), 12 (Importing incremental backups).
CreateTime	String	Migration task creation time StartTime	String	Migration task start time EndTime	String	Migration task end time Message	String	More information Detail	MigrationDetail	Migration detail Action	MigrationAction	Operation allowed in the current status IsRecovery	String	Whether this is the final restoration. For a full import task, this field will be left empty.
Note: this field may return ‘null’, indicating that no valid values can be obtained.
DBRename	Array of DBRenameRes	Name set of renamed databases Note: This field may return null, indicating that no valid values can be obtained.

MigrationAction

Operation allowed by a cold backup import task

Used by actions: DescribeBackupMigration, DescribeIncrementalMigration.

Name	Type	Description AllAction	Array of String	All the allowed operations. Values include: view (viewing a task), modify (modifying a task), start (starting a task), incremental (creating an incremental task), delete (deleting a task), and upload (obtaining the upload permission).
AllowedAction	Array of String	Operation allowed in the current status. If the subset of AllAction is left empty, no operations will be allowed.

MigrationDetail

Details of a cold backup import task

Used by actions: DescribeBackupMigration, DescribeIncrementalMigration.

Name	Type	Description StepAll	Integer	Total number of steps StepNow	Integer	Current step Progress	Integer	Overall progress. For example, “30” means 30%.
StepInfo	Array of MigrationStep	Step information. ‘null’ means the migration has not started Note: this field may return ‘null’, indicating that no valid values can be obtained.

MigrationStep

Migration steps of a cold backup import task

Used by actions: DescribeBackupMigration, DescribeIncrementalMigration.

Name	Type	Description StepNo	Integer	Step sequence StepName	String	Step name StepId	String	Step ID in English Status	Integer	Step status: 0 (default value), 1 (succeeded), 2 (failed), 3 (in progress), 4 (not started)

ModifyDataBaseTuple

Database Subscription Publication Relationship Collection to be Modified

Used by actions: ModifyPublishSubscribe.

Name	Type	Required	Description DatabaseTuple	DatabaseTuple	Yes	Subscription Relationship to be Modified NewDatabaseTuple	DatabaseTuple	No	Modified subscription relationship. Takes effect when DeleteDataBasesTuple is false DeleteDataBasesTuple	Boolean	No	Whether to delete the subscription relationship. When this option is true, NewDatabaseTuple is invalid

OldVip

This API is used to return the number of unrecovered IP addresses for the instance.

Used by actions: DescribeDBInstancesAttribute.

Name	Type	Description Vip	String	Unrecovered old IP addresses RecycleTime	String	IP recovery time OldIpRetainTime	Integer	Old IP retention time (hours) Note: This field may return null, indicating that no valid values can be obtained.

ParamRecord

Instance parameter modification record

Used by actions: DescribeInstanceParamRecords.

Name	Type	Description InstanceId	String	Instance ID ParamName	String	Parameter name OldValue	String	Parameter value before modification NewValue	String	Parameter value after modification Status	Integer	Parameter modification status. Valid values: 1 (initializing and waiting for modification), 2 (modification succeed), 3 (modification failed), 4 (modifying) ModifyTime	String	Modification time

Parameter

Database instance parameter

Used by actions: ModifyInstanceParam.

Name	Type	Required	Description Name	String	No	Parameter name CurrentValue	String	No	Parameter value

ParameterDetail

Instance parameter details

Used by actions: DescribeInstanceParams.

Name	Type	Description Name	String	Parameter name ParamType	String	Data type of the parameter. Valid values: integer, enum Default	String	Default value of the parameter Description	String	Parameter description CurrentValue	String	Current value of the parameter NeedReboot	Integer	Whether the database needs to be restarted for the modified parameter to take effect. Valid values: 0 (no),1 (yes) Max	Integer	Maximum value of the parameter Min	Integer	Minimum value of the parameter EnumValue	Array of String	Enumerated values of the parameter Status	Integer	Parameter status. Valid values: 0 (normal), 1 (modifying)

Price

Reference price. This price covers CPU and memory specifications, excluding disk usage. The actual price is subject to the quotation API.

Used by actions: DescribeSpecSellStatus.

Name	Type	Description PrepaidPrice	Integer	Reference price for yearly/monthly subscription, unit-cent PrepaidPriceUnit	String	Price unit for yearly/monthly subscription, M-month PostpaidPrice	Integer	Pay-as-you-go price, unit-cent PostpaidPriceUnit	String	Pay-as-you-go price unit, H-hour

PublishSubscribe

Pub/Sub Object

Used by actions: DescribePublishSubscribe.

Name	Type	Description Id	Integer	Pub/Sub ID Name	String	Pub/Sub Name PublishInstanceId	String	Published Instance ID PublishInstanceName	String	Published Instance Name PublishInstanceIp	String	Published Instance IP SubscribeInstanceId	String	Subscription Instance ID SubscribeInstanceName	String	Subscription Instance Name SubscribeInstanceIp	String	Subscription Instance IP DatabaseTupleSet	Array of DatabaseTupleStatus	Publication-Subscription Relationship Collection of Database

ReadOnlyGroup

Read-Only Group Object

Used by actions: DescribeReadOnlyGroupList.

Name	Type	Description ReadOnlyGroupId	String	Read-Only Group ID ReadOnlyGroupName	String	Read-Only Group Name RegionId	String	Region ID of the Read-Only Group, same as the Primary Instance ZoneId	String	Read-Only Group's AZ ID, same as the Primary Instance IsOfflineDelay	Integer	Whether to enable the timeout culling feature; 0 - disabled, 1 - enabled ReadOnlyMaxDelayTime	Integer	Timeout threshold used after enabling the timeout culling feature MinReadOnlyInGroup	Integer	Minimum number of read-only replicas retained in the read-only group after enabling the timeout culling feature Vip	String	Read-Only Group vip Vport	Integer	Read-Only Group vport VpcId	String	Read-Only Group VPC ID SubnetId	String	Read-Only Group VPC Subnet ID Status	Integer	Read-Only Group Status: 1-Running, 5-Creating MasterInstanceId	String	Primary instance ID, in the form of mssql-sgeshe3th ReadOnlyInstanceSet	Array of ReadOnlyInstance	Read-Only Instance Replica Set DnsPodDomain	String	RO group's public network address domain name TgwWanVPort	Integer	RO group's public network address port

ReadOnlyInstance

Read-Only Replica Instance

Used by actions: DescribeReadOnlyGroupAutoWeight, DescribeReadOnlyGroupDetails, DescribeReadOnlyGroupList.

Name	Type	Description InstanceId	String	Read-Only Replica ID, in the format of: mssqlro-3l3fgqn7 Name	String	Read-Only Replica Name Uid	String	Read-Only Replica Unique UID ProjectId	Integer	Read-Only Replica Project ID Status	Integer	Read-Only Replica Status: 1: Creating, 2: Running, 3: Delayed Removal, 4: Isolated, 5: Recycling, 6: Recycled, 7: Task Executing, 8: Offline, 9: Instance Scaling, 10: Instance Migrating, 12: Restarting CreateTime	String	Read-Only Replica Creation Time UpdateTime	String	Read-Only Replica Update Time Memory	Integer	Read-Only Replica Memory Size (Unit: GB) Storage	Integer	Read-Only Replica Storage Space Size (Unit: GB) Cpu	Integer	Read-Only Replica cpu Core Count Version	String	Read-Only Replica Codenames Type	String	Host Machine Code Model	Integer	Read-Only Replica Mode, 2-Standalone PayMode	Integer	Read-Only Replica Billing Mode, 1-yearly/monthly subscription, 0-pay-as-you-go Weight	Integer	Read-Only Replica Weight DelayTime	String	Read-Only Replica Latency Time (Unit: seconds) SynStatus	String	Synchronization status between the read-only replica and the primary instance.

Init: Initializing

DeployReadOnlyInPorgress: Deploying replica in progress

DeployReadOnlySuccess: Replica deployment succeeded

DeployReadOnlyFail: Replica deployment failed

DeployMasterDBInPorgress: Adding replica database to primary node in progress

DeployMasterDBSuccess: Successfully added replica database to primary node

DeployMasterDBFail: Failed to add replica database to primary node

DeployReadOnlyDBInPorgress: Replica restoration and database joining started

DeployReadOnlyDBSuccess: Replica restoration and database joining succeeded

DeployReadOnlyDBFail: Replica restoration and database joining failed

SyncDelay: Synchronization delayed

SyncFail: Synchronization failed

SyncExcluded: Removed from read-only group

SyncNormal: Normal DatabaseDifference	String	Databases not synchronized between the read-only replica and the primary instance AccountDifference	String	Accounts not synchronized between the read-only replica and the primary instance StartTime	String	Read-Only Replica Billing Start Time EndTime	String	Read-Only Replica Billing End Time IsolateTime	String	Read-Only Replica Isolation Time RegionId	String	Read-Only Replica Region Location ZoneId	String	Read-Only Replica AZ Location

ReadOnlyInstanceWeightPair

Read-Only Instance to Weight Mapping

Used by actions: ModifyReadOnlyGroupDetails.

Name	Type	Required	Description ReadOnlyInstanceId	String	Yes	Read-Only Instance ID, in the format of: mssqlro-3l3fgqn7 ReadOnlyWeight	Integer	Yes	Read-Only Instance Weight, in the range of 0-100

RegionInfo

Region information

Used by actions: DescribeRegions.

Name	Type	Description Region	String	Region ID in the format of ap-guangzhou RegionName	String	Region name RegionId	Integer	Numeric ID of region RegionState	String	Current purchasability of this region. UNAVAILABLE: not purchasable, AVAILABLE: purchasable

RenameRestoreDatabase

It is used to specify and rename the database to be restored through the RestoreInstance, RollbackInstance, CreateMigration, CloneDB or ModifyBackupMigration APIs.

Used by actions: CloneDB, CreateMigration, ModifyBackupMigration, RestoreInstance, RollbackInstance.

Name	Type	Required	Description OldName	String	No	Database name. If the OldName database does not exist, a failure will be returned.
It can be left empty in offline migration tasks.
NewName	String	No	New database name. In offline migration, OldName will be used if NewName is left empty (OldName and NewName cannot be both empty). In database cloning, OldName and NewName must be both specified and cannot have the same value.

ResourceTag

The information of tags associated with instances

Used by actions: CreateBasicDBInstances, CreateBusinessDBInstances, CreateCloudDBInstances, CreateCloudReadOnlyDBInstances, CreateDBInstances, CreateReadOnlyDBInstances, DescribeDBInstances, DescribeInstanceTradeParameter.

Name	Type	Required	Description TagKey	String	No	Tag key TagValue	String	No	Tag value

RestoreTask

Rollback Task Record

Used by actions: DescribeRestoreTask.

Name	Type	Description TargetInstanceId	String	Target Instance ID TargetInstanceName	String	Target Instance Name TargetInstanceStatus	Integer	Target Instance Status. Valid values:
1: Creating 2: Running 3: Restricted Running (primary/secondary switching) 4: Isolated 5: Recycling 6: Recycled 7: Task Executing (instance backup, rollback, etc.) 8: Offline 9: Instance Scaling 10: Instance Migrating 11: Read-Only 12: Restarting TargetRegion	String	Target Instance Region RestoreId	Integer	Rollback Record ID TargetType	Integer	Restoration target instance type: 0 - current instance, 1 - existing instance, 2 - new instance RestoreType	Integer	Rollback method: 0 - by point-in-time, 1 - by backup set RestoreTime	String	Rollback Target Time StartTime	String	Start Time EndTime	String	End Time Status	Integer	Rollback status: 0 - Initialization, 1 - Running, 2 - Success, 3 - Failure FlowId	Integer	Rollback Asynchronous Task ID

SSLConfig

SSL Encryption Configuration

Used by actions: DescribeDBInstancesAttribute.

Name	Type	Description Encryption	String	SSL Encryption Status enable - Enabled disable - Disabled enable_doing - Enabling disable_doing - Disabling renew_doing - Updating wait_doing - Waiting to be executed during maintenance window SSLValidityPeriod	String	SSL Certificates Validity Period, Time Format YYYY-MM-DD HH:MM:SS SSLValidity	Integer	SSL Certificates Validity: 0 - Invalid, 1 - Valid

SecurityGroup

Security Group

Used by actions: DescribeDBSecurityGroups, DescribeProjectSecurityGroups.

Name	Type	Description ProjectId	Integer	Project ID CreateTime	String	Creation Time, Time format: yyyy-mm-dd hh:mm:ss InboundSet	Array of SecurityGroupPolicy	Inbound Rules OutboundSet	Array of SecurityGroupPolicy	Outbound Rules SecurityGroupId	String	Security Group ID SecurityGroupName	String	Security Group Name SecurityGroupRemark	String	Security Group Remarks

SecurityGroupPolicy

Security Group Policy

Used by actions: DescribeDBSecurityGroups, DescribeProjectSecurityGroups.

Name	Type	Description Action	String	Policy, ACCEPT or DROP CidrIp	String	Destination IP or IP range, for example 172.16.0.0/12 PortRange	String	port or port range IpProtocol	String	Network protocol supports UDP, TCP, etc.
Dir	String	Rule direction, OUTPUT - Outbound Rules, INPUT - Inbound Rules

SlaveZones

Replica AZ information

Used by actions: DescribeDBInstances.

Name	Type	Description SlaveZone	String	Replica AZ region code SlaveZoneName	String	Replica AZ

SlowLog

Slow query log file information

Used by actions: DescribeSlowlogs.

Name	Type	Description Id	Integer	Unique ID of slow query log file StartTime	Timestamp	File generation start time EndTime	Timestamp	File generation end time Size	Integer	File size in KB Count	Integer	Number of logs in file InternalAddr	String	Download address for private network ExternalAddr	String	Download address for public network Status	Integer	Status (1: success, 2: failure) Note: this field may return null, indicating that no valid values can be obtained.

SpecInfo

Information of purchasable specification for an instance

Used by actions: DescribeProductConfig.

Name	Type	Description SpecId	Integer	Instance specification ID. The SpecId returned by DescribeZones together with the purchasable specification information returned by DescribeProductConfig can be used to find out what specifications can be purchased in a specified AZ MachineType	String	Model ID MachineTypeName	String	Model name Version	String	Database version information. Valid values: 2008R2 (SQL Server 2008 Enterprise), 2012SP3 (SQL Server 2012 Enterprise), 2016SP1 (SQL Server 2016 Enterprise), 201602 (SQL Server 2016 Standard), 2017 (SQL Server 2017 Enterprise) VersionName	String	Version name corresponding to the Version field Memory	Integer	Memory size in GB CPU	Integer	Number of CPU cores MinStorage	Integer	Minimum disk size under this specification in GB MaxStorage	Integer	Maximum disk size under this specification in GB QPS	Integer	QPS of this specification SuitInfo	String	Description of this specification Pid	Integer	Pid of this specification PostPid	Array of Integer	Pay-as-you-go Pid list corresponding to this specification Note: this field may return null, indicating that no valid values can be obtained.
PayModeStatus	String	Billing mode under this specification. POST: pay-as-you-go InstanceType	String	Instance type. Valid values: HA (High-Availability Edition, including dual-server high availability and AlwaysOn cluster), RO (read-only replica), SI (Basic Edition) MultiZonesStatus	String	Whether multi-AZ deployment is supported. Valid values: MultiZones (only multi-AZ deployment is supported), SameZones (only single-AZ deployment is supported), ALL (both deployments are supported)

SpecSellStatus

Offering Configuration Status

Used by actions: DescribeSpecSellStatus.

Name	Type	Description Id	String	Sellable Specification Unique ID SpecId	Integer	Instance Type ID PayModeStatus	String	Supported payment modes for this specification: POST - only supports pay-as-you-go, PRE - only supports yearly/monthly subscription, ALL - supports all.
InstanceType	String	Product type. Types of instances for purchase: HA - Local Disk High Availability (including dual-node high availability, alwaysOn cluster), RO - Local Disk Read-Only Replica, SI - Cloud Disk Edition Single Node, BI - Business Intelligence Service, cvmHA - Cloud Disk Edition High Availability, cvmRO - Cloud Disk Edition Read-Only Replica, MultiHA - Multi-node, cvmMultiHA - Cloud Disk Multi-node.
MultiZonesStatus	String	Whether this specification supports cross-AZ deployment: MultiZones - only supports cross-AZ, SameZones - only supports same-AZ, ALL - supports all.
Architecture	String	Architecture Type, SINGLE - single node, DOUBLE - dual node, TRIPLE - three-node, MULTI - multi-node Example value: SINGLE Style	String	Type identifier, EXCLUSIVE - Dedicated, SHARED - Shared Version	String	Database Version Information ZoneStatusSet	Array of ZoneStatus	Sellable Status Set Per AZ Price	Price	Reference price for specifications. The actual price is subject to the quotation API.
Status	Integer	Specification Sale Status: 1 - Normal, 2 - Sale disabled but upgradable, 3 - Sale completely disabled.

StepDetail

Progress Steps Details

Used by actions: QueryMigrationCheckProcess.

Name	Type	Description Msg	String	Detailed Steps Return Information Status	Integer	Current Step Status, 0 Success, -2 Not Started Name	String	Step Name

SummaryDetailRes

Backup Overview Real-Time Statistics

Used by actions: DescribeBackupStatistical.

Name	Type	Description RegionId	Integer	Region Identifier Status	Integer	Instance Status. Valid values:
1: Creating 2: Running 3: Restricted Running (primary/secondary switching) 4: Isolated 5: Recycling 6: Recycled 7: Task Executing (performing instance backup, rollback, etc.) 8: Offline 9: Instance Scaling 10: Instance Migrating InstanceId	String	Instance ID Name	String	Instance Name ActualUsedSpace	Integer	Backup Space DataBackupSpace	Integer	Data Backup Space DataBackupCount	Integer	Data Backup Total File Count LogBackupSpace	Integer	Log Backup Space LogBackupCount	Integer	Log Backup Total File Count AutoBackupSpace	Integer	Automatic Backup Space AutoBackupCount	Integer	Automatic Backup Total File Count ManualBackupSpace	Integer	Manual Backup Space ManualBackupCount	Integer	Manual Backup Total File Count Region	String	Instance Region Code

SwitchLog

Primary/Secondary Switchover Log

Used by actions: DescribeHASwitchLog.

Name	Type	Description EventId	String	Switchover Event ID SwitchType	Integer	Switchover Mode 0-System Automatic Switchover, 1-Manual Switchover StartTime	String	Switchover Start Time EndTime	String	Switchover End Time Reason	String	Machine failure causes automatic switchover.

TDEConfigAttribute

TDE configuration

Used by actions: DescribeDBInstancesAttribute.

Name	Type	Description Encryption	String	TDE status. Valid values: enable (enabled), disable (disabled).
CertificateAttribution	String	Certificate ownership. Valid values: self (certificate of the this account), others (certificate of the other account), none (no certificate).
QuoteUin	String	Note: This field may return null, indicating that no valid values can be obtained.

ZoneInfo

AZ information

Used by actions: DescribeZones.

Name	Type	Description Zone	String	AZ ID in the format of ap-guangzhou-1 (i.e., Guangzhou Zone 1) ZoneName	String	AZ name ZoneId	Integer	Numeric ID of AZ SpecId	Integer	ID of specification purchasable in this AZ, which, together with the returned value of the DescribeProductConfig API, can be used to find out the specifications currently purchasable in the AZ Version	String	Information of database versions purchasable under the current AZ and specification. Valid values: 2008R2 (SQL Server 2008 Enterprise), 2012SP3 (SQL Server 2012 Enterprise), 2016SP1 (SQL Server 2016 Enterprise), 201602 (SQL Server 2016 Standard), 2017 (SQL Server 2017 Enterprise)

ZoneStatus

Specification Sellable Status in a Specific Region's AZ

Used by actions: DescribeSpecSellStatus.

Name	Type	Description Zone	String	Specification AZ Region	String	Specification Region Status	Integer	Specification Sale Status in the AZ: 1 - Normal, 2 - Sale disabled but upgradable, 3 - Sale completely disabled.
Previous Topic: QueryMigrationCheckProcess Next Topic: Error Codes Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page AccountCreateInfo AccountDetail AccountPassword AccountPrivilege AccountPrivilegeModifyInfo AccountRemark Backup BackupFile BusinessIntelligenceFile CheckItem CosUploadBackupFile CrossBackupAddr CrossRegionStatus CrossSummaryDetailRes DBCreateInfo DBDetail DBInstance DBPrivilege DBPrivilegeModifyInfo DBRemark DBRenameRes DBTDEEncrypt DataBasePrivilegeModifyInfo DatabaseTuple DatabaseTupleStatus DbNormalDetail DbRollbackTimeInfo DealInfo DealInstance DrReadableInfo DrZoneInfo EventConfig Events FileAction InstanceDBDetail InstanceRenewInfo InstanceTask InterInstance InterInstanceFlow MigrateDB MigrateDetail MigrateSource MigrateTarget MigrateTask Migration MigrationAction MigrationDetail MigrationStep ModifyDataBaseTuple OldVip ParamRecord Parameter ParameterDetail Price PublishSubscribe ReadOnlyGroup ReadOnlyInstance ReadOnlyInstanceWeightPair RegionInfo RenameRestoreDatabase ResourceTag RestoreTask SSLConfig SecurityGroup SecurityGroupPolicy SlaveZones SlowLog SpecInfo SpecSellStatus StepDetail SummaryDetailRes SwitchLog TDEConfigAttribute ZoneInfo ZoneStatus Search AllCurrent Product Search titles only Enter keywords to search documentation
