# History

> 来源: https://www.tencentcloud.com/document/product/236/16787

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL ​​API Reference History History Download Focus Mode Font Size Last updated: 2026-08-06 16:09:06 Release 59

Release time: 2026-08-06 16:08:34

Release updates:

Improvement to existing documentation.

New APIs:

UpgradeRoGroup Release 58

Release time: 2026-06-03 10:34:07

Release updates:

Improvement to existing documentation.

New APIs:

DescribeClusterInfo

Modified APIs:

ModifyDBInstanceLogToCLS New input parameters:ResourceTags

New data structures:

AddressInfo ClusterNodeInfo Release 57

Release time: 2026-06-01 16:57:58

Release updates:

Improvement to existing documentation.

New APIs:

CloseSSL DeleteDatabase DeleteRotationPassword DescribeCPUExpandStrategyInfo DescribeInstanceAlarmEvents DescribeInstancePasswordComplexity DescribeInstanceUpgradeCheckJob DescribeInstanceUpgradeType DescribeTableColumns ModifyDBInstanceModes ModifyProtectMode ModifyRoGroupVipVport OpenSSL ResetPassword SubmitInstanceUpgradeCheckJob

Deleted APIs:

DescribeCpuExpandStrategy

Deprecated APIs:

DescribeAuditRules

Modified APIs:

AdjustCdbProxyAddress New input parameters:ApNodeAsRoNode, ApQueryToOtherNode AnalyzeAuditLogs Deprecate input parameters: AuditLogFilter CloseWanService New input parameters:OpResourceId CreateBackup New input parameters:EncryptionFlag CreateCdbProxy New input parameters:ProxyVersion CreateCloneInstance New input parameters:PayType, Period, ClusterTopology, SrcRegion, SpecifiedSubBackupId, MasterZone, Zone, FourthZone CreateDBInstance New input parameters:FourthZone CreateDBInstanceHour New input parameters:DataProtectVolume, ClusterTopology, DiskType, ClusterType, DestroyProtect, FourthZone DescribeAccounts New input parameters:SortBy, OrderBy, HostRegexp DescribeBackupConfig Deprecate output parameters: StartTimeMin, StartTimeMax DescribeBackupDecryptionKey New input parameters:BackupType DescribeBinlogs New input parameters:ContainsMinStartTime DescribeDBInstanceConfig New output parameters:FourthConfig DescribeDBInstanceLogToCLS New input parameters:ClsRegion DescribeDBSecurityGroups New input parameters:OpResourceId DescribeProxyCustomConf New output parameters:CustomConfInfo Deprecate output parameters: CustomConf DescribeProxySupportParam New output parameters:SupportAutoLoadBalance, SupportAccessMode DescribeSlowLogData New input parameters:OpResourceId IsolateDBInstance Deprecate output parameters: AsyncRequestId ModifyAccountPassword New input parameters:SkipValidatePassword ModifyBackupEncryptionStatus New input parameters:BinlogEncryptionStatus ModifyDBInstanceLogToCLS New input parameters:ClsRegion ModifyDBInstanceSecurityGroups New input parameters:OpResourceId ModifyDBInstanceVipVport New input parameters:OpResourceId Deprecate output parameters: AsyncRequestId ModifyRoGroupInfo Deprecate input parameters: ReplicationDelayTime OpenAuditService Deprecate input parameters: AuditRuleFilters OpenWanService New input parameters:OpResourceId StartCpuExpand New input parameters:TimeIntervalStrategy, PeriodStrategy SwitchDBInstanceMasterSlave New input parameters:DstNodeId SwitchForUpgrade New input parameters:IsRelatedSwitch UpgradeDBInstance New input parameters:ClusterTopology, CheckFastUpgradeReboot, DataCheckSensitive, FourthZone UpgradeDBInstanceEngineVersion New input parameters:IgnoreErrKeyword, ParamList

New data structures:

InstEventInfo NodeDistribution PeriodStrategy TImeCycle TaskAttachInfo TimeInterval TimeIntervalStrategy UpgradeAnalysisInstanceVersionInfo UpgradeEngineVersionParams

Modified data structures:

AccountInfo New members:OpenCam Deprecate members: CreateTime AuditLog New members:TrxId, ClientPort AutoStrategy New members:ExpandSecondPeriod, ShrinkSecondPeriod Modified members: ExpandPeriod, ShrinkPeriod Deprecate members: ExpandPeriod, ShrinkPeriod BackupInfo New members:Progress, ExecutedGTIDSet, MD5 BinlogInfo New members:Progress Deprecate members: InstanceId Inbound New members:Id Modified members: Action, CidrIp, PortRange, IpProtocol, Dir InstanceInfo New members:CpuModel, AnalysisUpgradeVersionInfo LogToCLSConfig New members:ClsRegion ParamTemplateInfo Modified members: EngineType ParameterDetail Modified members: IsNotSupportEdit ProxyAddress New members:AccessMode, AutoLoadBalance, ApNodeAsRoNode, ApQueryToOtherNode ProxyInst New members:InstNodeId, InstNodeRole TaskDetail New members:TaskAttachInfo Release 56

Release time: 2026-04-21 11:45:05

Release updates:

Improvement to existing documentation.

New APIs:

DescribeSSLStatus Release 55

Release time: 2026-03-19 18:21:14

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstance New input parameters:DataProtectVolume, ClusterTopology, DiskType, DestroyProtect RenewDBInstance New input parameters:AutoRenew

New data structures:

ClusterTopology DiskTypeConfigItem ReadWriteNode ReadonlyNode

Modified data structures:

CdbZoneSellConf New members:CloudNativeClusterStatus, DiskTypeConf Release 54

Release time: 2026-01-19 16:25:15

Release updates:

Improvement to existing documentation.

New APIs:

CreateRotationPassword Release 53

Release time: 2026-01-19 15:59:21

Release updates:

Improvement to existing documentation.

New APIs:

CloseAuditService CreateAuditLogFile CreateAuditRuleTemplate DeleteAuditLogFile DeleteAuditPolicy DeleteAuditRuleTemplates DescribeAuditConfig DescribeAuditInstanceList DescribeAuditLogFiles DescribeAuditRuleTemplateModifyHistory DescribeAuditRuleTemplates ModifyAuditConfig ModifyAuditRuleTemplates ModifyAuditService

New data structures:

AuditInstanceFilters AuditInstanceInfo AuditLogFile AuditRuleTemplateInfo InstanceDbAuditStatus RuleTemplateInfo RuleTemplateRecordInfo Release 52

Release time: 2025-12-19 11:08:18

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeDBInstances New input parameters:QueryClusterInfo

New data structures:

AnalysisNodeInfo ClusterInfo

Modified data structures:

InstanceInfo New members:ExpandCpu, ClusterInfo, AnalysisNodeInfos, DeviceBandwidth, DestroyProtect RoInstanceInfo New members:ReplicationStatus SlaveInfo Modified members: Second Release 51

Release time: 2025-08-01 12:01:32

Release updates:

Improvement to existing documentation.

Modified APIs:

AdjustCdbProxyAddress New input parameters:AutoLoadBalance, AccessMode CreateCdbProxyAddress New input parameters:AutoLoadBalance, AccessMode DescribeDBPrice New input parameters:DiskType Release 50

Release time: 2024-11-20 11:11:49

Release updates:

Improvement to existing documentation.

Deleted APIs:

InitDBInstances

Modified APIs:

CloseCDBProxy Modified input parameters: ProxyGroupId DescribeDefaultParams Modified input parameters: EngineVersion DescribeProjectSecurityGroups Modified input parameters: ProjectId

Modified data structures:

InstanceInfo Modified members: MasterInfo Parameter Modified members: Name, CurrentValue RoInstanceInfo Modified members: MasterInstanceId, RoStatus, OfflineTime, Weight, Region, Zone, InstanceId, Status, InstanceType, InstanceName, HourFeeStatus, TaskStatus, Memory, Volume, Qps, Vip, Vport, VpcId, SubnetId, DeviceType, EngineVersion, DeadlineTime, PayType Release 49

Release time: 2024-01-30 10:25:14

Release updates:

Improvement to existing documentation.

Modified data structures:

RemoteBackupInfo Modified members: SubBackupId Release 48

Release time: 2023-12-01 15:39:07

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBInstanceLogToCLS ModifyDBInstanceLogToCLS

Modified APIs:

OpenAuditService New input parameters:AuditAll StartCpuExpand New input parameters:InstanceId, Type, ExpandCpu, AutoStrategy

New data structures:

AutoStrategy LogRuleTemplateInfo LogToCLSConfig

Modified data structures:

AuditLog New members:TemplateInfo ParamRecord New members:IsSuccess Deprecate members: IsSucess Release 47

Release time: 2023-10-13 09:47:47

Release updates:

Improvement to existing documentation.

New APIs:

DescribeCpuExpandStrategy StartCpuExpand StopCpuExpand Release 46

Release time: 2023-08-10 15:49:41

Release updates:

Improvement to existing documentation.

New APIs:

DescribeAuditLogs

Deleted APIs:

DescribeCDBProxy DescribeProxyConnectionPoolConf ModifyCDBProxyConnectionPool ModifyCDBProxyDesc ModifyCDBProxyVipVPort QueryCDBProxy

Modified APIs:

AnalyzeAuditLogs New input parameters:LogFilter

New data structures:

AuditLog InstanceAuditLogFilters

Deleted data structures:

Address BaseGroupInfo ConnectionPoolInfo PoolConf ProxyGroup ProxyGroups ProxyNodeInfo RWInfo RWInfos RWInstanceInfo Release 45

Release time: 2023-07-19 15:11:38

Release updates:

Improvement to existing documentation.

New APIs:

CreateDatabase

Modified data structures:

ProxyInst Modified members: InstanceType Release 44

Release time: 2023-06-21 09:49:53

Release updates:

Improvement to existing documentation.

New APIs:

AdjustCdbProxy AdjustCdbProxyAddress CloseCdbProxyAddress CreateCdbProxy CreateCdbProxyAddress DescribeBackupDecryptionKey DescribeCdbProxyInfo DescribeProxySupportParam ModifyCdbProxyAddressDesc ModifyCdbProxyAddressVipAndVPort ModifyCdbProxyParam

Modified APIs:

DescribeBinlogs New input parameters:MinStartTime, MaxStartTime DescribeParamTemplateInfo New output parameters:EngineType DescribeRollbackRangeTime New input parameters:IsRemoteZone, BackupRegion OpenAuditService New input parameters:AuditRuleFilters, RuleTemplateIds

New data structures:

AuditRuleFilters ProxyAddress ProxyAllocation ProxyGroupInfo ProxyInst ProxyNode ProxyNodeCustom RuleFilters

Modified data structures:

AuditLogFilter New members:ThreadId, SentRows, ErrCode Inbound New members:AddressModule Outbound New members:AddressModule ParamTemplateInfo New members:EngineType ParameterDetail New members:IsNotSupportEdit Release 43

Release time: 2023-04-20 14:34:36

Release updates:

Improvement to existing documentation.

Deprecated APIs:

DescribeCDBProxy DescribeProxyConnectionPoolConf ModifyCDBProxyConnectionPool ModifyCDBProxyDesc ModifyCDBProxyVipVPort QueryCDBProxy

Modified APIs:

UpgradeDBInstance New input parameters:RoTransType Release 42

Release time: 2023-04-04 16:31:02

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeDBInstances New input parameters:EngineTypes DescribeDefaultParams New input parameters:EngineType

Modified data structures:

InstanceInfo New members:DiskType Release 41

Release time: 2023-04-04 16:27:39

Release updates:

Improvement to existing documentation.

New APIs:

AnalyzeAuditLogs

New data structures:

AggregationCondition AuditLogAggregationResult AuditLogFilter Bucket Release 40

Release time: 2023-03-23 17:41:28

Release updates:

Improvement to existing documentation.

Deprecated APIs:

InitDBInstances

Modified data structures:

CloneItem New members:NewRegionId, SrcRegionId Release 39

Release time: 2023-02-24 15:41:50

Release updates:

Improvement to existing documentation.

New APIs:

DescribeBackupEncryptionStatus ModifyBackupEncryptionStatus OpenDBInstanceEncryption

Deleted APIs:

UpgradeCDBProxy Release 38

Release time: 2023-02-15 16:31:32

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBFeatures Release 37

Release time: 2023-02-03 15:38:03

Release updates:

Improvement to existing documentation.

New APIs:

CreateDBInstance RenewDBInstance

Modified APIs:

DescribeDBInstances New input parameters:ProxyVips, ProxyIds

Modified data structures:

CommonTimeWindow New members:BackupPeriodStrategy, Days, BackupPeriodTime Release 36

Release time: 2023-01-03 15:54:50

Release updates:

Improvement to existing documentation.

New APIs:

DescribeRemoteBackupConfig ModifyRemoteBackupConfig

Modified APIs:

DescribeBackupConfig New output parameters:EnableBackupStandby, BackupStandbyDays, EnableBinlogStandby, BinlogStandbyDays DescribeBackupOverview New output parameters:BackupStandbyVolume DescribeBinlogBackupOverview New output parameters:BinlogStandbyVolume, BinlogStandbyCount DescribeDataBackupOverview New output parameters:DataBackupStandbyVolume, DataBackupStandbyCount ModifyBackupConfig New input parameters:EnableBackupStandby, BackupStandbyDays, EnableBinlogStandby, BinlogStandbyDays Release 35

Release time: 2022-12-19 14:58:41

Release updates:

Improvement to existing documentation.

Deleted APIs:

ApplyCDBProxy ModifyCDBProxy

Deleted data structures:

RoWeight

Modified data structures:

BackupInfo New members:EncryptionFlag Release 34

Release time: 2022-11-21 11:19:14

Release updates:

Improvement to existing documentation.

Modified APIs:

ReloadBalanceProxyNode New input parameters:ProxyAddressId Release 33

Release time: 2022-10-27 17:04:16

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeBackupConfig New output parameters:EnableBackupArchive, BackupArchiveDays, EnableBinlogArchive, BinlogArchiveDays DescribeBackupOverview New output parameters:RemoteBackupVolume, BackupArchiveVolume DescribeBinlogBackupOverview New output parameters:BinlogArchiveVolume, BinlogArchiveCount DescribeDataBackupOverview New output parameters:DataBackupArchiveVolume, DataBackupArchiveCount ModifyBackupConfig New input parameters:EnableBackupArchive, BackupArchiveDays, BinlogArchiveDays, EnableBinlogArchive

New data structures:

RemoteBackupInfo

Modified data structures:

BackupInfo New members:Region, RemoteInfo, CosStorageType, InstanceId BinlogInfo New members:Region, Status, RemoteInfo, CosStorageType, InstanceId Release 32

Release time: 2022-10-12 16:08:03

Release updates:

Improvement to existing documentation.

Modified APIs:

ModifyInstanceParam New input parameters:NotSyncRo, NotSyncDr Release 31

Release time: 2022-10-08 10:47:01

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateParamTemplate New input parameters:EngineType Release 30

Release time: 2022-09-21 15:42:01

Release updates:

Improvement to existing documentation.

New APIs:

DescribeCdbZoneConfig

Modified APIs:

DescribeBinlogBackupOverview New output parameters:RemoteBinlogVolume, RemoteBinlogCount DescribeDBPrice New input parameters:DeviceType, InstanceNodes, Cpu, InstanceId, Ladder Modified input parameters: Zone, GoodsNum, Memory, Volume, PayType New output parameters:Currency DescribeDataBackupOverview New output parameters:RemoteBackupVolume, RemoteBackupCount

New data structures:

CdbRegionSellConf CdbSellConfig CdbSellType CdbZoneDataResult CdbZoneSellConf ZoneConf

Modified data structures:

InstanceInfo New members:EngineType, MaxDelayTime Release 29

Release time: 2022-09-19 11:50:25

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBPrice

Deleted APIs:

DescribeDBZoneConfig

Modified APIs:

DescribeParamTemplates New input parameters:EngineTypes, TemplateNames, TemplateIds

Deleted data structures:

RegionSellConf SellConfig SellType ZoneConf ZoneSellConf Release 28

Release time: 2022-08-17 15:54:33

Release updates:

Improvement to existing documentation.

New APIs:

CreateAccounts DescribeAccounts ModifyDBInstanceVipVport ModifyInstancePasswordComplexity ModifyNameOrDescByDpId

New data structures:

AccountInfo Release 27

Release time: 2022-07-18 10:44:49

Release updates:

Improvement to existing documentation.

New APIs:

OpenAuditService Release 26

Release time: 2022-06-14 16:43:39

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeDBInstances New input parameters:Tags

New data structures:

Tag

Modified data structures:

SellConfig New members:EngineType Release 25

Release time: 2022-05-19 10:38:21

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstanceHour New input parameters:EngineType Release 24

Release time: 2022-05-05 15:03:52

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeBackupConfig New output parameters:EnableBackupPeriodSave, BackupPeriodSaveDays, BackupPeriodSaveInterval, BackupPeriodSaveCount, StartBackupPeriodSaveDate ModifyBackupConfig New input parameters:EnableBackupPeriodSave, EnableBackupPeriodLongTermSave, BackupPeriodSaveDays, BackupPeriodSaveInterval, BackupPeriodSaveCount, StartBackupPeriodSaveDate

Modified data structures:

BackupInfo New members:SaveMode Release 23

Release time: 2022-04-26 16:21:26

Release updates:

Improvement to existing documentation.

New APIs:

DescribeAuditPolicies DescribeAuditRules ResetRootAccount

Deleted APIs:

CreateAccounts CreateDeployGroup DeleteDeployGroups DescribeAccounts DescribeDeployGroupList ModifyDBInstanceVipVport ModifyNameOrDescByDpId

Modified APIs:

AddTimeWindow New input parameters:MaxDelayTime CreateCloneInstance New input parameters:ProjectId CreateDBInstanceHour New input parameters:Vips DescribeDBInstances New input parameters:TagValues, UniqueVpcIds, UniqSubnetIds DescribeTimeWindow New output parameters:MaxDelayTime ModifyTimeWindow New input parameters:MaxDelayTime

New data structures:

AuditFilter AuditPolicy AuditRule

Deleted data structures:

AccountInfo DeployGroupInfo Release 22

Release time: 2022-02-24 15:04:42

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBImportJob New input parameters:CosUrl Modified input parameters: FileName DescribeDefaultParams New input parameters:TemplateType

Modified data structures:

ZoneSellConf New members:ExClusterStatus, ExClusterRemoteRoZone, ExClusterZoneConf Release 21

Release time: 2022-02-15 14:49:26

Release updates:

Improvement to existing documentation.

New APIs:

ApplyCDBProxy CloseCDBProxy DescribeCDBProxy DescribeLocalBinlogConfig DescribeProxyConnectionPoolConf DescribeProxyCustomConf ModifyCDBProxy ModifyCDBProxyConnectionPool ModifyCDBProxyDesc ModifyCDBProxyVipVPort ModifyLocalBinlogConfig QueryCDBProxy ReloadBalanceProxyNode SwitchCDBProxy UpgradeCDBProxy UpgradeCDBProxyVersion

Modified APIs:

CreateParamTemplate New input parameters:TemplateType DescribeParamTemplateInfo New output parameters:TemplateType

New data structures:

Address BaseGroupInfo ConnectionPoolInfo CustomConfig LocalBinlogConfig LocalBinlogConfigDefault PoolConf ProxyGroup ProxyGroups ProxyNodeInfo RWInfo RWInfos RWInstanceInfo RoWeight Rule

Modified data structures:

ParamTemplateInfo New members:TemplateType ParameterDetail New members:MaxFunc, MinFunc Release 20

Release time: 2022-01-19 11:26:39

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateCloneInstance New input parameters:CageId CreateDBInstanceHour New input parameters:ParamTemplateType DescribeParamTemplates New input parameters:EngineVersions Release 19

Release time: 2022-01-07 11:50:21

Release updates:

Improvement to existing documentation.

New APIs:

StartReplication StopReplication

Deleted APIs:

ModifyRoReplicationDelay StartDelayReplication StopDelayReplication

Modified APIs:

ModifyRoGroupInfo New input parameters:ReplicationDelayTime New output parameters:AsyncRequestId UpgradeDBInstance New input parameters:CrossCluster, ZoneId

Modified data structures:

RoGroup New members:DelayReplicationTime RoGroupAttr New members:ReplicationDelayTime Release 18

Release time: 2021-12-15 14:25:47

Release updates:

Improvement to existing documentation.

Modified APIs:

UpgradeDBInstance New input parameters:MaxDelayTime UpgradeDBInstanceEngineVersion New input parameters:MaxDelayTime Release 17

Release time: 2021-11-24 16:52:13

Release updates:

Improvement to existing documentation.

New APIs:

DescribeBackupDownloadRestriction ModifyBackupDownloadRestriction

New data structures:

BackupLimitVpcItem Release 16

Release time: 2021-11-05 19:17:59

Release updates:

Improvement to existing documentation.

Deleted APIs:

ModifyRoType

Modified APIs:

CreateBackup New input parameters:ManualBackupName CreateCloneInstance New input parameters:DryRun CreateDBInstanceHour New input parameters:AlarmPolicyIdList, DryRun

Modified data structures:

BackupInfo New members:ManualBackupName Release 15

Release time: 2021-10-28 10:17:51

Release updates:

Improvement to existing documentation.

Deleted APIs:

DescribeBackupDatabases DescribeBackupTables

Modified APIs:

CreateCloneInstance New input parameters:DeployGroupId

Deleted data structures:

DatabaseName TableName Release 14

Release time: 2021-10-12 17:17:11

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstanceHour New input parameters:CageId DescribeDBInstances New input parameters:CageIds Release 13

Release time: 2021-09-29 17:51:19

Release updates:

Improvement to existing documentation.

New APIs:

CreateAuditPolicy Release 12

Release time: 2021-08-19 17:25:48

Release updates:

Improvement to existing documentation.

Modified APIs:

UpgradeDBInstance New input parameters:FastUpgrade Release 11

Release time: 2021-07-02 15:23:48

Release updates:

Improvement to existing documentation.

Modified APIs:

UpgradeDBInstance New input parameters:DeviceType, Cpu Release 10

Release time: 2021-06-03 09:46:01

Release updates:

Improvement to existing documentation.

New APIs:

ModifyAccountMaxUserConnections

Modified APIs:

CreateAccounts New input parameters:MaxUserConnections DescribeAccounts New output parameters:MaxUserConnections DescribeDBInstances New input parameters:TagKeysForSearch ModifyAccountPrivileges New input parameters:ModifyAction

New data structures:

TagInfoItem

Modified data structures:

AccountInfo New members:MaxUserConnections InstanceInfo New members:TagList Release 9

Release time: 2021-04-15 16:33:15

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeDBInstanceConfig New output parameters:Switched DescribeDatabases New output parameters:DatabaseList DescribeParamTemplateInfo New output parameters:Description DescribeProjectSecurityGroups New output parameters:TotalCount

New data structures:

DatabasesWithCharacterLists

Modified data structures:

SellConfig New members:DeviceType, DeviceTypeName Release 8

Release time: 2021-03-19 17:06:01

Release updates:

Improvement to existing documentation.

Modified APIs:

AssociateSecurityGroups New input parameters:ForReadonlyInstance CreateCloneInstance New input parameters:InstanceNodes CreateDBInstanceHour New input parameters:InstanceNodes, Cpu, AutoSyncFlag DescribeDBSecurityGroups New input parameters:ForReadonlyInstance DisassociateSecurityGroups New input parameters:ForReadonlyInstance ModifyDBInstanceSecurityGroups New input parameters:ForReadonlyInstance

Modified data structures:

Inbound New members:Desc InstanceInfo New members:InstanceNodes Outbound New members:Desc Release 7

Release time: 2021-02-09 10:57:46

Release updates:

Improvement to existing documentation.

New APIs:

SwitchDBInstanceMasterSlave SwitchDrInstanceToMaster

Modified APIs:

DescribeErrorLogData New input parameters:InstType DescribeSlowLogData New input parameters:InstType Release 6

Release time: 2020-12-17 16:49:08

Release updates:

Improvement to existing documentation.

New APIs:

ModifyRoReplicationDelay ModifyRoType StartDelayReplication StopDelayReplication Release 5

Release time: 2020-12-09 18:28:03

Release updates:

Improvement to existing documentation.

New APIs:

CreateCloneInstance DescribeCloneList StopRollback

New data structures:

CloneItem Release 4

Release time: 2020-11-05 19:16:28

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstanceHour New input parameters:ParamTemplateId, AlarmPolicyList DescribeDBInstanceInfo New output parameters:DefaultKmsRegion

Modified data structures:

DeviceDiskInfo New members:CapacityRatio Release 3

Release time: 2020-08-06 19:38:51

Release updates:

Improvement to existing documentation.

New APIs:

CreateRoInstanceIp Release 2

Release time: 2020-07-30 17:59:28

Release updates:

Improvement to existing documentation.

New APIs:

DescribeRoMinScale Existing Release

Release time: 2020-07-24 14:18:41

Existing APIs/data structures are as follows:

Improvement to existing documentation.

Existing APIs:

AddTimeWindow AssociateSecurityGroups BalanceRoGroupLoad CloseWanService CreateAccounts CreateBackup CreateDBImportJob CreateDBInstanceHour CreateDeployGroup CreateParamTemplate DeleteAccounts DeleteBackup DeleteDeployGroups DeleteParamTemplate DeleteTimeWindow DescribeAccountPrivileges DescribeAccounts DescribeAsyncRequestInfo DescribeBackupConfig DescribeBackupDatabases DescribeBackupOverview DescribeBackupSummaries DescribeBackupTables DescribeBackups DescribeBinlogBackupOverview DescribeBinlogs DescribeDBImportRecords DescribeDBInstanceCharset DescribeDBInstanceConfig DescribeDBInstanceGTID DescribeDBInstanceInfo DescribeDBInstanceRebootTime DescribeDBInstances DescribeDBSecurityGroups DescribeDBSwitchRecords DescribeDBZoneConfig DescribeDataBackupOverview DescribeDatabases DescribeDefaultParams DescribeDeployGroupList DescribeDeviceMonitorInfo DescribeErrorLogData DescribeInstanceParamRecords DescribeInstanceParams DescribeParamTemplateInfo DescribeParamTemplates DescribeProjectSecurityGroups DescribeRoGroups DescribeRollbackRangeTime DescribeRollbackTaskDetail DescribeSlowLogData DescribeSlowLogs DescribeSupportedPrivileges DescribeTables DescribeTagsOfInstanceIds DescribeTasks DescribeTimeWindow DescribeUploadedFiles DisassociateSecurityGroups InitDBInstances IsolateDBInstance ModifyAccountDescription ModifyAccountPassword ModifyAccountPrivileges ModifyAutoRenewFlag ModifyBackupConfig ModifyDBInstanceName ModifyDBInstanceProject ModifyDBInstanceSecurityGroups ModifyDBInstanceVipVport ModifyInstanceParam ModifyInstanceTag ModifyNameOrDescByDpId ModifyParamTemplate ModifyRoGroupInfo ModifyTimeWindow OfflineIsolatedInstances OpenDBInstanceGTID OpenWanService ReleaseIsolatedDBInstances RestartDBInstances StartBatchRollback StopDBImportJob SwitchForUpgrade UpgradeDBInstance UpgradeDBInstanceEngineVersion

Existing data structures:

Account AccountInfo BackupConfig BackupInfo BackupItem BackupSummaryItem BinlogInfo ColumnPrivilege CommonTimeWindow DBSwitchInfo DatabaseName DatabasePrivilege DeployGroupInfo DeviceCpuInfo DeviceCpuRateInfo DeviceDiskInfo DeviceMemInfo DeviceNetInfo DrInfo ErrlogItem ImportRecord Inbound InstanceInfo InstanceRebootTime InstanceRollbackRangeTime MasterInfo Outbound ParamInfo ParamRecord ParamTemplateInfo Parameter ParameterDetail RegionSellConf ReleaseResult RoGroup RoGroupAttr RoInstanceInfo RoVipInfo RoWeightValue RollbackDBName RollbackInstancesInfo RollbackTableName RollbackTables RollbackTask RollbackTimeRange SecurityGroup SellConfig SellType SlaveConfig SlaveInfo SlaveInstanceInfo SlowLogInfo SlowLogItem SqlFileInfo TableName TablePrivilege TagInfo TagInfoUnit TagsInfoOfInstance TaskDetail UploadInfo ZoneConf ZoneSellConf Previous Topic: Handling Primary Key-Related Error Hiding Next Topic: Introduction Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Release 59 Release 58 Release 57 Release 56 Release 55 Release 54 Release 53 Release 52 Release 51 Release 50 Release 49 Release 48 Release 47 Release 46 Release 45 Release 44 Release 43 Release 42 Release 41 Release 40 Release 39 Release 38 Release 37 Release 36 Release 35 Release 34 Release 33 Release 32 Release 31 Release 30 Release 29 Release 28 Release 27 Release 26 Release 25 Release 24 Release 23 Release 22 Release 21 Release 20 Release 19 Release 18 Release 17 Release 16 Release 15 Release 14 Release 13 Release 12 Release 11 Release 10 Release 9 Release 8 Release 7 Release 6 Release 5 Release 4 Release 3 Release 2 Existing Release Search AllCurrent Product Search titles only Enter keywords to search documentation
