# ALL_SCHEDULER_WINGROUP_MEMBERS

`ALL_SCHEDULER_WINGROUP_MEMBERS` displays the members of the Scheduler window groups accessible to the current user.
Related View `DBA_SCHEDULER_WINGROUP_MEMBERS` displays the members of all Scheduler window groups in the database.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| WINDOW_GROUP_NAME | VARCHAR2(128) | NOT NULL | Name of the window group |
| WINDOW_NAME | VARCHAR2(128) | NOT NULL | Name of the window member of the window group |

See Also:
"DBA_SCHEDULER_WINGROUP_MEMBERS"
