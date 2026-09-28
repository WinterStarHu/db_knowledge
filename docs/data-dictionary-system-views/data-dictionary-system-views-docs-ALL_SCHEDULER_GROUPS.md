# ALL_SCHEDULER_GROUPS

`ALL_SCHEDULER_GROUPS` displays information about the Scheduler object groups accessible to the current user.
Related Views
- DBA_SCHEDULER_GROUPS displays information about all Scheduler object groups in the database.

- USER_SCHEDULER_GROUPS displays information about the Scheduler object groups owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the group |
| GROUP_NAME | VARCHAR2(128) | NOT NULL | Name of the group |
| GROUP_TYPE | VARCHAR2(13) |  | Type of object contained in the group: WINDOW JOB DB_DEST EXTERNAL_DEST |
| ENABLED | VARCHAR2(5) |  | Indicates whether the group is enabled (TRUE) or disabled (FALSE) |
| NUMBER_OF_MEMBERS | NUMBER |  | Number of members in this group |
| COMMENTS | VARCHAR2(4000) |  | An optional comment about this group |

See Also:
- "DBA_SCHEDULER_GROUPS"
- "USER_SCHEDULER_GROUPS"
