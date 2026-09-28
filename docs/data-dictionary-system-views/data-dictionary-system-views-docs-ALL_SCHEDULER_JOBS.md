# ALL_SCHEDULER_JOBS

`ALL_SCHEDULER_JOBS` displays information about the Scheduler jobs accessible to the current user.
Related Views
- DBA_SCHEDULER_JOBS displays information about all Scheduler jobs in the database.

- USER_SCHEDULER_JOBS displays information about the Scheduler jobs owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) |  | Owner of the Scheduler job |
| JOB_NAME | VARCHAR2(128) |  | Name of the Scheduler job |
| JOB_SUBNAME | VARCHAR2(128) |  | Subname of the Scheduler job (for a job running a chain step) |
| JOB_STYLE | VARCHAR2(17) |  | Job style: REGULAR LIGHTWEIGHT IN_MEMORY_RUNTIME IN_MEMORY_FULL |
| JOB_CREATOR | VARCHAR2(128) |  | Original creator of the job |
| CLIENT_ID | VARCHAR2(65) |  | Client identifier of the user creating the job |
| GLOBAL_UID | VARCHAR2(33) |  | Global user identifier of the user creating the job |
| PROGRAM_OWNER | VARCHAR2(4000) |  | Owner of the program associated with the job |
| PROGRAM_NAME | VARCHAR2(4000) |  | Name of the program associated with the job |
| JOB_TYPE | VARCHAR2(16) |  | Inline job action type: PLSQL_BLOCK STORED_PROCEDURE EXECUTABLE CHAIN SQL_SCRIPT BACKUP_SCRIPT EXTERNAL_SCRIPT |
| JOB_ACTION | VARCHAR2(4000) |  | Inline job action |
| NUMBER_OF_ARGUMENTS | NUMBER |  | Inline number of job arguments |
| SCHEDULE_OWNER | VARCHAR2(4000) |  | Owner of the schedule that the job uses (can be a window or a window group) |
| SCHEDULE_NAME | VARCHAR2(4000) |  | Name of the schedule that the job uses (can be a window or a window group) |
| SCHEDULE_TYPE | VARCHAR2(12) |  | Type of the schedule that the job uses: IMMEDIATE - Start date and repeat interval are NULL ONCE - Repeat interval is NULL PLSQL - PL/SQL expression used as schedule CALENDAR - Oracle calendaring expression used as schedule EVENT - Event schedule NAMED - Named schedule WINDOW - Window used as schedule WINDOW_GROUP - Window group used as schedule |
| START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Original scheduled start date of the job (for an inline schedule) |
| REPEAT_INTERVAL | VARCHAR2(4000) |  | Inline schedule PL/SQL expression or calendar string |
| EVENT_QUEUE_OWNER | VARCHAR2(128) |  | Owner of the source queue into which the event will be raised |
| EVENT_QUEUE_NAME | VARCHAR2(128) |  | Name of the source queue into which the event will be raised |
| EVENT_QUEUE_AGENT | VARCHAR2(523) |  | Name of the AQ agent used by the user on the event source queue (if it is a secure queue) |
| EVENT_CONDITION | VARCHAR2(4000) |  | Boolean expression used as the subscription rule for the event on the source queue |
| EVENT_RULE | VARCHAR2(261) |  | Name of the rule used by the coordinator to trigger the event-based job |
| FILE_WATCHER_OWNER | VARCHAR2(261) |  | Owner of the file watcher on which this job is based |
| FILE_WATCHER_NAME | VARCHAR2(261) |  | Name of the file watcher on which this job is based |
| END_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Date after which the job will no longer run (for an inline schedule) |
| JOB_CLASS | VARCHAR2(128) |  | Name of the job class associated with the job |
| ENABLED | VARCHAR2(5) |  | Indicates whether the job is enabled (TRUE) or disabled (FALSE) |
| AUTO_DROP | VARCHAR2(5) |  | Indicates whether the job will be dropped when it has completed (TRUE) or not (FALSE) |
| RESTART_ON_RECOVERY | VARCHAR2(5) |  | Indicates whether the step should be restarted on database recovery (TRUE) or not (FALSE) |
| RESTART_ON_FAILURE | VARCHAR2(5) |  | Indicates whether the step should be restarted on application failure (TRUE) or not (FALSE) |
| STATE | VARCHAR2(20) |  | Current state of the job: BLOCKED BROKEN CHAIN_STALLED COMPLETED DISABLED FAILED READY TO RUN REMOTE RESOURCE_UNAVAILABLE RETRY SCHEDULED RUNNING SCHEDULED SOME FAILED STOPPED SUCCEEDED |
| JOB_PRIORITY | NUMBER |  | Priority of the job relative to other jobs in the same class |
| RUN_COUNT | NUMBER |  | Number of times the job has run |
| UPTIME_RUN_COUNT | NUMBER |  | Number of runs since the database last restarted. For in-memory jobs, this column is populated, but the RUN_COUNT column is not populated. For all other jobs, this column is NULL. |
| MAX_RUNS | NUMBER |  | Maximum number of times the job is scheduled to run |
| FAILURE_COUNT | NUMBER |  | Number of times the job has failed to run |
| UPTIME_FAILURE_COUNT | NUMBER |  | Number of failures since the database last restarted. For in-memory jobs, this column is populated, but the FAILURE_COUNT column is not populated. For all other jobs, this column is NULL. |
| MAX_FAILURES | NUMBER |  | Number of times the job will be allowed to fail before being marked broken |
| RETRY_COUNT | NUMBER |  | Number of times the job has retried, if it is retrying |
| LAST_START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Last date on which the job started running |
| LAST_RUN_DURATION | INTERVAL DAY(9) TO SECOND(6) |  | Amount of time the job took to complete during the last run |
| NEXT_RUN_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Next date on which the job is scheduled to run |
| SCHEDULE_LIMIT | INTERVAL DAY(3) TO SECOND(0) |  | Time after which a job which has not run yet will be rescheduled |
| MAX_RUN_DURATION | INTERVAL DAY(3) TO SECOND(0) |  | Maximum amount of time for which the job will be allowed to run |
| LOGGING_LEVEL | VARCHAR2(11) |  | Amount of logging that will be done pertaining to the job: OFF RUNS FAILED RUNS FULL |
| STORE_OUTPUT | VARCHAR2(5) |  | Indicates whether all job output messages for the job are stored in the OUTPUT column of the *_JOB_RUN_DETAILS views for job runs that are logged. Possible values: TRUE: All job output messages for the job are stored in the OUTPUT column of the *_JOB_RUN_DETAILS views for job runs that are logged. This is the default for new jobs. A new job is a job created using Oracle Database 12c software. FALSE: Job output messages for the job are not stored in the OUTPUT column of the *_JOB_RUN_DETAILS views. This is the default for existing jobs. An existing job is a job created using pre-Oracle Database 12c software. |
| STOP_ON_WINDOW_CLOSE | VARCHAR2(5) |  | Indicates whether the job will stop if a window associated with the job closes (TRUE) or not (FALSE) |
| INSTANCE_STICKINESS | VARCHAR2(5) |  | Indicates whether the job is sticky (TRUE) or not (FALSE) |
| RAISE_EVENTS | VARCHAR2(4000) |  | List of job events to raise for the job: JOB_STARTED JOB_SUCCEEDED JOB_FAILED JOB_BROKEN JOB_COMPLETED JOB_STOPPED JOB_SCH_LIM_REACHED JOB_DISABLED JOB_CHAIN_STALLED JOB_OVER_MAX_DUR |
| SYSTEM | VARCHAR2(5) |  | Indicates whether the job is a system job (TRUE) or not (FALSE) |
| JOB_WEIGHT | NUMBER |  | Weight of the job |
| NLS_ENV | VARCHAR2(4000) |  | NLS environment of the job |
| SOURCE | VARCHAR2(128) |  | Source global database identifier |
| NUMBER_OF_DESTINATIONS | NUMBER |  | Number of destinations associated with this job |
| DESTINATION_OWNER | VARCHAR2(261) |  | Owner of the destination object (if used), else NULL |
| DESTINATION | VARCHAR2(261) |  | Destination that this job will run on |
| CREDENTIAL_OWNER | VARCHAR2(128) |  | Owner of the credential to be used for an external job |
| CREDENTIAL_NAME | VARCHAR2(128) |  | Name of the credential to be used for an external job |
| INSTANCE_ID | NUMBER |  | Instance on which the user requests the job to run |
| DEFERRED_DROP | VARCHAR2(5) |  | Indicates whether the job will be dropped when completed due to user request (TRUE) or not (FALSE) |
| ALLOW_RUNS_IN_RESTRICTED_MODE | VARCHAR2(5) |  | Indicates whether the job is allowed to run in restricted session mode (TRUE) or not (FALSE) |
| COMMENTS | VARCHAR2(4000) |  | Comments on the job |
| FLAGS | NUMBER |  | This column is for internal use |
| RESTARTABLE | VARCHAR2(5) |  | Indicates whether the job can be restarted (TRUE) or not (FALSE) |
| HAS_CONSTRAINTS | VARCHAR2(5) |  | Indicates whether the job (not including the program of the job) is part of a resource constraint or incompatibility (TRUE) or not (FALSE) |
| CONNECT_CREDENTIAL_OWNER | VARCHAR2(128) |  | Owner of connect credential |
| CONNECT_CREDENTIAL_NAME | VARCHAR2(128) |  | Name of connect credential |
| FAIL_ON_SCRIPT_ERROR | VARCHAR2(5) |  | Indicates whether this job fails on script error (TRUE) or not (FALSE) |

See Also:
- "DBA_SCHEDULER_JOBS"
- "USER_SCHEDULER_JOBS"
