# PostgreSQL: Documentation: 18: dblink_close

PostgreSQL: Documentation: 18: dblink_close Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_close Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_close dblink_close — closes a cursor in a remote database Synopsis dblink_close(text cursorname [, bool fail_on_error]) returns text dblink_close(text connname, text cursorname [, bool fail_on_error]) returns text Description dblink_close closes a cursor previously opened with dblink_open.
Arguments connname Name of the connection to use; omit this parameter to use the unnamed connection.
cursorname The name of the cursor to close.
fail_on_error If true (the default when omitted) then an error thrown on the remote side of the connection causes an error to also be thrown locally. If false, the remote error is locally reported as a NOTICE, and the function's return value is set to ERROR.
Return Value Returns status, either OK or ERROR.
Notes If dblink_open started an explicit transaction block, and this is the last remaining open cursor in this connection, dblink_close will issue the matching COMMIT.
Examples SELECT dblink_connect('dbname=postgres options=-csearch_path=');
dblink_connect
----------------
OK (1 row) SELECT dblink_open('foo', 'select proname, prosrc from pg_proc');
dblink_open
-------------
OK (1 row) SELECT dblink_close('foo');
dblink_close
--------------
OK (1 row) Prev Up Next dblink_fetch Home dblink_get_connections Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
