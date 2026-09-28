# PostgreSQL: Documentation: 18: dblink_disconnect

PostgreSQL: Documentation: 18: dblink_disconnect Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_disconnect Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_disconnect dblink_disconnect — closes a persistent connection to a remote database Synopsis dblink_disconnect() returns text dblink_disconnect(text connname) returns text Description dblink_disconnect() closes a connection previously opened by dblink_connect(). The form with no arguments closes an unnamed connection.
Arguments connname The name of a named connection to be closed.
Return Value Returns status, which is always OK (since any error causes the function to throw an error instead of returning).
Examples SELECT dblink_disconnect();
dblink_disconnect
-------------------
OK (1 row) SELECT dblink_disconnect('myconn');
dblink_disconnect
-------------------
OK (1 row) Prev Up Next dblink_connect_u Home dblink Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
