# Audit Trail Management Data Dictionary Views

Oracle Database provides data dictionary views that list information about audit trail management settings.
The following list describes these views.
````
```
DELETE FROM DBA_AUDIT_MGMT_CLEAN_EVENTS;
```
``````````````
- DBA_AUDIT_MGMT_CLEAN_EVENTS: Displays the history of purge events of the traditional (that is, non-unified) audit trails. Periodically, as a user who has been granted the AUDIT_ADMIN role, you should delete the contents of this view so that it does not grow too large. For example: This view applies to read-write databases only. For read-only databases, a history of purge events is in the alert log. For unified auditing, you can find a history of purged events by querying the UNIFIED_AUDIT_TRAIL data dictionary view, using the following criteria: OBJECT_NAME is DBMS_AUDIT_MGMT, OBJECT_SCHEMA is SYS, and SQL_TEXT is set to LIKE %DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL%.
- DBA_AUDIT_MGMT_CLEANUP_JOBS: Displays the currently configured audit trail purge jobs.
````
- DBA_AUDIT_MGMT_CONFIG_PARAMS: Displays the currently configured audit trail properties that are used by the DBMS_AUDIT_MGMT PL/SQL package.
- DBA_AUDIT_MGMT_LAST_ARCH_TS: Displays the last archive timestamps that have set for audit trail purges.
## Related Topics
  **- Oracle Database Reference
