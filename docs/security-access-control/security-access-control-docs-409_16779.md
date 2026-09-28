# History

> 来源: https://www.tencentcloud.com/document/product/409/16779

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL ​​API Reference History History Download Focus Mode Font Size Last updated: 2026-06-11 16:01:29

Release 34

Release time: 2026-05-21 10:40:11

Release updates:

Improvement to existing documentation.

New APIs:

CloseAccountCAM CloseAuditService CreateAuditLogFile DeleteAuditLogFile DescribeAuditInstanceList DescribeAuditLogFiles DescribeAuditLogs ModifyAuditService OpenAccountCAM OpenAuditService RefreshAccountPassword

Deleted APIs:

CloseServerlessDBExtranetAccess CreateDBInstances CreateServerlessDBInstance DeleteServerlessDBInstance DescribeDBSlowlogs DescribeServerlessDBInstances InitDBInstances OpenServerlessDBExtranetAccess UpgradeDBInstance

Modified APIs:

AddDBInstanceToReadOnlyGroup New output parameters:TaskId CreateReadOnlyGroup New output parameters:TaskId DeleteDBInstanceNetworkAccess New output parameters:TaskId DeleteReadOnlyGroupNetworkAccess New output parameters:TaskId DescribeClasses New input parameters:StorageType DescribeDBErrlogs New input parameters:LogFilters DescribeDBVersions New input parameters:StorageType DescribeProductConfig New input parameters:StorageType InquiryPriceUpgradeDBInstance Deprecate input parameters: InstanceChargeType ModifyBackupPlan New input parameters:PlanId, PlanName ModifyDBInstanceDeployment New output parameters:TaskId ModifyDBInstanceReadOnlyGroup New output parameters:TaskId RemoveDBInstanceFromReadOnlyGroup New output parameters:TaskId RestartDBInstance New output parameters:TaskId RestoreDBInstanceObjects New output parameters:TaskId SwitchDBInstancePrimary New output parameters:TaskId UpgradeDBInstanceKernelVersion New output parameters:TaskId UpgradeDBInstanceMajorVersion New output parameters:TaskId

New data structures:

AuditInstanceInfo AuditLog AuditLogFile AuditLogFilter DeliverSummary LogFilter LogInstanceInfo

Deleted data structures:

NormalQueryItem ServerlessDBAccount ServerlessDBInstance ServerlessDBInstanceNetInfo SlowlogDetail

Modified data structures:

BackupPlan New members:PlanId, PlanName, LogBackupRetentionPeriod, CreatedTime, UpdatedTime, PlanType, BackupPeriodType ErrLogDetail New members:ProcessId, ClientAddr, SessionId, SessionStartTime, VirtualTransactionId, SqlStateCode, ApplicationName RawSlowQuery New members:ProcessId, SessionId, VirtualTransactionId, SqlStateCode, ApplicationName

Release 33

Release time: 2026-04-22 17:00:11

Release updates:

Improvement to existing documentation.

New APIs:

ModifyDBInstanceDeletionProtection

Release 32

Release time: 2026-04-13 13:06:39

Release updates:

Improvement to existing documentation.

New APIs:

CreateAccount CreateDatabase DeleteAccount DeleteBackupPlan DescribeAccountPrivileges DescribeDatabaseObjects DescribeDedicatedClusters DescribeTasks LockAccount ModifyAccountPrivileges ModifyDatabaseOwner UnlockAccount

Modified APIs:

CloseDBExtranetAccess New output parameters:TaskId CreateDBInstanceNetworkAccess New output parameters:TaskId CreateReadOnlyGroupNetworkAccess New output parameters:TaskId DescribeDatabases New output parameters:Databases InquiryPriceCreateDBInstances New input parameters:StorageType ModifyDBInstanceParameters New output parameters:TaskId OpenDBExtranetAccess New output parameters:TaskId

New data structures:

Database DatabaseObject DatabasePrivilege DedicatedCluster ModifyPrivilege TaskDetail TaskSet

Modified data structures:

AccountInfo New members:PasswordUpdateTime, UserType, OpenCam

Release 31

Release time: 2026-04-13 13:04:51

Release updates:

Improvement to existing documentation.

New APIs:

CreateBackupPlan DescribeDBInstanceSSLConfig DescribeMaintainTimeWindow ModifyDBInstanceSSLConfig ModifyMaintainTimeWindow ModifyReadOnlyDBInstanceWeight

Modified data structures:

EncryptionKey New members:KMSClusterId

Release 30

Release time: 2026-04-01 18:22:32

Release updates:

Improvement to existing documentation.

Modified APIs:

CloneDBInstance New input parameters:DeletionProtection CreateInstances New input parameters:DeletionProtection, StorageType CreateReadOnlyDBInstance New input parameters:DeletionProtection New output parameters:BillingParameters

Release 29

Release time: 2026-04-01 18:13:10

Release updates:

Improvement to existing documentation.

Modified data structures:

DBInstance New members:ExpandedCpu, DeletionProtection, DBInstanceStorageType DBNode New members:DedicatedClusterId

Release 28

Release time: 2025-08-13 17:56:16

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateInstances New input parameters:KMSClusterId CreateReadOnlyDBInstance New input parameters:DedicatedClusterId Deprecate input parameters: DBVersion

Release 27

Release time: 2024-06-17 14:24:43

Release updates:

Improvement to existing documentation.

New APIs:

RestoreDBInstanceObjects UpgradeDBInstanceMajorVersion

Modified APIs:

DescribeDatabases New input parameters:Filters, Offset, Limit New output parameters:TotalCount InquiryPriceUpgradeDBInstance New input parameters:Cpu ModifyBackupPlan New input parameters:LogBackupRetentionPeriod ModifyDBInstanceSpec New input parameters:Cpu

Release 26

Release time: 2023-10-13 09:40:31

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBInstanceHAConfig ModifyDBInstanceHAConfig SwitchDBInstancePrimary

Modified APIs:

CloneDBInstance New input parameters:SyncMode CreateInstances New input parameters:SyncMode

Release 25

Release time: 2023-06-26 16:44:09

Release updates:

Improvement to existing documentation.

New APIs:

DescribeBackupDownloadRestriction ModifyBackupDownloadRestriction ModifyDBInstanceChargeType

Modified APIs:

CreateBaseBackup New output parameters:BaseBackupId

Release 24

Release time: 2023-05-04 10:04:43

Release updates:

Improvement to existing documentation.

Modified APIs:

DescribeBackupDownloadURL New input parameters:BackupDownloadRestriction

New data structures:

BackupDownloadRestriction

Release 23

Release time: 2023-03-31 17:18:45

Release updates:

Improvement to existing documentation.

New APIs:

CreateBaseBackup DeleteBaseBackup DeleteLogBackup DescribeBackupDownloadURL DescribeBackupOverview DescribeBackupSummaries DescribeBaseBackups DescribeClasses DescribeDBVersions DescribeLogBackups ModifyBaseBackupExpireTime UpgradeDBInstanceKernelVersion

New data structures:

BackupSummary BaseBackup ClassInfo LogBackup Version

Release 22

Release time: 2023-01-06 11:48:30

Release updates:

Improvement to existing documentation.

New APIs:

CreateParameterTemplate DeleteParameterTemplate DescribeDBInstanceSecurityGroups DescribeDefaultParameters DescribeParameterTemplateAttributes DescribeParameterTemplates ModifyDBInstanceSecurityGroups ModifyParameterTemplate

New data structures:

ParameterTemplate PolicyRule SecurityGroup

Release 21

Release time: 2022-12-12 15:20:52

Release updates:

Improvement to existing documentation.

New data structures:

ParamSpecRelation ParamVersionRelation

Modified data structures:

DBInstanceNetInfo New members:ProtocolType ParamInfo New members:StandbyRelated, VersionRelationSet, SpecRelationSet

Release 20

Release time: 2022-10-21 10:39:28

Release updates:

Improvement to existing documentation.

Modified APIs:

CloneDBInstance New output parameters:DBInstanceId CreateInstances New input parameters:DBEngine, DBEngineConfig CreateReadOnlyDBInstance Modified input parameters: DBVersion DescribeProductConfig New input parameters:DBEngine InquiryPriceCreateDBInstances New input parameters:InstanceType, DBEngine Modified input parameters: Pid

Modified data structures:

DBInstance New members:DBEngine, DBEngineConfig

Release 19

Release time: 2022-07-08 10:15:34

Release updates:

Improvement to existing documentation.

Modified APIs:

InquiryPriceCreateDBInstances New output parameters:Currency InquiryPriceRenewDBInstance New output parameters:Currency InquiryPriceUpgradeDBInstance New output parameters:Currency

Release 18

Release time: 2022-05-13 10:40:43

Release updates:

Improvement to existing documentation.

New APIs:

DescribeEncryptionKeys

New data structures:

EncryptionKey

Release 17

Release time: 2022-05-05 15:22:02

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateInstances New input parameters:NeedSupportTDE, KMSKeyId, KMSRegion

Modified data structures:

DBInstance New members:IsSupportTDE SpecInfo New members:SupportKMSRegions SpecItemInfo New members:IsSupportTDE

Release 16

Release time: 2022-03-18 10:00:12

Release updates:

Improvement to existing documentation.

New APIs:

CreateDBInstanceNetworkAccess CreateReadOnlyGroupNetworkAccess DeleteDBInstanceNetworkAccess DeleteReadOnlyGroupNetworkAccess

Release 15

Release time: 2022-01-28 15:12:20

Release updates:

Improvement to existing documentation.

New APIs:

CloneDBInstance DescribeAvailableRecoveryTime DescribeBackupPlans DescribeCloneDBInstanceSpec ModifyBackupPlan ModifyDBInstanceDeployment

New data structures:

BackupPlan

Modified data structures:

DBBackup New members:SetId ZoneInfo New members:StandbyZoneSet

Release 14

Release time: 2022-01-11 10:27:27

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstances New input parameters:DBMajorVersion, DBKernelVersion Modified input parameters: DBVersion CreateInstances New input parameters:DBNodeSet

New data structures:

DBNode

Modified data structures:

DBInstance New members:DBNodeSet ServerlessDBInstance New members:DBMajorVersion SpecItemInfo New members:MajorVersion, KernelVersion

Release 13

Release time: 2021-12-27 10:21:40

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateInstances New input parameters:DBMajorVersion, DBKernelVersion Modified input parameters: DBVersion

Modified data structures:

DBInstance New members:DBMajorVersion DBInstanceNetInfo New members:VpcId, SubnetId

Release 12

Release time: 2021-12-09 10:58:08

Release updates:

Improvement to existing documentation.

New data structures:

NetworkAccess

Modified data structures:

DBInstance New members:DBKernelVersion, NetworkAccessList ReadOnlyGroup New members:NetworkAccessList ServerlessDBInstance New members:DBKernelVersion

Release 11

Release time: 2021-11-19 18:12:10

Release updates:

Improvement to existing documentation.

New APIs:

ModifyDBInstanceSpec

Release 10

Release time: 2021-11-16 17:18:11

Release updates:

Improvement to existing documentation.

New APIs:

DescribeDBInstanceParameters DescribeParamsEvent ModifyDBInstanceParameters

New data structures:

EventInfo EventItem ParamEntry ParamInfo

Release 9

Release time: 2021-09-09 17:55:51

Release updates:

Improvement to existing documentation.

New APIs:

DescribeSlowQueryAnalysis DescribeSlowQueryList

New data structures:

AnalysisItems Detail DurationAnalysis RawSlowQuery

Release 8

Release time: 2021-08-06 15:57:30

Release updates:

Improvement to existing documentation.

New APIs:

ModifySwitchTimePeriod

Modified APIs:

UpgradeDBInstance New input parameters:SwitchTag, SwitchStartTime, SwitchEndTime

Release 7

Release time: 2021-06-02 17:23:48

Release updates:

Improvement to existing documentation.

New APIs:

CreateInstances

Release 6

Release time: 2021-04-26 17:42:28

Release updates:

Improvement to existing documentation.

New APIs:

DisIsolateDBInstances IsolateDBInstances

Release 5

Release time: 2021-04-20 10:11:20

Release updates:

Improvement to existing documentation.

Modified APIs:

CreateDBInstances New input parameters:SecurityGroupIds CreateReadOnlyDBInstance New input parameters:SecurityGroupIds CreateReadOnlyGroup New input parameters:SecurityGroupIds

Modified data structures:

DBInstance New members:OfflineTime

Release 4

Release time: 2021-03-01 16:57:48

Release updates:

Improvement to existing documentation.

New APIs:

AddDBInstanceToReadOnlyGroup CreateReadOnlyDBInstance CreateReadOnlyGroup DeleteReadOnlyGroup DescribeReadOnlyGroups ModifyDBInstanceReadOnlyGroup ModifyReadOnlyGroupConfig RebalanceReadOnlyGroup RemoveDBInstanceFromReadOnlyGroup

New data structures:

ReadOnlyGroup

Modified data structures:

RegionInfo New members:SupportInternational

Release 3

Release time: 2021-02-26 16:43:58

Release updates:

Improvement to existing documentation.

New APIs:

CloseServerlessDBExtranetAccess OpenServerlessDBExtranetAccess

Release 2

Release time: 2020-12-01 20:28:46

Release updates:

Improvement to existing documentation.

New APIs:

CreateServerlessDBInstance DeleteServerlessDBInstance DescribeServerlessDBInstances

New data structures:

ServerlessDBAccount ServerlessDBInstance ServerlessDBInstanceNetInfo

Modified data structures:

DBInstance New members:MasterDBInstanceId, ReadOnlyInstanceNum, StatusInReadonlyGroup

Existing Release

Release time: 2020-07-24 14:20:11

Existing APIs/data structures are as follows:

Improvement to existing documentation.

Existing APIs:

CloseDBExtranetAccess CreateDBInstances DescribeAccounts DescribeDBBackups DescribeDBErrlogs DescribeDBInstanceAttribute DescribeDBInstances DescribeDBSlowlogs DescribeDBXlogs DescribeDatabases DescribeOrders DescribeProductConfig DescribeRegions DescribeZones DestroyDBInstance InitDBInstances InquiryPriceCreateDBInstances InquiryPriceRenewDBInstance InquiryPriceUpgradeDBInstance ModifyAccountRemark ModifyDBInstanceName ModifyDBInstancesProject OpenDBExtranetAccess RenewInstance ResetAccountPassword RestartDBInstance SetAutoRenewFlag UpgradeDBInstance

Existing data structures:

AccountInfo DBBackup DBInstance DBInstanceNetInfo ErrLogDetail Filter NormalQueryItem PgDeal RegionInfo SlowlogDetail SpecInfo SpecItemInfo Xlog ZoneInfo Previous Topic: Test Results Next Topic: Introduction Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Release 34 Release 33 Release 32 Release 31 Release 30 Release 29 Release 28 Release 27 Release 26 Release 25 Release 24 Release 23 Release 22 Release 21 Release 20 Release 19 Release 18 Release 17 Release 16 Release 15 Release 14 Release 13 Release 12 Release 11 Release 10 Release 9 Release 8 Release 7 Release 6 Release 5 Release 4 Release 3 Release 2 Existing Release Search AllCurrent Product Search titles only Enter keywords to search documentation
