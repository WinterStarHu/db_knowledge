# ALL_SCHEDULER_FILE_WATCHERS

`ALL_SCHEDULER_FILE_WATCHERS` displays information about the Scheduler file watch requests accessible to the current user.
Related Views
- DBA_SCHEDULER_FILE_WATCHERS displays information about all Scheduler file watch requests in the database.

- USER_SCHEDULER_FILE_WATCHERS displays information about the Scheduler file watch requests owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the file watch request |
| FILE_WATCHER_NAME | VARCHAR2(128) | NOT NULL | Name of the file watch request |
| ENABLED | VARCHAR2(5) |  | Indicates whether this file watch request is enabled (TRUE) or disabled (FALSE) |
| DESTINATION_OWNER | VARCHAR2(261) |  | Owner of the named destination object |
| DESTINATION | VARCHAR2(261) |  | Name of the destination object |
| DIRECTORY_PATH | VARCHAR2(4000) | NOT NULL | Name of the directory path where the file will arrive |
| FILE_NAME | VARCHAR2(512) | NOT NULL | Name or pattern specifying the files that need to be monitored |
| CREDENTIAL_OWNER | VARCHAR2(128) |  | Owner of the credential that should be used to authorize the file watch |
| CREDENTIAL_NAME | VARCHAR2(128) |  | Name of the credential that should be used to authorize the file watch |
| MIN_FILE_SIZE | NUMBER | NOT NULL | Minimum size of the file being monitored |
| STEADY_STATE_DURATION | INTERVAL DAY(3) TO SECOND(0) |  | Time to wait before concluding that the file has stopped growing |
| LAST_MODIFIED_TIME | TIMESTAMP(6) WITH TIME ZONE |  | Time at which this file watcher was last modified |
| COMMENTS | VARCHAR2(4000) |  | Comments on the file watch request |

See Also:
- "DBA_SCHEDULER_FILE_WATCHERS"
- "USER_SCHEDULER_FILE_WATCHERS"
