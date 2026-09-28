# PostgreSQL: Documentation: 18: WHENEVER

PostgreSQL: Documentation: 18: WHENEVER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
WHENEVER Prev Up
34.14. Embedded SQL Commands
Home Next WHENEVER WHENEVER — specify the action to be taken when an SQL statement causes a specific class condition to be raised Synopsis WHENEVER { NOT FOUND | SQLERROR | SQLWARNING } action Description Define a behavior which is called on the special cases (Rows not found, SQL warnings or errors) in the result of SQL execution.
Parameters See Section 34.8.1 for a description of the parameters.
Examples EXEC SQL WHENEVER NOT FOUND CONTINUE;
EXEC SQL WHENEVER NOT FOUND DO BREAK;
EXEC SQL WHENEVER NOT FOUND DO CONTINUE;
EXEC SQL WHENEVER SQLWARNING SQLPRINT;
EXEC SQL WHENEVER SQLWARNING DO warn();
EXEC SQL WHENEVER SQLERROR sqlprint;
EXEC SQL WHENEVER SQLERROR CALL print2();
EXEC SQL WHENEVER SQLERROR DO handle_error("select");
EXEC SQL WHENEVER SQLERROR DO sqlnotice(NULL, NONO);
EXEC SQL WHENEVER SQLERROR DO sqlprint();
EXEC SQL WHENEVER SQLERROR GOTO error_label;
EXEC SQL WHENEVER SQLERROR STOP;
A typical application is the use of WHENEVER NOT FOUND BREAK to handle looping through result sets:
int main(void) { EXEC SQL CONNECT TO testdb AS con1;
EXEC SQL SELECT pg_catalog.set_config('search_path', '', false); EXEC SQL COMMIT;
EXEC SQL ALLOCATE DESCRIPTOR d;
EXEC SQL DECLARE cur CURSOR FOR SELECT current_database(), 'hoge', 256;
EXEC SQL OPEN cur;
/* when end of result set reached, break out of while loop */ EXEC SQL WHENEVER NOT FOUND DO BREAK;
while (1) { EXEC SQL FETCH NEXT FROM cur INTO SQL DESCRIPTOR d;
...
} EXEC SQL CLOSE cur;
EXEC SQL COMMIT;
EXEC SQL DEALLOCATE DESCRIPTOR d;
EXEC SQL DISCONNECT ALL;
return 0;
} Compatibility WHENEVER is specified in the SQL standard, but most of the actions are PostgreSQL extensions.
Prev Up Next VAR Home
34.15. Informix Compatibility Mode
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
