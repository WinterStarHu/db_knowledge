# ALL_SCHEDULER_WINDOWS

`ALL_SCHEDULER_WINDOWS` displays information about the Scheduler windows accessible to the current user.
Related View `DBA_SCHEDULER_WINDOWS` displays information about all Scheduler windows in the database.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the Scheduler window |
| WINDOW_NAME | VARCHAR2(128) | NOT NULL | Name of the Scheduler window |
| RESOURCE_PLAN | VARCHAR2(128) |  | Resource plan associated with the window |
| SCHEDULE_OWNER | VARCHAR2(4000) |  | Owner of the schedule of the window |
| SCHEDULE_NAME | VARCHAR2(4000) |  | Name of the schedule of the window |
| SCHEDULE_TYPE | VARCHAR2(8) |  | Type of the schedule of the window: ONCE - Repeat interval is NULL NAMED - Named schedule CALENDAR - Oracle calendaring expression used as schedule |
| START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Start date of the window (for an inline schedule) |
| REPEAT_INTERVAL | VARCHAR2(4000) |  | Calendar string for the window (for an inline schedule) |
| END_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Date after which the window will no longer open (for an inline schedule) |
| DURATION | INTERVAL DAY(3) TO SECOND(0) |  | Duration of the window |
| WINDOW_PRIORITY | VARCHAR2(4) |  | Priority of the job relative to other windows: HIGH LOW |
| NEXT_START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Next date on which the window is scheduled to start |
| LAST_START_DATE | TIMESTAMP(6) WITH TIME ZONE |  | Last date on which the window opened |
| ENABLED | VARCHAR2(5) |  | Indicates whether the window is enabled (TRUE) or disabled (FALSE) |
| ACTIVE | VARCHAR2(5) |  | Indicates whether the window is open (TRUE) or not (FALSE) |
| MANUAL_OPEN_TIME | TIMESTAMP(6) WITH TIME ZONE |  | Open time of the window if it was manually opened, else NULL |
| MANUAL_DURATION | INTERVAL DAY(3) TO SECOND(0) |  | Duration of the window if it was manually opened, else NULL |
| COMMENTS | VARCHAR2(4000) |  | Comments on the window |

See Also:
"DBA_SCHEDULER_WINDOWS"
