# ALL_SCHEDULER_GLOBAL_ATTRIBUTE

`ALL_SCHEDULER_GLOBAL_ATTRIBUTE` displays the values of all scheduler attributes (for example, `DEFAULT_TIMEZONE` and `CURRENT_OPEN_WINDOW`).
Related View `DBA_SCHEDULER_GLOBAL_ATTRIBUTE` displays the values of all scheduler attributes in the database.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| ATTRIBUTE_NAME | VARCHAR2(128) | NOT NULL | Name of the Scheduler attribute |
| VALUE | VARCHAR2(256) |  | Value of the Scheduler attribute |

See Also:
"DBA_SCHEDULER_GLOBAL_ATTRIBUTE"
