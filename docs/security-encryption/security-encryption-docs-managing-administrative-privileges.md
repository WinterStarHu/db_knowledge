# Managing Administrative Privileges

Administrative privileges can be used for both general and specific database operations.
- About Administrative Privileges For better separation of duty, Oracle Database provides administrative privileges that are tailored for commonly performed specific administrative tasks.
- Grants of Administrative Privileges to Users As with all powerful privileges, only grant administrative privileges to trusted users.
````
- SYSDBA and SYSOPER Privileges for Standard Database Operations The SYSDBA and SYSOPER administrative privileges enable you to perform standard database operations.
````
- Forcing oracle Users to Enter a Password When Logging in as SYSDBA You can force an oracle user to enter a password when the user logs in to an Oracle database using the SYSDBA administrative privilege.
- SYSBACKUP Administrative Privilege for Backup and Recovery Operations The SYSBACKUP administrative privilege is used to perform backup and recovery operations from either Oracle Recovery Manager (RMAN) and or through SQL*Plus.
````
- SYSDG Administrative Privilege for Oracle Data Guard Operations You can log in as user SYSDG with the SYSDG administrative privilege to perform Data Guard operations.
````
- SYSKM Administrative Privilege for Transparent Data Encryption The SYSKM administrative privilege enables the SYSKM user to manage Transparent Data Encryption (TDE) wallet operations.
- SYSRAC Administrative Privilege for Oracle Real Application Clusters The SYSRAC administrative privilege is used by the Oracle Real Application Clusters (Oracle RAC) Clusterware agent.
## About Administrative Privileges
For better separation of duty, Oracle Database provides administrative privileges that are tailored for commonly performed specific administrative tasks.
These tasks include operations for backup and recovery, Oracle Data Guard, and encryption key management for Transparent Data Encryption (TDE).
You can find the administrative privileges that a user has by querying the `V$PWFILE_USERS` dynamic view, which lists users in the password file.
In previous releases, you needed to have the `SYSDBA` administrative privilege to perform these tasks. To support backward compatibility, you still can use the `SYSDBA` privilege for these tasks, but Oracle recommends that you use the administrative privileges described in this section.
Users who have been granted administrative privileges can be altered to be schema-only accounts.
The use of administrative privileges is mandatorily audited.
## Grants of Administrative Privileges to Users
As with all powerful privileges, only grant administrative privileges to trusted users.
However, be aware that there is a restriction for users whose names have non-ASCII characters (for example, the umlaut in the name `HÃœBER`). You can grant administrative privileges to these users, but if the Oracle database instance is down, the authentication using the granted privilege is not supported if the user name has non-ASCII characters. If the database instance is up, then the authentication is supported.
## SYSDBA and SYSOPER Privileges for Standard Database Operations
The `SYSDBA` and `SYSOPER` administrative privileges enable you to perform standard database operations.
These database operations can include tasks such as database startups and shutdowns, creating the server parameter file (`SPFILE`), or altering the database archive log. In a multitenant environment, you can grant the `SYSDBA` and `SYSOPER` administrative privileges to application common users (but not to CDB common users).
You can find if a user has been granted an administrative privilege on a local (PDB) level, for a CDB root, or for an application root by querying the `SCOPE` column of the `V$PWFILE_USERS` dynamic view.
You can grant the `SYSDBA` or `SYSOPER` administrative privilege to users who have been created with no authentication.
## Forcing oracle Users to Enter a Password When Logging in as SYSDBA
You can force an `oracle` user to enter a password when the user logs in to an Oracle database using the `SYSDBA` administrative privilege.
- Edit the $ORACLE_HOME/network/admin/sqlnet.ora file.
```
sqlnet.authentication_services=none
```
````
- Set the SQLNET.AUTHENTICATION_SERVICES parameter as follows: If SQLNET.AUTHENTICATION_SERVICES is not set, then it defaults to ALL.
## SYSBACKUP Administrative Privilege for Backup and Recovery Operations
The `SYSBACKUP` administrative privilege is used to perform backup and recovery operations from either Oracle Recovery Manager (RMAN) and or through SQL*Plus.
To connect to the database as `SYSBACKUP` using a password, you must create a password file for it. See *Oracle Database Administrator’s Guide* for more information about creating password files.
You cannot grant the `SYSBACKUP` administrative privilege to users who have been created with no authentication.
This privilege enables you to perform the following operations:
- STARTUP
- SHUTDOWN
- ALTER DATABASE
- ALTER SYSTEM
- ALTER SESSION
- ALTER TABLESPACE
- CREATE CONTROLFILE
- CREATE ANY DIRECTORY
- CREATE ANY TABLE
- CREATE ANY CLUSTER
- CREATE PFILE
````
- CREATE RESTORE POINT (including GUARANTEED restore points)
- CREATE SESSION
- CREATE SPFILE
- DROP DATABASE
- DROP TABLESPACE
````
- DROP RESTORE POINT (including GUARANTEED restore points)
- FLASHBACK DATABASE
- RESUMABLE
- UNLIMITED TABLESPACE
- SELECT ANY DICTIONARY
- SELECT ANY TRANSACTION
  - X$ tables (that is, the fixed tables)
````
  - V$ and GV$ views (that is, the dynamic performance views)
  - APPQOSSYS.WLM_CLASSIFIER_PLAN
  - SYSTEM.LOGSTDBY$PARAMETERS
````
  - SYS.APPLY$_SOURCE_SCHEMA
  - SYSTEM.LOGSTDBY$PARAMETERS
  - SYS.DBMS_BACKUP_RESTORE
  - SYS.DBMS_RCVMAN
  - SYS.DBMS_DATAPUMP
  - SYS.DBMS_IR
  - SYS.DBMS_PIPE
  - SYS.SYS_ERROR
  - SYS.DBMS_TTS
  - SYS.DBMS_TDB
  - SYS.DBMS_PLUGTS
  - SYS.DBMS_PLUGTSP
- SELECT_CATALOG_ROLE
In addition, the `SYSBACKUP` privilege enables you to connect to the database even if the database is not open.
## SYSDG Administrative Privilege for Oracle Data Guard Operations
You can log in as user `SYSDG` with the `SYSDG` administrative privilege to perform Data Guard operations.
You can use this privilege with either Data Guard Broker or the `DGMGRL` command-line interface. In order to connect to the database as `SYSDG` using a password, you must create a password file for it.
You cannot grant the `SYSYSDG` administrative privilege to users who have been created with no authentication.
The `SYSDG` privilege enables the following operations:
- STARTUP
- SHUTDOWN
- ALTER DATABASE
- ALTER SESSION
- ALTER SYSTEM
````
- CREATE RESTORE POINT (including GUARANTEED restore points)
- CREATE SESSION
````
- DROP RESTORE POINT (including GUARANTEED restore points)
- FLASHBACK DATABASE
- SELECT ANY DICTIONARY
  - X$ tables (that is, the fixed tables)
````
  - V$ and GV$ views (that is, the dynamic performance views)
  - APPQOSSYS.WLM_CLASSIFIER_PLAN
  - APPQOSSYS.WLM_CLASSIFIER_PLAN
  - SYS.DBMS_DRS
In addition, the `SYSDG` privilege enables you to connect to the database even if it is not open.
## SYSKM Administrative Privilege for Transparent Data Encryption
The `SYSKM` administrative privilege enables the `SYSKM` user to manage Transparent Data Encryption (TDE) wallet operations.
In order to connect to the database as `SYSKM` using a password, you must create a password file for it.
You cannot grant the `SYSKM` administrative privilege to users who have been created with no authentication.
The `SYSKM` administrative privilege enables the following operations:
- ADMINISTER KEY MANAGEMENT
- CREATE SESSION
  - SYS.V$ENCRYPTED_TABLESPACES
  - SYS.V$ENCRYPTION_WALLET
  - SYS.V$WALLET
  - SYS.V$ENCRYPTION_KEYS
  - SYS.V$CLIENT_SECRETS
  - SYS.DBA_ENCRYPTION_KEY_USAGE
In addition, the `SYSKM` privilege enables you to connect to the database even if it is not open.
## SYSRAC Administrative Privilege for Oracle Real Application Clusters
The `SYSRAC` administrative privilege is used by the Oracle Real Application Clusters (Oracle RAC) Clusterware agent.
The `SYSRAC` administrative privilege provides only the minimal privileges necessary for performing day-to-day Oracle RAC operations. For example, this privilege is used for Oracle RAC utilities such as `SRVCTL`.
You cannot grant the `SYSRAC` administrative privilege to users who have been created with no authentication.
The `SYSRAC` administrative privilege enables the following operations:
- STARTUP
- SHUTDOWN
- ALTER DATABASE MOUNT
- ALTER DATABASE OPEN
- ALTER DATABASE OPEN READ ONLY
- ALTER DATABASE CLOSE NORMAL
- ALTER DATABASE DISMOUNT
- ALTER SESSION SET EVENTS
- ALTER SESSION SET _NOTIFY_CRS
- ALTER SESSION SET CONTAINER
- ALTER SYSTEM REGISTER
- ALTER SYSTEM SET local_listener|remote_listener|listener_networks
In addition to these privileges, the `SYSRAC` user will have access to the following views:
- V$PARAMETER
- V$DATABASE
- V$PDBS
- CDB_SERVICE$
- DBA_SERVICES
- V$ACTIVE_SERVICES
- V$SERVICES
The `SYSRAC` user is also granted the `EXECUTE` privilege for the following PL/SQL packages:
- DBMS_DRS
- DBMS_SERVICE
- DBMS_SERVICE_PRVT
- DBMS_SESSION
- DBMS_HA_ALERTS_PRVT
- Dequeue messaging SYS.SYS$SERVICE_METRICS
## Related Topics
  - Auditing Administrative Users
**- Oracle Database Backup and Recovery User’s Guide for more information about backup and recovery operations **- Oracle Database Administrator’s Guide for more information about creating password files **- Oracle Data Guard Concepts and Administration for more information about Oracle Data Guard **- Oracle Database Advanced Security Guide for more information about Transparent Data Encryption **- Oracle Real Application Clusters Administration and Deployment Guide
