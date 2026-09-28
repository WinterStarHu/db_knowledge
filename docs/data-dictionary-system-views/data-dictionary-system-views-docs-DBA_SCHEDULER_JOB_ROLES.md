# DBA_SCHEDULER_JOB_ROLES

`DBA_SCHEDULER_JOB_ROLES` displays information about all Scheduler jobs in the database by database role.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the Scheduler job |
| JOB_NAME | VARCHAR2(128) | NOT NULL | Name of the Scheduler job |
| JOB_SUBNAME | VARCHAR2(128) |  | Subname of the Scheduler job (for a job running a chain step) |
| JOB_CREATOR | VARCHAR2(128) |  | Creator of the Scheduler job |
| DATABASE_ROLE | VARCHAR2(16) |  | Name of the database role |
| PROGRAM_OWNER | VARCHAR2(4000) |  | Owner of the program associated with the job |
| PROGRAM_NAME | VARCHAR2(4000) |  | Name of the program associated with the job |
| JOB_TYPE | VARCHAR2(16) |  | Inline job action type: PLSQL_BLOCK STORED_PROCEDURE EXECUTABLE CHAIN |
| JOB_ACTION | VARCHAR2(4000) |  | Inline job action |
| JOB_CLASS | VARCHAR2(128) |  | Name of the job class associated with the job |
| SCHEDULE_OWNER | VARCHAR2(4000) |  | Owner of the schedule that the job uses (can be a window or a window group) |
| SCHEDULE_NAME | VARCHAR2(4000) |  | Name of the schedule that the job uses (can be a window or a window group) |
| SCHEDULE_TYPE | VARCHAR2(12) |  | Type of the schedule that the job uses: IMMEDIATE - Start date and repeat interval are NULL ONCE - Repeat interval is NULL PLSQL - PL/SQL expression used as schedule CALENDAR - Oracle calendaring expression used as schedule EVENT - Event schedule NAMED - Named schedule WINDOW - Window used as schedule WINDOW_GROUP - Window group used as schedule |
| START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Original scheduled start date of the job (for an inline schedule) |
| REPEAT_INTERVAL | VARCHAR2(4000) |  | Inline schedule PL/SQL expression or calendar string |
| END_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Date after which the job will no longer run (for an inline schedule) |
| LAST_START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Last date on which the job ran |
| ENABLED | VARCHAR2(5) |  | Indicates whether the job is enabled (TRUE) or disabled (FALSE) |
| STATE | VARCHAR2(15) |  | Current state of the job: DISABLED RETRY SCHEDULED SCHEDULED RUNNING COMPLETED BROKEN FAILED REMOTE SUCCEEDED CHAIN_STALLED |
| COMMENTS | VARCHAR2(4000) |  | Comments on the job |
