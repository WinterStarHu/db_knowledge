# PostgreSQL: Documentation: 18: dblink_open

PostgreSQL: Documentation: 18: dblink_open Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_open Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_open dblink_open — opens a cursor in a remote database Synopsis dblink_open(text cursorname, text sql [, bool fail_on_error]) returns text dblink_open(text connname, text cursorname, text sql [, bool fail_on_error]) returns text Description dblink_open() opens a cursor in a remote database. The cursor can subsequently be manipulated with dblink_fetch() and dblink_close().
Arguments connname Name of the connection to use; omit this parameter to use the unnamed connection.
cursorname The name to assign to this cursor.
sql The SELECT statement that you wish to execute in the remote database, for example select * from pg_class.
fail_on_error If true (the default when omitted) then an error thrown on the remote side of the connection causes an error to also be thrown locally. If false, the remote error is locally reported as a NOTICE, and the function's return value is set to ERROR.
Return Value Returns status, either OK or ERROR.
Notes Since a cursor can only persist within a transaction, dblink_open starts an explicit transaction block (BEGIN) on the remote side, if the remote side was not already within a transaction. This transaction will be closed again when the matching dblink_close is executed. Note that if you use dblink_exec to change data between dblink_open and dblink_close, and then an error occurs or you use dblink_disconnect before dblink_close, your change will be lost because the transaction will be aborted.
Examples SELECT dblink_connect('dbname=postgres options=-csearch_path=');
dblink_connect
----------------
OK (1 row) SELECT dblink_open('foo', 'select proname, prosrc from pg_proc');
dblink_open
-------------
OK (1 row) Prev Up Next dblink_exec Home dblink_fetch Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
