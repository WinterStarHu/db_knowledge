# Scheduling an Automatic Purge Job for the Audit Trail

Scheduling an automatic purge job requires planning beforehand, such as tuning the online and archive redo log sizes.
- About Scheduling an Automatic Purge Job You can purge the entire audit trail, or only a portion of the audit trail that was created before a timestamp.
- Step 1: If Necessary, Tune Online and Archive Redo Log Sizes The purge process may generate additional redo logs.
- Step 2: Plan a Timestamp and Archive Strategy You must record the timestamp of the audit records before you can archive them.
- Step 3: Optionally, Set an Archive Timestamp for Audit Records If you want to delete all of the audit trail, then you can bypass this step.
- Step 4: Create and Schedule the Purge Job You can use the DBMS_AUDIT_MGMT PL/SQL package to create and schedule the purge job.
## About Scheduling an Automatic Purge Job
You can purge the entire audit trail, or only a portion of the audit trail that was created before a timestamp.
The individual audit records created before the timestamp can be purged.
Be aware that purging the audit trail, particularly a large one, can take a while to complete. Consider scheduling the purge job so that it runs during a time when the database is not busy.
You can create multiple purge jobs for different audit trail types, so long as they do not conflict. For example, you can create a purge job for the standard audit trail table and then the fine-grained audit trail table. However, you cannot then create a purge job for both or all types, that is, by using the `DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD` or `DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL` property. In addition, be aware that the jobs created by the `DBMS_SCHEDULER` PL/SQL package do not execute on a read-only database. An automatic purge job created with `DBMS_AUDIT_MGMT` uses the `DBMS_SCHEDULER` package to schedule the tasks. Therefore, these jobs cannot run on a database or PDB that is open in read-only mode.
## Step 1: If Necessary, Tune Online and Archive Redo Log Sizes
The purge process may generate additional redo logs.
  - If necessary, tune online and archive redo log sizes to accommodate the additional records generated during the audit table purge process.
In a unified auditing environment, the purge process does not generate as many redo logs as in a mixed mode auditing environment, so if you have migrated to unified auditing, then you may want to bypass this step.
## Step 2: Plan a Timestamp and Archive Strategy
You must record the timestamp of the audit records before you can archive them.
  - To find the timestamp date, query the DBA_AUDIT_MGMT_LAST_ARCH_TS data dictionary view.
Later on, when the purge takes place, Oracle Database purges only the audit trail records that were created before the date of this archive timestamp.
After you have timestamped the records, you are ready to archive them.
## Step 3: Optionally, Set an Archive Timestamp for Audit Records
If you want to delete all of the audit trail, then you can bypass this step.
You can set a timestamp for when the last audit record was archived. Setting an archive timestamp provides the point of cleanup to the purge infrastructure. If you are setting a timestamp for a read-only database, then you can use the `DBMS_AUDIT.MGMT.GET_LAST_ARCHIVE_TIMESTAMP` function to find the last archive timestamp that was configured for the instance on which it was run. For a read-write database, you can query the `DBA_AUDIT_MGMT_LAST_ARCH_TS` data dictionary view.
To find the last archive timestamps for the unified audit trail, you can query the `DBA_AUDIT_MGMT_LAST_ARCH_TS` data dictionary view. After you set the timestamp, all audit records in the audit trail that indicate a time earlier than that timestamp are purged when you run the `DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL` PL/SQL procedure. If you want to clear the archive timestamp setting, see Clearing the Archive Timestamp Setting.
If you are using Oracle Database Real Application Clusters, then use Network Time Protocol (NTP) to synchronize the time on each computer where you have installed an Oracle Database instance. For example, suppose you set the time for one Oracle RAC instance node at 11:00:00 a.m. and then set the next Oracle RAC instance node at 11:00:05. As a result, the two nodes have inconsistent times. You can use Network Time Protocol (NTP) to synchronize the times for these Oracle RAC instance nodes.
To set the timestamp for the purge job:
- Log into the database instance as a user who has been granted the AUDIT_ADMIN role. In a multitenant environment, log into either the root or the PDB in which you want to schedule the purge job. In most cases, you may want to schedule the purge job on individual PDBs. For example, to log into a PDB called hrpdb:
```
CONNECT aud_admin@hrpdb
Enter password: password
Connected.
```
- Run the DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP PL/SQL procedure to set the timestamp. For example:
```
BEGIN
  DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
   AUDIT_TRAIL_TYPE     =>  DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
   LAST_ARCHIVE_TIME    =>  '12-OCT-2013 06:30:00.00',
   RAC_INSTANCE_NUMBER  =>  1,
   CONTAINER            => DBMS_AUDIT_MGMT.CONTAINER_CURRENT);
END;
/
```
```
In this example:
- `AUDIT_TRAIL_TYPE` specifies the audit trail type. `DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED` sets it for the unified audit trail.
  For upgraded databases that still have traditional audit data from previous releases:
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD` is used for the traditional standard audit trail table, `AUD$`. (This setting does not apply to read-only databases.)
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD` is used for the traditional fine-grained audit trail table, `FGA_LOG$`. (This setting does not apply to read-only databases.)
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS` is used for the traditional operating system audit trail files with the `.aud` extension. (This setting does not apply to Windows Event Log entries.)
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML` is used for the XML traditional operating system audit trail files.
  To archive records from the `AUDSYS.AUD$UNIFIED` table or from the operating system spillover files:
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_TABLE` archives records from the `AUDSYS.AUD$UNIFIED` table.
  - `DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_FILES` archives records from the operating system spillover files in each database (primary or standby).
- `LAST_ARCHIVE_TIME` specifies the timestamp in `YYYY-MM-DD HH:MI:SS.FF` UTC (Coordinated Universal Time) format for `AUDIT_TRAIL_UNIFIED`, `AUDIT_TRAIL_AUD_STD`, and `AUDIT_TRAIL_FGA_STD`, and in the Local Time Zone for `AUDIT_TRAIL_OS` and `AUDIT_TRAIL_XML`. Do not enter a future system date or timestamp (for example, `SYSDATE + 1`, or a date in the future) for this value.
- `RAC_INSTANCE_NUMBER` specifies the instance number for an Oracle RAC installation. This setting is not relevant for single instance databases. If you specified the `DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD` or `DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD` audit trail types, then you can omit the `RAC_INSTANCE_NUMBER` argument. This is because there is only one `AUD$` or `FGA_LOG$` table, even for an Oracle RAC installation. The default is `NULL`. You can find the instance number for the current instance by issuing the `SHOW PARAMETER INSTANCE_NUMBER` command in SQL*Plus.
- `CONTAINER` applies the timestamp to a multitenant environment. `DBMS_AUDIT_MGMT.CONTAINER_CURRENT` specifies the current PDB; `DBMS_AUDIT_MGMT.CONTAINER_ALL` applies to all PDBs in the multitenant environment.
  Note that you can set `CONTAINER` to `DBMS_MGMT.CONTAINER_ALL` only from the root, and `DBMS_MGMT.CONTAINER_CURRENT` only from a PDB.
Typically, after you set the timestamp, you can use the `DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL` PL/SQL procedure to remove the audit records that were created before the timestamp date.
```
## Step 4: Create and Schedule the Purge Job
You can use the `DBMS_AUDIT_MGMT` PL/SQL package to create and schedule the purge job.
- Create and schedule the purge job by running the DBMS_AUDIT_MGMT.CREATE_PURGE_JOB PL/SQL procedure. For example:
```
CONNECT aud_admin@hrpdb
Enter password: password
Connected.
BEGIN
  DBMS_AUDIT_MGMT.CREATE_PURGE_JOB (
   AUDIT_TRAIL_TYPE            => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
   AUDIT_TRAIL_PURGE_INTERVAL  => 12,
   AUDIT_TRAIL_PURGE_NAME      => 'Audit_Trail_PJ',
   USE_LAST_ARCH_TIMESTAMP     => TRUE,
   CONTAINER                   => DBMS_AUDIT_MGMT.CONTAINER_CURRENT);
END;
/
```
In this example:
````
````
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD is used for the standard audit trail table, AUD$. (This setting does not apply to read-only databases.)
````
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD is used for the fine-grained audit trail table, FGA_LOG$. (This setting does not apply to read-only databases.)
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD is used for both standard and fine-grained audit trail tables. (This setting does not apply to read-only databases.)
````
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS is used for the operating system audit trail files with the .aud extension. (This setting does not apply to Windows Event Log entries.)
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML is used for the XML operating system audit trail files.
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_FILES is used for both operating system and XML audit trail files.
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL is used for all audit trail records, that is, both database audit trail and operating system audit trail types. (This setting does not apply to read-only databases.)
To purge records from the `AUDSYS.AUD$UNIFIED` table or from the operating system spillover files:
````
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_TABLE purges records from the AUDSYS.AUD$UNIFIED table.
  - DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_FILES purges records from the operating system spillover files in each database (primary or standby).
``````
- AUDIT_TRAIL_PURGE_INTERVAL specifies the hourly interval for this purge job to run. The timing begins when you run the DBMS_AUDIT_MGMT.CREATE_PURGE_JOB procedure, in this case, 12 hours after you run this procedure. Later on, if you want to update this value, run the DBMS_AUDIT_MGMT.SET_PURGE_JOB_INTERVAL procedure.
``````````````
  - TRUE deletes audit records created before the last archive timestamp. To check the last recorded timestamp, query the LAST_ARCHIVE_TS column of the DBA_AUDIT_MGMT_LAST_ARCH_TS data dictionary view for read-write databases and the DBMS_AUDIT_MGMT.GET_LAST_ARCHIVE_TIMESTAMP function for read-only databases. The default value is TRUE. Oracle recommends that you set USE_LAST_ARCH_TIMESTAMP to TRUE.
  - FALSE deletes all audit records without considering last archive timestamp. Be careful about using this setting, in case you inadvertently delete audit records that should not have been deleted.
````````
- CONTAINER is used for a multitenant environment to define where to create the purge job. If you set CONTAINER to DBMS_AUDIT_MGMT.CONTAINER_CURRENT, then it is available, visible, and managed only from the current PDB. The DBMS_AUDIT_MGMT.CONTAINER_ALL setting creates the job in the root. This defines the job as a global job, which runs according to the defined job schedule. When the job is invoked, it cleans up audit trails in all the PDBs in the multitenant environment. If you create the job in the root, then it is visible only in the root. Hence, you can enable, disable, and drop it from the root only.
## Related Topics
**- Oracle Database Administrator’s Guide for more information about tuning log files
  - Step 3: Optionally, Set an Archive Timestamp for Audit Records
  - Archiving the Audit Trail
