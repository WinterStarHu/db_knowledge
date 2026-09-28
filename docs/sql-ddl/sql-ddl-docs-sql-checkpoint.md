# PostgreSQL: Documentation: 18: CHECKPOINT

PostgreSQL: Documentation: 18: CHECKPOINT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
CHECKPOINT Prev Up SQL Commands Home Next CHECKPOINT CHECKPOINT — force a write-ahead log checkpoint Synopsis CHECKPOINT Description A checkpoint is a point in the write-ahead log sequence at which all data files have been updated to reflect the information in the log. All data files will be flushed to disk. Refer to Section 28.5 for more details about what happens during a checkpoint.
The CHECKPOINT command forces an immediate checkpoint when the command is issued, without waiting for a regular checkpoint scheduled by the system (controlled by the settings in Section 19.5.2). CHECKPOINT is not intended for use during normal operation.
If executed during recovery, the CHECKPOINT command will force a restartpoint (see Section 28.5) rather than writing a new checkpoint.
Only superusers or users with the privileges of the pg_checkpoint role can call CHECKPOINT.
Compatibility The CHECKPOINT command is a PostgreSQL language extension.
Prev Up Next CALL Home CLOSE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
