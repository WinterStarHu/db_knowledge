# PostgreSQL: Documentation: 18: DEALLOCATE DESCRIPTOR

PostgreSQL: Documentation: 18: DEALLOCATE DESCRIPTOR Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DEALLOCATE DESCRIPTOR Prev Up
34.14. Embedded SQL Commands
Home Next DEALLOCATE DESCRIPTOR DEALLOCATE DESCRIPTOR — deallocate an SQL descriptor area Synopsis DEALLOCATE DESCRIPTOR name Description DEALLOCATE DESCRIPTOR deallocates a named SQL descriptor area.
Parameters name # The name of the descriptor which is going to be deallocated. It is case sensitive. This can be an SQL identifier or a host variable.
Examples EXEC SQL DEALLOCATE DESCRIPTOR mydesc;
Compatibility DEALLOCATE DESCRIPTOR is specified in the SQL standard.
See AlsoALLOCATE DESCRIPTOR, GET DESCRIPTOR, SET DESCRIPTOR Prev Up Next CONNECT Home DECLARE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
