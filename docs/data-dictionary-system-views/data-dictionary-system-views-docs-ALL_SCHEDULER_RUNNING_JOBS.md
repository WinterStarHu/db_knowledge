# ALL_SCHEDULER_RUNNING_JOBS

`ALL_SCHEDULER_RUNNING_JOBS` displays information about the running Scheduler jobs accessible to the current user.
Related Views
- DBA_SCHEDULER_RUNNING_JOBS displays information about all running Scheduler jobs in the database.

- USER_SCHEDULER_RUNNING_JOBS displays information about the running Scheduler jobs owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) |  | Owner of the running Scheduler job |
| JOB_NAME | VARCHAR2(128) |  | Name of the running Scheduler job |
| JOB_SUBNAME | VARCHAR2(128) |  | Subname of the running Scheduler job (for a job running a chain step) |
| JOB_STYLE | VARCHAR2(17) |  | Job style: REGULAR LIGHTWEIGHT IN_MEMORY_RUNTIME IN_MEMORY_FULL |
| DETACHED | VARCHAR2(5) |  | Indicates whether the detached attribute is set for the job (TRUE) or not (FALSE). If the detached attribute is set, then the job will remain running even after the job action has completed. |
| SESSION_ID | NUMBER |  | Identifier of the session running the Scheduler job |
| SLAVE_PROCESS_ID | NUMBER |  | Process number of the worker process running the Scheduler job |
| SLAVE_OS_PROCESS_ID | VARCHAR2(12) |  | Process number of the operating system worker process running the scheduler job |
| RUNNING_INSTANCE | NUMBER |  | Database instance number of the worker process running the Scheduler job |
| RESOURCE_CONSUMER_GROUP | VARCHAR2(32) |  | Resource consumer group of the session in which the Scheduler job is running |
| ELAPSED_TIME | INTERVAL DAY(3) TO SECOND(2) |  | Elapsed time since the Scheduler job was started |
| CPU_USED | INTERVAL DAY(3) TO SECOND(2) |  | CPU time consumed by the running Scheduler job, if available |
| DESTINATION_OWNER | VARCHAR2(261) |  | Owner of the destination object (if used), else NULL |
| DESTINATION | VARCHAR2(261) |  | Destination that this job is running on |
| CREDENTIAL_OWNER | VARCHAR2(128) |  | Owner of the login credential used for this running job, if any |
| CREDENTIAL_NAME | VARCHAR2(128) |  | Name of the login credential used for this running job, if any |
| LOG_ID | NUMBER |  | Log ID used for this running job. This column maps to the LOG_ID column of the *_SCHEDULER_JOB_LOG and *_SCHEDULER_JOB_RUN_DETAILS views. |

See Also:
- "DBA_SCHEDULER_RUNNING_JOBS"
- "USER_SCHEDULER_RUNNING_JOBS"
