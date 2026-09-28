# PostgreSQL: Documentation: 18: dblink_get_notify

PostgreSQL: Documentation: 18: dblink_get_notify Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_get_notify Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_get_notify dblink_get_notify — retrieve async notifications on a connection Synopsis dblink_get_notify() returns setof (notify_name text, be_pid int, extra text) dblink_get_notify(text connname) returns setof (notify_name text, be_pid int, extra text) Description dblink_get_notify retrieves notifications on either the unnamed connection, or on a named connection if specified. To receive notifications via dblink, LISTEN must first be issued, using dblink_exec. For details see LISTEN and NOTIFY.
Arguments connname The name of a named connection to get notifications on.
Return Value Returns setof (notify_name text, be_pid int, extra text), or an empty set if none.
Examples SELECT dblink_exec('LISTEN virtual');
dblink_exec
-------------
LISTEN (1 row) SELECT * FROM dblink_get_notify();
notify_name | be_pid | extra
-------------+--------+-------
(0 rows) NOTIFY virtual;
NOTIFY SELECT * FROM dblink_get_notify();
notify_name | be_pid | extra
-------------+--------+-------
virtual     |   1229 | (1 row) Prev Up Next dblink_is_busy Home dblink_get_result Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
