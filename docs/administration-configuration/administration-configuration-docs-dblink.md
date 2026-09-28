# PostgreSQL: Documentation: 18: F.11. dblink — connect to other PostgreSQL databases

PostgreSQL: Documentation: 18: F.11. dblink — connect to other PostgreSQL databases Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
F.11. dblink — connect to other PostgreSQL databases Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.11. dblink — connect to other PostgreSQL databases # dblink_connect — opens a persistent connection to a remote database dblink_connect_u — opens a persistent connection to a remote database, insecurely dblink_disconnect — closes a persistent connection to a remote database dblink — executes a query in a remote database dblink_exec — executes a command in a remote database dblink_open — opens a cursor in a remote database dblink_fetch — returns rows from an open cursor in a remote database dblink_close — closes a cursor in a remote database dblink_get_connections — returns the names of all open named dblink connections dblink_error_message — gets last error message on the named connection dblink_send_query — sends an async query to a remote database dblink_is_busy — checks if connection is busy with an async query dblink_get_notify — retrieve async notifications on a connection dblink_get_result — gets an async query result dblink_cancel_query — cancels any active query on the named connection dblink_get_pkey — returns the positions and field names of a relation's primary key fields dblink_build_sql_insert — builds an INSERT statement using a local tuple, replacing the primary key field values with alternative supplied values dblink_build_sql_delete — builds a DELETE statement using supplied values for primary key field values dblink_build_sql_update — builds an UPDATE statement using a local tuple, replacing the primary key field values with alternative supplied values dblink is a module that supports connections to other PostgreSQL databases from within a database session.
dblink can report the following wait events under the wait event type Extension.
DblinkConnect Waiting to establish a connection to a remote server.
DblinkGetConnect Waiting to establish a connection to a remote server when it could not be found in the list of already-opened connections.
DblinkGetResult Waiting to receive the results of a query from a remote server.
See also postgres_fdw, which provides roughly the same functionality using a more modern and standards-compliant infrastructure.
Prev Up Next F.10. cube — a multi-dimensional cube data type Home dblink_connect Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
