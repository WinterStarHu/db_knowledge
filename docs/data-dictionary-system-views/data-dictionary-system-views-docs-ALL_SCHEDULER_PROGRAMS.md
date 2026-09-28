# ALL_SCHEDULER_PROGRAMS

`ALL_SCHEDULER_PROGRAMS` displays information about the Scheduler programs accessible to the current user.
Related Views
- DBA_SCHEDULER_PROGRAMS displays information about all Scheduler programs in the database.

- USER_SCHEDULER_PROGRAMS displays information about the Scheduler programs owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the Scheduler program |
| PROGRAM_NAME | VARCHAR2(128) | NOT NULL | Name of the Scheduler program |
| PROGRAM_TYPE | VARCHAR2(16) |  | Type of the program action: PLSQL_BLOCK STORED_PROCEDURE EXECUTABLE |
| PROGRAM_ACTION | VARCHAR2(4000) |  | String specifying the program action |
| NUMBER_OF_ARGUMENTS | NUMBER |  | Number of arguments accepted by the program |
| ENABLED | VARCHAR2(5) |  | Indicates whether the program is enabled (TRUE) or disabled (FALSE) |
| DETACHED | VARCHAR2(5) |  | This column is for internal use |
| SCHEDULE_LIMIT | INTERVAL DAY(3) TO SECOND(0) |  | Maximum delay in running the program after the scheduled start |
| PRIORITY | NUMBER |  | Priority of the program |
| WEIGHT | NUMBER |  | Weight of the program |
| MAX_RUNS | NUMBER |  | Maximum number of runs of any job based on this program |
| MAX_FAILURES | NUMBER |  | Maximum number of failures of any job based on this program |
| MAX_RUN_DURATION | INTERVAL DAY(3) TO SECOND(0) |  | Maximum amount of time this program can run |
| HAS_CONSTRAINTS | VARCHAR2(5) |  | Indicates whether the job (not including the program of the job) is part of a resource constraint or incompatibility (TRUE) or not (FALSE) |
| NLS_ENV | VARCHAR2(4000) |  | NLS environment in which the program was created |
| COMMENTS | VARCHAR2(4000) |  | Comments on the program |

See Also:
- "DBA_SCHEDULER_PROGRAMS"
- "USER_SCHEDULER_PROGRAMS"
