# PostgreSQL: Documentation: 18: OPEN

PostgreSQL: Documentation: 18: OPEN Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
OPEN Prev Up
34.14. Embedded SQL Commands
Home Next OPEN OPEN — open a dynamic cursor Synopsis OPEN cursor_name OPEN cursor_name USING value [, ... ] OPEN cursor_name USING SQL DESCRIPTOR descriptor_name Description OPEN opens a cursor and optionally binds actual values to the placeholders in the cursor's declaration. The cursor must previously have been declared with the DECLARE command. The execution of OPEN causes the query to start executing on the server.
Parameters cursor_name # The name of the cursor to be opened. This can be an SQL identifier or a host variable.
value # A value to be bound to a placeholder in the cursor. This can be an SQL constant, a host variable, or a host variable with indicator.
descriptor_name # The name of a descriptor containing values to be bound to the placeholders in the cursor. This can be an SQL identifier or a host variable.
Examples EXEC SQL OPEN a;
EXEC SQL OPEN d USING 1, 'test';
EXEC SQL OPEN c1 USING SQL DESCRIPTOR mydesc;
EXEC SQL OPEN :curname1;
Compatibility OPEN is specified in the SQL standard.
See AlsoDECLARE, CLOSE Prev Up Next GET DESCRIPTOR Home PREPARE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
