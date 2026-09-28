# ALL_SCHEDULER_JOB_LOG

`ALL_SCHEDULER_JOB_LOG` displays log information for the Scheduler jobs accessible to the current user.
Related Views
- DBA_SCHEDULER_JOB_LOG displays log information for all Scheduler jobs in the database.
- USER_SCHEDULER_JOB_LOG displays log information for the Scheduler jobs owned by the current user.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| LOG_ID | NUMBER | NOT NULL | Unique identifier that identifies a row |
| LOG_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Date of the log entry |
| OWNER | VARCHAR2(128) |  | Owner of the Scheduler job |
| JOB_NAME | VARCHAR2(261) |  | Name of the Scheduler job |
| JOB_SUBNAME | VARCHAR2(261) |  | Subname of the Scheduler job (for a chain step job) |
| JOB_CLASS | VARCHAR2(128) |  | Class that the job belonged to at the time of entry |
| OPERATION | VARCHAR2(30) |  | Operation corresponding to the log entry |
| STATUS | VARCHAR2(30) |  | Status of the operation, if applicable. Possible values for this column are dependent on the value in the OPERATION column. In most cases, STATUS will be NULL. Only for job run operations will it have a value. STATUS will be NULL when OPERATION is one of the following: CREATE - Job was created UPDATE - One or more job attributes have been modified ENABLE - Job has been enabled DISABLE - Job has been disabled COMPLETED - For repeating jobs only, job has reached its end date or maximum number of runs BROKEN - Job has reached its maximum number of failures STATUS can be SUCCEEDED (job run completed successfully), FAILED (job run failed), or STOPPED (job run was stopped) when OPERATION is one of the following: RUN - Regular job run RETRY_RUN - Job is being retried because the previous run resulted in an error and RESTARTABLE is set to TRUE RECOVERY_RUN - Job is being rerun because the database went down, or the job worker process crashed and RESTARTABLE is set to TRUE |
| USER_NAME | VARCHAR2(128) |  | Name of the user who performed the operation, if applicable |
| CLIENT_ID | VARCHAR2(64) |  | Client identifier of the user who performed the operation, if applicable |
| GLOBAL_UID | VARCHAR2(32) |  | Global user identifier of the user who performed the operation, if applicable |
| CREDENTIAL_OWNER | VARCHAR2(261) |  | Owner of the credential used for this remote job run |
| CREDENTIAL_NAME | VARCHAR2(261) |  | Name of the credential used for this remote job run |
| DESTINATION_OWNER | VARCHAR2(261) |  | Owner of the destination object used in this remote job run; NULL if no object used |
| DESTINATION | VARCHAR2(261) |  | Destination for a remote job operation |
| ADDITIONAL_INFO | CLOB |  | Additional information on the entry, if applicable |

See Also:
- "DBA_SCHEDULER_JOB_LOG"
- "USER_SCHEDULER_JOB_LOG"
