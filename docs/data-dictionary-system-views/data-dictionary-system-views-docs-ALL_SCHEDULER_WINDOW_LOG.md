# ALL_SCHEDULER_WINDOW_LOG

`ALL_SCHEDULER_WINDOW_LOG` displays log information for the Scheduler windows accessible to the current user.
Related View `DBA_SCHEDULER_WINDOW_LOG` displays log information for all Scheduler windows in the database.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| LOG_ID | NUMBER | NOT NULL | Unique identifier of the log entry |
| LOG_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Date of the log entry |
| OWNER | VARCHAR2(128) |  | Owner of the Scheduler window |
| WINDOW_NAME | VARCHAR2(261) |  | Name of the Scheduler window |
| OPERATION | VARCHAR2(30) |  | Operation corresponding to the log entry |
| STATUS | VARCHAR2(30) |  | Status of the operation, if applicable |
| USER_NAME | VARCHAR2(128) |  | Name of the user who performed the operation, if applicable |
| CLIENT_ID | VARCHAR2(64) |  | Client identifier of the user who performed the operation, if applicable |
| GLOBAL_UID | VARCHAR2(32) |  | Global user identifier of the user who performed the operation, if applicable |
| ADDITIONAL_INFO | CLOB |  | Additional information on the entry, if applicable |

See Also:
"DBA_SCHEDULER_WINDOW_LOG"
