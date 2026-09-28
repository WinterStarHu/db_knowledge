# Archiving the Audit Trail

You can archive the traditional operating system, unified database, and traditional database audit trails.
- Archiving the Traditional Operating System Audit Trail You can create an archive of the traditional operating system audit files after you have upgraded Oracle Database.
- Archiving the Unified and Traditional Database Audit Trails You should periodically archive and then purge the audit trail to prevent it from growing too large.
## Archiving the Traditional Operating System Audit Trail
You can create an archive of the traditional operating system audit files after you have upgraded Oracle Database.
To archive the traditional operating system audit trail from an upgraded database, use your platform-specific operating system tools to create an archive of the traditional operating system audit files.
****
  - Use Oracle Audit Vault and Database Firewall. You install Oracle Audit Vault and Database Firewall separately from Oracle Database.
****
  - Create tape or disk backups. You can create a compressed file of the audit files, and then store it on tapes or disks. Consult your operating system documentation for more information.
Afterwards, you should purge (delete) the traditional operating system audit records to facilitate audit trail management.
## Archiving the Unified and Traditional Database Audit Trails
You should periodically archive and then purge the audit trail to prevent it from growing too large.
Archiving and purging facilitate the purging of the database audit trail.
You can create an archive of the unified and traditional database audit trail by using Oracle Audit Vault and Database Firewall. You install Oracle Audit Vault and Database Firewall separately from Oracle Database.
After you complete the archive, you can purge the database audit trail contents.
- To archive the unified, traditional standard, and traditional fine-grained audit records, copy the relevant records to a normal database table. For example:
```
INSERT INTO table SELECT ... FROM UNIFIED_AUDIT_TRAIL ...;
INSERT INTO table SELECT ... FROM SYS.AUD$ ...;
INSERT INTO table SELECT ... FROM SYS.FGA_LOG$ ...;
```
## Related Topics
  - Moving Operating System Audit Records into the Unified Audit Trail
  - Purging Audit Trail Records
