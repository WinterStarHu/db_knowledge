# History

> 来源: https://www.tencentcloud.com/document/product/238/32092

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation History History Download Focus Mode Font Size Last updated: 2026-06-30 11:29:24

Release 55

Release time: 2026-06-30 11:28:18

Release updates:

Improvement to existing documentation.

New APIs:

DeleteRestoreTask DescribeUploadIncrementalInfo InquiryPriceRenewDBInstance ModifyDBInstanceRenewFlag RenewDBInstance StartMigrationCheck StopMigration

New data structures:

InstanceRenewInfo

Release 54

Release time: 2026-03-31 18:13:32

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateCloudDBInstances New input parameters:MultiNodes, DrZones, DiskEncryptFlag

Release 53

Release time: 2025-09-11 16:40:03

Release updates:

Improvement to existing documentation.

New APIs:

QueryMigrationCheckProcess

New data structures:

StepDetail

Release 52

Release time: 2025-08-29 10:10:06

Release updates:

Improvement to existing documentation.

New APIs:

CompleteMigration DescribeMigrationDatabases

Release 51

Release time: 2025-08-28 16:44:13

Release updates:

Improvement to existing documentation.

Modified data structures:

AccountCreateInfo New members:EncryptedVersion

Release 50

Release time: 2025-08-28 14:57:03

Release updates:

Improvement to existing documentation.

New APIs:

DescribeCrossBackupStatistical DescribeCrossRegions DescribeDBRestoreTime DescribeRestoreTask ModifyCrossBackupStrategy

New data structures:

CrossSummaryDetailRes RestoreTask

Release 49

Release time: 2025-08-28 14:55:33

Release updates:

Improvement to existing documentation.

New APIs:

DescribeBackupByFlowId DescribeBackupMonitor DescribeBackupStatistical DescribeBackupSummary RemoveBackups

New data structures:

SummaryDetailRes

Release 48

Release time: 2025-08-28 14:53:59

Release updates:

Improvement to existing documentation.

New APIs:

DeletePublishSubscribe DescribePublishSubscribe DescribeRegularBackupPlan ModifyBackupName ModifyPublishSubscribe

New data structures:

DatabaseTupleStatus ModifyDataBaseTuple PublishSubscribe

Release 47

Release time: 2025-08-28 14:52:52

Release updates:

Improvement to existing documentation.

New APIs:

BalanceReadOnlyGroup CreatePublishSubscribe DescribeReadOnlyGroupAutoWeight ModifyPublishSubscribeName RecycleReadOnlyGroup

New data structures:

DatabaseTuple

Release 46

Release time: 2025-08-28 14:49:44

Release updates:

Improvement to existing documentation.

New APIs:

DescribeHASwitchLog DescribeReadOnlyGroupByReadOnlyInstance DescribeReadOnlyGroupDetails DescribeReadOnlyGroupList ModifyReadOnlyGroupDetails

New data structures:

ReadOnlyGroup ReadOnlyInstance ReadOnlyInstanceWeightPair SwitchLog

Release 45

Release time: 2025-08-28 14:48:38

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBSecurityGroups DescribeDatabasesNormal DisassociateSecurityGroups ModifyDBInstanceSSL ModifyDatabaseShrinkMDF

Release 44

Release time: 2025-08-28 14:47:15

Release updates:

Improvement to existing documentation.

New APIs:

DescribeAccountPrivilegeByDB DescribeDBPrivilegeByAccount DescribeDatabaseNames ModifyCloseWanIp ModifyDatabasePrivilege

New data structures:

DataBasePrivilegeModifyInfo

Release 43

Release time: 2025-08-28 14:43:55

Release updates:

Improvement to existing documentation.

New APIs:

DeleteDBInstance ModifyMaintenanceSpan ModifyOpenWanIp RenewPostpaidDBInstance SwitchCloudInstanceHA

Release 42

Release time: 2025-08-28 14:38:16

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeBackupFiles New input parameters:OrderByType DescribeBackups New input parameters:StorageStrategy

Modified data structures:

AccountRemark Modified members: UserName, Remark

Release 41

Release time: 2025-08-28 10:32:17

Release updates:

Improvement to existing documentation.

New APIs:

AssociateSecurityGroups DescribeProjectSecurityGroups ModifyDBInstanceSecurityGroups

New data structures:

SecurityGroup SecurityGroupPolicy

Release 40

Release time: 2025-08-27 18:05:14

Release updates:

Improvement to existing documentation.

New APIs:

CompleteExpansion CutXEvents DescribeUpgradeInstanceCheck ModifyDBInstanceNote

New data structures:

CheckItem

Release 39

Release time: 2025-08-27 18:04:05

Release updates:

Improvement to existing documentation.

New APIs:

DescribeInstanceTasks

New data structures:

InstanceTask

Release 38

Release time: 2025-08-27 18:01:57

Release updates:

Improvement to existing documentation.

New APIs:

DescribeCrossRegionZone

Release 37

Release time: 2025-08-27 17:50:19

Release updates:

Improvement to existing documentation.

New APIs:

DescribeInstanceTradeParameter

Release 36

Release time: 2025-08-27 17:48:32

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDatabases

Modified data structures:

DBDetail Modified members: Encryption

Release 35

Release time: 2025-08-21 19:45:10

Release updates:

Improvement to existing documentation.

Modified APIs:

ModifyDBInstanceNetwork New input parameters:DrInstanceId

Release 34

Release time: 2025-08-21 19:43:42

Release updates:

Improvement to existing documentation.

Modified APIs:

UpgradeDBInstance New input parameters:DrZones

New data structures:

DrZoneInfo

Release 33

Release time: 2025-08-21 19:42:18

Release updates:

Improvement to existing documentation.

New APIs:

DescribeCollationTimeZone

Release 32

Release time: 2025-08-21 19:40:08

Release updates:

Improvement to existing documentation.

New APIs:

DescribeSpecSellStatus

New data structures:

Price SpecSellStatus ZoneStatus

Release 31

Release time: 2025-08-21 19:38:34

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateBasicDBInstances New input parameters:DiskEncryptFlag

Release 30

Release time: 2025-08-07 19:08:06

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateCloudReadOnlyDBInstances New input parameters:DiskEncryptFlag

Release 29

Release time: 2025-08-04 21:30:19

Release updates:

Improvement to existing documentation.

Modified data structures:

DBInstance New members:MultiSlaveZones

Release 28

Release time: 2025-06-27 11:34:28

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstances New input parameters:MultiNodes, DrZones

Release 27

Release time: 2025-04-17 17:02:15

Release updates:

Improvement to existing documentation.

New APIs:

DescribeMaintenanceSpan

Release 26

Release time: 2024-11-26 16:30:50

Release updates:

Improvement to existing documentation.

New APIs:

CreateBasicDBInstances CreateReadOnlyDBInstances DescribeRestoreTimeRange ModifyDReadable

Modified APIs:

DescribeDBInstances New input parameters:PaginationType DescribeUploadBackupInfo New output parameters:CosSecurityToken Deprecate output parameters: XCosSecurityToken ModifyBackupStrategy New output parameters:Code Deprecate output parameters: Errno ModifyDBInstanceNetwork New input parameters:DRNetwork RollbackInstance Modified input parameters: DBs

Modified data structures:

AccountCreateInfo New members:IsCam Modified members: Password AccountDetail New members:IsCam DbNormalDetail Modified members: CreateTime Deprecate members: IsFulltextEnabled ResourceTag Modified members: TagKey, TagValue

Release 25

Release time: 2024-11-06 16:39:49

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeSlowlogs New output parameters:SlowLogs Deprecate output parameters: Slowlogs

New data structures:

SlowLog

Release 24

Release time: 2024-07-08 20:30:52

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeDBInstancesAttribute New output parameters:SSLConfig, DrReadableInfo, OldVipList

New data structures:

DrReadableInfo OldVip SSLConfig

Release 23

Release time: 2023-09-18 11:37:43

Release updates:

Improvement to existing documentation.

New APIs:

DescribeInstanceByOrders ModifyDBEncryptAttributes ModifyInstanceEncryptAttributes

Modified APIs:

CreateBackup New input parameters:StorageStrategy DescribeDBInstancesAttribute New output parameters:TDEConfig DescribeDBs New input parameters:Encryption

New data structures:

DBTDEEncrypt DealInstance TDEConfigAttribute

Modified data structures:

DBDetail New members:Encryption DBInstance Modified members: Architecture, Style

Release 22

Release time: 2023-06-27 09:46:53

Release updates:

Improvement to existing documentation.

New APIs:

CreateCloudDBInstances CreateCloudReadOnlyDBInstances

Modified APIs:

CreateBusinessDBInstances New output parameters:FlowId, InstanceIdSet

Release 21

Release time: 2023-05-04 10:20:10

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBInstancesAttribute DescribeXEvents StartInstanceXEvent

Modified APIs:

RestoreInstance New input parameters:Type, DBList

New data structures:

EventConfig Events

Modified data structures:

DBInstance New members:Architecture, Style

Release 20

Release time: 2023-03-01 16:52:44

Release updates:

Improvement to existing documentation.

Modified APIs:

ModifyBackupMigration New input parameters:DBRename

New data structures:

DBRenameRes

Modified data structures:

AccountCreateInfo New members:AccountType AccountDetail New members:AccountType AccountPrivilege New members:AccountType AccountPrivilegeModifyInfo New members:AccountType DbNormalDetail New members:CreateTime Migration New members:DBRename

Release 19

Release time: 2022-12-22 16:19:50

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeAccounts New input parameters:Name, OrderBy, OrderByType DescribeDBs New input parameters:Name, OrderByType

New data structures:

SlaveZones

Modified data structures:

DBInstance New members:IsDrZone, SlaveZones

Release 18

Release time: 2022-11-29 17:24:03

Release updates:

Improvement to existing documentation.

Modified APIs:

ModifyBackupStrategy New input parameters:RegularBackupEnable, RegularBackupSaveDays, RegularBackupStrategy, RegularBackupCounts, RegularBackupStartTime

Release 17

Release time: 2022-10-08 10:28:01

Release updates:

Improvement to existing documentation.

New APIs:

CloseInterCommunication CreateBusinessDBInstances CreateBusinessIntelligenceFile DeleteBusinessIntelligenceFile DescribeBusinessIntelligenceFile DescribeDBInstanceInter OpenInterCommunication

New data structures:

BusinessIntelligenceFile FileAction InterInstance InterInstanceFlow

Release 16

Release time: 2022-08-26 11:04:09

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstances New input parameters:Collation, TimeZone

Release 15

Release time: 2022-08-16 16:30:47

Release updates:

Improvement to existing documentation.

Modified data structures:

DBInstance New members:Collation, TimeZone

Release 14

Release time: 2022-08-01 17:03:46

Release updates:

Improvement to existing documentation.

New data structures:

CrossBackupAddr CrossRegionStatus

Modified data structures:

Backup New members:Region, CrossBackupAddr, CrossBackupStatus BackupFile New members:Region, CrossBackupAddr DBInstance New members:CrossRegions, CrossBackupEnabled, CrossBackupSaveDays, DnsPodDomain, TgwWanVPort

Release 13

Release time: 2022-06-06 15:24:21

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeBackupFiles New input parameters:OrderBy DescribeBackups New input parameters:Type, BackupFormat DescribeDBInstances New input parameters:InstanceType ModifyBackupStrategy New input parameters:BackupCycle, BackupSaveDays UpgradeDBInstance New input parameters:WaitSwitch

Modified data structures:

AccountCreateInfo New members:Authentication AccountDetail New members:Authentication, Host AccountPrivilegeModifyInfo New members:IsAdmin Backup New members:BackupFormat DBInstance New members:InstanceNote, BackupCycle, BackupCycleType, BackupSaveDays, InstanceType

Release 12

Release time: 2022-01-26 14:29:49

Release updates:

Improvement to existing documentation.

Modified APIs:

ModifyDBInstanceNetwork New input parameters:Vip

Release 11

Release time: 2021-10-13 10:27:05

Release updates:

Improvement to existing documentation.

New APIs:

DescribeBackupFiles

Modified APIs:

DescribeBackups New input parameters:Group DescribeDBInstances New input parameters:UidSet ModifyBackupStrategy New input parameters:BackupModel Modified input parameters: BackupType, BackupTime, BackupDay RestoreInstance New input parameters:GroupId

New data structures:

BackupFile

Modified data structures:

Backup New members:GroupId DBInstance New members:BackupModel

Release 10

Release time: 2021-08-11 11:25:51

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBsNormal DescribeInstanceParamRecords DescribeInstanceParams ModifyDatabaseCDC ModifyDatabaseCT ModifyDatabaseMdf ModifyInstanceParam

New data structures:

DbNormalDetail ParamRecord Parameter ParameterDetail

Release 9

Release time: 2021-03-22 18:06:06

Release updates:

Improvement to existing documentation.

Modified data structures:

DBCreateInfo Modified members: Charset, Accounts, Remark

Release 8

Release time: 2021-03-18 10:48:08

Release updates:

Improvement to existing documentation.

New APIs:

CreateBackupMigration CreateIncrementalMigration DeleteBackupMigration DeleteIncrementalMigration DescribeBackupCommand DescribeBackupMigration DescribeBackupUploadSize DescribeDBCharsets DescribeIncrementalMigration DescribeUploadBackupInfo ModifyBackupMigration ModifyIncrementalMigration StartBackupMigration StartIncrementalMigration

New data structures:

CosUploadBackupFile Migration MigrationAction MigrationDetail MigrationStep

Release 7

Release time: 2021-02-22 15:40:09

Release updates:

Improvement to existing documentation.

New APIs:

CloneDB

Release 6

Release time: 2021-02-05 14:17:07

Release updates:

Improvement to existing documentation.

New APIs:

ModifyDBInstanceNetwork

Modified APIs:

CreateDBInstances New input parameters:ResourceTags DescribeBackups New input parameters:DatabaseName DescribeDBInstances New input parameters:VipSet, InstanceNameSet, VersionSet, Zone, TagKeys, SearchKey UpgradeDBInstance New input parameters:DBVersion, HAType, MultiZones Modified input parameters: Memory, Storage

New data structures:

ResourceTag

Modified data structures:

DBInstance New members:ResourceTags

Release 5

Release time: 2020-12-07 19:22:14

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeProductConfig New input parameters:InstanceType

Modified data structures:

SpecInfo New members:InstanceType, MultiZonesStatus

Release 4

Release time: 2020-11-24 16:06:15

Release updates:

Improvement to existing documentation.

New APIs:

RecycleDBInstance

Modified data structures:

AccountDetail New members:IsAdmin

Release 3

Release time: 2020-09-25 11:38:54

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateBackup New input parameters:BackupName CreateMigration New input parameters:RenameRestore DescribeBackups New input parameters:BackupName, Strategy, BackupWay, BackupId RestoreInstance New input parameters:TargetInstanceId, RenameRestore RollbackInstance New input parameters:TargetInstanceId, RenameRestore

New data structures:

RenameRestoreDatabase

Release 2

Release time: 2020-08-13 23:33:25

Release updates:

Improvement to existing documentation.

New APIs:

ModifyBackupStrategy

Modified data structures:

Backup New members:BackupName

Existing Release

Release time: 2020-07-30 20:40:31

Existing APIs/data structures are as follows:

Improvement to existing documentation.

Existing APIs:

CreateAccount CreateBackup CreateDB CreateDBInstances CreateMigration DeleteAccount DeleteDB DeleteMigration DescribeAccounts DescribeBackups DescribeDBInstances DescribeDBs DescribeFlowStatus DescribeMigrationDetail DescribeMigrations DescribeOrders DescribeProductConfig DescribeRegions DescribeRollbackTime DescribeSlowlogs DescribeZones InquiryPriceCreateDBInstances InquiryPriceUpgradeDBInstance ModifyAccountPrivilege ModifyAccountRemark ModifyDBInstanceName ModifyDBInstanceProject ModifyDBName ModifyDBRemark ModifyMigration ResetAccountPassword RestartDBInstance RestoreInstance RollbackInstance RunMigration TerminateDBInstance UpgradeDBInstance

Existing data structures:

AccountCreateInfo AccountDetail AccountPassword AccountPrivilege AccountPrivilegeModifyInfo AccountRemark Backup DBCreateInfo DBDetail DBInstance DBPrivilege DBPrivilegeModifyInfo DBRemark DbRollbackTimeInfo DealInfo InstanceDBDetail MigrateDB MigrateDetail MigrateSource MigrateTarget MigrateTask RegionInfo SlowlogInfo SpecInfo ZoneInfo Previous Topic: Shrinking a Database Next Topic: Introduction Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Release 55 Release 54 Release 53 Release 52 Release 51 Release 50 Release 49 Release 48 Release 47 Release 46 Release 45 Release 44 Release 43 Release 42 Release 41 Release 40 Release 39 Release 38 Release 37 Release 36 Release 35 Release 34 Release 33 Release 32 Release 31 Release 30 Release 29 Release 28 Release 27 Release 26 Release 25 Release 24 Release 23 Release 22 Release 21 Release 20 Release 19 Release 18 Release 17 Release 16 Release 15 Release 14 Release 13 Release 12 Release 11 Release 10 Release 9 Release 8 Release 7 Release 6 Release 5 Release 4 Release 3 Release 2 Existing Release Search AllCurrent Product Search titles only Enter keywords to search documentation
