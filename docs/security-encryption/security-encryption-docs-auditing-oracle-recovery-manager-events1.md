# Auditing Oracle Recovery Manager Events

You can use the `CREATE AUDIT POLICY` statement to audit Oracle Recovery Manager events.
````
- About Auditing Oracle Recovery Manager Events The UNIFIED_AUDIT_TRAIL data dictionary view automatically stores Oracle Recovery Manager audit events in the RMAN_column.
- Oracle Recovery Manager Unified Audit Trail Events The unified audit trail can capture Oracle Recovery Manager events.
- How Oracle Recovery Manager Audited Events Appear in the Audit Trail The UNIFIED_AUDIT_TRAIL data dictionary view lists Oracle Recovery Manager audit events.
## About Auditing Oracle Recovery Manager Events
The `UNIFIED_AUDIT_TRAIL` data dictionary view automatically stores Oracle Recovery Manager audit events in the `RMAN_`column.
Unlike other Oracle Database components, you do not create a unified audit policy for Oracle Recovery Manager events.
However, you must have the `AUDIT_ADMIN` or `AUDIT_VIEWER` role in order to query the `UNIFIED_AUDIT_TRAIL` view to see these events. If you have the `SYSBACKUP` or the `SYSDBA` administrative privilege, then you can find additional information about Recovery Manager jobs by querying views such as `V$RMAN_STATUS` or `V$RMAN_BACKUP_JOB_DETAILS`.
## Oracle Recovery Manager Unified Audit Trail Events
The unified audit trail can capture Oracle Recovery Manager events.
The following list describes the Oracle Recovery Manager columns in the `UNIFIED_AUDIT_TRAIL` view.
****````
- RMAN_SESSION_RECID: Recovery Manager session identifier. Together with the RMAN_SESSION_STAMP column, this column uniquely identifies the Recovery Manager job. The Recovery Manager session ID is a a RECID value in the control file that identifies the Recovery Manager job. (Note that the Recovery Manager session ID is not the same as a user session ID.)
****
- RMAN_SESSION_STAMP: Timestamp for the session. Together with the RMAN_SESSION_RECID column, this column identifies Recovery Manager jobs.
****````
- RMAN_OPERATION: The Recovery Manager operation executed by the job. One row is added for each distinct operation within a Recovery Manager session. For example, a backup job contains BACKUP as the RMAN_OPERATION value.
****
  - DB FULL (Database Full) refers to a full backup of the database.
  - RECVR AREA refers to the Fast Recovery area.
  - DB INCR (Database Incremental) refers to incremental backups of the database.
  - DATAFILE FULL refers to a full backup of the data files.
  - DATAFILE INCR refers to incremental backups of the data files.
  - ARCHIVELOG refers to archived redo log files.
  - CONTROLFILE refers to control files.
  - SPFILE refers to the server parameter file.
  - BACKUPSET refers to backup files.
****``````````
- RMAN_DEVICE_TYPE: Device associated with a Recovery Manager session. This column can be DISK, SBT (system backup tape), or * (asterisk). An asterisk indicates more than one device. In most cases, the value will be DISK and SBT.
## How Oracle Recovery Manager Audited Events Appear in the Audit Trail
The UNIFIED_AUDIT_TRAIL data dictionary view lists Oracle Recovery Manager audit events.
The Oracle Recovery Manager columns list describes the columns in the `UNIFIED_AUDIT_TRAIL` data dictionary view that you can query to find Oracle Recovery Manager-specific audit data.
For example:
```
SELECT RMAN_OPERATION FROM UNIFIED_AUDIT_TRAIL WHERE RMAN_OBJECT_TYPE = 'DB FULL';
RMAN_OPERATION
---------------
BACKUP
```
## Related Topics
  **- Oracle Database Backup and Recovery User’s Guide
