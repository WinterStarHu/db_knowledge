# PostgreSQL: Documentation: 18: 34.14. Embedded SQL Commands

PostgreSQL: Documentation: 18: 34.14. Embedded SQL Commands Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
34.14. Embedded SQL Commands
Prev Up Chapter 34. ECPG — Embedded SQL in C Home Next
34.14. Embedded SQL Commands #
ALLOCATE DESCRIPTOR — allocate an SQL descriptor area CONNECT — establish a database connection DEALLOCATE DESCRIPTOR — deallocate an SQL descriptor area DECLARE — define a cursor DECLARE STATEMENT — declare SQL statement identifier DESCRIBE — obtain information about a prepared statement or result set DISCONNECT — terminate a database connection EXECUTE IMMEDIATE — dynamically prepare and execute a statement GET DESCRIPTOR — get information from an SQL descriptor area OPEN — open a dynamic cursor PREPARE — prepare a statement for execution SET AUTOCOMMIT — set the autocommit behavior of the current session SET CONNECTION — select a database connection SET DESCRIPTOR — set information in an SQL descriptor area TYPE — define a new data type VAR — define a variable WHENEVER — specify the action to be taken when an SQL statement causes a specific class condition to be raised This section describes all SQL commands that are specific to embedded SQL. Also refer to the SQL commands listed in SQL Commands, which can also be used in embedded SQL, unless stated otherwise.
Prev Up Next
34.13. C++ Applications
Home ALLOCATE DESCRIPTOR Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
