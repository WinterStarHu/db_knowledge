# PostgreSQL: Documentation: 18: ALTER LANGUAGE

PostgreSQL: Documentation: 18: ALTER LANGUAGE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER LANGUAGE Prev Up SQL Commands Home Next ALTER LANGUAGE ALTER LANGUAGE — change the definition of a procedural language Synopsis ALTER [ PROCEDURAL ] LANGUAGE name RENAME TO new_name ALTER [ PROCEDURAL ] LANGUAGE name OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } Description ALTER LANGUAGE changes the definition of a procedural language. The only functionality is to rename the language or assign a new owner. You must be superuser or owner of the language to use ALTER LANGUAGE.
Parameters name Name of a language new_name The new name of the language new_owner The new owner of the language Compatibility There is no ALTER LANGUAGE statement in the SQL standard.
See AlsoCREATE LANGUAGE, DROP LANGUAGE Prev Up Next ALTER INDEX Home ALTER LARGE OBJECT Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
