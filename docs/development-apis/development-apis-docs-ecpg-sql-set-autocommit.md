# PostgreSQL: Documentation: 18: SET AUTOCOMMIT

PostgreSQL: Documentation: 18: SET AUTOCOMMIT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SET AUTOCOMMIT Prev Up
34.14. Embedded SQL Commands
Home Next SET AUTOCOMMIT SET AUTOCOMMIT — set the autocommit behavior of the current session Synopsis SET AUTOCOMMIT { = | TO } { ON | OFF } Description SET AUTOCOMMIT sets the autocommit behavior of the current database session. By default, embedded SQL programs are not in autocommit mode, so COMMIT needs to be issued explicitly when desired. This command can change the session to autocommit mode, where each individual statement is committed implicitly.
Compatibility SET AUTOCOMMIT is an extension of PostgreSQL ECPG.
Prev Up Next PREPARE Home SET CONNECTION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
