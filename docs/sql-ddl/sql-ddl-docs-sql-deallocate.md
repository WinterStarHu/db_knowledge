# PostgreSQL: Documentation: 18: DEALLOCATE

PostgreSQL: Documentation: 18: DEALLOCATE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
DEALLOCATE Prev Up SQL Commands Home Next DEALLOCATE DEALLOCATE — deallocate a prepared statement Synopsis DEALLOCATE [ PREPARE ] { name | ALL } Description DEALLOCATE is used to deallocate a previously prepared SQL statement. If you do not explicitly deallocate a prepared statement, it is deallocated when the session ends.
For more information on prepared statements, see PREPARE.
Parameters PREPARE This key word is ignored.
name The name of the prepared statement to deallocate.
ALL Deallocate all prepared statements.
Compatibility The SQL standard includes a DEALLOCATE statement, but it is only for use in embedded SQL.
See AlsoEXECUTE, PREPARE Prev Up Next CREATE VIEW Home DECLARE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
