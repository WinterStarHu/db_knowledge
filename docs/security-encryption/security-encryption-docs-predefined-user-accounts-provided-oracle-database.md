# Predefined Schema User Accounts Provided by Oracle Database

The Oracle Database installation process creates predefined administrative, non-administrative, and sample schema user accounts in the database.
- About the Predefined Schema User Accounts The predefined schema accounts are either created automatically when you run standard Oracle scripts or they are accounts that represent a fictional company.
- Predefined Administrative Accounts A default Oracle Database installation provides predefined administrative accounts to manage commonly used features, such as auditing.
- Predefined Non-Administrative User Accounts A default Oracle Database installation provides non-administrative user accounts to manage features such as Oracle Spatial.
- Predefined Sample Schema User Accounts Oracle Database creates a set of sample user accounts if you install the sample schemas.
## About the Predefined Schema User Accounts
The predefined schema accounts are either created automatically when you run standard Oracle scripts or they are accounts that represent a fictional company.
The predefined schema accounts are in two categories:
````````````
- The predefined administrative and non-administrative schema accounts are created automatically when you run standard scripts such as the various cat.*sql scripts. You can find these accounts by querying the USERNAME and ORACLE_MAINTAINED columns of the ALL_USERS data dictionary view. If the output for ORACLE_MAINTAINED is Y, then you must not modify the user account except by running the script that was used to create it.
``````````````````
- The HR sample schema user account is installed by default. A set of additional schema user accounts (OE, PM, IX, and SH, along with HR) is available on GitHub. These schema accounts represent different divisions of a fictional company that manufactures various products. You can find the status of these accounts by querying the DBA_USERS data dictionary view. Because the ORACLE_MAINTAINED column output for these accounts is N, you can modify these accounts without re-running the scripts that were used to create them.
By default, most of these accounts are authenticated as schema only accounts, except for the sample schema accounts, which are locked and expired during the database installation process. When using these accounts, you can configure them to be authenticated in other ways (such as with password authentication), but Oracle recommends that for better security, to keep these accounts as schema only accounts.
## Predefined Administrative Accounts
A default Oracle Database installation provides predefined administrative accounts to manage commonly used features, such as auditing.
These are accounts that have special privileges required to administer areas of the database, such as the `CREATE ANY TABLE` or `ALTER SESSION` privilege, or `EXECUTE` privileges on packages owned by the `SYS` schema. The default tablespace for administrative accounts is either `SYSTEM` or `SYSAUX`. In a multitenant environment, the predefined administrative accounts reside in the root database.
To protect these accounts from unauthorized access, the installation process expires and locks most of these accounts, except where noted in the following list. As the database administrator, you are responsible for unlocking and resetting these accounts.
The following list describes the predefined administrative user accounts, which Oracle Database automatically creates when you run standard scripts (such as the various `cat`*`.sql` scripts). You can find a complete list of user accounts that are created and maintained by Oracle by querying the `USERNAME` and `ORACLE_MAINTAINED` columns of the `ALL_USERS` data dictionary view. If the output for `ORACLE_MAINTAINED` is `Y`, then you must not modify the user account except by running the script that was used to create it.
To find the status of an account, such as whether it is open, locked, or expired, query the `ACCOUNT_STATUS` column of the `DBA_USERS` data dictionary view. If the account is schema only, then the status is `NONE`.
Predefined Oracle Database Administrative User Accounts
````
- ANONYMOUS: An account that allows HTTP access to Oracle XML DB. It is used in place of the APEX_PUBLIC_USER account when the Embedded PL/SQL Gateway (EPG) is installed in the database. EPG is a Web server that can be used with Oracle Database. It provides the necessary infrastructure to create dynamic applications.
- APPQOSSYS: Used for storing and managing all data and metadata required by Oracle Quality of Service Management.
- AUDSYS: The internal account used by the unified audit feature to store unified audit trail records. See When and Where Are Audit Records Created?.
**
- CTXSYS: The account used to administer Oracle Text. Oracle Text enables you to build text query applications and document classification applications. It provides indexing, word and theme searching, and viewing capabilities for text. See Oracle Text Application Developer’s Guide.
**
- DBSNMP: The account used by the Management Agent component of Oracle Enterprise Manager to monitor and manage the database. See Enterprise Manager Cloud Control Administrator’s Guide.
````**
- DBSFWUSER: The account used to run the DBMS_SFW_ACL_ADMIN package. See Oracle Database PL/SQL Packages and Types Reference.
**
- DVF: The account owned by Oracle Database Vault that contains public functions to retrieve Database Vault factor values. See Oracle Database Vault Administrator’s Guide.
``````**
- DVSYS: Oracle Database Vault account that is associated with the DV_OWNER (for administrative configurations) and DV_ACCTMGR (for account management) roles. See Oracle Database Vault Administrator’s Guide.
**
- GGSYS: The internal account used by Oracle GoldenGate. It should not be unlocked or used for a database login. See Oracle Database Global Data Services Concepts and Administration Guide.
**
- GSMADMIN_INTERNAL: The internal account that owns the Global Data Services schema. It should not be unlocked or used for a database login. See Oracle Database Global Data Services Concepts and Administration Guide.
**
- GSMCATUSER: The account used by Global Service Manager to connect to the Global Data Services catalog. See Oracle Database Global Data Services Concepts and Administration Guide.
````````
- GSMROOTUSER: An account that is used to log into CDB$ROOT for CDBs in a sharding configuration. This user is not used in GDS configurations. Any connections to CDB$ROOT in a CDB are with GSMROOTUSER.
**
- GSMUSER: The account used by Global Service Manager to connect to the database. See Oracle Database Global Data Services Concepts and Administration Guide.
**
- LBACSYS: The account used to administer Oracle Label Security (OLS). It is created only when you install the Label Security custom option. See Oracle Label Security Administrator’s Guide.
**
- MDSYS: The Oracle Spatial and Oracle Multimedia Locator administrator account. See Oracle Spatial and Graph Developer’s Guide.
**
- OJVMSYS: The account that is used with the Java Naming and Directory Interface (JNDI) support with Oracle JVM support. This account owns database tables that store the following details about JVM objects: namespace metadata, bound names, attributes, permissions, and stored object representations. See Oracle Database Java Developer’s Guide.
- OLAPSYS: The account that owns the OLAP Catalog (CWMLite). This account has been deprecated, but is retained for backward compatibility.
**
- ORDDATA: This account contains the Oracle Multimedia DICOM data model. See Oracle Multimedia DICOM Developer’s Guide for more information.
**
- ORDPLUGINS: The Oracle Multimedia user. Plug-ins supplied by Oracle and third-party format plug-ins are installed in this schema. Oracle Multimedia enables Oracle Database to store, manage, and retrieve images, audio, video, DICOM format medical images and other objects, or other heterogeneous media data integrated with other enterprise information. See Oracle Multimedia User’s Guide.
**
- ORDSYS: The Oracle Multimedia administrator account. See Oracle Multimedia User’s Guide.
````
- OUTLN: The account that supports plan stability. Plan stability enables you to maintain the same execution plans for the same SQL statements. OUTLN acts as a role to centrally manage metadata associated with stored outlines.
**
- REMOTE_SCHEDULER_AGENT: The account to disable remote jobs on a database. This account is created during the remote scheduler agent configuration. You can disable the capability of a database to run remote jobs by dropping this user. See Oracle Database Administrator’s Guide.
********
- SI_INFORMTN_SCHEMA: The account that stores the information views for the SQL/MM Still Image Standard. See Oracle Multimedia User’s Guide. Note: The SI_INFORMTN_SCHEMA account is deprecated in Oracle Database 12c release 2 (12.2).
**
- SYS: An account used to perform database administration tasks. See Oracle Database 2 Day DBA.
**
- SYS$UMF: The account used to administer Remote Management Framework, including the remote Automatic Workload Repository (AWR). See Oracle Database Performance Tuning Guide.
**
- SYSBACKUP: The account used to perform Oracle Recovery Manager recovery and backup operations. See Oracle Database Backup and Recovery User’s Guide.
**
- SYSDG: The account used to perform Oracle Data Guard operations. See Oracle Data Guard Concepts and Administration.
**
- SYSKM: The account used to manage Transparent Data Encryption. See Oracle Database Advanced Security Guide.
**
- SYSRAC: The account used to manage Oracle Real Application Clusters. See Oracle Real Application Clusters Administration and Deployment Guide.
````**
- SYSTEM: A default generic database administrator account for Oracle databases. For production systems, Oracle recommends creating individual database administrator accounts and not using the generic SYSTEM account for database administration operations. See Oracle Database 2 Day DBA.
**
- WMSYS: The account used to store the metadata information for Oracle Workspace Manager. See Oracle Database Workspace Manager Developer’s Guide.
````**
- XDB: The account used for storing Oracle XML DB data and metadata. For better security, never unlock the XDB user account. Oracle XML DB provides high-performance XML storage and retrieval for Oracle Database data. See Oracle XML DB Developer’s Guide.
**Note:** If you create an Oracle Automatic Storage Management (Oracle ASM) instance, then the `ASMSNMP` account is created. Oracle Enterprise Manager uses this account to monitor ASM instances to retrieve data from ASM-related data dictionary views. The `ASMSNMP` account status is set to `OPEN` upon creation, and it is granted the `SYSDBA` administrative privilege.
## Predefined Non-Administrative User Accounts
A default Oracle Database installation provides non-administrative user accounts to manage features such as Oracle Spatial.
The following table lists the predefined non-administrative user accounts that Oracle Database automatically creates when you run standard scripts (such as the various `cat`*`.sql` scripts). You can find a complete list of user accounts that are created and maintained by Oracle by querying the `USERNAME` and `ORACLE_MAINTAINED` columns of the `ALL_USERS` data dictionary view. If the output for `ORACLE_MAINTAINED` is `Y`, then you must not modify the user account except by running the script that was used to create it.
Non-administrative user accounts only have the minimum privileges needed to perform their jobs. Their default tablespace is `USERS`. In a multitenant environment, the predefined non-administrative accounts reside in the root database
To protect these accounts from unauthorized access, the installation process locks and expires these accounts immediately after installation, except where noted in the following table. As the database administrator, you are responsible for unlocking and resetting these accounts.
To find the status of an account, such as whether it is open, locked, or expired, query the `ACCOUNT_STATUS` column of the `DBA_USERS` data dictionary view. If the account is schema only, then the status is `NONE`.

| User Account | Description |
|---|---|
| DIP | The Oracle Directory Integration and Provisioning (DIP) account that is installed with Oracle Label Security. This profile is created automatically as part of the installation process for Oracle Internet Directory-enabled Oracle Label Security. See Oracle Label Security Administrator’s Guide. |
| MDDATA | The schema used by Oracle Spatial for storing Geocoder and router data. Oracle Spatial provides a SQL schema and functions that enable you to store, retrieve, update, and query collections of spatial features in an Oracle database. See Oracle Spatial and Graph Developer’s Guide. |
| ORACLE_OCM | The account used with Oracle Configuration Manager. This feature enables you to associate the configuration information for the current Oracle Database instance with My Oracle Support. Then when you log a service request, it is associated with the database instance configuration information. See Oracle Database Installation Guide for your platform. |
| XS$NULL | An internal account that represents the absence of database user in a session and the actual session user is an application user supported by Oracle Real Application Security. XS$NULL has no privileges and does not own any database object. No one can authenticate as XS$NULL, nor can authentication credentials ever be assigned to XS$NULL. |

## Predefined Sample Schema User Accounts
Oracle Database creates a set of sample user accounts if you install the sample schemas.
The sample schema user accounts are all non-administrative accounts, and their tablespace is `USERS`.
To protect these accounts from unauthorized access, the installation process locks and expires these accounts immediately after installation. As the database administrator, you are responsible for unlocking and resetting these accounts.
The following table lists the sample schema user accounts, which represent different divisions of a fictional company that manufactures various products. You can find the status of these accounts by querying the `DBA_USERS` data dictionary view. Because the `ORACLE_MAINTAINED` column output for these accounts is `N`, you can modify these accounts without re-running the scripts that were used to create them.
To find the status of an account, such as whether it is open, locked, or expired, query the `ACCOUNT_STATUS` column of the `DBA_USERS` data dictionary view. If the account is schema only, then the status is `NONE`.

| User Account | Description |
|---|---|
| HR | The account used to manage the HR (Human Resources) schema. This schema stores information about the employees and the facilities of the company. |
| OE | The account used to manage the OE (Order Entry) schema. This schema stores product inventories and sales of the company’s products through various channels. |
| PM | The account used to manage the PM (Product Media) schema. This schema contains descriptions and detailed information about each product sold by the company. |
| IX | The account used to manage the IX (Information Exchange) schema. This schema manages shipping through business-to-business (B2B) applications. |
| SH | The account used to manage the SH (Sales) schema. This schema stores business statistics to facilitate business decisions. |

In addition to the sample schema accounts, Oracle Database provides another sample schema account, `SCOTT`. The `SCOTT` schema contains the tables `EMP`, `DEPT`, `SALGRADE`, and `BONUS`. The `SCOTT` account is used in examples throughout the Oracle Database documentation set. When you install Oracle Database, the `SCOTT` account is locked and expired.
## Related Topics
  **- Oracle Database Sample Schemas
  - Schema-Only Accounts
  **- Oracle Database Sample Schemas
