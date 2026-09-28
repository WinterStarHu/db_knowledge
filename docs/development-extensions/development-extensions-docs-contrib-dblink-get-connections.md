# PostgreSQL: Documentation: 18: dblink_get_connections

PostgreSQL: Documentation: 18: dblink_get_connections Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_get_connections Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_get_connections dblink_get_connections — returns the names of all open named dblink connections Synopsis dblink_get_connections() returns text[] Description dblink_get_connections returns an array of the names of all open named dblink connections.
Return Value Returns a text array of connection names, or NULL if none.
Examples SELECT dblink_get_connections();
Prev Up Next dblink_close Home dblink_error_message Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
