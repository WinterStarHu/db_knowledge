# Other Audit Trail Purge Operations

Other kinds of audit trail purge include enabling or disabling the audit trail purge job or setting the default audit trail purge job interval.
- Enabling or Disabling an Audit Trail Purge Job The DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS procedure enables or disables an audit trail purge job.
- Setting the Default Audit Trail Purge Job Interval for a Specified Purge Job You can set a default purge operation interval, in hours, that must pass before the next purge job operation takes place.
- Deleting an Audit Trail Purge Job You can delete existing audit trail purge jobs.
- Clearing the Archive Timestamp Setting The DBMS_AUDIT_MGMT.CLEAR_LAST_ARCHIVE_TIMESTAMP procedure can clear the archive timestamp setting.
## Enabling or Disabling an Audit Trail Purge Job
The `DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS` procedure enables or disables an audit trail purge job.
In a multitenant environment, where you run the `DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS` procedure depends on the location of the purge job, which is determined by the `CONTAINER` parameter of the `DBMS_MGMT.CREATE_PURGE_JOB` procedure. If you had set `CONTAINER` to `CONTAINER_ALL` (to create the purge job in the root), then you must run the `DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS` procedure from the root. If you had set `CONTAINER` to `CONTAINER_CURRENT`, then you must run the `DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS` procedure from the PDB in which it was created.
- To enable or disable an audit trail purge job, use the DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS PL/SQL procedure. For example, assuming that you had created the purge job in a the hrpdb PDB:
```
CONNECT aud_admin@hrpdb
Enter password: password
Connected.
BEGIN
 DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS(
  AUDIT_TRAIL_PURGE_NAME      => 'Audit_Trail_PJ',
  AUDIT_TRAIL_STATUS_VALUE    => DBMS_AUDIT_MGMT.PURGE_JOB_ENABLE);
END;
/
```
In this example:
``````````
- AUDIT_TRAIL_PURGE_NAME specifies a purge job called Audit_Trail_PJ. To find existing purge jobs, query the JOB_NAME and JOB_STATUS columns of the DBA_AUDIT_MGMT_CLEANUP_JOBS data dictionary view.
  - DBMS_AUDIT_MGMT.PURGE_JOB_ENABLE enables the specified purge job.
  - DBMS_AUDIT_MGMT.PURGE_JOB_DISABLE disables the specified purge job.
## Setting the Default Audit Trail Purge Job Interval for a Specified Purge Job
You can set a default purge operation interval, in hours, that must pass before the next purge job operation takes place.
The interval setting that is used in the `DBMS_AUDIT_MGMT.CREATE_PURGE_JOB` procedure takes precedence over this setting.
- To set the default audit trail purge job interval for a specific purge job, run the DBMS_AUDIT_MGMT.SET_PURGE_JOB_INTERVAL procedure. For example, assuming that you had created the purge job in the hrpdb PDB:
```
CONNECT aud_admin@hrpdb Enter password: password Connected.
BEGIN DBMS_AUDIT_MGMT.SET_PURGE_JOB_INTERVAL( AUDIT_TRAIL_PURGE_NAME       => 'Audit_Trail_PJ', AUDIT_TRAIL_INTERVAL_VALUE   => 24);
END;
/
```
In this example:
````````
- AUDIT_TRAIL_PURGE_NAME specifies the name of the audit trail purge job. To find a list of existing purge jobs, query the JOB_NAME and JOB_STATUS columns of the DBA_AUDIT_MGMT_CLEANUP_JOBS data dictionary view.
````````
- AUDIT_TRAIL_INTERVAL_VALUE updates the default hourly interval set by the DBMS_AUDIT_MGMT.CREATE_PURGE_JOB procedure. Enter a value between 1 and 999. The timing begins when you run the purge job.
In a multitenant environment, where you run the `DBMS_AUDIT_MGMT.SET_PURGE_JOB_INTERVAL` procedure depends on the location of the purge job, which is determined by the `CONTAINER` parameter of the `DBMS_MGMT.CREATE_PURGE_JOB` procedure. If you had set `CONTAINER` to `CONTAINER_ALL`, then the purge job exists in the root, so you must run the `DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS` procedure from the root. If you had set `CONTAINER` to `CONTAINER_CURRENT`, then you must run the `DBMS_AUDIT_MGMT.SET_PURGE_JOB_INTERVAL` procedure from the PDB in which it was created.
## Deleting an Audit Trail Purge Job
You can delete existing audit trail purge jobs.
To find existing purge jobs, query the `JOB_NAME` and `JOB_STATUS` columns of the `DBA_AUDIT_MGMT_CLEANUP_JOBS` data dictionary view.
  - To delete an audit trail purge job, use the DBMS_AUDIT_MGMT.DROP_PURGE_JOB PL/SQL procedure.
For example, assuming that you had created the purge job in the `hrpdb` PDB:
```
CONNECT aud_admin@hrpdb Enter password: password Connected.
BEGIN DBMS_AUDIT_MGMT.DROP_PURGE_JOB( AUDIT_TRAIL_PURGE_NAME  => 'Audit_Trail_PJ');
END;
/
```
In a multitenant environment, where you run the `DBMS_AUDIT_MGMT.DROP_PURGE_JOB` procedure depends on the location of the purge job, which is determined by the `CONTAINER` parameter of the `DBMS_MGMT.CREATE_PURGE_JOB` procedure. If you had set `CONTAINER` to `CONTAINER_ALL`, then the purge job exists in the root, so you must run the `DBMS_AUDIT_MGMT.SET_PURGE_JOB_STATUS` procedure from the root. If you had set `CONTAINER` to `CONTAINER_CURRENT`, then you must run the `DBMS_AUDIT_MGMT.DROP_PURGE_JOB_INTERVAL` procedure from the PDB in which it was created.
## Clearing the Archive Timestamp Setting
The `DBMS_AUDIT_MGMT.CLEAR_LAST_ARCHIVE_TIMESTAMP` procedure can clear the archive timestamp setting.
To find a history of audit trail log cleanup, you can query the `UNIFIED_AUDIT_TRAIL` data dictionary view, using the following criteria: `OBJECT_NAME` is `DBMS_AUDIT_MGMT`, `OBJECT_SCHEMA` is `SYS`, and `SQL_TEXT` is set to `LIKE %DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL%`.
- To clear the archive timestamp setting, use the DBMS_AUDIT_MGMT.CLEAR_LAST_ARCHIVE_TIMESTAMP PL/SQL procedure to specify the audit trail type and for a multitenant environment, the container type. For example, assuming that you had created the purge job in the hrpdb PDB:
```
CONNECT aud_admin@hrpdb Enter password: password Connected.
BEGIN DBMS_AUDIT_MGMT.CLEAR_LAST_ARCHIVE_TIMESTAMP( AUDIT_TRAIL_TYPE     =>  DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED, CONTAINER            =>  DBMS_AUDIT_MGMT.CONTAINER_CURRENT);
END;
/
```
In this example:
``````````````````
``````
- AUDIT_TRAIL_TYPE is set for the unified audit trail. If the AUDIT_TRAIL_TYPE property is set to DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS or DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML, then you cannot set RAC_INSTANCE_NUMBER to 0. You can omit the RAC_INSTANCE_NUMBER setting if you set AUDIT_TRAIL_TYPE to DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED. You can clear the archive timestamps from the AUDSYS.AUD$UNIFIED table by setting DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_TABLE. To clear the archive timestamps from the operating system spillover files in each database (primary or standby), set DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED_FILES.
``````
- CONTAINER applies the timestamp to a multitenant environment. DBMS_AUDIT_MGMT.CONTAINER_CURRENT specifies the local PDB; DBMS_AUDIT_MGMT.CONTAINER_ALL applies to all databases.
