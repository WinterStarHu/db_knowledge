# Purchase Consultation

> 来源: https://www.tencentcloud.com/document/product/238/47718

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Purchase Consultation Purchase Consultation Download Focus Mode Font Size Last updated: 2026-07-30 17:20:58 AI-Translated How to Choose a TencentDB for SQL Server Architecture?
TencentDB for SQL Server supports the single-node (formerly Basic Edition) architecture, two-node (formerly HA Edition/Cluster Edition) architecture, and multi-node architecture. To ensure the high availability of instances, it is recommended that you select the two-node (formerly HA Edition/Cluster Edition) architecture or multi-node architecture and adopt cross-AZ high availability deployment. If there is a strong dependency on the granting of the sysadmin permission, you can select the single-node (formerly Basic Edition) architecture and submit a ticket to apply to create an account with the sysadmin permission. The differences between these architectures are as follows:
Single-node (formerly Basic Edition): Single-node deployment, with storage-computing separation and 3-replica storage based on Premium Disk to prevent data loss.
Two-node (formerly HA Edition/Cluster Edition):
SQL Server 2008 R2, 2012, 2014, and 2016 Enterprise/Standard editions adopt the Database Mirroring high-availability replication solution, providing second-level automatic switchover and reliability with "zero" data loss.
SQL Server 2017, 2019 Enterprise/Standard, 2022, and 2025 Enterprise editions are built into high-performance, highly available, highly reliable, and easily maintainable SQL Server clusters using AlwaysOn technology.
Multi-node: It supports SQL Server 2017, 2019, 2022, and 2025 Enterprise editions, featuring a one-primary-multiple-secondary architecture. 2 to 5 secondary nodes can be deployed, and different secondary nodes can be deployed in different AZs, ensuring high availability and significantly enhancing the disaster recovery capability of the database.
For differences between architecture versions, see Product Architecture and Instance Types.
How to Choose the Architecture and Edition of TencentDB for SQL Server for Read-Only Requirements?
If read-only functionality is required, it is recommended to use the two-node (formerly HA Edition/Cluster Edition) SQL Server 2017 Enterprise, SQL Server 2019 Enterprise, SQL Server 2022 Enterprise, or SQL Server 2025 Enterprise editions, which provide more efficient and stable data synchronization. For details, see Read-Only Instance Overview and Read-Only Instance Specifications.
How Is the Performance of TencentDB for SQL Server?
TencentDB for SQL Server is categorized into the single-node architecture (formerly Basic Edition) and the primary/secondary two-node architecture (formerly HA Edition/Cluster Edition):
The single-node architecture (formerly Basic Edition - Premium Disk) supports a maximum TPM of 1.32 million.
The single-node architecture (formerly Basic Edition - Cloud SSD) supports a maximum TPM of 1.38 million.
The primary/replica two-node architecture (formerly HA Edition/Cluster Edition) supports a maximum TPM of 4.58 million.
For detailed performance, see Performance Test Report.
What Specifications Does TencentDB for SQL Server Support?
For specifications of TencentDB for SQL Server single-node (formerly Basic Edition), dual-node (formerly HA Edition/Cluster Edition), and multi-node primary instances, see Primary Instance Specification List. For specifications of read-only instances, see Read-Only Instance Specification List.
How to Choose a TencentDB for SQL Server Specification?
TencentDB for SQL Server specifications can be selected based on capacity and performance. Capacity is determined according to data storage requirements. For supported instance specifications, see Primary Instance Specification List and Read-Only Instance Specification List. For performance, see Performance Test Report.
What Regions Does TencentDB for SQL Server Support?
For regions and AZs supported by TencentDB for SQL Server, see Regions and AZs.
What Editions Does TencentDB for SQL Server Support?
For supported versions, see Engine and Versions.
How Is the Edition Compatibility of TencentDB for SQL Server?
Higher versions of TencentDB for SQL Server are backward compatible with lower versions, but lower versions are not forward compatible with higher versions. For example, the 2016 version can be upgraded or migrated to the 2019 version, but the 2019 version cannot be downgraded or migrated to the 2016 version.
What Features Does TencentDB for SQL Server Support?
The supported features vary across different series/editions of TencentDB for SQL Server. For details, see Feature Overview and Differences and Constraints and Limitations.
What Are the Feature Differences Among Different Editions of TencentDB for SQL Server?
For features supported and differences across various editions of TencentDB for SQL Server, see Feature Overview and Differences.
Is There a Limit on the Number of Databases for a TencentDB for SQL Server Instance? What Is the Maximum Number of Databases That Can Be Created?
In terms of performance for TencentDB for SQL Server, having too many databases can lead to a decline in instance performance, consuming resources such as worker threads. Moreover, exceeding the database creation quantity limit can easily cause primary/secondary synchronization exceptions. It is recommended that the number of databases created for a single instance should not surpass its upper limit. The number of databases that a single instance can handle is related to the instance's CPU core count. For the detailed computational formula of the maximum number of databases for each version, see Database Quantity.
Although you can also use SSMS to connect to an instance and create databases, and databases created via SSMS are automatically synchronized to the secondary node, it is recommended not to exceed the database creation quantity limit for each version. Exceeding the limit can easily cause primary/secondary synchronization exceptions.
Does TencentDB for SQL Server Support Real-Time Hot Standby?
TencentDB for SQL Server dual-node (formerly HA Edition/Cluster Edition) instances support real-time hot backup, featuring a one-primary-one-secondary architecture. Multi-node instances also support real-time hot backup, and allow the creation of one-primary-two-secondary, one-primary-three-secondary, one-primary-four-secondary, and one-primary-five-secondary architectures.
What Application Scenarios Is TencentDB for SQL Server Suitable For?
TencentDB for SQL Server is suitable for various application scenarios, such as industry tools, mobile office, gaming, healthcare, pharmaceuticals, media, internet, IoT, retail, e-commerce, logistics, insurance, securities, technical services, automotive, tourism, and finance. For details, see Application Scenarios.
What High Availability and Disaster Recovery Capabilities Does TencentDB for SQL Server Have?
TencentDB for SQL Server incorporates disaster recovery capabilities at various levels, including instance, server, data center, AZ, and region. This ensures that when disasters such as natural disasters, equipment failures, or human operational errors occur, the production system's business can continue to run uninterrupted while minimizing data loss.
Backup is the cornerstone of all disaster recovery efforts and the last line of defense for data high availability. TencentDB for SQL Server also provides comprehensive backup capabilities. The purpose is to recover data when the system data is completely corrupted, ensuring business recoverability as much as possible while minimizing the time required.
TencentDB for SQL Server provides instances with diverse architectures to ensure high availability:
Multi-node instances support SQL Server 2017/2019/2022/2025 Enterprise editions. They feature a one-primary-multiple-secondary architecture (with 2 to 5 secondary nodes), are deployed on physical servers at the bottom layer, and utilize AlwaysOn technology to build a high-performance, highly available, highly reliable, and easily maintainable SQL Server cluster, providing second-level HA automatic switch.
In dual-node (formerly HA Edition/Cluster Edition) instances, versions SQL Server 2008R2/2012/2014/2016 Enterprise feature a primary/secondary two-node architecture. They are deployed on physical servers at the bottom layer and adopt the database mirroring (Mirror) high-availability replication solution, providing second-level HA automatic switch.
In dual-node (formerly HA Edition/Cluster Edition) instances, versions SQL Server 2017/2019/2022/2025 Enterprise feature a primary/secondary two-node architecture. They are deployed on physical servers at the bottom layer and utilize AlwaysOn technology to build a high-performance, highly available, highly reliable, and easily maintainable SQL Server cluster, providing second-level HA automatic switch.
The single-node (formerly Basic Edition) instance has only one node, which is deployed on the CVM at the bottom layer and features storage-computing separation. The underlying Premium Cloud Disk three-replica storage can prevent data loss. In extreme cases, if the instance fails, a new instance will be started. The data in the original instance is then automatically restored to the new instance through backup recovery by combining data backup and the most recent log backup. The specific recovery time depends on the size of the data volume. Typically, the servers of the two database instances are on the same physical server.
For intra-city disaster recovery, the multi-AZ deployment capability is provided. The private networks between AZs are interconnected within the same region, and fault isolation can be achieved between AZs. For dual-node primary/secondary instances and multi-node instances, primary and secondary nodes can be distributed across different AZs within the same region (for example, one primary node in the primary AZ and one secondary node in the secondary AZ). This enhances business continuity to prevent database instance failures or AZ interruptions. Additionally, users can manually perform switch via the console to verify the robustness of the business. Switch within an AZ or between AZs is transparent to applications.
For off-site disaster recovery, cross-region backup capability is provided. This capability supports storing backup files in another region, allows you to configure the retention period for cross-region backups, and enables setting multiple backup regions simultaneously. After you enable the cross-region backup policy, the backup files of the instance are automatically backed up to the target region. If an instance in one region fails, you can use the backup files to restore it to a new instance in another region, thereby recovering the business. This achieves high availability for database recovery and meets requirements for data availability and security, off-site backup recovery, off-site disaster recovery, long-term data archiving, and compliance.
Meanwhile, TencentDB for SQL Server also provides comprehensive backup capabilities to ensure data security and prevent data loss or corruption. These capabilities include automatic backup, manual backup, data backup, log backup, single-database backup, packaged backup, instance backup, multi-database backup, custom backup policies, and customizable backup retention periods from 3 to 7300 days as well as customizable backup cycles.
In addition to building robust disaster recovery capabilities at the data layer, we have also established comprehensive disaster recovery capabilities at the management and control layer. Cross-region disaster recovery for databases is only valuable when accompanied by cross-region disaster recovery for the business. However, deploying the business across regions in a distributed manner inevitably introduces the split-brain problem. At the business management and control layer, our HA adopts a 3-AZ deployment, with 2 AZs in the same city and 1 AZ in a different city, to ensure stable and uninterrupted business operation. Furthermore, during an actual switch, the synchronization status of the database (the database synchronization system table) is checked to ensure it is normal, thereby preventing erroneous switches.
What Are the Product Advantages of TencentDB for SQL Server?
TencentDB for SQL Server is licensed by Microsoft, enabling it to continuously provide users with the latest features and mitigate the risk of using unauthorized software. It offers characteristics such as instant availability, stability, reliability, secure operation, and elastic scaling. Additionally, it features a high-availability architecture, data security safeguards, and second-level fault recovery, allowing users to focus on application development.
Diverse versions: 3 deployment architectures are provided, that is, single-node (formerly Basic Edition), dual-node (formerly HA Edition/Cluster Edition), and multi-node, fully ensuring the high availability of services.
Genuine license: TencentDB for SQL Server is licensed by Microsoft, enabling it to continuously provide users with the latest features, mitigate the risk of using unauthorized software, and make your enterprise more trustworthy in the competitive market.
Outstanding performance: The newly launched 90C720GB specification delivers a TPM of up to 4.5 million, with performance and cost-effectiveness improved by over 30% again, once more breaking the industry performance record previously held by Tencent Cloud itself.
Stability and reliability: It delivers 99.9996% data reliability and 99.99% service availability, and provides convenient cloud-based management and control capabilities such as monitoring and alarms, backup/recovery, data migration, and flexible scaling.
Easy management: Users do not need to worry about database installation and maintenance. They can easily perform various management tasks such as database management, permission configuration, and monitoring and alarms through the Tencent Cloud Management Console or SQL Server Management Studio (SSMS).
Monitoring and alarms: In the management console, you can view dozens of key metrics such as number of connections, number of requests, disk I/O, and buffer cache hit ratio. This provides comprehensive monitoring of database operation status, enabling you to accurately understand database load and system health. It also supports user-defined resource threshold alarms, helping Ops engineers promptly detect database exceptions, thereby allowing for quick response and resolution of potential system issues.
Business intelligence: It provides an SSIS + BI business intelligence analytics service that integrates data storage, extraction, loading, transformation, and visual analysis, helping customers solve problems across the entire chain in scenarios such as business intelligence analysis, high-value data mining, and master data management system construction.
What Advantages Does TencentDB for SQL Server Have Compared to Self-Built SQL Server Databases?
Compared with self-built databases, TencentDB for SQL Server offers the following advantages:
Feature

TencentDB for SQL Server

Self-Built SQL Server Database

Service availability.

See Service Level Agreement.

Requires self-guarantee, self-deployment of master-slave replication, self-construction of RAID, and so on

System security

Protects against DDoS attacks and promptly fixes various database security vulnerabilities. Data security complies with the full set of national and international security standards.

Requires self-deployment, incurs high costs, and necessitates self-repair of database security vulnerabilities. Security compliance cannot be guaranteed, making it difficult to meet security requirements within a short timeframe.

Database performance

High-performance hardware with excellent performance, supporting up to 4.5 million TPM. See Performance Test Report.

Uses general-purpose equipment with no performance optimization or tuning.

Software and hardware investment

No upfront investment in software or hardware, with pay-as-you-go pricing.

Database server costs are relatively high.

System hosting

No hosting fees.

Hosting costs are relatively high.

Deployment and scaling

Ready to use immediately, deploys rapidly, and scales elastically.

Requires hardware procurement, data center colocation, machine deployment, and other tasks. Requires self-resolution of stability issues and the construction of numerous supporting modules and management tools. Involves substantial technical investment and a long implementation cycle.

Resource utilization

Bills based on actual usage, scales elastically, and achieves high resource utilization.

Requires planning for peak loads, resulting in low resource utilization.

Data disaster recovery

Configures master-slave replication and backups by default, and supports disaster recovery solutions such as multi-AZ deployment and cross-region backup for both local and remote scenarios.

Requires self-implementation, including finding backup storage space and periodically verifying whether backups are recoverable, which incurs additional costs in both money and time.

Management service

Comprehensive cloud-based management features, including complete instance lifecycle management, monitoring and alarms, backup/recovery, and management of instances, databases, accounts, networks, parameters, logs, and so on.

All management and control capabilities must be built by the user.

Procurement cost

Instance pricing is transparent and more cost-effective than purchasing a CVM.

Requires self-construction of disaster recovery, monitoring, management, and other capabilities beyond the instance itself, and this cost is entirely uncontrollable.

License

Licensed by Microsoft, continuously provides users with the latest features, and requires no additional License purchase.

Using pirated software carries legal risks, while genuine licenses are expensive.

Ops cost

No user Ops required. Tencent Cloud provides 7*24 premium service support for enterprise customers through a professional team.

Requires hiring dedicated DBAs for maintenance, incurring substantial labor costs.
How to Migrate Data to TencentDB for SQL Server TencentDB for SQL Server supports migration from self-built instances in local IDCs, self-built instances on Tencent Cloud CVMs, self-built instances on other cloud providers' cloud servers, cloud databases from other cloud providers, and Tencent Cloud cloud databases. It supports two migration methods: cold backup migration and data migration using DTS. You can select the migration method suitable for your business scenario.
If your service allows downtime for backup, you can use cold backup migration. This method migrates the source database to TencentDB for SQL Server by restoring data from .bak backup files. It supports migrating data to TencentDB for SQL Server via COS files or local file uploads, and offers three recovery modes: full backup files, full backup files + log backups, and full backup files + differential backups.
If your service does not allow downtime and requires a smooth migration without interruption, you can use DTS to migrate data. This method supports two migration types: full migration and full + incremental migration. It also supports multiple access types, including public network, self-built on cloud hosts, Direct Connect, VPN, CCN, and cloud databases.
Previous Topic: FAQ Overview Next Topic: Billing and Purchase Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How to Choose a TencentDB for SQL Server Architecture?
How to Choose the Architecture and Edition of TencentDB for SQL Server for Read-Only Requirements?
How Is the Performance of TencentDB for SQL Server?
What Specifications Does TencentDB for SQL Server Support?
How to Choose a TencentDB for SQL Server Specification?
What Regions Does TencentDB for SQL Server Support?
What Editions Does TencentDB for SQL Server Support?
How Is the Edition Compatibility of TencentDB for SQL Server?
What Features Does TencentDB for SQL Server Support?
What Are the Feature Differences Among Different Editions of TencentDB for SQL Server?
Is There a Limit on the Number of Databases for a TencentDB for SQL Server Instance? What Is the Maximum Number of Databases That Can Be Created?
Does TencentDB for SQL Server Support Real-Time Hot Standby?
What Application Scenarios Is TencentDB for SQL Server Suitable For?
What High Availability and Disaster Recovery Capabilities Does TencentDB for SQL Server Have?
What Are the Product Advantages of TencentDB for SQL Server?
What Advantages Does TencentDB for SQL Server Have Compared to Self-Built SQL Server Databases?
How to Migrate Data to TencentDB for SQL Server Search AllCurrent Product Search titles only Enter keywords to search documentation
