# PostgreSQL: Documentation: 18: dblink_send_query

PostgreSQL: Documentation: 18: dblink_send_query Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_send_query Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_send_query dblink_send_query — sends an async query to a remote database Synopsis dblink_send_query(text connname, text sql) returns int Description dblink_send_query sends a query to be executed asynchronously, that is, without immediately waiting for the result. There must not be an async query already in progress on the connection.
After successfully dispatching an async query, completion status can be checked with dblink_is_busy, and the results are ultimately collected with dblink_get_result. It is also possible to attempt to cancel an active async query using dblink_cancel_query.
Arguments connname Name of the connection to use.
sql The SQL statement that you wish to execute in the remote database, for example select * from pg_class.
Return Value Returns 1 if the query was successfully dispatched, 0 otherwise.
Examples SELECT dblink_send_query('dtest1', 'SELECT * FROM foo WHERE f1 < 3');
Prev Up Next dblink_error_message Home dblink_is_busy Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
