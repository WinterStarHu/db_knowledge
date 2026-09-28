# ALL_SCHEDULER_DESTS

`ALL_SCHEDULER_DESTS` displays information about the destination objects for jobs accessible to the current user.
Related Views
- DBA_SCHEDULER_DESTS displays information about all destination objects for jobs in the database.

- USER_SCHEDULER_DESTS displays information about the destination objects for jobs owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of this destination object |
| DESTINATION_NAME | VARCHAR2(128) | NOT NULL | Name of this destination object |
| DESTINATION_TYPE | VARCHAR2(8) |  | Type of this destination object: EXTERNAL DATABASE |
| ENABLED | VARCHAR2(5) |  | Indicates whether this destination object is enabled (TRUE) or disabled (FALSE) |
| COMMENTS | VARCHAR2(4000) |  | Optional comment |

See Also:
- "DBA_SCHEDULER_DESTS"
- "USER_SCHEDULER_DESTS"
