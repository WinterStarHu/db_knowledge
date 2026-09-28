# PostgreSQL: Documentation: 18: DECLARE

PostgreSQL: Documentation: 18: DECLARE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DECLARE Prev Up
34.14. Embedded SQL Commands
Home Next DECLARE DECLARE — define a cursor Synopsis DECLARE cursor_name [ BINARY ] [ ASENSITIVE | INSENSITIVE ] [ [ NO ] SCROLL ] CURSOR [ { WITH | WITHOUT } HOLD ] FOR prepared_name DECLARE cursor_name [ BINARY ] [ ASENSITIVE | INSENSITIVE ] [ [ NO ] SCROLL ] CURSOR [ { WITH | WITHOUT } HOLD ] FOR query Description DECLARE declares a cursor for iterating over the result set of a prepared statement. This command has slightly different semantics from the direct SQL command DECLARE: Whereas the latter executes a query and prepares the result set for retrieval, this embedded SQL command merely declares a name as a “loop variable” for iterating over the result set of a query; the actual execution happens when the cursor is opened with the OPEN command.
Parameters cursor_name # A cursor name, case sensitive. This can be an SQL identifier or a host variable.
prepared_name # The name of a prepared query, either as an SQL identifier or a host variable.
query # A SELECT or VALUES command which will provide the rows to be returned by the cursor.
For the meaning of the cursor options, see DECLARE.
Examples Examples declaring a cursor for a query:
EXEC SQL DECLARE C CURSOR FOR SELECT * FROM My_Table;
EXEC SQL DECLARE C CURSOR FOR SELECT Item1 FROM T;
EXEC SQL DECLARE cur1 CURSOR FOR SELECT version();
An example declaring a cursor for a prepared statement:
EXEC SQL PREPARE stmt1 AS SELECT version();
EXEC SQL DECLARE cur1 CURSOR FOR stmt1;
Compatibility DECLARE is specified in the SQL standard.
See AlsoOPEN, CLOSE, DECLARE Prev Up Next DEALLOCATE DESCRIPTOR Home DECLARE STATEMENT Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
