# PostgreSQL: Documentation: 18: F.47. tsm_system_time — the SYSTEM_TIME sampling method for TABLESAMPLE

PostgreSQL: Documentation: 18: F.47. tsm_system_time — the SYSTEM_TIME sampling method for TABLESAMPLE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
F.47. tsm_system_time — the SYSTEM_TIME sampling method for TABLESAMPLE Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.47. tsm_system_time — the SYSTEM_TIME sampling method for TABLESAMPLE # F.47.1. Examples The tsm_system_time module provides the table sampling method SYSTEM_TIME, which can be used in the TABLESAMPLE clause of a SELECT command.
This table sampling method accepts a single floating-point argument that is the maximum number of milliseconds to spend reading the table. This gives you direct control over how long the query takes, at the price that the size of the sample becomes hard to predict. The resulting sample will contain as many rows as could be read in the specified time, unless the whole table has been read first.
Like the built-in SYSTEM sampling method, SYSTEM_TIME performs block-level sampling, so that the sample is not completely random but may be subject to clustering effects, especially if only a small number of rows are selected.
SYSTEM_TIME does not support the REPEATABLE clause.
This module is considered “trusted”, that is, it can be installed by non-superusers who have CREATE privilege on the current database.
F.47.1. Examples # Here is an example of selecting a sample of a table with SYSTEM_TIME. First install the extension:
CREATE EXTENSION tsm_system_time;
Then you can use it in a SELECT command, for instance:
SELECT * FROM my_table TABLESAMPLE SYSTEM_TIME(1000);
This command will return as large a sample of my_table as it can read in 1 second (1000 milliseconds). Of course, if the whole table can be read in under 1 second, all its rows will be returned.
Prev Up Next F.46. tsm_system_rows — the SYSTEM_ROWS sampling method for TABLESAMPLE Home F.48. unaccent — a text search dictionary which removes diacritics Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
