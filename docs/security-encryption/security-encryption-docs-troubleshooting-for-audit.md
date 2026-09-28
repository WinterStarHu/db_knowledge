# Troubleshooting for Audit

Use these troubleshooting topics to resolve common Oracle Database auditing and audit trail management issues.
## Oracle Database Audit Data Management: Resolving Common Issues
The following are common questions and issues encountered configuring Traditional Audit or Pure Unified Audit in Oracle Database.
### How to Recreate the SYS.AUD$ Table
Follow the action plan in: How to Rebuild the AUD$ Table When it is Corrupted (KB141619)
### Export/Import Unified Audit Trail
To export (including spillover files):
```
BEGIN
```
```
 /
```
- Load spillover files into AUDSYS.AUD$UNIFIED. sql BEGIN DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES; DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES; END; END; /
```
expdp system/password full=y directory=AUD_DP_DIR \
```
```
 INCLUDE=AUDIT_TRAIL
```
- Export audit trails only. sql expdp system/password full=y directory=AUD_DP_DIR \ dumpfile=audexp_dump.dmp logfile=audexp_log.log dumpfile=audexp_dump.dmp logfile=audexp_log.log \ INCLUDE=AUDIT_TRAIL
To import, run:
```
impdp system/password full=y directory=AUD_DP_DIR \
 dumpfile=audexp_dump.dmp logfile=audimp_log.log
```
### How to Use `CLIENT_IDENTIFIER` in Unified Audit Trail for Logons
### How to Use `CLIENT_IDENTIFIER` in Unified Audit Trail for Logons
```
CREATE AUDIT POLICY LOG_ON_OFF ACTIONS LOGON, LOGOFF;
```
```
 AUDIT POLICY LOG_ON_OFF;
```
- Create and enable audit policy for logon/logoff. sql CREATE AUDIT POLICY LOG_ON_OFF ACTIONS LOGON, LOGOFF; AUDIT POLICY LOG_ON_OFF;
```
BEGIN
```
```
 END;
```
- In your application, set client identifier after connect. sql BEGIN SYS.DBMS_SESSION.SET_IDENTIFIER(:end_user_id); SYS.DBMS_SESSION.SET_IDENTIFIER(:end_user_id); END;
```
BEGIN
```
```
 END;
```
- Optionally set module/action. sql BEGIN DBMS_APPLICATION_INFO.SET_MODULE(:module, :action); DBMS_APPLICATION_INFO.SET_MODULE(:module, :action); END;
```
SELECT event_timestamp, dbusername, client_identifier, action_name
```
```
 ORDER BY event_timestamp DESC;
```
- Verify. sql SELECT event_timestamp, dbusername, client_identifier, action_name FROM unified_audit_trail FROM unified_audit_trail WHERE client_identifier IS NOT NULL WHERE client_identifier IS NOT NULL ORDER BY event_timestamp DESC;
**Note:**
  - LOGON rows won’t show CLIENT_IDENTIFIER unless using proxy authentication
  - CLIENT_IDENTIFIER is limited to 64 bytes
  - On 19c, CLIENT_IDENTIFIER is not populated for FGA audit rows (known issue)
### `.aud` Files Generated in `AUDIT_FILE_DEST` Even After Setting `AUDIT_TRAIL=DB`
This is expected behavior.
Oracle still writes OS `.aud` files for mandatory auditing (startup, shutdown, `SYSDBA/SYSOPER` logins);
Oracle still writes OS `.aud` files for mandatory auditing (startup, shutdown, `SYSDBA/SYSOPER` logins);
Also, `SYS` activity when `AUDIT_SYS_OPERATIONS=TRUE` Also, `SYS` activity when `AUDIT_SYS_OPERATIONS=TRUE` Verify the current settings
```
SHOW PARAMETER audit_trail;
 SHOW PARAMETER audit_sys_operations;
 SHOW PARAMETER audit_file_dest;
```
To stop SYS activity going to .aud files (requires restart):
```
ALTER SYSTEM SET AUDIT_SYS_OPERATIONS=FALSE SCOPE=SPFILE;
```
To relocate audit files only:
```
ALTER SYSTEM SET AUDIT_FILE_DEST='/path/to/adump' DEFERRED;
```
This requires database instance restart to be effective.
**Note:** Mandatory auditing cannot be disabled.
### How to Exclude an Application Schema from a DML Audit Policy
Direct schema exclusion is not supported in Unified Auditing 19c.
Use these workarounds:
Option 1: Exclude activities of a specific user.
```
AUDIT POLICY dml_pol EXCEPT app_user;
```
Option 2: Generate per-object policies excluding the application schema.
```
SELECT 'begin execute immediate q''[create audit policy DML_'

 ||owner||'_'||table_name
 ||' actions insert,update,delete on '||owner||'.'||table_name||']''; '
 ||'execute immediate ''audit policy DML_'||owner||'_'||table_name||'''; end; /'

 FROM dba_tables
 WHERE owner <> 'APP_SCHEMA';
```
### How to Forward Unified Audit Records to SYSLOG
```
echo "local1.warning /var/log/oracle_unified_audit.log" \
```
```
 systemctl restart rsyslog
```
- Configure OS syslog as root. bash echo “local1.warning /var/log/oracle_unified_audit.log” \ /etc/rsyslog.d/oracle-uniaudit.conf /etc/rsyslog.d/oracle-uniaudit.conf touch /var/log/oracle_unified_audit.log touch /var/log/oracle_unified_audit.log chown oracle:oinstall /var/log/oracle_unified_audit.log chown oracle:oinstall /var/log/oracle_unified_audit.log chmod 640 /var/log/oracle_unified_audit.log chmod 640 /var/log/oracle_unified_audit.log systemctl restart rsyslog
```
ALTER SYSTEM SET UNIFIED_AUDIT_SYSTEMLOG='LOCAL1.WARNING' SCOPE=SPFILE;
```
```
ALTER SYSTEM SET UNIFIED_AUDIT_SYSTEMLOG='LOCAL1.WARNING' SCOPE=SPFILE;
```
- Set initialization parameter (requires database instance restart).
For Oracle RAC:
```
ALTER SYSTEM SET UNIFIED_AUDIT_SYSTEMLOG='LOCAL1.WARNING' SCOPE=SPFILE SID='*';
```
```
ALTER SYSTEM SET UNIFIED_AUDIT_SYSTEMLOG='LOCAL1.WARNING' SCOPE=SPFILE SID='*';
```
```
SHOW PARAMETER unified_audit_systemlog;
```
```
SHOW PARAMETER unified_audit_systemlog;
```
- Verify.
```
AUDIT POLICY UA_TEST;
```
```
 SELECT 1 FROM dual;
```
- Test with a simple policy. sql AUDIT POLICY UA_TEST; SELECT 1 FROM dual;
```
ALTER SYSTEM RESET UNIFIED_AUDIT_SYSTEMLOG SCOPE=SPFILE;
```
```
ALTER SYSTEM RESET UNIFIED_AUDIT_SYSTEMLOG SCOPE=SPFILE;
```
- Disable SYSLOG forwarding.
### Can Unified Audit Trail Data Be Archived to the OS File System?
No. There is no built-in mechanism for full OS archiving.
Only a subset of fields can be written to `SYSLOG` via `UNIFIED_AUDIT_SYSTEMLOG`. For full archiving, export data externally using Data Pump or custom queries, then purge using `DBMS_AUDIT_MGMT`.
Only a subset of fields can be written to `SYSLOG` via `UNIFIED_AUDIT_SYSTEMLOG`. For full archiving, export data externally using Data Pump or custom queries, then purge using `DBMS_AUDIT_MGMT`.
### How to Find When Unified Auditing Was Enabled
There is no single built-in enablement date flag. Use the earliest `EVENT_TIMESTAMP` in `UNIFIED_AUDIT_TRAIL` and the first policy-related records as the reference point.
There is no single built-in enablement date flag. Use the earliest `EVENT_TIMESTAMP` in `UNIFIED_AUDIT_TRAIL` and the first policy-related records as the reference point.
Whether the question is “when unified auditing was enabled” or “whether unified auditing is enabled” If it is “whether”, the queries are:
```
SELECT VALUE FROM V$OPTION WHERE PARAMETER = 'Unified Auditing'; checks if pure Unified Audit is enabled
```
```
SELECT count(*) FROM AUDIT_UNIFIED_ENABLED_POLICIES;
```
### Is It Common to Disable Auditing of Successful Logins and DML on OLTP Databases?
Successful logins: No.
Logon/logoff auditing is typically retained as it has low overhead.
Successful DML by valid accounts: Yes.
Blanket DML auditing on OLTP is commonly avoided. Instead, audit privileged users, sensitive objects, or use application-level change-data capture.
### How to Change the Default Tablespace for Unified Audit Trail
To move to a new tablespace, run:
```
BEGIN
 DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION(
 audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
 audit_trail_location_value => 'NEW_TSPACE');
 END;
 /
```
The NEW_TSPACE should be an ASSM (Auto Segment Space Management) tablespace.
You can shorten partition interval (pre-21c) for faster effect:
```
BEGIN
 DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL(
 interval_number => 1,
 interval_frequency => 'DAY');
 END;
 /
```
**Note:** From 21c onward, the change takes effect the next day automatically, provided that the AUDSYS.AUD$UNIFIED table is daily partitioned (default from 21c). On pre-21c, only new partitions move; existing ones remain in SYSAUX.
### Why Is DML on SYS Objects Captured for Application Users?
This is expected behavior.
Unified Auditing records recursive SQL that Oracle executes internally to service user requests (for example, dictionary/space management operations). These are attributed to the initiating session.
To suppress recursive SYS DML using ONLY TOPLEVEL (19c+):
```
CREATE AUDIT POLICY APP_TOP ACTIONS ALL ONLY TOPLEVEL;
 AUDIT POLICY APP_TOP;
```
### Why Are Audit Files Containing `createRmanOutputRow` Being Created?
### Why Are Audit Files Containing `createRmanOutputRow` Being Created?
Cause: Archived logs were deleted manually at the OS level, causing frequent RMAN CROSSCHECK operations to generate internal audit entries.
Resolution: Manage archivelogs with RMAN only.
Resolution: Manage archivelogs with RMAN only.
```
```
RMAN> CROSSCHECK ARCHIVELOG ALL;
RMAN> DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
RMAN> DELETE NOPROMPT ARCHIVELOG ALL BACKED UP 1 TIMES TO DEVICE TYPE DISK;
```
```
Never delete archived logs manually; always use `RMAN DELETE`.
Never delete archived logs manually; always use `RMAN DELETE`.
### Generate Unified Audit Policies from Traditional Audit Configuration
Follow the action plan in: Traditional to Unified Audit Syntax Converter (KB120309).
### Audit Records Still Appearing After Disabling a Unified Audit Policy
Sessions established before the policy was disabled continue to generate audit records.
To stop this, either kill the existing sessions or restart the database.  where the audit policies are effective immediately.
### SYSAUX Tablespace Growing After Enabling Unified Auditing
Steps to resolve:
  - Identify AUDSYS space usage.
```
SELECT segment_name, segment_type, ROUND(bytes/1024/1024) mb
```
```
 ORDER BY bytes DESC;
```
- Identify AUDSYS space usage. sql SELECT segment_name, segment_type, ROUND(bytes/1024/1024) mb FROM dba_segments FROM dba_segments WHERE tablespace_name=’SYSAUX’ AND owner=’AUDSYS’ WHERE tablespace_name=’SYSAUX’ AND owner=’AUDSYS’ ORDER BY bytes DESC;
```
CREATE TABLESPACE AUDIT_TBS
```
```
 SEGMENT SPACE MANAGEMENT AUTO;
```
- Create dedicated ASSM tablespace. sql CREATE TABLESPACE AUDIT_TBS DATAFILE ‘/u02/oradata/AUDIT_TBS01.dbf’ SIZE 10G DATAFILE ‘/u02/oradata/AUDIT_TBS01.dbf’ SIZE 10G AUTOEXTEND ON NEXT 1G MAXSIZE UNLIMITED AUTOEXTEND ON NEXT 1G MAXSIZE UNLIMITED SEGMENT SPACE MANAGEMENT AUTO;
```
BEGIN
```
```
 /
```
- Move unified audit to new tablespace. sql BEGIN DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION( DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION( audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, audit_trail_location_value => ‘AUDIT_TBS’); audit_trail_location_value => ‘AUDIT_TBS’); END; END; /
```
BEGIN
```
```
 /
```
- Shorten the partition interval. sql BEGIN DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL( DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL( interval_number => 1, interval_frequency => ‘DAY’); interval_number => 1, interval_frequency => ‘DAY’); END; END; /
```
BEGIN
```
```
 /
```
- Purge old audit data. sql BEGIN DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP( DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP( audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, last_archive_time => SYSTIMESTAMP - INTERVAL ‘30’ DAY); last_archive_time => SYSTIMESTAMP - INTERVAL ‘30’ DAY); DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL( DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL( audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, use_last_arch_timestamp => TRUE); use_last_arch_timestamp => TRUE); END; END; /
**Note:** Do not manually move AUDSYS.AUD$UNIFIED partitions; use DBMS_AUDIT_MGMT only.
### Impact of AUDIT NETWORK in 19c Traditional Auditing
```
AUDIT NETWORK logs internal Oracle Net/network layer failures only, not normal/successful traffic. Overhead is typically minimal unless network failures are frequent.
```
### Can the `AUDSYS` Schema Be Excluded During Database Migration?
### Can the `AUDSYS` Schema Be Excluded During Database Migration?
Yes, and it should be. `AUDSYS` is a protected system schema; the target database provisions its own. Migrating it can cause errors and is unnecessary.
Yes, and it should be. `AUDSYS` is a protected system schema; the target database provisions its own. Migrating it can cause errors and is unnecessary.
bash# Exclude using Data Pump:
```
expdp ... EXCLUDE=AUDIT_TRAILS
```
For OCI DMS: add `AUDSYS` to Excluded Objects or use SCHEMA mode.
For OCI DMS: add `AUDSYS` to Excluded Objects or use SCHEMA mode.
### Purpose of Hex-Numbered Folders in `AUDIT_FILE_DEST`
### Purpose of Hex-Numbered Folders in `AUDIT_FILE_DEST`
These hex-named subdirectories are automatically created per PDB, named using each PDB’s GUID. They segregate OS audit files and temporary XML index files per PDB. Do not delete files while in use.
### Can a Complete Audit Log of All Superuser Activities Be Maintained?
Yes. Use Unified Auditing with targeted policies:
```
CREATE AUDIT POLICY app_superuser_pol
```
```
 SELECT, INSERT, UPDATE, DELETE, EXECUTE;
```
- Create policy for superuser activity sql CREATE AUDIT POLICY app_superuser_pol ACTIONS ALL PRIVILEGES, LOGON, LOGOFF, ACTIONS ALL PRIVILEGES, LOGON, LOGOFF, SELECT, INSERT, UPDATE, DELETE, EXECUTE;
`ALL PRIVILEGES` should be removed `ALL PRIVILEGES` should be removed
```
AUDIT POLICY app_superuser_pol BY USERS user1, user2;
```
```
AUDIT POLICY app_superuser_pol BY USERS user1, user2;
```
```
SELECT event_timestamp, dbusername, action_name, object_schema, object_name, return_code
```
```
 ORDER BY event_timestamp;
```
- Query audit trail sql SELECT event_timestamp, dbusername, action_name, object_schema, object_name, return_code FROM unified_audit_trail FROM unified_audit_trail WHERE dbusername IN (‘USER1’,’USER2’) WHERE dbusername IN (‘USER1’,’USER2’) ORDER BY event_timestamp;
### Can `SYS.AUD$` Be Partitioned?
### Can `SYS.AUD$` Be Partitioned?
No. Partitioning `SYS.AUD$` is unsupported and can cause internal errors (ORA-600/ORA-7445).
No. Partitioning `SYS.AUD$` is unsupported and can cause internal errors (ORA-600/ORA-7445).
If already partitioned, revert it immediately. Use Unified Auditing (`AUDSYS.AUD$UNIFIED`) which is interval-partitioned by design.
If already partitioned, revert it immediately. Use Unified Auditing (`AUDSYS.AUD$UNIFIED`) which is interval-partitioned by design.
### How to Create a Unified Audit Policy for Objects in Other Schemas
Option 1: Audit via system privilege.
```
CREATE AUDIT POLICY SELECT_ANY_TAB_BY_OTHERS PRIVILEGES SELECT ANY TABLE;
 AUDIT POLICY SELECT_ANY_TAB_BY_OTHERS;
```
Option 2: Generate per-object policy for a specific schema.
```
DECLARE
 policy_stmt VARCHAR2(32767);
 BEGIN
 policy_stmt := 'CREATE AUDIT POLICY SELECT_HR_TABLES ACTIONS ';
 FOR r IN (SELECT owner, object_name FROM dba_objects
 WHERE owner='HR' AND object_type='TABLE') LOOP
 policy_stmt := policy_stmt||' SELECT ON '||r.owner||'.'||r.object_name||',';
 END LOOP;
 policy_stmt := RTRIM(policy_stmt,',')||
 ' WHEN ''SYS_CONTEXT(''''USERENV'''',''''CURRENT_USER'''') <> ''''HR'''''
 ' EVALUATE PER STATEMENT';
 EXECUTE IMMEDIATE policy_stmt;
 END;
 /
 AUDIT POLICY SELECT_HR_TABLES;
```
### `ORA-04063: view "AUDSYS.UNIFIED_AUDIT_TRAIL"` has errors
### `ORA-04063: view "AUDSYS.UNIFIED_AUDIT_TRAIL"` has errors
```
SELECT owner, object_name, object_type, status
```
```
 WHERE owner='AUDSYS' AND object_name='AUD$UNIFIED';
```
- Check if base table exists. sql SELECT owner, object_name, object_type, status FROM dba_objects FROM dba_objects WHERE owner=’AUDSYS’ AND object_name=’AUD$UNIFIED’;
  - Generate DDL from a working database.
  - Generate DDL from a working database.
```
   SELECT DBMS_METADATA.GET_DDL('TABLE','AUD$UNIFIED','AUDSYS') FROM dual;
```
```
   SELECT DBMS_METADATA.GET_DDL('TABLE','AUD$UNIFIED','AUDSYS') FROM dual;
```
  - Use the supplied script (in upgrade mode).
  - Use the supplied script (in upgrade mode).
```
   $ORACLE_HOME/rdbms/admin/catuat.sql
```
```
   $ORACLE_HOME/rdbms/admin/catuat.sql
```
### Unified Audit Records Still Written to `SYSAUX` After Moving to New Tablespace
### Unified Audit Records Still Written to `SYSAUX` After Moving to New Tablespace
This issue occurs because `SET_AUDIT_TRAIL_LOCATION` only affects new partitions. Existing partitions remain in `SYSAUX` until they age out.
This issue occurs because `SET_AUDIT_TRAIL_LOCATION` only affects new partitions. Existing partitions remain in `SYSAUX` until they age out.
```
SELECT partition_name, high_value, tablespace_name
```
```
 ORDER BY high_value DESC;
```
- Verify the current partition boundary. sql SELECT partition_name, high_value, tablespace_name FROM dba_tab_partitions FROM dba_tab_partitions WHERE table_owner=’AUDSYS’ AND table_name=’AUD$UNIFIED’ WHERE table_owner=’AUDSYS’ AND table_name=’AUD$UNIFIED’ ORDER BY high_value DESC;
- Shorten the interval and purge old data.
- Apply fix for Bug 27576342 to ensure LOB/INDEX partitions also move to the new tablespace.
### `ORA-04063: package body "AUDSYS.DBMS_AUDIT_MGMT"` has errors
### `ORA-04063: package body "AUDSYS.DBMS_AUDIT_MGMT"` has errors
To resolve:
```
GRANT SELECT ANY DICTIONARY TO audsys;
```
```
 ALTER PACKAGE audsys.dbms_audit_mgmt COMPILE BODY;
```
- Grant privileges and recompile. sql GRANT SELECT ANY DICTIONARY TO audsys; GRANT ANALYZE ANY DICTIONARY TO audsys; GRANT ANALYZE ANY DICTIONARY TO audsys; ALTER PACKAGE audsys.dbms_audit_mgmt COMPILE; ALTER PACKAGE audsys.dbms_audit_mgmt COMPILE; ALTER PACKAGE audsys.dbms_audit_mgmt COMPILE BODY;
  - Recreate audit packages if still invalid. This includes
  - /rdbms/admin/dbmsamgt.sql
  - /rdbms/admin/dbmsamgt.sql
  - /rdbms/admin/prvtamgt.plb
  - /rdbms/admin/prvtamgt.plb
  - /rdbms/admin/utlrp.sql
  - /rdbms/admin/utlrp.sql
```
EXEC DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
```
```
 use_last_arch_timestamp => FALSE);
```
- Retry purge. sql EXEC DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL( audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, use_last_arch_timestamp => FALSE);
### `ORA-02002` and `ORA-00600 `While Writing Audit Trail
### `ORA-02002` and `ORA-00600 `While Writing Audit Trail
Fix 1: Install patch for Bug 37108466.
Fix 2 (Workaround): Resize the problematic datafile to greater than 256MB.
```
SELECT file_name, tablespace_name, bytes FROM dba_data_files;
```
```
SELECT file_name, tablespace_name, bytes FROM dba_data_files;
```
- Identify problematic datafile:
```
ALTER DATABASE DATAFILE '' RESIZE 300M;
```
```
ALTER DATABASE DATAFILE '' RESIZE 300M;
```
- Resize to 300MB
Cause: `ORA-600` can occur when creating a segment in a bigfile tablespace where a failed extend was followed by a file shrink, specifically for datafiles smaller than 256MB.
Cause: `ORA-600` can occur when creating a segment in a bigfile tablespace where a failed extend was followed by a file shrink, specifically for datafiles smaller than 256MB.
## Oracle Database Audit Purging Guide (Unified and Standard)
The following topics explain the purging procedure and anser commonly asked questions around it. The process of periodically archiving and purging the audit trail to prevent the database from growing too large is explained, while addressing key questions about what purging means, how data is handled, and archive of the unified and traditional database audit trail.
### About Purging the Audit Trail and Archiving
Auditing is always enabled in Oracle Database. Audit records are generated during or after the execution phase of the audited SQL statements, and are written to the configured audit trail destination (database table, OS file, or XML file).
  - Unified Audit Trail records are stored in AUDSYS.AUD$UNIFIED (in SYSAUX tablespace by default).
  - Traditional Audit Trail records go to SYS.AUD$ (standard), SYS.FGA_LOG$ (fine-grained), or OS/XML files in audit_file_dest.
#### Why Archive and Purge
  - You should periodically archive and then purge the audit trail to prevent it from growing too large.
  - Archiving and purging together facilitate safe cleanup of the database audit trail without losing compliance data.
#### How to Archive
  - Use Oracle Audit Vault and Database Firewall (AVDF), installed separately from Oracle Database, to create a full archive of both unified and traditional audit trails before purging.
  - For traditional trails, Data Pump export with INCLUDE=AUDIT_TRAILS is an alternative archiving method.
  - For unified trails, use DBMS_AUDIT_MGMT.GET_UNIFIED_AUDIT_TRAIL or a CTAS (Create Table As Select) from UNIFIED_AUDIT_TRAIL into archive tables prior to setting the archive timestamp.
#### How to Purge (using DBMS_AUDIT_MGMT)
DBMS_AUDIT_MGMT is the standard PL/SQL package for all audit trail operations; it can schedule automatic purge jobs, manually purge records, and manage other audit trail settings.
### Purging Audit Data
#### How do I purge Unified Audit Trail data?
Use DBMS_AUDIT_MGMT procedures. Set a last archive timestamp, then call CLEAN_AUDIT_TRAIL:
```
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, last_archive_time => SYSTIMESTAMP - INTERVAL '90' DAY);
 DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, use_last_arch_timestamp => TRUE);
```
Unified audit records (AUD$UNIFIED): AUDIT_TRAIL_UNIFIED Refer to KB106078 (schedule purge job) and KB82473 (purge unified audit trail).
#### How do I purge Traditional Audit Trail (AUD$ table)?
Use the following trail type with DBMS_AUDIT_MGMT:
  - Standard audit trail (AUD$): AUDIT_TRAIL_AUD_STD
  - OS audit trails: AUDIT_TRAIL_OS
  - FGA records (FGA_LOG$): AUDIT_TRAIL_FGA_STD
  - XML audit records: AUDIT_TRAIL_XML
Refer to KB142420 for a basic AUD$ management script.
#### Can I truncate AUD$ directly if DBMS_AUDIT_MGMT is too slow?
Yes. A one-time TRUNCATE of SYS.AUD$ is an accepted workaround when standard purge is extremely slow due to large data volumes.
Steps:
- Archive audit data using Data Pump if compliance requires it.
- Acquire an exclusive lock and truncate SYS.AUD$.
- Initialize and use DBMS_AUDIT_MGMT for ongoing scheduled purging going forward.
**Note:** Obtain formal approvals and align with your retention policy before truncating. For FGA_LOG$, manual deletion may also be faster than CLEAN_AUDIT_TRAIL in extreme cases.
Refer to KB181173 (Traditional Audit Primary Note)
### Controlling Audit Trail Growth
#### What are the minimal steps to control audit trail growth in Oracle 19c?
Follow this structured approach:
- Determine auditing mode: SELECT value FROM v$option WHERE parameter=’Unified Auditing’; (TRUE = Unified, FALSE = Traditional/Mixed)
- Reduce volume at source: Review and narrow enabled audit policies. Use ONLY TOPLEVEL, WHEN conditions, and EXCEPT users clauses. Remove unnecessary policies.
```
BEGIN
```
```
 /
```
  - Traditional (AUD$, FGA_LOG$):
  - Traditional (AUD$, FGA_LOG$):
```
BEGIN
```
sql BEGIN DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION( DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION( audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, audit_trail_location_value => ‘TBS_AUDIT’);
audit_trail_location_value => ‘TBS_AUDIT’);
DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION( DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION( audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD, audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD, audit_trail_location_value => ‘TBS_AUDIT’);
audit_trail_location_value => ‘TBS_AUDIT’);
END;
END;
/
```
 /
```
- Implement scheduled purging: Use DBMS_SCHEDULER to run CLEAN_AUDIT_TRAIL daily with a rolling retention window (e.g., 90 days).
One-time init:
```
BEGIN
```
sql BEGIN
```
DBMS_AUDIT_MGMT.INIT_CLEANUP(
DBMS_AUDIT_MGMT.INIT_CLEANUP(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, default_cleanup_interval => 24);
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, default_cleanup_interval => 24);
DBMS_AUDIT_MGMT.INIT_CLEANUP(
DBMS_AUDIT_MGMT.INIT_CLEANUP(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD, default_cleanup_interval => 24);
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD, default_cleanup_interval => 24);
END;
END;
/
```
```
 /
```
Set rolling retention (example: keep last 90 days): Unified
```
BEGIN
```
sql BEGIN
```
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
last_archive_time => SYSTIMESTAMP - INTERVAL '90' DAY);
last_archive_time => SYSTIMESTAMP - INTERVAL '90' DAY);
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
use_last_arch_timestamp => TRUE);
use_last_arch_timestamp => TRUE);
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
last_archive_time => SYSTIMESTAMP
```
```
 last_archive_time => SYSTIMESTAMP
```
Traditional:
```
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
```
sql DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
```
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
use_last_arch_timestamp => TRUE);
use_last_arch_timestamp => TRUE);
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
last_archive_time => SYSTIMESTAMP - INTERVAL '90' DAY);
last_archive_time => SYSTIMESTAMP - INTERVAL '90' DAY);
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
use_last_arch_timestamp => TRUE);
use_last_arch_timestamp => TRUE);
END;
END;
/
```
```
 /
```
Automate: create DBMS_SCHEDULER job to run CLEAN_AUDIT_TRAIL daily.
- Archive before purge (if compliance required): Use Data Pump with INCLUDE=AUDIT_TRAILS for traditional trails.
- Handle Unified spillover OS files: Call DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES then remove *.bin files from $ORACLE_BASE/audit/$ORACLE_SID.
**Warning:**
  - CLEAN_AUDIT_TRAIL with use_last_arch_timestamp=FALSE deletes ALL records in the selected trail.
  - Reducing audit scope can affect compliance; always obtain approvals and document changes.
  - Always archive audit data before purging if required by your compliance policy.
#### How do I move audit data to a dedicated tablespace?
For Unified Auditing (AUDSYS):
```
CREATE TABLESPACE TBS_AUDIT DATAFILE '/tbs_audit01.dbf' SIZE 10G AUTOEXTEND ON NEXT 1G;
 DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION(audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, audit_trail_location_value => 'TBS_AUDIT');
```
For Traditional (AUD$ and FGA_LOG$):
use AUDIT_TRAIL_AUD_STD and AUDIT_TRAIL_FGA_STD respectively with the same procedure.
### Recovery of Purged Data
#### Can purged unified audit trail data be recovered?
No supported recovery is possible. Once unified audit records are purged and you have no backups, no Flashback Database/restore point, no standby/snapshots, and no external collection, the data cannot be restored.
You can still quickly check for any residual sources:
  - OS spillover files: look under $ORACLE_BASE/audit/$ORACLE_SID and ADR trace directories for .bin spillover files generated during SYSAUX pressure.
  - If archived redo logs from the purge window still exist, you may attempt expert-level redo mining to manually reconstruct deletes on AUDSYS.AUD$UNIFIED, but this is not guaranteed, is complex (LOBs/partitions), and is not a supported recovery path for compliance.
Prevention going forward:
  - Enable and test RMAN backups and/or Flashback Database restore points.
  - Stream unified audits to AVDF or a SIEM.
  - Schedule regular exports or staging copies of unified audit data.
  - Configure DBMS_AUDIT_MGMT purge with LAST_ARCHIVE_TIMESTAMP and retention aligned to your RPO/RTO.
Summary: With no backups/flashback/standby/snapshots and no external copies, purged unified audit data cannot be recovered; only potential leftovers are spillover files or non-guaranteed redo mining.
Refer to Primary Note For Database Unified Auditing KB831399
#### What if there are no backups and data was purged on Oracle 19c non-CDB?
No supported recovery is possible in this scenario. You can quickly check these residual sources:
  - OS spillover files: Check $ORACLE_BASE/audit/$ORACLE_SID and ADR trace directories for .bin files generated during SYSAUX pressure.
  - Redo log mining: If archived redo logs from the purge window still exist, expert-level redo mining may reconstruct deletes, but this is not guaranteed, is complex (LOBs/partitions), and is not a supported path.
Prevention going forward: Enable RMAN backups and Flashback Database, stream unified audits to AVDF/SIEM, schedule regular exports, and configure DBMS_AUDIT_MGMT with LAST_ARCHIVE_TIMESTAMP aligned to your RPO/RTO.
Refer to KB831399 (Primary Note for Database Unified Auditing)
### Troubleshooting Common Issues
#### The unified audit trail purging job is taking very long. What should I do?
Execute the workaround described in Recommended Way To Purge The Unified Audit Trail To Avoid “Row-delete” KB750686
#### DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL is not removing rows for an old DBID. Why?
This occurs when a Pluggable Database (PDB) is cloned. The unified audit tables are newly created in the new PDB, leaving old tables behind.
To drop old unified audit tables, use DROP_OLD_UNIFIED_AUDIT_TABLES with the old container GUID:
DBMS_AUDIT_MGMT.DROP_OLD_UNIFIED_AUDIT_TABLES(container_guid);
Query DBA_PDB_HISTORY for the old GUID of the source PDB.
Refer to KB843709 How to drop the old unified audit tables following the cloning of a pluggable database (PDB)
#### Improving the Performance of Queries and Purge Operations in 19c.
If the partition on which the AUDSYS.AUD$UNIFIED table is located is too large, then queries to and purges of the UNIFIED_AUDIT_TRAIL data dictionary view may take a long time to complete.
To improve performance, break the partition into smaller portions by using the ALTER TABLE SPLIT PARTITION statement.
For example:
Check the current partition:
```
SELECT partition_position, partition_name, high_value FROM dba_tab_partitions where table_name='AUD$UNIFIED';
```
```
alter table "AUDSYS"."AUD$UNIFIED" split partition "SYS_P36749" into
 (PARTITION VALUES LESS THAN (DATE '2025-11-28'),
 PARTITION VALUES LESS THAN (DATE '2025-11-29'),
 PARTITION VALUES LESS THAN (DATE '2025-11-30'),
 PARTITION
 ) UPDATE INDEXES;
```
Verify that the partition was split:
```
SELECT partition_position, partition_name, high_value FROM dba_tab_partitions where table_name='AUD$UNIFIED';
```
**Note:** In case of PDB, please switch to pdb and run the following query before running the ALTER TABLE SPLIT PARTITION statement
```
SQL> alter session set container=m18gf;
 SQL> alter session set "_ORACLE_SCRIPT"=true
```
#### Unified audit records still exist after running the purge job. How do I fix this?
Follow these steps in order:
```
EXEC DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES;
```
```
EXEC DBMS_AUDIT_MGMT.LOAD_UNIFIED_AUDIT_FILES;
```
- Load unified audit log .bin files into the database.
- Move remaining .bin files under $ORACLE_BASE/audit/$ORACLE_SID to another location.
```
EXEC DBMS_AUDIT_MGMT.TRANSFER_UNIFIED_AUDIT_RECORDS;
```
```
EXEC DBMS_AUDIT_MGMT.TRANSFER_UNIFIED_AUDIT_RECORDS;
```
- Transfer records from CLI_SWP$ tables to AUDSYS.AUD$UNIFIED.
- Re-run the purge job with SET_LAST_ARCHIVE_TIMESTAMP and CLEAN_AUDIT_TRAIL.
Refer to Unified Auditing Causes Many *.bin Files (KB226337) **Note:** Purging or relocating audit data affects evidentiary records. Always obtain approved retention policies and tested rollback plans before making changes.
## Oracle Database Audit Configuration and Procedures
The following is a comprehensive technical discussion about how to enable and configure audit, and storage/performance. The following also provides step-by-step SQL and OS-level procedures for common auditing tasks, such as auditing specific users (SYS/SYSTEM), tools (SQL Developer), and operations (DDL/DML), along with best practices for partition management, and also addresses key operational concerns including licensing requirements.
### Audit Modes
#### What are the three types of Oracle audit modes?
- Standard/Traditional Audit Mode: Enabled by setting the audit_trail parameter to a value other than NONE. Note: This is Deprecated in 21c and desupported from 23c onward.
- Mixed Mode Audit Mode: Enabled when audit_trail is set to a non-NONE value AND at least one unified audit policy is active. This is the default mode for databases created from 12c and above.
- Pure Unified Audit Mode: Enabled by relinking Oracle binaries with the uniaud_on option. In this mode, the AUDIT_TRAIL parameter is ignored entirely.
#### How do different parameter combinations affect audit behavior?
The table below shows the resulting audit mode behavior based on the combination of the Unified Auditing and standard auditing.

| Unified Auditing (v$option) = TRUE? | AUDIT_TRAIL Is Not NONE? | Unified Policies Enabled? | Standard Audit Mode | Mixed Audit Mode | Pure Unified Mode | Tables / Dictionary Views | KM Docs (Purging) |
|---|---|---|---|---|---|---|---|
| No | No | No | Disabled | Disabled | Disabled | None | - |
| No | No | Yes | Disabled | Disabled | Disabled | None | - |
| No | Yes | No | Enabled | Disabled | Disabled | Tables: SYS.AUD$, SYS.FGA_LOG$ Views: DBA_AUDIT_TRAIL, DBA_FGA_AUDIT_TRAIL | KB142420 |
| No | Yes | Yes | Enabled | Enabled | Disabled | Tables: SYS.AUD$, SYS.FGA_LOG$, AUDSYS.AUD$UNIFIED Views: DBA_AUDIT_TRAIL, DBA_FGA_AUDIT_TRAIL, UNIFIED_AUDIT_TRAIL | KB142420, KB106078, KB82473 |
| Yes | N/A | Yes/No | Disabled | Disabled | Enabled | Tables: AUDSYS.AUD$UNIFIED Views: UNIFIED_AUDIT_TRAIL | KB106078, KB82473 |
| Note: Green = Enabled | Red = Disabled | N/A = Not Applicable to this mode. Status of AUDIT_TRAIL parameter is irrelevant when Unified Auditing (v$option) = TRUE. |
|---|---|---|

#### How do I check which audit mode is currently active?
Run the following SQL query:
```
SELECT VALUE FROM V$OPTION WHERE PARAMETER = 'Unified Auditing';
```
Returns:
  - TRUE = Pure Unified Auditing is enabled.
  - FALSE = Pure unified audit is disabled (Standard or Mixed mode).
### Enabling Pure Unified Auditing
#### How do I enable Pure Unified Auditing?
Follow these steps (requires OS-level access): This applies to 12c to 19c version.
  - Shut down the database: SHUTDOWN IMMEDIATE
  - Stop the listener: lsnrctl stop listener_name
```
 cd $ORACLE_HOME/rdbms/lib
```
```
 make -f ins_rdbms.mk uniaud_on oracle ORACLE_HOME=$ORACLE_HOME
```
````
- Relink the Oracle binaries: bash cd $ORACLE_HOME/rdbms/lib make -f ins_rdbms.mk uniaud_on oracle ORACLE_HOME=$ORACLE_HOME On Windows, rename %ORACLE_HOME%/bin/orauniaud12.dll.dbl to orauniaud12.dll.
- Restart the listener and database. For Oracle RAC, repeat the relink step on every cluster node.
**Note:** From 26ai and above unified auditing is enabled and value is true by default and traditional auditing is de-supported.
### Standby/Data Guard
#### Can unified auditing be enabled only on the standby side?
No. Unified audit policies cannot be enabled exclusively on a physical standby. You must create and enable the policy on the primary, using a WHEN condition to restrict it to the standby role.
Example:
```
CREATE AUDIT POLICY standby_only_audpol ACTIONS SELECT ON schema.table WHEN 'sys_context(''USERENV'',''DATABASE_ROLE'') = ''PHYSICAL STANDBY''' EVALUATE PER INSTANCE;
```
```
AUDIT POLICY standby_only_audpol;
```
### Licensing
#### Do I need an additional license to use Oracle Database auditing?
No additional license is required for standard Oracle Database auditing.
The following are included with Oracle Database (EE and SE2):
  - Standard Auditing (AUD$, OS/file auditing)
  - Unified Auditing (policies, UNIFIED_AUDIT_TRAIL)
  - SYS operation auditing (audit_sys_operations)
  - Fine-Grained Auditing (DBMS_FGA); Enterprise Edition only
Oracle Audit Vault and Database Firewall (AVDF) is a separate licensed product for centralized audit collection, reporting, and firewall capabilities.
### Configuration Parameters
#### What is the purpose of the audit_file_dest parameter?
The audit_file_dest parameter defines the filesystem directory where Oracle writes OS-based audit files.
It is used when:
  - audit_trail = OS or XML/XML,EXTENDED
  - audit_sys_operations = TRUE (even if audit_trail = DB)
Default location: $ORACLE_BASE/admin/$ORACLE_SID/adump
To view:
show parameter audit_file_dest
To set the location:
```
ALTER SYSTEM SET audit_file_dest='/path/adump' SCOPE=SPFILE;
```
**Note:** An instance restart is required after changing this parameter.
### Storage and Partitioning
#### What are the best practices for managing UNIFIED_AUDIT_TRAIL partitions?
Do not manually DDL/DML the AUD$UNIFIED table. This causes ORA-46385 errors.
Key best practices:
In 19c, default is monthly partition. If the number of audit records on daily basis is very high then it is recommended to switch to daily partitions.
  - To change to daily partitioning interval, following procedure can be used.
  - From 21c onwards default is daily partition.
  - Use DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL to adjust partitioning intervals
```
BEGIN
```
```
/
```
- To change the partition interval to day use the following procedure. sql BEGIN DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL( DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL( interval_number => 1, interval_number => 1, interval_frequency => ‘DAY’); interval_frequency => ‘DAY’); END; END; / Please note that audit records will get populated in the daily partition after the end of the current monthly partition. Please note that audit records will get populated in the daily partition after the end of the current monthly partition.
  - Redirect new partitions to a dedicated tablespace to reduce SYSAUX pressure.
  - Implement scheduled purging using DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL with last archive timestamps.
  - Keep statistics current with DBMS_STATS.GATHER_TABLE_STATS.
  - Tune audit policies (WHEN conditions, ONLY TOPLEVEL) to control audit volume.
Example: Move future partitions to a dedicated tablespace:
```
EXEC DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION(
```
sql
   EXEC DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
   audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
audit_trail_location_value => ‘AUDIT_TBS’);
```
audit_trail_location_value => 'AUDIT_TBS');
```
**Note:** Purging or relocating audit data affects evidentiary records. Always obtain approved retention policies and tested rollback plans before making changes.
#### What is the impact of enabling unified auditing in Oracle 19c?
  - Functional: Default policies ORA_SECURECONFIG and ORA_LOGON_FAILURES may be enabled automatically.
  - Performance: Typically low single-digit percent overhead. Increases with broad policies (e.g., ACTIONS ALL) or heavy DML.
  - Storage: AUDSYS.AUD$UNIFIED stored in SYSAUX by default; can grow rapidly with broad policies. Plan capacity and purging in advance.
**Note:** Known 19c issue: ‘SELECT without policy’ rows may appear. Patch 36723173 available.
### Enabling Specific Audit Scenarios
#### How do I audit actions executed via SQL Developer?
Run:
```
CREATE AUDIT POLICY sqldev_all ACTIONS ALL WHEN 'sys_context(''USERENV'',''MODULE'') LIKE ''SQL Developer%''' EVALUATE PER SESSION;
```
```
AUDIT POLICY sqldev_all;
```
To view audit records:
```
SELECT event_timestamp, dbusername, action_name, module FROM unified_audit_trail WHERE module LIKE 'SQL Developer%' ORDER BY event_timestamp DESC;
```
#### How do I audit actions executed by SYS and SYSTEM users?
Run:
```
CREATE AUDIT POLICY admin_all_toplevel ACTIONS ALL ONLY TOPLEVEL;
AUDIT POLICY admin_all_toplevel BY SYS, SYSTEM;
```
Using ONLY TOPLEVEL avoids recursive audit noise from internal statements.
To view records:
```
SELECT event_timestamp, dbusername, action_name, object_schema FROM unified_audit_trail WHERE dbusername IN ('SYS','SYSTEM') ORDER BY event_timestamp DESC;
```
#### How do I audit DML actions on all tables (Oracle 19c, non-CDB)?
Run:
```
CREATE AUDIT POLICY DML_ALL_TABS ACTIONS INSERT, UPDATE, DELETE, MERGE ONLY TOPLEVEL;
```
```
AUDIT POLICY DML_ALL_TABS;
```
To verify:
```
SELECT policy_name, enabled_option, user_name FROM audit_unified_enabled_policies WHERE policy_name = 'DML_ALL_TABS';
```
To disable:
```
NOAUDIT POLICY DML_ALL_TABS;
```
#### How do I enable auditing for both DDL and DML actions?
Option 1: Unified Auditing (Recommended for 19c+)
```
CREATE AUDIT POLICY ddl_core
```
```
AUDIT POLICY ddl_core;
```
- DDL policy: sql CREATE AUDIT POLICY ddl_core ACTIONS CREATE USER, ALTER USER, DROP USER, ACTIONS CREATE USER, ALTER USER, DROP USER, CREATE TABLE, ALTER TABLE, DROP TABLE, CREATE TABLE, ALTER TABLE, DROP TABLE, CREATE INDEX, DROP INDEX, CREATE VIEW, DROP VIEW; CREATE INDEX, DROP INDEX, CREATE VIEW, DROP VIEW; AUDIT POLICY ddl_core;
```
CREATE AUDIT POLICY dml_sales
```
```
AUDIT POLICY dml_sales;
```
- DML policy (per object): sql CREATE AUDIT POLICY dml_sales ACTIONS INSERT, UPDATE, DELETE ON sales.orders, ACTIONS INSERT, UPDATE, DELETE ON sales.orders, INSERT, UPDATE, DELETE ON sales.customers; INSERT, UPDATE, DELETE ON sales.customers; AUDIT POLICY dml_sales;
Option 2: Traditional Auditing
```
ALTER SYSTEM SET audit_trail=DB,EXTENDED SCOPE=SPFILE; -- restart required AUDIT CREATE TABLE BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON sales.orders BY ACCESS;
```
