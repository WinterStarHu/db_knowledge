# ALL_SCHEDULER_GROUP_MEMBERS

`ALL_SCHEDULER_GROUP_MEMBERS` displays information about the members of the Scheduler object groups accessible to the current user.
Related Views
- DBA_SCHEDULER_GROUP_MEMBERS displays information about the members of all Scheduler object groups in the database.

- USER_SCHEDULER_GROUP_MEMBERS displays information about the members of the Scheduler object groups owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the group |
| GROUP_NAME | VARCHAR2(128) | NOT NULL | Name of the group |
| MEMBER_NAME | VARCHAR2(523) |  | Name of the member of this group |

See Also:
- "DBA_SCHEDULER_GROUP_MEMBERS"
- "USER_SCHEDULER_GROUP_MEMBERS"
