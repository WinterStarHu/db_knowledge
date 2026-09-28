# PostgreSQL: Documentation: 18: dblink_is_busy

PostgreSQL: Documentation: 18: dblink_is_busy Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_is_busy Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_is_busy dblink_is_busy — checks if connection is busy with an async query Synopsis dblink_is_busy(text connname) returns int Description dblink_is_busy tests whether an async query is in progress.
Arguments connname Name of the connection to check.
Return Value Returns 1 if connection is busy, 0 if it is not busy. If this function returns 0, it is guaranteed that dblink_get_result will not block.
Examples SELECT dblink_is_busy('dtest1');
Prev Up Next dblink_send_query Home dblink_get_notify Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
