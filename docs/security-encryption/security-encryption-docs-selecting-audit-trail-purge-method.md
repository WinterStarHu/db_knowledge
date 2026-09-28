# Selecting an Audit Trail Purge Method

You can perform the purge on a regularly scheduled basis or at a specified times.
- Purging the Audit Trail on a Regularly Scheduled Basis You can purge all audit records, or audit records that were created before a specified timestamp, on a regularly scheduled basis.
- Manually Purging the Audit Trail at a Specific Time You can manually purge the audit records right away in a one-time operation, rather than creating a purge schedule.
## Purging the Audit Trail on a Regularly Scheduled Basis
You can purge all audit records, or audit records that were created before a specified timestamp, on a regularly scheduled basis.
For example, you can schedule the purge for every Saturday at 2 a.m.
- If necessary, tune online and archive redo log sizes to accommodate the additional records generated during the audit table purge process.
- Plan a timestamp and archive strategy.
- Optionally, set an archive timestamp for the audit records.
- Create and schedule the purge job.
## Manually Purging the Audit Trail at a Specific Time
You can manually purge the audit records right away in a one-time operation, rather than creating a purge schedule.
- If necessary, tune online and archive redo log sizes to accommodate the additional records generated during the audit table purge process.
- Plan a timestamp and archive strategy.
- Optionally, set an archive timestamp for the audit records.
- Run the purge operation.
## Related Topics
  - Scheduling an Automatic Purge Job for the Audit Trail
  - Manually Purging the Audit Trail
