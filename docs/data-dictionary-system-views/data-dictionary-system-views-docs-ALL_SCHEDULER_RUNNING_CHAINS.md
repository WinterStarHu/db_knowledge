# ALL_SCHEDULER_RUNNING_CHAINS

`ALL_SCHEDULER_RUNNING_CHAINS` displays information about the chain steps of the running chains accessible to the current user (that is, those chains that the user has `ALTER` privileges for). In the case of nested chains, this view also enables you to traverse the hierarchy of the chain with a SQL statement that contains a `CONNECT BY` clause linking up the `JOB_SUBNAME` and `STEP_JOB_SUBNAME` columns.
Related Views
- DBA_SCHEDULER_RUNNING_CHAINS displays information about the chain steps of all running chains in the database.

- USER_SCHEDULER_RUNNING_CHAINS displays information about the chain steps of the running chains owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the job which is running the chain |
| JOB_NAME | VARCHAR2(128) | NOT NULL | Name of the job which is running the chain |
| JOB_SUBNAME | VARCHAR2(128) |  | Subname of the job which is running the chain (for a nested chain), else NULL |
| CHAIN_OWNER | VARCHAR2(128) | NOT NULL | Owner of the chain being run |
| CHAIN_NAME | VARCHAR2(128) | NOT NULL | Name of the chain being run |
| STEP_NAME | VARCHAR2(128) | NOT NULL | Name of the step of the running chain |
| STATE | VARCHAR2(15) |  | State of the running chain step: NOT_STARTED RUNNING SUCCEEDED STOPPED FAILED SCHEDULED RETRY SCHEDULED PAUSED STALLED |
| ERROR_CODE | NUMBER |  | Error code with which the step completed (if it has completed) |
| COMPLETED | VARCHAR2(5) |  | Indicates whether the running chain step has completed (TRUE) or not (FALSE) |
| START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Date when the running chain step started (if it has started) |
| END_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Date when the running chain step stopped (if it has stopped) |
| DURATION | INTERVAL DAY(9) TO SECOND(6) |  | Amount of time it took the chain step to complete (if it has completed) |
| SKIP | VARCHAR2(5) |  | Indicates whether the chain step should be skipped (TRUE) or not (FALSE) |
| PAUSE | VARCHAR2(5) |  | Indicates whether the chain step should be paused after running (TRUE) or not (FALSE) |
| PAUSE_BEFORE | VARCHAR2(5) |  | Indicates whether the chain step should be paused before running (TRUE) or not (FALSE) |
| RESTART_ON_RECOVERY | VARCHAR2(5) |  | Indicates whether the chain step will be restarted on database recovery (TRUE) or not (FALSE) |
| RESTART_ON_FAILURE | VARCHAR2(5) |  | Indicates whether the chain step will be restarted on application failure (TRUE) or not (FALSE) |
| STEP_JOB_SUBNAME | VARCHAR2(128) |  | Subname of the job running the step |
| STEP_JOB_LOG_ID | NUMBER |  | Log ID of the job running the step |

See Also:
- "DBA_SCHEDULER_RUNNING_CHAINS"
- "USER_SCHEDULER_RUNNING_CHAINS"
