# Managing the Unified Audit Trail

Auditing is enabled by default, but you can control when audit records are written to disk.
- When and Where Are Audit Records Created? Auditing is always enabled. Oracle Database generates audit records during or after the execution phase of the audited SQL statements.
- Activities That Are Mandatorily Audited Certain security sensitive database activities are always audited and such audit configuration cannot be disabled.
- How Do Cursors Affect Auditing? For each execution of an auditable operation within a cursor, Oracle Database inserts one audit record into the audit trail.
- Writing the Unified Audit Trail Records to the AUDSYS Schema Oracle Database automatically writes audit records to an internal relational table in the AUDSYS schema.
- Writing the Unified Audit Trail Records to SYSLOG or the Windows Event Viewer You can write the unified audit trail records to SYSLOG or the Windows Event Viewer by setting an initialization parameter.
- When Audit Records Are Written to the Operating System In situations where the database table is unable to accept unified audit records, these records will be written to operating system spillover audit files (.bin format).
- Moving Operating System Audit Records into the Unified Audit Trail Audit records that have been written to the spillover audit files can be moved to the unified audit trail database table.
- Exporting and Importing the Unified Audit Trail Using Oracle Data Pump You can include the unified audit trail in Oracle Database Pump export and import dump files.
- Disabling Unified Auditing You can disable unified auditing.
1.md)
## When and Where Are Audit Records Created?
Auditing is always enabled. Oracle Database generates audit records during or after the execution phase of the audited SQL statements.
Oracle Database individually audits SQL statements inside PL/SQL program units, as necessary, when the program unit is run.
To improve read performance of the unified audit trail, the unified audit records are written immediately to disk to an internal relational table in the `AUDSYS` schema. In the previous release, the unified audit records were written to SecureFile LOBs. If you had migrated to unified auditing in Oracle Database 12*c* release 1 (12.1), then you can manually transfer the unified audit records from the SecureFile LOBS to this internal table. If the version of the database that you are using supports partitioned tables, then this internal table is a partitioned table. In this case, you can modify the partition interval of the table by using the `DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL` procedure. The partitioned version of this table is based on the `EVENT_TIMESTAMP` timestamp as a partition key with a default partition interval of one month. If the database version does not support partitioning, then the internal table is a regular, non-partitioned table.
The generation and insertion of an audit trail record is independent of the user transaction being committed. That is, even if a user transaction is rolled back, the audit trail record remains committed.
Statement and privilege audit options from unified audit policies that are in effect at the time a database user connects to the database remain in effect for the duration of the session. When the session is already active, setting or changing statement or privilege unified audit options does not take effect in that session. The modified statement or privilege audit options take effect only when the current session ends and a new session is created.
In contrast, changes to schema object audit options become immediately effective for current sessions.
By default, audit trail records are written to the `AUDSYS` schema in the `SYSAUX` tablespace. You can designate a different tablespace, including one that is encrypted, by using the `DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION` procedure.
## Activities That Are Mandatorily Audited
Certain security sensitive database activities are always audited and such audit configuration cannot be disabled.
The `UNIFIED_AUDIT_TRAIL` data dictionary view captures activities from administrative users such as `SYSDBA`, `SYSBACKUP`, and `SYSKM`. You do not need to audit the unified audit trail. The unified audit trail resides in a specialized table in the `AUDSYS` schema that only allows `INSERT` activity. Hence, DMLs are not permitted on the unified audit trail views. Even DML and DDL operations on the underlying dictionary tables from `AUDSYS` schema are not permitted.
Mandatorily audited activities will have audit policy by name `ORA$MANDATORY` in the `UNIFIED_AUDIT_POLICIES` column of the `UNIFIED_AUDIT_TRAIL` data dictionary view. The `ORA$MANDATORY` is always listed first in this column, if there are other unified audit policies that are tracking mandatorily audited activities.
The `SYSTEM_PRIVILEGE_USED` column shows the type of administrative privilege that was used for the activity.
**Mandatorily Audited Non-Audit-Related Activities**
  - ORADEBUG utility
**Mandatorily Audited Audit-Related Activities**
- CREATE AUDIT POLICY
- ALTER AUDIT POLICY
- DROP AUDIT POLICY
- AUDIT
- NOAUDIT
````
- EXECUTE of the DBMS_FGA PL/SQL package
````
- EXECUTE of the DBMS_AUDIT_MGMT PL/SQL package
**Note:**  When you run the DBMS_AUDIT_MGMT procedures directly, they are audited in both pure unified auditing and mixed mode auditing, even when you have not created a specific policy. However, when you execute the same procedures inside a DBMS_SCHEDULER job, then they are audited only in pure unified auditing, not in mixed mode auditing.
````
- ALTER TABLE attempts on the AUDSYS audit trail table (remember that this table cannot be altered)
````````````````````````
- Top level statements by the administrative users SYS, SYSDBA, SYSOPER, SYSASM, SYSBACKUP, SYSDG, and SYSKM, until the database opens. When the database opens, Oracle Database audits these users using the audit configurations in the system—not just the ones that were applied using the BY clause in the AUDIT statement, for example, but those that were applied for all users when AUDIT statement does not have a BY clause or when the EXCEPT clause was used and these users were not excluded.
````
- All user-issued DML statements on the SYS.AUD$ and SYS.FGA_LOG$ dictionary tables
- Any attempts to modify the data or metadata of the unified audit internal table. SELECT statements on this table are not audited by default or mandatorily.
- All configuration changes that are made to Oracle Database Vault
**Mandatorily Audited Access to Sensitive Columns in the Oracle Optimizer Dictionary Tables**
Be aware that internal access to these table columns by the `DBMS_STATS` package does not generate mandatory audit records. The optimizer dictionary tables are as follows:

| Optimizer Dictionary Table | Columns |
|---|---|
| SYS.HIST_HEAD$ | minimum, maximum, lowval, hival |
| SYS.HISTGRM$ | endpoint, epvalue_raw |
| SYS.WRI$_OPTSTAT_HISTHEAD_HISTORY | minimum, maximum, lowval, hival |
| SYS.WRI$_OPSTAT_HISTGRM_HISTORY | endpoint, epvalue_raw |

## How Do Cursors Affect Auditing?
For each execution of an auditable operation within a cursor, Oracle Database inserts one audit record into the audit trail.
Events that cause cursors to be reused include the following:
- An application, such as Oracle Forms, holding a cursor open for reuse
- Subsequent execution of a cursor using new bind variables
- Statements executed within PL/SQL loops where the PL/SQL engine optimizes the statements to reuse a single cursor
Auditing is *not* affected by whether or not a cursor is shared. Each user creates her or his own audit trail records on first execution of the cursor.
## Writing the Unified Audit Trail Records to the AUDSYS Schema
Oracle Database automatically writes audit records to an internal relational table in the `AUDSYS` schema.
In Oracle Database 12c release 1 (12.1), you had the option of queuing the audit records in memory (queued-write mode) and be written periodically to the `AUDSYS` schema audit table. However, starting with Oracle Database 12c release 2 (12.2), immediate-write mode and queued-write mode are deprecated. The parameters that controlled them (`UNIFIED_AUDIT_SGA_QUEUE_SIZE`, `DBMS_AUDIT_MGMT.AUDIT_TRAIL_IMMEDIATE_WRITE`, and` DBMS_AUDIT_MGMT.AUDIT_TRAIL_QUEUED_WRITE`), while still viewable, no longer have any functionality.
The new functionality of having audit records always written to a relational table in the `AUDSYS` schema prevents the risk of audit records being lost in the event of an instance crash or during a `SHUTDOWN ABORT` operation. The new functionality also improves the performance of the audit trail and the database as a whole.
If you have upgraded from Oracle Database 12c release 1 (12.1) and migrated to unified auditing in that release, then Oracle recommends that you use the `DBMS_AUDIT_MGMT.TRANSFER_UNIFIED_AUDIT_RECORDS` procedure to transfer the audit records as generated in the previous release to the `AUDSYS` audit internal table. *Oracle Database Upgrade Guide* provides information about transferring unified audit records after an upgrade.
## Writing the Unified Audit Trail Records to SYSLOG or the Windows Event Viewer
You can write the unified audit trail records to SYSLOG or the Windows Event Viewer by setting an initialization parameter.
- About Writing the Unified Audit Trail Records to SYSLOG or the Windows Event Viewer With this feature, you can copy some of the key unified audit fields to SYSLOG or the Windows Event Viewer.
- Enabling SYSLOG and Windows Event Viewer Captures for the Unified Audit Trail You can write a subset of unified audit trail records to the UNIX SYSLOG or to the Windows Event Viewer.
### About Writing the Unified Audit Trail Records to SYSLOG or the Windows Event Viewer
With this feature, you can copy some of the key unified audit fields to SYSLOG or the Windows Event Viewer.
Unlike traditional audit, only key fields of unified audit records in the `UNIFIED_AUDIT_TRAIL` data dictionary view are copied to SYSLOG. SYSLOG records in a unified audit environment provide proof of operational integrity.
You can configure this feature on both UNIX and Microsoft Windows systems. On Windows systems, you either enable it or disable it. If enabled, it writes the records to the Windows Event Viewer.
On UNIX systems, you can fine-tune the capture of unified audit trail records for SYSLOG to specify the facility where the SYSLOG records are sent and the severity level of the records (for example, `DEBUG` if it is capturing debugging-related messages).
The following table maps the names given to the unified audit records fields that are written to SYSLOG and the Windows Event Viewer to the corresponding column names in the `UNIFIED_AUDIT_TRAIL` view.

| Field Name | Column Name in UNIFIED_AUDIT_TRAIL | Column Type | Column Description |
|---|---|---|---|
| TYPE | AUDIT_TYPE | NUMBER | Type of the audit record |
| DBID | DBID | NUMBER | Database identifier |
| SESID | SESSION_ID | NUMBER | Session identifier |
| CLIENTID | CLIENT_IDENTIFIER | VARCHAR2 | Client identifier in the session |
| STMTID | STATEMENT_ID | NUMBER | Identifier for each statement run in the system |
| DBUSER | DB_USERNAME | VARCHAR2 | Session user |
| CURUSER | CURRENT_USER | VARCHAR2 | Effective user for the audited event |
| ACTION | ACTION | NUMBER | Action code of the audited event |
| RETCODE | RETURN_CODE | NUMBER | Return code for the audited event |
| SCHEMA | OBJECT_SCHEMA | VARCHAR2 | Schema name of the object |
| OBJNAME | OBJECT_NAME | VARCHAR2 | Name of the object |
| PDB_GUID | NULL (there are no columns in UNIFIED_AUDIT_TRAIL for this field) | VARCHAR2 | GUID of the container in which the unified audit record is generated |

### Enabling SYSLOG and Windows Event Viewer Captures for the Unified Audit Trail
You can write a subset of unified audit trail records to the UNIX SYSLOG or to the Windows Event Viewer.
````
- Locate the init.ora initialization file, which by default is in the $ORACLE_HOME/dbs directory.
````
````````````
```
UNIFIED_AUDIT_SYSTEMLOG = TRUE
```
  - On Windows, set UNIFIED_AUDIT_SYSTEMLOG to either TRUE or FALSE. TRUE writes the SYSLOG values to the Windows Event Viewer; FALSE disables the parameter. On Windows, the default is FALSE. For example:
```
UNIFIED_AUDIT_SYSTEMLOG = 'facility_clause.priority_clause'
```
**``````````
  - facility_clause refers to the facility to which you will write the audit trail records. Valid choices are USER and LOCAL. If you enter LOCAL, then optionally append 0–7 to designate a local custom facility for the SYSLOG records.
**````````````````
  - priority_clause refers to the type of warning in which to categorize the record. Valid choices are NOTICE, INFO, DEBUG, WARNING, ERR, CRIT, ALERT, and EMERG.
For example:
```
UNIFIED_AUDIT_SYSTEMLOG = 'LOCAL7.EMERG'
```
````````
``````
- On UNIX platforms, to write unified audit records to SYSLOG set the UNIFIED_AUDIT_COMMON_SYSTEMLOG parameter to either TRUE or FALSE in the init.ora file in the root. Setting UNIFIED_AUDIT_COMMON_SYSTEMLOG to TRUE writes predefined columns of unified audit records from common unified audit policies to SYSLOG. FALSE disables these columns from being written to SYSLOG. You cannot set this parameter in a pluggable database (PDB). There is no Windows equivalent of the UNIFIED_AUDIT_COMMON_SYSTEMLOG parameter.
````
```
local7.emerg /var/log/audit.log
```
- Add the audit file destination to the SYSLOG configuration file /etc/syslog.conf. For example, assuming you had set the UNIFIED_AUDIT_SYSTEMLOG to LOCAL7.EMERG, enter the following: This setting logs all emergency messages to the /var/log/audit.log file.
```
$/etc/rc.d/init.d/syslog restart
```
````
- Restart the SYSLOG logger. Now, all audit records will be captured in the file /var/log/audit.log through the syslog daemon.
- Log back in to the database instance.
```
SHUTDOWN IMMEDIATE
STARTUP
```
```
ALTER PLUGGABLE DATABASE pdb_name CLOSE IMMEDIATE;
ALTER PLUGGABLE DATABASE pdb_name OPEN;
```
- Restart the database. For example: If you set UNIFIED_AUDIT_SYSTEMLOG in a PDB, then close and reopen the PDB:
## When Audit Records Are Written to the Operating System
In situations where the database table is unable to accept unified audit records, these records will be written to operating system spillover audit files (`.bin` format).
The default locations for unified audit spillover `.bin` files are as follows:
****
- For pluggable databases (PDBs): $ORACLE_BASE/audit/$ORACLE_SID/PDB_GUID
****
- For non-consolidated databases, or for the CDB root: $ORACLE_BASE/audit/$ORACLE_SID/
The ability to write to the database table can fail in situations such as the following: the audit tablespace is offline, the tablespace is read-only, the tablespace is full, the database is read-only, and so on. The unified audit records will continue to be written to OS spillover files until the OS disk space becomes full. At this point, when there is no room in the OS for the audit records, user auditable transactions will fail with `ORA-02002 error while writing to audit trail` errors. To prevent this problem, Oracle recommends that you purge the audit trail on a regular basis.
## Moving Operating System Audit Records into the Unified Audit Trail
Audit records that have been written to the spillover audit files can be moved to the unified audit trail database table.
When the database is not writable (such as during database mounts), if the database is closed, or if it is read-only, then Oracle Database writes the audit records to these external files. The default location for these external files is the `$ORACLE_BASE/audit/$ORACLE_SID` directory.
You can load the files into the database by running the `DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES` procedure. Be aware that if you are moving a large number of operating system audit records in the external files, performance may be affected.
To move the audit records in these files to the `AUDSYS` schema audit table when the database is writable:
- Log into the database instance as a user who has been granted the AUDIT_ADMIN role. For example:
```
CONNECT aud_admin
Enter password: password
Connected.
```
```
In a multitenant environment, log into the CDB root with the `AUDIT_ADMIN` role. Before you can upgrade to the current release or Oracle Database, you must execute the `DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES` procedure from the CDB root to avoid losing operating system spillover files during the upgrade process.
For example:
```
```
CONNECT c##aud_admin
Enter password: password
Connected.
```
- Ensure that the database is open and writable. For a non-CDB architecture, to find if the database is open and writable, query the V$DATABASE view. For example, in a CDB environment:
```
SELECT NAME, OPEN_MODE FROM V$DATABASE;
NAME            OPEN_MODE
--------------- ----------
HRPDB           READ WRITE
```
```
In a multitenant environment, you can run the `show pdbs` command to find information about PDBs associated with the current instance.
```
  - Run the DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES procedure.
```
EXEC DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES;
```
  - In a multitenant environment, if you want to load individual PDB audit records, then log in to each PDB and run the DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES procedure again.
The audit records are loaded into the `AUDSYS` schema audit table immediately, and then deleted from the `$ORACLE_BASE/audit/$ORACLE_SID` directory.
If the session ID linked to the spillover files is owned by the PMON process, then the files can’t be loaded until the database is restarted.
## Exporting and Importing the Unified Audit Trail Using Oracle Data Pump
You can include the unified audit trail in Oracle Database Pump export and import dump files.
The unified audit trail is automatically included in either full database or partial database export and import operations using Oracle Data Pump. As part of the schema level export or import operation, Oracle Database does not include the audit policy’s metadata in the `SYS` schema during the export or import operation. Instead, use full export (`expdp`) or import (`impdp`) for the export and import of the metadata in unified audit policies.
For example, for a partial database export operation that does not use schema level export or import, if you wanted to export only the unified audit trail tables, then you could enter the following commands:
- In SQL*Plus, move any operating system audit records that have been written to the spillover audit files to the unified audit trail table. Doing so ensures that all records will be exported.
- From the operating system prompt, run the following command:
```
expdp system
full=y
directory=aud_dp_dir
logfile=audexp_log.log
dumpfile=audexp_dump.dmp
version=18.02.00.02.00
INCLUDE=AUDIT_TRAILS
Password: password
```
Next, you can import all the exported content by reading the export dump file. This operation imports only the unified audit trail tables.
```
impdp system
full=y
directory=aud_dp_dir
dumpfile=audexp_dump.dmp
logfile=audimp_log.log
Password: password
```
You do not need to perform any special configuration to achieve this operation. However, you must have the `EXP_FULL_DATABASE` role if you are performing the export operation and the `IMP_FULL_DATABASE` role if you are performing the import operation.
## Disabling Unified Auditing
You can disable unified auditing.
  - Log into the database instance as a user who has been granted the AUDIT_ADMIN role.
``````
  - Query the POLICY_NAME and ENABLED_OPT columns of the AUDIT_UNIFIED_ENABLED_POLICIES data dictionary view to find unified audit policies that are enabled.
  - Run the NOAUDIT POLICY statement to disable each enabled policy. For example, to disable a policy that had been applied to user psmith:
```
NOAUDIT POLICY audit_pol BY psmith;
```
````
- Connect as user SYS with the SYSOPER privilege.
```
CONNECT sys as sysoper
Enter password: password
```
```
In a multitenant environment, this command connects you to the root.
```
- Shut down the database. For example:
```
SHUTDOWN IMMEDIATE
```
```
In a multitenant environment, this command shuts down all PDBs in the CDB.
```
```
net stop OracleServiceSID
```
- On a Windows system, stop the OracleServiceSID process.
****  - UNIX systems: Run the following commands:
```
cd $ORACLE_HOME/rdbms/lib
make -f ins_rdbms.mk uniaud_off ioracle
```
```
- **Windows systems:** Rename the `%ORACLE_HOME%/bin/orauniaud19.dll` file to `%ORACLE_HOME%/bin/orauniaud19.dll.dbl`.
In a multitenant environment, these actions disable unified auditing in all PDBs in the CDB.
```
```
net start OracleServiceSID
```
- On a Windows system, before you restart the database, restart the OracleServiceSID process.
- In SQL*Plus, restart the database.
```
STARTUP
```
```
In a multitenant environment, this command restarts all PDBs in the CDB.
```
## Related Topics
  - [Purging Audit Trail Records](purging-audit-trail-records
  - Writing the Unified Audit Trail Records to the AUDSYS Schema
**- Oracle Database Upgrade Guide **- Oracle Database PL/SQL Packages and Types Reference
  - Auditing Administrative Users
**- Oracle Database Reference
  - Purging Audit Trail Records
  - Moving Operating System Audit Records into the Unified Audit Trail
  - About Mixed Mode Auditing
  - Disabling Unified Audit Policies
