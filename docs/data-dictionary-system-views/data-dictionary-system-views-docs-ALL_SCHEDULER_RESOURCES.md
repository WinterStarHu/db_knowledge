# ALL_SCHEDULER_RESOURCES

`ALL_SCHEDULER_RESOURCES` displays all scheduler resource objects in the database that are accessible to the current user.
Related Views
- DBA_SCHEDULER_RESOURCES displays all scheduler resource objects in the database.

- USER_SCHEDULER_RESOURCES displays all scheduler resource objects in the database from the schema of the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the resource object |
| RESOURCE_NAME | VARCHAR2(128) | NOT NULL | Name of the resource object |
| STATUS | VARCHAR2(19) |  | Resource status for resource object. |
| RESOURCE_UNITS | NUMBER |  | Maximum number of available units for the resource object |
| UNITS_USED | NUMBER |  | Current number of resource units in use for the resource object |
| JOBS_RUNNING_COUNT | NUMBER |  | Current number of running jobs using the resource object |
| COMMENTS | VARCHAR2(256) |  | Comments for the resource object |

See Also:
- "DBA_SCHEDULER_RESOURCES"
- "USER_SCHEDULER_RESOURCES"
