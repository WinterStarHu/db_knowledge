# Purging Audit Trail Records

The `DBMS_AUDIT_MGMT` PL/SQL package can schedule automatic purge jobs, manually purge audit records, and perform other audit trail operations.
- About Purging Audit Trail Records You can use a variety of ways to purge audit trail records.
- Selecting an Audit Trail Purge Method You can perform the purge on a regularly scheduled basis or at a specified times.
- Scheduling an Automatic Purge Job for the Audit Trail Scheduling an automatic purge job requires planning beforehand, such as tuning the online and archive redo log sizes.
- Manually Purging the Audit Trail You can use the DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL procedure to manually purge the audit trail.
- Other Audit Trail Purge Operations Other kinds of audit trail purge include enabling or disabling the audit trail purge job or setting the default audit trail purge job interval.
- Example: Directly Calling a Unified Audit Trail Purge Operation You can create a customized archive procedure to directly call a unified audit trail purge operation.
- Purge CLI Records in Databases Upgraded from Oracle Database 12.1 or Earlier In Oracle Database 12c release 12.1, the unified audit records used to reside in the common logging infrastructure (CLI) SGA back-end tables.
## Related Topics
  - Managing the Unified Audit Trail
