# Manually Purging the Audit Trail

You can use the `DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL` procedure to manually purge the audit trail.
- About Manually Purging the Audit Trail You can manually purge the audit trail right away, without scheduling a purge job.
- Using DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL to Manually Purge the Audit Trail After you complete preparatory steps, you can use the DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL procedure to manually purge the audit trail.
## About Manually Purging the Audit Trail
You can manually purge the audit trail right away, without scheduling a purge job.
Similar to a purge job, you can purge audit trail records that were created before an archive timestamp date or all the records in the audit trail. Only the current audit directory is cleaned up when you run this procedure.
For upgraded databases that may still have audit trails from earlier releases, note the following about the `DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL` PL/SQL procedure:
````````
- On Microsoft Windows, because the DBMS_AUDIT_MGMT package does not support cleanup of Windows Event Viewer, setting the AUDIT_TRAIL_TYPE property to DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS has no effect. This is because operating system audit records on Windows are written to Windows Event Viewer. The DBMS_AUDIT_MGMT package does not support this type of cleanup operation.
``````````
- On UNIX platforms, if you had set the AUDIT_SYSLOG_LEVEL initialization parameter, then Oracle Database writes the operating system log files to syslog files. (Be aware that when you configure the use of syslog files, the messages are sent to the syslog daemon process. The syslog daemon process does not return an acknowledgement to Oracle Database indicating a committed write to the syslog files.) If you set the AUDIT_TRAIL_TYPE property to DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS, then the procedure only removes .aud files under audit directory (This directory is specified by the AUDIT_FILE_DEST initialization parameter).
## Using DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL to Manually Purge the Audit Trail
After you complete preparatory steps, you can use the `DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL` procedure to manually purge the audit trail.
****````- Ensure that operating system audit trail (.bin) files are not owned by the Oracle PMON process. If this is the case, restart the database. Note: The DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL procedure only purges database audit records and does not affect operating system audit files, like syslog.
  - Step 1: If Necessary, Tune Online and Archive Redo Log Sizes
  - Step 2: Plan a Timestamp and Archive Strategy
  - Step 3: Optionally, Set an Archive Timestamp for Audit Records
- If you are using a multitenant environment, then connect to the database in which you created the purge job. If you created the purge job in the root, then you must log into the root. If you created the purge job in a specific PDB, then log into that PDB. For example:
```
CONNECT aud_admin@hrpdb
Enter password: password
Connected.
```
- Purge the audit trail records by running the DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL PL/SQL procedure. For example:
```
BEGIN
  DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
   AUDIT_TRAIL_TYPE           =>  DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
   USE_LAST_ARCH_TIMESTAMP    =>  TRUE,
   CONTAINER                  =>  DBMS_AUDIT_MGMT.CONTAINER_CURRENT );
END;
/
```
```
In this example:
- `AUDIT_TRAIL_TYPE`: Specifies the audit trail type. `DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED` sets it for the unified audit trail.
  For upgraded databases that still have audit data from previous releases:
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD`: Standard audit trail table, `AUD$`. (This setting does not apply to read-only databases.)
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD`: Fine-grained audit trail table, `FGA_LOG$`. (This setting does not apply to read-only databases.)
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD`: Both standard and fine-grained audit trail tables. (This setting does not apply to read-only databases)
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS`: Operating system audit trail files with the `.aud` extension. (This setting does not apply to Windows Event Log entries.)
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML`: XML Operating system audit trail files.
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_FILES`: Both operating system and XML audit trail files.
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL`: All audit trail records, that is, both database audit trail and operating system audit trail types. (This setting does not apply to read-only databases.)
  To purge records from the `AUDSYS.AUD$UNIFIED` table or from the operating system spillover files:
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_TABLE` purges records from the `AUDSYS.AUD$UNIFIED` table.
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_FILES` purges records from the operating system spillover files in each database (primary or standby).
- `USE_LAST_ARCH_TIMESTAMP`: Enter either of the following settings:
  - `TRUE`: Deletes audit records created before the last archive timestamp. To set the archive timestamp, see [Step 3: Optionally, Set an Archive Timestamp for Audit Records](scheduling-automatic-purge-job-audit-trail.html#GUID-1C9053BB-30B8-48DB-9062-44DD42A75B4E). The default (and recommended) value is `TRUE`. Oracle recommends that you set `USE_LAST_ARCH_TIMESTAMP` to `TRUE`.
  - `FALSE`: Deletes all audit records without considering last archive timestamp. Be careful about using this setting, in case you inadvertently delete audit records that should not have been deleted.
- `CONTAINER`: Applies the cleansing to a multitenant environment. `DBMS_AUDIT_MGMT.CONTAINER_CURRENT` specifies the local PDB; `DBMS_AUDIT_MGMT.CONTAINER_ALL` applies to all databases.
```
